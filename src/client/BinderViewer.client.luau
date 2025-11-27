-- Minimal Binder viewer (client)
-- Expects RemoteFunctions in ReplicatedStorage:
--     ReplicatedStorage.BinderRemotes.GetContents : RemoteFunction
--     ReplicatedStorage.BinderRemotes.AttachDocument : RemoteFunction
-- Expects RemoteEvent:
--     ReplicatedStorage.BinderRemotes.BinderChanged : RemoteEvent

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BinderRemotes = ReplicatedStorage:WaitForChild("BinderRemotes")
local BinderEvents = ReplicatedStorage:WaitForChild("BinderEvents")

local GetContents = BinderRemotes:WaitForChild("GetContents")
local AttachDocument = BinderRemotes:WaitForChild("AttachDocument")

local BinderChanged = BinderEvents:WaitForChild("BinderChanged")
local BinderCreated = BinderEvents:WaitForChild("BinderCreated")
local CreateBinderEvent = BinderEvents:WaitForChild("CreateBinder")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Simple ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BinderViewerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "ViewerFrame"
frame.Size = UDim2.fromOffset(420, 320)
frame.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(210, 160)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 24)
title.Position = UDim2.fromOffset(8, 8)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(1, 1, 1)
title.Text = "Binder Viewer"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local pageArea = Instance.new("Frame")
pageArea.Name = "PageArea"
pageArea.Size = UDim2.fromOffset(344, 240)
pageArea.Position = UDim2.fromOffset(36, 44)
pageArea.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
pageArea.Parent = frame

local pageLabel = Instance.new("TextLabel")
pageLabel.Size = UDim2.new(1, -16, 1, -16)
pageLabel.Position = UDim2.fromOffset(0, -24)
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
pageLabel.Text = ""
pageLabel.Font = Enum.Font.SourceSans
pageLabel.TextSize = 14
pageLabel.Parent = pageArea

local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.fromOffset(28, 28)
prevBtn.Position = UDim2.fromOffset(8, 284)
prevBtn.Text = "<"
prevBtn.Parent = frame

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.fromOffset(28, 28)
nextBtn.Position = UDim2.fromOffset(384, 284)
nextBtn.Text = ">"
nextBtn.Parent = frame

local attachBtn = Instance.new("TextButton")
attachBtn.Size = UDim2.fromOffset(120, 28)
attachBtn.Position = UDim2.fromOffset(148, 284)
attachBtn.Text = "Attach Selected"
attachBtn.Parent = frame

--client state
local currentBinderID = nil
local binderState = nil
local pageIndex = 1
local selectedDoc = nil -- mock selected doc from tray

local function renderCurrentPage()
    pageArea:ClearAllChildren()
    pageLabel.Parent = pageArea

    if not binderState or #binderState.pages == 0 then
        pageLabel.Text = "No documents in binder."
        return
    end
    pageIndex = math.clamp(pageIndex, 1, #binderState.pages)
    local pageData = binderState.pages[pageIndex]

    pageLabel.Text = string.format("Page %d / %d - %s", pageIndex, #binderState.pages, pageData.type or "doc")

    -- thumbnail (placeholder)
    local thumb = Instance.new("ImageLabel")
    thumb.Size = UDim2.new(1, -8, 1, -28)
    thumb.Position = UDim2.fromOffset(4, 24)
    thumb.BackgroundColor3 = Color3.fromRGB(245, 245, 245)

    -- I don't even know what asset id this is - good luck!
    thumb.Image = pageData.thumbnail or "rbxassetid://7072727161" -- placeholder image -- assuming pageData has a thumbnail field
    thumb.Parent = pageArea

    -- Slot Markers (render simple text markers)
    if binderState.slots then
        local i = 0
        --for slotName, slotInfo in pairs(binderState.slots) do
        for slotName, docId in pairs(binderState.slots) do
            i = i + 1
            local marker = Instance.new("TextLabel")
            marker.Size = UDim2.fromOffset(120, 18)
            marker.Position = UDim2.fromOffset(8, 8 + (i - 1) * 20)
            marker.BackgroundTransparency = 0.7
            marker.TextColor3 = Color3.fromRGB(0, 0, 0)
            marker.Text = string.format("%s: %s", slotName, docId and ("attached"..docId) or "(empty)")
            marker.Parent = pageArea
        end
    end
end

local function fetchBinder(binderId)
    local success, state = pcall(function(...)  
        return GetContents:InvokeServer(binderId)
    end)
    if success then
        binderState = state
        currentBinderID = binderId
        pageIndex = 1
        renderCurrentPage()
    else
        warn("Failed to fetch binder:", state)
    end
end

prevBtn.MouseButton1Click:Connect(function()
    pageIndex = pageIndex - 1
    renderCurrentPage()
end)

nextBtn.MouseButton1Click:Connect(function()
    pageIndex = pageIndex + 1
    renderCurrentPage()
end)

attachBtn.MouseButton1Click:Connect(function()
    if not currentBinderID then return end
    if not selectedDoc then
        -- for the POC we'll mock a document to attach
        selectedDoc = { id = "DRO-0001", type = "DockingReport", thumbnail = "" }
    end
    local success, err = pcall(function()
        return AttachDocument:InvokeServer(currentBinderID, selectedDoc)
    end)
    if not success then
        warn("Failed to attach document:", err)
    end
end)

-- Server push: update binder UI when changed
BinderChanged.OnClientEvent:Connect(function(binderId, deltaOrState)
    if binderId ~= currentBinderID then return end
    -- deltaOrState may be full state or partial delta
    if type(deltaOrState) == "table" and deltaOrState.pages then
        binderState = deltaOrState
    else
        -- apply delta (simple merge for POC)
        for k, v in pairs(deltaOrState) do
            binderState[k] = v
        end
    end
    renderCurrentPage()
end)

task.defer(function()
    -- For POC, auto-fetch a test binder on load
    local binderID = "BND-0427"
    CreateBinderEvent:FireServer(binderID)
    print("Requested creation of binder with ID:", binderID)
end)

BinderCreated.OnClientEvent:Connect(function(binderId)
    fetchBinder(binderId)
end)
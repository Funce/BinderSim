-- Simple trigger to test CreateBinder remoteEvent

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BinderEvents = ReplicatedStorage:WaitForChild("BinderEvents")
local CreateBinderEvent = BinderEvents:WaitForChild("CreateBinder")

local player = Players.LocalPlayer

-- Create a test button in the player's GUI to trigger binder creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BinderTestUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Create Binder"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    local binderID = "BND-" .. tostring(math.random(1000, 9999))
    CreateBinderEvent:FireServer(binderID)
    print("Requested creation of binder with ID:", binderID)
end)
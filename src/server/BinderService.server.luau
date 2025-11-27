-- Handles binder creation and form attachment

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BinderEvents = ReplicatedStorage:WaitForChild("BinderEvents")
local Binder = require(ReplicatedStorage.Shared:WaitForChild("Binder"))

-- Store binders per player (simple table for now)
local playerBinders = {}

-- Create binder when requested
BinderEvents:WaitForChild("CreateBinder").OnServerEvent:Connect(function(player, binderID)
    local newBinder = Binder.new(binderID)
    playerBinders[player.UserId] = playerBinders[player.UserId] or {}
    table.insert(playerBinders[player.UserId], newBinder)
    print("Created binder with ID:", binderID, "for player:", player.Name)
end)

BinderEvents:WaitForChild("AttachForm").OnServerEvent:Connect(function(player, binderID, formData)
    local binders = playerBinders[player.UserId]
    if not binders then
        warn("No binders found for player:", player.Name)
        return
    end

    -- Find the binder by its ID
    for _, binder in ipairs(binders) do
        if binder.id == binderID then
            targetBinder = binder
            break
        end
    end

    if not targetBinder then
        warn("Binder ID:", binderID, "not found for player:", player.Name)
        return
    end

    -- Attach the form
    targetBinder:AttachForm(formData)
    print("Attached form", formData.formType, "to binder ID:", binderID, "for player:", player.Name)
end)

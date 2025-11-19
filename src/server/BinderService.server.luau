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
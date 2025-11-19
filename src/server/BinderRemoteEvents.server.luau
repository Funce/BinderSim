-- Shared RemoteEvents for binder interactions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a folder to hold all binder-related events
local BinderEvents = ReplicatedStorage:FindFirstChild("BinderEvents")

if not BinderEvents then
    BinderEvents = Instance.new("Folder")
    BinderEvents.Name = "BinderEvents"
    BinderEvents.Parent = ReplicatedStorage

    -- Event: Create a new binder
    local CreateBinderEvent = Instance.new("RemoteEvent")
    CreateBinderEvent.Name = "CreateBinder"
    CreateBinderEvent.Parent = BinderEvents

    -- Event: Attach a form to a binder
    local AttachFormEvent = Instance.new("RemoteEvent")
    AttachFormEvent.Name = "AttachForm"
    AttachFormEvent.Parent = BinderEvents

    -- Event: Validate a scanned form (optional for later)
    local ValidateFormEvent = Instance.new("RemoteEvent")
    ValidateFormEvent.Name = "ValidateForm"
    ValidateFormEvent.Parent = BinderEvents
end

return BinderEvents
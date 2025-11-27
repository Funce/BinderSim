-- Shared RemoteEvents for binder interactions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a folder to hold all binder-related events
local BinderEvents = ReplicatedStorage:FindFirstChild("BinderEvents")

if not BinderEvents then
    BinderEvents = Instance.new("Folder")
    BinderEvents.Name = "BinderEvents"
    BinderEvents.Parent = ReplicatedStorage

    -- Event: Create a new binder
    local CreateBinder = Instance.new("RemoteEvent")
    CreateBinder.Name = "CreateBinder"
    CreateBinder.Parent = BinderEvents

    -- Event: Attach a form to a binder
    local AttachForm = Instance.new("RemoteEvent")
    AttachForm.Name = "AttachForm"
    AttachForm.Parent = BinderEvents

    -- Event: Validate a scanned form (optional for later)
    local ValidateForm = Instance.new("RemoteEvent")
    ValidateForm.Name = "ValidateForm"
    ValidateForm.Parent = BinderEvents
end

return BinderEvents
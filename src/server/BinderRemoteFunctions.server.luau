-- Shared RemoteFunctions for binder interactions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BinderRemotes = ReplicatedStorage:FindFirstChild("BinderRemotes")
if not BinderRemotes then
    BinderRemotes = Instance.new("Folder")
    BinderRemotes.Name = "BinderRemotes"
    BinderRemotes.Parent = ReplicatedStorage

    -- RemoteFunction: Get the contents of a binder
    local GetContents = Instance.new("RemoteFunction")
    GetContents.Name = "GetContents"
    GetContents.Parent = BinderRemotes

    -- RemoteFunction: Attach a document to a binder
    local AttachDocument = Instance.new("RemoteFunction")
    AttachDocument.Name = "AttachDocument"
    AttachDocument.Parent = BinderRemotes
end

return BinderRemotes
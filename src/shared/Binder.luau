-- This contains the model for the Binder object (ID, contents, cover page, etc)
-- Defines a binder object with ID, cover page, canonical documents, and attached forms

local Binder = {}
Binder.__index = Binder

-- Constructor: creates a new binder with a unique id and empty contents
function Binder.new(id)
    local self = setmetatable({}, Binder)

    self.ID = id -- e.g., "BND-0427"
    self.CoverPage = {} -- Can hold surfaced details like vessel ID, bay assignment
    self.CanonicalDocs = {} -- Usually the manifest
    self.AttachedForms = {} -- Filled reports, slips, etc.

    return self
end

-- Method: attach a form to the binder
function Binder:AttachForm(form: table)
    table.insert(self.AttachedForms, form)
end

-- Method: add a canonical document (e.g., manifest)
function Binder:AddCanonicalDoc(doc: table)
    table.insert(self.CanonicalDocs, doc)
end

-- Method: update cover page details
function Binder:SetCoverField(key: string, value: any)
    self.CoverPage[key] = value
end

return Binder
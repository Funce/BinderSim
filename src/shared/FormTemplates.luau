-- This is the definition for our blank forms/templates (docking report, bay ticket)
-- Each blank form can be filled out and added to a binder

-- Provides blank form templates for Docking Report and Bay Ticket

local FormTemplates = {}

-- Docking Operations Report template
FormTemplates.DockingReport = {
    formType = "DockingReport",
    fields = {
        vesselID = "",
        bayAssignment = "",
        anomalies = "",
    },
    stamped = false
}

-- Bay Ticket template
FormTemplates.BayTicket = {
    formType = "BayTicket",
    fields = {
        vesselID = "",
        bayNumber = "",
        dockingTime = "",
    },
    stamped = false
}

return FormTemplates
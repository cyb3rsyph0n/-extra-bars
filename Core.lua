-- !ExtraBars Core
-- Main addon initialization and utility functions

local addonName, ExtraBars = ...
_G.ExtraBars = ExtraBars

ExtraBars.version = "1.0.0"
ExtraBars.bars = {}
ExtraBars.barFrames = {}
ExtraBars.selectedBarID = nil

-- Default settings for the addon
local defaults = {
    bars = {},
    nextBarID = 1,
}

-- Default settings for a new bar
ExtraBars.barDefaults = {
    enabled = true,
    iconSize = 36,
    iconPadding = 2,
    rows = 1,
    cols = 12,
    categories = {}, -- List of category keys in order
    position = {
        point = "CENTER",
        relativePoint = "CENTER",
        xOffset = 0,
        yOffset = 0,
    },
}

-- Event frame for addon initialization
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        ExtraBars:Initialize()
    elseif event == "PLAYER_LOGIN" then
        ExtraBars:OnPlayerLogin()
    elseif event == "PLAYER_ENTERING_WORLD" then
        ExtraBars:UpdateAllBars()
    end
end)

function ExtraBars:Initialize()
    -- Initialize saved variables
    if not ExtraBarsDB then
        ExtraBarsDB = CopyTable(defaults)
    end
    
    -- Ensure all default keys exist
    for key, value in pairs(defaults) do
        if ExtraBarsDB[key] == nil then
            ExtraBarsDB[key] = CopyTable(value)
        end
    end
    
    self.db = ExtraBarsDB
    
    -- Register slash commands
    SLASH_EXTRABARS1 = "/extrabars"
    SLASH_EXTRABARS2 = "/eb"
    SlashCmdList["EXTRABARS"] = function(msg)
        self:SlashCommand(msg)
    end
    
    print("|cff00ff00!ExtraBars|r v" .. self.version .. " loaded. Use |cff00ff00/eb add|r to create bars. Bars are movable in the game's Edit Mode.")
end

function ExtraBars:OnPlayerLogin()
    -- Create all saved bars
    for barID, barData in pairs(self.db.bars) do
        self:CreateBar(barID, barData)
    end
    
    -- Initialize config panel
    C_Timer.After(0.5, function()
        if self.InitializeConfigPanel then
            self:InitializeConfigPanel()
        end
    end)
end

function ExtraBars:SlashCommand(msg)
    msg = msg:lower():trim()
    
    if msg == "" or msg == "config" or msg == "options" then
        self:ToggleConfigPanel()
    elseif msg == "add" or msg == "new" then
        local barID = self:CreateNewBar()
        self:SelectBar(barID)
        print("|cff00ff00!ExtraBars|r: Created new bar. Open game Edit Mode (Esc > Edit Mode) to move it.")
    elseif msg == "reset" then
        self:ResetAllBars()
    else
        print("|cff00ff00!ExtraBars|r Commands:")
        print("  /eb - Open configuration panel")
        print("  /eb add - Add a new bar")
        print("  /eb reset - Reset all bars to default positions")
    end
end

-- Check if game Edit Mode is active
function ExtraBars:IsEditModeActive()
    return EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive()
end

-- Select a bar for editing
function ExtraBars:SelectBar(barID)
    self.selectedBarID = barID
    
    if self.configPanel and barID then
        self:ShowConfigPanel(barID)
    end
end

-- Toggle config panel
function ExtraBars:ToggleConfigPanel()
    if self.configPanel then
        if self.configPanel:IsShown() then
            self.configPanel:Hide()
        else
            self.configPanel:Show()
            self:RefreshBarList()
        end
    end
end

function ExtraBars:ResetAllBars()
    for barID, barFrame in pairs(self.barFrames) do
        if barFrame then
            local barData = self.db.bars[barID]
            if barData then
                barData.position = {
                    point = "CENTER",
                    relativePoint = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                }
                self:UpdateBarPosition(barID)
            end
        end
    end
    print("|cff00ff00!ExtraBars|r: All bars reset to center.")
end

function ExtraBars:UpdateAllBars()
    for barID, _ in pairs(self.barFrames) do
        self:UpdateBar(barID)
    end
end

-- Deep copy a table
function ExtraBars:DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[self:DeepCopy(orig_key)] = self:DeepCopy(orig_value)
        end
        setmetatable(copy, self:DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Create a new bar with default settings
function ExtraBars:CreateNewBar()
    local barID = self.db.nextBarID
    self.db.nextBarID = self.db.nextBarID + 1
    
    local barData = self:DeepCopy(self.barDefaults)
    
    self.db.bars[barID] = barData
    self:CreateBar(barID, barData)
    
    return barID
end

-- Delete a bar
function ExtraBars:DeleteBar(barID)
    if self.barFrames[barID] then
        self.barFrames[barID]:Hide()
        self.barFrames[barID] = nil
    end
    self.db.bars[barID] = nil
end

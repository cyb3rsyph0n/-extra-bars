-- !ExtraBars Bar
-- Bar creation, button handling, and Edit Mode integration

local addonName, ExtraBars = ...

-- Create the main bar frame with Edit Mode support
function ExtraBars:CreateBar(barID, barData)
    if self.barFrames[barID] then
        return self.barFrames[barID]
    end
    
    local bar = CreateFrame("Frame", "ExtraBarsBar" .. barID, UIParent, "BackdropTemplate")
    bar.barID = barID
    bar.buttons = {}
    
    -- Set up backdrop (invisible by default, shown in edit mode)
    bar:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    bar:SetBackdropColor(0, 0, 0, 0)
    bar:SetBackdropBorderColor(0, 0, 0, 0)
    
    -- Create bar label (shown in edit mode)
    bar.label = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bar.label:SetPoint("TOP", bar, "TOP", 0, 15)
    bar.label:SetText("Bar " .. barID)
    bar.label:Hide()
    
    -- Make bar movable
    bar:SetMovable(true)
    bar:SetClampedToScreen(true)
    bar:EnableMouse(false)
    
    self.barFrames[barID] = bar
    
    -- Register with Edit Mode system
    self:RegisterBarWithEditMode(barID, bar)
    
    -- Update the bar with current settings
    self:UpdateBar(barID)
    self:UpdateBarPosition(barID)
    
    return bar
end

-- Register a bar frame with WoW's Edit Mode system
function ExtraBars:RegisterBarWithEditMode(barID, bar)
    -- Create the edit mode selection frame that wraps the bar
    local selection = CreateFrame("Frame", bar:GetName() .. "Selection", bar, "EditModeSystemSelectionTemplate")
    selection:SetAllPoints(bar)
    selection:SetFrameLevel(bar:GetFrameLevel() + 100)
    selection.barID = barID
    bar.Selection = selection
    
    -- Set up the highlight/selection textures
    if selection.HighlightFrame then
        selection.HighlightFrame:SetAllPoints(bar)
    end
    if selection.SelectionFrame then
        selection.SelectionFrame:SetAllPoints(bar)
    end
    
    -- Label for edit mode
    selection.Label = selection:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    selection.Label:SetPoint("TOP", selection, "TOP", 0, 20)
    selection.Label:SetText("|cff00ff00Bar " .. barID .. "|r")
    
    -- Make it draggable in edit mode
    selection:SetMovable(true)
    selection:RegisterForDrag("LeftButton")
    selection:EnableMouse(true)
    
    selection:SetScript("OnDragStart", function(self)
        if ExtraBars:IsEditModeActive() then
            bar:StartMoving()
        end
    end)
    
    selection:SetScript("OnDragStop", function(self)
        bar:StopMovingOrSizing()
        ExtraBars:SaveBarPosition(barID)
    end)
    
    selection:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and ExtraBars:IsEditModeActive() then
            ExtraBars:SelectBar(barID)
        end
    end)
    
    selection:SetScript("OnEnter", function(self)
        if ExtraBars:IsEditModeActive() then
            -- Show highlight border on hover
            if selection.ShowHighlighted then
                selection:ShowHighlighted()
            end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("Bar " .. barID, 1, 1, 1)
            GameTooltip:AddLine("Click to select, drag to move", 0.7, 0.7, 0.7)
            GameTooltip:AddLine("Use /eb to configure categories", 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end
    end)
    
    selection:SetScript("OnLeave", function(self)
        -- Hide highlight when not hovering
        if selection.HideHighlighted then
            selection:HideHighlighted()
        end
        GameTooltip:Hide()
    end)
    
    -- Initially hide - shown only in Edit Mode
    selection:Hide()
    
    -- If we're already in edit mode, show the selection frame immediately
    if self:IsEditModeActive() then
        selection:Show()
        bar.label:Show()
        bar:SetBackdropColor(0, 0, 0, 0.3)
        bar:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    end
    
    -- Hook into Edit Mode events
    if not self.editModeHooked then
        self:HookEditModeEvents()
    end
end

-- Hook into the game's Edit Mode events
function ExtraBars:HookEditModeEvents()
    if self.editModeHooked then return end
    self.editModeHooked = true
    
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
    eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    
    eventFrame:SetScript("OnEvent", function(self, event)
        ExtraBars:UpdateEditModeState()
    end)
    
    -- Also hook the EditModeManagerFrame if available
    if EditModeManagerFrame then
        hooksecurefunc(EditModeManagerFrame, "EnterEditMode", function()
            ExtraBars:OnEnterEditMode()
        end)
        
        hooksecurefunc(EditModeManagerFrame, "ExitEditMode", function()
            ExtraBars:OnExitEditMode()
        end)
    end
end

-- Called when entering Edit Mode
function ExtraBars:OnEnterEditMode()
    for barID, bar in pairs(self.barFrames) do
        if bar and bar.Selection then
            local barData = self.db.bars[barID]
            
            -- Show selection frame with blue highlight
            bar.Selection:Show()
            bar.Selection.Label:SetText("|cff00ff00Bar " .. barID .. "|r")
            
            -- Show the blue highlight border (native Edit Mode style)
            if bar.Selection.ShowHighlighted then
                bar.Selection:ShowHighlighted()
            end
            
            -- Show bar label
            bar.label:Show()
            bar.label:SetText("Bar " .. barID)
            
            -- Ensure minimum size for empty bars
            local width, height = bar:GetSize()
            if width < 60 or height < 40 then
                bar:SetSize(math.max(width, 80), math.max(height, 50))
            end
        end
    end
end

-- Called when exiting Edit Mode
function ExtraBars:OnExitEditMode()
    for barID, bar in pairs(self.barFrames) do
        if bar and bar.Selection then
            -- Hide selection frame and highlight
            if bar.Selection.HideHighlighted then
                bar.Selection:HideHighlighted()
            end
            bar.Selection:Hide()
            
            -- Hide bar label
            bar.label:Hide()
            
            -- Recalculate proper size
            self:UpdateBar(barID)
        end
    end
    
    -- Hide config panel when exiting edit mode
    if self.configPanel and self.configPanel:IsShown() then
        -- Keep it open but deselect
    end
end

-- Update edit mode state based on current mode
function ExtraBars:UpdateEditModeState()
    if self:IsEditModeActive() then
        self:OnEnterEditMode()
    else
        self:OnExitEditMode()
    end
end

-- Create a single button for the bar
function ExtraBars:CreateButton(bar, index, iconSize)
    local button = CreateFrame("Button", bar:GetName() .. "Button" .. index, bar, "SecureActionButtonTemplate, BackdropTemplate")
    button:SetSize(iconSize, iconSize)
    
    -- Set up button visuals
    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetAllPoints()
    button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    
    button.cooldown = CreateFrame("Cooldown", button:GetName() .. "Cooldown", button, "CooldownFrameTemplate")
    button.cooldown:SetAllPoints()
    button.cooldown:SetDrawEdge(false)
    button.cooldown:SetDrawBling(false)
    
    button.count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    button.count:SetPoint("BOTTOMRIGHT", -2, 2)
    button.count:SetJustifyH("RIGHT")
    
    button.border = button:CreateTexture(nil, "OVERLAY")
    button.border:SetPoint("TOPLEFT", -1, 1)
    button.border:SetPoint("BOTTOMRIGHT", 1, -1)
    button.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    button.border:SetBlendMode("ADD")
    button.border:SetAlpha(0.5)
    
    -- Highlight texture
    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    
    -- Push texture
    button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
    
    -- Set up tooltip
    button:SetScript("OnEnter", function(self)
        if self.itemType and self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.itemType == "SPELL" then
                GameTooltip:SetSpellByID(self.itemID)
            elseif self.itemType == "ITEM" then
                GameTooltip:SetItemByID(self.itemID)
            end
            GameTooltip:Show()
        end
    end)
    
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    return button
end

-- Update a bar's buttons and layout
function ExtraBars:UpdateBar(barID)
    local barData = self.db.bars[barID]
    local bar = self.barFrames[barID]
    
    if not barData or not bar then return end
    
    -- Show/hide bar based on enabled state
    if not barData.enabled then
        bar:Hide()
        return
    end
    
    -- Get available items for this bar
    local items = self:GetAllAvailableItemsForBar(barID)
    
    -- Update bar label with display name
    local displayName = self:GetBarDisplayName(barID)
    bar.label:SetText(displayName)
    if bar.Selection and bar.Selection.Label then
        bar.Selection.Label:SetText("|cff00ff00" .. displayName .. "|r")
    end
    
    local iconSize = barData.iconSize
    local padding = barData.iconPadding
    local rows = barData.rows
    local cols = barData.cols
    local maxButtons = rows * cols
    
    -- Hide existing buttons
    for i, button in ipairs(bar.buttons) do
        button:Hide()
        button:SetAttribute("type", nil)
        button:SetAttribute("spell", nil)
        button:SetAttribute("item", nil)
    end
    
    -- Create or update buttons
    local buttonIndex = 0
    for i, item in ipairs(items) do
        if buttonIndex >= maxButtons then break end
        
        buttonIndex = buttonIndex + 1
        
        -- Create button if needed
        if not bar.buttons[buttonIndex] then
            bar.buttons[buttonIndex] = self:CreateButton(bar, buttonIndex, iconSize)
        end
        
        local button = bar.buttons[buttonIndex]
        button:SetSize(iconSize, iconSize)
        button.itemID = item.id
        button.itemType = item.type
        
        -- Position button in grid based on anchor
        local row = math.floor((buttonIndex - 1) / cols)
        local col = (buttonIndex - 1) % cols
        -- Handle legacy data where anchor might be a table or missing
        local anchor = barData.anchor
        if type(anchor) ~= "string" then
            anchor = "TOPLEFT"
        end
        local xOffset, yOffset
        local anchorPoint
        
        if anchor == "TOPLEFT" then
            xOffset = col * (iconSize + padding) + padding
            yOffset = -row * (iconSize + padding) - padding
            anchorPoint = "TOPLEFT"
        elseif anchor == "TOPRIGHT" then
            xOffset = -col * (iconSize + padding) - padding
            yOffset = -row * (iconSize + padding) - padding
            anchorPoint = "TOPRIGHT"
        elseif anchor == "BOTTOMLEFT" then
            xOffset = col * (iconSize + padding) + padding
            yOffset = row * (iconSize + padding) + padding
            anchorPoint = "BOTTOMLEFT"
        elseif anchor == "BOTTOMRIGHT" then
            xOffset = -col * (iconSize + padding) - padding
            yOffset = row * (iconSize + padding) + padding
            anchorPoint = "BOTTOMRIGHT"
        else
            -- Default fallback
            anchor = "TOPLEFT"
            xOffset = col * (iconSize + padding) + padding
            yOffset = -row * (iconSize + padding) - padding
            anchorPoint = "TOPLEFT"
        end
        
        button:ClearAllPoints()
        button:SetPoint(anchorPoint, bar, anchorPoint, xOffset, yOffset)
        
        -- Set up button attributes and visuals
        if item.type == "SPELL" then
            button:SetAttribute("type", "spell")
            button:SetAttribute("spell", item.id)
            
            local spellInfo = C_Spell.GetSpellInfo(item.id)
            if spellInfo then
                button.icon:SetTexture(spellInfo.iconID)
            end
            button.count:SetText("")
            button.slotID = nil
            
            -- Update cooldown
            self:UpdateButtonCooldown(button, "SPELL", item.id)
            
        elseif item.type == "ITEM" then
            -- Check if this is an equipped item (trinket)
            if item.slotID then
                -- Use slot-based action for equipped items
                button:SetAttribute("type", "macro")
                button:SetAttribute("macrotext", "/use " .. item.slotID)
                button.slotID = item.slotID
            else
                button:SetAttribute("type", "item")
                button:SetAttribute("item", "item:" .. item.id)
                button.slotID = nil
            end
            
            local itemIcon = C_Item.GetItemIconByID(item.id)
            if itemIcon then
                button.icon:SetTexture(itemIcon)
            end
            
            -- Update count (don't show for equipped items)
            if item.slotID then
                button.count:SetText("")
            else
                local count = C_Item.GetItemCount(item.id, true, false)
                if count > 1 then
                    button.count:SetText(count)
                else
                    button.count:SetText("")
                end
            end
            
            -- Update cooldown
            self:UpdateButtonCooldown(button, "ITEM", item.id)
        end
        
        button:Show()
    end
    
    -- Calculate bar size
    local usedCols = math.min(buttonIndex, cols)
    local usedRows = math.ceil(buttonIndex / cols)
    
    if usedCols == 0 then usedCols = 1 end
    if usedRows == 0 then usedRows = 1 end
    
    local barWidth = usedCols * (iconSize + padding) + padding
    local barHeight = usedRows * (iconSize + padding) + padding
    
    -- Minimum size for empty bars (visible in edit mode)
    if buttonIndex == 0 then
        barWidth = 80
        barHeight = 50
    end
    
    bar:SetSize(barWidth, barHeight)
    bar:Show()
    
    -- Start update timer for cooldowns and counts
    self:StartBarUpdateTimer(barID)
end

-- Update button cooldown display
function ExtraBars:UpdateButtonCooldown(button, itemType, itemID)
    if not button.cooldown then return end
    
    local start, duration = 0, 0
    
    if itemType == "SPELL" then
        local cooldownInfo = C_Spell.GetSpellCooldown(itemID)
        if cooldownInfo then
            start = cooldownInfo.startTime
            duration = cooldownInfo.duration
        end
    elseif itemType == "ITEM" then
        start, duration = C_Item.GetItemCooldown(itemID)
    end
    
    if start and duration and start > 0 and duration > 0 then
        button.cooldown:SetCooldown(start, duration)
    else
        button.cooldown:Clear()
    end
end

-- Start a timer to update bar cooldowns and item counts
function ExtraBars:StartBarUpdateTimer(barID)
    local bar = self.barFrames[barID]
    if not bar then return end
    
    if bar.updateTimer then
        bar.updateTimer:Cancel()
    end
    
    bar.updateTimer = C_Timer.NewTicker(0.1, function()
        if not ExtraBars.barFrames[barID] then
            return
        end
        ExtraBars:UpdateBarCooldownsAndCounts(barID)
    end)
end

-- Update cooldowns and item counts for a bar
function ExtraBars:UpdateBarCooldownsAndCounts(barID)
    local bar = self.barFrames[barID]
    if not bar then return end
    
    for _, button in ipairs(bar.buttons) do
        if button:IsShown() and button.itemID and button.itemType then
            -- Update cooldown
            self:UpdateButtonCooldown(button, button.itemType, button.itemID)
            
            -- Update count for items
            if button.itemType == "ITEM" then
                local count = C_Item.GetItemCount(button.itemID, true, false)
                if count > 1 then
                    button.count:SetText(count)
                elseif count == 0 then
                    button:SetAlpha(0.5)
                    button.count:SetText("")
                else
                    button:SetAlpha(1)
                    button.count:SetText("")
                end
            end
        end
    end
end

-- Get the anchor point based on anchor setting (handles legacy data)
function ExtraBars:GetAnchorPoint(anchor)
    -- Handle legacy data where anchor might be a table
    if type(anchor) ~= "string" then
        return "TOPLEFT"
    end
    -- Anchor is already the point name
    if anchor == "TOPLEFT" or anchor == "TOPRIGHT" or anchor == "BOTTOMLEFT" or anchor == "BOTTOMRIGHT" then
        return anchor
    end
    return "TOPLEFT" -- Default
end

-- Save bar position after dragging (using anchor-aware positioning)
function ExtraBars:SaveBarPosition(barID)
    local barData = self.db.bars[barID]
    local bar = self.barFrames[barID]
    
    if not barData or not bar then return end
    
    -- Get the appropriate anchor point for the bar's anchor setting
    local anchorPoint = self:GetAnchorPoint(barData.anchor)
    
    -- Get the bar's current position in screen coordinates
    local left, bottom, width, height = bar:GetRect()
    if not left then return end
    
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local scale = bar:GetEffectiveScale()
    
    -- Calculate position relative to UIParent based on anchor point
    local xOfs, yOfs
    if anchorPoint == "TOPLEFT" then
        xOfs = left * scale
        yOfs = (bottom + height) * scale - screenHeight
    elseif anchorPoint == "TOPRIGHT" then
        xOfs = (left + width) * scale - screenWidth
        yOfs = (bottom + height) * scale - screenHeight
    elseif anchorPoint == "BOTTOMLEFT" then
        xOfs = left * scale
        yOfs = bottom * scale
    elseif anchorPoint == "BOTTOMRIGHT" then
        xOfs = (left + width) * scale - screenWidth
        yOfs = bottom * scale
    end
    
    barData.position = {
        point = anchorPoint,
        relativePoint = anchorPoint,
        xOffset = xOfs,
        yOffset = yOfs,
    }
end

-- Update bar position based on saved position (anchor-aware)
function ExtraBars:UpdateBarPosition(barID)
    local barData = self.db.bars[barID]
    local bar = self.barFrames[barID]
    
    if not barData or not bar then return end
    
    -- Get the appropriate anchor for the current anchor setting
    local anchorPoint = self:GetAnchorPoint(barData.anchor)
    
    bar:ClearAllPoints()
    
    local pos = barData.position
    
    -- Apply the saved position using the anchor point
    bar:SetPoint(anchorPoint, UIParent, anchorPoint, pos.xOffset, pos.yOffset)
end

-- Register events for bar updates
local updateFrame = CreateFrame("Frame")
updateFrame:RegisterEvent("BAG_UPDATE")
updateFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
updateFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
updateFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
updateFrame:RegisterEvent("PLAYER_REGEN_DISABLED")

updateFrame:SetScript("OnEvent", function(self, event)
    -- Delay update slightly to allow game state to settle
    C_Timer.After(0.1, function()
        ExtraBars:UpdateAllBars()
    end)
end)

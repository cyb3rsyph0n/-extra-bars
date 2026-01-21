-- !ExtraBars Options
-- Configuration panel for bar settings

local addonName, ExtraBars = ...

-- Helper function to create a custom slider
local function CreateSlider(parent, name, label, minVal, maxVal, step, width)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(width or 200, 45)
    
    local labelText = container:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    labelText:SetPoint("TOPLEFT", 0, 0)
    labelText:SetText(label)
    
    local slider = CreateFrame("Slider", name, container, "BackdropTemplate")
    slider:SetSize(width or 200, 17)
    slider:SetPoint("TOPLEFT", 0, -15)
    slider:SetOrientation("HORIZONTAL")
    slider:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 3, right = 3, top = 6, bottom = 6 },
    })
    
    local thumb = slider:CreateTexture(nil, "ARTWORK")
    thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    thumb:SetSize(32, 32)
    slider:SetThumbTexture(thumb)
    
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    
    slider.lowText = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    slider.lowText:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -2)
    slider.lowText:SetText(minVal)
    
    slider.highText = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    slider.highText:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, -2)
    slider.highText:SetText(maxVal)
    
    slider.valueText = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    slider.valueText:SetPoint("LEFT", slider, "RIGHT", 8, 0)
    
    container.slider = slider
    return container
end

-- Create the main configuration panel
local function CreateConfigPanel()
    local frame = CreateFrame("Frame", "ExtraBarsConfigPanel", UIParent, "BackdropTemplate")
    frame:SetSize(330, 630)
    frame:SetPoint("LEFT", 20, 0)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    frame:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()
    
    -- Make closeable with Escape
    tinsert(UISpecialFrames, "ExtraBarsConfigPanel")
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    
    local yPos = -20
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, yPos)
    title:SetText("|cff00ff00!ExtraBars|r")
    
    yPos = yPos - 25
    
    local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    subtitle:SetPoint("TOP", 0, yPos)
    subtitle:SetTextColor(0.7, 0.7, 0.7)
    subtitle:SetText("Use game Edit Mode to move bars")
    
    yPos = yPos - 30
    
    -- Bar selector dropdown
    local barLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    barLabel:SetPoint("TOPLEFT", 20, yPos)
    barLabel:SetText("Select Bar:")
    
    frame.barDropdown = CreateFrame("Frame", "ExtraBarsBarDropdown", frame, "UIDropDownMenuTemplate")
    frame.barDropdown:SetPoint("TOPLEFT", 80, yPos + 5)
    UIDropDownMenu_SetWidth(frame.barDropdown, 180)
    
    yPos = yPos - 40
    
    -- Separator
    local sep1 = frame:CreateTexture(nil, "ARTWORK")
    sep1:SetHeight(1)
    sep1:SetPoint("TOPLEFT", 15, yPos)
    sep1:SetPoint("TOPRIGHT", -15, yPos)
    sep1:SetColorTexture(0.4, 0.4, 0.4, 0.5)
    
    yPos = yPos - 15
    
    -- Settings section (initially hidden until bar selected)
    frame.settingsFrame = CreateFrame("Frame", nil, frame)
    frame.settingsFrame:SetPoint("TOPLEFT", 0, yPos)
    frame.settingsFrame:SetPoint("BOTTOMRIGHT", 0, 55) -- Leave room for bottom buttons
    frame.settingsFrame:Hide()
    
    local settingsY = 0
    
    -- Enabled checkbox
    frame.enabledCheck = CreateFrame("CheckButton", nil, frame.settingsFrame, "UICheckButtonTemplate")
    frame.enabledCheck:SetPoint("TOPLEFT", 15, settingsY)
    frame.enabledCheck:SetScript("OnClick", function(self)
        local barID = ExtraBars.selectedBarID
        if barID and ExtraBars.db.bars[barID] then
            ExtraBars.db.bars[barID].enabled = self:GetChecked()
            ExtraBars:UpdateBar(barID)
        end
    end)
    
    local enabledLabel = frame.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    enabledLabel:SetPoint("LEFT", frame.enabledCheck, "RIGHT", 2, 0)
    enabledLabel:SetText("Enabled")
    
    settingsY = settingsY - 30
    
    -- Bar Name input
    local nameLabel = frame.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    nameLabel:SetPoint("TOPLEFT", 20, settingsY)
    nameLabel:SetText("Bar Name:")
    
    frame.nameEditBox = CreateFrame("EditBox", "EBBarNameEditBox", frame.settingsFrame, "InputBoxTemplate")
    frame.nameEditBox:SetSize(180, 20)
    frame.nameEditBox:SetPoint("TOPLEFT", 90, settingsY + 3)
    frame.nameEditBox:SetAutoFocus(false)
    frame.nameEditBox:SetMaxLetters(30)
    frame.nameEditBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        local barID = ExtraBars.selectedBarID
        if barID and ExtraBars.db.bars[barID] then
            ExtraBars.db.bars[barID].name = self:GetText()
            ExtraBars:UpdateBar(barID)
            ExtraBars:RefreshBarList()
        end
    end)
    frame.nameEditBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    
    settingsY = settingsY - 30
    
    -- Layout section
    local layoutTitle = frame.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    layoutTitle:SetPoint("TOPLEFT", 20, settingsY)
    layoutTitle:SetText("|cff00ff00Layout|r")
    
    settingsY = settingsY - 25
    
    -- Icon Size
    frame.sizeContainer = CreateSlider(frame.settingsFrame, "EBSizeSlider", "Icon Size", 20, 64, 1, 260)
    frame.sizeContainer:SetPoint("TOPLEFT", 20, settingsY)
    frame.sizeContainer.slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        self.valueText:SetText(value)
        local barID = ExtraBars.selectedBarID
        if barID and ExtraBars.db.bars[barID] then
            ExtraBars.db.bars[barID].iconSize = value
            ExtraBars:UpdateBar(barID)
        end
    end)
    
    settingsY = settingsY - 50
    
    -- Padding
    frame.paddingContainer = CreateSlider(frame.settingsFrame, "EBPaddingSlider", "Padding", 0, 10, 1, 260)
    frame.paddingContainer:SetPoint("TOPLEFT", 20, settingsY)
    frame.paddingContainer.slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        self.valueText:SetText(value)
        local barID = ExtraBars.selectedBarID
        if barID and ExtraBars.db.bars[barID] then
            ExtraBars.db.bars[barID].iconPadding = value
            ExtraBars:UpdateBar(barID)
        end
    end)
    
    settingsY = settingsY - 50
    
    -- Rows
    frame.rowsContainer = CreateSlider(frame.settingsFrame, "EBRowsSlider", "Rows", 1, 6, 1, 120)
    frame.rowsContainer:SetPoint("TOPLEFT", 20, settingsY)
    frame.rowsContainer.slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        self.valueText:SetText(value)
        local barID = ExtraBars.selectedBarID
        if barID and ExtraBars.db.bars[barID] then
            ExtraBars.db.bars[barID].rows = value
            ExtraBars:UpdateBar(barID)
        end
    end)
    
    -- Columns
    frame.colsContainer = CreateSlider(frame.settingsFrame, "EBColsSlider", "Columns", 1, 12, 1, 120)
    frame.colsContainer:SetPoint("TOPLEFT", 160, settingsY)
    frame.colsContainer.slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value)
        self.valueText:SetText(value)
        local barID = ExtraBars.selectedBarID
        if barID and ExtraBars.db.bars[barID] then
            ExtraBars.db.bars[barID].cols = value
            ExtraBars:UpdateBar(barID)
        end
    end)
    
    settingsY = settingsY - 50
    
    -- Anchor dropdown
    local anchorLabel = frame.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    anchorLabel:SetPoint("TOPLEFT", 20, settingsY)
    anchorLabel:SetText("Anchor:")
    
    frame.anchorDropdown = CreateFrame("Frame", "EBAnchorDropdown", frame.settingsFrame, "UIDropDownMenuTemplate")
    frame.anchorDropdown:SetPoint("TOPLEFT", 70, settingsY + 5)
    UIDropDownMenu_SetWidth(frame.anchorDropdown, 120)
    
    local anchors = {
        { value = "TOPLEFT", text = "Top Left" },
        { value = "TOPRIGHT", text = "Top Right" },
        { value = "BOTTOMLEFT", text = "Bottom Left" },
        { value = "BOTTOMRIGHT", text = "Bottom Right" },
    }
    
    local function InitAnchorDropdown(self, level)
        for _, anch in ipairs(anchors) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = anch.text
            info.value = anch.value
            info.func = function()
                local barID = ExtraBars.selectedBarID
                if barID and ExtraBars.db.bars[barID] then
                    -- Save current position before changing anchor
                    ExtraBars:SaveBarPosition(barID)
                    -- Change anchor
                    ExtraBars.db.bars[barID].anchor = anch.value
                    UIDropDownMenu_SetText(frame.anchorDropdown, anch.text)
                    -- Update bar layout and reposition with new anchor
                    ExtraBars:UpdateBar(barID)
                    ExtraBars:UpdateBarPosition(barID)
                end
            end
            info.checked = function()
                local barID = ExtraBars.selectedBarID
                return barID and ExtraBars.db.bars[barID] and ExtraBars.db.bars[barID].anchor == anch.value
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(frame.anchorDropdown, InitAnchorDropdown)
    
    settingsY = settingsY - 35
    
    -- Categories section
    local catTitle = frame.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    catTitle:SetPoint("TOPLEFT", 20, settingsY)
    catTitle:SetText("|cff00ff00Categories|r (drag to reorder)")
    
    settingsY = settingsY - 20
    
    -- Categories scroll frame container
    local catScrollContainer = CreateFrame("Frame", nil, frame.settingsFrame, "BackdropTemplate")
    catScrollContainer:SetPoint("TOPLEFT", 15, settingsY)
    catScrollContainer:SetSize(285, 140)
    catScrollContainer:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    catScrollContainer:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    
    -- Scroll frame
    local catScrollFrame = CreateFrame("ScrollFrame", "EBCategoryScrollFrame", catScrollContainer, "UIPanelScrollFrameTemplate")
    catScrollFrame:SetPoint("TOPLEFT", 4, -4)
    catScrollFrame:SetPoint("BOTTOMRIGHT", -24, 4)
    
    -- Scroll child (content frame)
    frame.catContainer = CreateFrame("Frame", nil, catScrollFrame)
    frame.catContainer:SetSize(255, 1) -- Height will be set dynamically
    catScrollFrame:SetScrollChild(frame.catContainer)
    
    frame.categoryButtons = {}
    local catY = 0
    local totalCategories = 0
    
    for i, catKey in ipairs(ExtraBars.CategoryOrder) do
        totalCategories = totalCategories + 1
        local catData = ExtraBars.Categories[catKey]
        
        local catBtn = CreateFrame("Button", nil, frame.catContainer, "BackdropTemplate")
        catBtn:SetSize(255, 22)
        catBtn:SetPoint("TOPLEFT", 0, catY)
        catBtn:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        catBtn:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
        catBtn.categoryKey = catKey
        
        catBtn.check = CreateFrame("CheckButton", nil, catBtn, "UICheckButtonTemplate")
        catBtn.check:SetSize(22, 22)
        catBtn.check:SetPoint("LEFT", 2, 0)
        
        catBtn.label = catBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        catBtn.label:SetPoint("LEFT", catBtn.check, "RIGHT", 2, 0)
        catBtn.label:SetText(catData.name)
        
        catBtn.order = catBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        catBtn.order:SetPoint("RIGHT", -8, 0)
        catBtn.order:SetTextColor(0.5, 1, 0.5)
        
        catBtn.check:SetScript("OnClick", function(self)
            local barID = ExtraBars.selectedBarID
            if not barID or not ExtraBars.db.bars[barID] then return end
            
            local categories = ExtraBars.db.bars[barID].categories
            local key = catBtn.categoryKey
            
            if self:GetChecked() then
                local found = false
                for _, cat in ipairs(categories) do
                    if cat == key then found = true break end
                end
                if not found then
                    table.insert(categories, key)
                end
            else
                for j = #categories, 1, -1 do
                    if categories[j] == key then
                        table.remove(categories, j)
                    end
                end
            end
            
            ExtraBars:UpdateBar(barID)
            ExtraBars:UpdateConfigPanel()
        end)
        
        -- Drag to reorder
        catBtn:EnableMouse(true)
        catBtn:RegisterForDrag("LeftButton")
        
        catBtn:SetScript("OnDragStart", function(self)
            if self.check:GetChecked() then
                self.dragging = true
                self:SetBackdropColor(0.3, 0.3, 0, 0.9)
            end
        end)
        
        catBtn:SetScript("OnDragStop", function(self)
            self.dragging = false
            self:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
        end)
        
        catBtn:SetScript("OnEnter", function(self)
            if not self.dragging then
                self:SetBackdropColor(0.25, 0.25, 0.25, 0.9)
            end
            for _, btn in pairs(frame.categoryButtons) do
                if btn.dragging and btn ~= self then
                    ExtraBars:SwapCategories(btn.categoryKey, self.categoryKey)
                    btn.dragging = false
                    btn:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
                end
            end
        end)
        
        catBtn:SetScript("OnLeave", function(self)
            if not self.dragging then
                self:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
            end
        end)
        
        frame.categoryButtons[catKey] = catBtn
        catY = catY - 24
    end
    
    -- Set scroll child height based on total categories
    frame.catContainer:SetHeight(totalCategories * 24)
    
    -- Reset Position button at bottom
    local resetPosBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    resetPosBtn:SetSize(110, 22)
    resetPosBtn:SetPoint("BOTTOMLEFT", 15, 18)
    resetPosBtn:SetText("Reset Position")
    resetPosBtn:SetFrameLevel(frame:GetFrameLevel() + 10)
    resetPosBtn:SetScript("OnClick", function()
        if ExtraBars.selectedBarID then
            local barID = ExtraBars.selectedBarID
            local barData = ExtraBars.db.bars[barID]
            if barData then
                -- Reset anchor to default
                barData.anchor = "TOPLEFT"
                -- Reset position to centered above character
                barData.position = ExtraBars:GetDefaultPosition()
                -- Update bar
                ExtraBars:UpdateBar(barID)
                ExtraBars:UpdateBarPosition(barID)
                ExtraBars:UpdateConfigPanel()
                print("|cff00ff00!ExtraBars:|r Position reset for " .. ExtraBars:GetBarDisplayName(barID))
            end
        end
    end)
    frame.resetPosBtn = resetPosBtn
    
    -- Delete button at bottom
    local deleteBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    deleteBtn:SetSize(100, 22)
    deleteBtn:SetPoint("BOTTOMRIGHT", -15, 18)
    deleteBtn:SetText("Delete Bar")
    deleteBtn:SetFrameLevel(frame:GetFrameLevel() + 10)
    deleteBtn:SetScript("OnClick", function()
        if ExtraBars.selectedBarID then
            StaticPopup_Show("EXTRABARS_DELETE_CONFIRM")
        end
    end)
    frame.deleteBtn = deleteBtn
    
    return frame
end

-- Swap category order
function ExtraBars:SwapCategories(key1, key2)
    local barID = self.selectedBarID
    if not barID or not self.db.bars[barID] then return end
    
    local categories = self.db.bars[barID].categories
    local idx1, idx2
    
    for i, cat in ipairs(categories) do
        if cat == key1 then idx1 = i end
        if cat == key2 then idx2 = i end
    end
    
    if idx1 and idx2 then
        categories[idx1], categories[idx2] = categories[idx2], categories[idx1]
        self:UpdateBar(barID)
        self:UpdateConfigPanel()
    end
end

-- Refresh bar dropdown
function ExtraBars:RefreshBarList()
    if not self.configPanel then return end
    
    local function InitBarDropdown(self, level)
        -- Add New option at top
        local addInfo = UIDropDownMenu_CreateInfo()
        addInfo.text = "|cff00ff00+ Add New Bar|r"
        addInfo.func = function()
            local barID = ExtraBars:CreateNewBar()
            ExtraBars:SelectBar(barID)
            ExtraBars:RefreshBarList()
        end
        addInfo.notCheckable = true
        UIDropDownMenu_AddButton(addInfo, level)
        
        -- Separator if there are bars
        if next(ExtraBars.db.bars) then
            local sepInfo = UIDropDownMenu_CreateInfo()
            sepInfo.text = ""
            sepInfo.disabled = true
            sepInfo.notCheckable = true
            UIDropDownMenu_AddButton(sepInfo, level)
        end
        
        -- List existing bars (sorted by barID)
        local sortedBarIDs = {}
        for barID in pairs(ExtraBars.db.bars) do
            table.insert(sortedBarIDs, barID)
        end
        table.sort(sortedBarIDs)
        
        for _, barID in ipairs(sortedBarIDs) do
            local displayName = ExtraBars:GetBarDisplayName(barID)
            local info = UIDropDownMenu_CreateInfo()
            info.text = displayName
            info.func = function()
                ExtraBars:SelectBar(barID)
                UIDropDownMenu_SetText(ExtraBars.configPanel.barDropdown, ExtraBars:GetBarDisplayName(barID))
            end
            info.checked = (ExtraBars.selectedBarID == barID)
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(self.configPanel.barDropdown, InitBarDropdown)
    
    if self.selectedBarID and self.db.bars[self.selectedBarID] then
        UIDropDownMenu_SetText(self.configPanel.barDropdown, self:GetBarDisplayName(self.selectedBarID))
    else
        UIDropDownMenu_SetText(self.configPanel.barDropdown, "Select a bar...")
    end
end

-- Update config panel with selected bar data
function ExtraBars:UpdateConfigPanel()
    local panel = self.configPanel
    if not panel then return end
    
    local barID = self.selectedBarID
    if not barID or not self.db.bars[barID] then
        panel.settingsFrame:Hide()
        panel.deleteBtn:Hide()
        panel.resetPosBtn:Hide()
        return
    end
    
    local barData = self.db.bars[barID]
    
    panel.settingsFrame:Show()
    panel.deleteBtn:Show()
    panel.resetPosBtn:Show()
    
    panel.enabledCheck:SetChecked(barData.enabled)
    panel.nameEditBox:SetText(barData.name or "")
    panel.sizeContainer.slider:SetValue(barData.iconSize)
    panel.paddingContainer.slider:SetValue(barData.iconPadding)
    panel.rowsContainer.slider:SetValue(barData.rows)
    panel.colsContainer.slider:SetValue(barData.cols)
    
    -- Update anchor dropdown (handle legacy data where anchor might be a table)
    local anchorLabels = { TOPLEFT = "Top Left", TOPRIGHT = "Top Right", BOTTOMLEFT = "Bottom Left", BOTTOMRIGHT = "Bottom Right" }
    local currentAnchor = barData.anchor
    if type(currentAnchor) ~= "string" then
        currentAnchor = "TOPLEFT"
    end
    UIDropDownMenu_SetText(panel.anchorDropdown, anchorLabels[currentAnchor] or "Top Left")
    
    -- Update category checkboxes
    for catKey, btn in pairs(panel.categoryButtons) do
        local orderNum = nil
        for i, cat in ipairs(barData.categories) do
            if cat == catKey then
                orderNum = i
                break
            end
        end
        
        if orderNum then
            btn.order:SetText("#" .. orderNum)
            btn.check:SetChecked(true)
        else
            btn.order:SetText("")
            btn.check:SetChecked(false)
        end
    end
end

-- Show config panel
function ExtraBars:ShowConfigPanel(barID)
    if not self.configPanel then return end
    
    -- If no bar specified and no bar currently selected, select the first bar
    if not barID and not self.selectedBarID then
        local sortedBarIDs = {}
        for id in pairs(self.db.bars) do
            table.insert(sortedBarIDs, id)
        end
        table.sort(sortedBarIDs)
        if #sortedBarIDs > 0 then
            barID = sortedBarIDs[1]
        end
    end
    
    -- Set the selected bar directly (don't call SelectBar to avoid recursion)
    if barID then
        self.selectedBarID = barID
    end
    
    self.configPanel:Show()
    self:RefreshBarList()
    self:UpdateConfigPanel()
end

-- Delete confirmation
StaticPopupDialogs["EXTRABARS_DELETE_CONFIRM"] = {
    text = "Delete this bar?",
    button1 = "Delete",
    button2 = "Cancel",
    OnAccept = function()
        local barID = ExtraBars.selectedBarID
        if barID then
            ExtraBars:DeleteBar(barID)
            ExtraBars.selectedBarID = nil
            ExtraBars:RefreshBarList()
            ExtraBars:UpdateConfigPanel()
        end
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Initialize config panel
function ExtraBars:InitializeConfigPanel()
    self.configPanel = CreateConfigPanel()
    self:RefreshBarList()
end

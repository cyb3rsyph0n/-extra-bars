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

-- Helper function to create a tab button
local function CreateTabButton(parent, text, tabIndex, tabFrame, mainFrame)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(90, 24)
    btn:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    btn:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
    
    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    btn.text:SetPoint("CENTER")
    btn.text:SetText(text)
    
    btn.tabIndex = tabIndex
    btn.tabFrame = tabFrame
    btn.mainFrame = mainFrame
    
    btn:SetScript("OnClick", function(self)
        self.mainFrame:SelectTab(self.tabIndex)
    end)
    
    btn:SetScript("OnEnter", function(self)
        if not self.selected then
            self:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
        end
    end)
    
    btn:SetScript("OnLeave", function(self)
        if not self.selected then
            self:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
        end
    end)
    
    return btn
end

-- Create the main configuration panel
local function CreateConfigPanel()
    local frame = CreateFrame("Frame", "ExtraBarsConfigPanel", UIParent, "BackdropTemplate")
    frame:SetSize(330, 680)
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
    
    -- Strata dropdown
    local strataLabel = frame.settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    strataLabel:SetPoint("TOPLEFT", 20, settingsY)
    strataLabel:SetText("Strata:")
    
    frame.strataDropdown = CreateFrame("Frame", "EBStrataDropdown", frame.settingsFrame, "UIDropDownMenuTemplate")
    frame.strataDropdown:SetPoint("TOPLEFT", 70, settingsY + 5)
    UIDropDownMenu_SetWidth(frame.strataDropdown, 120)
    
    local stratas = {
        { value = "BACKGROUND", text = "Background" },
        { value = "LOW", text = "Low" },
        { value = "MEDIUM", text = "Medium" },
        { value = "HIGH", text = "High" },
        { value = "DIALOG", text = "Dialog" },
    }
    
    local function InitStrataDropdown(self, level)
        for _, strata in ipairs(stratas) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = strata.text
            info.value = strata.value
            info.func = function()
                local barID = ExtraBars.selectedBarID
                if barID and ExtraBars.db.bars[barID] then
                    ExtraBars.db.bars[barID].strata = strata.value
                    UIDropDownMenu_SetText(frame.strataDropdown, strata.text)
                    -- Update bar strata
                    local barFrame = ExtraBars.barFrames[barID]
                    if barFrame then
                        barFrame:SetFrameStrata(strata.value)
                    end
                end
            end
            info.checked = function()
                local barID = ExtraBars.selectedBarID
                return barID and ExtraBars.db.bars[barID] and ExtraBars.db.bars[barID].strata == strata.value
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    UIDropDownMenu_Initialize(frame.strataDropdown, InitStrataDropdown)
    
    settingsY = settingsY - 35
    
    -- Tab buttons container
    local tabContainer = CreateFrame("Frame", nil, frame.settingsFrame)
    tabContainer:SetPoint("TOPLEFT", 15, settingsY)
    tabContainer:SetSize(285, 28)
    
    frame.tabButtons = {}
    frame.tabFrames = {}
    
    -- Create tab content frames first
    local tabContentY = settingsY - 30
    
    -- Tab 1: Categories
    local categoriesTab = CreateFrame("Frame", nil, frame.settingsFrame, "BackdropTemplate")
    categoriesTab:SetPoint("TOPLEFT", 15, tabContentY)
    categoriesTab:SetSize(285, 155)
    categoriesTab:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    categoriesTab:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    frame.tabFrames[1] = categoriesTab
    
    -- Tab 2: Inventory
    local inventoryTab = CreateFrame("Frame", nil, frame.settingsFrame, "BackdropTemplate")
    inventoryTab:SetPoint("TOPLEFT", 15, tabContentY)
    inventoryTab:SetSize(285, 155)
    inventoryTab:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    inventoryTab:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    inventoryTab:Hide()
    frame.tabFrames[2] = inventoryTab
    
    -- Tab 3: Order
    local orderTab = CreateFrame("Frame", nil, frame.settingsFrame, "BackdropTemplate")
    orderTab:SetPoint("TOPLEFT", 15, tabContentY)
    orderTab:SetSize(285, 155)
    orderTab:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    orderTab:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    orderTab:Hide()
    frame.tabFrames[3] = orderTab
    
    -- Create tab buttons
    local tab1Btn = CreateTabButton(tabContainer, "Categories", 1, categoriesTab, frame)
    tab1Btn:SetPoint("TOPLEFT", 0, 0)
    frame.tabButtons[1] = tab1Btn
    
    local tab2Btn = CreateTabButton(tabContainer, "Inventory", 2, inventoryTab, frame)
    tab2Btn:SetPoint("LEFT", tab1Btn, "RIGHT", 4, 0)
    frame.tabButtons[2] = tab2Btn
    
    local tab3Btn = CreateTabButton(tabContainer, "Order", 3, orderTab, frame)
    tab3Btn:SetPoint("LEFT", tab2Btn, "RIGHT", 4, 0)
    frame.tabButtons[3] = tab3Btn
    
    -- Tab selection function
    function frame:SelectTab(index)
        for i, btn in ipairs(self.tabButtons) do
            if i == index then
                btn.selected = true
                btn:SetBackdropColor(0, 0.4, 0, 0.9)
                btn.text:SetTextColor(1, 1, 1)
                self.tabFrames[i]:Show()
            else
                btn.selected = false
                btn:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
                btn.text:SetTextColor(0.7, 0.7, 0.7)
                self.tabFrames[i]:Hide()
            end
        end
        self.currentTab = index
        
        -- Refresh the content when switching tabs
        if index == 2 then
            ExtraBars:RefreshInventoryTab()
        elseif index == 3 then
            ExtraBars:RefreshOrderTab()
        end
    end
    
    -- Select first tab by default
    frame:SelectTab(1)
    
    -- ==========================================
    -- TAB 1: Categories Content
    -- ==========================================
    local catScrollFrame = CreateFrame("ScrollFrame", "EBCategoryScrollFrame", categoriesTab, "UIPanelScrollFrameTemplate")
    catScrollFrame:SetPoint("TOPLEFT", 4, -4)
    catScrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)
    
    frame.catContainer = CreateFrame("Frame", nil, catScrollFrame)
    frame.catContainer:SetSize(250, 1)
    catScrollFrame:SetScrollChild(frame.catContainer)
    
    frame.categoryButtons = {}
    local catY = 0
    local totalCategories = 0
    
    for i, catKey in ipairs(ExtraBars.CategoryOrder) do
        totalCategories = totalCategories + 1
        local catData = ExtraBars.Categories[catKey]
        
        local catBtn = CreateFrame("Button", nil, frame.catContainer, "BackdropTemplate")
        catBtn:SetSize(250, 22)
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
                    -- Also add to itemOrder
                    ExtraBars:AddToItemOrder(barID, "category", key)
                end
            else
                for j = #categories, 1, -1 do
                    if categories[j] == key then
                        table.remove(categories, j)
                    end
                end
                -- Also remove from itemOrder
                ExtraBars:RemoveFromItemOrder(barID, "category", key)
            end
            
            ExtraBars:UpdateBar(barID)
            ExtraBars:UpdateConfigPanel()
        end)
        
        -- Hover highlight
        catBtn:EnableMouse(true)
        catBtn:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 0.9)
        end)
        catBtn:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
        end)
        
        frame.categoryButtons[catKey] = catBtn
        catY = catY - 24
    end
    
    frame.catContainer:SetHeight(totalCategories * 24)
    
    -- ==========================================
    -- TAB 2: Inventory Content
    -- ==========================================
    local invLabel = inventoryTab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    invLabel:SetPoint("TOPLEFT", 8, -8)
    invLabel:SetText("Select items from your bags:")
    
    local invScrollFrame = CreateFrame("ScrollFrame", "EBInventoryScrollFrame", inventoryTab, "UIPanelScrollFrameTemplate")
    invScrollFrame:SetPoint("TOPLEFT", 4, -24)
    invScrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)
    
    frame.invContainer = CreateFrame("Frame", nil, invScrollFrame)
    frame.invContainer:SetSize(250, 1)
    invScrollFrame:SetScrollChild(frame.invContainer)
    
    frame.inventoryButtons = {}
    
    -- ==========================================
    -- TAB 3: Order Content
    -- ==========================================
    local orderLabel = orderTab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    orderLabel:SetPoint("TOPLEFT", 8, -8)
    orderLabel:SetText("Drag to reorder (categories & items):")
    
    local orderScrollFrame = CreateFrame("ScrollFrame", "EBOrderScrollFrame", orderTab, "UIPanelScrollFrameTemplate")
    orderScrollFrame:SetPoint("TOPLEFT", 4, -24)
    orderScrollFrame:SetPoint("BOTTOMRIGHT", -26, 4)
    
    frame.orderContainer = CreateFrame("Frame", nil, orderScrollFrame)
    frame.orderContainer:SetSize(250, 1)
    orderScrollFrame:SetScrollChild(frame.orderContainer)
    
    frame.orderButtons = {}
    
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
                barData.anchor = "TOPLEFT"
                barData.position = ExtraBars:GetDefaultPosition()
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

-- Helper to add an item to the bar's itemOrder
function ExtraBars:AddToItemOrder(barID, itemType, key)
    local barData = self.db.bars[barID]
    if not barData then return end
    
    barData.itemOrder = barData.itemOrder or {}
    
    -- Check if already exists
    for _, entry in ipairs(barData.itemOrder) do
        if entry.type == itemType and entry.key == key then
            return
        end
    end
    
    table.insert(barData.itemOrder, { type = itemType, key = key })
end

-- Helper to remove an item from the bar's itemOrder
function ExtraBars:RemoveFromItemOrder(barID, itemType, key)
    local barData = self.db.bars[barID]
    if not barData or not barData.itemOrder then return end
    
    for i = #barData.itemOrder, 1, -1 do
        local entry = barData.itemOrder[i]
        if entry.type == itemType and entry.key == key then
            table.remove(barData.itemOrder, i)
        end
    end
end

-- Refresh the inventory tab with items from bags
function ExtraBars:RefreshInventoryTab()
    local panel = self.configPanel
    if not panel then return end
    
    local barID = self.selectedBarID
    if not barID or not self.db.bars[barID] then return end
    
    local barData = self.db.bars[barID]
    barData.customItems = barData.customItems or {}
    
    -- Clear existing buttons
    for _, btn in pairs(panel.inventoryButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(panel.inventoryButtons)
    
    -- Get all items from bags (only items with on-use effects)
    local rawBagItems = {}
    local seenItems = {}
    
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.itemID and not seenItems[itemInfo.itemID] then
                -- Check if item has on-use effect
                local spellName = GetItemSpell(itemInfo.itemID)
                if spellName then
                    seenItems[itemInfo.itemID] = true
                    local name, _, quality, _, _, _, _, _, _, icon = C_Item.GetItemInfo(itemInfo.itemID)
                    if name then
                        table.insert(rawBagItems, {
                            id = itemInfo.itemID,
                            name = name,
                            baseName = self:GetBaseItemName(name),
                            icon = icon,
                            quality = quality or 1,
                        })
                    end
                end
            end
        end
    end
    
    -- Group items by base name (consolidate ranks)
    local groupedItems = {}
    local groupOrder = {}
    
    for _, item in ipairs(rawBagItems) do
        local baseName = item.baseName
        if not groupedItems[baseName] then
            groupedItems[baseName] = {
                baseName = baseName,
                displayName = baseName,
                icon = item.icon,
                quality = item.quality,
                itemIds = {},
                primaryId = item.id, -- First one found
            }
            table.insert(groupOrder, baseName)
        end
        -- Add this item ID to the group
        table.insert(groupedItems[baseName].itemIds, item.id)
        -- Keep highest quality icon/quality
        if item.quality > groupedItems[baseName].quality then
            groupedItems[baseName].quality = item.quality
            groupedItems[baseName].icon = item.icon
        end
    end
    
    -- Build final list from grouped items
    local bagItems = {}
    for _, baseName in ipairs(groupOrder) do
        table.insert(bagItems, groupedItems[baseName])
    end
    
    -- Sort alphabetically by base name
    table.sort(bagItems, function(a, b)
        return a.baseName < b.baseName
    end)
    
    local invY = 0
    for i, item in ipairs(bagItems) do
        local btn = CreateFrame("Button", nil, panel.invContainer, "BackdropTemplate")
        btn:SetSize(250, 24)
        btn:SetPoint("TOPLEFT", 0, invY)
        btn:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        btn:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
        btn.itemIds = item.itemIds
        btn.baseName = item.baseName
        btn.primaryId = item.primaryId
        
        btn.check = CreateFrame("CheckButton", nil, btn, "UICheckButtonTemplate")
        btn.check:SetSize(22, 22)
        btn.check:SetPoint("LEFT", 2, 0)
        
        btn.iconTexture = btn:CreateTexture(nil, "ARTWORK")
        btn.iconTexture:SetSize(18, 18)
        btn.iconTexture:SetPoint("LEFT", btn.check, "RIGHT", 2, 0)
        btn.iconTexture:SetTexture(item.icon)
        
        btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btn.label:SetPoint("LEFT", btn.iconTexture, "RIGHT", 4, 0)
        btn.label:SetPoint("RIGHT", -8, 0)
        btn.label:SetJustifyH("LEFT")
        -- Show rank count if multiple ranks exist
        local displayText = item.displayName
        if #item.itemIds > 1 then
            displayText = displayText .. " |cff888888(x" .. #item.itemIds .. " ranks)|r"
        end
        btn.label:SetText(displayText)
        
        -- Set quality color
        local r, g, b = C_Item.GetItemQualityColor(item.quality)
        btn.label:SetTextColor(r, g, b)
        
        -- Check if already selected (check by baseName match in customItems)
        local isSelected = false
        for _, customItem in ipairs(barData.customItems) do
            if customItem.baseName == item.baseName then
                isSelected = true
                break
            end
        end
        btn.check:SetChecked(isSelected)
        
        btn.check:SetScript("OnClick", function(self)
            local checked = self:GetChecked()
            local baseName = btn.baseName
            local itemIds = btn.itemIds
            local primaryId = btn.primaryId
            
            if checked then
                -- Add to custom items (store baseName and all item IDs)
                local found = false
                for _, ci in ipairs(barData.customItems) do
                    if ci.baseName == baseName then found = true break end
                end
                if not found then
                    table.insert(barData.customItems, { 
                        id = primaryId, 
                        name = baseName,
                        baseName = baseName,
                        itemIds = itemIds 
                    })
                    ExtraBars:AddToItemOrder(barID, "custom", baseName)
                end
            else
                -- Remove from custom items
                for j = #barData.customItems, 1, -1 do
                    if barData.customItems[j].baseName == baseName then
                        table.remove(barData.customItems, j)
                    end
                end
                ExtraBars:RemoveFromItemOrder(barID, "custom", baseName)
            end
            
            ExtraBars:UpdateBar(barID)
        end)
        
        btn:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.25, 0.25, 0.25, 0.9)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetItemByID(self.primaryId)
            GameTooltip:Show()
        end)
        
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.15, 0.15, 0.15, 0.9)
            GameTooltip:Hide()
        end)
        
        panel.inventoryButtons[i] = btn
        invY = invY - 26
    end
    
    panel.invContainer:SetHeight(math.max(1, #bagItems * 26))
end

-- Refresh the order tab
function ExtraBars:RefreshOrderTab()
    local panel = self.configPanel
    if not panel then return end
    
    local barID = self.selectedBarID
    if not barID or not self.db.bars[barID] then return end
    
    local barData = self.db.bars[barID]
    
    -- Clear existing buttons
    for _, btn in pairs(panel.orderButtons) do
        btn:Hide()
        btn:SetParent(nil)
    end
    wipe(panel.orderButtons)
    
    -- Build the order list from itemOrder or legacy categories+customItems
    local orderList = {}
    
    if barData.itemOrder and #barData.itemOrder > 0 then
        for _, entry in ipairs(barData.itemOrder) do
            table.insert(orderList, entry)
        end
    else
        -- Build from legacy data
        barData.itemOrder = {}
        for _, catKey in ipairs(barData.categories) do
            local entry = { type = "category", key = catKey }
            table.insert(orderList, entry)
            table.insert(barData.itemOrder, entry)
        end
        if barData.customItems then
            for _, customItem in ipairs(barData.customItems) do
                local key = customItem.baseName or customItem.id
                local entry = { type = "custom", key = key }
                table.insert(orderList, entry)
                table.insert(barData.itemOrder, entry)
            end
        end
    end
    
    local orderY = 0
    for i, entry in ipairs(orderList) do
        local btn = CreateFrame("Button", nil, panel.orderContainer, "BackdropTemplate")
        btn:SetSize(250, 24)
        btn:SetPoint("TOPLEFT", 0, orderY)
        btn:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        
        if entry.type == "category" then
            btn:SetBackdropColor(0.1, 0.2, 0.1, 0.9)
        else
            btn:SetBackdropColor(0.2, 0.1, 0.2, 0.9)
        end
        
        btn.orderIndex = i
        btn.entryType = entry.type
        btn.entryKey = entry.key
        
        btn.indexLabel = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btn.indexLabel:SetPoint("LEFT", 8, 0)
        btn.indexLabel:SetText(i .. ".")
        btn.indexLabel:SetTextColor(0.5, 0.5, 0.5)
        
        btn.iconTexture = btn:CreateTexture(nil, "ARTWORK")
        btn.iconTexture:SetSize(18, 18)
        btn.iconTexture:SetPoint("LEFT", btn.indexLabel, "RIGHT", 4, 0)
        
        btn.label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btn.label:SetPoint("LEFT", btn.iconTexture, "RIGHT", 4, 0)
        btn.label:SetPoint("RIGHT", -8, 0)
        btn.label:SetJustifyH("LEFT")
        
        if entry.type == "category" then
            local catData = self.Categories[entry.key]
            btn.iconTexture:SetTexture("Interface\\Icons\\INV_Misc_Bag_10")
            btn.label:SetText(catData and catData.name or entry.key)
            btn.label:SetTextColor(0.5, 1, 0.5)
        else
            -- Custom item - key is baseName, find the customItem data
            local customItem = nil
            if barData.customItems then
                for _, ci in ipairs(barData.customItems) do
                    if ci.baseName == entry.key or ci.id == entry.key then
                        customItem = ci
                        break
                    end
                end
            end
            
            local displayName = entry.key
            local icon = "Interface\\Icons\\INV_Misc_QuestionMark"
            
            if customItem then
                displayName = customItem.baseName or customItem.name
                -- Try to get icon from first available item
                local iconId = customItem.id
                if customItem.itemIds and #customItem.itemIds > 0 then
                    iconId = customItem.itemIds[1]
                end
                local _, _, _, _, _, _, _, _, _, itemIcon = C_Item.GetItemInfo(iconId)
                if itemIcon then
                    icon = itemIcon
                end
            else
                -- Legacy: key might be an item ID
                local name, _, _, _, _, _, _, _, _, itemIcon = C_Item.GetItemInfo(entry.key)
                if name then displayName = name end
                if itemIcon then icon = itemIcon end
            end
            
            btn.iconTexture:SetTexture(icon)
            btn.label:SetText(displayName)
            btn.label:SetTextColor(0.8, 0.6, 1)
        end
        
        -- Drag to reorder
        btn:EnableMouse(true)
        btn:RegisterForDrag("LeftButton")
        
        btn:SetScript("OnDragStart", function(self)
            self.dragging = true
            self:SetBackdropColor(0.4, 0.4, 0, 0.9)
        end)
        
        btn:SetScript("OnDragStop", function(self)
            self.dragging = false
            if self.entryType == "category" then
                self:SetBackdropColor(0.1, 0.2, 0.1, 0.9)
            else
                self:SetBackdropColor(0.2, 0.1, 0.2, 0.9)
            end
        end)
        
        btn:SetScript("OnEnter", function(self)
            if not self.dragging then
                self:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
            end
            -- Check if another button is being dragged
            for _, otherBtn in pairs(panel.orderButtons) do
                if otherBtn.dragging and otherBtn ~= self then
                    ExtraBars:SwapOrderItems(barID, otherBtn.orderIndex, self.orderIndex)
                    otherBtn.dragging = false
                    ExtraBars:RefreshOrderTab()
                    ExtraBars:UpdateBar(barID)
                    return
                end
            end
        end)
        
        btn:SetScript("OnLeave", function(self)
            if not self.dragging then
                if self.entryType == "category" then
                    self:SetBackdropColor(0.1, 0.2, 0.1, 0.9)
                else
                    self:SetBackdropColor(0.2, 0.1, 0.2, 0.9)
                end
            end
        end)
        
        panel.orderButtons[i] = btn
        orderY = orderY - 26
    end
    
    panel.orderContainer:SetHeight(math.max(1, #orderList * 26))
end

-- Swap items in the order list
function ExtraBars:SwapOrderItems(barID, idx1, idx2)
    local barData = self.db.bars[barID]
    if not barData or not barData.itemOrder then return end
    
    if idx1 > 0 and idx1 <= #barData.itemOrder and idx2 > 0 and idx2 <= #barData.itemOrder then
        barData.itemOrder[idx1], barData.itemOrder[idx2] = barData.itemOrder[idx2], barData.itemOrder[idx1]
    end
end

-- Swap category order (for categories tab drag-reorder)
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
        
        -- Also swap in itemOrder
        local itemOrder = self.db.bars[barID].itemOrder
        if itemOrder then
            local orderIdx1, orderIdx2
            for i, entry in ipairs(itemOrder) do
                if entry.type == "category" and entry.key == key1 then orderIdx1 = i end
                if entry.type == "category" and entry.key == key2 then orderIdx2 = i end
            end
            if orderIdx1 and orderIdx2 then
                itemOrder[orderIdx1], itemOrder[orderIdx2] = itemOrder[orderIdx2], itemOrder[orderIdx1]
            end
        end
        
        self:UpdateBar(barID)
        self:UpdateConfigPanel()
    end
end

-- Move category up or down in order (direction: -1 for up, 1 for down)
function ExtraBars:MoveCategoryInOrder(categoryKey, direction)
    local barID = self.selectedBarID
    if not barID or not self.db.bars[barID] then return end
    
    local categories = self.db.bars[barID].categories
    local currentIdx = nil
    
    for i, cat in ipairs(categories) do
        if cat == categoryKey then
            currentIdx = i
            break
        end
    end
    
    if not currentIdx then return end
    
    local newIdx = currentIdx + direction
    if newIdx < 1 or newIdx > #categories then return end
    
    -- Swap with adjacent item
    categories[currentIdx], categories[newIdx] = categories[newIdx], categories[currentIdx]
    
    -- Also swap in itemOrder
    local itemOrder = self.db.bars[barID].itemOrder
    if itemOrder then
        local orderCurrentIdx, orderNewIdx
        local catCount = 0
        for i, entry in ipairs(itemOrder) do
            if entry.type == "category" then
                catCount = catCount + 1
                if entry.key == categoryKey then
                    orderCurrentIdx = i
                end
                if catCount == newIdx and entry.key ~= categoryKey then
                    orderNewIdx = i
                end
            end
        end
        -- Find the entry we're swapping with
        if orderCurrentIdx then
            local swapKey = categories[currentIdx] -- This is now the swapped category
            for i, entry in ipairs(itemOrder) do
                if entry.type == "category" and entry.key == swapKey then
                    orderNewIdx = i
                    break
                end
            end
            if orderNewIdx then
                itemOrder[orderCurrentIdx], itemOrder[orderNewIdx] = itemOrder[orderNewIdx], itemOrder[orderCurrentIdx]
            end
        end
    end
    
    self:UpdateBar(barID)
    self:UpdateConfigPanel()
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
    
    -- Update anchor dropdown
    local anchorLabels = { TOPLEFT = "Top Left", TOPRIGHT = "Top Right", BOTTOMLEFT = "Bottom Left", BOTTOMRIGHT = "Bottom Right" }
    local currentAnchor = barData.anchor
    if type(currentAnchor) ~= "string" then
        currentAnchor = "TOPLEFT"
    end
    UIDropDownMenu_SetText(panel.anchorDropdown, anchorLabels[currentAnchor] or "Top Left")
    
    -- Update strata dropdown
    local strataLabels = { BACKGROUND = "Background", LOW = "Low", MEDIUM = "Medium", HIGH = "High", DIALOG = "Dialog" }
    local currentStrata = barData.strata or "MEDIUM"
    UIDropDownMenu_SetText(panel.strataDropdown, strataLabels[currentStrata] or "Medium")
    
    -- Update category checkboxes
    for catKey, btn in pairs(panel.categoryButtons) do
        local isChecked = false
        for i, cat in ipairs(barData.categories) do
            if cat == catKey then
                isChecked = true
                break
            end
        end
        
        btn.check:SetChecked(isChecked)
    end
    
    -- Refresh inventory and order tabs if visible
    if panel.currentTab == 2 then
        self:RefreshInventoryTab()
    elseif panel.currentTab == 3 then
        self:RefreshOrderTab()
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
    
    -- Set the selected bar directly
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

-- !ExtraBars Data
-- Item and spell definitions for categories

local addonName, ExtraBars = ...

-- Category definitions with display order and items
ExtraBars.Categories = {
    -- Racial Abilities
    RACIALS = {
        name = "Racial Abilities",
        type = "SPELL",
        items = {
            -- Alliance Racials
            { id = 20594, name = "Stoneform" },           -- Dwarf
            { id = 59752, name = "Will to Survive" },     -- Human
            { id = 58984, name = "Shadowmeld" },          -- Night Elf
            { id = 20589, name = "Escape Artist" },       -- Gnome
            { id = 28880, name = "Gift of the Naaru" },   -- Draenei
            { id = 68992, name = "Darkflight" },          -- Worgen
            { id = 255654, name = "Bull Rush" },          -- Highmountain Tauren
            { id = 260364, name = "Arcane Pulse" },       -- Nightborne
            { id = 265221, name = "Fireblood" },          -- Dark Iron Dwarf
            { id = 312411, name = "Bag of Tricks" },      -- Vulpera
            { id = 287712, name = "Haymaker" },           -- Kul Tiran
            { id = 312924, name = "Spatial Rift" },       -- Void Elf
            { id = 256948, name = "Light's Judgment" },   -- Lightforged Draenei
            { id = 69041, name = "Rocket Barrage" },      -- Goblin
            { id = 69070, name = "Rocket Jump" },         -- Goblin
            { id = 107079, name = "Quaking Palm" },       -- Pandaren
            
            -- Horde Racials
            { id = 20572, name = "Blood Fury" },          -- Orc
            { id = 7744, name = "Will of the Forsaken" }, -- Undead
            { id = 20549, name = "War Stomp" },           -- Tauren
            { id = 26297, name = "Berserking" },          -- Troll
            { id = 33697, name = "Blood Fury" },          -- Orc (Caster)
            { id = 33702, name = "Blood Fury" },          -- Orc (AP/SP)
            { id = 28730, name = "Arcane Torrent" },      -- Blood Elf
            { id = 69179, name = "Arcane Torrent" },      -- Blood Elf (RP)
            { id = 80483, name = "Arcane Torrent" },      -- Blood Elf (Focus)
            { id = 129597, name = "Arcane Torrent" },     -- Blood Elf (Chi)
            { id = 155145, name = "Arcane Torrent" },     -- Blood Elf (Holy Power)
            { id = 202719, name = "Arcane Torrent" },     -- Blood Elf (Runic Power)
            { id = 232633, name = "Arcane Torrent" },     -- Blood Elf (Fury)
            { id = 274738, name = "Ancestral Call" },     -- Mag'har Orc
            { id = 291944, name = "Regeneratin'" },       -- Zandalari Troll
            { id = 274740, name = "Ancestral Call" },     -- Mag'har (Rictus)
            
            -- Neutral/Both
            { id = 312916, name = "Adrenaline Rush" },    -- Mechagnome
            { id = 357214, name = "Chosen Ones" },        -- Dracthyr
            { id = 368970, name = "Tail Swipe" },         -- Dracthyr
            { id = 368847, name = "Wing Buffet" },        -- Dracthyr
            { id = 381748, name = "Glide" },              -- Dracthyr
            { id = 358733, name = "Visage" },             -- Dracthyr
            { id = 435576, name = "Guardian of the Grove" }, -- Earthen
            { id = 436090, name = "Azerite Surge" },      -- Earthen
        },
    },
    
    -- Food
    FOOD = {
        name = "Food",
        type = "ITEM",
        items = {
            -- The War Within Food (TWW)
            { id = 222728, name = "Feast of the Divine Day" },
            { id = 222729, name = "Feast of the Midnight Masquerade" },
            { id = 222730, name = "Sizzling Honey Roast" },
            { id = 222731, name = "Angler's Delight" },
            { id = 222732, name = "Beledar's Bounty" },
            { id = 222733, name = "Empress' Farewell" },
            { id = 222734, name = "Jester's Board" },
            { id = 222735, name = "Outsider's Provisions" },
            { id = 222736, name = "Meat and Potatoes" },
            { id = 222737, name = "Fried Stormray" },
            { id = 222738, name = "Roasted Mycbloom" },
            { id = 222739, name = "Exquisitely Eviscerated Muscle" },
            { id = 222740, name = "Salt Baked Seafood" },
            { id = 222741, name = "Deep Fried Icefingers" },
            { id = 222742, name = "Zesty Nibblers" },
            { id = 222743, name = "Unseasoned Field Steak" },
            { id = 222744, name = "Spongey Scramble" },
            { id = 222745, name = "Skewered Fishticks" },
            { id = 222746, name = "Simple Stew" },
            { id = 222747, name = "Cinder Nectar" },
            { id = 222748, name = "Ginger Snaps" },
            { id = 222749, name = "Sweet and Sour Meatballs" },
            { id = 222750, name = "Pan Seared Mycbloom" },
            { id = 222751, name = "Flash Fire Fillet" },
            { id = 222752, name = "Coreway Kabob" },
            { id = 222753, name = "Salty Dog" },
            { id = 222754, name = "Chippy Tea" },
            { id = 222755, name = "Everything Stew" },
            { id = 222756, name = "Hearty Stew" },
            
            -- Dragonflight Food
            { id = 197784, name = "Grand Banquet of the Kalu'ak" },
            { id = 197786, name = "Hoard of Draconic Delicacies" },
            { id = 197758, name = "Timely Demise" },
            { id = 197759, name = "Filet of Fangs" },
            { id = 197760, name = "Seamoth Surprise" },
            { id = 197761, name = "Salt-Baked Fishcake" },
            { id = 197762, name = "Feisty Fish Sticks" },
            { id = 197763, name = "Aromatic Seafood Platter" },
            { id = 197764, name = "Sizzling Seafood Medley" },
            { id = 197765, name = "Revenge, Served Cold" },
            { id = 197766, name = "Thousandbone Tongueslicer" },
            { id = 197767, name = "Great Cerulean Sea" },
            { id = 197768, name = "Braised Bruffalon Brisket" },
            { id = 197769, name = "Riverside Picnic" },
            { id = 197770, name = "Roast Duck Delight" },
            { id = 197771, name = "Salted Meat Mash" },
            { id = 197772, name = "Thrice-Spiced Mammoth Kabob" },
            { id = 197773, name = "Hopefully Healthy" },
            { id = 197774, name = "Yusa's Hearty Stew" },
            { id = 197775, name = "Delicious Dragon Spittle" },
            { id = 197776, name = "Cheeseburger" },
            { id = 197777, name = "Sweet and Sour Clam Chowder" },
            { id = 197778, name = "Breakfast of Draconic Champions" },
        },
    },
    
    -- Drinks/Mana
    DRINKS = {
        name = "Drinks",
        type = "ITEM",
        items = {
            -- TWW Drinks
            { id = 222720, name = "Algari Mana Oil" },
            
            -- Dragonflight
            { id = 197779, name = "Potion Absorption Inhibitor" },
            
            -- Generic Drinks
            { id = 159867, name = "Rockskip Mineral Water" },
            { id = 178222, name = "Purified Skyspring Water" },
            { id = 194684, name = "Azure Leywine" },
            { id = 194686, name = "Delicate Hundredfield Tea" },
        },
    },
    
    -- Flasks/Phials
    FLASKS = {
        name = "Flasks/Phials",
        type = "ITEM",
        items = {
            -- TWW Flasks
            { id = 212283, name = "Flask of Alchemical Chaos" },
            { id = 212266, name = "Flask of Tempered Aggression" },
            { id = 212270, name = "Flask of Tempered Mastery" },
            { id = 212265, name = "Flask of Tempered Swiftness" },
            { id = 212269, name = "Flask of Tempered Versatility" },
            { id = 212280, name = "Flask of Saving Graces" },
            
            -- Dragonflight Phials
            { id = 191318, name = "Phial of Static Empowerment" },
            { id = 191319, name = "Phial of Still Air" },
            { id = 191320, name = "Phial of the Eye in the Storm" },
            { id = 191321, name = "Phial of Charged Isolation" },
            { id = 191322, name = "Phial of Glacial Fury" },
            { id = 191323, name = "Phial of Icy Preservation" },
            { id = 191324, name = "Iced Phial of Corrupting Rage" },
            { id = 191325, name = "Phial of Tepid Versatility" },
            { id = 191326, name = "Steaming Phial of Finesse" },
            { id = 191327, name = "Charged Phial of Alacrity" },
            { id = 191328, name = "Phial of Elemental Chaos" },
            { id = 191329, name = "Phial of the Eye in the Storm" },
            { id = 191330, name = "Crystalline Phial of Perception" },
            { id = 191331, name = "Phial of Chilling Might" },
            { id = 191332, name = "Phial of Tempered Wrath" },
            { id = 191333, name = "Steaming Phial of Finesse" },
            { id = 191334, name = "Aerated Phial of Quick Hands" },
            { id = 191335, name = "Phial of the Bonfire" },
            { id = 191336, name = "Phial of Crackling Calamity" },
            { id = 191337, name = "Phial of Tempered Persistence" },
            { id = 191338, name = "Phial of Ultimate Power" },
            { id = 191339, name = "Phial of Tepid Endurance" },
            { id = 191340, name = "Dewy Phial of Ravenous Slumber" },
        },
    },
    
    -- Health Potions
    HEALTH_POTIONS = {
        name = "Health Potions",
        type = "ITEM",
        showBestOnly = true, -- Only show the best available healing potion
        items = {
            -- The War Within Health Potions (all ranks) - priority determines which is "best"
            { id = 211878, name = "Invigorating Healing Potion", priority = 100, group = "invigorating" },
            { id = 211879, name = "Invigorating Healing Potion R2", priority = 101, group = "invigorating" },
            { id = 211880, name = "Invigorating Healing Potion R3", priority = 102, group = "invigorating" },
            { id = 212239, name = "Algari Healing Potion", priority = 90, group = "algari" },
            { id = 212240, name = "Algari Healing Potion R2", priority = 91, group = "algari" },
            { id = 212241, name = "Algari Healing Potion R3", priority = 92, group = "algari" },
            { id = 212234, name = "Cavedweller's Delight", priority = 80, group = "cavedweller" },
            { id = 212235, name = "Cavedweller's Delight R2", priority = 81, group = "cavedweller" },
            { id = 212236, name = "Cavedweller's Delight R3", priority = 82, group = "cavedweller" },
            { id = 212237, name = "Slumbering Soul Serum", priority = 70, group = "slumbering" },
            { id = 212238, name = "Slumbering Soul Serum R2", priority = 71, group = "slumbering" },
            { id = 212242, name = "Slumbering Soul Serum R3", priority = 72, group = "slumbering" },
            -- TWW Warband versions
            { id = 224464, name = "Algari Healing Potion (Warband)", priority = 93, group = "algari" },
            
            -- Dragonflight Health Potions
            { id = 191378, name = "Refreshing Healing Potion", priority = 60, group = "refreshing" },
            { id = 191379, name = "Refreshing Healing Potion R2", priority = 61, group = "refreshing" },
            { id = 191380, name = "Refreshing Healing Potion R3", priority = 62, group = "refreshing" },
            { id = 207023, name = "Dreamwalker's Healing Potion", priority = 65, group = "dreamwalker" },
            { id = 207039, name = "Dreamwalker's Healing Potion R2", priority = 66, group = "dreamwalker" },
            { id = 207040, name = "Dreamwalker's Healing Potion R3", priority = 67, group = "dreamwalker" },
            
            -- Shadowlands Health Potions
            { id = 171267, name = "Spiritual Healing Potion", priority = 50, group = "spiritual" },
            { id = 187802, name = "Cosmic Healing Potion", priority = 55, group = "cosmic" },
            
            -- Battle for Azeroth Health Potions
            { id = 169451, name = "Abyssal Healing Potion", priority = 45, group = "abyssal" },
            { id = 152494, name = "Coastal Healing Potion", priority = 40, group = "coastal" },
            
            -- Legion Health Potions
            { id = 127834, name = "Ancient Healing Potion", priority = 35, group = "ancient" },
            { id = 127835, name = "Ancient Rejuvenation Potion", priority = 36, group = "ancient_rejuv" },
            
            -- Classic/Generic Health Potions
            { id = 118, name = "Minor Healing Potion", priority = 1, group = "minor" },
            { id = 858, name = "Lesser Healing Potion", priority = 5, group = "lesser" },
            { id = 929, name = "Healing Potion", priority = 10, group = "basic" },
            { id = 1710, name = "Greater Healing Potion", priority = 15, group = "greater" },
            { id = 3928, name = "Superior Healing Potion", priority = 20, group = "superior" },
            { id = 13446, name = "Major Healing Potion", priority = 25, group = "major" },
            { id = 33447, name = "Runic Healing Potion", priority = 30, group = "runic" },
            
            -- Healthstones (Warlock) - Always show separately
            { id = 5512, name = "Healthstone", priority = 200, group = "healthstone" },
        },
    },
    
    -- Combat Potions
    COMBAT_POTIONS = {
        name = "Combat Potions",
        type = "ITEM",
        items = {
            -- The War Within Combat Potions (all ranks)
            { id = 212259, name = "Tempered Potion" },
            { id = 212260, name = "Tempered Potion R2" },
            { id = 212261, name = "Tempered Potion R3" },
            { id = 212263, name = "Potion of Unwavering Focus" },
            { id = 212264, name = "Potion of Unwavering Focus R2" },
            { id = 212265, name = "Potion of Unwavering Focus R3" },
            { id = 212243, name = "Frontline Potion" },
            { id = 212244, name = "Frontline Potion R2" },
            { id = 212245, name = "Frontline Potion R3" },
            { id = 212246, name = "Potion of the Reborn Cheetah" },
            { id = 212247, name = "Potion of the Reborn Cheetah R2" },
            { id = 212248, name = "Potion of the Reborn Cheetah R3" },
            { id = 212249, name = "Treading Lightly" },
            { id = 212250, name = "Treading Lightly R2" },
            { id = 212251, name = "Treading Lightly R3" },
            { id = 212252, name = "Grotesque Vial" },
            { id = 212253, name = "Grotesque Vial R2" },
            { id = 212254, name = "Grotesque Vial R3" },
            { id = 212255, name = "Draught of Shocking Revelations" },
            { id = 212256, name = "Draught of Shocking Revelations R2" },
            { id = 212257, name = "Draught of Shocking Revelations R3" },
            { id = 212268, name = "Draught of Silent Footfalls" },
            { id = 212271, name = "Draught of Silent Footfalls R2" },
            { id = 212272, name = "Draught of Silent Footfalls R3" },
            
            -- TWW Mana Potions
            { id = 212229, name = "Algari Mana Potion" },
            { id = 212230, name = "Algari Mana Potion R2" },
            { id = 212231, name = "Algari Mana Potion R3" },
            
            -- Dragonflight
            { id = 191383, name = "Elemental Potion of Ultimate Power" },
            { id = 191389, name = "Elemental Potion of Power" },
            { id = 191393, name = "Aerated Mana Potion" },
            { id = 191399, name = "Potion of Shocking Disclosure" },
            { id = 191401, name = "Potion of the Hushed Zephyr" },
            { id = 191905, name = "Fleeting Elemental Potion of Ultimate Power" },
            { id = 191906, name = "Fleeting Elemental Potion of Power" },
            { id = 191914, name = "Bottled Putrescence" },
            { id = 191915, name = "Potion of Frozen Fatality" },
            { id = 191916, name = "Delicate Suspension of Spores" },
            { id = 191917, name = "Potion of Chilled Clarity" },
            { id = 191918, name = "Potion of Withering Dreams" },
            { id = 191919, name = "Residual Neural Channeling Agent" },
        },
    },
    
    -- Utility Items
    UTILITY = {
        name = "Utility",
        type = "ITEM",
        items = {
            -- Engineering
            { id = 109076, name = "Goblin Glider Kit" },
            { id = 198159, name = "Wyrmhole Generator" },
            { id = 221839, name = "Algari Repair Bot" },
            
            -- Consumables
            { id = 6948, name = "Hearthstone" },
            { id = 140192, name = "Dalaran Hearthstone" },
            { id = 110560, name = "Garrison Hearthstone" },
            
            -- Drums
            { id = 219905, name = "Reverberating Drums" },
            { id = 193470, name = "Feral Hide Drums" },
            
            -- Augment Runes
            { id = 211495, name = "Crystallized Augment Rune" },
            { id = 201325, name = "Draconic Augment Rune" },
            
            -- Weapon Buffs
            { id = 222503, name = "Algari Mana Oil" },
            { id = 222504, name = "Oil of Deep Toxins" },
            { id = 222506, name = "Bubbling Wax" },
            { id = 191933, name = "Howling Rune" },
            { id = 194823, name = "Buzzing Rune" },
            { id = 194824, name = "Chirping Rune" },
            { id = 194825, name = "Hissing Rune" },
        },
    },
    
    -- Equipped Trinkets (on-use only)
    TRINKETS = {
        name = "Trinkets",
        type = "EQUIPPED",
        slots = { 13, 14 }, -- Trinket slot IDs
        items = {}, -- Dynamically populated from equipped items
    },
}

-- Category display order
ExtraBars.CategoryOrder = {
    "RACIALS",
    "FOOD",
    "DRINKS",
    "FLASKS",
    "HEALTH_POTIONS",
    "COMBAT_POTIONS",
    "UTILITY",
    "TRINKETS",
}

-- Helper function to check if player knows a spell
function ExtraBars:PlayerKnowsSpell(spellID)
    return IsSpellKnown(spellID) or IsPlayerSpell(spellID)
end

-- Helper function to check if an item has an on-use effect
function ExtraBars:ItemHasOnUse(itemID)
    if not itemID then return false end
    local spellName = GetItemSpell(itemID)
    return spellName ~= nil
end

-- Helper function to get equipped trinkets with on-use effects
function ExtraBars:GetEquippedOnUseTrinkets()
    local trinkets = {}
    local slots = { 13, 14 } -- Trinket 1 and Trinket 2
    
    for _, slotID in ipairs(slots) do
        local itemID = GetInventoryItemID("player", slotID)
        if itemID and self:ItemHasOnUse(itemID) then
            local itemName = C_Item.GetItemInfo(itemID)
            if itemName then
                table.insert(trinkets, {
                    id = itemID,
                    name = itemName,
                    type = "ITEM",
                    slotID = slotID,
                })
            end
        end
    end
    
    return trinkets
end

-- Helper function to check if player has an item
function ExtraBars:PlayerHasItem(itemID)
    return C_Item.GetItemCount(itemID, true, false) > 0
end

-- Get items for a category that the player can use
function ExtraBars:GetAvailableItemsForCategory(categoryKey)
    local category = self.Categories[categoryKey]
    if not category then return {} end
    
    -- Handle equipped items (trinkets)
    if category.type == "EQUIPPED" then
        return self:GetEquippedOnUseTrinkets()
    end
    
    local available = {}
    local bestByGroup = {} -- Track best item per group for showBestOnly categories
    
    for _, item in ipairs(category.items) do
        local isAvailable = false
        
        if category.type == "SPELL" then
            isAvailable = self:PlayerKnowsSpell(item.id)
        elseif category.type == "ITEM" then
            isAvailable = self:PlayerHasItem(item.id)
        end
        
        if isAvailable then
            local itemData = {
                id = item.id,
                name = item.name,
                type = category.type,
                priority = item.priority or 0,
                group = item.group,
            }
            
            -- If this category shows best only, track by group
            if category.showBestOnly and item.group then
                if not bestByGroup[item.group] or itemData.priority > bestByGroup[item.group].priority then
                    bestByGroup[item.group] = itemData
                end
            else
                table.insert(available, itemData)
            end
        end
    end
    
    -- For showBestOnly categories, find the single best item across all groups
    if category.showBestOnly then
        local bestItem = nil
        for _, item in pairs(bestByGroup) do
            if not bestItem or item.priority > bestItem.priority then
                bestItem = item
            end
        end
        if bestItem then
            table.insert(available, bestItem)
        end
    end
    
    return available
end

-- Get all available items for a bar based on its category configuration
function ExtraBars:GetAllAvailableItemsForBar(barID)
    local barData = self.db.bars[barID]
    if not barData then return {} end
    
    local allItems = {}
    
    -- Check if we have custom item ordering
    if barData.itemOrder and #barData.itemOrder > 0 then
        -- Use the ordered list
        for _, orderEntry in ipairs(barData.itemOrder) do
            if orderEntry.type == "category" then
                -- Get items from the category
                local items = self:GetAvailableItemsForCategory(orderEntry.key)
                for _, item in ipairs(items) do
                    item.category = orderEntry.key
                    table.insert(allItems, item)
                end
            elseif orderEntry.type == "custom" then
                -- Find the custom item by baseName (key is now baseName)
                local customItem = nil
                if barData.customItems then
                    for _, ci in ipairs(barData.customItems) do
                        if ci.baseName == orderEntry.key or ci.id == orderEntry.key then
                            customItem = ci
                            break
                        end
                    end
                end
                
                if customItem then
                    -- Check if player has any of the ranked items
                    local availableId = nil
                    if customItem.itemIds then
                        -- New format: check all item IDs
                        for _, itemId in ipairs(customItem.itemIds) do
                            if self:PlayerHasItem(itemId) then
                                availableId = itemId
                                break
                            end
                        end
                    else
                        -- Legacy format: single item ID
                        if self:PlayerHasItem(customItem.id) then
                            availableId = customItem.id
                        end
                    end
                    
                    if availableId then
                        local itemName = C_Item.GetItemInfo(availableId)
                        if itemName then
                            table.insert(allItems, {
                                id = availableId,
                                name = itemName,
                                type = "ITEM",
                                category = "CUSTOM",
                            })
                        end
                    end
                end
            end
        end
    else
        -- Legacy: use categories in order
        for _, categoryKey in ipairs(barData.categories) do
            local items = self:GetAvailableItemsForCategory(categoryKey)
            for _, item in ipairs(items) do
                item.category = categoryKey
                table.insert(allItems, item)
            end
        end
        
        -- Also add custom items if any (legacy support)
        if barData.customItems then
            for _, customItem in ipairs(barData.customItems) do
                local availableId = nil
                if customItem.itemIds then
                    -- New format: check all item IDs
                    for _, itemId in ipairs(customItem.itemIds) do
                        if self:PlayerHasItem(itemId) then
                            availableId = itemId
                            break
                        end
                    end
                else
                    -- Legacy format: single item ID
                    if self:PlayerHasItem(customItem.id) then
                        availableId = customItem.id
                    end
                end
                
                if availableId then
                    local itemName = C_Item.GetItemInfo(availableId)
                    if itemName then
                        table.insert(allItems, {
                            id = availableId,
                            name = itemName,
                            type = "ITEM",
                            category = "CUSTOM",
                        })
                    end
                end
            end
        end
    end
    
    return allItems
end

----------------------------------------------------------------------------------
-- Total RP 3: Inventory system
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local assert, tostring, tinsert, wipe, pairs = assert, tostring, tinsert, wipe, pairs;
local getItemClass = TRP3_API.inventory.getItemClass;
local EMPTY = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTILS func
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isContainerByClass(item)
	return item and item.CO;
end

local function isContainerByClassID(itemID)
	return itemID == "main" or isContainerByClass(getItemClass(itemID));
end

local function getBaseClassDateSafe(itemClass)
	local icon = "TEMP";
	local name = UNKNOWN;
	if itemClass and itemClass.BA then
		if itemClass.BA.IC then
			icon = itemClass.BA.IC;
		end
		if itemClass.BA.NA then
			name = itemClass.BA.NA;
		end
	end
	return icon, name;
end

local function getItemTextLine(itemClass)
	local icon, name = getBaseClassDateSafe(itemClass);
	return Utils.str.icon(icon, 25) .. " " .. name;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INVENTORY MANAGEMENT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local playerInventory;
local CONTAINER_SLOT_MAX = 1000;

--- Add an item to a container.
-- Returns:
-- 0 if OK
-- 1 if container full
-- 2 if too many item already possessed (unique)
function TRP3_API.inventory.addItem(container, itemID, itemData)
	-- Checking data
	local container = container or playerInventory;
	assert(isContainerByClassID(container.id), "Is not a container ! ID: " .. tostring(container.id));
	local itemClass = getItemClass(itemID);
	assert(itemClass, "Unknown item class: " .. tostring(itemID));
	if not container.content then
		container.content = {};
	end
	itemData = itemData or EMPTY;

	-- Finding an empty slot
	local slot = itemData.containerSlot;
	if not slot then
		for i = 1, CONTAINER_SLOT_MAX do
			if not container.content[tostring(i)] then
				slot = tostring(i);
				break;
			end
		end
	end
	if not slot then
		-- Container is full
		return 1;
	end

	-- Adding item instance
	if container.content[slot] then
		assert(container.content[slot].id == itemID, ("Mismatch itemID in slot %s: %s vs %s"):format(slot, container.content[slot].id, itemID));
		container.content[slot].count = container.content[slot].count + (itemData.count or 1);
	else
		container.content[slot] = {
			id = itemID,
			count = itemData.count or 1,
			instanceId = Utils.str.id(),
		};
	end

	return 0;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: BAGS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CreateFrame, ToggleFrame = CreateFrame, ToggleFrame;

local function containerFrameUpdate(self, elapsed)
	if not self.info or not self.class then return end
	-- Durability
	local durability = "";
	if self.class.CO.DU and self.class.CO.DU > 0 then
		local max = self.class.CO.DU;
		local current = self.info.durability or self.class.CO.DU;
		durability = (Utils.str.texture("Interface\\GROUPFRAME\\UI-GROUP-MAINTANKICON", 15) .. "%s/%s"):format(current, max);
	end
	self.DurabilityText:SetText(durability);

	-- Weight
	local current = self.info.totalWeight or 0;
	local weight = ("%s kg" .. Utils.str.texture("Interface\\GROUPFRAME\\UI-Group-MasterLooter", 15)):format(current);
	if self.class.CO.MW and self.class.CO.MW > 0 then
		-- TODO: color if too heavy
	end
	self.WeightText:SetText(weight);
end

local function decorateContainer(containerFrame, class, container)
	local icon, name = getBaseClassDateSafe(class);
	containerFrame.Icon:SetTexture("Interface\\ICONS\\" .. icon);
	containerFrame.Title:SetText(name);
end

local COLUMN_SPACING = 43;
local ROW_SPACING = 42;
local function initContainerSlots(container, rowCount, colCount)
	local slotNum = 1;
	local rowY = -58;
	for row = 1, rowCount do
		local colX = 22;
		for col = 1, colCount do
			local slot = CreateFrame("Button", container:GetName() .. "Slot" .. slotNum, container, "TRP3_BagSlotTemplate");
			container["Slot" .. slotNum] = slot;
			slot:SetPoint("TOPLEFT", colX, rowY);
			slot:Show();
			colX = colX + COLUMN_SPACING;
			slotNum = slotNum + 1;
		end
		rowY = rowY - ROW_SPACING;
	end
end

local containerInstances5x4 = {};
local CONTAINER_UPDATE_FREQUENCY = 0.5;
local function getContainerInstance(size, instanceId)
	if not size or size == "5x4" then
		local count = 0;
		local containerFrame, available;
		for _, ref in pairs(containerInstances5x4) do
			count = count + 1;
			if not ref:IsVisible() then
				available = ref;
			end
			if ref:IsVisible() and ref.instanceId == instanceId then
				containerFrame = ref;
				break;
			end
		end
		if containerFrame then -- If a container is already visible for this instance
			return containerFrame;
		end
		if available then -- If there is available frame in the pool
			containerFrame = available;
		else -- Else: we create a new one
			containerFrame = CreateFrame("Frame", "TRP3_Container5x4_" .. (count + 1), nil, "TRP3_Container5x4Template");
			TRP3_API.ui.frame.createRefreshOnFrame(containerFrame, CONTAINER_UPDATE_FREQUENCY, containerFrameUpdate);
			initContainerSlots(containerFrame, 5, 4);
			tinsert(containerInstances5x4, containerFrame);
		end
		containerFrame.instanceId = instanceId;
		return containerFrame;
	end
end

local function switchContainerByRef(container)
	local instanceId = container.instanceId;
	local class = getItemClass(container.id);
	local containerFrame = getContainerInstance(class.CO.SI, instanceId);
	ToggleFrame(containerFrame);
	if containerFrame:IsVisible() then
		decorateContainer(containerFrame, class, container);
		containerFrame.info = container;
		containerFrame.class = class;
	end
end

local function switchContainerBySlotID(parentContainer, slotID)
	assert(parentContainer, "Nil parent container.");
	assert(parentContainer.content[slotID], "Empty slot.");
	assert(parentContainer.content[slotID].id, "Container without id for slot: " .. tostring(slotID));
	switchContainerByRef(parentContainer.content[slotID]);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local displayDropDown = TRP3_API.ui.listbox.displayDropDown;

local playerInvText = ("%s's inventory"):format(Globals.player);
local PLAYER_INV_BUTTON_MAX_ENTRIES = 10;

local function playerInventoryButtonSelection(selectedSlot)
	if selectedSlot == 0 then
		message("Opening all inventory");
	elseif playerInventory.content[selectedSlot] then -- Check again, as maybe the slot was deleted
		local classID = playerInventory.content[selectedSlot].id;
		local class = getItemClass(classID);
		if isContainerByClass(class) then
			switchContainerBySlotID(playerInventory, selectedSlot);
		else
			message("Using item");
		end
	end
end

local dropdownItems = {};
local function playerInventoryButtonClick(button)
	wipe(dropdownItems);
	tinsert(dropdownItems,{playerInvText, nil});
	tinsert(dropdownItems,{"Show all inventory", 0}); -- TODO: locals
	local i = 1;
	local found = 0;
	while i <= CONTAINER_SLOT_MAX and found <= PLAYER_INV_BUTTON_MAX_ENTRIES do
		local slot = tostring(i);
		if playerInventory.content[slot] then
			local classID = playerInventory.content[slot].id;
			local class = getItemClass(classID);
			tinsert(dropdownItems,{getItemTextLine(class), slot});
			found = found + 1;
		end
		i = i + 1;
	end
	displayDropDown(button, dropdownItems, playerInventoryButtonSelection, 0, true);
end

local function initPlayerInventoryButton()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_d_inventory",
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			configText = playerInvText,
			condition = function(targetType, unitID)
				return unitID == Globals.player_id;
			end,
			onClick = function(unitID, _, _, button)
				playerInventoryButtonClick(button);
			end,
			tooltip = playerInvText,
			tooltipSub = "Click: Show content", -- TODO: locals
			icon = "inv_misc_bag_16"
		});
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function initPlayerInventory()
	-- Structures
	local playerProfile = TRP3_API.profile.getPlayerCurrentProfile();
	if not playerProfile.inventory then
		playerProfile.inventory = {};
	end
	playerInventory = playerProfile.inventory;
	playerInventory.id = "main";
	if not playerInventory.content then
		playerInventory.content = {};
	end

	-- UI
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		initPlayerInventoryButton();
	end);
end

local function onStart()
	initPlayerInventory();
end

local MODULE_STRUCTURE = {
	["name"] = "Inventory",
	["description"] = "Inventory system for characters and companions",
	["version"] = 1.000,
	["id"] = "trp3_inventory",
	["onStart"] = onStart,
	["minVersion"] = 12,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
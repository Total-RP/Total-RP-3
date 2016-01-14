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
local _G, assert, tostring, tinsert, wipe, pairs = _G, assert, tostring, tinsert, wipe, pairs;
local getClass, isContainerByClassID, isUsableByClass = TRP3_API.extended.getClass, TRP3_API.inventory.isContainerByClassID, TRP3_API.inventory.isUsableByClass;
local isContainerByClass, getItemTextLine = TRP3_API.inventory.isContainerByClass, TRP3_API.inventory.getItemTextLine;
local checkContainerInstance, countItemInstances = TRP3_API.inventory.checkContainerInstance, TRP3_API.inventory.countItemInstances;
local getItemLink = TRP3_API.inventory.getItemLink;
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INVENTORY MANAGEMENT API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local playerInventory;
local CONTAINER_SLOT_MAX = 20;
TRP3_API.inventory.CONTAINER_SLOT_MAX = CONTAINER_SLOT_MAX;

local function onItemAddEnd(...)
	TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, container);
	TRP3_API.inventory.recomputeAllInventory();
	return ...;
end

--- Add an item to a container.
-- Returns:
-- 0 if OK
-- 1 if container full
-- 2 if too many item already possessed (unique)
function TRP3_API.inventory.addItem(givenContainer, classID, itemData)
	-- Checking data
	local container = givenContainer or playerInventory;
	local containerClass = getClass(container.id);
	assert(isContainerByClassID(container.id), "Is not a container ! ID: " .. tostring(container.id));
	local itemClass = getClass(classID);

	checkContainerInstance(container);
	itemData = itemData or EMPTY;

	local slot;
	local ret;
	local toAdd = itemData.count or 1;

	for count = 0, toAdd - 1 do
		local freeSlot, stackSlot;

		-- Check unicity
		if itemClass.UN then
			local currentCount = countItemInstances(playerInventory, classID);
			if currentCount + 1 > itemClass.UN then
				Utils.message.displayMessage(loc("IT_INV_ERROR_MAX"):format(getItemLink(itemClass)), Utils.message.type.ALERT_MESSAGE);
				return onItemAddEnd(2, count);
			end
		end

		-- Finding an empty slot
		for i = 1, ((containerClass.CO.SR or 5) * (containerClass.CO.SC or 4)) do
			local slotID = tostring(i);
			if not freeSlot and not container.content[slotID] then
				freeSlot = slotID;
			elseif container.content[slotID] and itemClass.ST and classID == container.content[slotID].id then
				local expectedCount = (container.content[slotID].count or 1) + 1;
				if expectedCount <= (itemClass.ST.MA or 1) then
					stackSlot = slotID;
					break;
				end
			end
		end

		slot = stackSlot or freeSlot;

		-- Container is full
		if not slot then
			if givenContainer then
				Utils.message.displayMessage(loc("IT_INV_ERROR_FULL"):format(getItemLink(containerClass)), Utils.message.type.ALERT_MESSAGE);
			else
				Utils.message.displayMessage(ERR_INV_FULL, Utils.message.type.ALERT_MESSAGE);
			end
			return onItemAddEnd(1, count);
		end

		-- Adding item
		if not container.content[slot] then
			container.content[slot] = {
				id = classID,
			};
			if itemClass.CO and itemClass.CO.IT then
				container.content[slot].content = {};
				Utils.table.copy(container.content[slot].content, itemClass.CO.IT);
			end
			if itemData.madeBy then
				container.content[slot].madeBy = Globals.player_id;
			end
		end
		if stackSlot then
			container.content[slot].count = (container.content[slot].count or 1) + 1;
		end

	end

	return onItemAddEnd(0, toAdd);

end

function TRP3_API.inventory.getItem(container, slotID)
	-- Checking data
	local container = container or playerInventory;
	assert(isContainerByClassID(container.id), "Is not a container ! ID: " .. tostring(container.id));
	checkContainerInstance(container);
	return container.content[slotID];
end

local function swapContainersSlots(container1, slot1, container2, slot2)
	assert(container1 and slot1, "Missing 'from' container/slot");
	assert(container2 and slot2, "Missing 'to' container/slot");
	checkContainerInstance(container2);

	local slot1Data = container1.content[slot1];
	local slot2Data = container2.content[slot2];
	local done;

	if slot2Data and slot1Data.id == slot2Data.id and getClass(slot1Data.id).ST then
		local stackMax = getClass(slot1Data.id).ST.MA or 1;
		local availableOnTarget = stackMax - (slot2Data.count or 1);
		if availableOnTarget > 0 then
			local canBeMoved = math.min(availableOnTarget, slot1Data.count or 1);
			slot1Data.count = (slot1Data.count or 1) - canBeMoved;
			slot2Data.count = (slot2Data.count or 1) + canBeMoved;
			if slot1Data.count == 0 then
				wipe(container1.content[slot1]);
				container1.content[slot1] = nil;
			end
			done = true;
		end
	end

	if not done then
		if TRP3_API.inventory.isItemInContainer(container2, slot1Data) or TRP3_API.inventory.isItemInContainer(container1, slot2Data) then
			Utils.message.displayMessage(loc("IT_CON_CAN_INNER"), Utils.message.type.ALERT_MESSAGE);
			return;
		end

		container2.content[slot2] = slot1Data;
		container1.content[slot1] = slot2Data;
	end

	TRP3_API.inventory.recomputeAllInventory();
	TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, container1);
	if container1 ~= container2 then
		TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, container2);
	end
end

local function useContainerSlot(slotButton, containerFrame)
	if slotButton.info then
		if slotButton.class.missing then -- If using a missing item : remove it
			TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_DETACH_SLOT, slotButton.info);
			if containerFrame.info.content[slotButton.slotID] then
				wipe(containerFrame.info.content[slotButton.slotID]);
			end
			containerFrame.info.content[slotButton.slotID] = nil;
		elseif slotButton.class and isUsableByClass(slotButton.class) then
			local retCode = TRP3_API.script.executeClassScript(slotButton.class.US.SC, slotButton.class.SC, {class = slotButton.class, slotInfo = slotButton.info, containerInfo = containerFrame.info});
		end
	end
end

function TRP3_API.inventory.consumeItem(slotInfo, containerInfo, quantity) -- Et grominet :D
	if slotInfo and containerInfo then
		slotInfo.count = math.max((slotInfo.count or 1) - quantity, 0);
		if slotInfo.count == 0 then
			for slotIndex, slot in pairs(containerInfo.content) do
				if slot == slotInfo then
					wipe(containerInfo.content[slotIndex]);
					containerInfo.content[slotIndex] = nil;
					TRP3_API.inventory.recomputeAllInventory();
					TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, containerInfo);
				end
			end
		end
	end
end

function TRP3_API.inventory.changeContainerDurability(containerInfo, durabilityChange)
	if containerInfo and containerInfo.id and isContainerByClassID(containerInfo.id) then
		local class = getClass(containerInfo.id);
		if class.CO.DU and class.CO.DU > 0 then
			durabilityChange = durabilityChange or 0;
			if not containerInfo.durability then -- init from class info
				containerInfo.durability = class.CO.DU;
			end
			local old = containerInfo.durability;
			containerInfo.durability = containerInfo.durability + durabilityChange;
			containerInfo.durability = math.min(math.max(containerInfo.durability, 0), class.CO.DU);
			if old == containerInfo.durability then
				return 1;
			end
			return 0;
		end
	end
end

local function removeSlotContent(container, slotID, slotInfo)
	-- Check that nothing has changed
	if container.content[slotID] == slotInfo then
		wipe(container.content[slotID]);
		container.content[slotID] = nil;
		TRP3_API.inventory.recomputeAllInventory();
		TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, container);
	end
end

local function splitSlot(slot, container, quantity)
	local containerClass = getClass(container.id);

	local emptySlotID;
	-- Finding an empty slot
	for i = 1, ((containerClass.CO.SR or 5) * (containerClass.CO.SC or 4)) do
		local slotID = tostring(i);
		if not container.content[slotID] then
			emptySlotID = slotID;
			break;
		end
	end

	if not emptySlotID then
		Utils.message.displayMessage(ERR_BAG_FULL, Utils.message.type.ALERT_MESSAGE);
		return;
	end

	container.content[emptySlotID] = {
		count = quantity,
		id = slot.id
	};

	slot.count = slot.count - quantity;

	TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_REFRESH_BAG, container);
end

function TRP3_API.inventory.getInventory()
	-- Structures
	local playerProfile = TRP3_API.profile.getPlayerCurrentProfile();
	if not playerProfile.inventory then
		playerProfile.inventory = {};
	end
	local playerInventory = playerProfile.inventory;
	playerInventory.id = "main";
	if not playerInventory.content then
		playerInventory.content = {};
	end
	return playerInventory;
end

local function recomputeContainerWeight(container)
	assert(container, "Nil container");
	local weight = 0;

	-- Add container own weight
	local containerClass = getClass(container.id);
	if containerClass and containerClass.BA then
		weight = weight + (containerClass.BA.WE or 0);
	end

	-- Add content weight
	for slotID, slotInfo in pairs(container.content or EMPTY) do
		if isContainerByClassID(slotInfo.id) then
			weight = weight + recomputeContainerWeight(slotInfo);
		else
			local class = getClass(slotInfo.id);
			if class and class.BA then
				weight = weight + ((class.BA.WE or 0) * (slotInfo.count or 1));
			end
		end
	end
	container.totalWeight = weight;
	return weight;
end

function TRP3_API.inventory.recomputeAllInventory()
	recomputeContainerWeight(playerInventory);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStart()
	local refreshInventory = function()
		playerInventory = TRP3_API.inventory.getInventory();
		TRP3_API.inventory.closeBags();
		-- Recompute weight
		recomputeContainerWeight(playerInventory);
	end
	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, refreshInventory);
	refreshInventory();

	TRP3_API.inventory.EVENT_ON_SLOT_USE = "EVENT_ON_SLOT_USE";
	TRP3_API.inventory.EVENT_ON_SLOT_SWAP = "EVENT_ON_SLOT_SWAP";
	TRP3_API.inventory.EVENT_DETACH_SLOT = "EVENT_DETACH_SLOT";
	TRP3_API.inventory.EVENT_REFRESH_BAG = "EVENT_REFRESH_BAG";
	TRP3_API.inventory.EVENT_ON_SLOT_REMOVE = "EVENT_ON_SLOT_REMOVE";
	TRP3_API.inventory.EVENT_SPLIT_SLOT = "EVENT_SPLIT_SLOT";
	TRP3_API.events.registerEvent(TRP3_API.inventory.EVENT_ON_SLOT_USE);
	TRP3_API.events.registerEvent(TRP3_API.inventory.EVENT_ON_SLOT_SWAP);
	TRP3_API.events.registerEvent(TRP3_API.inventory.EVENT_DETACH_SLOT);
	TRP3_API.events.registerEvent(TRP3_API.inventory.EVENT_REFRESH_BAG);
	TRP3_API.events.registerEvent(TRP3_API.inventory.EVENT_ON_SLOT_REMOVE);
	TRP3_API.events.registerEvent(TRP3_API.inventory.EVENT_SPLIT_SLOT);
	TRP3_API.events.listenToEvent(TRP3_API.inventory.EVENT_ON_SLOT_SWAP, swapContainersSlots);
	TRP3_API.events.listenToEvent(TRP3_API.inventory.EVENT_ON_SLOT_USE, useContainerSlot);
	TRP3_API.events.listenToEvent(TRP3_API.inventory.EVENT_ON_SLOT_REMOVE, removeSlotContent);
	TRP3_API.events.listenToEvent(TRP3_API.inventory.EVENT_SPLIT_SLOT, splitSlot);

	-- Effect and operands
	TRP3_API.script.registerEffects(TRP3_API.inventory.EFFECTS);

	-- Inventory page
	TRP3_API.inventory.initInventoryPage();

	-- UI
	TRP3_API.inventory.initLootFrame();
	StackSplitFrame:SetScript("OnMouseWheel",function(_, delta)
		if delta == -1 then
			StackSplitFrameLeft_Click();
		elseif delta == 1 then
			StackSplitFrameRight_Click();
		end
	end);
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
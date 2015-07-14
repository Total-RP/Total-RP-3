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
local _G, assert, tostring, tinsert, wipe, pairs = _G, assert, tostring, tinsert, wipe, pairs;
local getItemClass = TRP3_API.inventory.getItemClass;
local EMPTY = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTILS func
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function isContainerByClass(item)
	return item and item.CO;
end
TRP3_API.inventory.isContainerByClass = isContainerByClass;

local function isContainerByClassID(itemID)
	return itemID == "main" or isContainerByClass(getItemClass(itemID));
end
TRP3_API.inventory.isContainerByClassID = isContainerByClassID;

local function isUsableByClass(item)
	return item and item.US;
end
TRP3_API.inventory.isContainerByClass = isContainerByClass;

local function isUsableByClassID(itemID)
	return isUsableByClass(getItemClass(itemID));
end
TRP3_API.inventory.isUsableByClassID = isUsableByClassID;

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

function TRP3_API.inventory.getItem(container, slotID)
	-- Checking data
	local container = container or playerInventory;
	assert(isContainerByClassID(container.id), "Is not a container ! ID: " .. tostring(container.id));
	if not container.content then
		container.content = {};
	end

	return container.content[slotID];
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: BAGS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local switchContainerByRef, isContainerInstanceOpen;

local CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown = CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown;
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local ITEM_QUALITY_COLORS = { -- TODO: calcul
	{"|cff9d9d9d", 157/255, 157/255, 157/255},
	{"|cffffffff", 1, 1, 1},
	{"|cff1eff00", 30/255, 1, 0},
	{"|cff0070dd", 0, 112/255, 221/255},
	{"|cffa335ee", 163/255, 53/255, 238/255},
	{"|cffff8000", 1, 128/255, 0},
}

local function getQualityColorTab(quality)
	quality = quality or 1;
	return ITEM_QUALITY_COLORS[quality];
end

local function getQualityColorText(quality)
	return getQualityColorTab(quality)[1];
end

local function getQualityColorRGB(quality)
	local tab = getQualityColorTab(quality);
	return tab[2], tab[3], tab[4];
end

local function getItemTooltipLines(slotInfo, itemClass)
	local title, text1, text2;
	local icon, name = getBaseClassDateSafe(itemClass);
	title = getQualityColorText(itemClass.BA.QA) .. name;

	text1 = "";
	if itemClass.QE then
		text1 = Utils.str.color("w") .. ITEM_BIND_QUEST;
	end
	if isContainerByClass(itemClass) then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("y") .. "Container"; -- TODO:
	end
	if itemClass.BA.SB then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("w") .. ITEM_SOULBOUND;
	end
	if itemClass.BA.UN and itemClass.BA.UN > 0 then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("w") .. ITEM_UNIQUE .. " (" .. itemClass.BA.UN .. ")";
	end

	if itemClass.BA.DE and itemClass.BA.DE:len() > 0 then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("o") .. "\"" .. itemClass.BA.DE .. "\"";
	end

	if itemClass.US and itemClass.US.AC then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. Utils.str.color("g") .. USE .. ": " .. itemClass.US.AC;
	end

	if itemClass.BA.CO then
		if text1:len() > 0 then text1 = text1 .. "\n"; end
		text1 = text1 .. "|cff66BBFF" .. PROFESSIONS_USED_IN_COOKING;
	end

	if IsAltKeyDown() then
		if itemClass.BA.WE and itemClass.BA.WE > 0 then
			if text1:len() > 0 then text1 = text1 .. "\n"; end
			text1 = text1 .. Utils.str.texture("Interface\\GROUPFRAME\\UI-Group-MasterLooter", 15) .. Utils.str.color("w") .. " " .. itemClass.BA.WE .. "kg";
		end

		local first = true;
		text2 = "";
		if isContainerByClass(itemClass) then
			if first then first = false; text2 = text2 .. "\n"; end
			text2 = text2 .. Utils.str.color("y") .. loc("CM_DOUBLECLICK") .. ": " .. Utils.str.color("o") .. "Open container"; -- TODO:
		end
	end

	return title, text1, text2;
end

local TRP3_ItemTooltip = TRP3_ItemTooltip;
local function showItemTooltip(frame, slotInfo, itemClass)
	TRP3_ItemTooltip:Hide();
	TRP3_ItemTooltip:SetOwner(frame, "TOP_LEFT", 0, 0);

	local title, text1, text2 = getItemTooltipLines(slotInfo, itemClass);

	local i = 1;
	if title and title:len() > 0 then
		TRP3_ItemTooltip:AddLine(title, 1, 1, 1,true);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetFontObject(GameFontNormalLarge);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetNonSpaceWrap(true);
		i = i + 1;
	end

	if text1 and text1:len() > 0 then
		TRP3_ItemTooltip:AddLine(text1, 1, 1, 1,true);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetFontObject(GameFontNormal);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetSpacing(2);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetNonSpaceWrap(true);
		i = i + 1;
	end

	if text2 and text2:len() > 0 then
		TRP3_ItemTooltip:AddLine(text2, 1, 1, 1,true);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetFontObject(GameFontNormalSmall);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetSpacing(2);
		_G["TRP3_ItemTooltipTextLeft"..i]:SetNonSpaceWrap(true);
		i = i + 1;
	end

	TRP3_ItemTooltip:Show();
end

local function containerSlotUpdate(self, elapsed)
	if not self.info then
		self:Disable();
		self:SetAlpha(0);
	else
		self:Enable();
		self:SetAlpha(1);
		local class = self.class or EMPTY;
		local icon, name = getBaseClassDateSafe(class);
		self.Icon:SetTexture("Interface\\ICONS\\" .. icon);
		if class.QE and class.QE.QH then
			self.Quest:Show();
		else
			self.Quest:Hide();
		end
		if class.BA and class.BA.QA and class.BA.QA ~= 1 then
			self.IconBorder:Show();
			local r, g, b = getQualityColorRGB(class.BA.QA);
			self.IconBorder:SetVertexColor(r, g, b);
		else
			self.IconBorder:Hide();
		end
		if self.info.count and self.info.count > 1 then
			self.Quantity:Show();
			self.Quantity:SetText(self.info.count);
		else
			self.Quantity:Hide();
		end

		if self.class and MouseIsOver(self) and TRP3_ItemTooltip.ref == self then
			showItemTooltip(self, self.info, self.class);
		end

		if isContainerByClass(self.class) and isContainerInstanceOpen(self.class, self.info.instanceId) then
			self.Icon:SetVertexColor(0.5, 0.5, 0.5);
		else
			self.Icon:SetVertexColor(1, 1, 1);
		end
	end
end

local COLUMN_SPACING = 43;
local ROW_SPACING = 42;
local CONTAINER_SLOT_UPDATE_FREQUENCY = 0.15;
local function initContainerSlots(containerFrame, rowCount, colCount)
	local slotNum = 1;
	local rowY = -58;
	containerFrame.slots = {};
	for row = 1, rowCount do
		local colX = 22;
		for col = 1, colCount do
			local slot = CreateFrame("Button", containerFrame:GetName() .. "Slot" .. slotNum, containerFrame, "TRP3_ContainerSlotTemplate");
			tinsert(containerFrame.slots, slot);
			createRefreshOnFrame(slot, CONTAINER_SLOT_UPDATE_FREQUENCY, containerSlotUpdate);
			slot:SetPoint("TOPLEFT", colX, rowY);
			slot:SetScript("OnEnter", function(self)
				if self.info and self.class then
					TRP3_ItemTooltip.ref = self;
					showItemTooltip(self, self.info, self.class);
				end
			end);
			slot:SetScript("OnLeave", function(self)
				TRP3_ItemTooltip.ref = nil;
				TRP3_ItemTooltip:Hide();
			end);
			slot:SetScript("OnDoubleClick", function(self, button)
				if self.info and self.class and isContainerByClass(self.class) then
					switchContainerByRef(self.info, self:GetParent());
				end
			end);
			colX = colX + COLUMN_SPACING;
			slotNum = slotNum + 1;
		end
		rowY = rowY - ROW_SPACING;
	end
end

local function loadContainerPage(containerFrame)
	if not containerFrame.info or not containerFrame.class then return end
	local containerContent = containerFrame.info.content or EMPTY;
	local slotCounter = 1;
	for index, slot in pairs(containerFrame.slots) do
		slot.slotID = tostring(slotCounter);
		if containerContent[slot.slotID] then
			slot.info = containerContent[slot.slotID];
			slot.class = getItemClass(containerContent[slot.slotID].id);
		else
			slot.info = nil;
			slot.class = nil;
		end
		containerSlotUpdate(slot);
		slotCounter = slotCounter + 1;
	end
end

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


	if self:GetNumPoints() == 1 then
		local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1);
		if point == "TOPLEFT" and relativePoint == "TOPRIGHT" then
			-- TODO: show anchor icon

		else
			-- TODO: hide anchor icon

		end
	end
end

local function decorateContainer(containerFrame, class, container)
	local icon, name = getBaseClassDateSafe(class);
	Utils.texture.applyRoundTexture(containerFrame.Icon, "Interface\\ICONS\\" .. icon, "Interface\\ICONS\\TEMP");
	containerFrame.Title:SetText(name);
end

local containerInstances5x4 = {};
local containerInstances2x4 = {};
local function getContainerPool(containerClass)
	local size = containerClass.CO.SI;
	size = size or 5;
	if size == 5 then
		return containerInstances5x4, size;
	elseif size == 2 then
		return containerInstances2x4, size;
	end
	error("Unknown container size: " .. size);
end

local CONTAINER_UPDATE_FREQUENCY = 0.5;
local function getContainerInstance(containerClass, instanceId)
	local pool, size = getContainerPool(containerClass);
	local count = 0;
	local containerFrame, available;
	for _, ref in pairs(pool) do
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
		containerFrame = CreateFrame("Frame", "TRP3_Container" .. size .. "x4_" .. (count + 1), nil, "TRP3_Container" .. size .. "x4Template");
		createRefreshOnFrame(containerFrame, CONTAINER_UPDATE_FREQUENCY, containerFrameUpdate);
		initContainerSlots(containerFrame, size, 4);
		containerFrame:SetScript("OnShow", function(self)
			decorateContainer(self, self.class, self.info);
			loadContainerPage(self);
			self:ClearAllPoints();
			if self.originContainer then
				self:SetPoint("TOPLEFT", self.originContainer, "TOPRIGHT", 0, 0);
			else
				self:SetPoint("CENTER", 0, 0);
			end
		end);
		containerFrame:RegisterForDrag("LeftButton");
		containerFrame:SetScript("OnDragStart", function(self)
			self:StartMoving();
		end);
		containerFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing();
			local anchor, _, _, x, y = self:GetPoint(1);
			local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1);
			self.info.point = point;
			self.info.relativePoint = relativePoint;
			self.info.xOfs = xOfs;
			self.info.yOfs = yOfs;
		end);
		tinsert(pool, containerFrame);
	end
	containerFrame.instanceId = instanceId;
	return containerFrame;

end

function isContainerInstanceOpen(containerClass, instanceId)
	for _, ref in pairs(getContainerPool(containerClass)) do
		if ref.instanceId == instanceId and ref:IsVisible() then
			return true;
		end
	end
	return false;
end

function switchContainerByRef(container, originContainer)
	local instanceId = container.instanceId;
	local class = getItemClass(container.id);
	local containerFrame = getContainerInstance(class, instanceId);
	containerFrame.info = container;
	containerFrame.class = class;
	containerFrame.originContainer = originContainer;
	ToggleFrame(containerFrame);
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
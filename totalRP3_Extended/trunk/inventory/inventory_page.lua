----------------------------------------------------------------------------------
-- Total RP 3: Inventory page
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
local getItemClass, isContainerByClassID, isUsableByClass = TRP3_API.inventory.getItemClass, TRP3_API.inventory.isContainerByClassID, TRP3_API.inventory.isUsableByClass;
local getBaseClassDataSafe, isContainerByClass, isUsableByClass = TRP3_API.inventory.getBaseClassDataSafe, TRP3_API.inventory.isContainerByClass, TRP3_API.inventory.isUsableByClass;
local checkContainerInstance, countItemInstances = TRP3_API.inventory.checkContainerInstance, TRP3_API.inventory.countItemInstances;
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown = CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown;
local TRP3_ItemTooltip = TRP3_ItemTooltip;
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;

local onInventoryShow;
local inventorySlots, equipedSlots = {}, {};

local function slotOnEnter(self)
	if self.info then
		TRP3_ItemTooltip.ref = self;
		TRP3_API.inventory.showItemTooltip(self, self.info, self.class);
	end
end

local function slotOnLeave(self)
	TRP3_ItemTooltip.ref = nil;
	TRP3_ItemTooltip:Hide();
end

local function slotOnDragStart(self)
	if self.info then
		self:GetNormalTexture():SetDesaturated(true);
		SetCursor("Interface\\ICONS\\" .. ((self.class and self.class.BA.IC) or "inv_misc_questionmark")) ;
		for index, button in pairs(equipedSlots) do
			button:LockHighlight();
		end
	end
end

local function slotOnDragStop(slotFrom)
	for index, button in pairs(equipedSlots) do
		button:UnlockHighlight();
	end
	slotFrom:GetNormalTexture():SetDesaturated(false);
	ResetCursor();
	if slotFrom.info then
		local slotTo = GetMouseFocus();
		local slot = slotFrom.slotID;
		local container = slotFrom:GetParent().info;

		if slotTo:GetName() == "WorldFrame" then
			local itemClass = getItemClass(slotFrom.info.id);
			TRP3_API.popup.showConfirmPopup(DELETE_ITEM:format(TRP3_API.inventory.getItemLink(itemClass)), function()
				TRP3_API.events.fireEvent(TRP3_API.inventory.EVENT_ON_SLOT_REMOVE, container, slot, slotFrom.info);
				onInventoryShow();
			end);
		elseif slotTo:GetName():sub(1, 31) == "TRP3_InventoryMainLeftModelSlot" and slotTo.slotID then

		else
			Utils.message.displayMessage(loc("IT_INV_ERROR_CANT_HERE"), Utils.message.type.ALERT_MESSAGE);
		end
	end
end


local function containerSlotUpdate(self, elapsed)
	if self.info then
		local class = self.class;
		local icon, name = getBaseClassDataSafe(class);
		self:SetNormalTexture("Interface\\ICONS\\" .. icon);
		self:SetPushedTexture("Interface\\ICONS\\" .. icon);
		_G[self:GetName() .. "SpellName"]:SetText(name);
		_G[self:GetName() .. "SubSpellName"]:SetText("");
		if isContainerByClass(class) then
			_G[self:GetName() .. "SubSpellName"]:SetText("|cffffffff" .. CONTAINER_SLOTS:format((class.CO.SR or 5) * (class.CO.SC or 4), BAGSLOT));
		end

		if MouseIsOver(self) then
			TRP3_API.inventory.showItemTooltip(self, self.info, self.class);
		end
	else
		if TRP3_ItemTooltip.ref == self and MouseIsOver(self) then
			TRP3_ItemTooltip:Hide();
		end
	end
end

function onInventoryShow(context)
	local playerInventory = TRP3_API.inventory.getInventory();
	TRP3_InventoryMainRightScrollContainer.info = playerInventory;

	TRP3_InventoryMainLeftModel:SetUnit("player");

	for index, button in pairs(inventorySlots) do
		button:Hide();
	end

	local i = 1;
	local found = 0;
	while i <= TRP3_API.inventory.CONTAINER_SLOT_MAX do
		local slotID = tostring(i);
		local slot = playerInventory.content[slotID];
		if slot then
			local classID = slot.id;
			local class = getItemClass(classID);
			found = found + 1;

			-- Get slot UI
			local slotButton = inventorySlots[found];
			if not slotButton then
				slotButton = CreateFrame("Button", "TRP3_InventoryMainRightSlot" .. found, TRP3_InventoryMainRightScrollContainer, "TRP3_InventoryMainRightSlotTemplate");
				slotButton:SetPoint("TOPLEFT", 5, -10 + ((found - 1) * -55));
				slotButton:RegisterForDrag("LeftButton");
				createRefreshOnFrame(slotButton, TRP3_API.inventory.CONTAINER_SLOT_UPDATE_FREQUENCY, containerSlotUpdate);
				slotButton:SetScript("OnEnter", slotOnEnter);
				slotButton:SetScript("OnLeave", slotOnLeave);
				slotButton:SetScript("OnDragStart", slotOnDragStart);
				slotButton:SetScript("OnDragStop", slotOnDragStop);
				slotButton:SetScript("OnDoubleClick", function(self, button)
					if button == "LeftButton" and self.info and self.class and isContainerByClass(self.class) then
						TRP3_API.inventory.switchContainerByRef(self.info);
						slotOnEnter(self);
					end
				end);
				tinsert(inventorySlots, slotButton);
			end

			slotButton.slotID = slotID;
			slotButton.class = class;
			slotButton.info = slot;

			slotButton:Show();
		end
		i = i + 1;
	end
end

local playerInvText = ("%s's inventory"):format(Globals.player);

local function initPlayerInventoryButton()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_d_inventory",
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			configText = playerInvText,
			condition = function(_, unitID)
				return unitID == Globals.player_id;
			end,
			onClick = function(_, _, button, _)
				if button == "LeftButton" then
					TRP3_API.navigation.openMainFrame();
					TRP3_API.navigation.menu.selectMenu("main_13_player_inventory");
				end
			end,
			tooltip = playerInvText,
			tooltipSub = loc("IT_INV_SHOW_CONTENT"),
			icon = "inv_misc_bag_16"
		});
	end
end

function TRP3_API.inventory.initInventoryPage()

	TRP3_API.navigation.menu.registerMenu({
		id = "main_13_player_inventory",
		text = INVENTORY_TOOLTIP,
		onSelected = function()
			TRP3_API.navigation.page.setPage("player_inventory", {});
		end,
		isChildOf = "main_10_player",
	});

	TRP3_API.navigation.page.registerPage({
		id = "player_inventory",
		templateName = "TRP3_InventoryMain",
		frameName = "TRP3_InventoryMain",
		frame = TRP3_InventoryMain,
		onPagePostShow = onInventoryShow
	});
	TRP3_API.ui.frame.setupFieldPanel(TRP3_InventoryMainRight, INVENTORY_TOOLTIP, 150);

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		initPlayerInventoryButton();
	end);

	-- Create model slots
	for i=1, 16 do
		local button = CreateFrame("Button", "TRP3_InventoryMainLeftModelSlot" .. i, TRP3_InventoryMainLeft, "TRP3_IconButton");
		button:SetSize(40, 40);
		_G[button:GetName() .. "Icon"]:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot");
		if i == 1 then
			button:SetPoint("TOPRIGHT", TRP3_InventoryMainLeftModel, "TOPLEFT", -2, 0);
		elseif i == 9 then
				button:SetPoint("TOPLEFT", TRP3_InventoryMainLeftModel, "TOPRIGHT", 4, 0);
		else
			button:SetPoint("TOP", _G["TRP3_InventoryMainLeftModelSlot" .. (i - 1)], "BOTTOM", 0, -11);
		end
		tinsert(equipedSlots, button);
		button.slotID = tostring(i);
	end
end
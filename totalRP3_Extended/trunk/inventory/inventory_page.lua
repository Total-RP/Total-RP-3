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

function onInventoryShow()
	local playerInventory = TRP3_API.inventory.getInventory();
	TRP3_InventoryMainLeft.info = playerInventory;
	TRP3_InventoryMainLeftModel:SetUnit("player");

	TRP3_API.inventory.loadContainerPageSlots(TRP3_InventoryMainLeft);
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
			TRP3_API.navigation.page.setPage("player_inventory");
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
	TRP3_InventoryMainLeft.slots = {};
	for i=1, 16 do
		local button = CreateFrame("Button", "TRP3_ContainerInvPageSlot" .. i, TRP3_InventoryMainLeft, "TRP3_InventoryMainSlotTemplate");
		if i == 1 then
			button:SetPoint("TOPRIGHT", TRP3_InventoryMainLeftModel, "TOPLEFT", -2, 0);
		elseif i == 9 then
			button:SetPoint("TOPLEFT", TRP3_InventoryMainLeftModel, "TOPRIGHT", 4, 0);
		else
			button:SetPoint("TOP", _G["TRP3_ContainerInvPageSlot" .. (i - 1)], "BOTTOM", 0, -11);
		end
		tinsert(TRP3_InventoryMainLeft.slots, button);
		button.slotID = tostring(i);
		TRP3_API.inventory.initContainerSlot(button);
	end
	TRP3_API.inventory.initContainerInstance(TRP3_InventoryMainLeft, 16);

	-- On profile changed
	local refreshInventory = function()
		if TRP3_API.navigation.page.getCurrentPageID() == "player_inventory" then
			onInventoryShow();
		end
	end
	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, refreshInventory);
end
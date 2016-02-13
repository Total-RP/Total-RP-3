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
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown = CreateFrame, ToggleFrame, MouseIsOver, IsAltKeyDown;
local TRP3_ItemTooltip = TRP3_ItemTooltip;
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Slot equipement management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function resetEquip()
	Model_Reset(TRP3_InventoryPage.Main.Model);
	TRP3_InventoryPage.Main.Equip:Hide();
	TRP3_InventoryPage.Main.Model.Marker:Hide();
end

local function setModelPosition(self, rotation, zoom, y, z)
	self.rotation = rotation;
	self.zoomLevel = zoom;
	self:SetPortraitZoom(self.zoomLevel);
	self:SetRotation(self.rotation);
	self:SetPosition(0, y, z);
	self:RefreshCamera();
end

local function setButtonModelPosition(self)
	if self.info and self.class then
		local isWearable = self.class.BA and self.class.BA.WA;
		if isWearable then
			local pos = self.info.pos or EMPTY;
			setModelPosition(TRP3_InventoryPage.Main.Model, pos.rotation or 0, pos.zoom or 0, pos.y or 0, pos.z or 0);
			TRP3_InventoryPage.Main.Model.Marker:Show();
		else
			resetEquip();
		end
	end
end

local function onSlotEnter(self)
	if not TRP3_InventoryPage.Main.Equip:IsVisible() then
		setButtonModelPosition(self);
	end
end

local function onSlotLeave()
	if TRP3_InventoryPage.Main.Equip:IsVisible() then
		return;
	end
end

local function onSlotDrag()
	resetEquip();
end

local function onSlotDoubleClick()
	TRP3_InventoryPage.Main.Equip:Hide();
end

local function onSlotUpdate(self, elapsed)

end

local function onSlotClick(button)

	if TRP3_InventoryPage.Main.Equip:IsVisible() and TRP3_InventoryPage.Main.Equip.isOn == button then
		TRP3_InventoryPage.Main.Equip:Hide();
		return;
	end

	if button.info and button.class then
		if not button.class.BA or not button.class.BA.WA then
			TRP3_InventoryPage.Main.Equip:Hide();
			return;
		end
	end

	local position, x, y = "RIGHT", -10, 0;
	if button.slotNumber > 8 then
		position, x, y = "LEFT", 10, 0;
	end
	TRP3_API.ui.frame.configureHoverFrame(TRP3_InventoryPage.Main.Equip, button, position, x, y);
	TRP3_InventoryPage.Main.Equip.isOn = button;

	setButtonModelPosition(button);
end

local function onEquipRefresh(self)
	-- Camera
	local cameraString = "Camera parameters:\nRotation: %.2f\nZoom: %.2f\nPosition: %.2f, %.2f"; -- TODO: locals
	local rotation, zoom = TRP3_InventoryPage.Main.Model.rotation, TRP3_InventoryPage.Main.Model.zoomLevel;
	local _, cameraY, cameraZ = TRP3_InventoryPage.Main.Model:GetPosition();

	self.Camera:SetText(cameraString:format(rotation, zoom, cameraY, cameraZ));

	local button = TRP3_InventoryPage.Main.Equip.isOn
	if button and button.info then
		local pos =  button.info.pos or {};
		pos.rotation = TRP3_InventoryPage.Main.Model.rotation;
		pos.zoom = TRP3_InventoryPage.Main.Model.zoomLevel;
		pos.y = cameraY;
		pos.z = cameraZ;
		button.info.pos = pos;
	end

	-- Marker
	self.Marker:SetText(("Marker position"));  -- TODO: locals
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Page management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local onInventoryShow;

function onInventoryShow()
	local playerInventory = TRP3_API.inventory.getInventory();
	TRP3_InventoryPage.Main.info = playerInventory;
	TRP3_InventoryPage.Main.Model:SetUnit("player", true);
	resetEquip();

	TRP3_API.inventory.loadContainerPageSlots(TRP3_InventoryPage.Main);
end

local function containerFrameUpdate(self, elapsed)
	-- Weight
	local current = self.info.totalWeight or 0;
	local weight = ("%s kg" .. Utils.str.texture("Interface\\GROUPFRAME\\UI-Group-MasterLooter", 15)):format(current);
	TRP3_InventoryPage.Main.Model.WeightText:SetText(weight);
end

local playerInvText = ("%s's inventory"):format(Globals.player); -- TODO locals

local function onToolbarButtonClicked(buttonType)
	if buttonType == "LeftButton" then
		local playerInventory = TRP3_API.inventory.getInventory();
		local quickSlot = playerInventory.content["17"];
		if quickSlot and quickSlot.id and TRP3_API.inventory.isContainerByClassID(quickSlot.id) then
			TRP3_API.inventory.switchContainerBySlotID(playerInventory, "17");
			return;
		end
	end
	TRP3_API.navigation.openMainFrame();
	TRP3_API.navigation.menu.selectMenu("main_13_player_inventory");
end

local function initPlayerInventoryButton()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_d_inventory",
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			configText = playerInvText,
			condition = function(_, unitID)
				return unitID == Globals.player_id;
			end,
			onClick = function(_, _, buttonType, _)
				onToolbarButtonClicked(buttonType);
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
		frame = TRP3_InventoryPage,
		onPagePostShow = onInventoryShow
	});

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		initPlayerInventoryButton();
	end);

	createRefreshOnFrame(TRP3_InventoryPage.Main, 0.15, containerFrameUpdate);

	-- Create model slots
	TRP3_InventoryPage.Main.slots = {};
	for i=1, 17 do
		local button = CreateFrame("Button", "TRP3_ContainerInvPageSlot" .. i, TRP3_InventoryPage.Main, "TRP3_InventoryPageSlotTemplate");
		if i == 1 then
			button:SetPoint("TOPRIGHT", TRP3_InventoryPage.Main.Model, "TOPLEFT", -10, 4);
		elseif i == 9 then
			button:SetPoint("TOPLEFT", TRP3_InventoryPage.Main.Model, "TOPRIGHT", 12, 4);
		elseif i == 17 then
			button:SetPoint("TOPLEFT", TRP3_InventoryPage.Main.Model, "BOTTOMLEFT", 5, -10);
			button.First:SetText("Quick slot"); -- TODO: loc
			button.Second:SetText("This slot will be used as primary container."); -- TODO: loc
		else
			button:SetPoint("TOP", _G["TRP3_ContainerInvPageSlot" .. (i - 1)], "BOTTOM", 0, -11);
		end
		tinsert(TRP3_InventoryPage.Main.slots, button);
		button.slotNumber = i;
		button.slotID = tostring(i);
		TRP3_API.inventory.initContainerSlot(button, onSlotClick);
		button.additionalOnEnterHandler = onSlotEnter;
		button.additionalOnLeaveHandler = onSlotLeave;
		button.additionalOnDragHandler = onSlotDrag;
		button.additionalDoubleClickHandler = onSlotDoubleClick;
		button.additionalOnUpdateHandler = onSlotUpdate;
		button.First:ClearAllPoints();
		if i > 8 then
			button.tooltipRight = true;
			button.First:SetPoint("TOPLEFT", button, "TOPRIGHT", 5, -5);
			button.First:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 15);
			button.First:SetPoint("RIGHT", TRP3_InventoryPage, "RIGHT", -15, 0);
			button.First:SetJustifyH("LEFT");
			button.Second:SetPoint("TOPLEFT", button, "TOPRIGHT", 5, -10);
			button.Second:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, -10);
			button.Second:SetPoint("RIGHT", TRP3_InventoryPage, "RIGHT", -15, 0);
			button.Second:SetJustifyH("LEFT");
		else
			button.First:SetPoint("TOPRIGHT", button, "TOPLEFT", -5, -5);
			button.First:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 15);
			button.First:SetPoint("LEFT", TRP3_InventoryPage, "LEFT", 15, 0);
			button.First:SetJustifyH("RIGHT");
			button.Second:SetPoint("TOPRIGHT", button, "TOPLEFT", -5, -10);
			button.Second:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, -10);
			button.Second:SetPoint("LEFT", TRP3_InventoryPage, "LEFT", 15, 0);
			button.Second:SetJustifyH("RIGHT");
		end
	end
	TRP3_API.inventory.initContainerInstance(TRP3_InventoryPage.Main, 16);

	-- On profile changed
	local refreshInventory = function()
		if TRP3_API.navigation.page.getCurrentPageID() == "player_inventory" then
			onInventoryShow();
		end
	end
	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, refreshInventory);

	-- Equip
	TRP3_InventoryPage.Main.Model.defaultRotation = 0;
	TRP3_InventoryPage.Main.Equip.Title:SetText("Item location on character"); -- TODO: locals
	createRefreshOnFrame(TRP3_InventoryPage.Main.Equip, 0.15, onEquipRefresh);
	TRP3_InventoryPage.Main.Equip:SetScript("OnShow", function() TRP3_InventoryPage.Main.Model.Blocker:Hide() end);
	TRP3_InventoryPage.Main.Equip:SetScript("OnHide", function() TRP3_InventoryPage.Main.Model.Blocker:Show() end);
	TRP3_InventoryPage.Main.Model.Blocker:EnableMouseWheel(true);
	TRP3_InventoryPage.Main.Model.Blocker:SetScript("OnMouseWheel", function() end); -- Block behind scroll
end
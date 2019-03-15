----------------------------------------------------------------------------------
--- Total RP 3
--- Register cursor
--- Implements right-click on a player in the 3D world to open their profile
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

-- Lua API imports
local insert = table.insert;

-- WoW API imports
local InCombatLockdown = InCombatLockdown;
local IsShiftKeyDown = IsShiftKeyDown;
local IsControlKeyDown = IsControlKeyDown;
local IsAltKeyDown = IsAltKeyDown;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local hasProfile = TRP3_API.register.hasProfile;
local openMainFrame = TRP3_API.navigation.openMainFrame;
local openPageByUnitID = TRP3_API.register.openPageByUnitID;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local getConfigValue = TRP3_API.configuration.getValue;
local isUnitIDIgnored = TRP3_API.register.isIDIgnored;
local isPlayerIC = TRP3_API.dashboard.isPlayerIC;

-- Ellyb imports
local Cursor = TRP3_API.Ellyb.Cursor;
--- Create a new Ellyb Unit for the mouseover unit
---@type Unit
local Mouseover = TRP3_API.Ellyb.Unit("mouseover");

local CONFIG_RIGHT_CLICK_OPEN_PROFILE = "CONFIG_RIGHT_CLICK_OPEN_PROFILE";
local CONFIG_RIGHT_CLICK_DISABLE_OOC = "CONFIG_RIGHT_CLICK_DISABLE_OOC";
local CONFIG_RIGHT_CLICK_OPEN_PROFILE_MODIFIER_KEY = "CONFIG_RIGHT_CLICK_OPEN_PROFILE_MODIFIER_KEY";

---Check if we can view the unit profile by using the cursor
local function canInteractWithUnit()

	if
	not Mouseover:Exists()
	or InCombatLockdown() -- We don't want to open stuff in combat
	or not Mouseover:IsPlayer() -- Unit has to be a player
	or Mouseover:IsMountable() -- Avoid unit on multi seats mounts
	or Mouseover:IsAttackable() -- Unit must not be attackable
	then
		return false;
	end

	local unitID = Mouseover:GetUnitID();
	if
	not unitID
	or unitID == TRP3_API.globals.player_id -- Unit is not the player
	or not isUnitIDKnown(unitID) -- Unit is known by TRP3
	or hasProfile(unitID) == nil -- Unit has a RP profile available
	or isUnitIDIgnored(unitID) -- Unit has been ignored
	then
		return false;
	end

	return true;
end

local ICON_X = 30;
local ICON_Y = -3;
local function onMouseOverUnit()
	if getConfigValue(CONFIG_RIGHT_CLICK_DISABLE_OOC) and not isPlayerIC() then
		return
	end
	if getConfigValue(CONFIG_RIGHT_CLICK_OPEN_PROFILE) and canInteractWithUnit() then
		if TRP3_API.register.unitIDIsFilteredForMatureContent(Mouseover:GetUnitID()) then
			Cursor:SetIcon("Interface\\AddOns\\totalRP3\\resources\\WorkOrders_Pink.tga", ICON_X, ICON_Y);
		else
			Cursor:SetIcon("Interface\\CURSOR\\WorkOrders", ICON_X, ICON_Y);
		end
		Cursor:HideOnUnitChanged();
	end
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	registerConfigKey(CONFIG_RIGHT_CLICK_OPEN_PROFILE, false);
	registerConfigKey(CONFIG_RIGHT_CLICK_DISABLE_OOC, false);
	registerConfigKey(CONFIG_RIGHT_CLICK_OPEN_PROFILE_MODIFIER_KEY, 1);

	local function isModifierKeyPressed()
		local option = getConfigValue(CONFIG_RIGHT_CLICK_OPEN_PROFILE_MODIFIER_KEY);
		if option == 1 then
			return true;
		elseif option == 2 then
			return IsShiftKeyDown();
		elseif option == 3 then
			return IsControlKeyDown();
		elseif option == 4 then
			return IsAltKeyDown();
		end
	end

	Cursor:OnUnitRightClicked(function(unitID)
		if getConfigValue(CONFIG_RIGHT_CLICK_DISABLE_OOC) and not isPlayerIC() then
			return
		end
		if getConfigValue(CONFIG_RIGHT_CLICK_OPEN_PROFILE) and isModifierKeyPressed() and not isUnitIDIgnored(unitID) then
			openMainFrame()
			openPageByUnitID(unitID);
		end
	end)

	-- Listen to the mouse over event and register data update to event to show the cursor icon
	TRP3_API.utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOverUnit);
	TRP3_API.events.listenToEvent(TRP3_API.events.REGISTER_DATA_UPDATED, onMouseOverUnit)

	-- Configuration header
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_CURSOR_TITLE,
	});

	-- Main checkbox to toggle this feature
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_CURSOR_RIGHT_CLICK,
		help = loc.CO_CURSOR_RIGHT_CLICK_TT,
		configKey = CONFIG_RIGHT_CLICK_OPEN_PROFILE,
	});

	-- Main checkbox to toggle this feature
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_CURSOR_DISABLE_OOC,
		help = loc.CO_CURSOR_DISABLE_OOC_TT,
		configKey = CONFIG_RIGHT_CLICK_DISABLE_OOC,
		dependentOnOptions = { CONFIG_RIGHT_CLICK_OPEN_PROFILE },
	});

	-- Modifier key dropdown option
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigCursor_ModifierKey",
		title = loc.CO_CURSOR_MODIFIER_KEY,
		help = loc.CO_CURSOR_MODIFIER_KEY_TT,
		listContent = {
			{ NONE, 1 },
			{ TRP3_API.Ellyb.System.MODIFIERS.SHIFT, 2 },
			{ TRP3_API.Ellyb.System.MODIFIERS.CTRL, 3 },
			{ TRP3_API.Ellyb.System.MODIFIERS.ALT, 4 }
		},
		configKey = CONFIG_RIGHT_CLICK_OPEN_PROFILE_MODIFIER_KEY,
		dependentOnOptions = { CONFIG_RIGHT_CLICK_OPEN_PROFILE },
	});

end)

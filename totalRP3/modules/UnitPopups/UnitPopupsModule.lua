----------------------------------------------------------------------------------
--- Total RP 3
---
--- UnitPopup Integration
---	---------------------------------------------------------------------------
--- Copyright 2018 Daniel "Meorawr" Yates <me@meorawr.io>
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);
local loc = TRP3_API.loc;

local UnitPopups = TRP3_API.UnitPopups;

--region Lua imports
local assert = assert;
local newproxy = newproxy;
local tinsert = table.insert;
--endregion

--region WoW imports
local hooksecurefunc = _G.hooksecurefunc;
local UnitPopupButtons = _G.UnitPopupButtons;
local UnitPopupMenus = _G.UnitPopupMenus;
local UnitPopupShown = _G.UnitPopupShown;
--endregion

--region Ellyb imports
local Assertions = Ellyb.Assertions;
--endregion

--- Logger for this module.
local logger = Ellyb.Logger("TotalRP3_UnitPopups");

--- Unique key added to button tables that refers back to the defining action.
--  It's a constant. You do anything with this, I'll find you.
local ACTION_KEY = newproxy(true);

--- Enumeration of button IDs to be registered in menus.
local Buttons = {
	SEPARATOR = "TRP3_SEPARATOR",
	HEADER = "TRP3_HEADER",
	OPEN_PLAYER_PROFILE = "TRP3_OPEN_PLAYER_PROFILE",
};

--- Enumeration of menus to insert button IDs into.
--  As this list is fairly large it's been defined at the bottom end of
--  the script.
local Menus;

--- Creates a button entry from the given UnitAction instance.
-- @param action The action to create a button from.
-- @return A button for use with the UnitPopup system.
local function createButton(action)
	local button = {};

	-- Our button should be able to link back to its action.
	button[ACTION_KEY] = action;

	-- Straightforward button attributes.
	button.text = action:GetText();
	button.icon = action:GetIcon();
	button.tCoordLeft,
		button.tCoordRight,
		button.tCoordTop,
		button.tCoordBottom = action:GetIconCoords();

	-- Color is optional and, if set, should be an Ellyb.Color instance.
	local color = action:GetTextColor();
	if color then
		button.color = color:GetRGBTable();
	end

	-- Headers need a whole bunch of flags set, see FrameXML\UnitPopup.lua.
	if action:IsHeader() then
		button.isTitle = true;
		button.isUninteractable = true;
		button.isSubsection = true;
		button.isSubsectionSeparator = true;

		-- If the text isn't nil or empty we'll treat it as a titled header
		-- and not a separator space.
		button.isSubsectionTitle = (button.text ~= nil and button.text ~= "");
	end

	return button;
end

--- Returns the UnitAction associated with the registered button, if one exists.
-- @param buttonID The ID of the button to query.
-- @return A UnitAction instance if this button exists and is associated with one.
local function getButtonAction(buttonID)
	local button = UnitPopupButtons[buttonID];
	return button and button[ACTION_KEY];
end

--- Returns the index of a button within a menu if it exists.
-- @param menuID The ID of the menu to query.
-- @param buttonID The ID of the button to query.
-- @return Numerical index of the button if found, or nil.
local function indexOfButton(menuID, buttonID)
	local menu = UnitPopupMenus[menuID];
	assert(Assertions.isNotNil(menu));

	for i = 1, #menu do
		if menu[i] == buttonID then
			return i;
		end
	end
end

--- Inserts a given button within a menu at the specified index.
-- @param menuID The ID of the menu to modify.
-- @param index The index to insert the button at.
-- @param buttonID The ID of the button to insert.
local function insertButton(menuID, index, buttonID)
	local menu = UnitPopupMenus[menuID];
	local button = UnitPopupButtons[buttonID];

	assert(Assertions.isNotNil(button, "button"));
	assert(Assertions.isNotNil(menu, "menu"));
	assert(Assertions.isNotNil(index, "index"));

	tinsert(menu, index, buttonID);
end

--- Inserts a list of menu entries into the given menu by its ID, with each
--  button being inserted at indices described by the entry.
-- @param menuID The ID of the menu to modify.
-- @param entries A list of entries to insert.
local function insertMenuEntries(menuID, entries)
	local menu = UnitPopupMenus[menuID];
	assert(Assertions.isNotNil(menu, "menu"));

	-- Hit up each entry in the menu.
	for _, entry in ipairs(entries) do
		-- By default append to the menu, unless told to insert before/after
		-- another button explicitly.
		local index = #menu + 1;
		if entry.insertBefore then
			index = indexOfButton(menuID, entry.insertBefore);
		elseif entry.insertAfter then
			index = indexOfButton(menuID, entry.insertAfter);
			index = index and index + 1;
		end

		if not index then
			logger:Severe("Failed to insert button", entry.button, "into menu", menuID);
			assert(Assertions.isNotNil(index, "index"));

			-- Recover by just appending.
			index = #menu + 1;
		end

		-- Insert at the specified index.
		insertButton(menuID, index, entry.button);
	end
end

--- Registers a button with a given identifier.
-- @param buttonID The ID of the button to register.
-- @param button The button to be registered.
local function registerButton(buttonID, button)
	local existingButton = UnitPopupButtons[buttonID];
	assert(Assertions.isType(existingButton, "nil", "existingButton"));

	UnitPopupButtons[buttonID] = button;
end

--- Called when a button in a dropdown menu has been clicked.
-- @param info The dropdown entry info table for this button.
local function onUnitPopupClick(info)
	-- Grab the action from the info's button ID.
	local action = getButtonAction(info.value);
	if not action then
		return;
	end

	-- Grab the dropdown that triggered this call and extract the fields that
	-- get assigned during the UnitPopup_ShowMenu call.
	local dropdown = UIDROPDOWNMENU_INIT_MENU;
	local unit = dropdown.unit;
	local name = dropdown.name;
	local server = dropdown.server;

	return action:OnTriggered(unit, name, server);
end

--- Called when a menu is going to be shown but before it gets populated with
--  any buttons. Updates the shown flag of buttons that are associated with
--  actions based upon the return of their IsVisible method.
local function onHideButtons()
	-- These globals (UIDROPDOWNMENU_*) are explicitly not upvalued. Magic.
	local currentMenuEntries = UnitPopupMenus[UIDROPDOWNMENU_MENU_VALUE];
	local initMenuEntries = UnitPopupMenus[UIDROPDOWNMENU_INIT_MENU.which];

	-- Which menu is actually err, relevant? We need the fields...
	local dropdown = UIDROPDOWNMENU_MENU_VALUE;
	if not currentMenuEntries then
		dropdown = UIDROPDOWNMENU_INIT_MENU;
	end

	-- Field extraction for the visibility query.
	local unit = dropdown.unit;
	local name = dropdown.name;
	local server = dropdown.server;

	-- This loop itself is otherwise the same as in UnitPopup_HideButtons.
	for index, buttonID in ipairs(currentMenuEntries or initMenuEntries) do
		-- Does this entry correspond to a button with an action?
		local action = getButtonAction(buttonID);
		if action then
			-- Query visibility and update the flag appropriately.
			local shown = action:IsVisible(unit, name, server);
			UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = shown and 1 or 0;
		end
	end
end

--- Called when the module is started. Does stuff to make things work.
local function onModuleStart()
	-- Hook a few select functions that'll enable us to integrate buttons
	-- with actions just enough to function in ways that are sensible.
	hooksecurefunc("UnitPopup_OnClick", onUnitPopupClick);
	hooksecurefunc("UnitPopup_HideButtons", onHideButtons);

	-- Instantiate a bunch of actions.
	local separatorAction = UnitPopups.UnitAction();
	separatorAction:SetHeader(true);

	local headerAction = UnitPopups.UnitAction(loc.UP_GENERIC_MENU_TITLE);
	headerAction:SetHeader(true);

	local openPlayerProfileAction = UnitPopups.OpenPlayerProfileAction();

	-- Register the actions.
	local actions = {};
	actions[Buttons.SEPARATOR] = separatorAction;
	actions[Buttons.HEADER] = headerAction;
	actions[Buttons.OPEN_PLAYER_PROFILE] = openPlayerProfileAction;

	-- Create and register buttons for all those actions.
	for buttonID, action in pairs(actions) do
		local button = createButton(action);
		registerButton(buttonID, button);
	end

	-- Insert our magical buttons into menu entries.
	for menuID, entries in pairs(Menus) do
		insertMenuEntries(menuID, entries);
	end
end

-- Registrado del modulado, or something like that. Probably. ¯\_(ツ)_/¯
TRP3_API.module.registerModule({
	["name"] = loc.UP_MODULE_NAME,
	["description"] = loc.UP_MODULE_DESCRIPTION,
	["version"] = 1,
	["id"] = "trp3_unitpopups",
	["onStart"] = onModuleStart,
	["minVersion"] = 52,
	["autoEnable"] = false, -- We don't want to taint things by default.
});

-- Remember that Menus variable above? BEHOLD!
Menus = {
	-- Touching these menus definitively breaks the Set Focus item due to taint.
	-- SELF = {
	-- 	{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
	-- 	{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
	-- 	{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	-- },
	-- PARTY = {
	-- 	{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
	-- 	{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
	-- 	{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	-- },
	-- PLAYER = {
	-- 	{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
	-- 	{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
	-- 	{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	-- },
	-- RAID_PLAYER = {
	-- 	{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
	-- 	{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
	-- 	{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	-- },
	-- RAID = {
	-- 	{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
	-- 	{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
	-- 	{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	-- },
	FRIEND = {
		{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	FRIEND_OFFLINE = {
		{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	BN_FRIEND = {
		{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	BN_FRIEND_OFFLINE = {
		{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	GUILD = {
		{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	GUILD_OFFLINE = {
		{ button = Buttons.SEPARATOR, insertBefore = "CANCEL" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	CHAT_ROSTER = {
		{ button = Buttons.SEPARATOR, insertBefore = "CLOSE" },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	COMMUNITIES_WOW_MEMBER = {
		{ button = Buttons.SEPARATOR },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	COMMUNITIES_GUILD_MEMBER = {
		{ button = Buttons.SEPARATOR },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
	COMMUNITIES_MEMBER = {
		{ button = Buttons.SEPARATOR },
		{ button = Buttons.HEADER, insertAfter = Buttons.SEPARATOR },
		{ button = Buttons.OPEN_PLAYER_PROFILE, insertAfter = Buttons.HEADER },
	},
};

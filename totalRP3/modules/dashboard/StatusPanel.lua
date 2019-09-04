-------------------------------------------------------
-- Total RP 3
-- Dashboard Status Panel
-- --------------------------------------------------
-- Copyright 2014-2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- 	http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-------------------------------------------------------

--@type TRP3_API
local _, TRP3_API = ...;

-- TRP imports.
local L = TRP3_API.loc;
local Config = TRP3_API.configuration;
local Enums = AddOn_TotalRP3.Enums;
local Events = TRP3_API.events;
local Globals = TRP3_API.globals;
local UI = TRP3_API.ui;
local Utils = TRP3_API.utils;

-- Increments the character version data number for a given player model.
--
-- @param The player model to increment version data for.
local function IncrementCharacterDataVersion(player)
	local character = player:GetInfo("character");
	character.v = Utils.math.incrementNumber(character.v or 1, 2);

	Events.fireEvent(Events.REGISTER_DATA_UPDATED,
		Globals.player_id, player:GetProfileID(), "character");
end

-- Mixin for the top-level status frame panel.
local DashboardStatusPanelMixin = {};
TRP3_DashboardStatusPanelMixin = DashboardStatusPanelMixin;

-- Handler called when the frame is loaded.
function DashboardStatusPanelMixin:OnLoad()
	-- Connect to addon events.
	Events.registerCallback(Events.WORKFLOW_ON_LOADED,
		function(...) self:OnWorkflowLoaded(...); end);
end

-- Handler called when addon workflow reaches the loaded state.
function DashboardStatusPanelMixin:OnWorkflowLoaded()
	-- Defer registering config handlers to here, since OnLoad is too early.
	Config.registerHandler({ "AddonLocale" },
		function(...) self:OnLocaleChanged(...); end);

	self:LocalizeUI();
end

-- Handler called when the addon locale changes.
function DashboardStatusPanelMixin:OnLocaleChanged()
	self:LocalizeUI();
end

-- Updates all localization-dependant parts of the UI.
function DashboardStatusPanelMixin:LocalizeUI()
	UI.frame.setupFieldPanel(self, L.DB_STATUS, 150);

	self.RPStatusLabel:SetText(L.DB_STATUS_RP);
	self.XPStatusLabel:SetText(L.DB_STATUS_XP);
	self.RPLanguageLabel:SetText(L.DB_STATUS_LC);
end

-- Mixin for dropdown menus on the dashboard status panel.
local DashboardStatusMenuMixin = {};
TRP3_DashboardStatusMenuMixin = DashboardStatusMenuMixin;

-- Handler called when the menu frame is loaded.
function DashboardStatusMenuMixin:OnLoad()
	-- Connect to addon events.
	Events.registerCallback(Events.WORKFLOW_ON_LOADED,
		function(...) self:OnWorkflowLoaded(...); end);
	Events.registerCallback(Events.REGISTER_DATA_UPDATED,
		function(...) self:OnRegisterDataUpdated(...); end);
end

-- Handler called when the menu frame is shown.
function DashboardStatusMenuMixin:OnShow()
	self:RefreshMenu();
end

-- Handler called when the addon workflow reaches the loaded state.
function DashboardStatusMenuMixin:OnWorkflowLoaded()
	-- Defer registering config handlers to here, since OnLoad is too early.
	Config.registerHandler({ "AddonLocale" },
		function(...) self:OnLocaleChanged(...); end);

	self:InitializeMenu();
end

-- Handler called when the addon locale is changed.
function DashboardStatusMenuMixin:OnLocaleChanged()
	if MSA_DROPDOWNMENU_OPEN_MENU == self then
		-- Changing the locale will re-initialize the whole menu due to the
		-- fact that the individual buttons within will be localized.
		self:InitializeMenu();
	else
		-- Menu isn't open so we don't want to re-initialize.
		self:RefreshMenu();
	end
end

-- Handler called when register data is updated.
function DashboardStatusMenuMixin:OnRegisterDataUpdated(unitID, _, dataType)
	if unitID ~= Globals.player_id then
		-- This change doesn't affect the player.
		return;
	end

	if not dataType or dataType == "character" then
		-- The player's character data was changed.
		self:RefreshMenu();
	end
end

-- Handler called when the dropdown menu contents are initialized for
-- displaying in a list.
--
-- This should be overridden and populate the menu contents via the
-- provided CreateMenuItem/AddButtonToMenu type functions.
--
-- @param level The level of the dropdown menu being populated.
function DashboardStatusMenuMixin:OnMenuInitialize(--[[level]])
	-- Override to implement logic for initializing the dropdown menu.
end

-- Handler called when a dropdown menu button is clicked.
--
-- This should be overridden to perform changes to persistent state.
--
-- @param button The menu list button that was clicked.
function DashboardStatusMenuMixin:OnMenuButtonClicked(button)
	-- Override to implement logic when a menu button is clicked.
	MSA_DropDownMenu_SetSelectedValue(self, button.value);
end

-- Returns the displayable text for a given menu item value.
--
-- This should be overridden to return a displayable string for the menu
-- frame itself. This function may be called with a nil item value.
--
-- @param itemValue The menu item value to obtain a localized string for.
function DashboardStatusMenuMixin:GetMenuItemText(itemValue)
	-- Override to return a text label for the given menu item value.
	return itemValue ~= nil and tostring(itemValue) or nil;
end

-- Returns the item value that should be displayed as selected in the menu
-- based on persistent state elsewhere.
--
-- If no item is selected, this should return nil.
function DashboardStatusMenuMixin:GetSelectedMenuItem()
	-- Override to return the item value for the selected menu item.
end

-- Initializes the dropdown menu from scratch, rebuilding the list from the
-- model defined by OnMenuInitialize.
--
-- Calling this function will close any active dropdown menus.
function DashboardStatusMenuMixin:InitializeMenu()
	MSA_DropDownMenu_SetWidth(self, 170);
	MSA_DropDownMenu_Initialize(self, function(_, ...)
		-- Lazy binding as the method we're calling should be overridden.
		self:OnMenuInitialize(...)
	end);

	MSA_DropDownMenu_SetSelectedValue(self, self:GetSelectedMenuItem());
end

-- Refreshes the dropdown menu with the currently selected menu item data.
--
-- Unlike InitializeMenu, this function will not cause active dropdown menus
-- to close.
function DashboardStatusMenuMixin:RefreshMenu()
	if MSA_DROPDOWNMENU_OPEN_MENU == self then
		-- The menu is open; this means we can safely use the below functions
		-- without totally hosing other menus.
		MSA_DropDownMenu_SetSelectedValue(self, self:GetSelectedMenuItem());
		MSA_DropDownMenu_RefreshAll(self, false);
	else
		-- The menu isn't open, so the best we can do is update the label
		-- on the menu button itself.
		local selectedValue = self:GetSelectedMenuItem();
		local selectedText = self:GetMenuItemText(selectedValue);
		if not selectedText then
			-- Default to the "Custom" label, as is standard in the UI.
			selectedText = VIDEO_QUALITY_LABEL6;
		end

		MSA_DropDownMenu_SetText(self, selectedText);
	end
end

-- Obtains a dropdown menu item table for population by the OnMenuInitialize
-- handler. This item table will have sensible defaults present, but these
-- may be overridden as needed.
--
-- This function will error if called when the menu being initialized is not
-- our own.
--[[protected]] function DashboardStatusMenuMixin:CreateMenuItem()
	-- Preconditions: We must be initializing our own menu.
	assert(MSA_DROPDOWNMENU_INIT_MENU == self);

	-- Create the item and set up sensible defaults that are used almost
	-- universally anyways.
	local item = MSA_DropDownMenu_CreateInfo();
	item.tooltipOnButton = true;
	item.func = function(...) self:OnMenuButtonClicked(...); end

	return item;
end

-- Adds a given menu item table to the dropdown menu as a clickable button.
--
-- This function will error if called when the menu being initialized is not
-- our own.
--
-- @param item The item table to add as a button.
-- @param level The dropdown level to add this button at.
--[[protected]] function DashboardStatusMenuMixin:AddButtonToMenu(item, level)
	-- Preconditions: We must be initializing our own menu.
	assert(MSA_DROPDOWNMENU_INIT_MENU == self);

	-- Apply some additional modifications to the given item as a courtesy
	-- to reduce the amount of stuff done elsewhere.
	if not item.tooltipTitle and item.tooltipText ~= nil then
		-- Tooltip text but no title; use the item text as the title.
		item.tooltipTitle = item.text;
	end

	MSA_DropDownMenu_AddButton(item, level or 1);
end

-- Mixin for the Character Status dashboard menu.
local DashboardRPStatusMenuMixin = CreateFromMixins(DashboardStatusMenuMixin);
TRP3_DashboardRPStatusMenuMixin = DashboardRPStatusMenuMixin;

-- Mapping of menu item values to icons to display in the list.
DashboardRPStatusMenuMixin.Icons = {
	[Enums.ROLEPLAY_STATUS.IN_CHARACTER] = "|TInterface\\COMMON\\Indicator-Green:15|t",
	[Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER] = "|TInterface\\COMMON\\Indicator-Red:15|t",
};

--[[override]] function DashboardRPStatusMenuMixin:GetMenuItemText(itemValue)
	local itemText;
	if itemValue == Enums.ROLEPLAY_STATUS.IN_CHARACTER then
		-- In Character
		itemText = L.DB_STATUS_RP_IC;
	elseif itemValue == Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER then
		-- Out of Character
		itemText = L.DB_STATUS_RP_OOC;
	end

	if itemText then
		-- Format it with an icon before yielding the text.
		return format(L.DB_STATUS_ICON_ITEM, self.Icons[itemValue], itemText);
	end
end

--[[override]] function DashboardRPStatusMenuMixin:GetSelectedMenuItem()
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	return currentUser:GetRoleplayStatus();
end

--[[override]] function DashboardRPStatusMenuMixin:OnMenuInitialize(level)
	DashboardStatusMenuMixin.OnMenuInitialize(self, level);

	local item;

	-- In Character
	item = self:CreateMenuItem();
	item.value = Enums.ROLEPLAY_STATUS.IN_CHARACTER;
	item.text = self:GetMenuItemText(item.value);
	item.tooltipText = L.DB_STATUS_RP_IC_TT;
	self:AddButtonToMenu(item, level);

	-- Out of Character
	item = self:CreateMenuItem();
	item.value = Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
	item.text = self:GetMenuItemText(item.value);
	item.tooltipText = L.DB_STATUS_RP_OOC_TT;
	self:AddButtonToMenu(item, level);
end

--[[override]] function DashboardRPStatusMenuMixin:OnMenuButtonClicked(button)
	DashboardStatusMenuMixin.OnMenuButtonClicked(self, button);

	-- Update the character data on the current user profile.
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local character = currentUser:GetInfo("character");
	if character.RP == button.value then
		-- Value isn't changing.
		return;
	end

	character.RP = button.value;
	IncrementCharacterDataVersion(currentUser);
end

-- Mixin for the Roleplay Experience dashboard menu.
local DashboardXPStatusMenuMixin = CreateFromMixins(DashboardStatusMenuMixin);
TRP3_DashboardXPStatusMenuMixin = DashboardXPStatusMenuMixin;

-- Mapping of menu item values to icons to display in the list.
DashboardXPStatusMenuMixin.Icons = {
	[Enums.ROLEPLAY_EXPERIENCE.BEGINNER] = "|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20|t",
	[Enums.ROLEPLAY_EXPERIENCE.VOLUNTEER] = "|TInterface\\TARGETINGFRAME\\PortraitQuestBadge:15|t",
};

--[[override]] function DashboardXPStatusMenuMixin:GetMenuItemText(itemValue)
	local itemIcon, itemText;
	if itemValue == Enums.ROLEPLAY_EXPERIENCE.BEGINNER then
		-- Beginner/Rookie Roleplayer
		itemIcon = self.Icons[itemValue];
		itemText = L.DB_STATUS_XP_BEGINNER;
	elseif itemValue == Enums.ROLEPLAY_EXPERIENCE.EXPERIENCED then
		-- Experienced Roleplayer
		itemText = L.DB_STATUS_RP_EXP;
	elseif itemValue == Enums.ROLEPLAY_EXPERIENCE.VOLUNTEER then
		-- Volunteer Roleplayer
		itemIcon = self.Icons[itemValue];
		itemText = L.DB_STATUS_RP_VOLUNTEER;
	end

	if itemIcon and itemText then
		-- Format it with an icon before yielding the text.
		return format(L.DB_STATUS_ICON_ITEM, itemIcon, itemText);
	else
		return itemText;
	end
end

--[[override]] function DashboardXPStatusMenuMixin:GetSelectedMenuItem()
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	return currentUser:GetRoleplayExperience();
end

--[[override]] function DashboardXPStatusMenuMixin:OnMenuInitialize(level)
	DashboardStatusMenuMixin.OnMenuInitialize(self, level);

	local item;

	-- Beginner/Rookie Roleplayer
	item = self:CreateMenuItem();
	item.value = Enums.ROLEPLAY_EXPERIENCE.BEGINNER;
	item.text = self:GetMenuItemText(item.value);
	item.tooltipText = L.DB_STATUS_XP_BEGINNER_TT;
	self:AddButtonToMenu(item, level);

	-- Experienced Roleplayer
	item = self:CreateMenuItem();
	item.value = Enums.ROLEPLAY_EXPERIENCE.EXPERIENCED;
	item.text = self:GetMenuItemText(item.value);
	item.tooltipText = L.DB_STATUS_RP_EXP_TT;
	self:AddButtonToMenu(item, level);

	-- Volunteer Roleplayer
	item = self:CreateMenuItem();
	item.value = Enums.ROLEPLAY_EXPERIENCE.VOLUNTEER;
	item.text = self:GetMenuItemText(item.value);
	item.tooltipText = L.DB_STATUS_RP_VOLUNTEER_TT;
	self:AddButtonToMenu(item, level);
end

--[[override]] function DashboardXPStatusMenuMixin:OnMenuButtonClicked(button)
	DashboardStatusMenuMixin.OnMenuButtonClicked(self, button);

	-- Update the character data on the current user profile.
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local character = currentUser:GetInfo("character");
	if character.XP == button.value then
		-- Value isn't changing.
		return;
	end

	character.XP = button.value;
	IncrementCharacterDataVersion(currentUser);
end

-- Mixin for the Roleplay Language dashboard menu.
local DashboardRPLanguageMenuMixin = CreateFromMixins(DashboardStatusMenuMixin);
TRP3_DashboardRPLanguageMenuMixin = DashboardRPLanguageMenuMixin;

-- Handler called when the cursor enters the region for this menu.
function DashboardRPLanguageMenuMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_SetTitle(GameTooltip, L.DB_STATUS_LC);
	GameTooltip_AddNormalLine(GameTooltip, L.DB_STATUS_LC_TT, true);
	GameTooltip:Show();
end

--[[override]] function DashboardRPLanguageMenuMixin:GetMenuItemText(itemValue)
	if type(itemValue) ~= "string" then
		-- Protect against assertion failures.
		return;
	end

	local locale = L:GetLocale(itemValue);
	return locale and locale:GetName() or nil;
end

--[[override]] function DashboardRPLanguageMenuMixin:GetSelectedMenuItem()
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	return currentUser:GetRoleplayLanguage();
end

--[[override]] function DashboardRPLanguageMenuMixin:OnMenuInitialize(level)
	DashboardStatusMenuMixin.OnMenuInitialize(self, level);

	-- Grab all the registered locale codes and sort them.
	local localeCodes = {};
	for localeCode in pairs(L:GetLocales(true)) do
		table.insert(localeCodes, localeCode);
	end

	table.sort(localeCodes);

	-- Add all the locales to the menu.
	for _, localeCode in ipairs(localeCodes) do
		local locale = L:GetLocale(localeCode);

		local item = self:CreateMenuItem();
		item.value = localeCode;
		item.text = locale:GetName();
		self:AddButtonToMenu(item, level);
	end
end

--[[override]] function DashboardRPLanguageMenuMixin:OnMenuButtonClicked(button)
	DashboardStatusMenuMixin.OnMenuButtonClicked(self, button);

	-- Update the character data on the current user profile.
	local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
	local character = currentUser:GetInfo("character");
	if character.LC == button.value then
		-- Value isn't changing.
		return;
	end

	character.LC = button.value;
	IncrementCharacterDataVersion(currentUser);
end

--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local GenerateConfigurationPage;

local function ShouldDisableOutOfCharacter()
	return TRP3_API.configuration.getValue("UnitPopups_DisableOutOfCharacter");
end

local function ShouldDisableInCombat()
	return TRP3_API.configuration.getValue("UnitPopups_DisableInCombat");
end

local function ShouldDisableInInstances()
	return TRP3_API.configuration.getValue("UnitPopups_DisableInInstances");
end

local function ShouldDisableOnUnitFrames()
	return TRP3_API.configuration.getValue("UnitPopups_DisableOnUnitFrames");
end

local function ShouldShowHeaderText()
	return TRP3_API.configuration.getValue("UnitPopups_ShowHeaderText");
end

local function ShouldShowSeparator()
	return TRP3_API.configuration.getValue("UnitPopups_ShowSeparator");
end

local function ShouldShowOpenProfile()
	return TRP3_API.configuration.getValue("UnitPopups_ShowOpenProfile");
end

local function ShouldShowCharacterStatus()
	return TRP3_API.configuration.getValue("UnitPopups_ShowCharacterStatus");
end

--
-- Unit Popups Module
--

local UnitPopupsModule = {};

UnitPopupsModule.MenuButtons = {};
UnitPopupsModule.MenuEntries = {};

function UnitPopupsModule:OnModuleInitialize()
	for _, setting in pairs(UnitPopupsModule.Configuration) do
		TRP3_API.configuration.registerConfigKey(setting.key, setting.default);
	end

	TRP3_API.configuration.registerConfigurationPage(GenerateConfigurationPage());
end

function UnitPopupsModule:OnModuleEnable()
	hooksecurefunc("UnitPopup_ShowMenu", function(...) return self:OnUnitPopupShown(...); end);
end

function UnitPopupsModule:OnUnitPopupShown(dropdownMenu, menuType)
	if not dropdownMenu or dropdownMenu:IsForbidden() then
		return;  -- Invalid or forbidden menu.
	elseif UIDROPDOWNMENU_MENU_LEVEL ~= 1 then
		return;  -- We don't support submenus.
	elseif not self:ShouldCustomizeMenus() then
		return;  -- Menu customizations are disabled.
	elseif ShouldDisableOnUnitFrames() and dropdownMenu:GetParent() and dropdownMenu:GetParent():IsProtected() then
		return;  -- Parent of the menu is a protected probably-unit frame.
	end

	local buttons = self:GetButtonsForMenu(menuType);

	if #buttons == 0 then
		return;  -- No buttons to be shown.
	end

	-- The top-level menu has a separator/header display before the actual
	-- items are added. This is user-configurable to deal with cases such
	-- as the Raider.IO addon which itself also adds unit menu options with
	-- its own separator.

	if ShouldShowSeparator() then
		UIDropDownMenu_AddSeparator();
	end

	if ShouldShowHeaderText() then
		UIDropDownMenu_AddButton(self.MenuButtons.RoleplayOptions);
	end

	for _, button in ipairs(buttons) do
		UIDropDownMenu_AddButton(button, UIDROPDOWNMENU_MENU_LEVEL);
	end
end

function UnitPopupsModule:ShouldCustomizeMenus()
	local player = AddOn_TotalRP3.Player.GetCurrentUser();

	if ShouldDisableOutOfCharacter() and not player:IsInCharacter() then
		return false;
	elseif ShouldDisableInCombat() and InCombatLockdown() then
		return false;
	elseif ShouldDisableInInstances() and IsInInstance() then
		return false;
	else
		return true;
	end
end

function UnitPopupsModule:GetButtonsForMenu(menuType)
	local entries = self.MenuEntries[menuType];
	local buttons = {};

	if entries then
		for _, buttonId in ipairs(entries) do
			local button = self.MenuButtons[buttonId];

			if button:ShouldShow() then
				table.insert(buttons, button);
			end
		end
	end

	return buttons;
end

--
-- Menu Commands
--

local function OpenProfile(button)  -- luacheck: ignore 212 (unused button)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
	local unit = dropdownFrame.unit;
	local name = dropdownFrame.name;
	local server = dropdownFrame.server;
	local fullName = string.join("-", name or UNKNOWNOBJECT, server or GetNormalizedRealmName());

	if UnitExists(unit) then
		TRP3_API.slash.openProfile(unit);
	elseif not string.find(fullName, UNKNOWNOBJECT, 1, true) then
		TRP3_API.slash.openProfile(fullName);
	end
end

local function IsOutOfCharacter(button)  -- luacheck: ignore 212 (unused button)
	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	local roleplayStatus = player:GetRoleplayStatus();

	return roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
end

local function ToggleCharacterStatus(button)
	local player = AddOn_TotalRP3.Player.GetCurrentUser();

	if button.checked() then
		player:SetRoleplayStatus(AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER);
	else
		player:SetRoleplayStatus(AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
	end
end

--
-- Menu Data
--

Mixin(UnitPopupsModule.MenuButtons, {
	RoleplayOptions = {
		text = L.UNIT_POPUPS_ROLEPLAY_OPTIONS_HEADER,
		isTitle = true,
		isUninteractable = true,
		notCheckable = true,
	},

	OpenProfile = {
		text = L.UNIT_POPUPS_OPEN_PROFILE,
		notCheckable = true,
		func = OpenProfile,
		ShouldShow = ShouldShowOpenProfile,
	},

	CharacterStatus = {
		text = L.DB_STATUS_RP_OOC,
		notCheckable = false,
		isNotRadio = true,
		keepShownOnClick = true,
		checked = IsOutOfCharacter,
		func = ToggleCharacterStatus,
		ShouldShow = ShouldShowCharacterStatus,
	},
});

Mixin(UnitPopupsModule.MenuEntries, {
	CHAT_ROSTER    = { "OpenProfile" },
	FRIEND         = { "OpenProfile" },
	FRIEND_OFFLINE = { "OpenProfile" },
	GUILD          = { "OpenProfile" },
	GUILD_OFFLINE  = { "OpenProfile" },
	PARTY          = { "OpenProfile" },
	PLAYER         = { "OpenProfile" },
	RAID           = { "OpenProfile" },
	RAID_PLAYER    = { "OpenProfile" },
	SELF           = { "OpenProfile", "CharacterStatus" },
});

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_unitpopups",
	name = L.UNIT_POPUPS_MODULE_NAME,
	description = L.UNIT_POPUPS_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	onInit = function() UnitPopupsModule:OnModuleInitialize(); end,
	onStart = function() UnitPopupsModule:OnModuleEnable(); end,
});

--
-- Configuration Data
--

UnitPopupsModule.Configuration = {
	DisableOutOfCharacter = {
		key = "UnitPopups_DisableOutOfCharacter",
		default = false,
	},

	DisableInCombat = {
		key = "UnitPopups_DisableInCombat",
		default = false,
	},

	DisableInInstances = {
		key = "UnitPopups_DisableInInstances",
		default = false,
	},

	DisableOnUnitFrames = {
		key = "UnitPopups_DisableOnUnitFrames",
		default = false,
	},

	ShowHeaderText = {
		key = "UnitPopups_ShowHeaderText",
		default = true,
	},

	ShowSeparator = {
		key = "UnitPopups_ShowSeparator",
		default = true,
	},

	ShowOpenProfile = {
		key = "UnitPopups_ShowOpenProfile",
		default = true,
	},

	ShowCharacterStatus = {
		key = "UnitPopups_ShowCharacterStatus",
		default = true,
	},
};

function GenerateConfigurationPage()
	return {
		id = "main_config_unitpopups",
		menuText = L.UNIT_POPUPS_CONFIG_MENU_TITLE,
		pageText = L.UNIT_POPUPS_CONFIG_PAGE_TEXT,
		elements = {
			{
				inherit = "TRP3_ConfigParagraph",
				title = L.UNIT_POPUPS_CONFIG_PAGE_HELP,
			},
			{
				inherit = "TRP3_ConfigButton",
				title = L.UNIT_POPUPS_CONFIG_ENABLE_MODULE,
				text = DISABLE,
				OnClick = function()
					TRP3_API.popup.showConfirmPopup(L.UNIT_POPUPS_MODULE_DISABLE_WARNING, function()
						local current = TRP3_Configuration.MODULE_ACTIVATION["trp3_unitpopups"];
						TRP3_Configuration.MODULE_ACTIVATION["trp3_unitpopups"] = not current;
						ReloadUI();
					end);
				end,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.UNIT_POPUPS_CONFIG_VISIBILITY_HEADER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_DISABLE_OUT_OF_CHARACTER,
				help = L.UNIT_POPUPS_CONFIG_DISABLE_OUT_OF_CHARACTER_HELP,
				configKey = "UnitPopups_DisableOutOfCharacter",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_DISABLE_IN_COMBAT,
				help = L.UNIT_POPUPS_CONFIG_DISABLE_IN_COMBAT_HELP,
				configKey = "UnitPopups_DisableInCombat",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_DISABLE_IN_INSTANCES,
				help = L.UNIT_POPUPS_CONFIG_DISABLE_IN_INSTANCES_HELP,
				configKey = "UnitPopups_DisableInInstances",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_DISABLE_ON_UNIT_FRAMES,
				help = L.UNIT_POPUPS_CONFIG_DISABLE_ON_UNIT_FRAMES_HELP,
				configKey = "UnitPopups_DisableOnUnitFrames",
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.UNIT_POPUPS_CONFIG_ENTRIES_HEADER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_SHOW_HEADER_TEXT,
				help = L.UNIT_POPUPS_CONFIG_SHOW_HEADER_TEXT_HELP,
				configKey = "UnitPopups_ShowHeaderText",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_SHOW_SEPARATOR,
				help = L.UNIT_POPUPS_CONFIG_SHOW_SEPARATOR_HELP,
				configKey = "UnitPopups_ShowSeparator",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_SHOW_OPEN_PROFILE,
				help = L.UNIT_POPUPS_CONFIG_SHOW_OPEN_PROFILE_HELP,
				configKey = "UnitPopups_ShowOpenProfile",
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.UNIT_POPUPS_CONFIG_SHOW_CHARACTER_STATUS,
				help = L.UNIT_POPUPS_CONFIG_SHOW_CHARACTER_STATUS_HELP,
				configKey = "UnitPopups_ShowCharacterStatus",
			},
		},
	};
end

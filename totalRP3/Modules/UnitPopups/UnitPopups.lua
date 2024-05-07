-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

local LibDropDownExtension = LibStub:GetLibrary("LibDropDownExtension-1.0");

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

local function ShouldShowOpenProfile()
	return TRP3_API.configuration.getValue("UnitPopups_ShowOpenProfile");
end

local function ShouldShowCharacterStatus()
	-- Character status is disabled as LibDropDownExtension has a rather silly
	-- bug where it doesn't anchor the text to the right of the check texture
	-- correctly, leading to two overlapping one another.

	return false;
end

local function GetUnitCompanionProfileInfo(unitToken)
	local unitType = TRP3_API.ui.misc.getTargetType(unitToken);
	local companionFullID = TRP3_API.ui.misc.getCompanionFullID(unitToken, unitType);
	local owner, companionID = TRP3_API.utils.str.companionIDToInfo(companionFullID);
	local profileType, profileID;

	if owner == TRP3_API.globals.player_id then
		profileType = "SELF";
		profileID = TRP3_API.companions.player.getCompanionProfileID(companionID);
	else
		profileType = "OTHER";
		profileID = TRP3_API.companions.register.companionHasProfile(companionFullID);
	end

	if profileType and profileID then
		return { type = profileType, id = profileID };
	else
		return nil;
	end
end

local function ShouldShowOpenCompanionProfile()
	if not ShouldShowOpenProfile() then
		return false;
	end

	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
	local unitToken = dropdownFrame.unit or "none";
	local profileInfo = GetUnitCompanionProfileInfo(unitToken);

	if not profileInfo then
		return false;
	else
		return true;
	end
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
	local MAX_DROPDOWN_LEVEL = 1;

	LibDropDownExtension:RegisterEvent("OnShow", GenerateClosure(self.OnUnitPopupShown, self), MAX_DROPDOWN_LEVEL);
end

function UnitPopupsModule:OnUnitPopupShown(dropdownMenu, _, options)
	if not dropdownMenu or dropdownMenu:IsForbidden() then
		return;  -- Invalid or forbidden menu.
	elseif not self:ShouldCustomizeMenus() then
		return;  -- Menu customizations are disabled.
	elseif ShouldDisableOnUnitFrames() and dropdownMenu:GetParent() and dropdownMenu:GetParent():IsProtected() then
		return;  -- Parent of the menu is a protected probably-unit frame.
	end

	-- The table of options that we insert to is local to our instance of the
	-- event registration; as such we're safe to wipe it each time the menu
	-- is shown to prevent entries getting duplicated each time.

	table.wipe(options);

	local menuType = dropdownMenu.which;
	local buttons = self:GetButtonsForMenu(menuType);

	if #buttons == 0 then
		return;  -- No buttons to be shown.
	end

	if ShouldShowHeaderText() then
		table.insert(options, self.MenuButtons.RoleplayOptions);
	end

	for _, button in ipairs(buttons) do
		table.insert(options, button);
	end

	return true;
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

local function OpenCompanionProfile(button)  -- luacheck: ignore 212 (unused button)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
	local unitToken = dropdownFrame.unit;
	local profileInfo = GetUnitCompanionProfileInfo(unitToken);

	if not profileInfo then
		return;  -- Maybe something unlinked it while the menu was open?
	elseif profileInfo.type == "SELF" then
		TRP3_API.companions.openPage(profileInfo.id);
		TRP3_API.navigation.openMainFrame();
	elseif profileInfo.type == "OTHER" then
		TRP3_API.companions.register.openPage(profileInfo.id);
		TRP3_API.navigation.openMainFrame();
	end
end

local function IsOutOfCharacter(button)  -- luacheck: ignore 212 (unused button)
	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	local roleplayStatus = player:GetRoleplayStatus();

	return roleplayStatus == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
end

local function ToggleCharacterStatus(button)
	local player = AddOn_TotalRP3.Player.GetCurrentUser();

	if button.option.checked() then
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

	OpenCompanionProfile = {
		text = L.UNIT_POPUPS_OPEN_PROFILE,
		notCheckable = true,
		func = OpenCompanionProfile,
		ShouldShow = ShouldShowOpenCompanionProfile,
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
	BATTLEPET      = { "OpenCompanionProfile" },
	CHAT_ROSTER    = { "OpenProfile" },
	FRIEND         = { "OpenProfile" },
	FRIEND_OFFLINE = { "OpenProfile" },
	GUILD          = { "OpenProfile" },
	GUILD_OFFLINE  = { "OpenProfile" },
	OTHERBATTLEPET = { "OpenCompanionProfile" },
	OTHERPET       = { "OpenCompanionProfile" },
	PARTY          = { "OpenProfile" },
	PET            = { "OpenCompanionProfile" },
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
				title = L.UNIT_POPUPS_CONFIG_SHOW_OPEN_PROFILE,
				help = L.UNIT_POPUPS_CONFIG_SHOW_OPEN_PROFILE_HELP,
				configKey = "UnitPopups_ShowOpenProfile",
			},
			-- TODO: Re-add this option when LibDropDownExtension is fixed.
			-- {
			-- 	inherit = "TRP3_ConfigCheck",
			-- 	title = L.UNIT_POPUPS_CONFIG_SHOW_CHARACTER_STATUS,
			-- 	help = L.UNIT_POPUPS_CONFIG_SHOW_CHARACTER_STATUS_HELP,
			-- 	configKey = "UnitPopups_ShowCharacterStatus",
			-- },
		},
	};
end

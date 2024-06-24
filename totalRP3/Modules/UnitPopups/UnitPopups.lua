-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

if not Menu or not Menu.ModifyMenu then
	return;
end

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

local function ShouldShowOpenProfile(contextData)  -- luacheck: no unused
	return TRP3_API.configuration.getValue("UnitPopups_ShowOpenProfile");
end

local function ShouldShowCharacterStatus(contextData)  -- luacheck: no unused
	return TRP3_API.configuration.getValue("UnitPopups_ShowCharacterStatus");
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

local function GetBattleNetCharacterID(gameAccountInfo)
	local characterName = gameAccountInfo.characterName;
	local realmName = gameAccountInfo.realmName;
	local ambiguatedName;

	characterName = (characterName ~= "" and characterName or UNKNOWNOBJECT);
	realmName = (realmName ~= "" and realmName or GetNormalizedRealmName());
	ambiguatedName = Ambiguate(string.join("-", characterName, realmName), "none");

	if string.find(ambiguatedName, UNKNOWNOBJECT, 1, true) == 1 then
		ambiguatedName = nil;
	end

	return ambiguatedName;
end

local function ShouldShowOpenBattleNetProfile(contextData)
	if not ShouldShowOpenProfile(contextData) then
		return false;
	end

	local accountInfo = contextData.accountInfo;
	local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo or nil;

	if not gameAccountInfo then
		return false;
	elseif gameAccountInfo.clientProgram ~= BNET_CLIENT_WOW then
		return false;
	elseif gameAccountInfo.wowProjectID ~= WOW_PROJECT_ID then
		return false;
	elseif not gameAccountInfo.isInCurrentRegion then
		return false;
	end

	local characterID = GetBattleNetCharacterID(gameAccountInfo);

	if not characterID then
		return false;
	else
		return true;
	end
end

local function ShouldShowOpenCompanionProfile(contextData)
	if not ShouldShowOpenProfile(contextData) then
		return false;
	end

	local unitToken = contextData.unit or "none";
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

UnitPopupsModule.MenuElementFactories = {};
UnitPopupsModule.MenuEntries = {};

function UnitPopupsModule:OnModuleInitialize()
	for _, setting in pairs(UnitPopupsModule.Configuration) do
		TRP3_API.configuration.registerConfigKey(setting.key, setting.default);
	end

	TRP3_API.configuration.registerConfigurationPage(GenerateConfigurationPage());
end

function UnitPopupsModule:OnModuleEnable()
	for menuTagSuffix in pairs(UnitPopupsModule.MenuEntries) do
		-- The closure supplied to ModifyMenu needs to be unique on each
		-- iteration of the loop as it acts as an "owner" in a callback
		-- registry behind the scenes. If not unique, successive registrations
		-- will replace previous ones.

		local function OnMenuOpen(owner, rootDescription, contextData)
			self:OnMenuOpen(owner, rootDescription, contextData);
		end

		local menuTag = "MENU_UNIT_" .. menuTagSuffix;
		Menu.ModifyMenu(menuTag, OnMenuOpen);
	end
end

function UnitPopupsModule:OnMenuOpen(owner, rootDescription, contextData)
	if not owner or owner:IsForbidden() then
		return;  -- Invalid or forbidden owner.
	elseif not self:ShouldCustomizeMenus() then
		return;  -- Menu customizations are disabled.
	elseif ShouldDisableOnUnitFrames() and owner:IsProtected() then
		return;  -- Owner of the menu is a protected probably-unit frame.
	end

	local menuEntries = self.MenuEntries[contextData.which];

	if menuEntries then
		rootDescription:QueueDivider();
		rootDescription:QueueTitle(L.UNIT_POPUPS_ROLEPLAY_OPTIONS_HEADER);

		for _, elementFactoryKey in ipairs(menuEntries) do
			local factory = self.MenuElementFactories[elementFactoryKey];

			if factory then
				factory(rootDescription, contextData);
			end
		end

		rootDescription:ClearQueuedDescriptions();
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

--
-- Menu element factories
--

local function CreateOpenBattleNetProfileButton(menuDescription, contextData)
	if not ShouldShowOpenBattleNetProfile(contextData) then
		return nil;
	end

	local function OnClick(contextData)  -- luacheck: no redefined
		local accountInfo = contextData.accountInfo;
		local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo or nil;

		-- Only a basic sanity test is required here.
		if not gameAccountInfo then
			return;
		end

		local characterID = GetBattleNetCharacterID(gameAccountInfo);

		if characterID then
			TRP3_API.slash.openProfile(characterID);
		end
	end

	local elementDescription = menuDescription:CreateButton(L.UNIT_POPUPS_OPEN_PROFILE);
	elementDescription:SetResponder(OnClick);
	elementDescription:SetData(contextData);
	return elementDescription;
end

local function CreateOpenCharacterProfileButton(menuDescription, contextData)
	if not ShouldShowOpenProfile(contextData) then
		return nil;
	end

	local function OnClick(contextData)  -- luacheck: no redefined
		local unit = contextData.unit;
		local name = contextData.name;
		local server = contextData.server;
		local fullName = string.join("-", name or UNKNOWNOBJECT, server or GetNormalizedRealmName());

		if UnitExists(unit) then
			TRP3_API.slash.openProfile(unit);
		elseif not string.find(fullName, UNKNOWNOBJECT, 1, true) then
			TRP3_API.slash.openProfile(fullName);
		end
	end

	local elementDescription = menuDescription:CreateButton(L.UNIT_POPUPS_OPEN_PROFILE);
	elementDescription:SetResponder(OnClick);
	elementDescription:SetData(contextData);
	return elementDescription;
end

local function CreateOpenCompanionProfileButton(menuDescription, contextData)
	if not ShouldShowOpenCompanionProfile(contextData) then
		return nil;
	end

	local function OnClick(contextData)  -- luacheck: no redefined
		local unitToken = contextData.unit;
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

	local elementDescription = menuDescription:CreateButton(L.UNIT_POPUPS_OPEN_PROFILE);
	elementDescription:SetResponder(OnClick);
	elementDescription:SetData(contextData);
	return elementDescription;
end

local function CreateCharacterStatusMenu(menuDescription, contextData)
	if not ShouldShowCharacterStatus(contextData) then
		return nil;
	end

	local function IsSelected(status)
		local player = AddOn_TotalRP3.Player.GetCurrentUser();
		local roleplayStatus = player:GetRoleplayStatus();
		return roleplayStatus == status;
	end

	local function SetSelected(status)
		local player = AddOn_TotalRP3.Player.GetCurrentUser();
		player:SetRoleplayStatus(status);
	end

	local elementDescription = menuDescription:CreateButton(L.DB_STATUS_RP);

	do
		local state = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
		local button = elementDescription:CreateRadio(L.DB_STATUS_RP_IC, IsSelected, SetSelected, state);
		TRP3_MenuUtil.SetElementTooltip(button, L.DB_STATUS_RP_IC_TT);
	end

	do
		local state = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
		local button = elementDescription:CreateRadio(L.DB_STATUS_RP_OOC, IsSelected, SetSelected, state);
		TRP3_MenuUtil.SetElementTooltip(button, L.DB_STATUS_RP_OOC_TT);
	end

	return elementDescription;
end

--
-- Menu Data
--

UnitPopupsModule.MenuElementFactories = {
	OpenBattleNetProfile = CreateOpenBattleNetProfileButton,
	OpenCharacterProfile = CreateOpenCharacterProfileButton,
	OpenCompanionProfile = CreateOpenCompanionProfileButton,
	CharacterStatus = CreateCharacterStatusMenu,
};

UnitPopupsModule.MenuEntries = {
	BATTLEPET      = { "OpenCompanionProfile" },
	BN_FRIEND      = { "OpenBattleNetProfile" },
	CHAT_ROSTER    = { "OpenCharacterProfile" },
	FRIEND         = { "OpenCharacterProfile" },
	FRIEND_OFFLINE = { "OpenCharacterProfile" },
	GUILD          = { "OpenCharacterProfile" },
	GUILD_OFFLINE  = { "OpenCharacterProfile" },
	OTHERBATTLEPET = { "OpenCompanionProfile" },
	OTHERPET       = { "OpenCompanionProfile" },
	PARTY          = { "OpenCharacterProfile" },
	PET            = { "OpenCompanionProfile" },
	PLAYER         = { "OpenCharacterProfile" },
	RAID           = { "OpenCharacterProfile" },
	RAID_PLAYER    = { "OpenCharacterProfile" },
	SELF           = { "OpenCharacterProfile", "CharacterStatus" },
};

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

TRP3_UnitPopupsModule = UnitPopupsModule;

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

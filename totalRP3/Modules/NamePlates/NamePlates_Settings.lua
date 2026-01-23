-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- Global cache of all nameplate settings. This is to eliminate the nested
-- function calls for each individual settings query multipled by the number
-- of active nameplates, which added up to a significant amount of performance
-- overhead.
--
-- This will be a table with the same keys as the DefaultSettings below, and
-- is updated each time the LoadSettings function is called.
TRP3_NamePlatesSettings = nil;

TRP3_NamePlateUnitCustomizationState = {
	Show = 1,
	Hide = 2,
	Disable = 3,
};

TRP3_NamePlateUnitNameDisplayMode = {
	FullName = 1,
	FirstName = 2,
	OriginalName = 3,
};

TRP3_NamePlateSubTextDisplayMode = {
	FullTitle = 1,
	GuildName = 2,
	FullTitleAndGuildName = 3,
	Nothing = 4,
}

local DefaultSettings = {
	CustomizeGuild = false,
	CustomizeHealthColors = true,
	CustomizeIcons = false,
	CustomizeNameColors = true,
	CustomizeNonRoleplayUnits = TRP3_NamePlateUnitCustomizationState.Show,
	CustomizeOOCUnits = TRP3_NamePlateUnitCustomizationState.Show,
	CustomizeNPCUnits = TRP3_NamePlateUnitCustomizationState.Show,
	CustomizeNames = TRP3_NamePlateUnitNameDisplayMode.FullName,
	CustomizeRoleplayStatus = false,
	CustomizeSubText = TRP3_NamePlateSubTextDisplayMode.Nothing,
	CustomizeTitles = true,
	DisableInCombat = false,
	DisableInInstances = true,
	DisableOutOfCharacter = false,
	EnableActiveQuery = true,
	EnableClassColorFallback = true,
	EnableNameOnlyMode = false,
	IconSize = 16,
	MaximumNameLength = 30,
	MaximumTitleLength = 30,
	MaximumGuildNameLength = 30,
	PreferredOOCIndicator = TRP3_OOCIndicatorStyle.Text,
	ShowTargetUnit = true,
	TooltipFullTitleColor = TRP3_API.Colors.White:GenerateHexColor(),
	TooltipGuildNameColor = TRP3_API.Colors.Yellow:GenerateHexColor(),
};

local function MapSettingToConfigKey(field)
	return "NamePlates_" .. field;
end

function TRP3_NamePlatesUtil.IsValidSetting(key)
	local plain = true;
	return string.find(key, "NamePlates_", 1, plain) == 1;
end

function TRP3_NamePlatesUtil.LoadSettings()
	local settings = {};

	for field in pairs(DefaultSettings) do
		settings[field] = TRP3_API.configuration.getValue(MapSettingToConfigKey(field));
	end

	TRP3_NamePlatesSettings = settings;
end

local subTextOptions = {
	{ L.NAMEPLATES_CONFIG_SUBTEXT_FULL_TITLE, TRP3_NamePlateSubTextDisplayMode.FullTitle, L.NAMEPLATES_CONFIG_SUBTEXT_FULL_TITLE_HELP },
	{ L.NAMEPLATES_CONFIG_SUBTEXT_NOTHING, TRP3_NamePlateSubTextDisplayMode.Nothing, L.NAMEPLATES_CONFIG_SUBTEXT_NOTHING_HELP },
}

local isPlaterLoaded = C_AddOns.IsAddOnLoaded("Plater");
local isPlatynatorLoaded = C_AddOns.IsAddOnLoaded("Platynator");

-- Plater handles guild name display in its own settings, we can only handle Full Titles.
if not isPlaterLoaded then
	tinsert(subTextOptions, #subTextOptions, { L.NAMEPLATES_CONFIG_SUBTEXT_GUILD_NAME, TRP3_NamePlateSubTextDisplayMode.GuildName, L.NAMEPLATES_CONFIG_SUBTEXT_GUILD_NAME_HELP:format(L.NAMEPLATES_CONFIG_CUSTOMIZE_GUILD) });
end

-- Plater handles guild name display in its own settings, we can only handle Full Titles & Platynator only allows Full Title OR Guild Name.
if not isPlaterLoaded and not isPlatynatorLoaded then
	tinsert(subTextOptions, #subTextOptions, {L.NAMEPLATES_CONFIG_SUBTEXT_FULL_TITLE_GUILD_NAME, TRP3_NamePlateSubTextDisplayMode.FullTitleAndGuildName, L.NAMEPLATES_CONFIG_SUBTEXT_FULL_TITLE_GUILD_NAME_HELP:format(L.NAMEPLATES_CONFIG_CUSTOMIZE_GUILD) });
end

function TRP3_NamePlatesUtil.RegisterSettings()
	for key, default in pairs(DefaultSettings) do
		TRP3_API.configuration.registerConfigKey(MapSettingToConfigKey(key), default);
	end

	TRP3_API.configuration.registerConfigurationPage({
		id = "main_config_nameplates",
		menuText = L.NAMEPLATES_NAME,
		pageText = L.NAMEPLATES_CONFIG_PAGE_TEXT,
		elements = {
			{
				inherit = "TRP3_ConfigParagraph",
				title = L.NAMEPLATES_CONFIG_PAGE_HELP .. "|n|n" .. L.NAMEPLATES_CONFIG_PAGE_SETTINGS_MAY_REQUIRE_TOGGLE_HELP,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.NAMEPLATES_CONFIG_VISIBILITY_HEADER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_IN_COMBAT,
				help = L.NAMEPLATES_CONFIG_DISABLE_IN_COMBAT_HELP,
				configKey = MapSettingToConfigKey("DisableInCombat"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_IN_INSTANCES,
				help = L.NAMEPLATES_CONFIG_DISABLE_IN_INSTANCES_HELP,
				configKey = MapSettingToConfigKey("DisableInInstances"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER,
				help = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_HELP,
				configKey = MapSettingToConfigKey("DisableOutOfCharacter"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_TARGET_UNIT,
				help = L.NAMEPLATES_CONFIG_SHOW_TARGET_UNIT_HELP,
				configKey = MapSettingToConfigKey("ShowTargetUnit"),
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NON_ROLEPLAY_UNITS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NON_ROLEPLAY_UNITS_HELP,
				listContent = {
					{ L.CM_DO_NOT_SHOW, TRP3_NamePlateUnitCustomizationState.Hide, L.NAMEPLATES_CONFIG_UNIT_STATE_HIDE_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_STATE_DISABLE, TRP3_NamePlateUnitCustomizationState.Disable, L.NAMEPLATES_CONFIG_UNIT_STATE_DISABLE_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_STATE_SHOW, TRP3_NamePlateUnitCustomizationState.Show, L.NAMEPLATES_CONFIG_UNIT_STATE_SHOW_HELP },
				},
				configKey = MapSettingToConfigKey("CustomizeNonRoleplayUnits"),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_OOC_UNITS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_OOC_UNITS_HELP,
				listContent = {
					{ L.CM_DO_NOT_SHOW, TRP3_NamePlateUnitCustomizationState.Hide, L.NAMEPLATES_CONFIG_UNIT_STATE_HIDE_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_STATE_DISABLE, TRP3_NamePlateUnitCustomizationState.Disable, L.NAMEPLATES_CONFIG_UNIT_STATE_DISABLE_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_STATE_SHOW, TRP3_NamePlateUnitCustomizationState.Show, L.NAMEPLATES_CONFIG_UNIT_STATE_SHOW_HELP },
				},
				configKey = MapSettingToConfigKey("CustomizeOOCUnits"),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NPC_UNITS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NPC_UNITS_HELP,
				listContent = {
					{ L.CM_DO_NOT_SHOW, TRP3_NamePlateUnitCustomizationState.Hide, L.NAMEPLATES_CONFIG_UNIT_STATE_HIDE_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_STATE_DISABLE, TRP3_NamePlateUnitCustomizationState.Disable, L.NAMEPLATES_CONFIG_UNIT_STATE_DISABLE_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_STATE_SHOW, TRP3_NamePlateUnitCustomizationState.Show, L.NAMEPLATES_CONFIG_UNIT_STATE_SHOW_HELP },
				},
				configKey = MapSettingToConfigKey("CustomizeNPCUnits"),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.NAMEPLATES_CONFIG_ELEMENT_HEADER,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAMES,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAMES_HELP,
				listContent = {
					{ L.NAMEPLATES_CONFIG_UNIT_NAME_ORIGINAL, TRP3_NamePlateUnitNameDisplayMode.OriginalName, L.NAMEPLATES_CONFIG_UNIT_NAME_ORIGINAL_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_NAME_FIRST, TRP3_NamePlateUnitNameDisplayMode.FirstName, L.NAMEPLATES_CONFIG_UNIT_NAME_FIRST_HELP },
					{ L.NAMEPLATES_CONFIG_UNIT_NAME_FULL, TRP3_NamePlateUnitNameDisplayMode.FullName, L.NAMEPLATES_CONFIG_UNIT_NAME_FULL_HELP },
				},
				configKey = MapSettingToConfigKey("CustomizeNames"),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_MAX_NAME_CHARS,
				help = L.NAMEPLATES_CONFIG_MAX_NAME_CHARS_HELP,
				configKey = MapSettingToConfigKey("MaximumNameLength"),
				min = 10,
				max = 60,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAME_COLORS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAME_COLORS_HELP,
				configKey = MapSettingToConfigKey("CustomizeNameColors"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS_HELP,
				configKey = MapSettingToConfigKey("CustomizeHealthColors"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_ENABLE_CLASS_COLOR_FALLBACK,
				help = L.NAMEPLATES_CONFIG_ENABLE_CLASS_COLOR_FALLBACK_HELP,
				configKey = MapSettingToConfigKey("EnableClassColorFallback"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_TITLES,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_TITLES_HELP,
				configKey = MapSettingToConfigKey("CustomizeTitles"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_ROLEPLAY_STATUS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_ROLEPLAY_STATUS_HELP,
				configKey = MapSettingToConfigKey("CustomizeRoleplayStatus"),
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR,
				listContent = {
					{ L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT .. TRP3_API.Colors.Red(L.CM_OOC), TRP3_OOCIndicatorStyle.Text },
					{ L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_ICON .. TRP3_NamePlatesUtil.OOC_ICON, TRP3_OOCIndicatorStyle.Icon },
				},
				configKey = MapSettingToConfigKey("PreferredOOCIndicator"),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_ICONS,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_ICONS_HELP,
				configKey = MapSettingToConfigKey("CustomizeIcons"),
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_ICON_SIZE,
				help = L.NAMEPLATES_CONFIG_ICON_SIZE_HELP,
				configKey = MapSettingToConfigKey("IconSize"),
				min = 12,
				max = 48,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_SUBTEXT,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_SUBTEXT_HELP,
				listContent = subTextOptions,
				configKey = MapSettingToConfigKey("CustomizeSubText"),
				listWidth = nil,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = L.NAMEPLATES_CONFIG_TOOLTIP_FULL_TITLE_COLOR,
				help = L.NAMEPLATES_CONFIG_TOOLTIP_FULL_TITLE_COLOR_HELP,
				configKey = MapSettingToConfigKey("TooltipFullTitleColor"),
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_MAX_TITLE_CHARS,
				help = L.NAMEPLATES_CONFIG_MAX_TITLE_CHARS_HELP,
				configKey = MapSettingToConfigKey("MaximumTitleLength"),
				min = 10,
				max = 60,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_GUILD,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_GUILD_HELP,
				configKey = MapSettingToConfigKey("CustomizeGuild"),
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = L.NAMEPLATES_CONFIG_TOOLTIP_GUILD_NAME_COLOR,
				help = L.NAMEPLATES_CONFIG_TOOLTIP_GUILD_NAME_COLOR_HELP,
				configKey = MapSettingToConfigKey("TooltipGuildNameColor"),
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_MAX_GUILD_NAME_CHARS,
				help = L.NAMEPLATES_CONFIG_MAX_GUILD_NAME_CHARS_HELP,
				configKey = MapSettingToConfigKey("MaximumGuildNameLength"),
				min = 10,
				max = 60,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.CO_ADVANCED_SETTINGS,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_ACTIVE_QUERY,
				help = L.NAMEPLATES_CONFIG_ACTIVE_QUERY_HELP,
				configKey = MapSettingToConfigKey("EnableActiveQuery"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_BLIZZARD_NAME_ONLY,
				help = L.NAMEPLATES_CONFIG_BLIZZARD_NAME_ONLY_HELP,
				configKey = MapSettingToConfigKey("EnableNameOnlyMode"),
				OnClick = function(button)
					TRP3_NamePlatesUtil.SetNameOnlyModeEnabled(button:GetChecked());
				end,
			},
		}
	});
end

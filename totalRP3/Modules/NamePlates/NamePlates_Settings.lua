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

local DefaultSettings = {
	CustomizeFirstNames = false,
	CustomizeFullTitles = false,
	CustomizeHealthColors = true,
	CustomizeIcons = false,
	CustomizeNameColors = true,
	CustomizeNames = true,
	CustomizeRoleplayStatus = false,
	CustomizeTitles = true,
	DisableInCombat = false,
	DisableInInstances = true,
	DisableNonPlayableUnits = false,
	DisableOutOfCharacter = false,
	DisableOutOfCharacterUnits = false,
	EnableActiveQuery = true,
	EnableClassColorFallback = true,
	EnableNameOnlyMode = false,
	HideNonRoleplayUnits = false,
	HideOutOfCharacterUnits = false,
	IconSize = 16,
	MaximumNameLength = 30,
	MaximumTitleLength = 30,
	PreferredOOCIndicator = TRP3_OOCIndicatorStyle.Text,
	ShowTargetUnit = true,
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

local function UpdateNameOnlyModeCheckButton(button)
	-- The checkbutton for name-only mode is a faux tri-state checkbutton
	-- to deal with changes in 10.0.5 where the name-only mode cvar no longer
	-- persists across client restarts.
	--
	-- Internally we store a desired preference for name-only mode in our
	-- saved variables and assign this to the cvar on load. For the UI however
	-- we visually track the current "effective" state of the cvar, which may
	-- be set by other installed addons.
	--
	-- If name-only mode is currently active from any addon, we'll display the
	-- checkbutton in a checked state. If the user didn't enable name-only
	-- mode through our settings, the check will be desaturated.

	local preferredState = TRP3_NamePlatesUtil.IsNameOnlyModePreferred();
	local effectiveState = TRP3_NamePlatesUtil.IsNameOnlyModeEnabled();

	button:SetChecked(effectiveState);
	button:GetCheckedTexture():SetDesaturated(preferredState ~= effectiveState);
end

function TRP3_NamePlatesUtil.RegisterSettings()
	for key, default in pairs(DefaultSettings) do
		TRP3_API.configuration.registerConfigKey(MapSettingToConfigKey(key), default);
	end

	TRP3_API.configuration.registerConfigurationPage({
		id = "main_config_nameplates",
		menuText = L.NAMEPLATES_CONFIG_MENU_TITLE,
		pageText = L.NAMEPLATES_CONFIG_PAGE_TEXT,
		elements = {
			{
				inherit = "TRP3_ConfigParagraph",
				title = L.NAMEPLATES_CONFIG_PAGE_HELP,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.NAMEPLATES_CONFIG_VISIBILITY_HEADER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_IN_COMBAT,
				help = L.NAMEPLATES_CONFIG_DISABLE_IN_COMBAT_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
				configKey = MapSettingToConfigKey("DisableInCombat"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_IN_INSTANCES,
				help = L.NAMEPLATES_CONFIG_DISABLE_IN_INSTANCES_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
				configKey = MapSettingToConfigKey("DisableInInstances"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER,
				help = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
				configKey = MapSettingToConfigKey("DisableOutOfCharacter"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_UNITS,
				help = L.NAMEPLATES_CONFIG_DISABLE_OUT_OF_CHARACTER_UNITS_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
				configKey = MapSettingToConfigKey("DisableOutOfCharacterUnits"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_DISABLE_NON_PLAYABLE_UNITS,
				help = L.NAMEPLATES_CONFIG_DISABLE_NON_PLAYABLE_UNITS_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
				configKey = MapSettingToConfigKey("DisableNonPlayableUnits"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_HIDE_NON_ROLEPLAY_UNITS,
				help = L.NAMEPLATES_CONFIG_HIDE_NON_ROLEPLAY_UNITS_HELP,
				configKey = MapSettingToConfigKey("HideNonRoleplayUnits"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_HIDE_OUT_OF_CHARACTER_UNITS,
				help = L.NAMEPLATES_CONFIG_HIDE_OUT_OF_CHARACTER_UNITS_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
				configKey = MapSettingToConfigKey("HideOutOfCharacterUnits"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_TARGET_UNIT,
				help = L.NAMEPLATES_CONFIG_SHOW_TARGET_UNIT_HELP,
				configKey = MapSettingToConfigKey("ShowTargetUnit"),
			},
			{
				inherit = "TRP3_ConfigH1",
				title = L.NAMEPLATES_CONFIG_ELEMENT_HEADER,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAMES,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_NAMES_HELP,
				configKey = MapSettingToConfigKey("CustomizeNames"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_FIRST_NAMES,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_FIRST_NAMES_HELP,
				configKey = MapSettingToConfigKey("CustomizeFirstNames"),
				dependentOnOptions = { MapSettingToConfigKey("CustomizeNames") },
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_MAX_NAME_CHARS,
				help = L.NAMEPLATES_CONFIG_MAX_NAME_CHARS_HELP,
				configKey = MapSettingToConfigKey("MaximumNameLength"),
				dependentOnOptions = { MapSettingToConfigKey("CustomizeNames") },
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
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_HEALTH_COLORS_HELP .. "\n\n" .. L.NAMEPLATES_CONFIG_REQUIRES_TOGGLE,
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
				title = L.NAMEPLATES_CONFIG_CUSTOMIZE_FULL_TITLES,
				help = L.NAMEPLATES_CONFIG_CUSTOMIZE_FULL_TITLES_HELP,
				configKey = MapSettingToConfigKey("CustomizeFullTitles"),
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = L.NAMEPLATES_CONFIG_MAX_TITLE_CHARS,
				help = L.NAMEPLATES_CONFIG_MAX_TITLE_CHARS_HELP,
				configKey = MapSettingToConfigKey("MaximumTitleLength"),
				dependentOnOptions = { MapSettingToConfigKey("CustomizeFullTitles") },
				min = 10,
				max = 60,
				step = 1,
				integer = true,
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
					{ L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT .. TRP3_API.Ellyb.ColorManager.RED(L.CM_OOC), TRP3_OOCIndicatorStyle.Text },
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
				OnShow = function(button)
					UpdateNameOnlyModeCheckButton(button);
				end,
				OnClick = function(button)
					-- When updating our setting we need to invert the current
					-- state of our internal tracking variable for name-only
					-- mode and *not* rely on the checked state of the button,
					-- as the checked state is a visual representation of the
					-- effective name-only state only.

					local preferredState = TRP3_NamePlatesUtil.IsNameOnlyModePreferred();
					local desiredState = not preferredState;
					local effectiveState = TRP3_NamePlatesUtil.IsNameOnlyModeEnabled();

					if desiredState ~= preferredState then
						TRP3_NamePlatesUtil.SetNameOnlyModePreferred(desiredState);
					end

					if desiredState ~= effectiveState then
						if desiredState then
							TRP3_NamePlatesUtil.SetNameOnlyModeEnabled(desiredState);
						else
							TRP3_API.popup.showConfirmPopup(L.CO_UI_RELOAD_WARNING, ReloadUI);
						end
					end

					UpdateNameOnlyModeCheckButton(button);
				end,
			},
		}
	});
end

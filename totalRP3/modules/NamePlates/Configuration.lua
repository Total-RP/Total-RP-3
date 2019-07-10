-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- TRP3_API imports.
local L = TRP3_API.loc;
local TRP3_Config = TRP3_API.configuration;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Returns true if the user has elected to customize nameplates.
--
-- If this returns false, all customizations are disabled.
function NamePlates.ShouldCustomizeNamePlates()
	return TRP3_Config.getValue(NamePlates.CONFIG_ENABLE);
end

-- Returns true if the user has elected to customize nameplates, but only
-- while in-character.
--
-- If this returns false, customizations should be disabled when not
-- in-character.
function NamePlates.ShouldCustomizeNamePlatesOnlyInCharacter()
	return TRP3_Config.getValue(NamePlates.CONFIG_ENABLE_ONLY_IN_CHARACTER);
end

-- Returns true if the user has elected to request profiles upon seeing a
-- nameplate.
function NamePlates.ShouldActivelyQueryProfiles()
	return TRP3_Config.getValue(NamePlates.CONFIG_ACTIVE_QUERY);
end

-- Returns true if the user has elected to show custom player names.
function NamePlates.ShouldShowCustomPlayerNames()
	return TRP3_Config.getValue(NamePlates.CONFIG_SHOW_PLAYER_NAMES);
end

-- Returns true if the user has elected to show custom pet titles.
function NamePlates.ShouldShowCustomPetNames()
	return TRP3_Config.getValue(NamePlates.CONFIG_SHOW_PET_NAMES);
end

-- Returns true if the user has elected to show custom colors.
function NamePlates.ShouldShowCustomColors()
	return TRP3_Config.getValue(NamePlates.CONFIG_SHOW_COLORS);
end

-- Returns true if the user has elected to show custom icons.
function NamePlates.ShouldShowCustomIcons()
	return TRP3_Config.getValue(NamePlates.CONFIG_SHOW_ICONS);
end

-- Returns true if the user has elected to show custom titles.
function NamePlates.ShouldShowCustomTitles()
	return TRP3_Config.getValue(NamePlates.CONFIG_SHOW_TITLES);
end

-- Returns true if the user has elected to show OOC indicators.
function NamePlates.ShouldShowOOCIndicators()
	return TRP3_Config.getValue(NamePlates.CONFIG_SHOW_OOC_INDICATORS);
end

-- Returns the currently configured style token for OOC indicators.
function NamePlates.GetConfiguredOOCIndicatorStyle()
	return TRP3_Config.getValue(NamePlates.CONFIG_OOC_INDICATOR_STYLE);
end

-- Registers all configuration keys with the TRP configuration API.
--[[private]] function NamePlates.RegisterConfigurationKeys()
	-- Register all the keys and their defaults as defined in the constants.
	for key, default in pairs(NamePlates.DEFAULT_CONFIG) do
		-- If the default is a function, execute it to obtain the value.
		if type(default) == "function" then
			default = select(2, xpcall(default, CallErrorHandler));
			print("DEFAULT", key, default);
		end

		TRP3_Config.registerConfigKey(key, default);
	end
end

-- Registers the configuration UI with the TRP configuration API.
--[[private]] function NamePlates.RegisterConfigurationUI()
	TRP3_Config.registerConfigurationPage({
		id = "main_config_uuu_nameplates",
		menuText = L.NAMEPLATES_CONFIG_MENU_TEXT,
		pageText = L.NAMEPLATES_CONFIG_PAGE_TEXT,
		elements = {
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_ENABLE_TITLE,
				help = L.NAMEPLATES_CONFIG_ENABLE_HELP,
				configKey = NamePlates.CONFIG_ENABLE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_ENABLE_ONLY_IN_CHARACTER_TITLE,
				help = L.NAMEPLATES_CONFIG_ENABLE_ONLY_IN_CHARACTER_HELP,
				configKey = NamePlates.CONFIG_ENABLE_ONLY_IN_CHARACTER,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_ACTIVE_QUERY_TITLE,
				help = L.NAMEPLATES_CONFIG_ACTIVE_QUERY_HELP,
				configKey = NamePlates.CONFIG_ACTIVE_QUERY,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_PLAYER_NAMES_TITLE,
				help = L.NAMEPLATES_CONFIG_SHOW_PLAYER_NAMES_HELP,
				configKey = NamePlates.CONFIG_SHOW_PLAYER_NAMES,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_PET_NAMES_TITLE,
				help = L.NAMEPLATES_CONFIG_SHOW_PET_NAMES_HELP,
				configKey = NamePlates.CONFIG_SHOW_PET_NAMES,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_COLORS_TITLE,
				help = L.NAMEPLATES_CONFIG_SHOW_COLORS_HELP,
				configKey = NamePlates.CONFIG_SHOW_COLORS,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_ICONS_TITLE,
				help = L.NAMEPLATES_CONFIG_SHOW_ICONS_HELP,
				configKey = NamePlates.CONFIG_SHOW_ICONS,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_TITLES_TITLE,
				help = L.NAMEPLATES_CONFIG_SHOW_TITLES_HELP,
				configKey = NamePlates.CONFIG_SHOW_TITLES,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = L.NAMEPLATES_CONFIG_SHOW_OOC_INDICATORS_TITLE,
				help = L.NAMEPLATES_CONFIG_SHOW_OOC_INDICATORS_HELP,
				configKey = NamePlates.CONFIG_SHOW_OOC_INDICATORS,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
					NamePlates.CONFIG_SHOW_PLAYER_NAMES,
				},
			},
			{
				inherit = "TRP3_ConfigDropDown",
				title = L.NAMEPLATES_CONFIG_OOC_INDICATOR_STYLE_TITLE,
				help = L.NAMEPLATES_CONFIG_OOC_INDICATOR_STYLE_HELP,
				configKey = NamePlates.CONFIG_OOC_INDICATOR_STYLE,
				dependentOnOptions = {
					NamePlates.CONFIG_ENABLE,
					NamePlates.CONFIG_SHOW_PLAYER_NAMES,
					NamePlates.CONFIG_SHOW_OOC_INDICATORS,
				},
				listContent = {
					{
						L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_TEXT .. NamePlates.OOC_TEXT_INDICATOR,
						NamePlates.OOC_STYLE_TEXT,
					},
					{
						L.CO_TOOLTIP_PREFERRED_OOC_INDICATOR_ICON .. tostring(NamePlates.OOC_ICON_INDICATOR),
						NamePlates.OOC_STYLE_ICON,
					},
				},
				listWidth = nil,
				listCancel = true,
			},
		}
	});
end

----------------------------------------------------------------------------------
--- 	Total RP 3
--- 	Nameplates config
---    ---------------------------------------------------------------------------
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@class TRP3_NameplatesConfig
local NameplatesConfig = {};
TRP3_API.nameplates.config = NameplatesConfig;

function NameplatesConfig.init()
	
	local loc = TRP3_API.locale.getText;
	local registerConfigKey = TRP3_API.configuration.registerConfigKey;
	local registerConfigHandler = TRP3_API.configuration.registerHandler;
	
	NameplatesConfig.configKeys = {
		ENABLE_NAMEPLATES_CUSTOMIZATION = "nameplates_enable",
		DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER = "nameplates_only_in_character",
		HIDE_HEALTH_BARS = "nameplates_hide_healthbars",
		USE_CUSTOM_COLOR = "nameplates_use_custom_color",
		INCREASE_COLOR_CONTRAST = "nameplates_increase_color_contrast",
		SHOW_TITLES = "nameplates_show_titles",
		HIDE_NON_ROLEPLAY = "nameplates_hide_non_roleplay",
		PET_NAMES = "nameplates_pet_names"
	};
	
	local DEFAULT_CONFIG = {
		[NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION] = true,
		[NameplatesConfig.configKeys.DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER] = true,
		[NameplatesConfig.configKeys.HIDE_HEALTH_BARS] = true,
		[NameplatesConfig.configKeys.HIDE_NON_ROLEPLAY] = false,
		[NameplatesConfig.configKeys.USE_CUSTOM_COLOR] = true,
		[NameplatesConfig.configKeys.INCREASE_COLOR_CONTRAST] = false,
		[NameplatesConfig.configKeys.PET_NAMES] = true,
		[NameplatesConfig.configKeys.SHOW_TITLES] = false,
	}
	
	for key, defaultValue in pairs(DEFAULT_CONFIG) do
		registerConfigKey(key, defaultValue);
		registerConfigHandler(key, TRP3_API.nameplates.refresh);
	end
	
	-- Build configuration page
	TRP3_API.configuration.registerConfigurationPage(
	{
		id = "main_config_trp3_nameplates",
		menuText = loc("NAMEPLATE_CONFIG_MENU"),
		pageText = loc("NAMEPLATE_CONFIG_TITLE"),
		elements = {
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("NAMEPLATE_ENABLE_CUSTOMIZATIONS"),
				help = loc("NAMEPLATE_CUSTOMIZATIONS_TT"),
				configKey = NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("NAMEPLATE_CUSTOM_COLORS"),
				help = loc("NAMEPLATE_CUSTOM_COLORS_TT"),
				configKey = NameplatesConfig.configKeys.USE_CUSTOM_COLOR,
				dependentOnOptions = {NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("NAMEPLATE_INCREASE_COLOR_CONTRAST"),
				help = loc("NAMEPLATE_INCREASE_COLOR_CONTRAST_TT"),
				configKey = NameplatesConfig.configKeys.USE_CUSTOM_COLOR,
				dependentOnOptions = {
					NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION,
					NameplatesConfig.configKeys.USE_CUSTOM_COLOR
				},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("NAMEPLATE_HIDE_HEALTHBARS"),
				help = loc("NAMEPLATE_HIDE_HEALTHBARS_TT"),
				configKey = NameplatesConfig.configKeys.HIDE_HEALTH_BARS,
				dependentOnOptions = {NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("NAMEPLATE_ONLY_IN_CHARACTER"),
				help = loc("NAMEPLATE_ONLY_IN_CHARACTER_TT"),
				configKey = NameplatesConfig.configKeys.DISPLAY_NAMEPLATES_ONLY_IN_CHARACTER,
				dependentOnOptions = {NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("NAMEPLATE_HIDE_NON_RP"),
				help = loc("NAMEPLATE_HIDE_NON_RP_TT"),
				configKey = NameplatesConfig.configKeys.HIDE_NON_ROLEPLAY,
				dependentOnOptions = {NameplatesConfig.configKeys.ENABLE_NAMEPLATES_CUSTOMIZATION},
			},
		}
	});
end
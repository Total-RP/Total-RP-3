----------------------------------------------------------------------------------
--- Total RP 3
---
--- Advanced settings page
--- ---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---  http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

-- Lua imports
local insert = table.insert;
local pairs = pairs;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local Configuration = TRP3_API.configuration;

--- Display a warning to let the user know modifying advanced settings might cause issues
local function advancedSettingsModifiedPopup(settingKey, value)
	if Configuration.getDefaultValue(settingKey) ~= value then
		TRP3_API.popup.showAlertPopup(loc.CO_ADVANCED_SETTINGS_POPUP)
	end
end

TRP3_API.ADVANCED_SETTINGS_STRUCTURE = {
	id = "main_config_zzz_advanced_settings",
	menuText = loc.CO_ADVANCED_SETTINGS_MENU_NAME,
	pageText = loc.CO_ADVANCED_SETTINGS,
	elements = {}
}

TRP3_API.ADVANCED_SETTINGS_KEYS = {
	USE_BROADCAST_COMMUNICATIONS = "comm_broad_use",
	BROADCAST_CHANNEL = "comm_broad_chan",
	PROFILE_SANITIZATION = "register_sanitization",
}
TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES = {};

-- Reset button
insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigH1",
	title = loc.CO_ADVANCED_BROADCAST,
});

-- Use broadcast communications
TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS] = true;
insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigCheck",
	title = loc.CO_GENERAL_BROADCAST,
	configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS,
	help = loc.CO_GENERAL_BROADCAST_TT,
});

-- Broadcast communications channel
TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.BROADCAST_CHANNEL] = "xtensionxtooltip2";
insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigEditBox",
	title = loc.CO_GENERAL_BROADCAST_C,
	configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.BROADCAST_CHANNEL,
	dependentOnOptions = { TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS },
});

-- Localization settings
insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigH1",
	title = loc.REG_REGISTER,
});

-- Profile sanitization
TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.PROFILE_SANITIZATION] = true;
insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
	inherit = "TRP3_ConfigCheck",
	title = loc.CO_SANITIZER,
	configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.PROFILE_SANITIZATION,
	help = loc.CO_SANITIZER_TT
});

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	for configurationKey, defaultValue in pairs(TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES) do
		Configuration.registerConfigKey(configurationKey, defaultValue)
	end

	local localeTab = {};
	for _, locale in pairs(loc:GetLocales(true)) do
		insert(localeTab, { locale:GetName(), locale:GetCode() });
	end

	-- Localization settings
	insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_GENERAL_LOCALE,
	});
	insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigurationGeneral_LangWidget",
		title = loc.CO_GENERAL_LOCALE,
		listContent = localeTab,
		listCallback = function(newLocaleCode)
			if newLocaleCode ~= loc:GetActiveLocale():GetCode() then
				Configuration.setValue("AddonLocale", newLocaleCode);
				TRP3_API.popup.showConfirmPopup(loc.CO_GENERAL_CHANGELOCALE_ALERT:format(Ellyb.ColorManager.GREEN(loc:GetLocale(newLocaleCode):GetName())), ReloadUI);
			end
		end,
		listDefault = loc:GetActiveLocale():GetName(),
		listCancel = true,
	});

	-- Reset button
	insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = " ",
	});
	insert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
		inherit = "TRP3_ConfigButton",
		title = loc.CO_ADVANCED_SETTINGS_RESET,
		help = loc.CO_ADVANCED_SETTINGS_RESET_TT,
		text = loc.CM_RESET,
		callback = function()
			for _, advancedKey in pairs(TRP3_API.ADVANCED_SETTINGS_KEYS) do
				Configuration.resetValue(advancedKey);
			end
			Configuration.refreshPage("main_config_zzz_advanced_settings");
		end,
	});

	TRP3_API.configuration.registerConfigurationPage(TRP3_API.ADVANCED_SETTINGS_STRUCTURE);

	-- All registered keys will show a warning when modified
	for _, advancedKey in pairs(TRP3_API.ADVANCED_SETTINGS_KEYS) do
		Configuration.registerHandler(advancedKey, advancedSettingsModifiedPopup)
	end

end);

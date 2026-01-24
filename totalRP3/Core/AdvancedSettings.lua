-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local Configuration = TRP3_API.configuration;

TRP3_API.ADVANCED_SETTINGS_STRUCTURE = {
	id = "main_config_zzz_advanced_settings",
	elements = {}
}

TRP3_API.ADVANCED_SETTINGS_KEYS = {
}

-- Broadcast keys should only be registered in Retail
if TRP3_ClientFeatures.ChannelBroadcasts then
	TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS = "comm_broad_use";
	TRP3_API.ADVANCED_SETTINGS_KEYS.BROADCAST_CHANNEL = "comm_broad_chan";
	TRP3_API.ADVANCED_SETTINGS_KEYS.MAKE_SURE_BROADCAST_CHANNEL_IS_LAST = "MAKE_SURE_BROADCAST_CHANNEL_IS_LAST";
end

TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES = {};

--- Display a warning to let the user know modifying advanced settings might cause issues
local function advancedSettingsModifiedPopup(settingKey, value)
	if Configuration.getDefaultValue(settingKey) ~= value then
		TRP3_API.popup.showAlertPopup(loc.CO_ADVANCED_SETTINGS_POPUP)
	end
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOAD, function()

	TRP3_API.ADVANCED_SETTINGS_STRUCTURE.menuText = loc.CO_ADVANCED_SETTINGS_MENU_NAME
	TRP3_API.ADVANCED_SETTINGS_STRUCTURE.pageText = loc.CO_ADVANCED_SETTINGS

	if TRP3_ClientFeatures.ChannelBroadcasts then
		-- Broadcast settings
		tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
			inherit = "TRP3_ConfigH1",
			title = loc.CO_ADVANCED_BROADCAST,
		});

		-- Use broadcast communications
		TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS] = true;
		tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_GENERAL_BROADCAST,
			configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS,
			help = loc.CO_GENERAL_BROADCAST_TT,
		});

		-- Broadcast communications channel
		TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.BROADCAST_CHANNEL] = "xtensionxtooltip2";
		tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
			inherit = "TRP3_ConfigEditBox",
			title = loc.CO_GENERAL_BROADCAST_C,
			configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.BROADCAST_CHANNEL,
			dependentOnOptions = { TRP3_API.ADVANCED_SETTINGS_KEYS.USE_BROADCAST_COMMUNICATIONS },
		});

		TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES[TRP3_API.ADVANCED_SETTINGS_KEYS.MAKE_SURE_BROADCAST_CHANNEL_IS_LAST] = true;
		tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_ADVANCED_BROADCAST_CHANNEL_ALWAYS_LAST,
			configKey = TRP3_API.ADVANCED_SETTINGS_KEYS.MAKE_SURE_BROADCAST_CHANNEL_IS_LAST,
			help = loc.CO_ADVANCED_BROADCAST_CHANNEL_ALWAYS_LAST_TT
		});
	end

	for configurationKey, defaultValue in pairs(TRP3_API.ADVANCED_SETTINGS_DEFAULT_VALUES) do
		Configuration.registerConfigKey(configurationKey, defaultValue)
	end

	local localeTab = {};
	for _, locale in pairs(loc:GetLocales(true)) do
		tinsert(localeTab, { locale:GetName(), locale:GetCode() });
	end

	-- Sort locales alphabetically.
	table.sort(localeTab, function(a,b) return a[1] < b[1] end);
	table.insert(localeTab, 1, { string.format(loc.CO_LOCALE_DEFAULT, loc:GetLocale(TRP3_API.GetDefaultLocale()):GetName()), TRP3_LocaleConstants.DefaultLocaleCode })

	-- Localization settings
	tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_GENERAL_LOCALE,
	});

	TRP3_API.configuration.registerConfigKey(TRP3_LocaleConstants.LocaleConfigKey, TRP3_LocaleConstants.DefaultLocaleCode);
	tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigurationGeneral_LangWidget",
		title = loc.CO_GENERAL_LOCALE,
		listContent = localeTab,
		listCallback = function(newLocaleCode)
			local currentLocaleCode = loc:GetActiveLocale():GetCode();

			if newLocaleCode == currentLocaleCode then
				-- Locale isn't changing.
				return;
			end

			-- If we're changing to the default locale but the default and
			-- active locales are effectively equivalent, commit directly
			-- without a reload warning.

			if newLocaleCode == TRP3_LocaleConstants.DefaultLocaleCode and currentLocaleCode == TRP3_API.GetDefaultLocale() then
				Configuration.setValue(TRP3_LocaleConstants.LocaleConfigKey, TRP3_LocaleConstants.DefaultLocaleCode)
			else
				local function OnAccept()
					Configuration.setValue(TRP3_LocaleConstants.LocaleConfigKey, newLocaleCode);
					ReloadUI();
				end

				TRP3_API.popup.showConfirmPopup(loc.CO_GENERAL_CHANGELOCALE_ALERT:format(TRP3_API.Colors.Green(loc:GetLocale(newLocaleCode):GetName())), OnAccept);
			end
		end,
		configKey = TRP3_LocaleConstants.LocaleConfigKey,
		listCancel = true,
	});

	-- Reset button
	tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, 1, {
		inherit = "TRP3_ConfigH1",
		title = " ",
	});
	tinsert(TRP3_API.ADVANCED_SETTINGS_STRUCTURE.elements, 1, {
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

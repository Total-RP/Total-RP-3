--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_LOCALE = {}

local TRP3_LOCALS = {};
local DEFAULT_LOCALE = "enUS";
local effectiveLocal = {};
local current;

TRP3_LOCALE.registerLocale = function(localeStructure)
	assert(localeStructure and localeStructure.locale and localeStructure.localeText and localeStructure.localeContent, "Usage: localeStructure with locale, localeText and localeContent.");
	if not TRP3_LOCALS[localeStructure.locale] then
		TRP3_LOCALS[localeStructure.locale] = localeStructure;
	end
end

-- Initialize a locale for the addon.
TRP3_LOCALE.init = function()
	-- Register config
	TRP3_CONFIG.registerConfigKey("AddonLocale", GetLocale());
	current = TRP3_CONFIG.getValue("AddonLocale");
	if not TRP3_LOCALS[current] then
		current = DEFAULT_LOCALE;
	end
	TRP3_UTILS.table.copy(effectiveLocal, TRP3_LOCALS[current].localeContent);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Current locale utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Get a sorted list of registered locales ID ("frFR", "enUS" ...).
TRP3_LOCALE.getLocales = function()
	local locales = {};
	for locale,_ in pairs(TRP3_LOCALS) do
		tinsert(locales, locale);
	end
	table.sort(locales);
	return locales;
end

-- Get the display name of a locale ("Français", "English" ...)
TRP3_LOCALE.getLocaleText = function(locale)
	if TRP3_LOCALS[locale] then
		return TRP3_LOCALS[locale].localeText
	end
	return UNKNOWN;
end

TRP3_LOCALE.getEffectiveLocale = function()
	return effectiveLocal;
end

TRP3_LOCALE.getDefaultLocaleStructure = function()
	return TRP3_LOCALS[DEFAULT_LOCALE];
end

TRP3_LOCALE.getCurrentLocale = function()
	return current;
end

--	Return the localized text link to this key.
--	If the key isn't present in the current Locals table, then return the default localization.
--	If the key is totally unknown from TRP3, then an error will be lifted.
function TRP3_L(key)
	return effectiveLocal[key] or TRP3_LOCALS[DEFAULT_LOCALE].localeContent[key] or error("Unknown localization key: "..tostring(key));
end
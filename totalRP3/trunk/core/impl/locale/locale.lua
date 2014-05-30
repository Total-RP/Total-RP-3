--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.locale = {}

local error, pairs, tinsert, assert, table, tostring = error, pairs, tinsert, assert, table, tostring;

local LOCALS = {};
local DEFAULT_LOCALE = "enUS";
local effectiveLocal = {};
local current;

function TRP3_API.locale.registerLocale(localeStructure)
	assert(localeStructure and localeStructure.locale and localeStructure.localeText and localeStructure.localeContent, "Usage: localeStructure with locale, localeText and localeContent.");
	if not LOCALS[localeStructure.locale] then
		LOCALS[localeStructure.locale] = localeStructure;
	end
end

-- Initialize a locale for the addon.
function TRP3_API.locale.init()
	-- Register config
	TRP3_API.configuration.registerConfigKey("AddonLocale", GetLocale());
	current = TRP3_API.configuration.getValue("AddonLocale");
	if not LOCALS[current] then
		current = DEFAULT_LOCALE;
	end
	TRP3_API.utils.table.copy(effectiveLocal, LOCALS[current].localeContent);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Current locale utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Get a sorted list of registered locales ID ("frFR", "enUS" ...).
function TRP3_API.locale.getLocales()
	local locales = {};
	for locale,_ in pairs(LOCALS) do
		tinsert(locales, locale);
	end
	table.sort(locales);
	return locales;
end

-- Get the display name of a locale ("Français", "English" ...)
function TRP3_API.locale.getLocaleText(locale)
	if LOCALS[locale] then
		return LOCALS[locale].localeText
	end
	return UNKNOWN;
end

function TRP3_API.locale.getEffectiveLocale()
	return effectiveLocal;
end

function TRP3_API.locale.getDefaultLocaleStructure()
	return LOCALS[DEFAULT_LOCALE];
end

function TRP3_API.locale.getCurrentLocale()
	return current;
end

--	Return the localized text link to this key.
--	If the key isn't present in the current Locals table, then return the default localization.
--	If the key is totally unknown from TRP3, then an error will be lifted.
function TRP3_API.locale.getText(key)
	if effectiveLocal[key] or LOCALS[DEFAULT_LOCALE].localeContent[key] then
		return effectiveLocal[key] or LOCALS[DEFAULT_LOCALE].localeContent[key];
	end
	error("Unknown localization key: ".. tostring(key));
end
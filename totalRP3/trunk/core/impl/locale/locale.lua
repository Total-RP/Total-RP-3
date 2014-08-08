--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.locale = {}

local error, pairs, tinsert, assert, table, tostring, GetLocale = error, pairs, tinsert, assert, table, tostring, GetLocale;

local LOCALS = {};
local DEFAULT_LOCALE = "enUS";
local effectiveLocal = {};
local current;
local localeFont;

function TRP3_API.locale.getLocaleFont()
	return localeFont;
end

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
	-- Pick the right font
	if current == "zhCN" then
		localeFont = "Fonts\\ZYKai_T.TTF";
	else
		localeFont = "Fonts\\FRIZQT__.TTF";
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Companion utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if GetLocale() == "frFR" then
	-- Thank you French language to be such a pain in the ass.
	-- It will be less effective on French client. Do I look like I care ? Fuck no. :D
	function TRP3_API.locale.findPetOwner(lines)
		if lines[2] then
			return lines[2]:match("Familier de ([%S%-%P]+)") or lines[2]:match("Familier d'([%S%-%P]+)") or
			lines[2]:match("Serviteur de ([%S%-%P]+)") or lines[2]:match("Serviteur d'([%S%-%P]+)");
		end
	end
	
	function TRP3_API.locale.findBattlePetOwner(lines)
		if lines[3] then
			return lines[3]:match("Mascotte de ([%S%-%P]+)") or lines[3]:match("Mascotte d'([%S%-%P]+)");
		end
	end
else
	local REPLACE_PATTERN, NAME_PATTERN = "%%s", "([%%S%%-%%P]+)";
	local COMPANION_PET_PATTERN = UNITNAME_TITLE_PET:gsub(REPLACE_PATTERN, NAME_PATTERN);
	local COMPANION_DEMON_PATTERN = UNITNAME_TITLE_MINION:gsub(REPLACE_PATTERN, NAME_PATTERN);

	function TRP3_API.locale.findPetOwner(lines)
		if lines[2] then
			return lines[2]:match(COMPANION_PET_PATTERN) or lines[2]:match(COMPANION_DEMON_PATTERN);
		end
	end

	local COMPANION_BATTLE_PET_PATTERN = UNITNAME_TITLE_COMPANION:gsub(REPLACE_PATTERN, NAME_PATTERN);

	function TRP3_API.locale.findBattlePetOwner(lines)
		if lines[3] then
			return lines[3]:match(COMPANION_BATTLE_PET_PATTERN);
		end
	end
end


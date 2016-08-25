----------------------------------------------------------------------------------
-- Total RP 3
-- Locale system
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

TRP3_API.locale = {}

-- Bindings locale
BINDING_HEADER_TRP3 = "Total RP 3";

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
	elseif current == "ruRU" then
		localeFont = "Fonts\\FRIZQT___CYR.TTF";
	else
		localeFont = "Fonts\\FRIZQT__.TTF";
	end
	effectiveLocal = LOCALS[current].localeContent;
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

function TRP3_API.locale.getLocale(localeID)
	assert(LOCALS[localeID], "Unknown locale: " .. localeID);
	return LOCALS[localeID];
end

--	Return the localized text link to this key.
--	If the key isn't present in the current Locals table, then return the default localization.
--	If the key is totally unknown from TRP3, then an error will be lifted.
local function getText(key)
	if effectiveLocal[key] or LOCALS[DEFAULT_LOCALE].localeContent[key] then
		return effectiveLocal[key] or LOCALS[DEFAULT_LOCALE].localeContent[key];
	end
	error("Unknown localization key: ".. tostring(key));
end
TRP3_API.locale.getText = getText;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Companion utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

if GetLocale() == "frFR" then
	-- Thank you French language to be such a pain in the ass.
	-- It will be less effective on French client. Do I look like I care ? Fuck no. :D
	function TRP3_API.locale.findPetOwner(lines)
		local masterLine = ENABLE_COLORBLIND_MODE == "1" and lines[3] or lines[2];
		if masterLine then
			return masterLine:match("Familier de ([%S%-%P]+)") or masterLine:match("Familier d'([%S%-%P]+)") or
			masterLine:match("Serviteur de ([%S%-%P]+)") or masterLine:match("Serviteur d'([%S%-%P]+)");
		end
	end
	
	function TRP3_API.locale.findBattlePetOwner(lines)
		local masterLine = ENABLE_COLORBLIND_MODE == "1" and lines[4] or lines[3];
		if masterLine then
			local master = masterLine:match("Mascotte de ([%S%-%P]+)") or masterLine:match("Mascotte d'([%S%-%P]+)");
			if not master or master:find("%s") then -- Hack for "Mascotte de niveau xxx" ...
				return nil;
			end
			return master;
		end
	end
else
	local REPLACE_PATTERN, NAME_PATTERN = "%%s", "([%%S%%-%%P]+)";
	local COMPANION_PET_PATTERN = UNITNAME_TITLE_PET:gsub(REPLACE_PATTERN, NAME_PATTERN);
	local COMPANION_DEMON_PATTERN = UNITNAME_TITLE_MINION:gsub(REPLACE_PATTERN, NAME_PATTERN);

	function TRP3_API.locale.findPetOwner(lines)
		local masterLine = ENABLE_COLORBLIND_MODE == "1" and lines[3] or lines[2];
		if masterLine then
			return masterLine:match(COMPANION_PET_PATTERN) or masterLine:match(COMPANION_DEMON_PATTERN);
		end
	end

	local COMPANION_BATTLE_PET_PATTERN = UNITNAME_TITLE_COMPANION:gsub(REPLACE_PATTERN, NAME_PATTERN);

	function TRP3_API.locale.findBattlePetOwner(lines)
		local masterLine = ENABLE_COLORBLIND_MODE == "1" and lines[4] or lines[3];
		if masterLine then
			return masterLine:match(COMPANION_BATTLE_PET_PATTERN);
		end
	end
end


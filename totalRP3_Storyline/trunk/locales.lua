----------------------------------------------------------------------------------
-- Total RP 3
-- Storyline module
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

Storyline_API.locale = {

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_EN
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	["enUS"] = {
		localeContent = {
			SL_STORYLINE = "Storyline",
			SL_SELECT_DIALOG_OPTION = "Select dialog option",
			SL_SELECT_AVAILABLE_QUEST = "Select available quest",
			SL_WELL = "Well ...",
			SL_ACCEPTANCE = "I accept.",
			SL_DECLINE = "I refuse.",
			SL_NEXT = "Continue",
			SL_CONTINUE = "Complete quest",
			SL_NOT_YET = "Come back when it's done",
			SL_CHECK_OBJ = "Check objectives",
			SL_RESET = "Rewind",
			SL_RESET_TT = "Rewind this dialogue.",
			SL_REWARD_MORE = "You will also get",
			SL_REWARD_MORE_SUB = "\nMoney: |cffffffff%s|r\nExperience: |cffffffff%s xp|r\n\n|cffffff00Click:|r Get your reward!",
			SL_GET_REWARD = "Get your reward",
			SL_SELECT_REWARD = "Select your reward",
			SL_CONFIG = "Parameters",
			SL_CONFIG_TEXTSPEED = "Text speed: %.1fx",
			SL_CONFIG_TEXTSPEED_INSTANT = "No anim",
			SL_CONFIG_TEXTSPEED_HIGH = "High",
			SL_CONFIG_AUTOEQUIP = "Auto equip reward (experimental)",
			SL_CONFIG_AUTOEQUIP_TT = "Auto equip rewards if it has a better item lvl.",
		}
	},
	
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOCALE_FR
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	["frFR"] = {
		localeContent = {
			SL_STORYLINE = "Storyline",
			SL_SELECT_DIALOG_OPTION = "Sélectionnez une option",
			SL_SELECT_AVAILABLE_QUEST = "Sélectionnez une quête",
			SL_WELL = "Et bien ...",
			SL_ACCEPTANCE = "J'accepte.",
			SL_DECLINE = "Je refuse.",
			SL_NEXT = "Continuer",
			SL_CONTINUE = "Terminer la quête",
			SL_NOT_YET = "Revenez quand cela sera fait",
			SL_CHECK_OBJ = "Vérifier objectifs",
			SL_RESET = "Début",
			SL_RESET_TT = "Revenir au début du dialogue",
			SL_REWARD_MORE = "Vous recevrez aussi",
			SL_REWARD_MORE_SUB = "\nArgent: |cffffffff%s|r\nExpérience: |cffffffff%s xp|r\n\n|cffffff00Clic:|r Prenez votre récompense !",
			SL_GET_REWARD = "Prenez votre récompense",
			SL_SELECT_REWARD = "Choisissez votre récompense",
		}
	},
}

local error, tostring = error, tostring;

local LOCALS = Storyline_API.locale;
local DEFAULT_LOCALE = "enUS";
local effectiveLocal = {};
local localeFont;
local current;

-- Initialize a locale for the addon.
function Storyline_API.locale.init()
	-- Register config
	current = TRP3_Storyline.config.locale or DEFAULT_LOCALE;
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

	Storyline_API.locale.localeFont = localeFont;
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
Storyline_API.locale.getText = getText;
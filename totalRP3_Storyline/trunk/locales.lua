----------------------------------------------------------------------------------
--  Storyline
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--	Copyright 2015 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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

Storyline_API = {
	lib = {},
};

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
			SL_CONFIG_WELCOME = "Thank you for using Storyline!",
			SL_CONFIG_TEXTSPEED_TITLE = "Text anim speed",
			SL_CONFIG_TEXTSPEED = "%.1fx",
			SL_CONFIG_TEXTSPEED_INSTANT = "No anim",
			SL_CONFIG_TEXTSPEED_HIGH = "High",
			SL_CONFIG_AUTOEQUIP = "Auto equip reward (experimental)",
			SL_CONFIG_AUTOEQUIP_TT = "Auto equip rewards if it has a better item lvl.",
			SL_CONFIG_FORCEGOSSIP = "Show flavor texts",
			SL_CONFIG_FORCEGOSSIP_TT = "Show flavor texts on NPCs like merchants or fly masters.",
			SL_CONFIG_HIDEORIGINALFRAMES = "Hide original frames",
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Hide the original quest frame and NPC dialogs frame.",
			SL_CONFIG_LOCKFRAME = "Lock frame",
			SL_CONFIG_LOCKFRAME_TT = "Lock Storyline frame so it cannot be move by mistake.",
			SL_CONFIG_SAMPLE_TEXT = "Grumpy wizards make toxic brew for the evil queen and jack",
			SL_CONFIG_QUEST_TITLE = "Quest title",
			SL_CONFIG_DIALOG_TEXT = "Dialog text",
			SL_CONFIG_NPC_NAME = "NPC name",
			SL_CONFIG_NEXT_ACTION = "Next action";
			SL_CONFIG_STYLING_OPTIONS = "Styling options",
			SL_CONFIG_STYLING_OPTIONS_SUBTEXT = "Styling options",
			SL_CONFIG_MISCELLANEOUS_SUBTEXT = "Miscellaneous options",
			SL_CONFIG_MISCELLANEOUS = "Miscellaneous options",
			SL_CONFIG_DEBUG = "Debug mode",
			SL_CONFIG_DEBUG_TT = "Enable the debug frame showing development data under Storyline frame",
			SL_RESIZE = "Resize",
			SL_RESIZE_TT = "Drag and drop to resize",
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
			SL_CONFIG = "Configuration",
			SL_CONFIG_TEXTSPEED_TITLE = "Vitesse de défilement du texte",
			SL_CONFIG_TEXTSPEED = "%.1fx",
			SL_CONFIG_TEXTSPEED_INSTANT = "Pas de défilement",
			SL_CONFIG_TEXTSPEED_HIGH = "Rapide",
			SL_CONFIG_AUTOEQUIP = "Équipement automatique (expérimental)",
			SL_CONFIG_AUTOEQUIP_TT = "Équipe automatiquement les récompense si elles ont un meilleur niveau d'équipement.",
			SL_CONFIG_FORCEGOSSIP = "Afficher les textes d'introduction des PNJs",
			SL_CONFIG_FORCEGOSSIP_TT = "Forcer l'affichage des textes d'introduction normalement masqués des PNJs, comme les marchands ou les maîtres de vol.",
			SL_CONFIG_HIDEORIGINALFRAMES = "Cacher les fenêtres originales",
			SL_CONFIG_HIDEORIGINALFRAMES_TT = "Cacher les fenêtres originales de quêtes et dialogues de PNJs.",
			SL_CONFIG_SAMPLE_TEXT = "Voix ambiguë d’un cœur qui au zéphyr préfère les jattes de kiwi",
			SL_RESIZE = "Redimensionner",
			SL_RESIZE_TT = "Cliquer-glisser pour redimensionner",
		}
	},
}

local error, tostring = error, tostring;

local LOCALS = Storyline_API.locale;
local DEFAULT_LOCALE = GetLocale() == "frFR" and "frFR" or "enUS";
Storyline_API.locale.DEFAULT_LOCALE = DEFAULT_LOCALE;
local effectiveLocal = {};
local localeFont;
local current;

-- Initialize a locale for the addon.
function Storyline_API.locale.init()
	-- Register config
	current = Storyline_Data.config.locale or DEFAULT_LOCALE;
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
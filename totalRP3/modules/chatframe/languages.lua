----------------------------------------------------------------------------------
-- Total RP 3
-- Language switcher
--	---------------------------------------------------------------------------
--	Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
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

---@type TRP3_API;
local _, TRP3_API = ...;

-- Imports
local setTooltipForFrame, refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.setTooltipForFrame, TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local icon, color = TRP3_API.utils.str.icon, TRP3_API.utils.str.color;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local loc = TRP3_API.loc;
local Globals = TRP3_API.globals;
local tinsert, _G, strconcat = tinsert, _G, strconcat;
local GetNumLanguages, GetLanguageByIndex, GetDefaultLanguage = GetNumLanguages, GetLanguageByIndex, GetDefaultLanguage;
local Log = TRP3_API.utils.log;

local LAST_LANGUAGE_USED = "chat_last_language_used";

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if not TRP3_API.toolbar then return end;


	---
	-- Check if the player has previously selected a lanauge or use the default one.
	local function getCharacterPreviouslySelectedLanguage()
		if TRP3_Characters and TRP3_Characters[Globals.player_id] and TRP3_Characters[Globals.player_id][LAST_LANGUAGE_USED] then
			return TRP3_Characters[Globals.player_id][LAST_LANGUAGE_USED];
		else
			local _, defaultLanguageID = GetDefaultLanguage();
			return defaultLanguageID;
		end
	end

	---
	-- Save the language used at a character level
	-- @param languageID
	--
	local updateToolbarButton = TRP3_API.toolbar.updateToolbarButton;
	local function saveCharacterLanguage(languageID)
		assert(languageID, "No language ID given to saveCharacterLanguage(languageID)");
		TRP3_Characters[Globals.player_id][LAST_LANGUAGE_USED] = languageID;
	end

	local languagesIcon = {

		-- Alliance
		[35] = "Inv_Misc_Tournaments_banner_Draenei", -- Draenei
		[2] = "Inv_Misc_Tournaments_banner_Nightelf", -- Dranassian
		[6] = "Inv_Misc_Tournaments_banner_Dwarf", -- Dwarvish
		[7] = "Inv_Misc_Tournaments_banner_Human",-- Common
		[13] = "Inv_Misc_Tournaments_banner_Gnome",-- Gnomish

		-- Horde
		[1] = "Inv_Misc_Tournaments_banner_Orc", -- Orcish
		[33] = "Inv_Misc_Tournaments_banner_Scourge", -- Forsaken
		[3] = "Inv_Misc_Tournaments_banner_Tauren", -- Taurahe
		[10] = "Inv_Misc_Tournaments_banner_Bloodelf", -- Thalassian
		[14] = "Inv_Misc_Tournaments_banner_Troll", -- Zandali
		[40] = "achievement_Goblinhead", -- Goblin

		-- Pandaren (now neutral)
		[42] = "Achievement_Guild_ClassyPanda",

		-- Demon hunters
		[8] = "artifactability_havocdemonhunter_anguishofthedeceiver",

		-- Allied races
		[182] = "Achievement_AlliedRace_VoidElf", -- Void elf Thalassian (different from Blood Elf Thalassian)
		[181] = "Achievement_AlliedRace_Nightborne", -- Shalassian

	}

	---
	-- Will set the language currently spoken by the player using a language ID
	-- @param languageID
	--
	local function setLanguage(languageID)
		Log.log("Setting language " .. languageID);
		local language;
		for i = 1, GetNumLanguages() do
			local name, id = GetLanguageByIndex(i)
			if name and id == languageID then
				language = name;
			end
		end

		if not language then
			language, languageID = GetDefaultLanguage();
			Log.log("Trying to set a language that is not known by this character, going back to default language: " .. language, Log.level.WARNING);
		end

		saveCharacterLanguage(languageID);

		for i = 1, 9 do
			if _G["ChatFrame"..i.."EditBox"] then
				_G["ChatFrame"..i.."EditBox"].languageID = languageID;
				_G["ChatFrame"..i.."EditBox"].language = language;
			end
		end
	end

	---
	-- Callback called when the user has selected a language in the dropdown
	-- We need to retreive the language ID using the index to thenset the language.
	-- @param languageIndex
	--
	local function languageSelected(languageIndex)
		local _, languageID = GetLanguageByIndex(languageIndex);
		setLanguage(languageID);

	end
	
	local languagesButton = {
		id = "ww_trp3_languages",
		icon = "spell_holy_silence",
		configText = loc.TB_LANGUAGE,
		onEnter = function(Uibutton, buttonStructure)
			refreshTooltip(Uibutton);
		end,
		onUpdate = function(Uibutton, buttonStructure)
			updateToolbarButton(Uibutton, buttonStructure);
		end,
		onModelUpdate = function(buttonStructure)
			local currentLanguageID = ChatFrame1EditBox.languageID;
			local currentLanguage = ChatFrame1EditBox.language

			if languagesIcon[currentLanguageID] then
				buttonStructure.tooltip  = loc.TB_LANGUAGE .. ": " .. currentLanguage;
				buttonStructure.tooltipSub  = strconcat(color("y"), loc.CM_CLICK, ": ", color("w"), loc.TB_LANGUAGES_TT);
				buttonStructure.icon = languagesIcon[currentLanguageID];
			else
				buttonStructure.icon = "spell_holy_silence";
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			local dropdownItems = {};
			tinsert(dropdownItems,{loc.TB_LANGUAGE, nil});
			for i = 1, GetNumLanguages() do
				local language, index = GetLanguageByIndex(i);
				if index == ChatFrame1EditBox.languageID then
					tinsert(dropdownItems,{"|Tinterface\\icons\\"..(languagesIcon[index] or "TEMP")..":15|t|cff00ff00 "..language.."|r", nil});
				else
					tinsert(dropdownItems,{"|Tinterface\\icons\\"..(languagesIcon[index] or "TEMP")..":15|t "..language, i});
				end
			end
			displayDropDown(Uibutton, dropdownItems, languageSelected, 0, true);
		end,
		onLeave = function()
			mainTooltip:Hide();
		end,
	};
	TRP3_API.toolbar.toolbarAddButton(languagesButton);

	-- We have to wait a little for everything to be fully loaded before trying to restore previously selected language
	C_Timer.After(1, function()
		setLanguage(getCharacterPreviouslySelectedLanguage());
	end)

	
end);

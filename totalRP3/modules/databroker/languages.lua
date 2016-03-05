----------------------------------------------------------------------------------
-- Total RP 3
-- Languages databroker plugin
--	---------------------------------------------------------------------------
--	Copyright 2014 Renaud Parize (Ellypse) (renaud@parize.me)
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

-- TRP3_API import
local icon, color = TRP3_API.utils.str.icon, TRP3_API.utils.str.color;
local loc = TRP3_API.locale.getText;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local tinsert, strconcat, _G = tinsert, strconcat, _G;
local GetNumLanguages, GetLanguageByIndex = GetNumLanguages, GetLanguageByIndex;
local ChatFrame1EditBox = ChatFrame1EditBox;

local languagesIcon = {

	-- Alliance
	[35] = "Inv_Misc_Tournaments_banner_Draenei", -- Draenei
	[2] = "Inv_Misc_Tournaments_banner_Nightelf", -- Dranassian
	[6] = "Inv_Misc_Tournaments_banner_Dwarf", -- Dwarvish
	[7] = "Inv_Misc_Tournaments_banner_Human",-- Common
	[13] = "Inv_Misc_Tournaments_banner_Gnome",-- Gnomish
	[43] = "Achievement_Guild_ClassyPanda", -- Pandaren

	-- Horde
	[1] = "Inv_Misc_Tournaments_banner_Orc", -- Orcish
	[33] = "Inv_Misc_Tournaments_banner_Scourge", -- Forsaken
	[3] = "Inv_Misc_Tournaments_banner_Tauren", -- Taurahe
	[10] = "Inv_Misc_Tournaments_banner_Bloodelf", -- Thalassian
	[14] = "Inv_Misc_Tournaments_banner_Troll", -- Zandali
	[40] = "achievement_Goblinhead", -- Goblin
	[44] = "Achievement_Guild_ClassyPanda" -- Pandaren

}

local tooltipTitle = "";
local tooltipText = strconcat(color("y"), loc("CM_CLICK"), ": ", color("w"), loc("TB_LANGUAGES_TT"));

local function languageSelected(languageIndex)
	for i = 1, 9 do
		if _G["ChatFrame"..i.."EditBox"] then
			local language, languageID = GetLanguageByIndex(languageIndex);
			_G["ChatFrame"..i.."EditBox"].languageID = languageID;
			_G["ChatFrame"..i.."EditBox"].language = language;
		end
	end
end

local function onUpdate(LDBObject)
	local currentLanguageID = ChatFrame1EditBox.languageID;
	local currentLanguage = ChatFrame1EditBox.language;
	LDBObject.icon = "Interface\\ICONS\\"..(languagesIcon[currentLanguageID] or "TEMP");
	tooltipTitle = icon(languagesIcon[currentLanguageID], 25) .." "..loc("TB_LANGUAGE")..": "..currentLanguage;
end

local function onClick(clickedframe)
	local dropdownItems = {};
	tinsert(dropdownItems,{loc("TB_LANGUAGE"), nil});
	for i = 0, GetNumLanguages() do
		if GetLanguageByIndex(i) then
			local language, index = GetLanguageByIndex(i);
			if index == ChatFrame1EditBox.languageID then
				tinsert(dropdownItems,{"|Tinterface\\icons\\"..(languagesIcon[index] or "TEMP")..":15|t|cff00ff00 "..language.."|r", nil});
			else
				tinsert(dropdownItems,{"|Tinterface\\icons\\"..(languagesIcon[index] or "TEMP")..":15|t "..language, i});
			end
		end
	end
	displayDropDown(clickedframe, dropdownItems, languageSelected, 0, true);
end

local function onTooltipShow(tooltip)
	tooltip:AddLine(tooltipTitle);
	tooltip:AddLine(tooltipText);
end

TRP3_API.databroker.registerButton(loc("DTBK_LANGUAGES"), {
	icon = "TEMP",
	OnClick = onClick,
	OnTooltipShow = onTooltipShow,
	OnUpdate = onUpdate
});
----------------------------------------------------------------------------------
--- Total RP 3
--- Language switcher
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Morgane "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local Ellyb = Ellyb(...);
local AddOn_TotalRP3 = AddOn_TotalRP3;

local Icon = Ellyb.Icon

---@type Icon[]
local LANGUAGES_ICONS = {
	-- Alliance
	[35] = Icon(TRP3_InterfaceIcons.LanguageDraenei), -- Draenei
	[2] = Icon(TRP3_InterfaceIcons.LanguageDarnassian), -- Dranassian
	[6] = Icon(TRP3_InterfaceIcons.LanguageDwarvish), -- Dwarvish
	[7] = Icon(TRP3_InterfaceIcons.LanguageCommon),-- Common
	[13] = Icon(TRP3_InterfaceIcons.LanguageGnomish),-- Gnomish

	-- Horde
	[1] = Icon(TRP3_InterfaceIcons.LanguageOrcish), -- Orcish
	[33] = Icon(TRP3_InterfaceIcons.LanguageForsaken), -- Forsaken
	[3] = Icon(TRP3_InterfaceIcons.LanguageTaurahe), -- Taurahe
	[10] = Icon(TRP3_InterfaceIcons.LanguageThalassian), -- Thalassian
	[14] = Icon(TRP3_InterfaceIcons.LanguageZandali), -- Zandali
	[40] = Icon(TRP3_InterfaceIcons.LanguageGoblin), -- Goblin

	-- Pandaren (now neutral)
	[42] = Icon(TRP3_InterfaceIcons.LanguagePandaren),

	-- Demon hunters
	[8] = Icon(TRP3_InterfaceIcons.LanguageDemonic),

	-- Allied races
	[181] = Icon(TRP3_InterfaceIcons.LanguageShalassian), -- Shalassian
	[285] = Icon(TRP3_InterfaceIcons.LanguageVulpera), -- Vulpera

	-- Funsies
	[37] = Icon(TRP3_InterfaceIcons.LanguageGnomishBinary), -- Gnome binary (Brewfest beer)
	[38] = Icon(TRP3_InterfaceIcons.LanguageGoblinBinary), -- Goblin binary (Brewfest beer)
	[11] = Icon(TRP3_InterfaceIcons.LanguageDraconic), -- Draconic (learned when opening the gates of AQ)
	[180] = Icon(TRP3_InterfaceIcons.LanguageMoonkin), -- Moonkin (seasonal event)
	[12] = Icon(TRP3_InterfaceIcons.LanguageKalimag), -- Kalimag (shaman?)
	[179] = Icon(TRP3_InterfaceIcons.LanguageNerglish), -- Murloc (?)
	[178] = Icon(TRP3_InterfaceIcons.LanguageShathYar), -- Shath'Yar (Shadow priests, Void Elves and Alliance Archbishops)
	[9] = Icon(TRP3_InterfaceIcons.LanguageTitan), -- Titan
	[36] = Icon(TRP3_InterfaceIcons.LanguageZombie), -- Zombie (in your head)
	[168] = Icon(TRP3_InterfaceIcons.LanguageSprite), -- Sprite (Faerie dragon)

}

local TEMP_ICON = Icon(TRP3_InterfaceIcons.Default)

---@class Language : Object
local Language, _private = Ellyb.Class("Language")

function Language:initialize(ID, name, icon)
	_private[self] = {}

	_private[self].ID = ID
	_private[self].name = name
	_private[self].icon = icon or LANGUAGES_ICONS[ID] or TEMP_ICON

	-- Custom language
	_private[self].isCustomLanguage = false
	_private[self].proficiency = 100
end

function Language:GetName()
	return _private[self].name
end

function Language:GetID()
	return _private[self].ID
end

---@return Icon
function Language:GetIcon()
	return _private[self].icon
end

function Language:IsActive()
	return self:GetID() == ChatFrame1EditBox.languageID
end

function Language:__eq(otherLanguage)
	return self:GetID() == otherLanguage:GetID()
end

---@return boolean
function Language:IsKnown()
	for _, knownLanguage in ipairs(AddOn_TotalRP3.Languages.getAvailableLanguages()) do
		if knownLanguage:GetID() == self:GetID() then
			return true
		end
	end
	return false
end

function Language:IsCustomLanguage()
	return _private[self].isCustomLanguage
end

function Language:GetPlayerProficiency()
	return _private[self].proficiency
end

--- Apply custom language modifications to given text
--[[ Override ]] function Language:Apply(text)
	return text
end

AddOn_TotalRP3.Language = Language

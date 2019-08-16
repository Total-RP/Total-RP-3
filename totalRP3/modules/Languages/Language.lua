----------------------------------------------------------------------------------
--- Total RP 3
--- Language switcher
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

---@type TRP3_API
local _, TRP3_API = ...;
local is_classic = TRP3_API.globals.is_classic;

local Ellyb = Ellyb(...);
local AddOn_TotalRP3 = AddOn_TotalRP3;

local Icon = Ellyb.Icon

---@type Icon[]
local LANGUAGES_ICONS = {

	-- Alliance
	[35] = Icon("Inv_Misc_Tournaments_banner_Draenei"), -- Draenei
	[2] = Icon(is_classic and "Spell_Arcane_TeleportMoonglade" or "Inv_Misc_Tournaments_banner_Nightelf"), -- Dranassian
	[6] = Icon(is_classic and "Spell_Arcane_TeleportIronForge" or "Inv_Misc_Tournaments_banner_Dwarf"), -- Dwarvish
	[7] = Icon(is_classic and "Spell_Arcane_TeleportStormWind" or "Inv_Misc_Tournaments_banner_Human"),-- Common
	[13] = Icon(is_classic and "INV_Misc_EngGizmos_01" or "Inv_Misc_Tournaments_banner_Gnome"),-- Gnomish

	-- Horde
	[1] = Icon(is_classic and "Spell_Arcane_TeleportOrgrimmar" or "Inv_Misc_Tournaments_banner_Orc"), -- Orcish
	[33] = Icon(is_classic and "Spell_Arcane_TeleportUnderCity" or "Inv_Misc_Tournaments_banner_Scourge"), -- Forsaken
	[3] = Icon(is_classic and "Spell_Arcane_TeleportThunderBluff" or "Inv_Misc_Tournaments_banner_Tauren"), -- Taurahe
	[10] = Icon("Inv_Misc_Tournaments_banner_Bloodelf"), -- Thalassian
	[14] = Icon(is_classic and "INV_Banner_01" or "Inv_Misc_Tournaments_banner_Troll"), -- Zandali
	[40] = Icon("achievement_Goblinhead"), -- Goblin

	-- Pandaren (now neutral)
	[42] = Icon("Achievement_Guild_ClassyPanda"),

	-- Demon hunters
	[8] = Icon("artifactability_havocdemonhunter_anguishofthedeceiver"),

	-- Allied races
	[181] = Icon("Achievement_AlliedRace_Nightborne"), -- Shalassian

	-- Funsies
	[37] = Icon("inv_misc_punchcards_blue"), -- Gnome binary (Brewfest beer)
	[38] = Icon("inv_misc_punchcards_blue"), -- Goblin binary (Brewfest beer)
	[11] = Icon("ability_warrior_dragonroar"), -- Draconic (learned when opening the gates of AQ)
	[180] = Icon("ability_druid_improvedmoonkinform"), -- Moonkin (seasonal event)
	[12] = Icon("shaman_talent_elementalblast"), -- Kalimag (shaman?)
	[179] = Icon("inv_pet_babymurlocs_blue"), -- Murloc (?)
	[178] = Icon("spell_priest_voidform"), -- Shath'Yar (Shadow priests, Void Elves and Alliance Archbishops)
	[9] = Icon("achievement_dungeon_ulduarraid_titan_01"), -- Titan
	[36] = Icon("icon_petfamily_undead"), -- Zombie (in your head)
	[168] = Icon("inv_pet_sprite_darter_hatchling"), -- Sprite (Faerie dragon)

}

local TEMP_ICON = Icon("INV_Misc_QuestionMark")

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

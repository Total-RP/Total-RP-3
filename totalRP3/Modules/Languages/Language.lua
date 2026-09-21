-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Ellyb = TRP3_API.Ellyb;
local AddOn_TotalRP3 = AddOn_TotalRP3;

local Icon = Ellyb.Icon

---@type Icon[]
local LANGUAGES_ICONS = {
	-- Alliance
	[35] = Icon(TRP3_InterfaceIconIDs.LanguageDraenei), -- Draenei
	[2] = Icon(TRP3_InterfaceIconIDs.LanguageDarnassian), -- Dranassian
	[6] = Icon(TRP3_InterfaceIconIDs.LanguageDwarvish), -- Dwarvish
	[7] = Icon(TRP3_InterfaceIconIDs.LanguageCommon),-- Common
	[13] = Icon(TRP3_InterfaceIconIDs.LanguageGnomish),-- Gnomish

	-- Horde
	[1] = Icon(TRP3_InterfaceIconIDs.LanguageOrcish), -- Orcish
	[33] = Icon(TRP3_InterfaceIconIDs.LanguageForsaken), -- Forsaken
	[3] = Icon(TRP3_InterfaceIconIDs.LanguageTaurahe), -- Taurahe
	[10] = Icon(TRP3_InterfaceIconIDs.LanguageThalassian), -- Thalassian
	[14] = Icon(TRP3_InterfaceIconIDs.LanguageZandali), -- Zandali
	[40] = Icon(TRP3_InterfaceIconIDs.LanguageGoblin), -- Goblin

	-- Pandaren (now neutral)
	[42] = Icon(TRP3_InterfaceIconIDs.LanguagePandaren),

	-- Demon hunters
	[8] = Icon(TRP3_InterfaceIconIDs.LanguageDemonic),

	-- Allied races
	[181] = Icon(TRP3_InterfaceIconIDs.LanguageShalassian), -- Shalassian
	[285] = Icon(TRP3_InterfaceIconIDs.LanguageVulpera), -- Vulpera
	[9] = Icon(TRP3_InterfaceIconIDs.LanguageTitan), -- Titan (Earthen)
	[309] = Icon(TRP3_InterfaceIconIDs.LanguageHarani), -- Hara'ni

	-- Funsies
	[37] = Icon(TRP3_InterfaceIconIDs.LanguageGnomishBinary), -- Gnome binary (Brewfest beer)
	[38] = Icon(TRP3_InterfaceIconIDs.LanguageGoblinBinary), -- Goblin binary (Brewfest beer)
	[11] = Icon(TRP3_InterfaceIconIDs.LanguageDraconic), -- Draconic (learned when opening the gates of AQ)
	[180] = Icon(TRP3_InterfaceIconIDs.LanguageMoonkin), -- Moonkin (seasonal event)
	[12] = Icon(TRP3_InterfaceIconIDs.LanguageKalimag), -- Kalimag (shaman?)
	[179] = Icon(TRP3_InterfaceIconIDs.LanguageNerglish), -- Murloc (?)
	[178] = Icon(TRP3_InterfaceIconIDs.LanguageShathYar), -- Shath'Yar (Shadow priests, Void Elves and Alliance Archbishops)
	[36] = Icon(TRP3_InterfaceIconIDs.LanguageZombie), -- Zombie (in your head)
	[168] = Icon(TRP3_InterfaceIconIDs.LanguageSprite), -- Sprite (Faerie dragon)
	[303] = Icon(TRP3_InterfaceIconIDs.LanguageFurbolg), -- Furbolg (Dragonflight reputation)

}

local TEMP_ICON = Icon(TRP3_InterfaceIconIDs.Default)

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

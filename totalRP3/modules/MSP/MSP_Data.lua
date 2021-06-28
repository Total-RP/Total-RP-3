--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- This string is used for msp_RPAddOn and in the addon versions (VA) field.
TRP3_MSPAddOnID = "TotalRP3";

TRP3_MSPRequestFields =
{
	-- The order of subtables will impact responsiveness of comms as MSP
	-- responds to fields requested in the order below; smaller and more
	-- important fields should go first, bulkier fields (like about)
	-- should always go last.

	[TRP3_MSPRequestType.Full] =
	{
		TRP3_MSPField.ProfileID,
		TRP3_MSPField.Tooltip,
		TRP3_MSPField.Icon,
		TRP3_MSPField.Pronouns,
		TRP3_MSPField.OOCText,
		TRP3_MSPField.RelationshipStatus,
		TRP3_MSPField.Age,
		TRP3_MSPField.Height,
		TRP3_MSPField.Weight,
		TRP3_MSPField.EyeColor,
		TRP3_MSPField.Birthplace,
		TRP3_MSPField.Residence,
		TRP3_MSPField.Motto,
		TRP3_MSPField.Nickname,
		TRP3_MSPField.HouseName,
		TRP3_MSPField.PersonalityTraits,
		TRP3_MSPField.Glances,
		TRP3_MSPField.Description,
		TRP3_MSPField.History,
	},

	[TRP3_MSPRequestType.Probe] =
	{
		TRP3_MSPField.ProfileID,
		TRP3_MSPField.AddOnVersions,
	},

	[TRP3_MSPRequestType.Tooltip] =
	{
		TRP3_MSPField.ProfileID,
		TRP3_MSPField.Tooltip,
	},

	[TRP3_MSPRequestType.NamePlate] =
	{
		TRP3_MSPField.ProfileID,
		TRP3_MSPField.Name,
		TRP3_MSPField.FullTitle,
		TRP3_MSPField.PrefixTitle,
		TRP3_MSPField.Icon,
		TRP3_MSPField.Class,
		TRP3_MSPField.CharacterStatus,
	},
};

TRP3_MSPTooltipFields =
{
	TRP3_MSPField.OOCText,
	TRP3_MSPField.Icon,
	TRP3_MSPField.PrefixTitle,
	TRP3_MSPField.Class,
	TRP3_MSPField.RelationshipStatus,
	TRP3_MSPField.TrialStatus,
	TRP3_MSPField.Pronouns,
};

-- The personality trait definitions below are kept separate as we don't want
-- to tie our internal presets to the comms ones.

TRP3_MSPPersonalityTraits =
{
	{
		leftEnglishText    = "Chaotic",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_CHAOTIC; end,
		leftIcon           = TRP3_InterfaceIcons.TraitChaotic,
		rightEnglishText   = "Loyal",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Loyal; end,
		rightIcon          = TRP3_InterfaceIcons.TraitLoyal,
	},
	{
		leftEnglishText    = "Chaste",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Chaste; end,
		leftIcon           = TRP3_InterfaceIcons.TraitChaste,
		rightEnglishText   = "Lustful",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Luxurieux; end,
		rightIcon          = TRP3_InterfaceIcons.TraitLustful,
	},
	{
		leftEnglishText    = "Forgiving",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Indulgent; end,
		leftIcon           = TRP3_InterfaceIcons.TraitForgiving,
		rightEnglishText   = "Vindictive",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Rencunier; end,
		rightIcon          = TRP3_InterfaceIcons.TraitVindictive,
	},
	{
		leftEnglishText    = "Altruistic",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Genereux; end,
		leftIcon           = TRP3_InterfaceIcons.TraitAltruistic,
		rightEnglishText   = "Selfish",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Egoiste; end,
		rightIcon          = TRP3_InterfaceIcons.TraitSelfish,
	},
	{
		leftEnglishText    = "Truthful",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Sincere; end,
		leftIcon           = TRP3_InterfaceIcons.TraitTruthful,
		rightEnglishText   = "Deceitful",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Trompeur; end,
		rightIcon          = TRP3_InterfaceIcons.TraitDeceitful,
	},
	{
		leftEnglishText    = "Gentle",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Misericordieux; end,
		leftIcon           = TRP3_InterfaceIcons.TraitGentle,
		rightEnglishText   = "Brutal",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Cruel; end,
		rightIcon          = TRP3_InterfaceIcons.TraitBrutal,
	},
	{
		leftEnglishText    = "Superstitious",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Pieux; end,
		leftIcon           = TRP3_InterfaceIcons.TraitSuperstitious,
		rightEnglishText   = "Rational",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Rationnel; end,
		rightIcon          = TRP3_InterfaceIcons.TraitRational,
	},
	{
		leftEnglishText    = "Renegade",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Pragmatique; end,
		leftIcon           = TRP3_InterfaceIcons.TraitRenegade,
		rightEnglishText   = "Paragon",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Conciliant; end,
		rightIcon          = TRP3_InterfaceIcons.TraitParagon,
	},
	{
		leftEnglishText    = "Cautious",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Reflechi; end,
		leftIcon           = TRP3_InterfaceIcons.TraitCautious,
		rightEnglishText   = "Impulsive",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Impulsif; end,
		rightIcon          = TRP3_InterfaceIcons.TraitImpulsive,
	},
	{
		leftEnglishText    = "Ascetic",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Acete; end,
		leftIcon           = TRP3_InterfaceIcons.TraitAscetic,
		rightEnglishText   = "Bon Vivant",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Bonvivant; end,
		rightIcon          = TRP3_InterfaceIcons.TraitBonVivant,
	},
	{
		leftEnglishText    = "Valorous",
		leftLocalizedText  = function() return L.REG_PLAYER_PSYCHO_Valeureux; end,
		leftIcon           = TRP3_InterfaceIcons.TraitValorous,
		rightEnglishText   = "Spineless",
		rightLocalizedText = function() return L.REG_PLAYER_PSYCHO_Couard; end,
		rightIcon          = TRP3_InterfaceIcons.TraitSpineless,
	},
};

TRP3_MSPMiscFieldInfo =
{
	{
		field         = TRP3_MSPField.Motto,
		englishText   = "Motto",
		localizedText = function() return L.REG_PLAYER_MSP_MOTTO; end,
		icon          = TRP3_InterfaceIcons.MiscInfoMotto,
		formatter     = function(value) return string.format([["%s"]], value); end,
	},
	{
		field         = TRP3_MSPField.HouseName,
		englishText   = "House name",
		localizedText = function() return L.REG_PLAYER_MSP_HOUSE; end,
		icon          = TRP3_InterfaceIcons.MiscInfoHouse,
	},
	{
		field         = TRP3_MSPField.Nickname,
		englishText   = "Nickname",
		localizedText = function() return L.REG_PLAYER_MSP_NICK; end,
		icon          = TRP3_InterfaceIcons.MiscInfoNickname,
	},
	{
		field         = TRP3_MSPField.Pronouns,
		englishText   = "Pronouns",
		localizedText = function() return L.REG_PLAYER_MISC_PRESET_PRONOUNS; end,
		icon          = TRP3_InterfaceIcons.MiscInfoPronouns,
	},
};

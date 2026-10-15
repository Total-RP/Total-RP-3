-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

Constants = {
	CharacterNameSeparatorConsts = {
		CHARACTERNAME_REALMNAME_SEPARATOR = "-",
		CHARACTERNAME_SURNAME_SEPARATOR = " ",
	},
};

Enum = {
	ExpansionLevel = {
		None = 0,
		BurningCrusade = 1,
		Northrend = 2,
		Cataclysm = 3,
		MistsOfPandaria = 4,
		Draenor = 5,
		Legion = 6,
		BattleForAzeroth = 7,
		Shadowlands = 8,
		Dragonflight = 9,
		WarWithin = 10,
		Midnight = 11,
		LastTitan = 12,
	},

	GameRule = {
		TransmogEnabled = 109,
	},
};

WOW_PROJECT_MAINLINE = 1;
WOW_PROJECT_CLASSIC = 2;
WOW_PROJECT_BURNING_CRUSADE_CLASSIC = 5;
WOW_PROJECT_WRATH_CLASSIC = 11;
WOW_PROJECT_CATACLYSM_CLASSIC = 14;
WOW_PROJECT_FOREVER = 18;
WOW_PROJECT_MISTS_CLASSIC = 19;

LE_EXPANSION_CLASSIC = Enum.ExpansionLevel.None;
LE_EXPANSION_BURNING_CRUSADE = Enum.ExpansionLevel.BurningCrusade;
LE_EXPANSION_WRATH_OF_THE_LICH_KING = Enum.ExpansionLevel.Northrend;
LE_EXPANSION_CATACLYSM = Enum.ExpansionLevel.Cataclysm;
LE_EXPANSION_MISTS_OF_PANDARIA = Enum.ExpansionLevel.MistsOfPandaria;
LE_EXPANSION_WARLORDS_OF_DRAENOR = Enum.ExpansionLevel.Draenor;
LE_EXPANSION_LEGION = Enum.ExpansionLevel.Legion;
LE_EXPANSION_BATTLE_FOR_AZEROTH = Enum.ExpansionLevel.BattleForAzeroth;
LE_EXPANSION_SHADOWLANDS = Enum.ExpansionLevel.Shadowlands;
LE_EXPANSION_DRAGONFLIGHT = Enum.ExpansionLevel.Dragonflight;
LE_EXPANSION_WAR_WITHIN = Enum.ExpansionLevel.WarWithin;
LE_EXPANSION_MIDNIGHT = Enum.ExpansionLevel.Midnight;

SOUNDKIT = {};

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

AddOn_TotalRP3.Enums = {};

AddOn_TotalRP3.Enums.ACCOUNT_TYPE = {
	REGULAR = 0,
	TRIAL = 1,
	VETERAN = 2
}

AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS = {
	UNKNOWN = 0,
	SINGLE = 1,
	TAKEN = 2,
	MARRIED = 3,
	DIVORCED = 4,
	WIDOWED = 5,
}

-- ROLEPLAY_STATUS is an enumeration of roleplay statuses for a player unit.
AddOn_TotalRP3.Enums.ROLEPLAY_STATUS = {
	IN_CHARACTER = 1,
	OUT_OF_CHARACTER = 2,
};

-- ROLEPLAY_EXPERIENCE is an enumeration of roleplay experience entries for
-- a player, for example "beginner roleplayer".
AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE = {
	BEGINNER = 1,
	EXPERIENCED = 2,
	VOLUNTEER = 3,
};

-- UNIT_TYPE describes the base type of a unit, such as whether it represents
-- a character or pet. These replace the old TRP3_API.ui.misc.TYPE_* constants.
AddOn_TotalRP3.Enums.UNIT_TYPE = {
	CHARACTER = "CHARACTER",
	PET = "PET",
	BATTLE_PET = "BATTLE_PET",
	MOUNT = "MOUNT", -- Not a real unit, but used for companion profiles.
	NPC = "NPC",
};

-- Configuration --
AddOn_TotalRP3.Enums.GENERAL_SETTINGS_CONFIG_KEYS = {
	DATE_FORMAT = "date_format"
}
AddOn_TotalRP3.Enums.DATE_OPTIONS = {
	D_M_Y = "D/M/Y",
	M_D_Y = "M/D/Y",
	Y_M_D = "Y/M/D"
}

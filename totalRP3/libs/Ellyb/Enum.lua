---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Enum then
	return
end

local Enum = {};
Ellyb.Enum = Enum;

Enum.CHARS = {
	NON_BREAKING_SPACE = " "
}

Enum.UI_ESCAPE_SEQUENCES = {
	CLOSE = "|r",
	COLOR = "|c%.2x%.2x%.2x%.2x",
}

Enum.CLASSES = {
	HUNTER = "HUNTER",
	WARLOCK = "WARLOCK",
	PRIEST = "PRIEST",
	PALADIN = "PALADIN",
	MAGE = "MAGE",
	ROGUE = "ROGUE",
	DRUID = "DRUID",
	SHAMAN = "SHAMAN",
	WARRIOR = "WARRIOR",
	DEATHKNIGHT = "DEATHKNIGHT",
	MONK = "MONK",
	DEMONHUNTER = "DEMONHUNTER",
}

Enum.LOCALES = {
	FRENCH = "frFR",
	ENGLISH = "enUS",
}

Enum.GAME_CLIENT_TYPES = {
	RETAIL = WOW_PROJECT_MAINLINE,
	CLASSIC = WOW_PROJECT_CLASSIC
}
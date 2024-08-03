-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

local function TryCreateColorFromTable(table)
	if table then
		return TRP3_API.CreateColorFromTable(table);
	end
end

-- Basic colors
TRP3_API.Colors =
{
	Red = TRP3_API.CreateColorFromBytes(255, 0, 0),
	Orange = TRP3_API.CreateColorFromBytes(255, 153, 0),
	Yellow = TRP3_API.CreateColorFromBytes(255, 209, 0),
	Green = TRP3_API.CreateColorFromBytes(0, 255, 0),
	Cyan = TRP3_API.CreateColorFromBytes(0, 255, 255),
	Blue = TRP3_API.CreateColorFromBytes(0, 0, 255),
	Purple = TRP3_API.CreateColorFromBytes(128, 0, 255),
	Pink = TRP3_API.CreateColorFromBytes(255, 0, 255),
	White = TRP3_API.CreateColorFromBytes(255, 255, 255),
	Grey = TRP3_API.CreateColorFromBytes(204, 204, 204),
	Black = TRP3_API.CreateColorFromBytes(0, 0, 0),
};

-- Faction colors (See: PLAYER_FACTION_COLORS)
TRP3_API.FactionColors =
{
	Alliance = TryCreateColorFromTable(PLAYER_FACTION_COLOR_ALLIANCE) or TRP3_API.CreateColorFromBytes(74, 84, 232),
	Horde = TryCreateColorFromTable(PLAYER_FACTION_COLOR_HORDE) or TRP3_API.CreateColorFromBytes(229, 13, 18),
};

-- Item quality colors (see: https://warcraft.wiki.gg/wiki/Quality)
TRP3_API.ItemQualityColors =
{
	Artifact = TryCreateColorFromTable(ITEM_ARTIFACT_COLOR) or TRP3_API.CreateColorFromBytes(230, 204, 128),
	Common = TryCreateColorFromTable(ITEM_STANDARD_COLOR) or TRP3_API.CreateColorFromBytes(255, 255, 255),
	Epic = TryCreateColorFromTable(ITEM_EPIC_COLOR) or TRP3_API.CreateColorFromBytes(163, 53, 238),
	Heirloom = TryCreateColorFromTable(ITEM_WOW_TOKEN_COLOR) or TRP3_API.CreateColorFromBytes(0, 204, 255),
	Legendary = TryCreateColorFromTable(ITEM_LEGENDARY_COLOR) or TRP3_API.CreateColorFromBytes(255, 128, 0),
	Poor = TryCreateColorFromTable(ITEM_POOR_COLOR) or TRP3_API.CreateColorFromBytes(157, 157, 157),
	Rare = TryCreateColorFromTable(ITEM_SUPERIOR_COLOR) or TRP3_API.CreateColorFromBytes(0, 112, 221),
	Uncommon = TryCreateColorFromTable(ITEM_GOOD_COLOR) or TRP3_API.CreateColorFromBytes(30, 255, 0),
	WoWToken = TryCreateColorFromTable(ITEM_WOW_TOKEN_COLOR) or TRP3_API.CreateColorFromBytes(0, 204, 255),
};

-- Class colors (see: https://warcraft.wiki.gg/wiki/Class_colors)
-- These use uppercase keys to match API-provided class tokens.
TRP3_API.ClassColors =
{
	DEATHKNIGHT = TRP3_API.GetClassDisplayColor("DEATHKNIGHT") or TRP3_API.CreateColorFromBytes(196, 30, 58),
	DEMONHUNTER = TRP3_API.GetClassDisplayColor("DEMONHUNTER") or TRP3_API.CreateColorFromBytes(163, 48, 201),
	DRUID = TRP3_API.GetClassDisplayColor("DRUID") or TRP3_API.CreateColorFromBytes(255, 124, 10),
	EVOKER = TRP3_API.GetClassDisplayColor("EVOKER") or TRP3_API.CreateColorFromBytes(51, 147, 127),
	HUNTER = TRP3_API.GetClassDisplayColor("HUNTER") or TRP3_API.CreateColorFromBytes(170, 211, 114),
	MAGE = TRP3_API.GetClassDisplayColor("MAGE") or TRP3_API.CreateColorFromBytes(63, 199, 235),
	MONK = TRP3_API.GetClassDisplayColor("MONK") or TRP3_API.CreateColorFromBytes(0, 255, 152),
	PALADIN = TRP3_API.GetClassDisplayColor("PALADIN") or TRP3_API.CreateColorFromBytes(244, 140, 186),
	PRIEST = TRP3_API.GetClassDisplayColor("PRIEST") or TRP3_API.CreateColorFromBytes(255, 255, 255),
	ROGUE = TRP3_API.GetClassDisplayColor("ROGUE") or TRP3_API.CreateColorFromBytes(255, 244, 104),
	SHAMAN = TRP3_API.GetClassDisplayColor("SHAMAN") or TRP3_API.CreateColorFromBytes(0, 112, 221),
	WARLOCK = TRP3_API.GetClassDisplayColor("WARLOCK") or TRP3_API.CreateColorFromBytes(135, 136, 238),
	WARRIOR = TRP3_API.GetClassDisplayColor("WARRIOR") or TRP3_API.CreateColorFromBytes(198, 155, 109),
};

-- Relation colors
TRP3_API.RelationColors =
{
	Unfriendly = TRP3_API.CreateColorFromBytes(255, 32, 32),
	Neutral = TRP3_API.CreateColorFromBytes(128, 128, 255),
	Business = TRP3_API.CreateColorFromBytes(255, 255, 0),
	Love = TRP3_API.CreateColorFromBytes(255, 192, 203),
	Family = TRP3_API.CreateColorFromBytes(255, 192, 0),
	Friend = TRP3_API.CreateColorFromBytes(25, 255, 25),
}

-- Power colors (See: https://warcraft.wiki.gg/wiki/Power_colors)
TRP3_API.PowerTypeColors =
{
	AmmoSlot = TRP3_API.CreateColorFromBytes(204, 153, 0),
	ArcaneCharges = TRP3_API.CreateColorFromBytes(26, 26, 250),
	Chi = TRP3_API.CreateColorFromBytes(181, 255, 235),
	ComboPoints = TRP3_API.CreateColorFromBytes(255, 245, 105),
	Energy = TRP3_API.CreateColorFromBytes(255, 255, 0),
	Focus = TRP3_API.CreateColorFromBytes(255, 128, 64),
	Fuel = TRP3_API.CreateColorFromBytes(0, 140, 128),
	Fury = TRP3_API.CreateColorFromBytes(201, 66, 253),
	HolyPower = TRP3_API.CreateColorFromBytes(242, 230, 153),
	Insanity = TRP3_API.CreateColorFromBytes(102, 0, 204),
	LunarPower = TRP3_API.CreateColorFromBytes(77, 133, 230),
	Maelstrom = TRP3_API.CreateColorFromBytes(0, 128, 255),
	Mana = TRP3_API.CreateColorFromBytes(0, 0, 255),
	Pain = TRP3_API.CreateColorFromBytes(255, 156, 0),
	Rage = TRP3_API.CreateColorFromBytes(255, 0, 0),
	Runes = TRP3_API.CreateColorFromBytes(128, 128, 128),
	RunicPower = TRP3_API.CreateColorFromBytes(0, 209, 255),
	SoulShards = TRP3_API.CreateColorFromBytes(128, 82, 105),
	StaggerHeavy = TRP3_API.CreateColorFromBytes(255, 107, 107),
	StaggerLight = TRP3_API.CreateColorFromBytes(133, 255, 133),
	StaggerMedium = TRP3_API.CreateColorFromBytes(255, 250, 184),
};

-- Misc. colors.
TRP3_API.MiscColors =
{
	BattleNet = TRP3_API.CreateColorFromTable(BATTLENET_FONT_COLOR),
	CraftingReagent = TRP3_API.CreateColorFromBytes(102, 187, 255),
	Disabled = TRP3_API.CreateColorFromTable(DISABLED_FONT_COLOR),
	Highlight = TRP3_API.CreateColorFromTable(HIGHLIGHT_FONT_COLOR),
	Link = TRP3_API.CreateColorFromTable(LINK_FONT_COLOR or { r = 0.4, g = 0.73, b = 1 }),
	Normal = TRP3_API.CreateColorFromTable(NORMAL_FONT_COLOR),
	Transmogrify = TRP3_API.CreateColorFromTable(TRANSMOGRIFY_FONT_COLOR),
	Warning = TRP3_API.CreateColorFromTable(WARNING_FONT_COLOR or { r = 1, g = 0.28, b = 0 }),

	PersonalityTraitColorLeft = TRP3_API.CreateColor(1, 0.76, 0.42),
	PersonalityTraitColorRight = TRP3_API.CreateColor(0.42, 0.65, 1),
};

-- Mapping of named colors. Colors in this table are available to markup and
-- may differ from those in the standard Colors table. These must be defined
-- with uppercase keys.
TRP3_API.NamedColors =
{
	-- CSS named colors (see: https://developer.mozilla.org/en-US/docs/Web/CSS/named-color)
	ALICEBLUE = TRP3_API.CreateColorFromBytes(240, 248, 255),
	ANTIQUEWHITE = TRP3_API.CreateColorFromBytes(250, 235, 215),
	AQUA = TRP3_API.CreateColorFromBytes(0, 255, 255),
	AQUAMARINE = TRP3_API.CreateColorFromBytes(127, 255, 212),
	AZURE = TRP3_API.CreateColorFromBytes(240, 255, 255),
	BEIGE = TRP3_API.CreateColorFromBytes(245, 245, 220),
	BISQUE = TRP3_API.CreateColorFromBytes(255, 228, 196),
	BLACK = TRP3_API.CreateColorFromBytes(0, 0, 0),
	BLANCHEDALMOND = TRP3_API.CreateColorFromBytes(255, 235, 205),
	BLUE = TRP3_API.CreateColorFromBytes(0, 0, 255),
	BLUEVIOLET = TRP3_API.CreateColorFromBytes(138, 43, 226),
	BROWN = TRP3_API.CreateColorFromBytes(165, 42, 42),
	BURLYWOOD = TRP3_API.CreateColorFromBytes(222, 184, 135),
	CADETBLUE = TRP3_API.CreateColorFromBytes(95, 158, 160),
	CHARTREUSE = TRP3_API.CreateColorFromBytes(127, 255, 0),
	CHOCOLATE = TRP3_API.CreateColorFromBytes(210, 105, 30),
	CORAL = TRP3_API.CreateColorFromBytes(255, 127, 80),
	CORNFLOWERBLUE = TRP3_API.CreateColorFromBytes(100, 149, 237),
	CORNSILK = TRP3_API.CreateColorFromBytes(255, 248, 220),
	CRIMSON = TRP3_API.CreateColorFromBytes(220, 20, 60),
	CYAN = TRP3_API.CreateColorFromBytes(0, 255, 255),
	DARKBLUE = TRP3_API.CreateColorFromBytes(0, 0, 139),
	DARKCYAN = TRP3_API.CreateColorFromBytes(0, 139, 139),
	DARKGOLDENROD = TRP3_API.CreateColorFromBytes(184, 134, 11),
	DARKGRAY = TRP3_API.CreateColorFromBytes(169, 169, 169),
	DARKGREEN = TRP3_API.CreateColorFromBytes(0, 100, 0),
	DARKGREY = TRP3_API.CreateColorFromBytes(169, 169, 169),
	DARKKHAKI = TRP3_API.CreateColorFromBytes(189, 183, 107),
	DARKMAGENTA = TRP3_API.CreateColorFromBytes(139, 0, 139),
	DARKOLIVEGREEN = TRP3_API.CreateColorFromBytes(85, 107, 47),
	DARKORANGE = TRP3_API.CreateColorFromBytes(255, 140, 0),
	DARKORCHID = TRP3_API.CreateColorFromBytes(153, 50, 204),
	DARKRED = TRP3_API.CreateColorFromBytes(139, 0, 0),
	DARKSALMON = TRP3_API.CreateColorFromBytes(233, 150, 122),
	DARKSEAGREEN = TRP3_API.CreateColorFromBytes(143, 188, 143),
	DARKSLATEBLUE = TRP3_API.CreateColorFromBytes(72, 61, 139),
	DARKSLATEGRAY = TRP3_API.CreateColorFromBytes(47, 79, 79),
	DARKSLATEGREY = TRP3_API.CreateColorFromBytes(47, 79, 79),
	DARKTURQUOISE = TRP3_API.CreateColorFromBytes(0, 206, 209),
	DARKVIOLET = TRP3_API.CreateColorFromBytes(148, 0, 211),
	DEEPPINK = TRP3_API.CreateColorFromBytes(255, 20, 147),
	DEEPSKYBLUE = TRP3_API.CreateColorFromBytes(0, 191, 255),
	DIMGRAY = TRP3_API.CreateColorFromBytes(105, 105, 105),
	DIMGREY = TRP3_API.CreateColorFromBytes(105, 105, 105),
	DODGERBLUE = TRP3_API.CreateColorFromBytes(30, 144, 255),
	FIREBRICK = TRP3_API.CreateColorFromBytes(178, 34, 34),
	FLORALWHITE = TRP3_API.CreateColorFromBytes(255, 250, 240),
	FORESTGREEN = TRP3_API.CreateColorFromBytes(34, 139, 34),
	FUCHSIA = TRP3_API.CreateColorFromBytes(255, 0, 255),
	GAINSBORO = TRP3_API.CreateColorFromBytes(220, 220, 220),
	GHOSTWHITE = TRP3_API.CreateColorFromBytes(248, 248, 255),
	GOLD = TRP3_API.CreateColorFromBytes(255, 215, 0),
	GOLDENROD = TRP3_API.CreateColorFromBytes(218, 165, 32),
	GRAY = TRP3_API.CreateColorFromBytes(128, 128, 128),
	GREEN = TRP3_API.CreateColorFromBytes(0, 128, 0),
	GREENYELLOW = TRP3_API.CreateColorFromBytes(173, 255, 47),
	GREY = TRP3_API.CreateColorFromBytes(128, 128, 128),
	HONEYDEW = TRP3_API.CreateColorFromBytes(240, 255, 240),
	HOTPINK = TRP3_API.CreateColorFromBytes(255, 105, 180),
	INDIANRED = TRP3_API.CreateColorFromBytes(205, 92, 92),
	INDIGO = TRP3_API.CreateColorFromBytes(75, 0, 130),
	IVORY = TRP3_API.CreateColorFromBytes(255, 255, 240),
	KHAKI = TRP3_API.CreateColorFromBytes(240, 230, 140),
	LAVENDER = TRP3_API.CreateColorFromBytes(230, 230, 250),
	LAVENDERBLUSH = TRP3_API.CreateColorFromBytes(255, 240, 245),
	LAWNGREEN = TRP3_API.CreateColorFromBytes(124, 252, 0),
	LEMONCHIFFON = TRP3_API.CreateColorFromBytes(255, 250, 205),
	LIGHTBLUE = TRP3_API.CreateColorFromBytes(173, 216, 230),
	LIGHTCORAL = TRP3_API.CreateColorFromBytes(240, 128, 128),
	LIGHTCYAN = TRP3_API.CreateColorFromBytes(224, 255, 255),
	LIGHTGOLDENRODYELLOW = TRP3_API.CreateColorFromBytes(250, 250, 210),
	LIGHTGRAY = TRP3_API.CreateColorFromBytes(211, 211, 211),
	LIGHTGREEN = TRP3_API.CreateColorFromBytes(144, 238, 144),
	LIGHTGREY = TRP3_API.CreateColorFromBytes(211, 211, 211),
	LIGHTPINK = TRP3_API.CreateColorFromBytes(255, 182, 193),
	LIGHTSALMON = TRP3_API.CreateColorFromBytes(255, 160, 122),
	LIGHTSEAGREEN = TRP3_API.CreateColorFromBytes(32, 178, 170),
	LIGHTSKYBLUE = TRP3_API.CreateColorFromBytes(135, 206, 250),
	LIGHTSLATEGRAY = TRP3_API.CreateColorFromBytes(119, 136, 153),
	LIGHTSLATEGREY = TRP3_API.CreateColorFromBytes(119, 136, 153),
	LIGHTSTEELBLUE = TRP3_API.CreateColorFromBytes(176, 196, 222),
	LIGHTYELLOW = TRP3_API.CreateColorFromBytes(255, 255, 224),
	LIME = TRP3_API.CreateColorFromBytes(0, 255, 0),
	LIMEGREEN = TRP3_API.CreateColorFromBytes(50, 205, 50),
	LINEN = TRP3_API.CreateColorFromBytes(250, 240, 230),
	MAGENTA = TRP3_API.CreateColorFromBytes(255, 0, 255),
	MAROON = TRP3_API.CreateColorFromBytes(128, 0, 0),
	MEDIUMAQUAMARINE = TRP3_API.CreateColorFromBytes(102, 205, 170),
	MEDIUMBLUE = TRP3_API.CreateColorFromBytes(0, 0, 205),
	MEDIUMORCHID = TRP3_API.CreateColorFromBytes(186, 85, 211),
	MEDIUMPURPLE = TRP3_API.CreateColorFromBytes(147, 112, 219),
	MEDIUMSEAGREEN = TRP3_API.CreateColorFromBytes(60, 179, 113),
	MEDIUMSLATEBLUE = TRP3_API.CreateColorFromBytes(123, 104, 238),
	MEDIUMSPRINGGREEN = TRP3_API.CreateColorFromBytes(0, 250, 154),
	MEDIUMTURQUOISE = TRP3_API.CreateColorFromBytes(72, 209, 204),
	MEDIUMVIOLETRED = TRP3_API.CreateColorFromBytes(199, 21, 133),
	MIDNIGHTBLUE = TRP3_API.CreateColorFromBytes(25, 25, 112),
	MINTCREAM = TRP3_API.CreateColorFromBytes(245, 255, 250),
	MISTYROSE = TRP3_API.CreateColorFromBytes(255, 228, 225),
	MOCCASIN = TRP3_API.CreateColorFromBytes(255, 228, 181),
	NAVAJOWHITE = TRP3_API.CreateColorFromBytes(255, 222, 173),
	NAVY = TRP3_API.CreateColorFromBytes(0, 0, 128),
	OLDLACE = TRP3_API.CreateColorFromBytes(253, 245, 230),
	OLIVE = TRP3_API.CreateColorFromBytes(128, 128, 0),
	OLIVEDRAB = TRP3_API.CreateColorFromBytes(107, 142, 35),
	ORANGE = TRP3_API.CreateColorFromBytes(255, 165, 0),
	ORANGERED = TRP3_API.CreateColorFromBytes(255, 69, 0),
	ORCHID = TRP3_API.CreateColorFromBytes(218, 112, 214),
	PALEGOLDENROD = TRP3_API.CreateColorFromBytes(238, 232, 170),
	PALEGREEN = TRP3_API.CreateColorFromBytes(152, 251, 152),
	PALETURQUOISE = TRP3_API.CreateColorFromBytes(175, 238, 238),
	PALEVIOLETRED = TRP3_API.CreateColorFromBytes(219, 112, 147),
	PAPAYAWHIP = TRP3_API.CreateColorFromBytes(255, 239, 213),
	PEACHPUFF = TRP3_API.CreateColorFromBytes(255, 218, 185),
	PERU = TRP3_API.CreateColorFromBytes(205, 133, 63),
	PINK = TRP3_API.CreateColorFromBytes(255, 192, 203),
	PLUM = TRP3_API.CreateColorFromBytes(221, 160, 221),
	POWDERBLUE = TRP3_API.CreateColorFromBytes(176, 224, 230),
	PURPLE = TRP3_API.CreateColorFromBytes(128, 0, 128),
	REBECCAPURPLE = TRP3_API.CreateColorFromBytes(102, 51, 153),
	RED = TRP3_API.CreateColorFromBytes(255, 0, 0),
	ROSYBROWN = TRP3_API.CreateColorFromBytes(188, 143, 143),
	ROYALBLUE = TRP3_API.CreateColorFromBytes(65, 105, 225),
	SADDLEBROWN = TRP3_API.CreateColorFromBytes(139, 69, 19),
	SALMON = TRP3_API.CreateColorFromBytes(250, 128, 114),
	SANDYBROWN = TRP3_API.CreateColorFromBytes(244, 164, 96),
	SEAGREEN = TRP3_API.CreateColorFromBytes(46, 139, 87),
	SEASHELL = TRP3_API.CreateColorFromBytes(255, 245, 238),
	SIENNA = TRP3_API.CreateColorFromBytes(160, 82, 45),
	SILVER = TRP3_API.CreateColorFromBytes(192, 192, 192),
	SKYBLUE = TRP3_API.CreateColorFromBytes(135, 206, 235),
	SLATEBLUE = TRP3_API.CreateColorFromBytes(106, 90, 205),
	SLATEGRAY = TRP3_API.CreateColorFromBytes(112, 128, 144),
	SLATEGREY = TRP3_API.CreateColorFromBytes(112, 128, 144),
	SNOW = TRP3_API.CreateColorFromBytes(255, 250, 250),
	SPRINGGREEN = TRP3_API.CreateColorFromBytes(0, 255, 127),
	STEELBLUE = TRP3_API.CreateColorFromBytes(70, 130, 180),
	TAN = TRP3_API.CreateColorFromBytes(210, 180, 140),
	TEAL = TRP3_API.CreateColorFromBytes(0, 128, 128),
	THISTLE = TRP3_API.CreateColorFromBytes(216, 191, 216),
	TOMATO = TRP3_API.CreateColorFromBytes(255, 99, 71),
	TRANSPARENT = TRP3_API.CreateColorFromBytes(0, 0, 0, 0),
	TURQUOISE = TRP3_API.CreateColorFromBytes(64, 224, 208),
	VIOLET = TRP3_API.CreateColorFromBytes(238, 130, 238),
	WHEAT = TRP3_API.CreateColorFromBytes(245, 222, 179),
	WHITE = TRP3_API.CreateColorFromBytes(255, 255, 255),
	WHITESMOKE = TRP3_API.CreateColorFromBytes(245, 245, 245),
	YELLOW = TRP3_API.CreateColorFromBytes(255, 255, 0),
	YELLOWGREEN = TRP3_API.CreateColorFromBytes(154, 205, 50),

	-- Shorthand color aliases (backwards compatibility)
	["0"] = TRP3_API.CreateColorFromBytes(0, 0, 0),    -- Black
	B = TRP3_API.CreateColorFromBytes(0, 0, 255),      -- Blue
	C = TRP3_API.CreateColorFromBytes(0, 255, 255),    -- Cyan
	G = TRP3_API.CreateColorFromBytes(0, 128, 0),      -- Green
	O = TRP3_API.CreateColorFromBytes(255, 165, 0),    -- Orange
	P = TRP3_API.CreateColorFromBytes(128, 0, 128),    -- Purple
	R = TRP3_API.CreateColorFromBytes(255, 0, 0),      -- Red
	W = TRP3_API.CreateColorFromBytes(255, 255, 255),  -- White
	Y = TRP3_API.CreateColorFromBytes(255, 255, 0),    -- Yellow

	-- Class colors
	DEATHKNIGHT = TRP3_API.ClassColors.DEATHKNIGHT,
	DEMONHUNTER = TRP3_API.ClassColors.DEMONHUNTER,
	DRUID = TRP3_API.ClassColors.DRUID,
	EVOKER = TRP3_API.ClassColors.EVOKER,
	HUNTER = TRP3_API.ClassColors.HUNTER,
	MAGE = TRP3_API.ClassColors.MAGE,
	MONK = TRP3_API.ClassColors.MONK,
	PALADIN = TRP3_API.ClassColors.PALADIN,
	PRIEST = TRP3_API.ClassColors.PRIEST,
	ROGUE = TRP3_API.ClassColors.ROGUE,
	SHAMAN = TRP3_API.ClassColors.SHAMAN,
	WARLOCK = TRP3_API.ClassColors.WARLOCK,
	WARRIOR = TRP3_API.ClassColors.WARRIOR,

	-- Item quality colors
	ARTIFACT = TRP3_API.ItemQualityColors.Artifact,
	COMMON = TRP3_API.ItemQualityColors.Common,
	EPIC = TRP3_API.ItemQualityColors.Epic,
	HEIRLOOM = TRP3_API.ItemQualityColors.Heirloom,
	LEGENDARY = TRP3_API.ItemQualityColors.Legendary,
	POOR = TRP3_API.ItemQualityColors.Poor,
	RARE = TRP3_API.ItemQualityColors.Rare,
	UNCOMMON = TRP3_API.ItemQualityColors.Uncommon,

	-- Faction colors
	ALLIANCE = TRP3_API.FactionColors.Alliance,
	HORDE = TRP3_API.FactionColors.Horde,
};

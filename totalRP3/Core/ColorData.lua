-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local function TryCreateColorFromTable(table)
	if table then
		return TRP3.CreateColorFromTable(table);
	end
end

-- Basic colors
TRP3.Colors =
{
	Red = TRP3.CreateColorFromBytes(255, 0, 0),
	Orange = TRP3.CreateColorFromBytes(255, 153, 0),
	Yellow = TRP3.CreateColorFromBytes(255, 209, 0),
	Green = TRP3.CreateColorFromBytes(0, 255, 0),
	Cyan = TRP3.CreateColorFromBytes(0, 255, 255),
	Blue = TRP3.CreateColorFromBytes(0, 0, 255),
	Purple = TRP3.CreateColorFromBytes(128, 0, 255),
	Pink = TRP3.CreateColorFromBytes(255, 0, 255),
	White = TRP3.CreateColorFromBytes(255, 255, 255),
	Grey = TRP3.CreateColorFromBytes(204, 204, 204),
	Black = TRP3.CreateColorFromBytes(0, 0, 0),
};

-- Faction colors (See: PLAYER_FACTION_COLORS)
TRP3.FactionColors =
{
	Alliance = TryCreateColorFromTable(PLAYER_FACTION_COLOR_ALLIANCE) or TRP3.CreateColorFromBytes(74, 84, 232),
	Horde = TryCreateColorFromTable(PLAYER_FACTION_COLOR_HORDE) or TRP3.CreateColorFromBytes(229, 13, 18),
};

-- Item quality colors (see: https://warcraft.wiki.gg/wiki/Quality)
TRP3.ItemQualityColors =
{
	Artifact = TryCreateColorFromTable(ITEM_ARTIFACT_COLOR) or TRP3.CreateColorFromBytes(230, 204, 128),
	Common = TryCreateColorFromTable(ITEM_STANDARD_COLOR) or TRP3.CreateColorFromBytes(255, 255, 255),
	Epic = TryCreateColorFromTable(ITEM_EPIC_COLOR) or TRP3.CreateColorFromBytes(163, 53, 238),
	Heirloom = TryCreateColorFromTable(ITEM_WOW_TOKEN_COLOR) or TRP3.CreateColorFromBytes(0, 204, 255),
	Legendary = TryCreateColorFromTable(ITEM_LEGENDARY_COLOR) or TRP3.CreateColorFromBytes(255, 128, 0),
	Poor = TryCreateColorFromTable(ITEM_POOR_COLOR) or TRP3.CreateColorFromBytes(157, 157, 157),
	Rare = TryCreateColorFromTable(ITEM_SUPERIOR_COLOR) or TRP3.CreateColorFromBytes(0, 112, 221),
	Uncommon = TryCreateColorFromTable(ITEM_GOOD_COLOR) or TRP3.CreateColorFromBytes(30, 255, 0),
	WoWToken = TryCreateColorFromTable(ITEM_WOW_TOKEN_COLOR) or TRP3.CreateColorFromBytes(0, 204, 255),
};

-- Class colors (see: https://warcraft.wiki.gg/wiki/Class_colors)
-- These use uppercase keys to match API-provided class tokens.
TRP3.ClassColors =
{
	DEATHKNIGHT = TRP3.GetClassDisplayColor("DEATHKNIGHT") or TRP3.CreateColorFromBytes(196, 30, 58),
	DEMONHUNTER = TRP3.GetClassDisplayColor("DEMONHUNTER") or TRP3.CreateColorFromBytes(163, 48, 201),
	DRUID = TRP3.GetClassDisplayColor("DRUID") or TRP3.CreateColorFromBytes(255, 124, 10),
	EVOKER = TRP3.GetClassDisplayColor("EVOKER") or TRP3.CreateColorFromBytes(51, 147, 127),
	HUNTER = TRP3.GetClassDisplayColor("HUNTER") or TRP3.CreateColorFromBytes(170, 211, 114),
	MAGE = TRP3.GetClassDisplayColor("MAGE") or TRP3.CreateColorFromBytes(63, 199, 235),
	MONK = TRP3.GetClassDisplayColor("MONK") or TRP3.CreateColorFromBytes(0, 255, 152),
	PALADIN = TRP3.GetClassDisplayColor("PALADIN") or TRP3.CreateColorFromBytes(244, 140, 186),
	PRIEST = TRP3.GetClassDisplayColor("PRIEST") or TRP3.CreateColorFromBytes(255, 255, 255),
	ROGUE = TRP3.GetClassDisplayColor("ROGUE") or TRP3.CreateColorFromBytes(255, 244, 104),
	SHAMAN = TRP3.GetClassDisplayColor("SHAMAN") or TRP3.CreateColorFromBytes(0, 112, 221),
	WARLOCK = TRP3.GetClassDisplayColor("WARLOCK") or TRP3.CreateColorFromBytes(135, 136, 238),
	WARRIOR = TRP3.GetClassDisplayColor("WARRIOR") or TRP3.CreateColorFromBytes(198, 155, 109),
};

-- Relation colors
TRP3.RelationColors =
{
	Unfriendly = TRP3.CreateColorFromBytes(255, 32, 32),
	Neutral = TRP3.CreateColorFromBytes(128, 128, 255),
	Business = TRP3.CreateColorFromBytes(255, 255, 0),
	Love = TRP3.CreateColorFromBytes(255, 192, 203),
	Family = TRP3.CreateColorFromBytes(255, 192, 0),
	Friend = TRP3.CreateColorFromBytes(25, 255, 25),
};

-- Power colors (See: https://warcraft.wiki.gg/wiki/Power_colors)
TRP3.PowerTypeColors =
{
	AmmoSlot = TRP3.CreateColorFromBytes(204, 153, 0),
	ArcaneCharges = TRP3.CreateColorFromBytes(26, 26, 250),
	Chi = TRP3.CreateColorFromBytes(181, 255, 235),
	ComboPoints = TRP3.CreateColorFromBytes(255, 245, 105),
	Energy = TRP3.CreateColorFromBytes(255, 255, 0),
	Focus = TRP3.CreateColorFromBytes(255, 128, 64),
	Fuel = TRP3.CreateColorFromBytes(0, 140, 128),
	Fury = TRP3.CreateColorFromBytes(201, 66, 253),
	HolyPower = TRP3.CreateColorFromBytes(242, 230, 153),
	Insanity = TRP3.CreateColorFromBytes(102, 0, 204),
	LunarPower = TRP3.CreateColorFromBytes(77, 133, 230),
	Maelstrom = TRP3.CreateColorFromBytes(0, 128, 255),
	Mana = TRP3.CreateColorFromBytes(0, 0, 255),
	Pain = TRP3.CreateColorFromBytes(255, 156, 0),
	Rage = TRP3.CreateColorFromBytes(255, 0, 0),
	Runes = TRP3.CreateColorFromBytes(128, 128, 128),
	RunicPower = TRP3.CreateColorFromBytes(0, 209, 255),
	SoulShards = TRP3.CreateColorFromBytes(128, 82, 105),
	StaggerHeavy = TRP3.CreateColorFromBytes(255, 107, 107),
	StaggerLight = TRP3.CreateColorFromBytes(133, 255, 133),
	StaggerMedium = TRP3.CreateColorFromBytes(255, 250, 184),
};

-- Misc. colors.
TRP3.MiscColors =
{
	BattleNet = TRP3.CreateColorFromTable(BATTLENET_FONT_COLOR),
	CraftingReagent = TRP3.CreateColorFromBytes(102, 187, 255),
	Disabled = TRP3.CreateColorFromTable(DISABLED_FONT_COLOR),
	Highlight = TRP3.CreateColorFromTable(HIGHLIGHT_FONT_COLOR),
	Link = TRP3.CreateColorFromTable(LINK_FONT_COLOR or { r = 0.4, g = 0.73, b = 1 }),
	Normal = TRP3.CreateColorFromTable(NORMAL_FONT_COLOR),
	Transmogrify = TRP3.CreateColorFromTable(TRANSMOGRIFY_FONT_COLOR),
	Warning = TRP3.CreateColorFromTable(WARNING_FONT_COLOR or { r = 1, g = 0.28, b = 0 }),

	PersonalityTraitColorLeft = TRP3.CreateColor(1, 0.76, 0.42),
	PersonalityTraitColorRight = TRP3.CreateColor(0.42, 0.65, 1),
};

-- Mapping of named colors. Colors in this table are available to markup and
-- may differ from those in the standard Colors table. These must be defined
-- with uppercase keys.
TRP3.NamedColors =
{
	-- CSS named colors (see: https://developer.mozilla.org/en-US/docs/Web/CSS/named-color)
	ALICEBLUE = TRP3.CreateColorFromBytes(240, 248, 255),
	ANTIQUEWHITE = TRP3.CreateColorFromBytes(250, 235, 215),
	AQUA = TRP3.CreateColorFromBytes(0, 255, 255),
	AQUAMARINE = TRP3.CreateColorFromBytes(127, 255, 212),
	AZURE = TRP3.CreateColorFromBytes(240, 255, 255),
	BEIGE = TRP3.CreateColorFromBytes(245, 245, 220),
	BISQUE = TRP3.CreateColorFromBytes(255, 228, 196),
	BLACK = TRP3.CreateColorFromBytes(0, 0, 0),
	BLANCHEDALMOND = TRP3.CreateColorFromBytes(255, 235, 205),
	BLUE = TRP3.CreateColorFromBytes(0, 0, 255),
	BLUEVIOLET = TRP3.CreateColorFromBytes(138, 43, 226),
	BROWN = TRP3.CreateColorFromBytes(165, 42, 42),
	BURLYWOOD = TRP3.CreateColorFromBytes(222, 184, 135),
	CADETBLUE = TRP3.CreateColorFromBytes(95, 158, 160),
	CHARTREUSE = TRP3.CreateColorFromBytes(127, 255, 0),
	CHOCOLATE = TRP3.CreateColorFromBytes(210, 105, 30),
	CORAL = TRP3.CreateColorFromBytes(255, 127, 80),
	CORNFLOWERBLUE = TRP3.CreateColorFromBytes(100, 149, 237),
	CORNSILK = TRP3.CreateColorFromBytes(255, 248, 220),
	CRIMSON = TRP3.CreateColorFromBytes(220, 20, 60),
	CYAN = TRP3.CreateColorFromBytes(0, 255, 255),
	DARKBLUE = TRP3.CreateColorFromBytes(0, 0, 139),
	DARKCYAN = TRP3.CreateColorFromBytes(0, 139, 139),
	DARKGOLDENROD = TRP3.CreateColorFromBytes(184, 134, 11),
	DARKGRAY = TRP3.CreateColorFromBytes(169, 169, 169),
	DARKGREEN = TRP3.CreateColorFromBytes(0, 100, 0),
	DARKGREY = TRP3.CreateColorFromBytes(169, 169, 169),
	DARKKHAKI = TRP3.CreateColorFromBytes(189, 183, 107),
	DARKMAGENTA = TRP3.CreateColorFromBytes(139, 0, 139),
	DARKOLIVEGREEN = TRP3.CreateColorFromBytes(85, 107, 47),
	DARKORANGE = TRP3.CreateColorFromBytes(255, 140, 0),
	DARKORCHID = TRP3.CreateColorFromBytes(153, 50, 204),
	DARKRED = TRP3.CreateColorFromBytes(139, 0, 0),
	DARKSALMON = TRP3.CreateColorFromBytes(233, 150, 122),
	DARKSEAGREEN = TRP3.CreateColorFromBytes(143, 188, 143),
	DARKSLATEBLUE = TRP3.CreateColorFromBytes(72, 61, 139),
	DARKSLATEGRAY = TRP3.CreateColorFromBytes(47, 79, 79),
	DARKSLATEGREY = TRP3.CreateColorFromBytes(47, 79, 79),
	DARKTURQUOISE = TRP3.CreateColorFromBytes(0, 206, 209),
	DARKVIOLET = TRP3.CreateColorFromBytes(148, 0, 211),
	DEEPPINK = TRP3.CreateColorFromBytes(255, 20, 147),
	DEEPSKYBLUE = TRP3.CreateColorFromBytes(0, 191, 255),
	DIMGRAY = TRP3.CreateColorFromBytes(105, 105, 105),
	DIMGREY = TRP3.CreateColorFromBytes(105, 105, 105),
	DODGERBLUE = TRP3.CreateColorFromBytes(30, 144, 255),
	FIREBRICK = TRP3.CreateColorFromBytes(178, 34, 34),
	FLORALWHITE = TRP3.CreateColorFromBytes(255, 250, 240),
	FORESTGREEN = TRP3.CreateColorFromBytes(34, 139, 34),
	FUCHSIA = TRP3.CreateColorFromBytes(255, 0, 255),
	GAINSBORO = TRP3.CreateColorFromBytes(220, 220, 220),
	GHOSTWHITE = TRP3.CreateColorFromBytes(248, 248, 255),
	GOLD = TRP3.CreateColorFromBytes(255, 215, 0),
	GOLDENROD = TRP3.CreateColorFromBytes(218, 165, 32),
	GRAY = TRP3.CreateColorFromBytes(128, 128, 128),
	GREEN = TRP3.CreateColorFromBytes(0, 128, 0),
	GREENYELLOW = TRP3.CreateColorFromBytes(173, 255, 47),
	GREY = TRP3.CreateColorFromBytes(128, 128, 128),
	HONEYDEW = TRP3.CreateColorFromBytes(240, 255, 240),
	HOTPINK = TRP3.CreateColorFromBytes(255, 105, 180),
	INDIANRED = TRP3.CreateColorFromBytes(205, 92, 92),
	INDIGO = TRP3.CreateColorFromBytes(75, 0, 130),
	IVORY = TRP3.CreateColorFromBytes(255, 255, 240),
	KHAKI = TRP3.CreateColorFromBytes(240, 230, 140),
	LAVENDER = TRP3.CreateColorFromBytes(230, 230, 250),
	LAVENDERBLUSH = TRP3.CreateColorFromBytes(255, 240, 245),
	LAWNGREEN = TRP3.CreateColorFromBytes(124, 252, 0),
	LEMONCHIFFON = TRP3.CreateColorFromBytes(255, 250, 205),
	LIGHTBLUE = TRP3.CreateColorFromBytes(173, 216, 230),
	LIGHTCORAL = TRP3.CreateColorFromBytes(240, 128, 128),
	LIGHTCYAN = TRP3.CreateColorFromBytes(224, 255, 255),
	LIGHTGOLDENRODYELLOW = TRP3.CreateColorFromBytes(250, 250, 210),
	LIGHTGRAY = TRP3.CreateColorFromBytes(211, 211, 211),
	LIGHTGREEN = TRP3.CreateColorFromBytes(144, 238, 144),
	LIGHTGREY = TRP3.CreateColorFromBytes(211, 211, 211),
	LIGHTPINK = TRP3.CreateColorFromBytes(255, 182, 193),
	LIGHTSALMON = TRP3.CreateColorFromBytes(255, 160, 122),
	LIGHTSEAGREEN = TRP3.CreateColorFromBytes(32, 178, 170),
	LIGHTSKYBLUE = TRP3.CreateColorFromBytes(135, 206, 250),
	LIGHTSLATEGRAY = TRP3.CreateColorFromBytes(119, 136, 153),
	LIGHTSLATEGREY = TRP3.CreateColorFromBytes(119, 136, 153),
	LIGHTSTEELBLUE = TRP3.CreateColorFromBytes(176, 196, 222),
	LIGHTYELLOW = TRP3.CreateColorFromBytes(255, 255, 224),
	LIME = TRP3.CreateColorFromBytes(0, 255, 0),
	LIMEGREEN = TRP3.CreateColorFromBytes(50, 205, 50),
	LINEN = TRP3.CreateColorFromBytes(250, 240, 230),
	MAGENTA = TRP3.CreateColorFromBytes(255, 0, 255),
	MAROON = TRP3.CreateColorFromBytes(128, 0, 0),
	MEDIUMAQUAMARINE = TRP3.CreateColorFromBytes(102, 205, 170),
	MEDIUMBLUE = TRP3.CreateColorFromBytes(0, 0, 205),
	MEDIUMORCHID = TRP3.CreateColorFromBytes(186, 85, 211),
	MEDIUMPURPLE = TRP3.CreateColorFromBytes(147, 112, 219),
	MEDIUMSEAGREEN = TRP3.CreateColorFromBytes(60, 179, 113),
	MEDIUMSLATEBLUE = TRP3.CreateColorFromBytes(123, 104, 238),
	MEDIUMSPRINGGREEN = TRP3.CreateColorFromBytes(0, 250, 154),
	MEDIUMTURQUOISE = TRP3.CreateColorFromBytes(72, 209, 204),
	MEDIUMVIOLETRED = TRP3.CreateColorFromBytes(199, 21, 133),
	MIDNIGHTBLUE = TRP3.CreateColorFromBytes(25, 25, 112),
	MINTCREAM = TRP3.CreateColorFromBytes(245, 255, 250),
	MISTYROSE = TRP3.CreateColorFromBytes(255, 228, 225),
	MOCCASIN = TRP3.CreateColorFromBytes(255, 228, 181),
	NAVAJOWHITE = TRP3.CreateColorFromBytes(255, 222, 173),
	NAVY = TRP3.CreateColorFromBytes(0, 0, 128),
	OLDLACE = TRP3.CreateColorFromBytes(253, 245, 230),
	OLIVE = TRP3.CreateColorFromBytes(128, 128, 0),
	OLIVEDRAB = TRP3.CreateColorFromBytes(107, 142, 35),
	ORANGE = TRP3.CreateColorFromBytes(255, 165, 0),
	ORANGERED = TRP3.CreateColorFromBytes(255, 69, 0),
	ORCHID = TRP3.CreateColorFromBytes(218, 112, 214),
	PALEGOLDENROD = TRP3.CreateColorFromBytes(238, 232, 170),
	PALEGREEN = TRP3.CreateColorFromBytes(152, 251, 152),
	PALETURQUOISE = TRP3.CreateColorFromBytes(175, 238, 238),
	PALEVIOLETRED = TRP3.CreateColorFromBytes(219, 112, 147),
	PAPAYAWHIP = TRP3.CreateColorFromBytes(255, 239, 213),
	PEACHPUFF = TRP3.CreateColorFromBytes(255, 218, 185),
	PERU = TRP3.CreateColorFromBytes(205, 133, 63),
	PINK = TRP3.CreateColorFromBytes(255, 192, 203),
	PLUM = TRP3.CreateColorFromBytes(221, 160, 221),
	POWDERBLUE = TRP3.CreateColorFromBytes(176, 224, 230),
	PURPLE = TRP3.CreateColorFromBytes(128, 0, 128),
	REBECCAPURPLE = TRP3.CreateColorFromBytes(102, 51, 153),
	RED = TRP3.CreateColorFromBytes(255, 0, 0),
	ROSYBROWN = TRP3.CreateColorFromBytes(188, 143, 143),
	ROYALBLUE = TRP3.CreateColorFromBytes(65, 105, 225),
	SADDLEBROWN = TRP3.CreateColorFromBytes(139, 69, 19),
	SALMON = TRP3.CreateColorFromBytes(250, 128, 114),
	SANDYBROWN = TRP3.CreateColorFromBytes(244, 164, 96),
	SEAGREEN = TRP3.CreateColorFromBytes(46, 139, 87),
	SEASHELL = TRP3.CreateColorFromBytes(255, 245, 238),
	SIENNA = TRP3.CreateColorFromBytes(160, 82, 45),
	SILVER = TRP3.CreateColorFromBytes(192, 192, 192),
	SKYBLUE = TRP3.CreateColorFromBytes(135, 206, 235),
	SLATEBLUE = TRP3.CreateColorFromBytes(106, 90, 205),
	SLATEGRAY = TRP3.CreateColorFromBytes(112, 128, 144),
	SLATEGREY = TRP3.CreateColorFromBytes(112, 128, 144),
	SNOW = TRP3.CreateColorFromBytes(255, 250, 250),
	SPRINGGREEN = TRP3.CreateColorFromBytes(0, 255, 127),
	STEELBLUE = TRP3.CreateColorFromBytes(70, 130, 180),
	TAN = TRP3.CreateColorFromBytes(210, 180, 140),
	TEAL = TRP3.CreateColorFromBytes(0, 128, 128),
	THISTLE = TRP3.CreateColorFromBytes(216, 191, 216),
	TOMATO = TRP3.CreateColorFromBytes(255, 99, 71),
	TRANSPARENT = TRP3.CreateColorFromBytes(0, 0, 0, 0),
	TURQUOISE = TRP3.CreateColorFromBytes(64, 224, 208),
	VIOLET = TRP3.CreateColorFromBytes(238, 130, 238),
	WHEAT = TRP3.CreateColorFromBytes(245, 222, 179),
	WHITE = TRP3.CreateColorFromBytes(255, 255, 255),
	WHITESMOKE = TRP3.CreateColorFromBytes(245, 245, 245),
	YELLOW = TRP3.CreateColorFromBytes(255, 255, 0),
	YELLOWGREEN = TRP3.CreateColorFromBytes(154, 205, 50),

	-- Shorthand color aliases (backwards compatibility)
	["0"] = TRP3.CreateColorFromBytes(0, 0, 0),    -- Black
	B = TRP3.CreateColorFromBytes(0, 0, 255),      -- Blue
	C = TRP3.CreateColorFromBytes(0, 255, 255),    -- Cyan
	G = TRP3.CreateColorFromBytes(0, 128, 0),      -- Green
	O = TRP3.CreateColorFromBytes(255, 165, 0),    -- Orange
	P = TRP3.CreateColorFromBytes(128, 0, 128),    -- Purple
	R = TRP3.CreateColorFromBytes(255, 0, 0),      -- Red
	W = TRP3.CreateColorFromBytes(255, 255, 255),  -- White
	Y = TRP3.CreateColorFromBytes(255, 255, 0),    -- Yellow

	-- Class colors
	DEATHKNIGHT = TRP3.ClassColors.DEATHKNIGHT,
	DEMONHUNTER = TRP3.ClassColors.DEMONHUNTER,
	DRUID = TRP3.ClassColors.DRUID,
	EVOKER = TRP3.ClassColors.EVOKER,
	HUNTER = TRP3.ClassColors.HUNTER,
	MAGE = TRP3.ClassColors.MAGE,
	MONK = TRP3.ClassColors.MONK,
	PALADIN = TRP3.ClassColors.PALADIN,
	PRIEST = TRP3.ClassColors.PRIEST,
	ROGUE = TRP3.ClassColors.ROGUE,
	SHAMAN = TRP3.ClassColors.SHAMAN,
	WARLOCK = TRP3.ClassColors.WARLOCK,
	WARRIOR = TRP3.ClassColors.WARRIOR,

	-- Item quality colors
	ARTIFACT = TRP3.ItemQualityColors.Artifact,
	COMMON = TRP3.ItemQualityColors.Common,
	EPIC = TRP3.ItemQualityColors.Epic,
	HEIRLOOM = TRP3.ItemQualityColors.Heirloom,
	LEGENDARY = TRP3.ItemQualityColors.Legendary,
	POOR = TRP3.ItemQualityColors.Poor,
	RARE = TRP3.ItemQualityColors.Rare,
	UNCOMMON = TRP3.ItemQualityColors.Uncommon,

	-- Faction colors
	ALLIANCE = TRP3.FactionColors.Alliance,
	HORDE = TRP3.FactionColors.Horde,
};

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

require("Environment.GameAPI");

ColorMixin = {};

BATTLENET_FONT_COLOR = Mixin({ r = 0.2, g = 0.8, b = 1, a = 1 }, ColorMixin);
DISABLED_FONT_COLOR = Mixin({ r = 0.5, g = 0.5, b = 0.5, a = 1 }, ColorMixin);
HIGHLIGHT_FONT_COLOR = Mixin({ r = 1, g = 1, b = 1, a = 1 }, ColorMixin);
ITEM_ARTIFACT_COLOR = Mixin({ r = 0.9, g = 0.8, b = 0.5, a = 1 }, ColorMixin);
ITEM_EPIC_COLOR = Mixin({ r = 0.64, g = 0.21, b = 0.93, a = 1 }, ColorMixin);
ITEM_GOOD_COLOR = Mixin({ r = 0.12, g = 1, b = 0, a = 1 }, ColorMixin);
ITEM_LEGENDARY_COLOR = Mixin({ r = 1, g = 0.5, b = 0, a = 1 }, ColorMixin);
ITEM_POOR_COLOR = Mixin({ r = 0.62, g = 0.62, b = 0.62, a = 1 }, ColorMixin);
ITEM_STANDARD_COLOR = Mixin({ r = 1, g = 1, b = 1, a = 1 }, ColorMixin);
ITEM_SUPERIOR_COLOR = Mixin({ r = 0, g = 0.44, b = 0.87, a = 1 }, ColorMixin);
ITEM_WOW_TOKEN_COLOR = Mixin({ r = 0, g = 0.8, b = 1, a = 1 }, ColorMixin);
LINK_FONT_COLOR = Mixin({ r = 0.4, g = 0.73, b = 1, a = 1 }, ColorMixin);
NORMAL_FONT_COLOR = Mixin({ r = 1, g = 1, b = 1, a = 1 }, ColorMixin);
PLAYER_FACTION_COLOR_ALLIANCE = Mixin({ r = 0.25, g = 0.31, b = 0.9, a = 1 }, ColorMixin);
PLAYER_FACTION_COLOR_HORDE = Mixin({ r = 0.9, g = 0.05, b = 0.07, a = 1 }, ColorMixin);
TRANSMOGRIFY_FONT_COLOR = Mixin({ r = 1, g = 0.5, b = 0, a = 1 }, ColorMixin);
WARNING_FONT_COLOR = Mixin({ r = 1, g = 0.28, b = 0, a = 1 }, ColorMixin);

RAID_CLASS_COLORS = {
	DEATHKNIGHT = Mixin({ r = 0.768627, g = 0.117647, b = 0.227451 }, ColorMixin);
	DEMONHUNTER = Mixin({ r = 0.639216, g = 0.188235, b = 0.788235 }, ColorMixin);
	DRUID = Mixin({ r = 1, g = 0.486275, b = 0.039216 }, ColorMixin);
	EVOKER = Mixin({ r = 0.2, g = 0.576471, b = 0.498039 }, ColorMixin);
	HUNTER = Mixin({ r = 0.666667, g = 0.827451, b = 0.447059 }, ColorMixin);
	MAGE = Mixin({ r = 0.247059, g = 0.780392, b = 0.921569 }, ColorMixin);
	MONK = Mixin({ r = 0, g = 1, b = 0.596078 }, ColorMixin);
	PALADIN = Mixin({ r = 0.956863, g = 0.549020, b = 0.729412 }, ColorMixin);
	PRIEST = Mixin({ r = 1, g = 1, b = 1 }, ColorMixin);
	ROGUE = Mixin({ r = 1, g = 0.956863, b = 0.407843 }, ColorMixin);
	SHAMAN = Mixin({ r = 0, g = 0.439216, b = 0.866667 }, ColorMixin);
	WARLOCK = Mixin({ r = 0.529412, g = 0.533333, b = 0.933333 }, ColorMixin);
	WARRIOR = Mixin({ r = 0.776471, g = 0.607843, b = 0.427451 }, ColorMixin);
};

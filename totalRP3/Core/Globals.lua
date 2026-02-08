-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local race_loc, race = UnitRace("player");
local class_loc, class, class_index = UnitClass("player");
local faction, faction_loc = UnitFactionGroup("player");

local Player = TRP3.Player.GetCurrentUser();

local currentDate = date("*t");

-- Public accessor
TRP3.r = {};
TRP3.formats = {
	dropDownElements = "%s: |cff00ff00%s"
};
TRP3.globals = {
	--@debug@
	DEBUG_MODE = true,
	--@end-debug@

	--[===[@non-debug@
	DEBUG_MODE = false,
	--@end-non-debug@]===]

	empty = {},

	addon_name = "Total RP 3",
	addon_name_extended = "TRP3: Extended",
	addon_name_short = "TRP3",
	addon_name_me = "Total RP 3",
	addon_id_length = 15,

	version = 152,

	--@debug@
	version_display = "-dev",
	--@end-debug@

	--[===[@non-debug@
	version_display = "@project-version@",
	--@end-non-debug@]===]


	player = UnitNameUnmodified("player"),
	player_realm = GetRealmName(),
	player_race_loc = race_loc,
	player_class_loc = class_loc,
	player_faction_loc = faction_loc,
	player_class_index = class_index,
	player_character = {
		race = race,
		class = class,
		faction = faction
	},
	is_trial_account = Player:GetAccountType(),
	clients = {
		TRP3 = "trp3",
		MSP = "msp",
	},

	serious_day = currentDate.month == 4 and currentDate.day == 1,

	-- Profile Constants
	PSYCHO_DEFAULT_VALUE_V2 = 10,
	PSYCHO_MAX_VALUE_V2 = 20,
};

TRP3_ClientFeatures = {
	ChannelBroadcasts = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE),
	WarMode = (LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_BATTLE_FOR_AZEROTH),
	Transmogrification = (LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_WRATH_OF_THE_LICH_KING),
	WaterElementalWorkaround = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE),
	OldTooltipAPI = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE),
};

TRP3_OOCIndicatorStyle = {
	-- The constants here are chosen for backwards compatibility with our
	-- existing settings which used the strings "ICON" and "TEXT".
	Icon = "ICON",
	Text = "TEXT",
};

local emptyMeta = {
	__newindex = function(_, _, _) end
};
setmetatable(TRP3.globals.empty, emptyMeta);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Globals build
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3.globals.build = function()
	local fullName = UnitNameUnmodified("player");
	local realm = GetRealmName():gsub("[%s%-%.]*", "");
	TRP3.globals.player_realm_id = realm;
	TRP3.globals.player_id = fullName .. "-" .. realm;
	TRP3.globals.player_icon = TRP3.ui.misc.getUnitTexture(race, UnitSex("player"));
end

TRP3.globals.addon = TRP3_Addon;

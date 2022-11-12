-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

local race_loc, race = UnitRace("player");
local class_loc, class, class_index = UnitClass("player");
local faction, faction_loc = UnitFactionGroup("player");

local Player = AddOn_TotalRP3.Player.GetCurrentUser();

local currentDate = date("*t");

-- Public accessor
TRP3_API.r = {};
TRP3_API.formats = {
	dropDownElements = "%s: |cff00ff00%s"
};
TRP3_API.globals = {
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

	version = 108,

	--@debug@
	version_display = "-dev",
	--@end-debug@

	--[===[@non-debug@
	version_display = "@project-version@",
	--@end-non-debug@]===]


	player = UnitName("player"),
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
	PSYCHO_DEFAULT_VALUE_V1 = 3,
	PSYCHO_MAX_VALUE_V1 = 6,
	PSYCHO_DEFAULT_VALUE_V2 = 10,
	PSYCHO_MAX_VALUE_V2 = 20,
	PSYCHO_DEFAULT_LEFT_COLOR = Ellyb.Color.CreateFromRGBAAsBytes(255, 140, 26):Freeze(),
	PSYCHO_DEFAULT_RIGHT_COLOR = Ellyb.Color.CreateFromRGBAAsBytes(32, 208, 249):Freeze(),
};

-- TODO: Expansion constants are temporary and can be cleaned up once the next
--       Classic Era patch (1.14.4+/1.15.0) goes live.

local TRP3_EXPANSION_CATACLYSM = LE_EXPANSION_CATACLYSM or 3;
local TRP3_EXPANSION_BATTLE_FOR_AZEROTH = LE_EXPANSION_BATTLE_FOR_AZEROTH or 7;

TRP3_BroadcastMethod = {
	Channel = 1,
	Yell = 2,
};

TRP3_ClientFeatures = {
	BroadcastMethod = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE and TRP3_BroadcastMethod.Yell or TRP3_BroadcastMethod.Channel),
	WarMode = (LE_EXPANSION_LEVEL_CURRENT >= TRP3_EXPANSION_BATTLE_FOR_AZEROTH),
	Transmogrification = (LE_EXPANSION_LEVEL_CURRENT >= TRP3_EXPANSION_CATACLYSM),
	WaterElementalWorkaround = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE),
};

--- RELATIONS is a list of (backwards-compatible) relationship IDs.
local RELATIONS = {
	UNFRIENDLY = "UNFRIENDLY",
	NONE = "NONE",
	NEUTRAL = "NEUTRAL",
	BUSINESS = "BUSINESS",
	FRIEND = "FRIEND",
	LOVE = "LOVE",
	FAMILY = "FAMILY",
};
TRP3_API.globals.RELATIONS = RELATIONS;

--- RELATIONS_ORDER defines a logical ordering for relations.
local RELATIONS_ORDER = {
	[RELATIONS.NONE] = 6,
	[RELATIONS.UNFRIENDLY] = 5,
	[RELATIONS.NEUTRAL] = 4,
	[RELATIONS.BUSINESS] = 3,
	[RELATIONS.FRIEND] = 2,
	[RELATIONS.LOVE] = 1,
	[RELATIONS.FAMILY] = 0,
};
TRP3_API.globals.RELATIONS_ORDER = RELATIONS_ORDER;

local emptyMeta = {
	__newindex = function(_, _, _) end
};
setmetatable(TRP3_API.globals.empty, emptyMeta);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Globals build
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.globals.build = function()
	local fullName = UnitName("player");
	local realm = GetRealmName():gsub("[%s*%-*]", "");
	TRP3_API.globals.player_realm_id = realm;
	TRP3_API.globals.player_id = fullName .. "-" .. realm;
	TRP3_API.globals.player_icon = TRP3_API.ui.misc.getUnitTexture(race, UnitSex("player"));

	-- Build BNet account Hash
	local bn = select(2, BNGetInfo());
	if bn then
		TRP3_API.globals.player_hash = TRP3_API.utils.serial.hashCode(bn);
	else
		-- Trial account ..etc.
		TRP3_API.globals.player_hash = TRP3_API.utils.serial.hashCode(TRP3_API.globals.player_id);
	end
end

TRP3_Addon = LibStub("AceAddon-3.0"):NewAddon("TRP3");
TRP3_API.globals.addon = TRP3_Addon;

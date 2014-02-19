--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Global variables
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local race_loc, race = UnitRace("player");
local class_loc, class, class_index = UnitClass("player");
local fullName, realm = UnitFullName("player");

-- Public accessor
TRP3_GLOBALS = {

	addon_name = "Total RP 3",
	addon_name_short = "TRP3",
	addon_name_alt = "TotalRP3",
	addon_id_length = 15,
	
	version = 1,
	version_display = "0.1-SNAPSHOT",
	
	player = UnitName("player"),
	player_realm = GetRealmName(),
	player_realm_id = realm;
	player_id = fullName .. "-" .. realm,
	player_race_loc = race_loc,
	player_class_loc = class_loc,
	player_class_index = class_index,
	player_character = {
		race = race,
		class = class
	},
	
	clients = {
		TRP3 = "trp3",
		MSP = "msp",
	},
	
	icons = {
		default = "TEMP";
		unknown = "INV_Misc_QuestionMark";
		profile_default = "INV_Misc_GroupLooking";
	},
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Libs management
-- AceSerializer is used for the communication serialization/dezerialization
-- AceCommand is used for TRP3 console commands handling
-- AceTimer is used for handling some generic timers
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
TRP3_GLOBALS.addon = LibStub("AceAddon-3.0"):NewAddon(TRP3_GLOBALS.addon_name, "AceSerializer-3.0", "AceConsole-3.0", "AceTimer-3.0");

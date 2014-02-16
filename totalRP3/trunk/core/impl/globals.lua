--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Global variables
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local race_loc, race = UnitRace("player");
local class_loc, class, class_index = UnitClass("player");

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
	player_id = GetRealmName()..'|'..UnitName("player"),
	player_race_loc = race_loc,
	player_race = race,
	player_class_loc = class_loc,
	player_class = class,
	player_class_index = class_index,
	
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
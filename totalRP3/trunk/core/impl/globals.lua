--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Global variables
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local race_loc, race = UnitRace("player");
local class_loc, class, class_index = UnitClass("player");

-- Public accessor
TRP3_API = {
	globals = {
		empty = {},

		addon_name = "Total RP 3",
		addon_name_short = "TRP3",
		addon_name_alt = "TotalRP3",
		addon_id_length = 15,

		version = 3,
		version_display = "0.2-SNAPSHOT",

		player = UnitName("player"),
		player_realm = GetRealmName(),
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
			default = "TEMP",
			unknown = "INV_Misc_QuestionMark",
			profile_default = "INV_Misc_GroupLooking",
		},
	}
}

TRP3_API.globals.build = function()
	local fullName, realm = UnitFullName("player");
	assert(realm, "Cannot have realm name information !");
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

TRP3_API.globals.addon = LibStub("AceAddon-3.0"):NewAddon(TRP3_API.globals.addon_name);
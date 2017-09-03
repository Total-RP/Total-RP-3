----------------------------------------------------------------------------------
-- Total RP 3
-- Global variables
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--	Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

local race_loc, race = UnitRace("player");
local class_loc, class, class_index = UnitClass("player");
local faction, faction_loc = UnitFactionGroup("player");

-- Public accessor
TRP3_API = {
	r = {},
	formats = {
		dropDownElements = "%s: |cff00ff00%s"
	},
	globals = {
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

		version = 32,

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

local emptyMeta = {
	__newindex = function(_, _, _) end
};
setmetatable(TRP3_API.globals.empty, emptyMeta);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Globals build
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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

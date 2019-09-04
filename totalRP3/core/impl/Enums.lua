----------------------------------------------------------------------------------
--- Total RP 3
--- Enuls
--- ---------------------------------------------------------------------------
--- Copyright 2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
--
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
--
--- 	http://www.apache.org/licenses/LICENSE-2.0
--
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

AddOn_TotalRP3.Enums = {};

AddOn_TotalRP3.Enums.ACCOUNT_TYPE = {
	REGULAR = 0,
	TRIAL = 1,
	VETERAN = 2
}

AddOn_TotalRP3.Enums.RELATIONSHIP_STATUS = {
	UNKNOWN = 0,
	SINGLE = 1,
	TAKEN = 2,
	MARRIED = 3,
	DIVORCED = 4,
	WIDOWED = 5,
}

-- ROLEPLAY_STATUS is an enumeration of roleplay statuses for a player unit.
AddOn_TotalRP3.Enums.ROLEPLAY_STATUS = {
	IN_CHARACTER = 1,
	OUT_OF_CHARACTER = 2,
};

-- ROLEPLAY_EXPERIENCE is an enumeration of roleplay experience entries for
-- a player, for example "beginner roleplayer".
AddOn_TotalRP3.Enums.ROLEPLAY_EXPERIENCE = {
	BEGINNER = 1,
	EXPERIENCED = 2,
	VOLUNTEER = 3,
};

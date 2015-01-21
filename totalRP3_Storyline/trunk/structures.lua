----------------------------------------------------------------------------------
-- Total RP 3
-- Storyline module
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

-- 193 : levitate
-- 195 : tchou
-- 225 : aaaaaaaah !
-- 520 : read

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Animation duration
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_ANIMATION_SEQUENCE_DURATION = {
	["64"] = 3000, -- huh !
	["65"] = 3000, -- huh ?
	["60"] = 4000, -- blabla
	["185"] = 2000, -- Yep !
	["186"] = 2000, -- Nope !
	["0"] = 1000,
}
local TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL = {
	-- DWARF
	["character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		["64"] = 1800, -- huh !
		["65"] = 1800, -- huh ?
		["60"] = 2000, -- blabla
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		["60"] = 1900,
	},
	-- WORGEN
	["character\\worgen\\male\\worgenmale.m2"] = {
		["65"] = 4000,
	},
	["character\\worgen\\female\\worgenfemale.m2"] = {
		["64"] = 2700,
		["65"] = 4500,
	},
	-- GNOMES
	["character\\gnome\\male\\gnomemale_hd.m2"] = {
		["64"] = 1800, -- huh !
		["65"] = 2250, -- huh ?
		["60"] = 3900, -- blabla
	},
	["character\\gnome\\female\\gnomefemale_hd.m2"] = {
		["64"] = 1850, -- huh !
		["65"] = 2250, -- huh ?
		["60"] = 3900, -- blabla
	},
	-- HUMAN
	["character\\human\\male\\humanmale_hd.m2"] = {
		["64"] = 1800, -- huh !
		["65"] = 1800, -- huh ?
		["60"] = 2000, -- blabla
	},
	["character\\human\\female\\humanfemale_hd.m2"] = {
		["64"] = 1800, -- huh !
		["65"] = 1800, -- huh ?
		["60"] = 2650, -- blabla
	},
	-- DRAENEI
	["character\\draenei\\female\\draeneifemale_hd.m2"] = {
		["60"] = 2850, -- blabla
	},
	["character\\draenei\\male\\draeneimale_hd.m2"] = {
		["60"] = 3200, -- blabla
		["65"] = 1850, -- huh ?
	},
	-- PANDAREN
	["character\\pandaren\\female\\pandarenfemale.m2"] = {
		["60"] = 3000, -- blabla
	},
	-- NIGHT ELVES
	["character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		["64"] = 2000, -- huh !
		["65"] = 1600, -- huh ?
		["60"] = 1900, -- blabla
	},
	["character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["60"] = 1900, -- blabla
	},
	-- ARRAKOA
	["creature\\arakkoaoutland\\arakkoaoutland.m2"] = {
		["60"] = 1700, -- blabla
	},
	["creature\\arakkoa2\\arakkoa2.m2"] = {
		["60"] = 4300, -- blabla
	},
	-- ORCS
	["character\\orc\\female\\orcfemale_hd.m2"] = {
		["64"] = 2000, -- huh !
		["65"] = 1600, -- huh ?
		["60"] = 1900, -- blabla
	},
	["character\\orc\\male\\orcmale_hd.m2"] = {
		["64"] = 2000, -- huh !
		["65"] = 1600, -- huh ?
		["60"] = 1900, -- blabla
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Animation mapping
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_DEFAULT_ANIM_MAPPING = {
	["!"] = 64,
	["?"] = 65,
	["."] = 60,
}
local ALL_TO_TALK = {
	["!"] = 60,
	["?"] = 60,
}
local ALL_TO_NONE = {
	["!"] = 0,
	["?"] = 0,
	["."] = 0,
}
local TRP3_ANIM_MAPPING = {
	["character\\worgen\\male\\worgenmale.m2"] = {
		["."] = 64,
	},
}
TRP3_ANIM_MAPPING["creature\\humanfemalekid\\humanfemalekid.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\humanmalekid\\humanmalekid.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\draeneifemalekid\\draeneifemalekid.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\golemdwarven\\golemdwarven.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\ridinghorse\\packmule.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\rabbit\\rabbit.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\naaru\\naaru.m2"] = ALL_TO_NONE;
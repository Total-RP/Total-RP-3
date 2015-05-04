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

local EXCLAME_ID = "64";
local QUESTION_ID = "65";
local TALK_ID = "60";
local YES_ID = "185";
local NOPE_ID = "186";

TRP3_ANIMATION_SEQUENCE_DURATION = {
	[EXCLAME_ID] = 3.000,
	[QUESTION_ID] = 3.000,
	[TALK_ID] = 4.000,
	[YES_ID] = 2.000,
	[NOPE_ID] = 2.000,
	["0"] = 1.500,
}

TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL = {
	-- DWARF
	["character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.000,
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		[TALK_ID] = 1.900,
	},
	-- WORGEN
	["character\\worgen\\male\\worgenmale.m2"] = {
		[QUESTION_ID] = 4.000,
	},
	["character\\worgen\\female\\worgenfemale.m2"] = {
		[EXCLAME_ID] = 2.700,
		[QUESTION_ID] = 4.500,
	},
	-- GNOMES
	["character\\gnome\\male\\gnomemale_hd.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 2.250,
		[TALK_ID] = 3.900,
	},
	["character\\gnome\\female\\gnomefemale_hd.m2"] = {
		[EXCLAME_ID] = 1.850,
		[QUESTION_ID] = 2.250,
		[TALK_ID] = 3.900,
	},
	-- HUMAN
	["character\\human\\male\\humanmale_hd.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.000,
	},
	["character\\human\\female\\humanfemale_hd.m2"] = {
		[EXCLAME_ID] = 2.500,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.650,
	},
	-- DRAENEI
	["character\\draenei\\female\\draeneifemale_hd.m2"] = {
		[TALK_ID] = 2.850,
		[QUESTION_ID] = 1.850,
		[EXCLAME_ID] = 2.000,
	},
	["character\\draenei\\male\\draeneimale_hd.m2"] = {
		[TALK_ID] = 3.200,
		[QUESTION_ID] = 1.850,
	},
	-- PANDAREN
	["character\\pandaren\\female\\pandarenfemale.m2"] = {
		[TALK_ID] = 3.000,
	},
	-- NIGHT ELVES
	["character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
	},
	["character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		[TALK_ID] = 1.900,
	},
	-- ARRAKOA
	["creature\\arakkoaoutland\\arakkoaoutland.m2"] = {
		[TALK_ID] = 1.700,
	},
	["creature\\arakkoa2\\arakkoa2.m2"] = {
		[TALK_ID] = 4.300,
	},
	-- ORCS
	["character\\orc\\female\\orcfemale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
	},
	["character\\orc\\male\\orcmale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
	},
	["creature\\rexxar\\rexxar.m2"] = {
		[TALK_ID] = 2.000,
		[QUESTION_ID] = 1.600,
	},
	["creature\\khadgar2\\khadgar2.m2"] = {
		[TALK_ID] = 2.000,
	}
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Animation mapping
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_DEFAULT_ANIM_MAPPING = {
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
TRP3_ANIM_MAPPING = {};
TRP3_ANIM_MAPPING["creature\\humanfemalekid\\humanfemalekid.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\humanmalekid\\humanmalekid.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\draeneifemalekid\\draeneifemalekid.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\golemdwarven\\golemdwarven.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\ridinghorse\\packmule.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\rabbit\\rabbit.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\naaru\\naaru.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\rat\\rat.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\beholder\\beholder.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\draenorancient\\draenorancientgorgrond.m2"] = ALL_TO_NONE;
TRP3_ANIM_MAPPING["creature\\arakkoa2\\arakkoa2.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\arakkoaoutland\\arakkoaoutland.m2"] = ALL_TO_TALK;
TRP3_ANIM_MAPPING["creature\\dreadravenwarbird\\dreadravenwarbirdwind.m2"] = ALL_TO_NONE;
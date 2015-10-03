----------------------------------------------------------------------------------
--  Storyline
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--	Copyright 2015 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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
-- 195 : /train
-- 225 : /fear
-- 520 : read
-- 66 : /bow
-- 67 : /hi
-- 113 : /salute
-- 209 : /point
-- 61 : /eat
-- 63 : /use
-- 68 : /acclame

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Animation duration
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local EXCLAME_ID = "64";
local QUESTION_ID = "65";
local TALK_ID = "60";
local YES_ID = "185";
local NOPE_ID = "186";
local ACLAIM_ID = "68";

Storyline_ANIMATION_SEQUENCE_DURATION = {
	[EXCLAME_ID] = 3.000,
	[QUESTION_ID] = 3.000,
	[TALK_ID] = 4.000,
	[YES_ID] = 3.000,
	[NOPE_ID] = 3.000,
	[ACLAIM_ID] = 2.400,
	["0"] = 1.500,
}

Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- OK
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- NIGHT ELVES
	["character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
		[YES_ID] = 1.9,
		[NOPE_ID] = 1.5,
		[ACLAIM_ID] = 2.4,
	},
	["character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		[TALK_ID] = 1.900,
		[EXCLAME_ID] = 1.9,
		[QUESTION_ID] = 1.900,
		[YES_ID] = 1.1,
		[NOPE_ID] = 1.3,
		[ACLAIM_ID] = 2,
	},
	-- DWARF
	["character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.000,
		[YES_ID] = 1.9,
		[NOPE_ID] = 1.9,
		[ACLAIM_ID] = 3,
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		[TALK_ID] = 1.900,
		[EXCLAME_ID] = 2.00,
		[QUESTION_ID] = 1.800,
		[YES_ID] = 2.0,
		[NOPE_ID] = 1.9,
		[ACLAIM_ID] = 2,
	},
	-- GNOMES
	["character\\gnome\\male\\gnomemale_hd.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 2.250,
		[TALK_ID] = 3.900,
		[YES_ID] = 0.9,
		[NOPE_ID] = 1.0,
		[ACLAIM_ID] = 2.0,
	},
	["character\\gnome\\female\\gnomefemale_hd.m2"] = {
		[EXCLAME_ID] = 1.850,
		[QUESTION_ID] = 2.250,
		[TALK_ID] = 3.900,
		[YES_ID] = 0.9,
		[NOPE_ID] = 1.7, -- Multi anim ...
		[ACLAIM_ID] = 2.0,
	},
	-- HUMAN
	["character\\human\\male\\humanmale_hd.m2"] = {
		[EXCLAME_ID] = 1.800,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.000,
		[YES_ID] = 2.6,
		[NOPE_ID] = 3.2,
		[ACLAIM_ID] = 2.400,
	},
	["character\\human\\female\\humanfemale_hd.m2"] = {
		[EXCLAME_ID] = 2.700,
		[QUESTION_ID] = 1.800,
		[TALK_ID] = 2.650,
		[YES_ID] = 1.900,
		[NOPE_ID] = 1.900,
		[ACLAIM_ID] = 2.300,
	},
	-- DRAENEI
	["character\\draenei\\female\\draeneifemale_hd.m2"] = {
		[TALK_ID] = 2.850,
		[QUESTION_ID] = 1.850,
		[EXCLAME_ID] = 2.000,
		[YES_ID] = 1.9,
		[NOPE_ID] = 2,
		[ACLAIM_ID] = 2,
	},
	["character\\draenei\\male\\draeneimale_hd.m2"] = {
		[TALK_ID] = 3.200,
		[QUESTION_ID] = 1.850,
		[EXCLAME_ID] = 3.000,
		[YES_ID] = 1.3,
		[NOPE_ID] = 1.2,
		[ACLAIM_ID] = 1.8,
	},
	-- WORGEN
	["character\\worgen\\male\\worgenmale.m2"] = {
		[QUESTION_ID] = 3.7,
		[TALK_ID] = 4.000,
		[EXCLAME_ID] = 2.700,
		[YES_ID] = 1.7,
		[ACLAIM_ID] = 3.5,
		[NOPE_ID] = 1.8,
	},
	["character\\worgen\\female\\worgenfemale.m2"] = {
		[TALK_ID] = 4.000,
		[EXCLAME_ID] = 2.700,
		[QUESTION_ID] = 4.500,
		[YES_ID] = 2.55,
		[NOPE_ID] = 2.35,
		[ACLAIM_ID] = 2.4,
	},
	-- PANDAREN
	["character\\pandaren\\female\\pandarenfemale.m2"] = {
		[TALK_ID] = 3.000,
		[EXCLAME_ID] = 3,
		[QUESTION_ID] = 3.8,
		[ACLAIM_ID] = 3.200,
		[YES_ID] = 2.00,
		[NOPE_ID] = 3.50, -- Multi anim ...
	},
	["character\\pandaren\\male\\pandarenmale.m2"] = {
		[EXCLAME_ID] = 3.400,
		[QUESTION_ID] = 4.0,
		[TALK_ID] = 4.000,
		[YES_ID] = 4,
		[NOPE_ID] = 3.2,
		[ACLAIM_ID] = 2.400,
	},
	-- ORCS
	["character\\orc\\female\\orcfemale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
		[YES_ID] = 1.2,
		[NOPE_ID] = 1.3,
		[ACLAIM_ID] = 1.4,
	},
	["character\\orc\\male\\orcmale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.600,
		[TALK_ID] = 1.900,
		[YES_ID] = 1.8,
		[NOPE_ID] = 1.8,
		[ACLAIM_ID] = 2.7,
	},
	-- GOBLIN
	["character\\goblin\\male\\goblinmale.m2"] = {
		[TALK_ID] = 4.3,
		[QUESTION_ID] = 3.7,
		[EXCLAME_ID] = 2.600,
		[YES_ID] = 2.5,
		[NOPE_ID] = 2.8,
		[ACLAIM_ID] = 3.2,
	},
	["character\\goblin\\female\\goblinfemale.m2"] = {
		[TALK_ID] = 4.2,
		[QUESTION_ID] = 4.2,
		[EXCLAME_ID] = 3.5,
		[YES_ID] = 2.6,
		[NOPE_ID] = 2.5,
		[ACLAIM_ID] = 1.8,
	},
	-- Blood elves
	["character\\bloodelf\\male\\bloodelfmale_hd.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 2.00,
		[TALK_ID] = 2.000,
		["185"] = 1.3,
		["68"] = 2.1,
		["186"] = 1.3,
	},
	["character\\bloodelf\\female\\bloodelffemale_hd.m2"] = {
		["185"] = 1.4,
		["65"] = 1.4,
		["68"] = 1.5,
		["186"] = 2,
		["64"] = 2.8,
	},
	["creature\\bloodelfguard\\bloodelfmale_guard.m2"] = {
		[TALK_ID] = 2.000,
		[QUESTION_ID] = 2.00,
	},
	-- Taurene
	["character\\tauren\\female\\taurenfemale_hd.m2"] = {
		["185"] = 1.5,
		["186"] = 1.8,
		["65"] = 1.7,
		["64"] = 1.9,
		["68"] = 1.8,
	},
	["character\\tauren\\male\\taurenmale_hd.m2"] = {
		[TALK_ID] = 2.90,
		[EXCLAME_ID] = 2.0,
		[QUESTION_ID] = 1.8,
		["185"] = 1.9,
		["68"] = 1.9,
		["186"] = 2,
	},
	-- Troll
	["character\\troll\\female\\trollfemale_hd.m2"] = {
		["185"] = 1.4,
		["186"] = 1.6,
		["65"] = 1.4,
		["64"] = 2,
		["68"] = 2.1,
	},
	["character\\troll\\male\\trollmale_hd.m2"] = {
		[TALK_ID] = 2.400,
		[EXCLAME_ID] = 2.600,
		[QUESTION_ID] = 1.9,
		["185"] = 1.6,
		["68"] = 3,
		["186"] = 1.6,
	},
	-- Scourge
	["character\\scourge\\male\\scourgemale_hd.m2"] = {
		["185"] = 1.8,
		["186"] = 1.8,
		["65"] = 2,
		["64"] = 2.2,
		["68"] = 2.1,
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- NPC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	["character\\broken\\male\\brokenmale.m2"] = {
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.7,
		[TALK_ID] = 3.000,
	},
	["creature\\rexxar\\rexxar.m2"] = {
		[TALK_ID] = 2.000,
		[QUESTION_ID] = 1.600,
	},
	["creature\\khadgar2\\khadgar2.m2"] = {
		[TALK_ID] = 2.000,
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.7,
	},
	["creature\\kingvarianwrynn\\kingvarianwrynn.m2"] = {
		[TALK_ID] = 2.000,
		[EXCLAME_ID] = 2.000,
		[QUESTION_ID] = 1.5,
	},
	-- ARRAKOA
	["creature\\arakkoaoutland\\arakkoaoutland.m2"] = {
		[TALK_ID] = 1.700,
	},
	["creature\\arakkoa2\\arakkoa2.m2"] = {
		[TALK_ID] = 4.300,
	},
	["creature\\ogredraenor\\ogredraenor.m2"] = {
		[TALK_ID] = 1.9,
	},
	["creature\\agronn\\agronn.m2"] = {
		[TALK_ID] = 3.2,
	},
	["creature\\furbolg\\furbolg.m2"] = {
		[TALK_ID] = 1.9,
	},
}

Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL["creature\\jinyu\\jinyu.m2"] = Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL["character\\nightelf\\male\\nightelfmale_hd.m2"];

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Animation mapping
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Storyline_DEFAULT_ANIM_MAPPING = {
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
Storyline_ANIM_MAPPING = {};
Storyline_ANIM_MAPPING["creature\\humanfemalekid\\humanfemalekid.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\ogredraenor\\ogredraenor.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\humanmalekid\\humanmalekid.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\draeneifemalekid\\draeneifemalekid.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\golemdwarven\\golemdwarven.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\ridinghorse\\packmule.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\rabbit\\rabbit.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\naaru\\naaru.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\rat\\rat.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\beholder\\beholder.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\draenorancient\\draenorancientgorgrond.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\arakkoa2\\arakkoa2.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\arakkoaoutland\\arakkoaoutland.m2"] = ALL_TO_TALK;
Storyline_ANIM_MAPPING["creature\\dreadravenwarbird\\dreadravenwarbirdwind.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\satyr\\satyr.m2"] = ALL_TO_NONE;
Storyline_ANIM_MAPPING["creature\\furbolg\\furbolg.m2"] = ALL_TO_TALK;

Storyline_SCALE_MAPPING = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NPC Blacklisting
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Storyline_NPC_BLACKLIST = {"94399"}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Scaling
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Storyline_SCALE_MAPPING = {

}
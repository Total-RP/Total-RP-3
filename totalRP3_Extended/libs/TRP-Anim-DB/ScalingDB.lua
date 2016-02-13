----------------------------------------------------------------------------------
-- Total RP 3: Dialogues animations
-- ---------------------------------------------------------------------------
-- Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

local MAJOR, MINOR = "TRP-Dialog-Scaling-DB", 1

local Lib = LibStub:NewLibrary(MAJOR, MINOR)

if not Lib then return end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Model scaling
-- Give the scaling between two models
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DEFAULT_SCALE = {
	me = {
		scale = 1.45,
		feet = 0.4,
		offset = 0.215,
		facing = 0.75
	}
};
DEFAULT_SCALE.you = DEFAULT_SCALE.me;

local SCALE_MAPPING = {

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Human female
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["character\\human\\female\\humanfemale_hd.m2~character\\human\\male\\humanmale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.56,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\gnome\\female\\gnomefemale_hd.m2"] = {
		["you"] = {
			["scale"] = 2.2,
			["offset"] = 0.195,
			["feet"] = 0.42,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\draenei\\female\\draeneifemale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.27,
			["feet"] = 0.41,
		},
		["me"] = {
			["scale"] = 1.63,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\draenei\\male\\draeneimale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.81,
		},
		["you"] = {
			["scale"] = 1.31,
			["offset"] = 0.205,
			["feet"] = 0.43,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\pandaren\\male\\pandarenmale.m2"] = {
		["me"] = {
			["scale"] = 1.58,
		},
		["you"] = {
			["offset"] = 0.205,
			["scale"] = 1.13,
			["feet"] = 0.43,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\pandaren\\female\\pandarenfemale.m2"] = {
		["me"] = {
			["scale"] = 1.58,
		},
		["you"] = {
			["scale"] = 1.38,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.61,
		},
		["you"] = {
			["offset"] = 0.215,
			["scale"] = 1.32,
			["feet"] = 0.42,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.61,
		},
		["you"] = {
			["scale"] = 1.27,
			["offset"] = 0.215,
			["feet"] = 0.41,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\gnome\\male\\gnomemale_hd.m2"] = {
		["you"] = {
			["scale"] = 2,
			["offset"] = 0.185,
			["feet"] = 0.41,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.61,
			["offset"] = 0.245,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.34,
			["offset"] = 0.175,
			["feet"] = 0.42,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\worgen\\female\\worgenfemale.m2"] = {
		["you"] = {
			["offset"] = 0.215,
			["scale"] = 1.05,
			["feet"] = 0.42,
		},
		["me"] = {
			["scale"] = 1.66,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\worgen\\male\\worgenmale.m2"] = {
		["me"] = {
			["scale"] = 1.74,
		},
		["you"] = {
			["scale"] = 1.27,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\goblin\\male\\goblinmale.m2"] = {
		["you"] = {
			["offset"] = 0.195,
			["scale"] = 1.91,
			["feet"] = 0.41,
		},
		["me"] = {
			["scale"] = 1.4,
		},
	},

	-- VS NPC
	["character\\human\\female\\humanfemale_hd.m2~creature\\velen2\\velen2.m2"] = {
		["me"] = {
			["scale"] = 1.97,
		},
		["you"] = {
			["scale"] = 1.06,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~creature\\dragondeepholm\\dragondeepholmmount.m2"] = {
		["you"] = {
			["offset"] = 0.325,
			["scale"] = 0.75,
			["feet"] = 0.4,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~creature\\humanmalekid\\humanmalekid.m2"] = {
		["you"] = {
			["scale"] = 1.02,
			["offset"] = 0.115,
			["feet"] = 0.45,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~creature\\kingvarianwrynn\\kingvarianwrynn.m2"] = {
		["me"] = {
			["scale"] = 1.52,
		},
		["you"] = {
			["scale"] = 1.29,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~character\\broken\\male\\brokenmale.m2"] = {
		["you"] = {
			["scale"] = 1.3,
		},
	},
	["character\\human\\female\\humanfemale_hd.m2~creature\\humanfemalekid\\humanfemalekid.m2"] = {
		["you"] = {
			["offset"] = 0.185,
			["feet"] = 0.43,
			["scale"] = 2.25,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Human male
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["character\\human\\male\\humanmale_hd.m2~character\\gnome\\female\\gnomefemale_hd.m2"] = {
		["you"] = {
			["height"] = 1.99,
		},
		["me"] = {
			["height"] = 1.29,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		["me"] = {
			["height"] = 1.29,
		},
		["you"] = {
			["height"] = 1.55,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\pandaren\\female\\pandarenfemale.m2"] = {
		["you"] = {
			["height"] = 1.350,
		},
		["me"] = {
			["height"] = 1.399,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		["you"] = {
			["height"] = 1.299,
		},
		["me"] = {
			["height"] = 1.389,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\goblin\\female\\goblinfemale.m2"] = {
		["me"] = {
			["height"] = 1.279,
		},
		["you"] = {
			["height"] = 1.959,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		["you"] = {
			["height"] = 1.599,
		},
		["me"] = {
			["height"] = 1.279,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\orc\\male\\orcmale_hd.m2"] = {
		["me"] = {
			["height"] = 1.289,
		},
		["you"] = {
			["height"] = 1.429,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\draenei\\female\\draeneifemale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.65,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\pandaren\\male\\pandarenmale.m2"] = {
		["you"] = {
			["scale"] = 1.15,
			["offset"] = 0.205,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\worgen\\male\\worgenmale.m2"] = {
		["you"] = {
			["scale"] = 1.24,
		},
		["me"] = {
			["scale"] = 1.69,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.59,
		},
		["you"] = {
			["scale"] = 1.28,
		},
	},

	-- VS NPC
	["character\\human\\male\\humanmale_hd.m2~creature\\siberiantiger\\siberiantiger.m2"] = {
		["you"] = {
			["offset"] = 0.105,
			["scale"] = 1.35,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\humlblacksmith\\humlblacksmith.m2"] = {
		["you"] = {
			["scale"] = 1.11,
			["offset"] = 0.135,
			["feet"] = 0.42,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\humanmalekid\\humanmalekid.m2"] = {
		["you"] = {
			["offset"] = 0.135,
			["scale"] = 0.95,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\druidcat\\druidcat.m2"] = {
		["you"] = {
			["scale"] = 2.45,
			["offset"] = 0.125,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\anduin\\anduin.m2"] = {
		["you"] = {
			["scale"] = 1.61,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\draeneimalekid\\draeneimalekid.m2"] = {
		["you"] = {
			["scale"] = 2.95,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\humanfemalekid\\humanfemalekid.m2"] = {
		["you"] = {
			["scale"] = 2.45,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\draeneifemalekid\\draeneifemalekid.m2"] = {
		["you"] = {
			["scale"] = 2.45,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\velen2\\velen2.m2"] = {
		["you"] = {
			["height"] = 0.969,
		},
		["me"] = {
			["height"] = 1.809,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\impoutland\\impoutland.m2"] = {
		["you"] = {
			["height"] = 2,
		},
		["me"] = {
			["height"] = 1.299,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\arakkoa2\\arakkoa2.m2"] = {
		["you"] = {
			["height"] = 1.12,
		},
		["me"] = {
			["height"] = 1.49,
		},
	},
	["character\\human\\male\\humanmale_hd.m2~creature\\salamander\\salamandermale.m2"] = {
		["me"] = {
			["height"] = 1.639,
		},
		["you"] = {
			["height"] = 1.019,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Draenei male
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["character\\draenei\\male\\draeneimale_hd.m2~character\\worgen\\female\\worgenfemale.m2"] = {
		["me"] = {
			["offset"] = 0.205,
		},
		["you"] = {
			["scale"] = 1.23,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		["me"] = {
			["offset"] = 0.185,
		},
		["you"] = {
			["scale"] = 2.1,
			["offset"] = 0.245,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\gnome\\male\\gnomemale_hd.m2"] = {
		["me"] = {
			["offset"] = 0.205,
		},
		["you"] = {
			["scale"] = 2.52,
			["feet"] = 0.43,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\pandaren\\female\\pandarenfemale.m2"] = {
		["me"] = {
			["offset"] = 0.185,
		},
		["you"] = {
			["scale"] = 1.82,
			["offset"] = 0.245,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\pandaren\\male\\pandarenmale.m2"] = {
		["me"] = {
			["offset"] = 0.205,
		},
		["you"] = {
			["scale"] = 1.31,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\bloodelf\\female\\bloodelffemale_hd.m2"] = {
		["me"] = {
			["offset"] = 0.195,
		},
		["you"] = {
			["scale"] = 1.7,
			["offset"] = 0.245,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		["me"] = {
			["offset"] = 0.205,
		},
		["you"] = {
			["scale"] = 1.57,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\gnome\\female\\gnomefemale_hd.m2"] = {
		["you"] = {
			["offset"] = 0.225,
			["scale"] = 2.7599,
			["feet"] = 0.42,
		},
		["me"] = {
			["scale"] = 1.44,
			["offset"] = 0.195,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		["you"] = {
			["offset"] = 0.195,
			["scale"] = 1.9,
			["feet"] = 0.41,
		},
		["me"] = {
			["offset"] = 0.205,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\goblin\\female\\goblinfemale.m2"] = {
		["me"] = {
			["offset"] = 0.205,
		},
		["you"] = {
			["offset"] = 0.195,
			["scale"] = 2.25,
			["feet"] = 0.42,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["me"] = {
			["offset"] = 0.195,
		},
		["you"] = {
			["scale"] = 1.42,
			["offset"] = 0.225,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\draenei\\female\\draeneifemale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.44,
		},
		["me"] = {
			["offset"] = 0.195,
			["scale"] = 1.44,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\human\\male\\humanmale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.61,
		},
		["me"] = {
			["offset"] = 0.195,
			["scale"] = 1.38,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\goblin\\male\\goblinmale.m2"] = {
		["me"] = {
			["offset"] = 0.185,
		},
		["you"] = {
			["offset"] = 0.215,
			["scale"] = 2.399,
			["feet"] = 0.41,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\worgen\\male\\worgenmale.m2"] = {
		["me"] = {
			["offset"] = 0.195,
		},
		["you"] = {
			["scale"] = 1.38,
			["offset"] = 0.235,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\orc\\female\\orcfemale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.42,
		},
		["you"] = {
			["scale"] = 1.68,
			["offset"] = 0.195,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\tauren\\male\\taurenmale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.56,
		},
		["you"] = {
			["scale"] = 1.05,
		},
	},

	-- VS NPC
	["character\\draenei\\male\\draeneimale_hd.m2~creature\\agronn\\agronn.m2"] = {
		["me"] = {
			["scale"] = 3.44999999999999,
		},
		["you"] = {
			["scale"] = 1.2,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~creature\\ogredraenor\\ogredraenor.m2"] = {
		["me"] = {
			["scale"] = 2.15,
		},
		["you"] = {
			["scale"] = 1.45,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~character\\broken\\male\\brokenmale.m2"] = {
		["me"] = {
			["offset"] = 0.215,
		},
		["you"] = {
			["scale"] = 1.66,
			["offset"] = 0.225,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~creature\\humanfemalekid\\humanfemalekid.m2"] = {
		["you"] = {
			["scale"] = 3.38,
			["feet"] = 0.43,
			["offset"] = 0.215,
			["facing"] = 0.73,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~creature\\humanmalekid\\humanmalekid.m2"] = {
		["you"] = {
			["scale"] = 1.4,
			["facing"] = 0.79,
			["offset"] = 0.125,
			["feet"] = 0.45,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~creature\\kingvarianwrynn\\kingvarianwrynn.m2"] = {
		["me"] = {
			["offset"] = 0.195,
		},
		["you"] = {
			["scale"] = 1.37,
			["offset"] = 0.245,
		},
	},
	["character\\draenei\\male\\draeneimale_hd.m2~creature\\arakkoaoutland\\arakkoaoutland.m2"] = {
		["me"] = {
			["offset"] = 0.205,
		},
		["you"] = {
			["scale"] = 1.6,
			["offset"] = 0.215,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Gnome male
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- VS player models
	["character\\gnome\\male\\gnomemale_hd.m2~character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.58,
			["offset"] = 0.195,
		},
		["you"] = {
			["scale"] = 1.08,
			["offset"] = 0.185,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\human\\male\\humanmale_hd.m2"] = {
		["me"] = {
			["scale"] = 2.06,
			["offset"] = 0.185,
			["feet"] = 0.42,
		},
		["you"] = {
			["scale"] = 1.3,
			["offset"] = 0.225,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\gnome\\male\\gnomemale_hd.m2"] = {
		["me"] = {
			["offset"] = 0.195,
		},
		["you"] = {
			["offset"] = 0.205,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\worgen\\male\\worgenmale.m2"] = {
		["me"] = {
			["scale"] = 2.5,
			["offset"] = 0.205,
			["feet"] = 0.42,
		},
		["you"] = {
			["scale"] = 1.3,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\draenei\\female\\draeneifemale_hd.m2"] = {
		["me"] = {
			["scale"] = 2.779,
			["offset"] = 0.195,
			["feet"] = 0.42,
		},
		["you"] = {
			["scale"] = 1.38,
			["offset"] = 0.245,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\nightelf\\female\\nightelffemale_hd.m2"] = {
		["me"] = {
			["scale"] = 2.5199,
			["offset"] = 0.205,
		},
		["you"] = {
			["scale"] = 1.35,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\pandaren\\female\\pandarenfemale.m2"] = {
		["you"] = {
			["offset"] = 0.235,
			["scale"] = 1.37,
		},
		["me"] = {
			["offset"] = 0.175,
			["scale"] = 2.24,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\pandaren\\male\\pandarenmale.m2"] = {
		["me"] = {
			["scale"] = 2.599,
			["offset"] = 0.195,
		},
		["you"] = {
			["scale"] = 1.12,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["me"] = {
			["scale"] = 2.389,
			["offset"] = 0.185,
			["feet"] = 0.42,
		},
		["you"] = {
			["scale"] = 1.26,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\goblin\\male\\goblinmale.m2"] = {
		["you"] = {
			["offset"] = 0.195,
			["scale"] = 1.34,
		},
		["me"] = {
			["offset"] = 0.165,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\dwarf\\female\\dwarffemale_hd.m2"] = {
		["you"] = {
			["offset"] = 0.265,
			["scale"] = 1.21,
		},
		["me"] = {
			["offset"] = 0.175,
			["scale"] = 1.6,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\goblin\\female\\goblinfemale.m2"] = {
		["you"] = {
			["offset"] = 0.185,
			["scale"] = 1.41,
		},
		["me"] = {
			["offset"] = 0.175,
		},
	},

	-- VS NPC
	["character\\gnome\\male\\gnomemale_hd.m2~creature\\draenorancient\\draenorancientgorgrond.m2"] = {
		["me"] = {
			["scale"] = 7.5499,
			["feet"] = 0.42,
		},
		["you"] = {
			["scale"] = 0.75,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~creature\\kingvarianwrynn\\kingvarianwrynn.m2"] = {
		["me"] = {
			["scale"] = 2.6999,
			["offset"] = 0.215,
		},
		["you"] = {
			["scale"] = 1.37,
			["offset"] = 0.235,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~character\\broken\\male\\brokenmale.m2"] = {
		["you"] = {
			["scale"] = 1.37,
			["feet"] = 0.38,
			["facing"] = 0.79,
		},
		["me"] = {
			["offset"] = 0.175,
			["scale"] = 2.1,
		},
	},
	["character\\gnome\\male\\gnomemale_hd.m2~creature\\humanfemalekid\\humanfemalekid.m2"] = {
		["me"] = {
			["scale"] = 1.31,
			["offset"] = 0.175,
		},
		["you"] = {
			["scale"] = 1.59,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Dwarf female
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\dwarf\\male\\dwarfmale_hd.m2"] = {
		["me"] = {
			["height"] = 1.299,
		},
		["you"] = {
			["height"] = 1.179,
		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\tauren\\male\\taurenmale_hd.m2"] = {
		["you"] = {
			["height"] = 1.029,
		},
		["me"] = {
			["height"] = 2,

		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["you"] = {
			["height"] = 1.23,
		},
		["me"] = {
			["height"] = 1.709,
		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\worgen\\male\\worgenmale.m2"] = {
		["me"] = {
			["height"] = 1.639,
		},
		["you"] = {
			["height"] = 1.299,
		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\human\\male\\humanmale_hd.m2"] = {
		["me"] = {
			["height"] = 1.599,
		},
		["you"] = {
			["height"] = 1.279,
		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\gnome\\female\\gnomefemale_hd.m2"] = {
		["me"] = {
			["height"] = 1.299,
		},
		["you"] = {
			["height"] = 1.799,
		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~character\\pandaren\\male\\pandarenmale.m2"] = {
		["you"] = {
			["height"] = 1.299,
		},
		["me"] = {
			["height"] = 1.769,
		},
	},

	-- VS NPC
	["character\\dwarf\\female\\dwarffemale_hd.m2~creature\\blingtron\\blingtron.m2"] = {
		["me"] = {
			["height"] = 1.269,
		},
		["you"] = {
			["height"] = 1.579,
		},
	},
	["character\\dwarf\\female\\dwarffemale_hd.m2~creature\\humanmalekid\\humanmalekid.m2"] = {
		["you"] = {
			["height"] = 0.799,
		},
		["me"] = {
			["height"] = 1.299,

		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Loup loup !
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["creature\\wolfdraenor\\wolfdraenor.m2~character\\human\\female\\humanfemale_hd.m2"] = {
		["me"] = {
			["height"] = 1.74,
		},
		["you"] = {
			["height"] = 1.299,
		},
	},
	["creature\\wolfdraenor\\wolfdraenor.m2~character\\worgen\\female\\worgenfemale.m2"] = {
		["you"] = {
			["height"] = 1.24,
		},
		["me"] = {
			["height"] = 2,
		},
	},
	["creature\\wolfdraenor\\wolfdraenor.m2~character\\human\\male\\humanmale_hd.m2"] = {
		["me"] = {
			["height"] = 1.799,
		},
		["you"] = {
			["height"] = 1.299,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Night elves Female
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["character\\nightelf\\female\\nightelffemale_hd.m2~character\\nightelf\\male\\nightelfmale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.41,
		},
		["me"] = {
			["scale"] = 1.56,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Blood elves Female
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models
	["character\\bloodelf\\female\\bloodelffemale_hd.m2~character\\troll\\female\\trollfemale_hd.m2"] = {
		["you"] = {
			["scale"] = 1.25,
		},
		["me"] = {
			["scale"] = 1.55,
		},
	},
	["character\\bloodelf\\female\\bloodelffemale_hd.m2~character\\tauren\\male\\taurenmale_hd.m2"] = {
		["me"] = {
			["scale"] = 1.79,
		},
		["you"] = {
			["scale"] = 1.05,
		},
	},

	-- VS NPC
	["character\\bloodelf\\female\\bloodelffemale_hd.m2~creature\\thralldoomplate\\thralldoomplate.m2"] = {
		["you"] = {
			["scale"] = 1.15,
		},
		["me"] = {
			["scale"] = 1.55,
		},
	},
	["character\\bloodelf\\female\\bloodelffemale_hd.m2~creature\\miev\\miev.m2"] = {
		["you"] = {
			["scale"] = 1.25,
		},
		["me"] = {
			["scale"] = 1.75,
		},
	},

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Troll male
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- VS player models

	-- VS NPC
	["character\\troll\\male\\trollmale_hd.m2~creature\\khadgar2\\khadgar2.m2"] = {
		["me"] = {
			["offset"] = 0.125,
			["scale"] = 1.46,
		},
	},
	["character\\troll\\male\\trollmale_hd.m2~creature\\velen2\\velen2.m2"] = {
		["you"] = {
			["scale"] = 1.03,
		},
		["me"] = {
			["scale"] = 1.79,
			["offset"] = 0.165,
		},
	},
	["character\\troll\\male\\trollmale_hd.m2~creature\\naaru\\naaru.m2"] = {
		["me"] = {
			["scale"] = 2.65,
			["offset"] = 0.175,
		},
		["you"] = {
			["scale"] = 1.51,
			["offset"] = 0.215,
		},
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Scaling API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function Lib:GetModelScaling(model1, model2)
	local key = model1 .. "~" .. model2;
	if SCALE_MAPPING[key] then
		return SCALE_MAPPING[key].me or DEFAULT_SCALE.me, SCALE_MAPPING[key].you or DEFAULT_SCALE.you, false;
	end

	local inverted = model2 .. "~" .. model1;
	if SCALE_MAPPING[inverted] then
		return SCALE_MAPPING[inverted].you or DEFAULT_SCALE.you, SCALE_MAPPING[key].me or DEFAULT_SCALE.me, true;
	end

	return DEFAULT_SCALE.me, DEFAULT_SCALE.you;
end

function Lib:GetModelDefaultScaling()
	return DEFAULT_SCALE;
end

function Lib:SetModelHeight(scale, frame)
	scale = scale or DEFAULT_SCALE.me.scale;
	frame.scale = scale;
	frame:InitializeCamera(scale);
end

function Lib:SetModelFacing(facing, frame, isMe)
	facing = facing or DEFAULT_SCALE.me.facing;
	frame.facing = facing;
	frame:SetFacing(facing * (isMe and 1 or -1));
end

function Lib:SetModelFeet(feet, frame)
	feet = feet or DEFAULT_SCALE.me.feet;
	frame.feet = feet;
	frame:SetHeightFactor(feet);
end

function Lib:SetModelOffset(offset, frame, isMe)
	offset = offset or DEFAULT_SCALE.me.offset;
	frame.offset = offset;
	frame:SetTargetDistance(offset * (isMe and 1 or -1));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG AND MAINTENANCE
-- Don't use it on your code. :)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local debugPlayerModelList = {
	-- Alliance
	"character\\human\\female\\humanfemale_hd.m2",
	"character\\human\\male\\humanmale_hd.m2",
	"character\\gnome\\female\\gnomefemale_hd.m2",
	"character\\gnome\\male\\gnomemale_hd.m2",
	"character\\dwarf\\female\\dwarffemale_hd.m2",
	"character\\dwarf\\male\\dwarfmale_hd.m2",
	"character\\draenei\\female\\draeneifemale_hd.m2",
	"character\\draenei\\male\\draeneimale_hd.m2",
	"character\\pandaren\\male\\pandarenmale.m2",
	"character\\pandaren\\female\\pandarenfemale.m2",
	"character\\nightelf\\female\\nightelffemale_hd.m2",
	"character\\nightelf\\male\\nightelfmale_hd.m2",
	"character\\worgen\\female\\worgenfemale.m2",
	"character\\worgen\\male\\worgenmale.m2",

	-- Horde
	--	"character\\goblin\\male\\goblinmale.m2",
	--	"character\\goblin\\female\\goblinfemale.m2",
}

--function TRP3_API.extended.animations.debugMissingScaling()
--	local alreadyTreated = {};
--	local count = 0;
--	for _, firstModel in pairs(debugPlayerModelList) do
--		for _, secondModel in pairs(debugPlayerModelList) do
--			if firstModel ~= secondModel then
--				local key, invertedKey = firstModel .. "~" .. secondModel, secondModel .. "~" .. firstModel;
--				if not TRP3_API.extended.animations.SCALE_MAPPING[key] and not TRP3_API.extended.animations.SCALE_MAPPING[invertedKey] and not alreadyTreated[key] and not alreadyTreated[invertedKey] then
--					alreadyTreated[key] = true;
--					alreadyTreated[invertedKey] = true;
--					count = count + 1;
--					print(("Missing scaling for %s + %s"):format(firstModel, secondModel));
--				end
--			end
--		end
--	end
--	print(("Total %s"):format(count));
--end
--
--local IMPORT = {
--
--}
--
--function TRP3_API.extended.animations.API.debugComplete()
--	if not TRP3_API.extended.animations.Data.debug.finalImport then
--		TRP3_API.extended.animations.Data.debug.finalImport = {};
--	end
--	wipe(TRP3_API.extended.animations.Data.debug.finalImport);
--	-- Find which key to import
--	local toImport = {};
--	for key, info in pairs(IMPORT) do
--		local firstModel = key:sub(1, key:find("~") - 1);
--		local secondModel = key:sub(key:find("~") + 1);
--		local invertedKey = secondModel .. "~" .. firstModel;
--		if not TRP3_API.extended.animations.SCALE_MAPPING[key] and not TRP3_API.extended.animations.SCALE_MAPPING[invertedKey] then
--			print("new to import: " .. key);
--			TRP3_API.extended.animations.Data.debug.finalImport[key] = info;
--		end
--	end
--end
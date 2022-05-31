--[[
	Total RP 3

	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--]]

--
-- Companion Data Tables
--

TRP3_CompanionPetData = C_PetJournal and {} or {

	--
	-- Classic
	--

	{ speciesID = 106,  itemID = 19450, spellID = 23811, creatureID = 14878 }, -- A Jubling's Tiny Home
	{ speciesID = 52,   itemID = 11023, spellID = 10685, creatureID = 7394  }, -- Ancona Chicken
	{ speciesID = 75,   itemID = 10360, spellID = 10714, creatureID = 7565  }, -- Black Kingsnake
	{ speciesID = 107,  itemID = 20371, spellID = 24696, creatureID = 15186 }, -- Blue Murloc Egg
	{ speciesID = 77,   itemID = 10361, spellID = 10716, creatureID = 7562  }, -- Brown Snake
	{ speciesID = 128,  itemID = 23083, spellID = 28871, creatureID = 16701 }, -- Captured Flame
	{ speciesID = 42,   itemID = 8491,  spellID = 10675, creatureID = 7383  }, -- Cat Carrier (Black Tabby)
	{ speciesID = 40,   itemID = 8485,  spellID = 10673, creatureID = 7385  }, -- Cat Carrier (Bombay)
	{ speciesID = 41,   itemID = 8486,  spellID = 10674, creatureID = 7384  }, -- Cat Carrier (Cornish Rex)
	{ speciesID = 43,   itemID = 8487,  spellID = 10676, creatureID = 7382  }, -- Cat Carrier (Orange Tabby)
	{ speciesID = 44,   itemID = 8490,  spellID = 10677, creatureID = 7380  }, -- Cat Carrier (Siamese)
	{ speciesID = 45,   itemID = 8488,  spellID = 10678, creatureID = 7381  }, -- Cat Carrier (Silver Tabby)
	{ speciesID = 46,   itemID = 8489,  spellID = 10679, creatureID = 7386  }, -- Cat Carrier (White Kitten)
	{ speciesID = 84,   itemID = 11110, spellID = 13548, creatureID = 7392  }, -- Chicken Egg
	{ speciesID = 55,   itemID = 10393, spellID = 10688, creatureID = 7395  }, -- Cockroach
	{ speciesID = 78,   itemID = 10392, spellID = 10717, creatureID = 7567  }, -- Crimson Snake
	{ speciesID = 56,   itemID = 10822, spellID = 10695, creatureID = 7543  }, -- Dark Whelpling
	{ speciesID = 93,   itemID = 13584, spellID = 17708, creatureID = 11326 }, -- Diablo Stone
	{ speciesID = 114,  itemID = 20769, spellID = 25162, creatureID = 15429 }, -- Disgusting Oozeling
	{ speciesID = 68,   itemID = 8500,  spellID = 10707, creatureID = 7553  }, -- Great Horned Owl
	{ speciesID = 757,  itemID = 19055, spellID = 23531, creatureID = 14755 }, -- Green Dragon Orb
	{ speciesID = 67,   itemID = 8501,  spellID = 10706, creatureID = 7555  }, -- Hawk Owl
	{ speciesID = 130,  itemID = 23713, spellID = 30156, creatureID = 17255 }, -- Hippogryph Hatchling
	{ speciesID = 95,   itemID = 15996, spellID = 19772, creatureID = 12419 }, -- Lifelike Mechanical Toad
	{ speciesID = 86,   itemID = 11826, spellID = 15049, creatureID = 9657  }, -- Lil' Smoky
	{ speciesID = 83,   itemID = 10398, spellID = 12243, creatureID = 8376  }, -- Mechanical Chicken
	{ speciesID = 39,   itemID = 4401,  spellID = 4055,  creatureID = 2671  }, -- Mechanical Squirrel Box
	{ speciesID = 1168, itemID = 20651, spellID = 25018, creatureID = 15361 }, -- Orange Murloc Egg
	{ speciesID = 92,   itemID = 13583, spellID = 17707, creatureID = 11325 }, -- Panda Collar
	{ speciesID = 47,   itemID = 8496,  spellID = 10680, creatureID = 7390  }, -- Parrot Cage (Cockatiel)
	{ speciesID = 50,   itemID = 8492,  spellID = 10683, creatureID = 7387  }, -- Parrot Cage (Green Wing Macaw)
	{ speciesID = 49,   itemID = 8494,  spellID = 10682, creatureID = 7391  }, -- Parrot Cage (Hyacinth Macaw)
	{ speciesID = 51,   itemID = 8495,  spellID = 10684, creatureID = 7389  }, -- Parrot Cage (Senegal)
	{ speciesID = 85,   itemID = 11825, spellID = 15048, creatureID = 9656  }, -- Pet Bombling
	{ speciesID = 126,  itemID = 23007, spellID = 28739, creatureID = 16548 }, -- Piglet's Collar
	{ speciesID = 121,  itemID = 22114, spellID = 27241, creatureID = 16069 }, -- Pink Murloc Egg
	{ speciesID = 124,  itemID = 22781, spellID = 28505, creatureID = 16456 }, -- Polar Bear Collar
	{ speciesID = 70,   itemID = 10394, spellID = 10709, creatureID = 14421 }, -- Prairie Dog Whistle
	{ speciesID = 72,   itemID = 8497,  spellID = 10711, creatureID = 7560  }, -- Rabbit Crate (Snowshoe)
	{ speciesID = 127,  itemID = 23015, spellID = 28740, creatureID = 16549 }, -- Rat Cage
	{ speciesID = 758,  itemID = 19054, spellID = 23530, creatureID = 14756 }, -- Red Dragon Orb
	{ speciesID = 120,  itemID = 21305, spellID = 26541, creatureID = 15705 }, -- Red Helper Box
	{ speciesID = 90,   itemID = 12529, spellID = 16450, creatureID = 10598 }, -- Smolderweb Carrier
	{ speciesID = 87,   itemID = 11474, spellID = 15067, creatureID = 9662  }, -- Sprite Darter Egg
	{ speciesID = 58,   itemID = 8499,  spellID = 10697, creatureID = 7544  }, -- Tiny Crimson Whelpling
	{ speciesID = 59,   itemID = 8498,  spellID = 10698, creatureID = 7545  }, -- Tiny Emerald Whelpling
	{ speciesID = 116,  itemID = 21277, spellID = 26010, creatureID = 15699 }, -- Tranquil Mechanical Yeti
	{ speciesID = 65,   itemID = 11026, spellID = 10704, creatureID = 7549  }, -- Tree Frog Box
	{ speciesID = 122,  itemID = 22235, spellID = 27570, creatureID = 16085 }, -- Truesilver Shafted Arrow
	{ speciesID = 125,  itemID = 23002, spellID = 28738, creatureID = 16547 }, -- Turtle Box
	{ speciesID = 1073, itemID = 22780, spellID = 28487, creatureID = 16445 }, -- White Murloc Egg
	{ speciesID = 1927, itemID = 23712, spellID = 30152, creatureID = 17254 }, -- White Tiger Cub
	{ speciesID = 64,   itemID = 11027, spellID = 10703, creatureID = 7550  }, -- Wood Frog Box
	{ speciesID = 89,   itemID = 12264, spellID = 15999, creatureID = 10259 }, -- Worg Carrier
	{ speciesID = 94,   itemID = 13582, spellID = 17709, creatureID = 11327 }, -- Zergling Leash

	--
	-- Burning Crusade
	--

	{ speciesID = 57,   itemID = 34535, spellID = 10696, creatureID = 7547  }, -- Azure Whelpling
	{ speciesID = 156,  itemID = 32588, spellID = 40549, creatureID = 23234 }, -- Banana Charm
	{ speciesID = 145,  itemID = 29958, spellID = 36031, creatureID = 21056 }, -- Blue Dragonhawk Hatchling
	{ speciesID = 138,  itemID = 29901, spellID = 35907, creatureID = 21010 }, -- Blue Moth Egg
	{ speciesID = 137,  itemID = 29364, spellID = 35239, creatureID = 20472 }, -- Brown Rabbit Crate
	{ speciesID = 146,  itemID = 29960, spellID = 36034, creatureID = 21076 }, -- Captured Firefly
	{ speciesID = 174,  itemID = 35350, spellID = 46426, creatureID = 26056 }, -- Chuck's Bucket
	{ speciesID = 180,  itemID = 37298, spellID = 48408, creatureID = 27346 }, -- Competitor's Souvenir
	{ speciesID = 169,  itemID = 34493, spellID = 45127, creatureID = 25110 }, -- Dragon Kite
	{ speciesID = 158,  itemID = 32616, spellID = 40614, creatureID = 23258 }, -- Egbert's Egg
	{ speciesID = 159,  itemID = 32622, spellID = 40634, creatureID = 23266 }, -- Elekk Training Collar
	{ speciesID = 155,  itemID = 32498, spellID = 40405, creatureID = 23198 }, -- Fortune Coin
	{ speciesID = 179,  itemID = 37297, spellID = 48406, creatureID = 27217 }, -- Gold Medallion
	{ speciesID = 142,  itemID = 29953, spellID = 36027, creatureID = 21055 }, -- Golden Dragonhawk Hatchling
	{ speciesID = 170,  itemID = 34518, spellID = 45174, creatureID = 25146 }, -- Golden Pig Coin
	{ speciesID = 111,  itemID = 30360, spellID = 24988, creatureID = 15358 }, -- Lurky's Egg
	{ speciesID = 132,  itemID = 27445, spellID = 33050, creatureID = 18839 }, -- Magical Crawdad Box
	{ speciesID = 136,  itemID = 29363, spellID = 35156, creatureID = 20408 }, -- Mana Wyrmling
	{ speciesID = 149,  itemID = 31760, spellID = 39181, creatureID = 22445 }, -- Miniwing
	{ speciesID = 165,  itemID = 33993, spellID = 43918, creatureID = 24480 }, -- Mojo
	{ speciesID = 164,  itemID = 33818, spellID = 43698, creatureID = 24389 }, -- Muckbreath's Bucket
	{ speciesID = 186,  itemID = 38628, spellID = 51716, creatureID = 28470 }, -- Nether Ray Fry
	{ speciesID = 131,  itemID = 25535, spellID = 32298, creatureID = 18381 }, -- Netherwhelp's Collar
	{ speciesID = 175,  itemID = 35504, spellID = 46599, creatureID = 26119 }, -- Phoenix Hatchling
	{ speciesID = 143,  itemID = 29956, spellID = 36028, creatureID = 21064 }, -- Red Dragonhawk Hatchling
	{ speciesID = 139,  itemID = 29902, spellID = 35909, creatureID = 21009 }, -- Red Moth Egg
	{ speciesID = 168,  itemID = 34492, spellID = 45125, creatureID = 25109 }, -- Rocket Chicken
	{ speciesID = 172,  itemID = 34955, spellID = 45890, creatureID = 25706 }, -- Scorched Stone
	{ speciesID = 144,  itemID = 29957, spellID = 36029, creatureID = 21063 }, -- Silver Dragonhawk Hatchling
	{ speciesID = 171,  itemID = 34519, spellID = 45175, creatureID = 25147 }, -- Silver Pig Coin
	{ speciesID = 162,  itemID = 33154, spellID = 42609, creatureID = 23909 }, -- Sinister Squashling
	{ speciesID = 157,  itemID = 32617, spellID = 40613, creatureID = 23231 }, -- Sleepy Willy
	{ speciesID = 173,  itemID = 35349, spellID = 46425, creatureID = 26050 }, -- Snarly's Bucket
	{ speciesID = 183,  itemID = 38050, spellID = 49964, creatureID = 27914 }, -- Soul-Trader Beacon
	{ speciesID = 167,  itemID = 34478, spellID = 45082, creatureID = 25062 }, -- Tiny Sporebat
	{ speciesID = 163,  itemID = 33816, spellID = 43697, creatureID = 24388 }, -- Toothy's Bucket
	{ speciesID = 189,  itemID = 39656, spellID = 53082, creatureID = 29089 }, -- Tyrael's Hilt
	{ speciesID = 141,  itemID = 29904, spellID = 35911, creatureID = 21018 }, -- White Moth Egg
	{ speciesID = 153,  itemID = 32233, spellID = 39709, creatureID = 22943 }, -- Wolpertinger's Tankard
	{ speciesID = 140,  itemID = 29903, spellID = 35910, creatureID = 21008 }, -- Yellow Moth Egg
};

TRP3_CompanionMountData = C_MountJournal and {} or {

	--
	-- Classic
	--

	{ mountID = 77,  itemID = 18243, spellID = 22719 }, -- Black Battlestrider
	{ mountID = 122, itemID = 21176, spellID = 26656 }, -- Black Qiraji Resonating Crystal
	{ mountID = 9,   itemID = 2411,  spellID = 470   }, -- Black Stallion Bridle
	{ mountID = 76,  itemID = 18247, spellID = 22718 }, -- Black War Kodo
	{ mountID = 78,  itemID = 18244, spellID = 22720 }, -- Black War Ram
	{ mountID = 75,  itemID = 18241, spellID = 22717 }, -- Black War Steed Bridle
	{ mountID = 40,  itemID = 8595,  spellID = 10969 }, -- Blue Mechanostrider
	{ mountID = 117, itemID = 21218, spellID = 25953 }, -- Blue Qiraji Resonating Crystal
	{ mountID = 66,  itemID = 13332, spellID = 17463 }, -- Blue Skeletal Horse
	{ mountID = 6,   itemID = 5656,  spellID = 458   }, -- Brown Horse Bridle
	{ mountID = 72,  itemID = 15290, spellID = 18990 }, -- Brown Kodo
	{ mountID = 25,  itemID = 5872,  spellID = 6899  }, -- Brown Ram
	{ mountID = 67,  itemID = 13333, spellID = 17464 }, -- Brown Skeletal Horse
	{ mountID = 18,  itemID = 5655,  spellID = 6648  }, -- Chestnut Mare Bridle
	{ mountID = 69,  itemID = 13335, spellID = 17481 }, -- Deathcharger's Reins
	{ mountID = 71,  itemID = 15277, spellID = 18989 }, -- Gray Kodo
	{ mountID = 21,  itemID = 5864,  spellID = 6777  }, -- Gray Ram
	{ mountID = 103, itemID = 18794, spellID = 23249 }, -- Great Brown Kodo
	{ mountID = 102, itemID = 18795, spellID = 23248 }, -- Great Gray Kodo
	{ mountID = 101, itemID = 18793, spellID = 23247 }, -- Great White Kodo
	{ mountID = 57,  itemID = 13321, spellID = 17453 }, -- Green Mechanostrider
	{ mountID = 120, itemID = 21323, spellID = 26056 }, -- Green Qiraji Resonating Crystal
	{ mountID = 68,  itemID = 13334, spellID = 17465 }, -- Green Skeletal Warhorse
	{ mountID = 82,  itemID = 18245, spellID = 22724 }, -- Horn of the Black War Wolf
	{ mountID = 20,  itemID = 5668,  spellID = 6654  }, -- Horn of the Brown Wolf
	{ mountID = 19,  itemID = 5665,  spellID = 6653  }, -- Horn of the Dire Wolf
	{ mountID = 108, itemID = 19029, spellID = 23509 }, -- Horn of the Frostwolf Howler
	{ mountID = 104, itemID = 18796, spellID = 23250 }, -- Horn of the Swift Brown Wolf
	{ mountID = 106, itemID = 18798, spellID = 23252 }, -- Horn of the Swift Gray Wolf
	{ mountID = 105, itemID = 18797, spellID = 23251 }, -- Horn of the Swift Timber Wolf
	{ mountID = 14,  itemID = 1132,  spellID = 580   }, -- Horn of the Timber Wolf
	{ mountID = 11,  itemID = 2414,  spellID = 472   }, -- Pinto Bridle
	{ mountID = 100, itemID = 18791, spellID = 23246 }, -- Purple Skeletal Warhorse
	{ mountID = 39,  itemID = 8563,  spellID = 10873 }, -- Red Mechanostrider
	{ mountID = 118, itemID = 21321, spellID = 26054 }, -- Red Qiraji Resonating Crystal
	{ mountID = 65,  itemID = 13331, spellID = 17462 }, -- Red Skeletal Horse
	{ mountID = 80,  itemID = 18248, spellID = 22722 }, -- Red Skeletal Warhorse
	{ mountID = 81,  itemID = 18242, spellID = 22723 }, -- Reins of the Black War Tiger
	{ mountID = 31,  itemID = 8632,  spellID = 10789 }, -- Reins of the Spotted Frostsaber
	{ mountID = 26,  itemID = 8631,  spellID = 8394  }, -- Reins of the Striped Frostsaber
	{ mountID = 34,  itemID = 8629,  spellID = 10793 }, -- Reins of the Striped Nightsaber
	{ mountID = 87,  itemID = 18766, spellID = 23221 }, -- Reins of the Swift Frostsaber
	{ mountID = 85,  itemID = 18767, spellID = 23219 }, -- Reins of the Swift Mistsaber
	{ mountID = 107, itemID = 18902, spellID = 23338 }, -- Reins of the Swift Stormsaber
	{ mountID = 55,  itemID = 13086, spellID = 17229 }, -- Reins of the Winterspring Frostsaber
	{ mountID = 109, itemID = 19030, spellID = 23510 }, -- Stormpike Battle Charger
	{ mountID = 84,  itemID = nil,   spellID = 23214 }, -- Summon Charger
	{ mountID = 83,  itemID = nil,   spellID = 23161 }, -- Summon Dreadsteed
	{ mountID = 17,  itemID = nil,   spellID = 5784  }, -- Summon Felsteed
	{ mountID = 41,  itemID = nil,   spellID = 13819 }, -- Summon Warhorse
	{ mountID = 97,  itemID = 18788, spellID = 23241 }, -- Swift Blue Raptor
	{ mountID = 94,  itemID = 18786, spellID = 23238 }, -- Swift Brown Ram
	{ mountID = 93,  itemID = 18777, spellID = 23229 }, -- Swift Brown Steed
	{ mountID = 95,  itemID = 18787, spellID = 23239 }, -- Swift Gray Ram
	{ mountID = 90,  itemID = 18772, spellID = 23225 }, -- Swift Green Mechanostrider
	{ mountID = 98,  itemID = 18789, spellID = 23242 }, -- Swift Olive Raptor
	{ mountID = 99,  itemID = 18790, spellID = 23243 }, -- Swift Orange Raptor
	{ mountID = 91,  itemID = 18776, spellID = 23227 }, -- Swift Palomino
	{ mountID = 110, itemID = 19872, spellID = 24242 }, -- Swift Razzashi Raptor
	{ mountID = 89,  itemID = 18773, spellID = 23223 }, -- Swift White Mechanostrider
	{ mountID = 96,  itemID = 18785, spellID = 23240 }, -- Swift White Ram
	{ mountID = 92,  itemID = 18778, spellID = 23228 }, -- Swift White Steed
	{ mountID = 88,  itemID = 18774, spellID = 23222 }, -- Swift Yellow Mechanostrider
	{ mountID = 111, itemID = 19902, spellID = 24252 }, -- Swift Zulian Tiger
	{ mountID = 58,  itemID = 13322, spellID = 17454 }, -- Unpainted Mechanostrider
	{ mountID = 79,  itemID = 18246, spellID = 22721 }, -- Whistle of the Black War Raptor
	{ mountID = 27,  itemID = 8588,  spellID = 8395  }, -- Whistle of the Emerald Raptor
	{ mountID = 36,  itemID = 8591,  spellID = 10796 }, -- Whistle of the Turquoise Raptor
	{ mountID = 38,  itemID = 8592,  spellID = 10799 }, -- Whistle of the Violet Raptor
	{ mountID = 24,  itemID = 5873,  spellID = 6898  }, -- White Ram
	{ mountID = 119, itemID = 21324, spellID = 26055 }, -- Yellow Qiraji Resonating Crystal

	--
	-- Burning Crusade
	--

	{ mountID = 125, itemID = 23720, spellID = 30174 }, -- Riding Turtle
	{ mountID = 129, itemID = 25470, spellID = 32235 }, -- Golden Gryphon
	{ mountID = 130, itemID = 25471, spellID = 32239 }, -- Ebon Gryphon
	{ mountID = 131, itemID = 25472, spellID = 32240 }, -- Snowy Gryphon
	{ mountID = 132, itemID = 25473, spellID = 32242 }, -- Swift Blue Gryphon
	{ mountID = 133, itemID = 25474, spellID = 32243 }, -- Tawny Windrider
	{ mountID = 134, itemID = 25475, spellID = 32244 }, -- Blue Windrider
	{ mountID = 135, itemID = 25476, spellID = 32245 }, -- Green Windrider
	{ mountID = 136, itemID = 25477, spellID = 32246 }, -- Swift Red Windrider
	{ mountID = 137, itemID = 25527, spellID = 32289 }, -- Swift Red Gryphon
	{ mountID = 138, itemID = 25528, spellID = 32290 }, -- Swift Green Gryphon
	{ mountID = 139, itemID = 25529, spellID = 32292 }, -- Swift Purple Gryphon
	{ mountID = 140, itemID = 25531, spellID = 32295 }, -- Swift Green Windrider
	{ mountID = 141, itemID = 25532, spellID = 32296 }, -- Swift Yellow Windrider
	{ mountID = 142, itemID = 25533, spellID = 32297 }, -- Swift Purple Windrider
	{ mountID = 146, itemID = 28936, spellID = 33660 }, -- Swift Pink Hawkstrider
	{ mountID = 147, itemID = 28481, spellID = 34406 }, -- Brown Elekk
	{ mountID = 149, itemID = nil,   spellID = 34767 }, -- Summon Thalassian Charger
	{ mountID = 150, itemID = nil,   spellID = 34769 }, -- Summon Thalassian Warhorse
	{ mountID = 151, itemID = 29228, spellID = 34790 }, -- Reins of the Dark War Talbuk
	{ mountID = 152, itemID = 28927, spellID = 34795 }, -- Red Hawkstrider
	{ mountID = 153, itemID = 29102, spellID = 34896 }, -- Reins of the Cobalt War Talbuk
	{ mountID = 153, itemID = 29227, spellID = 34896 }, -- Reins of the Cobalt War Talbuk
	{ mountID = 154, itemID = 29103, spellID = 34897 }, -- Reins of the White War Talbuk
	{ mountID = 154, itemID = 29231, spellID = 34897 }, -- Reins of the White War Talbuk
	{ mountID = 155, itemID = 29104, spellID = 34898 }, -- Reins of the Silver War Talbuk
	{ mountID = 155, itemID = 29229, spellID = 34898 }, -- Reins of the Silver War Talbuk
	{ mountID = 156, itemID = 29105, spellID = 34899 }, -- Reins of the Tan War Talbuk
	{ mountID = 156, itemID = 29230, spellID = 34899 }, -- Reins of the Tan War Talbuk
	{ mountID = 157, itemID = 29222, spellID = 35018 }, -- Purple Hawkstrider
	{ mountID = 158, itemID = 29220, spellID = 35020 }, -- Blue Hawkstrider
	{ mountID = 159, itemID = 29221, spellID = 35022 }, -- Black Hawkstrider
	{ mountID = 160, itemID = 29223, spellID = 35025 }, -- Swift Green Hawkstrider
	{ mountID = 161, itemID = 29224, spellID = 35027 }, -- Swift Purple Hawkstrider
	{ mountID = 162, itemID = 34129, spellID = 35028 }, -- Swift Warstrider
	{ mountID = 163, itemID = 29744, spellID = 35710 }, -- Gray Elekk
	{ mountID = 164, itemID = 29743, spellID = 35711 }, -- Purple Elekk
	{ mountID = 165, itemID = 29746, spellID = 35712 }, -- Great Green Elekk
	{ mountID = 166, itemID = 29745, spellID = 35713 }, -- Great Blue Elekk
	{ mountID = 167, itemID = 29747, spellID = 35714 }, -- Great Purple Elekk
	{ mountID = 168, itemID = 30480, spellID = 36702 }, -- Fiery Warhorse's Reins
	{ mountID = 169, itemID = 30609, spellID = 37015 }, -- Swift Nether Drake
	{ mountID = 170, itemID = 31829, spellID = 39315 }, -- Reins of the Cobalt Riding Talbuk
	{ mountID = 170, itemID = 31830, spellID = 39315 }, -- Reins of the Cobalt Riding Talbuk
	{ mountID = 171, itemID = 28915, spellID = 39316 }, -- Reins of the Dark Riding Talbuk
	{ mountID = 172, itemID = 31831, spellID = 39317 }, -- Reins of the Silver Riding Talbuk
	{ mountID = 172, itemID = 31832, spellID = 39317 }, -- Reins of the Silver Riding Talbuk
	{ mountID = 173, itemID = 31833, spellID = 39318 }, -- Reins of the Tan Riding Talbuk
	{ mountID = 173, itemID = 31834, spellID = 39318 }, -- Reins of the Tan Riding Talbuk
	{ mountID = 174, itemID = 31835, spellID = 39319 }, -- Reins of the White Riding Talbuk
	{ mountID = 174, itemID = 31836, spellID = 39319 }, -- Reins of the White Riding Talbuk
	{ mountID = 176, itemID = 32314, spellID = 39798 }, -- Green Riding Nether Ray
	{ mountID = 177, itemID = 32317, spellID = 39800 }, -- Red Riding Nether Ray
	{ mountID = 178, itemID = 32316, spellID = 39801 }, -- Purple Riding Nether Ray
	{ mountID = 179, itemID = 32318, spellID = 39802 }, -- Silver Riding Nether Ray
	{ mountID = 180, itemID = 32319, spellID = 39803 }, -- Blue Riding Nether Ray
	{ mountID = 183, itemID = 32458, spellID = 40192 }, -- Ashes of Al'ar
	{ mountID = 185, itemID = 32768, spellID = 41252 }, -- Reins of the Raven Lord
	{ mountID = 186, itemID = 32857, spellID = 41513 }, -- Reins of the Onyx Netherwing Drake
	{ mountID = 187, itemID = 32858, spellID = 41514 }, -- Reins of the Azure Netherwing Drake
	{ mountID = 188, itemID = 32859, spellID = 41515 }, -- Reins of the Cobalt Netherwing Drake
	{ mountID = 189, itemID = 32860, spellID = 41516 }, -- Reins of the Purple Netherwing Drake
	{ mountID = 190, itemID = 32861, spellID = 41517 }, -- Reins of the Veridian Netherwing Drake
	{ mountID = 191, itemID = 32862, spellID = 41518 }, -- Reins of the Violet Netherwing Drake
	{ mountID = 196, itemID = 33224, spellID = 42776 }, -- Reins of the Spectral Tiger
	{ mountID = 197, itemID = 33225, spellID = 42777 }, -- Reins of the Swift Spectral Tiger
	{ mountID = 199, itemID = 33809, spellID = 43688 }, -- Amani War Bear
	{ mountID = 201, itemID = 33976, spellID = 43899 }, -- Brewfest Ram
	{ mountID = 202, itemID = 33977, spellID = 43900 }, -- Swift Brewfest Ram
	{ mountID = 203, itemID = 33999, spellID = 43927 }, -- Cenarion War Hippogryph
	{ mountID = 204, itemID = 34061, spellID = 44151 }, -- Turbo-Charged Flying Machine Control
	{ mountID = 205, itemID = 34060, spellID = 44153 }, -- Flying Machine Control
	{ mountID = 207, itemID = 34092, spellID = 44744 }, -- Merciless Nether Drake
	{ mountID = 211, itemID = 35225, spellID = 46197 }, -- X-51 Nether-Rocket
	{ mountID = 212, itemID = 35226, spellID = 46199 }, -- X-51 Nether-Rocket X-TREME
	{ mountID = 213, itemID = 35513, spellID = 46628 }, -- Swift White Hawkstrider
	{ mountID = 219, itemID = 37012, spellID = 48025 }, -- The Horseman's Reins
	{ mountID = 220, itemID = 35906, spellID = 48027 }, -- Reins of the Black War Elekk
	{ mountID = 222, itemID = 37598, spellID = 48954 }, -- Swift Zhevra
	{ mountID = 223, itemID = 37676, spellID = 49193 }, -- Vengeful Nether Drake
	{ mountID = 224, itemID = 37719, spellID = 49322 }, -- Swift Zhevra
	{ mountID = 225, itemID = 37827, spellID = 49378 }, -- Brewfest Kodo
	{ mountID = 226, itemID = 37828, spellID = 49379 }, -- Great Brewfest Kodo
	{ mountID = 230, itemID = 38576, spellID = 51412 }, -- Big Battle Bear
};

--
-- Data Initialization
--

do
	local function FilterUnknownRecords(data)
		if data.itemID and not C_Item.DoesItemExistByID(data.itemID) then
			return false;  -- Item not known to client.
		elseif data.spellID and not C_Spell.DoesSpellExist(data.spellID) then
			return false;  -- Spell not known to client.
		else
			return true;
		end
	end

	TRP3_CompanionPetData = tFilter(TRP3_CompanionPetData, FilterUnknownRecords, true);
	TRP3_CompanionMountData = tFilter(TRP3_CompanionMountData, FilterUnknownRecords, true);
end

--
-- Resource Functions
--

do
	local companionPetsByCreatureID = {};
	local companionPetsBySpeciesID = {};
	local companionPetsBySpellID = {};
	local companionMountsByMountID = {};
	local companionMountsBySpellID = {};
	local currentSummonedMountID = IsMounted();
	local previousMountedStatus = nil;
	local rescanSummonedMountID = true;

	do
		local function RequestPreloadData(data)
			if data.itemID then
				C_Item.RequestLoadItemDataByID(data.itemID);
			end

			if data.spellID then
				C_Spell.RequestLoadSpellData(data.spellID);
			end
		end

		for _, petInfo in ipairs(TRP3_CompanionPetData) do
			companionPetsByCreatureID[petInfo.creatureID] = petInfo;
			companionPetsBySpeciesID[petInfo.speciesID] = petInfo;
			companionPetsBySpellID[petInfo.spellID] = petInfo;
			RequestPreloadData(petInfo);
		end

		for _, mountInfo in ipairs(TRP3_CompanionMountData) do
			companionMountsByMountID[mountInfo.mountID] = mountInfo;
			companionMountsBySpellID[mountInfo.spellID] = mountInfo;
			RequestPreloadData(mountInfo);
		end
	end

	function TRP3_API.utils.resources.GetNumPets()
		return #TRP3_CompanionPetData;
	end

	function TRP3_API.utils.resources.GetPetInfoByPetID(petID)
		-- The pet ID as returned by GetPetInfoByIndex is a stringified form
		-- of the species ID.

		local speciesID = tonumber(petID);
		local petInfo = companionPetsBySpeciesID[speciesID];

		if not petInfo then
			return nil;
		end

		local customName = C_Item.GetItemNameByID(petInfo.itemID);
		local level = 1;
		local xp = 1;
		local maxXp = 1;
		local displayID = nil;
		local isFavorite = false;
		local name = customName;
		local icon = C_Item.GetItemIconByID(petInfo.itemID);
		local petType = nil;
		local creatureID = petInfo.creatureID;
		local sourceText = nil;
		local description = GetSpellDescription(petInfo.spellID);
		local isWild = false;
		local canBattle = false;
		local tradable = false;
		local unique = false;
		local obtainable = true;

		return speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable;
	end

	function TRP3_API.utils.resources.GetPetInfoByIndex(petIndex)
		local petInfo = TRP3_CompanionPetData[petIndex];

		if not petInfo then
			return;
		end

		local petID = tostring(petInfo.speciesID);
		local speciesID = petInfo.speciesID;
		local owned = true;
		local customName = C_Item.GetItemNameByID(petInfo.itemID);
		local level = 1;
		local favorite = false;
		local isRevoked = false;
		local speciesName = customName;
		local icon = C_Item.GetItemIconByID(petInfo.itemID);
		local petType = nil;
		local creatureID = petInfo.creatureID;
		local tooltip = nil;
		local description = GetSpellDescription(petInfo.spellID);
		local isWild = false;
		local canBattle = false;
		local isTradeable = false;
		local isUnique = false;
		local obtainable = true;

		return petID, speciesID, owned, customName, level, favorite, isRevoked, speciesName, icon, petType, creatureID, tooltip, description, isWild, canBattle, isTradeable, isUnique, obtainable;
	end

	function TRP3_API.utils.resources.GetPetSpeciesBySpellID(spellID)
		-- Extension API that doesn't correlate to anything in non-Classic clients.
		local petInfo = companionPetsBySpellID[spellID];

		if petInfo then
			return petInfo.speciesID;
		end
	end

	function TRP3_API.utils.resources.GetPetNameByCreatureID(creatureID)
		-- Extension API that doesn't correlate to anything in non-Classic clients.
		local petInfo = companionPetsByCreatureID[creatureID];

		if petInfo then
			return C_Item.GetItemNameByID(petInfo.itemID);
		end
	end

	function TRP3_API.utils.resources.IsPetCreature(creatureID)
		-- Extension API that doesn't correlate to anything in non-Classic clients.
		return companionPetsByCreatureID[creatureID] ~= nil;
	end

	function TRP3_API.utils.resources.GetMountIDs()
		local mountIDs = {};

		for _, mountInfo in ipairs(TRP3_CompanionMountData) do
			if mountInfo.itemID or IsSpellKnown(mountInfo.spellID) then
				table.insert(mountIDs, mountInfo.mountID);
			end
		end

		return mountIDs;
	end

	function TRP3_API.utils.resources.GetMountInfoByID(mountID)
		local mountInfo = companionMountsByMountID[mountID];

		if not mountInfo then
			return;
		end

		local name = (mountInfo.itemID ~= nil) and C_Item.GetItemNameByID(mountInfo.itemID) or GetSpellInfo(mountInfo.spellID);
		local spellID = mountInfo.spellID;
		local icon = (mountInfo.itemID ~= nil) and C_Item.GetItemIconByID(mountInfo.itemID) or GetSpellTexture(mountInfo.spellID);
		local isActive = TRP3_API.utils.resources.GetSummonedMountID() == mountInfo.mountID;
		local isUsable = true;
		local sourceType = nil;
		local isFavorite = false;
		local isFactionSpecific = false;
		local faction = nil;
		local isCollected = (mountInfo.classID == nil or mountInfo.classID == select(2, UnitClassBase("player")));
		local shouldHideOnChar = not isCollected;

		return name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID;
	end

	function TRP3_API.utils.resources.GetMountInfoExtraByID(mountID)
		local mountInfo = companionMountsByMountID[mountID];

		if not mountInfo then
			return;
		end

		local creatureDisplayInfoID = nil;
		local description = GetSpellDescription(mountInfo.spellID);
		local source = nil;
		local isSelfMount = false;
		local mountTypeID = nil;
		local uiModelSceneID = nil;
		local animID = nil;
		local spellVisualKitID = nil;
		local disablePlayerMountPreview = false;

		return creatureDisplayInfoID, description, source, isSelfMount, mountTypeID, uiModelSceneID, animID, spellVisualKitID, disablePlayerMountPreview;
	end

	function TRP3_API.utils.resources.GetSummonedMountID()
		-- Extension API that doesn't correlate to anything in non-Classic clients.

		if not rescanSummonedMountID then
			return currentSummonedMountID;
		end

		local spellID;
		local auraIndex = 0;

		repeat
			auraIndex = auraIndex + 1;
			spellID = select(10, UnitAura("player", auraIndex, "HELPFUL|PLAYER|CANCELABLE"));
		until spellID == nil or companionMountsBySpellID[spellID] ~= nil;

		local mountInfo = companionMountsBySpellID[spellID];

		currentSummonedMountID = mountInfo and mountInfo.mountID or nil;
		rescanSummonedMountID = false;

		return currentSummonedMountID;
	end

	-- Finding the summoned mount is hard work on Classic so we only rescan
	-- when unit auras change for the player.

	TRP3_API.Ellyb.GameEvents.registerCallback("UNIT_AURA", function(unit)
		local currentMountedStatus = IsMounted();
		rescanSummonedMountID = rescanSummonedMountID or (unit == "player") and (previousMountedStatus ~= currentMountedStatus);
		previousMountedStatus = currentMountedStatus;
	end);
end

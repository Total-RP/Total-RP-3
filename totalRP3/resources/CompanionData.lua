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

-- The following static data set can be generated with the below SQL query
-- over a CSV import of the client databases.
--
-- All databases should be for the latest Classic release with the exception
-- of "battlepetspecies" which should be from Retail. This table exists to
-- prune out items and spells that summon critters that aren't actual pets,
-- like the combat companion summons from some Engineering items.
--
-- Note that the source data sets has some duplicate items and spells for
-- Collectors Edition and TCG pets. The GROUP BY clause handles these cases.
--
--    SELECT
--        battlepetspecies.ID AS CritterSpeciesID,
--        battlepetspecies.CreatureID AS CritterCreatureID,
--        spelleffect.SpellID AS CritterSpellID,
--        itemeffect.ParentItemID AS CritterItemID,
--        spellname.Name_lang AS CritterSpellName
--    FROM battlepetspecies
--    INNER JOIN spelleffect ON
--        spelleffect.'EffectMiscValue[0]' = battlepetspecies.CreatureID
--        AND spelleffect.effect = 28
--    INNER JOIN spellname ON
--        spellname.ID = CritterSpellID
--    INNER JOIN itemeffect ON
--        itemeffect.SpellID = CritterSpellID
--    GROUP BY CritterSpeciesID, CritterCreatureID
--    ORDER BY CritterSpeciesID ASC

TRP3_CompanionPetData = C_PetJournal and {} or {
	{ speciesID = 39, creatureID = 2671, spellID = 4055, itemID = 4401 },  -- Mechanical Squirrel
	{ speciesID = 40, creatureID = 7385, spellID = 10673, itemID = 8485 },  -- Bombay Cat
	{ speciesID = 41, creatureID = 7384, spellID = 10674, itemID = 8486 },  -- Cornish Rex Cat
	{ speciesID = 42, creatureID = 7383, spellID = 10675, itemID = 8491 },  -- Black Tabby Cat
	{ speciesID = 43, creatureID = 7382, spellID = 10676, itemID = 8487 },  -- Orange Tabby Cat
	{ speciesID = 44, creatureID = 7380, spellID = 10677, itemID = 8490 },  -- Siamese Cat
	{ speciesID = 45, creatureID = 7381, spellID = 10678, itemID = 8488 },  -- Silver Tabby Cat
	{ speciesID = 46, creatureID = 7386, spellID = 10679, itemID = 8489 },  -- White Kitten
	{ speciesID = 47, creatureID = 7390, spellID = 10680, itemID = 8496 },  -- Cockatiel
	{ speciesID = 49, creatureID = 7391, spellID = 10682, itemID = 8494 },  -- Hyacinth Macaw
	{ speciesID = 50, creatureID = 7387, spellID = 10683, itemID = 8492 },  -- Green Wing Macaw
	{ speciesID = 51, creatureID = 7389, spellID = 10684, itemID = 8495 },  -- Senegal
	{ speciesID = 52, creatureID = 7394, spellID = 10685, itemID = 11023 },  -- Ancona Chicken
	{ speciesID = 55, creatureID = 7395, spellID = 10688, itemID = 10393 },  -- Cockroach
	{ speciesID = 56, creatureID = 7543, spellID = 10695, itemID = 10822 },  -- Dark Whelpling
	{ speciesID = 57, creatureID = 7547, spellID = 10696, itemID = 34535 },  -- Azure Whelpling
	{ speciesID = 58, creatureID = 7544, spellID = 10697, itemID = 8499 },  -- Crimson Whelpling
	{ speciesID = 59, creatureID = 7545, spellID = 10698, itemID = 8498 },  -- Emerald Whelpling
	{ speciesID = 64, creatureID = 7550, spellID = 10703, itemID = 11027 },  -- Wood Frog
	{ speciesID = 65, creatureID = 7549, spellID = 10704, itemID = 11026 },  -- Tree Frog
	{ speciesID = 67, creatureID = 7555, spellID = 10706, itemID = 8501 },  -- Hawk Owl
	{ speciesID = 68, creatureID = 7553, spellID = 10707, itemID = 8500 },  -- Great Horned Owl
	{ speciesID = 70, creatureID = 14421, spellID = 10709, itemID = 10394 },  -- Brown Prairie Dog
	{ speciesID = 72, creatureID = 7560, spellID = 10711, itemID = 8497 },  -- Snowshoe Rabbit
	{ speciesID = 74, creatureID = 7561, spellID = 10713, itemID = 44822 },  -- Albino Snake
	{ speciesID = 75, creatureID = 7565, spellID = 10714, itemID = 10360 },  -- Black Kingsnake
	{ speciesID = 77, creatureID = 7562, spellID = 10716, itemID = 10361 },  -- Brown Snake
	{ speciesID = 78, creatureID = 7567, spellID = 10717, itemID = 10392 },  -- Crimson Snake
	{ speciesID = 83, creatureID = 8376, spellID = 12243, itemID = 10398 },  -- Mechanical Chicken
	{ speciesID = 84, creatureID = 30379, spellID = 13548, itemID = 11110 },  -- Westfall Chicken
	{ speciesID = 85, creatureID = 9656, spellID = 15048, itemID = 11825 },  -- Pet Bombling
	{ speciesID = 86, creatureID = 9657, spellID = 15049, itemID = 11826 },  -- Lil' Smoky
	{ speciesID = 87, creatureID = 9662, spellID = 15067, itemID = 11474 },  -- Sprite Darter Hatchling
	{ speciesID = 89, creatureID = 10259, spellID = 15999, itemID = 12264 },  -- Worg Pup
	{ speciesID = 90, creatureID = 10598, spellID = 16450, itemID = 12529 },  -- Smolderweb Hatchling
	{ speciesID = 92, creatureID = 11325, spellID = 17707, itemID = 13583 },  -- Panda Cub
	{ speciesID = 93, creatureID = 11326, spellID = 17708, itemID = 13584 },  -- Mini Diablo
	{ speciesID = 94, creatureID = 11327, spellID = 17709, itemID = 13582 },  -- Zergling
	{ speciesID = 95, creatureID = 12419, spellID = 19772, itemID = 15996 },  -- Lifelike Toad
	{ speciesID = 106, creatureID = 14878, spellID = 23811, itemID = 19450 },  -- Jubling
	{ speciesID = 107, creatureID = 15186, spellID = 24696, itemID = 20371 },  -- Murky
	{ speciesID = 111, creatureID = 15358, spellID = 24988, itemID = 30360 },  -- Lurky
	{ speciesID = 114, creatureID = 15429, spellID = 25162, itemID = 20769 },  -- Disgusting Oozeling
	{ speciesID = 116, creatureID = 15699, spellID = 26010, itemID = 21277 },  -- Tranquil Mechanical Yeti
	{ speciesID = 117, creatureID = 15710, spellID = 26045, itemID = 21309 },  -- Tiny Snowman
	{ speciesID = 118, creatureID = 15706, spellID = 26529, itemID = 21308 },  -- Winter Reindeer
	{ speciesID = 119, creatureID = 15698, spellID = 26533, itemID = 21301 },  -- Father Winter's Helper
	{ speciesID = 120, creatureID = 15705, spellID = 26541, itemID = 21305 },  -- Winter's Little Helper
	{ speciesID = 121, creatureID = 16069, spellID = 27241, itemID = 22114 },  -- Gurky
	{ speciesID = 122, creatureID = 16085, spellID = 27570, itemID = 22235 },  -- Peddlefeet
	{ speciesID = 124, creatureID = 16456, spellID = 28505, itemID = 22781 },  -- Poley
	{ speciesID = 125, creatureID = 16547, spellID = 28738, itemID = 23002 },  -- Speedy
	{ speciesID = 126, creatureID = 16548, spellID = 28739, itemID = 23007 },  -- Mr. Wiggles
	{ speciesID = 127, creatureID = 16549, spellID = 28740, itemID = 23015 },  -- Whiskers the Rat
	{ speciesID = 128, creatureID = 16701, spellID = 28871, itemID = 23083 },  -- Spirit of Summer
	{ speciesID = 130, creatureID = 17255, spellID = 30156, itemID = 23713 },  -- Hippogryph Hatchling
	{ speciesID = 131, creatureID = 18381, spellID = 32298, itemID = 25535 },  -- Netherwhelp
	{ speciesID = 132, creatureID = 18839, spellID = 33050, itemID = 27445 },  -- Magical Crawdad
	{ speciesID = 136, creatureID = 20408, spellID = 35156, itemID = 29363 },  -- Mana Wyrmling
	{ speciesID = 137, creatureID = 20472, spellID = 35239, itemID = 29364 },  -- Brown Rabbit
	{ speciesID = 138, creatureID = 21010, spellID = 35907, itemID = 29901 },  -- Blue Moth
	{ speciesID = 139, creatureID = 21009, spellID = 35909, itemID = 29902 },  -- Red Moth
	{ speciesID = 140, creatureID = 21008, spellID = 35910, itemID = 29903 },  -- Yellow Moth
	{ speciesID = 141, creatureID = 21018, spellID = 35911, itemID = 29904 },  -- White Moth
	{ speciesID = 142, creatureID = 21055, spellID = 36027, itemID = 29953 },  -- Golden Dragonhawk Hatchling
	{ speciesID = 143, creatureID = 21064, spellID = 36028, itemID = 29956 },  -- Red Dragonhawk Hatchling
	{ speciesID = 144, creatureID = 21063, spellID = 36029, itemID = 29957 },  -- Silver Dragonhawk Hatchling
	{ speciesID = 145, creatureID = 21056, spellID = 36031, itemID = 29958 },  -- Blue Dragonhawk Hatchling
	{ speciesID = 146, creatureID = 21076, spellID = 36034, itemID = 29960 },  -- Firefly
	{ speciesID = 149, creatureID = 22445, spellID = 39181, itemID = 31760 },  -- Miniwing
	{ speciesID = 153, creatureID = 22943, spellID = 39709, itemID = 32233 },  -- Wolpertinger
	{ speciesID = 155, creatureID = 23198, spellID = 40405, itemID = 32498 },  -- Lucky
	{ speciesID = 156, creatureID = 23234, spellID = 40549, itemID = 32588 },  -- Bananas
	{ speciesID = 157, creatureID = 23231, spellID = 40613, itemID = 32617 },  -- Willy
	{ speciesID = 158, creatureID = 23258, spellID = 40614, itemID = 32616 },  -- Egbert
	{ speciesID = 159, creatureID = 23266, spellID = 40634, itemID = 32622 },  -- Peanut
	{ speciesID = 160, creatureID = 23274, spellID = 40990, itemID = 40653 },  -- Stinker
	{ speciesID = 162, creatureID = 23909, spellID = 42609, itemID = 33154 },  -- Sinister Squashling
	{ speciesID = 163, creatureID = 24388, spellID = 43697, itemID = 33816 },  -- Toothy
	{ speciesID = 164, creatureID = 24389, spellID = 43698, itemID = 33818 },  -- Muckbreath
	{ speciesID = 165, creatureID = 24480, spellID = 43918, itemID = 33993 },  -- Mojo
	{ speciesID = 166, creatureID = 24753, spellID = 44369, itemID = 46707 },  -- Pint-Sized Pink Pachyderm
	{ speciesID = 167, creatureID = 25062, spellID = 45082, itemID = 34478 },  -- Tiny Sporebat
	{ speciesID = 168, creatureID = 25109, spellID = 45125, itemID = 34492 },  -- Rocket Chicken
	{ speciesID = 169, creatureID = 25110, spellID = 45127, itemID = 34493 },  -- Dragon Kite
	{ speciesID = 170, creatureID = 25146, spellID = 45174, itemID = 34518 },  -- Golden Pig
	{ speciesID = 171, creatureID = 25147, spellID = 45175, itemID = 34519 },  -- Silver Pig
	{ speciesID = 172, creatureID = 25706, spellID = 45890, itemID = 34955 },  -- Scorchling
	{ speciesID = 173, creatureID = 26050, spellID = 46425, itemID = 35349 },  -- Snarly
	{ speciesID = 174, creatureID = 26056, spellID = 46426, itemID = 35350 },  -- Chuck
	{ speciesID = 175, creatureID = 26119, spellID = 46599, itemID = 35504 },  -- Phoenix Hatchling
	{ speciesID = 179, creatureID = 27217, spellID = 48406, itemID = 37297 },  -- Spirit of Competition
	{ speciesID = 180, creatureID = 27346, spellID = 48408, itemID = 37298 },  -- Essence of Competition
	{ speciesID = 183, creatureID = 27914, spellID = 49964, itemID = 38050 },  -- Ethereal Soul-Trader
	{ speciesID = 186, creatureID = 28470, spellID = 51716, itemID = 38628 },  -- Nether Ray Fry
	{ speciesID = 187, creatureID = 28513, spellID = 51851, itemID = 38658 },  -- Vampiric Batling
	{ speciesID = 188, creatureID = 28883, spellID = 52615, itemID = 39286 },  -- Frosty
	{ speciesID = 189, creatureID = 29089, spellID = 53082, itemID = 39656 },  -- Mini Tyrael
	{ speciesID = 190, creatureID = 29147, spellID = 53316, itemID = 39973 },  -- Ghostly Skull
	{ speciesID = 191, creatureID = 24968, spellID = 54187, itemID = 34425 },  -- Clockwork Rocket Bot
	{ speciesID = 192, creatureID = 29726, spellID = 55068, itemID = 41133 },  -- Mr. Chilly
	{ speciesID = 193, creatureID = 31575, spellID = 59250, itemID = 43698 },  -- Giant Sewer Rat
	{ speciesID = 194, creatureID = 32589, spellID = 61348, itemID = 39896 },  -- Tickbird Hatchling
	{ speciesID = 195, creatureID = 32590, spellID = 61349, itemID = 39899 },  -- White Tickbird Hatchling
	{ speciesID = 196, creatureID = 32592, spellID = 61350, itemID = 44721 },  -- Proto-Drake Whelp
	{ speciesID = 197, creatureID = 32591, spellID = 61351, itemID = 39898 },  -- Cobra Hatchling
	{ speciesID = 198, creatureID = 32595, spellID = 61357, itemID = 44723 },  -- Pengu
	{ speciesID = 199, creatureID = 32643, spellID = 61472, itemID = 44738 },  -- Kirin Tor Familiar
	{ speciesID = 200, creatureID = 32791, spellID = 61725, itemID = 44794 },  -- Spring Rabbit
	{ speciesID = 201, creatureID = 32818, spellID = 61773, itemID = 44810 },  -- Plump Turkey
	{ speciesID = 202, creatureID = 32841, spellID = 61855, itemID = 44819 },  -- Baby Blizzard Bear
	{ speciesID = 203, creatureID = 32939, spellID = 61991, itemID = 44841 },  -- Little Fawn
	{ speciesID = 204, creatureID = 33188, spellID = 62491, itemID = 44965 },  -- Teldrassil Sproutling
	{ speciesID = 205, creatureID = 33194, spellID = 62508, itemID = 44970 },  -- Dun Morogh Cub
	{ speciesID = 206, creatureID = 33197, spellID = 62510, itemID = 44971 },  -- Tirisfal Batling
	{ speciesID = 207, creatureID = 33198, spellID = 62513, itemID = 44973 },  -- Durotar Scorpion
	{ speciesID = 209, creatureID = 33200, spellID = 62516, itemID = 44974 },  -- Elwynn Lamb
	{ speciesID = 210, creatureID = 33219, spellID = 62542, itemID = 44980 },  -- Mulgore Hatchling
	{ speciesID = 211, creatureID = 33226, spellID = 62561, itemID = 44983 },  -- Strand Crawler
	{ speciesID = 212, creatureID = 33205, spellID = 62562, itemID = 44984 },  -- Ammen Vale Lashling
	{ speciesID = 213, creatureID = 33227, spellID = 62564, itemID = 44982 },  -- Enchanted Broom
	{ speciesID = 214, creatureID = 33238, spellID = 62609, itemID = 44998 },  -- Argent Squire
	{ speciesID = 215, creatureID = 33274, spellID = 62674, itemID = 45002 },  -- Mechanopeep
	{ speciesID = 216, creatureID = 33239, spellID = 62746, itemID = 45022 },  -- Argent Gruntling
	{ speciesID = 217, creatureID = 33578, spellID = 63318, itemID = 45180 },  -- Murkimus the Gladiator
	{ speciesID = 218, creatureID = 33810, spellID = 63712, itemID = 45606 },  -- Sen'jin Fetish
	{ speciesID = 224, creatureID = 34364, spellID = 65358, itemID = 46398 },  -- Calico Cat
	{ speciesID = 225, creatureID = 33530, spellID = 65381, itemID = 46545 },  -- Curious Oracle Hatchling
	{ speciesID = 226, creatureID = 33529, spellID = 65382, itemID = 46544 },  -- Curious Wolvar Pup
	{ speciesID = 227, creatureID = 34587, spellID = 65682, itemID = 46767 },  -- Warbot
	{ speciesID = 228, creatureID = 34694, spellID = 66030, itemID = 46802 },  -- Grunty
	{ speciesID = 229, creatureID = 34724, spellID = 66096, itemID = 46820 },  -- Shimmering Wyrmling
	{ speciesID = 231, creatureID = 34930, spellID = 66520, itemID = 46894 },  -- Jade Tiger
	{ speciesID = 232, creatureID = 35396, spellID = 67413, itemID = 48112 },  -- Darting Hatchling
	{ speciesID = 233, creatureID = 35395, spellID = 67414, itemID = 48114 },  -- Deviate Hatchling
	{ speciesID = 234, creatureID = 35400, spellID = 67415, itemID = 48116 },  -- Gundrak Hatchling
	{ speciesID = 235, creatureID = 35387, spellID = 67416, itemID = 48118 },  -- Leaping Hatchling
	{ speciesID = 236, creatureID = 35399, spellID = 67417, itemID = 48120 },  -- Obsidian Hatchling
	{ speciesID = 237, creatureID = 35397, spellID = 67418, itemID = 48122 },  -- Ravasaur Hatchling
	{ speciesID = 238, creatureID = 35398, spellID = 67419, itemID = 48124 },  -- Razormaw Hatchling
	{ speciesID = 239, creatureID = 35394, spellID = 67420, itemID = 48126 },  -- Razzashi Hatchling
	{ speciesID = 240, creatureID = 35468, spellID = 67527, itemID = 48527 },  -- Onyx Panther
	{ speciesID = 241, creatureID = 36482, spellID = 68767, itemID = 49287 },  -- Tuskarr Kite
	{ speciesID = 242, creatureID = 36511, spellID = 68810, itemID = 49343 },  -- Spectral Tiger Cub
	{ speciesID = 243, creatureID = 36607, spellID = 69002, itemID = 49362 },  -- Onyxian Whelpling
	{ speciesID = 244, creatureID = 36871, spellID = 69452, itemID = 49646 },  -- Core Hound Pup
	{ speciesID = 245, creatureID = 36908, spellID = 69535, itemID = 49662 },  -- Gryphon Hatchling
	{ speciesID = 246, creatureID = 36909, spellID = 69536, itemID = 49663 },  -- Wind Rider Cub
	{ speciesID = 247, creatureID = 36910, spellID = 69539, itemID = 49664 },  -- Zipao Tiger
	{ speciesID = 248, creatureID = 36911, spellID = 69541, itemID = 49665 },  -- Pandaren Monk
	{ speciesID = 249, creatureID = 36979, spellID = 69677, itemID = 49693 },  -- Lil' K.T.
	{ speciesID = 250, creatureID = 37865, spellID = 70613, itemID = 49912 },  -- Perky Pug
	{ speciesID = 251, creatureID = 38374, spellID = 71840, itemID = 50446 },  -- Toxic Wasteling
	{ speciesID = 253, creatureID = 40198, spellID = 74932, itemID = 53641 },  -- Frigid Frostling
	{ speciesID = 254, creatureID = 40295, spellID = 75134, itemID = 54436 },  -- Blue Clockwork Rocket Bot
	{ speciesID = 255, creatureID = 40624, spellID = 75613, itemID = 54810 },  -- Celestial Dragon
	{ speciesID = 256, creatureID = 40703, spellID = 75906, itemID = 54847 },  -- Lil' XT
	{ speciesID = 257, creatureID = 40721, spellID = 75936, itemID = 54857 },  -- Murkimus the Gladiator
	{ speciesID = 258, creatureID = 42078, spellID = 78381, itemID = 56806 },  -- Mini Thor
	{ speciesID = 757, creatureID = 14755, spellID = 23531, itemID = 19055 },  -- Tiny Green Dragon
	{ speciesID = 758, creatureID = 14756, spellID = 23530, itemID = 19054 },  -- Tiny Red Dragon
	{ speciesID = 1073, creatureID = 16445, spellID = 28487, itemID = 22780 },  -- Terky
	{ speciesID = 1168, creatureID = 15361, spellID = 25018, itemID = 20651 },  -- Murki
	{ speciesID = 1351, creatureID = 34770, spellID = 66175, itemID = 46831 },  -- Macabre Marionette
	{ speciesID = 1927, creatureID = 17254, spellID = 30152, itemID = 23712 },  -- White Tiger Cub
};

-- The following static data set can be generated with the below SQL query
-- over a CSV import of the client databases.
--
-- All databases should be for the latest Classic release with the exception
-- of "mount" which should be from Retail. Note that getting accurate mount
-- data is... tricky due to the nature of class-specific mounts not having
-- source items, and a lot of mounts not actually being implemented.
--
--     SELECT
--         mount.ID AS MountID,
--         mount.SourceSpellID AS MountSpellID,
--         CASE
--             WHEN spellmisc.'Attributes[7]' & 0x100 THEN "Horde"
--             WHEN spellmisc.'Attributes[7]' & 0x200 THEN "Alliance"
--             ELSE NULL
--         END AS MountFactionGroup,
--         spellname.Name_lang AS MountSpellName
--     FROM mount
--     INNER JOIN spelleffect ON
--         spelleffect.SpellID = mount.SourceSpellID
--         AND spelleffect.effect = 6
--         AND spelleffect.effectaura = 78
--     INNER JOIN spellmisc ON
--         spellmisc.SpellID = MountSpellID
--     INNER JOIN spellname ON
--         spellname.ID = MountSpellID
--     WHERE
--         mount.Description_lang != ""
--         AND (
--             MountSpellID IN (SELECT spelllevels.SpellID FROM spelllevels WHERE spelllevels.BaseLevel > 0)
--             OR MountSpellID IN (SELECT itemeffect.SpellID FROM itemeffect)
--         )
--     ORDER BY MountID ASC

TRP3_CompanionMountData = C_MountJournal and {} or {
	{ mountID = 6, spellID = 458, factionGroup = nil },  -- Brown Horse
	{ mountID = 7, spellID = 459, factionGroup = nil },  -- Gray Wolf
	{ mountID = 8, spellID = 468, factionGroup = nil },  -- White Stallion
	{ mountID = 9, spellID = 470, factionGroup = nil },  -- Black Stallion
	{ mountID = 11, spellID = 472, factionGroup = nil },  -- Pinto
	{ mountID = 12, spellID = 578, factionGroup = nil },  -- Black Wolf
	{ mountID = 13, spellID = 579, factionGroup = nil },  -- Red Wolf
	{ mountID = 14, spellID = 580, factionGroup = nil },  -- Timber Wolf
	{ mountID = 15, spellID = 581, factionGroup = nil },  -- Winter Wolf
	{ mountID = 17, spellID = 5784, factionGroup = nil },  -- Felsteed
	{ mountID = 18, spellID = 6648, factionGroup = nil },  -- Chestnut Mare
	{ mountID = 19, spellID = 6653, factionGroup = nil },  -- Dire Wolf
	{ mountID = 20, spellID = 6654, factionGroup = nil },  -- Brown Wolf
	{ mountID = 21, spellID = 6777, factionGroup = nil },  -- Gray Ram
	{ mountID = 22, spellID = 6896, factionGroup = nil },  -- Black Ram
	{ mountID = 24, spellID = 6898, factionGroup = nil },  -- White Ram
	{ mountID = 25, spellID = 6899, factionGroup = nil },  -- Brown Ram
	{ mountID = 26, spellID = 8394, factionGroup = nil },  -- Striped Frostsaber
	{ mountID = 27, spellID = 8395, factionGroup = nil },  -- Emerald Raptor
	{ mountID = 28, spellID = 8980, factionGroup = nil },  -- Skeletal Horse
	{ mountID = 31, spellID = 10789, factionGroup = nil },  -- Spotted Frostsaber
	{ mountID = 34, spellID = 10793, factionGroup = nil },  -- Striped Nightsaber
	{ mountID = 35, spellID = 10795, factionGroup = nil },  -- Ivory Raptor
	{ mountID = 36, spellID = 10796, factionGroup = nil },  -- Turquoise Raptor
	{ mountID = 38, spellID = 10799, factionGroup = nil },  -- Violet Raptor
	{ mountID = 39, spellID = 10873, factionGroup = nil },  -- Red Mechanostrider
	{ mountID = 40, spellID = 10969, factionGroup = nil },  -- Blue Mechanostrider
	{ mountID = 41, spellID = 13819, factionGroup = "Alliance" },  -- Warhorse
	{ mountID = 42, spellID = 15779, factionGroup = nil },  -- White Mechanostrider Mod B
	{ mountID = 45, spellID = 16055, factionGroup = nil },  -- Black Nightsaber
	{ mountID = 46, spellID = 16056, factionGroup = nil },  -- Ancient Frostsaber
	{ mountID = 50, spellID = 16080, factionGroup = nil },  -- Red Wolf
	{ mountID = 51, spellID = 16081, factionGroup = nil },  -- Winter Wolf
	{ mountID = 52, spellID = 16082, factionGroup = nil },  -- Palomino
	{ mountID = 53, spellID = 16083, factionGroup = nil },  -- White Stallion
	{ mountID = 54, spellID = 16084, factionGroup = nil },  -- Mottled Red Raptor
	{ mountID = 55, spellID = 17229, factionGroup = "Alliance" },  -- Winterspring Frostsaber
	{ mountID = 56, spellID = 17450, factionGroup = nil },  -- Ivory Raptor
	{ mountID = 57, spellID = 17453, factionGroup = nil },  -- Green Mechanostrider
	{ mountID = 58, spellID = 17454, factionGroup = nil },  -- Unpainted Mechanostrider
	{ mountID = 62, spellID = 17459, factionGroup = nil },  -- Icy Blue Mechanostrider Mod A
	{ mountID = 63, spellID = 17460, factionGroup = nil },  -- Frost Ram
	{ mountID = 64, spellID = 17461, factionGroup = nil },  -- Black Ram
	{ mountID = 65, spellID = 17462, factionGroup = nil },  -- Red Skeletal Horse
	{ mountID = 66, spellID = 17463, factionGroup = nil },  -- Blue Skeletal Horse
	{ mountID = 67, spellID = 17464, factionGroup = nil },  -- Brown Skeletal Horse
	{ mountID = 68, spellID = 17465, factionGroup = nil },  -- Green Skeletal Warhorse
	{ mountID = 69, spellID = 17481, factionGroup = nil },  -- Rivendare's Deathcharger
	{ mountID = 70, spellID = 18363, factionGroup = nil },  -- Riding Kodo
	{ mountID = 71, spellID = 18989, factionGroup = nil },  -- Gray Kodo
	{ mountID = 72, spellID = 18990, factionGroup = nil },  -- Brown Kodo
	{ mountID = 73, spellID = 18991, factionGroup = nil },  -- Green Kodo
	{ mountID = 74, spellID = 18992, factionGroup = nil },  -- Teal Kodo
	{ mountID = 75, spellID = 22717, factionGroup = nil },  -- Black War Steed
	{ mountID = 76, spellID = 22718, factionGroup = nil },  -- Black War Kodo
	{ mountID = 77, spellID = 22719, factionGroup = nil },  -- Black Battlestrider
	{ mountID = 78, spellID = 22720, factionGroup = nil },  -- Black War Ram
	{ mountID = 79, spellID = 22721, factionGroup = nil },  -- Black War Raptor
	{ mountID = 80, spellID = 22722, factionGroup = nil },  -- Red Skeletal Warhorse
	{ mountID = 81, spellID = 22723, factionGroup = nil },  -- Black War Tiger
	{ mountID = 82, spellID = 22724, factionGroup = nil },  -- Black War Wolf
	{ mountID = 83, spellID = 23161, factionGroup = nil },  -- Dreadsteed
	{ mountID = 84, spellID = 23214, factionGroup = "Alliance" },  -- Charger
	{ mountID = 85, spellID = 23219, factionGroup = nil },  -- Swift Mistsaber
	{ mountID = 87, spellID = 23221, factionGroup = nil },  -- Swift Frostsaber
	{ mountID = 88, spellID = 23222, factionGroup = nil },  -- Swift Yellow Mechanostrider
	{ mountID = 89, spellID = 23223, factionGroup = nil },  -- Swift White Mechanostrider
	{ mountID = 90, spellID = 23225, factionGroup = nil },  -- Swift Green Mechanostrider
	{ mountID = 91, spellID = 23227, factionGroup = nil },  -- Swift Palomino
	{ mountID = 92, spellID = 23228, factionGroup = nil },  -- Swift White Steed
	{ mountID = 93, spellID = 23229, factionGroup = nil },  -- Swift Brown Steed
	{ mountID = 94, spellID = 23238, factionGroup = nil },  -- Swift Brown Ram
	{ mountID = 95, spellID = 23239, factionGroup = nil },  -- Swift Gray Ram
	{ mountID = 96, spellID = 23240, factionGroup = nil },  -- Swift White Ram
	{ mountID = 97, spellID = 23241, factionGroup = nil },  -- Swift Blue Raptor
	{ mountID = 98, spellID = 23242, factionGroup = nil },  -- Swift Olive Raptor
	{ mountID = 99, spellID = 23243, factionGroup = nil },  -- Swift Orange Raptor
	{ mountID = 100, spellID = 23246, factionGroup = nil },  -- Purple Skeletal Warhorse
	{ mountID = 101, spellID = 23247, factionGroup = nil },  -- Great White Kodo
	{ mountID = 102, spellID = 23248, factionGroup = nil },  -- Great Gray Kodo
	{ mountID = 103, spellID = 23249, factionGroup = nil },  -- Great Brown Kodo
	{ mountID = 104, spellID = 23250, factionGroup = nil },  -- Swift Brown Wolf
	{ mountID = 105, spellID = 23251, factionGroup = nil },  -- Swift Timber Wolf
	{ mountID = 106, spellID = 23252, factionGroup = nil },  -- Swift Gray Wolf
	{ mountID = 107, spellID = 23338, factionGroup = nil },  -- Swift Stormsaber
	{ mountID = 108, spellID = 23509, factionGroup = "Horde" },  -- Frostwolf Howler
	{ mountID = 109, spellID = 23510, factionGroup = "Alliance" },  -- Stormpike Battle Charger
	{ mountID = 110, spellID = 24242, factionGroup = nil },  -- Swift Razzashi Raptor
	{ mountID = 111, spellID = 24252, factionGroup = nil },  -- Swift Zulian Tiger
	{ mountID = 117, spellID = 25953, factionGroup = nil },  -- Blue Qiraji Battle Tank
	{ mountID = 118, spellID = 26054, factionGroup = nil },  -- Red Qiraji Battle Tank
	{ mountID = 119, spellID = 26055, factionGroup = nil },  -- Yellow Qiraji Battle Tank
	{ mountID = 120, spellID = 26056, factionGroup = nil },  -- Green Qiraji Battle Tank
	{ mountID = 122, spellID = 26656, factionGroup = nil },  -- Black Qiraji Battle Tank
	{ mountID = 125, spellID = 30174, factionGroup = nil },  -- Riding Turtle
	{ mountID = 129, spellID = 32235, factionGroup = "Alliance" },  -- Golden Gryphon
	{ mountID = 130, spellID = 32239, factionGroup = "Alliance" },  -- Ebon Gryphon
	{ mountID = 131, spellID = 32240, factionGroup = "Alliance" },  -- Snowy Gryphon
	{ mountID = 132, spellID = 32242, factionGroup = "Alliance" },  -- Swift Blue Gryphon
	{ mountID = 133, spellID = 32243, factionGroup = "Horde" },  -- Tawny Wind Rider
	{ mountID = 134, spellID = 32244, factionGroup = "Horde" },  -- Blue Wind Rider
	{ mountID = 135, spellID = 32245, factionGroup = "Horde" },  -- Green Wind Rider
	{ mountID = 136, spellID = 32246, factionGroup = "Horde" },  -- Swift Red Wind Rider
	{ mountID = 137, spellID = 32289, factionGroup = "Alliance" },  -- Swift Red Gryphon
	{ mountID = 138, spellID = 32290, factionGroup = "Alliance" },  -- Swift Green Gryphon
	{ mountID = 139, spellID = 32292, factionGroup = "Alliance" },  -- Swift Purple Gryphon
	{ mountID = 140, spellID = 32295, factionGroup = "Horde" },  -- Swift Green Wind Rider
	{ mountID = 141, spellID = 32296, factionGroup = "Horde" },  -- Swift Yellow Wind Rider
	{ mountID = 142, spellID = 32297, factionGroup = "Horde" },  -- Swift Purple Wind Rider
	{ mountID = 146, spellID = 33660, factionGroup = nil },  -- Swift Pink Hawkstrider
	{ mountID = 147, spellID = 34406, factionGroup = nil },  -- Brown Elekk
	{ mountID = 149, spellID = 34767, factionGroup = "Horde" },  -- Summon Charger
	{ mountID = 150, spellID = 34769, factionGroup = "Horde" },  -- Summon Warhorse
	{ mountID = 151, spellID = 34790, factionGroup = nil },  -- Dark War Talbuk
	{ mountID = 152, spellID = 34795, factionGroup = nil },  -- Red Hawkstrider
	{ mountID = 153, spellID = 34896, factionGroup = nil },  -- Cobalt War Talbuk
	{ mountID = 154, spellID = 34897, factionGroup = nil },  -- White War Talbuk
	{ mountID = 155, spellID = 34898, factionGroup = nil },  -- Silver War Talbuk
	{ mountID = 156, spellID = 34899, factionGroup = nil },  -- Tan War Talbuk
	{ mountID = 157, spellID = 35018, factionGroup = nil },  -- Purple Hawkstrider
	{ mountID = 158, spellID = 35020, factionGroup = nil },  -- Blue Hawkstrider
	{ mountID = 159, spellID = 35022, factionGroup = nil },  -- Black Hawkstrider
	{ mountID = 160, spellID = 35025, factionGroup = nil },  -- Swift Green Hawkstrider
	{ mountID = 161, spellID = 35027, factionGroup = nil },  -- Swift Purple Hawkstrider
	{ mountID = 162, spellID = 35028, factionGroup = nil },  -- Swift Warstrider
	{ mountID = 163, spellID = 35710, factionGroup = nil },  -- Gray Elekk
	{ mountID = 164, spellID = 35711, factionGroup = nil },  -- Purple Elekk
	{ mountID = 165, spellID = 35712, factionGroup = nil },  -- Great Green Elekk
	{ mountID = 166, spellID = 35713, factionGroup = nil },  -- Great Blue Elekk
	{ mountID = 167, spellID = 35714, factionGroup = nil },  -- Great Purple Elekk
	{ mountID = 168, spellID = 36702, factionGroup = nil },  -- Fiery Warhorse
	{ mountID = 169, spellID = 37015, factionGroup = nil },  -- Swift Nether Drake
	{ mountID = 170, spellID = 39315, factionGroup = nil },  -- Cobalt Riding Talbuk
	{ mountID = 171, spellID = 39316, factionGroup = nil },  -- Dark Riding Talbuk
	{ mountID = 172, spellID = 39317, factionGroup = nil },  -- Silver Riding Talbuk
	{ mountID = 173, spellID = 39318, factionGroup = nil },  -- Tan Riding Talbuk
	{ mountID = 174, spellID = 39319, factionGroup = nil },  -- White Riding Talbuk
	{ mountID = 176, spellID = 39798, factionGroup = nil },  -- Green Riding Nether Ray
	{ mountID = 177, spellID = 39800, factionGroup = nil },  -- Red Riding Nether Ray
	{ mountID = 178, spellID = 39801, factionGroup = nil },  -- Purple Riding Nether Ray
	{ mountID = 179, spellID = 39802, factionGroup = nil },  -- Silver Riding Nether Ray
	{ mountID = 180, spellID = 39803, factionGroup = nil },  -- Blue Riding Nether Ray
	{ mountID = 183, spellID = 40192, factionGroup = nil },  -- Ashes of Al'ar
	{ mountID = 185, spellID = 41252, factionGroup = nil },  -- Raven Lord
	{ mountID = 186, spellID = 41513, factionGroup = nil },  -- Onyx Netherwing Drake
	{ mountID = 187, spellID = 41514, factionGroup = nil },  -- Azure Netherwing Drake
	{ mountID = 188, spellID = 41515, factionGroup = nil },  -- Cobalt Netherwing Drake
	{ mountID = 189, spellID = 41516, factionGroup = nil },  -- Purple Netherwing Drake
	{ mountID = 190, spellID = 41517, factionGroup = nil },  -- Veridian Netherwing Drake
	{ mountID = 191, spellID = 41518, factionGroup = nil },  -- Violet Netherwing Drake
	{ mountID = 196, spellID = 42776, factionGroup = nil },  -- Spectral Tiger
	{ mountID = 197, spellID = 42777, factionGroup = nil },  -- Swift Spectral Tiger
	{ mountID = 199, spellID = 43688, factionGroup = nil },  -- Amani War Bear
	{ mountID = 201, spellID = 43899, factionGroup = nil },  -- Brewfest Ram
	{ mountID = 202, spellID = 43900, factionGroup = nil },  -- Swift Brewfest Ram
	{ mountID = 203, spellID = 43927, factionGroup = nil },  -- Cenarion War Hippogryph
	{ mountID = 204, spellID = 44151, factionGroup = nil },  -- Turbo-Charged Flying Machine
	{ mountID = 205, spellID = 44153, factionGroup = nil },  -- Flying Machine
	{ mountID = 207, spellID = 44744, factionGroup = nil },  -- Merciless Nether Drake
	{ mountID = 211, spellID = 46197, factionGroup = nil },  -- X-51 Nether-Rocket
	{ mountID = 212, spellID = 46199, factionGroup = nil },  -- X-51 Nether-Rocket X-TREME
	{ mountID = 213, spellID = 46628, factionGroup = nil },  -- Swift White Hawkstrider
	{ mountID = 219, spellID = 48025, factionGroup = nil },  -- Headless Horseman's Mount
	{ mountID = 220, spellID = 48027, factionGroup = nil },  -- Black War Elekk
	{ mountID = 221, spellID = 48778, factionGroup = nil },  -- Acherus Deathcharger
	{ mountID = 222, spellID = 48954, factionGroup = nil },  -- Swift Zhevra
	{ mountID = 223, spellID = 49193, factionGroup = nil },  -- Vengeful Nether Drake
	{ mountID = 224, spellID = 49322, factionGroup = nil },  -- Swift Zhevra
	{ mountID = 225, spellID = 49378, factionGroup = nil },  -- Brewfest Riding Kodo
	{ mountID = 226, spellID = 49379, factionGroup = nil },  -- Great Brewfest Kodo
	{ mountID = 230, spellID = 51412, factionGroup = nil },  -- Big Battle Bear
	{ mountID = 236, spellID = 54729, factionGroup = nil },  -- Winged Steed of the Ebon Blade
	{ mountID = 237, spellID = 54753, factionGroup = nil },  -- White Polar Bear
	{ mountID = 240, spellID = 55531, factionGroup = "Horde" },  -- Mechano-hog
	{ mountID = 241, spellID = 58615, factionGroup = nil },  -- Brutal Nether Drake
	{ mountID = 243, spellID = 58983, factionGroup = nil },  -- Big Blizzard Bear
	{ mountID = 246, spellID = 59567, factionGroup = nil },  -- Azure Drake
	{ mountID = 247, spellID = 59568, factionGroup = nil },  -- Blue Drake
	{ mountID = 248, spellID = 59569, factionGroup = nil },  -- Bronze Drake
	{ mountID = 249, spellID = 59570, factionGroup = nil },  -- Red Drake
	{ mountID = 250, spellID = 59571, factionGroup = nil },  -- Twilight Drake
	{ mountID = 251, spellID = 59572, factionGroup = nil },  -- Black Polar Bear
	{ mountID = 253, spellID = 59650, factionGroup = nil },  -- Black Drake
	{ mountID = 254, spellID = 59785, factionGroup = "Alliance" },  -- Black War Mammoth
	{ mountID = 255, spellID = 59788, factionGroup = "Horde" },  -- Black War Mammoth
	{ mountID = 256, spellID = 59791, factionGroup = nil },  -- Wooly Mammoth
	{ mountID = 257, spellID = 59793, factionGroup = nil },  -- Wooly Mammoth
	{ mountID = 258, spellID = 59797, factionGroup = "Horde" },  -- Ice Mammoth
	{ mountID = 259, spellID = 59799, factionGroup = "Alliance" },  -- Ice Mammoth
	{ mountID = 262, spellID = 59961, factionGroup = nil },  -- Red Proto-Drake
	{ mountID = 263, spellID = 59976, factionGroup = nil },  -- Black Proto-Drake
	{ mountID = 264, spellID = 59996, factionGroup = nil },  -- Blue Proto-Drake
	{ mountID = 265, spellID = 60002, factionGroup = nil },  -- Time-Lost Proto-Drake
	{ mountID = 266, spellID = 60021, factionGroup = nil },  -- Plagued Proto-Drake
	{ mountID = 267, spellID = 60024, factionGroup = nil },  -- Violet Proto-Drake
	{ mountID = 268, spellID = 60025, factionGroup = nil },  -- Albino Drake
	{ mountID = 269, spellID = 60114, factionGroup = "Alliance" },  -- Armored Brown Bear
	{ mountID = 270, spellID = 60116, factionGroup = "Horde" },  -- Armored Brown Bear
	{ mountID = 271, spellID = 60118, factionGroup = "Alliance" },  -- Black War Bear
	{ mountID = 272, spellID = 60119, factionGroup = "Horde" },  -- Black War Bear
	{ mountID = 275, spellID = 60424, factionGroup = "Alliance" },  -- Mekgineer's Chopper
	{ mountID = 276, spellID = 61229, factionGroup = "Alliance" },  -- Armored Snowy Gryphon
	{ mountID = 277, spellID = 61230, factionGroup = "Horde" },  -- Armored Blue Wind Rider
	{ mountID = 278, spellID = 61294, factionGroup = nil },  -- Green Proto-Drake
	{ mountID = 279, spellID = 61309, factionGroup = nil },  -- Magnificent Flying Carpet
	{ mountID = 280, spellID = 61425, factionGroup = "Alliance" },  -- Traveler's Tundra Mammoth
	{ mountID = 284, spellID = 61447, factionGroup = "Horde" },  -- Traveler's Tundra Mammoth
	{ mountID = 285, spellID = 61451, factionGroup = nil },  -- Flying Carpet
	{ mountID = 286, spellID = 61465, factionGroup = "Alliance" },  -- Grand Black War Mammoth
	{ mountID = 287, spellID = 61467, factionGroup = "Horde" },  -- Grand Black War Mammoth
	{ mountID = 288, spellID = 61469, factionGroup = "Horde" },  -- Grand Ice Mammoth
	{ mountID = 289, spellID = 61470, factionGroup = "Alliance" },  -- Grand Ice Mammoth
	{ mountID = 291, spellID = 61996, factionGroup = "Alliance" },  -- Blue Dragonhawk
	{ mountID = 292, spellID = 61997, factionGroup = "Horde" },  -- Red Dragonhawk
	{ mountID = 293, spellID = 62048, factionGroup = nil },  -- Black Dragonhawk Mount
	{ mountID = 294, spellID = 63232, factionGroup = nil },  -- Stormwind Steed
	{ mountID = 295, spellID = 63635, factionGroup = nil },  -- Darkspear Raptor
	{ mountID = 296, spellID = 63636, factionGroup = nil },  -- Ironforge Ram
	{ mountID = 297, spellID = 63637, factionGroup = nil },  -- Darnassian Nightsaber
	{ mountID = 298, spellID = 63638, factionGroup = nil },  -- Gnomeregan Mechanostrider
	{ mountID = 299, spellID = 63639, factionGroup = nil },  -- Exodar Elekk
	{ mountID = 300, spellID = 63640, factionGroup = nil },  -- Orgrimmar Wolf
	{ mountID = 301, spellID = 63641, factionGroup = nil },  -- Thunder Bluff Kodo
	{ mountID = 302, spellID = 63642, factionGroup = nil },  -- Silvermoon Hawkstrider
	{ mountID = 303, spellID = 63643, factionGroup = nil },  -- Forsaken Warhorse
	{ mountID = 304, spellID = 63796, factionGroup = nil },  -- Mimiron's Head
	{ mountID = 305, spellID = 63844, factionGroup = nil },  -- Argent Hippogryph
	{ mountID = 306, spellID = 63956, factionGroup = nil },  -- Ironbound Proto-Drake
	{ mountID = 307, spellID = 63963, factionGroup = nil },  -- Rusted Proto-Drake
	{ mountID = 308, spellID = 64656, factionGroup = nil },  -- Blue Skeletal Warhorse
	{ mountID = 309, spellID = 64657, factionGroup = nil },  -- White Kodo
	{ mountID = 310, spellID = 64658, factionGroup = nil },  -- Black Wolf
	{ mountID = 311, spellID = 64659, factionGroup = "Horde" },  -- Venomhide Ravasaur
	{ mountID = 312, spellID = 64731, factionGroup = nil },  -- Sea Turtle
	{ mountID = 313, spellID = 64927, factionGroup = nil },  -- Deadly Gladiator's Frost Wyrm
	{ mountID = 314, spellID = 64977, factionGroup = nil },  -- Black Skeletal Horse
	{ mountID = 317, spellID = 65439, factionGroup = nil },  -- Furious Gladiator's Frost Wyrm
	{ mountID = 318, spellID = 65637, factionGroup = nil },  -- Great Red Elekk
	{ mountID = 319, spellID = 65638, factionGroup = nil },  -- Swift Moonsaber
	{ mountID = 320, spellID = 65639, factionGroup = nil },  -- Swift Red Hawkstrider
	{ mountID = 321, spellID = 65640, factionGroup = nil },  -- Swift Gray Steed
	{ mountID = 322, spellID = 65641, factionGroup = nil },  -- Great Golden Kodo
	{ mountID = 323, spellID = 65642, factionGroup = nil },  -- Turbostrider
	{ mountID = 324, spellID = 65643, factionGroup = nil },  -- Swift Violet Ram
	{ mountID = 325, spellID = 65644, factionGroup = nil },  -- Swift Purple Raptor
	{ mountID = 326, spellID = 65645, factionGroup = nil },  -- White Skeletal Warhorse
	{ mountID = 327, spellID = 65646, factionGroup = nil },  -- Swift Burgundy Wolf
	{ mountID = 328, spellID = 65917, factionGroup = nil },  -- Magic Rooster
	{ mountID = 329, spellID = 66087, factionGroup = "Alliance" },  -- Silver Covenant Hippogryph
	{ mountID = 330, spellID = 66088, factionGroup = "Horde" },  -- Sunreaver Dragonhawk
	{ mountID = 331, spellID = 66090, factionGroup = "Alliance" },  -- Quel'dorei Steed
	{ mountID = 332, spellID = 66091, factionGroup = "Horde" },  -- Sunreaver Hawkstrider
	{ mountID = 336, spellID = 66846, factionGroup = nil },  -- Ochre Skeletal Warhorse
	{ mountID = 337, spellID = 66847, factionGroup = nil },  -- Striped Dawnsaber
	{ mountID = 338, spellID = 66906, factionGroup = nil },  -- Argent Charger
	{ mountID = 340, spellID = 67336, factionGroup = nil },  -- Relentless Gladiator's Frost Wyrm
	{ mountID = 341, spellID = 67466, factionGroup = nil },  -- Argent Warhorse
	{ mountID = 342, spellID = 68056, factionGroup = "Horde" },  -- Swift Horde Wolf
	{ mountID = 343, spellID = 68057, factionGroup = "Alliance" },  -- Swift Alliance Steed
	{ mountID = 344, spellID = 68187, factionGroup = "Alliance" },  -- Crusader's White Warhorse
	{ mountID = 345, spellID = 68188, factionGroup = "Horde" },  -- Crusader's Black Warhorse
	{ mountID = 349, spellID = 69395, factionGroup = nil },  -- Onyxian Drake
	{ mountID = 352, spellID = 71342, factionGroup = nil },  -- X-45 Heartbreaker
	{ mountID = 358, spellID = 71810, factionGroup = nil },  -- Wrathful Gladiator's Frost Wyrm
	{ mountID = 363, spellID = 72286, factionGroup = nil },  -- Invincible
	{ mountID = 364, spellID = 72807, factionGroup = nil },  -- Icebound Frostbrood Vanquisher
	{ mountID = 365, spellID = 72808, factionGroup = nil },  -- Bloodbathed Frostbrood Vanquisher
	{ mountID = 366, spellID = 73313, factionGroup = nil },  -- Crimson Deathcharger
	{ mountID = 371, spellID = 74856, factionGroup = nil },  -- Blazing Hippogryph
	{ mountID = 372, spellID = 74918, factionGroup = nil },  -- Wooly White Rhino
	{ mountID = 375, spellID = 75596, factionGroup = nil },  -- Frosty Flying Carpet
	{ mountID = 376, spellID = 75614, factionGroup = nil },  -- Celestial Steed
	{ mountID = 382, spellID = 75973, factionGroup = nil },  -- X-53 Touring Rocket
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

	local function GetPetName(petInfo)
		local name;

		-- From Wrath onwards we prefer the spell name as this matches what
		-- is actually shown in the companions UI.

		if LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_BURNING_CRUSADE then
			name = C_Item.GetItemNameByID(petInfo.itemID);
		else
			name = GetSpellInfo(petInfo.spellID);
		end

		return name;
	end

	local function GetPetIcon(petInfo)
		local icon;

		if LE_EXPANSION_LEVEL_CURRENT <= LE_EXPANSION_BURNING_CRUSADE then
			icon = C_Item.GetItemIconByID(petInfo.itemID);
		else
			icon = GetSpellTexture(petInfo.spellID);
		end

		return icon;
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

		local customName = GetPetName(petInfo);
		local level = 1;
		local xp = 1;
		local maxXp = 1;
		local displayID = nil;
		local isFavorite = false;
		local name = customName;
		local icon = GetPetIcon(petInfo);
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
		local customName = GetPetName(petInfo);
		local level = 1;
		local favorite = false;
		local isRevoked = false;
		local speciesName = customName;
		local icon = GetPetIcon(petInfo);
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
			return GetPetName(petInfo);
		end
	end

	function TRP3_API.utils.resources.IsPetCreature(creatureID)
		-- Extension API that doesn't correlate to anything in non-Classic clients.
		return companionPetsByCreatureID[creatureID] ~= nil;
	end

	function TRP3_API.utils.resources.GetMountIDs()
		local mountIDs = {};
		local factionGroup = UnitFactionGroup("player");

		for _, mountInfo in ipairs(TRP3_CompanionMountData) do
			if not mountInfo.factionGroup or factionGroup == mountInfo.factionGroup then
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

		local name = GetSpellInfo(mountInfo.spellID);
		local spellID = mountInfo.spellID;
		local icon = GetSpellTexture(mountInfo.spellID);
		local isActive = TRP3_API.utils.resources.GetSummonedMountID() == mountInfo.mountID;
		local isUsable = true;
		local sourceType = nil;
		local isFavorite = false;
		local isFactionSpecific = (mountInfo.factionGroup ~= nil);
		local faction = nil;
		local isCollected = true;
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

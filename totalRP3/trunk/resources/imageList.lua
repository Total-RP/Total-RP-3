----------------------------------------------------------------------------------
-- Total RP 3
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

local IMAGES = {
	{
		url = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Bling",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-TempRareSketch",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-AmberFly",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-AncientShamanHeaddress",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-Arakkoa",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-BabyPterrodax",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-BonesOfTransformation",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-ChaliceMountainKings",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-ClockworkGnome",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-CthunsPuzzleBox",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-DinosaurSkeleton",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-DraeneiRelic",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-DraenorOrc",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-DruidandPriestStatue",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-GenBeauregardsLastStand",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-HighborneSoulMirror",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-KaldoreiWindChimes",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-Mantid1HSword",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-MantidGun",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-Ogre",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-OldGodTrinket",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-PandarenTortureDummy",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-PendantoftheAqir",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-QueenAzsharaGown",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-QuilinStatue",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-RingoftheBoyEmperor",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-ScepterofAzAqir",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-ScimitaroftheSirocco",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-ShriveledMonkeyPaw",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-SpearofXuen",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-StaffofAmmunrae",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-StaffofSorcererThanThaurissan",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TheInnKeepersDaughter",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TinyDinosaurSkeleton",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TrollDrum",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TrollGolem",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TrollVoodooDoll",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TurtleShield",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-TyrandesFavoriteDoll",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-UmbrellaofChiJi",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-VrykulDrinkingHorn",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-WispAmulet",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-ZinRokhDestroyer",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\BarberShop\\UI-Barbershop-Banner",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\BattlefieldFrame\\UI-Battlefield-Icon",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\BlackMarket\\BlackMarketSign",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\Calendar\\MeetingIcon",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\UI-Calendar-Event-PVP",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\UI-Calendar-Event-PVP01",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\UI-Calendar-Event-PVP02",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Challenges\\ChallengeMode_Medal_Bronze",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Challenges\\ChallengeMode_Medal_Gold",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Challenges\\ChallengeMode_Medal_Platinum",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Challenges\\ChallengeMode_Medal_Silver",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Challenges\\challenges-bronze",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Challenges\\challenges-copper",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Challenges\\challenges-gold",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Challenges\\challenges-plat",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Challenges\\challenges-silver",
		width = 256,
		height = 256
	}, {
		url = "Interface\\FlavorImages\\BloodElfLogo-small",
		width = 256,
		height = 256
	}, {
		url = "Interface\\FlavorImages\\ScarletCrusadeLogo",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-AQRUINS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-AQTEMPLE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-ARATHIBASIN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-AUCHINDOUN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BATTLEGROUND",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKFATHOMDEEPS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKROCKCAVERNS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKROCKDEPTHS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKROCKSPIRE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKTEMPLE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKWINGDESCENTRAID",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLACKWINGLAIR",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-BLADESEDGEARENA",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-CAVERNSOFTIME",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-COILFANG",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-DALARANSEWERS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-DEADMINES",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-DIREMAUL",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-DUNGEON",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-EASTERNKINGDOMS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-GNOMEREGAN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-GRIMBATOL",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-GRIMBATOLRAID",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-GRUULSLAIR",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-HALLSOFLIGHTNING",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-HALLSOFORIGINATION",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-HELLFIRECITADEL",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-HELLFIRECITADEL5MAN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-HELLFIRECITADELRAID",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-HYJALPAST",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-KALIMDOR",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-KARAZHAN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-LOSTCITYOFTOLVIR",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-MAGISTERSTERRACE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-MARAUDON",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-MOLTENCORE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-NAGRANDARENA",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-NAXXRAMAS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-OUTLAND",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-QUEST",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-RAGEFIRECHASM",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-RAID",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-RAZORFENDOWNS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-RAZORFENKRAUL",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-RINGOFVALOR",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-RUINSOFLORDAERON",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-SCARLETMONASTERY",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-SCHOLOMANCE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-SERPENTSHRINECAVERN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-SHADOWFANGKEEP",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-STORMWINDSTOCKADES",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-STRANDOFTHEANCIENTS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-STRATHOLME",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-SUNKENTEMPLE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-SUNWELL",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-TEMPESTKEEP",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-THEBATTLEFORGILNEAS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-THESTONECORE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-THEVORTEXPINNACLE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-THRONEOFTHEFOURWINDS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-THRONEOFTHETIDES",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-ULDAMAN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-WAILINGCAVERNS",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-WARSONGGULCH",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-ZONE",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-ZULAMAN",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-ZULFARAK",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGICON-ZULGURUB",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Ahnkalet",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ArgentDungeon",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ArgentRaid",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-AuchindounWOD",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-AzjolNerub",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BaradinHold",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackrockFoundry",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackrockFoundryAssembly",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackrockFoundryCrucible",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackrockFoundryForge",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackrockFoundrySlagworks",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BloodmaulSlagMines",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Brew",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-CataEventFlamelash",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-CataEventKaijuGahzrilla",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-CataEventSarsarun",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-CataEventTheradras",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ChamberOfAspects",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-DeepwindGorge",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Draenor",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-DragonSoul",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-DrakTharon",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-EndTime",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-EndlessSpring",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Everbloom",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-FallofDeathwing",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Firelands",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-GateoftheSettingSun",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-GrimrailDepot",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-GuardiansofMogushan",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Gundrak",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Halloween",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HallsofLighting",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HallsofReflection",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HallsofStone",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HeartofFear",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Highmaul",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HighmaulCity",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HighmaulRise",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HighmaulSanctum",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-HourofTwilight",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-IcecrownCitadel",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-IronDocks",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-IsleOfConquest",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Love",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Malygos",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-MogushanPalace",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-MogushanVaults",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-NetherBattlegrounds",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-NightmareofShekzeer",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-OldStratholme",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-OnyxiaEncounter",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-OrgrimmarDownfall",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-OrgrimmarGates",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-OrgrimmarUnderhold",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-OrgrimmarVale",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Pandaria",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-PitofSaron",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-RubySanctum",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ScarletHalls",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ShadoPanBG",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ShadowmoonBurialGrounds",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ShadowpanMonastery",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-SiegeofNizaoTemple",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-SiegeofWyrmrestTemple",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-SilvershardMines",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Skyreach",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-StormstoutBrewery",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Summer",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TempleofKotmogu",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TempleoftheJadeSerpent",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TerraceoftheEndlessSpring",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheDreadApproach",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheForgeofSouls",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNexus",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheOculus",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheVaultofMysteries",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheVioletHold",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ThunderForgotten",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ThunderHalls",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ThunderLastStand",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ThunderPinnacle",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TolvirArena",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TwinPeaks",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TwinPeaksBG",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Ulduar",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-UlduarRaid",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-UlduarRaidHeroic",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-UpperBlackrockSpire",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Utgarde",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-UtgardePinnacle",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-VaultOfArchavon",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-WellofEternity",
		width = 256,
		height = 256
	}, {
		url = "Interface\\PETBATTLES\\Weather-ArcaneStorm",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Blizzard",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-BurntEarth",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Darkness",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Moonlight",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Mud",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Rain",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Sandstorm",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-StaticField",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Sunlight",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\PETBATTLES\\Weather-Windy",
		width = 512,
		height = 128
	},
	{
		url = "Interface\\Pictures\\11482_crystals_east",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11482_crystals_mini_east",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11482_crystals_mini_north",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11482_crystals_mini_west",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11482_crystals_north",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11482_crystals_west",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_blackrock_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_blasted_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_bldbank_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_nightdragon_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_ungoro_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_whipper_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\11733_windblossom_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\14679_Tirion_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\21037_crudemap_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\24475_gordawg_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\9330_gammerita_color_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\9330_gammerita_sepia_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\Linken__color_256px",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\Linken_sepia_256px",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\Winterspring_Memento_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\obj_nesingwary_256",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-ArmoryAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-ArmoryHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Ashran-Alliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Ashran-Horde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Ashran",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Frostfire-BloodmaulCompound",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Frostfire-IronSiegeworks",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Frostfire-Magnarok",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Gorgrond-BlackrockFoundry",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Gorgrond-PrimalForest",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-InnAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-InnHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-LumberMillAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-LumberMillHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-MageTowerAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-MageTowerHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Nagrand-BrokenPrecipice",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Nagrand-RingofBlood",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Nagrand-SunspringWatchpost",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Shadowmoon-DarktideRoost",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Shadowmoon-SanctumofOthaar",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-SpiresofArakk-EasternMushroomSwamp",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-SpiresofArakk-ShadowmoonCliffs",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-SpiresofArakk-UpperSkettisRuins",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-StablesAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-StablesHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Talador-ShattrathCityGroup",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-Talador-ShattrathCitySolo",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-TradingPostAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-TradingPostHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-TrainingPitAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-TrainingPitHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-WorkshopAlliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-WorkshopHorde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-alliance",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-horde",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-kirintor",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-sunreaver",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-troll",
		width = 512,
		height = 256
	},

};

local pairs, tinsert = pairs, tinsert;
local safeMatch = TRP3_API.utils.str.safeMatch;
local size = #IMAGES;

function TRP3_API.utils.resources.getImageListSize()
	return size;
end

function TRP3_API.utils.resources.getImageList(filter)
	if filter == nil or filter:len() == 0 then
		return IMAGES;
	end
	filter = filter:lower();
	local newList = {};
	for _, image in pairs(IMAGES) do
		if safeMatch(image.url:lower(), filter) then
			tinsert(newList, image);
		end
	end
	return newList;
end
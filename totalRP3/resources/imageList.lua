----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
	return;
end

local IMAGES = {
	{
		url = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Bling",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-ArakkoaBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-DemonsBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-DraeneiBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-DraenorOrcBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-DrustvariBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-DwarfBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-FossilBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-HighborneNightElvesBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-HighmountainTaurenBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-MantidBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-MiscBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-MoguBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-NerubianBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-NightElfBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-OgreBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-OrcBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-PandarenBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-TolvirBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-TrollBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-VrykulBIG",
		width = 256,
		height = 512
	},
	{
		url = "Interface\\ARCHEOLOGY\\Arch-Race-ZandalariBIG",
		width = 256,
		height = 512
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
		url = "Interface\\ARCHEOLOGY\\ArchRare-Demons",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-Drustvari",
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
		url = "Interface\\ARCHEOLOGY\\ArchRare-HighborneNightElves",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-HighborneSoulMirror",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\ARCHEOLOGY\\ArchRare-HighmountainTauren",
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
		url = "Interface\\ARCHEOLOGY\\ArchRare-Zandalari",
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
		url = "Interface\\Calendar\\Holidays\\Calendar_AllianceWarCampaign",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_BattleForDazaralorStart",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_Brawl",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_DanceDay",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_EternalPalace",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_HordeWarCampaign",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_MoonkinFestival",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_RaidCrucibleOfStormsStart",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_RunningoftheGnomesEnd",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_TombofSargerasStart",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_TransmogPopularityContestStart",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_UldirStart",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\Calendar\\Holidays\\Calendar_WeekendBlackTempleStart",
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
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-BloodElf1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-DarkIronDwarf1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-DeathKnight1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Draenei1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Dwarf1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DRESSUPBACKGROUND-GNOME1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Goblin1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-HighmountainTauren1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Human1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-LightforgedDraenei1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Maghar1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-NightElf1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Nightborne1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Orc1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Pandaren1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Scourge1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Tauren1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DRESSUPBACKGROUND-TROLL1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-VoidElf1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressUpBackground-Worgen1",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomDeathKnight",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomDemonHunter",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomDruid",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomHunter",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomMage",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomMonk",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomPaladin",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomPriest",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomRogue",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomShaman",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomWarlock",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\DRESSUPFRAME\\DressingRoomWarrior",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\FlavorImages\\BloodElfLogo-small",
		width = 256,
		height = 256
	}, {
		url = "Interface\\FlavorImages\\ScarletCrusadeLogo",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\LFGFRAME\\LFGICON-AQRUINS",
		width = 256,
		height = 256
	},
	{
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
		url = "Interface\\LFGFRAME\\LFGICON-Brewfest",
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
		url = "Interface\\LFGFRAME\\LFGIcon-AntorusWing1",
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
		url = "Interface\\LFGFRAME\\LFGIcon-Argus",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Ashran",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-AssaultonVioletHold",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Ataldazar",
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
		url = "Interface\\LFGFRAME\\LFGIcon-BattleOfDazaralor",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackRookHold",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-BlackrookHoldArena",
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
		url = "Interface\\LFGFRAME\\LFGIcon-BrokenIsles",
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
		url = "Interface\\LFGFRAME\\LFGIcon-CathedralOfEternalNight",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-ChamberOfAspects",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-CourtofStars",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-CrucibleOfStorms",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-DarkheartThicket",
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
		url = "Interface\\LFGFRAME\\LFGIcon-EternalPalace",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Everbloom",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-EyeofAzshara",
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
		url = "Interface\\LFGFRAME\\LFGIcon-Freehold",
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
		url = "Interface\\LFGFRAME\\LFGIcon-HallsofValor",
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
		url = "Interface\\LFGFRAME\\LFGIcon-KingsRest",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-KulTiras",
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
		url = "Interface\\LFGFRAME\\LFGIcon-MawofSouls",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Mechagon",
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
		url = "Interface\\LFGFRAME\\LFGIcon-NeltharionsLair",
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
		url = "Interface\\LFGFRAME\\LFGIcon-ReturntoKarazhan",
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
		url = "Interface\\LFGFRAME\\LFGIcon-SeatoftheTriumvirate",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-SeethingShore",
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
		url = "Interface\\LFGFRAME\\LFGIcon-ShrineoftheStorm",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-SiegeofBoralus",
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
		url = "Interface\\LFGFRAME\\LFGIcon-TempleofSethraliss",
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
		url = "Interface\\LFGFRAME\\LFGIcon-TheArcway",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheDreadApproach",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheEmeraldNightmare-Darkbough",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheEmeraldNightmare-RiftofAln",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheEmeraldNightmare-TormentedGuardians",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheForgeofSouls",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheMotherlode",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNexus",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNighthold",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNighthold-ArcingAqueducts",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNighthold-BetrayersRise",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNighthold-Nightspire",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheNighthold-RoyalAthenaeum",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheOculus",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TheUnderrot",
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
		url = "Interface\\LFGFRAME\\LFGIcon-TolDagor",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TolvirArena",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TombOfSargerasChamberOfTheAvatar",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TombOfSargerasDeceiversFall",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TombOfSargerasTheGatesOfHell",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TombOfSargerasWailingHalls",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-TrialofValor",
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
		url = "Interface\\LFGFRAME\\LFGIcon-Uldir",
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
		url = "Interface\\LFGFRAME\\LFGIcon-valsharrahArena",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-VaultOfArchavon",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-VaultoftheWardens",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-WaycrestManor",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-WellofEternity",
		width = 256,
		height = 256
	}, {
		url = "Interface\\LFGFRAME\\LFGIcon-Zandalar",
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
		url = "Interface\\PETBATTLES\\Weather-ToxicFumes",
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
		url = "Interface\\Pictures\\artifactbook-deathknight-apocalypse",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-deathknight-bladesofthefallenprince",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-deathknight-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-deathknight-mawofthedamned",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-demonhunter-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-demonhunter-thealdrachiwarblades",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-demonhunter-twinbladesofthedeceiver",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-druid-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-druid-ghanirthemothertree",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-druid-scytheofelune",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-druid-theclawsofursoc",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-druid-thefangsofashamane",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-hunter-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-hunter-talonclaw",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-hunter-thasdorah",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-hunter-titanstrike",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-mage-aluneth",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-mage-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-mage-ebonchill",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-mage-felomelorn",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-monk-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-monk-fists",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-monk-fuzan",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-monk-sheilun",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-paladin-ashbringer",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-paladin-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-paladin-silverhand",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-paladin-truthguard",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-priest-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-priest-lightswrath",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-priest-tuure",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-priest-xalatath",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-rogue-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-rogue-dreadblades",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-rogue-fangsofthedevourer",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-rogue-kingslayers",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-shaman-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-shaman-doomhammer",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-shaman-fistofraden",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-shaman-sharasdal",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warlock-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warlock-scepterofsargeras",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warlock-skullofthemanari",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warlock-ulthalesh",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warrior-cover",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warrior-scaleoftheearthwarder",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warrior-stromkar",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\Pictures\\artifactbook-warrior-warswordsofthevalarjar",
		width = 512,
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
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-2-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-2-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-2-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-2-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-2-5",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-3-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-3-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-3-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-3-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-3-5",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-4-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-4-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-4-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-4-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-4-5",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-5-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-5-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-5-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-5-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-6-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-6-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-6-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-6-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-7-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-7-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-7-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-7-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-6-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-8-1",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-8-2",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-8-3",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\prestige-icon-8-4",
		width = 128,
		height = 128
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-1",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-2",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-3",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-4",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-5",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-6",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-7",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-8",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-9",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-10",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-11",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-12",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-13",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-14",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-15",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-16",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-17",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-18",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-19",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-20",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-21",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-22",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-23",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-24",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-25",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-26",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-27",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-28",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-29",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-30",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-31",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-32",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-33",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-34",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-35",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-36",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-37",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-38",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-39",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-40",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-41",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-42",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-43",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-44",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-45",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-46",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-47",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-48",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-49",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-50",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-51",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-52",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-53",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-54",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-55",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-56",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-57",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-58",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-59",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-60",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-61",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-62",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-63",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-64",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-65",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-66",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-67",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-68",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-69",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-70",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-71",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-72",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-73",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-74",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-75",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-76",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-77",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-78",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-79",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-80",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-81",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-82",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-83",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-84",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-85",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-86",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-87",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-88",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-89",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-90",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-91",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-92",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-93",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-94",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-95",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-96",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-97",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-98",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-99",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-100",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-101",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-102",
		width = 64,
		height = 64
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_01",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_02",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_03",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_04",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_05",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_06",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_07",
		width = 256,
		height = 256
	},
	{
		url = "Interface\\PVPFrame\\Icons\\UI_RankedPvP_07Mod",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\QUESTFRAME\\UI-HorizontalBreak",
		width = 256,
		height = 64
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
		url = "Interface\\QuestionFrame\\answer-PH_BladesmanInowari",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_HunterAkana",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_TrackerOnu",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyExpressFlag",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyExpressFlag2",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyFlex",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyMK",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyPM1",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyPM2",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-PH_mooblyShe",
		width = 256,
		height = 128
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
	{
		url = "Interface\\QuestionFrame\\answer-Altruis",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ArtifactNYI",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ArtifactTEMP",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DHHavoc",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DHVengeance",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DeathKnightBlood",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DeathKnightFrost",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DeathKnightUnholy",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DemonHunterHavoc",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DemonHunterVengeance",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DruidBalance",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DruidFeral",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DruidGuardian",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-DruidRestoration",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-HunterBeastmaster",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-HunterMarksman",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-HunterSurvival",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-KaynSunfury",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-MageArcane",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-MageFire",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-MageFrost",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-MonkBrewmaster",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-MonkMistweaver",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-MonkWindwalker",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-PaladinHoly",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-PaladinProt",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-PaladinRet",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-PriestDiscipline",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-PriestHoly",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-PriestShadow",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-RogueAssassination",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-RogueCombat",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-RogueSubtlety",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ShamanElemental",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ShamanEnhancement",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ShamanRestoration",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-FelForge",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-IronFront",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-IronholdHarbor",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-RuinsofKranak",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-TempleofShanaar",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-ThroneofKiljaeden",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-Tanaan-ZethGol",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-WarlockAffliction",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-WarlockDemonology",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-WarlockDestruction",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-WarriorArms",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-WarriorFury",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-WarriorProtection",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ChromieScenario-Chromie",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ChromieScenario-Drake",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ChromieScenario-Gold",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-ChromieScenario-Hourglass",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-VindicaarCrystal-FelHeartofArgus",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-VindicaarCrystal-LightforgedWarframe",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-VindicaarCrystal-LightsJudgment",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-VindicaarCrystal-ShroudofArcaneEchoes",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-DarkIronDwarf",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-Highmountain",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-Kultiran",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-Lightforged",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-MagharOrc",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-Nightborne",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-Voidelf",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-AlliedRace-Zandalari",
		width = 256,
		height = 128,
	},
	{
		url = "Interface\\QuestionFrame\\answer-mechagon-chargingstation-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-mechagon-drillrig-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-mechagon-flameturret-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-mechagon-jetpack-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-mechagon-reclamationdevice-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-BladesEdgeMountains",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-HellfirePeninsula",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-IsleofQuelDanas",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-Nagrand",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-Netherstorm",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-ShadowmoonValley",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-TerokkarForest",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bc-Zangarmarsh",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bfa-Boralus",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bfa-Drustvar",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bfa-Nazmir",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bfa-Stormsong",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bfa-Voldun",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-bfa-Zuldazar",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-Deepholm",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-ElementalBonds",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-MoltenFront",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-MountHyjal",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-TwilightHighlands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-Uldum",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-cata-Vashjir",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-ArathiHighlands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Ashenvale",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Azshara",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-AzuremystIsle",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Badlands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-BlastedLands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-BloodmystIsle",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-BurningSteppes",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-CapeofStranglethorn",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Darkshore",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Desolace",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-DunMorogh",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Durotar",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Duskwood",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-DustwallowMarsh",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-EasternPlaguelands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-ElwynnForest",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-EversongWoods",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Felwood",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Feralas",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Ghostlands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Gilneas",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-HillsbradFoothills",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Hinterlands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-LochModan",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-LostIsles",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Mulgore",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-NorthernBarrens",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-NorthernStranglethorn",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-RedridgeMountains",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-SearingGorge",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Silithus",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-SilverpineForest",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-SouthernBarrens",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-StonetalonMountains",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-SwampofSorrows",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Tanaris",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Teldrassil",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-ThousandNeedles",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-TirisfalGlades",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-UngoroCrater",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-WanderingIsle",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-WesternPlaguelands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Westfall",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Wetlands",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-classic-Winterspring",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-DreadWastes",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-IsleofGiants",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-IsleoftheThunderKing",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-JadeForest",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-KrasarangWilds",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-KunLaiSummit",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-TimelessIsle",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-TownlongSteppes",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-ValeofEternalBlossoms",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-mop-ValleyoftheFourWinds",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-FrostfireRidge",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-Gorgrond",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-Nagrand",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-ShadowmoonValley",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-SpiresofArak",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-Talador",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-TanaanJungle",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wod-TanaanJungleIntro",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-BoreanTundra",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-CrystalsongForest",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-Dalaran",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-Dragonblight",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-GrizzlyHills",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-HowlingFjord",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-Icecrown",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-SholazarBasin",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-StormPeaks",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warboard-wotlk-ZulDrak",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-alliance-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-alliance",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-alliancecontribution-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-alliancecontribution",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-alliancewar-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-alliancewar",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-horde-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-horde",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-hordecontribution-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-hordecontribution",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-hordewar-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-arathi-hordewar",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-darkshore-alliance",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-darkshore-alliancecontribution",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-darkshore-alliancewar",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-darkshore-horde",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-darkshore-hordecontribution",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfrontqueue-darkshore-hordewar",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-AltarOfElders-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-AltarOfKings-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-AltarofKings",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-AncientOfWar-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-ArchDruid-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Armory-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Armory",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Barracks-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Barracks",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-CallOfNature",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Chimaera-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-ElekMount-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-ElekMount",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Footmen",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-GlaiveThrower-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Glaiveworks-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-HuntersHall-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-KaldoreiArcher",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-KaldoreiHuntress",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-KaldoreiSentinel",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-KaldoreiTreant",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Knight",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Priest",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Riflemen",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-SiegeEngine-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-SiegeEngine",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-SpiritofWater-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-SpiritofWater",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TownHall1",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TownHall2-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TownHall2",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TownHall3-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TownHall3",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TransformDryad",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TransformFaerieDragon",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TransformKeeper",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TreeOfAges-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TreeOfEternity-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-TreeOfLife-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Workshop-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-alliance-Workshop",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Abomination-large",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-AltarOfStorms-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-AltarOfStorms",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Armory-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Armory",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-AxeThrower",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-AxeThrowerDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Barracks-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Barracks",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-BatVehicle-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-BristlingPower",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-CallOfTheStorm",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DarkshoreAltarOfStorms-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DarkshoreArmory-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DarkshoreBarracks-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DarkshoreCatapult-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DarkshoreTownHall-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DarkshoreWorkshop-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Demolisher-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Demolisher",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-DemolisherDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-FelBat-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-FleshTitan-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-ForsakenAlchemist",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-ForsakenCavalry",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-ForsakenFootman",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-ForsakenFusilier",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Grunt",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-GruntAxeThrowerandTaurenWarrior",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-GruntAxeThrowerandTaurenWarriorDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-GruntDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-GruntandAxeThrower",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-GruntandAxeThrowerDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-KodoMount-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-KodoMount",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Raider",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-RaiderDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Shaman",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-ShamanDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-SpiritofFire-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-SpiritofFire",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-ShamanDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TaurenWarrior",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TaurenWarriorDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TownHall1",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TownHall2-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TownHall2",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TownHall3-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TownHall3",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TransformAbomination",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TransformAzermek",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TransformBanshee",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TrollBatRider",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-TrollBatRiderDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-WitchDoctor",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-WitchDoctorDisable",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Workshop-large",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-warfronts-horde-Workshop",
		width = 256,
		height = 128
	},
	{
		url = "Interface\\QuestionFrame\\answer-zone-BattleforAzerothKulTiras",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-zone-BattleforAzerothZandalar",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-zone-BurningCrusade",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-zone-Cataclysm",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-zone-MistsofPandaria",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\QuestionFrame\\answer-zone-WrathoftheLichKing",
		width = 512,
		height = 256
	},
	{
		url = "Interface\\TALENTFRAME\\bg-deathknight-blood",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-deathknight-frost",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-deathknight-unholy",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-druid-balance",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-druid-bear",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-druid-cat",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-druid-restoration",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-hunter-beastmaster",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-hunter-marksman",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-hunter-survival",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-mage-arcane",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-mage-fire",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-mage-frost",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-monk-battledancer",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-monk-brewmaster",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-monk-mistweaver",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-paladin-holy",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-paladin-protection",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-paladin-retribution",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-priest-discipline",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-priest-holy",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-priest-shadow",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-rogue-assassination",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-rogue-combat",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-rogue-subtlety",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-shaman-elemental",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-shaman-enhancement",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-shaman-restoration",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-warlock-affliction",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-warlock-demonology",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-warlock-destruction",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-warrior-arms",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-warrior-fury",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TALENTFRAME\\bg-warrior-protection",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TAXIFRAME\\TAXIMAP0",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TAXIFRAME\\TAXIMAP1",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TAXIFRAME\\TAXIMAP530",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TAXIFRAME\\TAXIMAP571",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TAXIFRAME\\Taximap870",
		width = 512,
		height = 512
	},
	{
		url = "Interface\\TAXIFRAME\\Taximap1116",
		width = 512,
		height = 512
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

----------------------------------------------------------------------------------
-- Total RP 3
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
	},
};

local match = TRP3_API.utils.str.match;
local pairs, tinsert = pairs, tinsert;

local size = #IMAGES;

function TRP3_API.utils.resources.getImageListSize()
	return size;
end

function TRP3_API.utils.resources.getImageList(filter)
	if filter == nil or filter:len() == 0 then
		return IMAGES;
	end
	local newList = {};
	for _, image in pairs(IMAGES) do
		if match(image.url, filter) then
			tinsert(newList, image);
		end
	end
	return newList;
end
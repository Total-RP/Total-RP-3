----------------------------------------------------------------------------------
--- Total RP 3
---    ---------------------------------------------------------------------------
---    Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

--region Lua imports
local tonumber = tonumber;
local insert = table.insert;
--endregion

--region WoW imports
local CreateVector2D = CreateVector2D;
--endregion

--region Total RP 3 imports
local loc = TRP3_API.loc;
local broadcast = AddOn_TotalRP3.Communications.broadcast;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
local getConfigValue = TRP3_API.configuration.getValue;
local get = TRP3_API.profile.getData;
local Map = AddOn_TotalRP3.Map;
--endregion

local MAP_PLAYER_SCAN_FAKE_DATA =  {
	["saveStructure"] = {
		["Reÿner-KirinTor"] = {
			["y"] = "0.60678493976593",
			["x"] = "0.50766050815582",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Elmerin-KirinTor"] = {
			["y"] = "0.3834725022316",
			["x"] = "0.61304694414139",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Pennie-KirinTor"] = {
			["y"] = "0.54757648706436",
			["x"] = "0.51022660732269",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Isuríth-KirinTor"] = {
			["y"] = "0.41543352603912",
			["x"] = "0.49844843149185",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Blâck-KirinTor"] = {
			["y"] = "0.556685090065",
			["x"] = "0.53704488277435",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Arnaryl-KirinTor"] = {
			["y"] = "0.66763138771057",
			["x"] = "0.51786541938782",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Kwanlin-KirinTor"] = {
			["y"] = "0.49703234434128",
			["x"] = "0.40575069189072",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Turin-KirinTor"] = {
			["y"] = "0.36676359176636",
			["x"] = "0.60277342796326",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Theorode-KirinTor"] = {
			["y"] = "0.64680576324463",
			["x"] = "0.4408170580864",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Kragondamos-KirinTor"] = {
			["y"] = "0.55116212368011",
			["x"] = "0.53862798213959",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Emerîc-KirinTor"] = {
			["y"] = "0.5673896074295",
			["x"] = "0.6110874414444",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Fens-KirinTor"] = {
			["y"] = "0.66889435052872",
			["x"] = "0.41254568099976",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Sinn-KirinTor"] = {
			["y"] = "0.14970761537552",
			["x"] = "0.57783901691437",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ethaldreï-KirinTor"] = {
			["y"] = "0.55946469306946",
			["x"] = "0.53822684288025",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Théssa-KirinTor"] = {
			["y"] = "0.73487943410873",
			["x"] = "0.61616134643555",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Amadriell-KirinTor"] = {
			["y"] = "0.46248984336853",
			["x"] = "0.55367183685303",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Cøuleuvre-KirinTor"] = {
			["y"] = "0.54584395885468",
			["x"] = "0.54839766025543",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Demiora-KirinTor"] = {
			["y"] = "0.51580685377121",
			["x"] = "0.5506774187088",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Gahïsha-KirinTor"] = {
			["y"] = "0.5024516582489",
			["x"] = "0.59479212760925",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Mëgan-KirinTor"] = {
			["y"] = "0.68937945365906",
			["x"] = "0.48209416866302",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Raysia-KirinTor"] = {
			["y"] = "0.52907431125641",
			["x"] = "0.48840838670731",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ïwar-KirinTor"] = {
			["y"] = "0.44089359045029",
			["x"] = "0.21403139829636",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Alicenzâh-KirinTor"] = {
			["y"] = "0.46876484155655",
			["x"] = "0.67261040210724",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Rebëca-KirinTor"] = {
			["y"] = "0.63509458303452",
			["x"] = "0.42925941944122",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Soldian-KirinTor"] = {
			["y"] = "0.55404794216156",
			["x"] = "0.53767573833466",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Aërius-KirinTor"] = {
			["y"] = "0.71858865022659",
			["x"] = "0.61503678560257",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Crocmaïs-KirinTor"] = {
			["y"] = "0.45551425218582",
			["x"] = "0.49850684404373",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Welkîn-KirinTor"] = {
			["y"] = "0.30851542949677",
			["x"] = "0.65353715419769",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Fenraë-KirinTor"] = {
			["y"] = "0.33015382289886",
			["x"] = "0.2127690911293",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Fåûve-KirinTor"] = {
			["y"] = "0.48705542087555",
			["x"] = "0.62864226102829",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Synrion-KirinTor"] = {
			["y"] = "0.54267483949661",
			["x"] = "0.53812497854233",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Reed-KirinTor"] = {
			["y"] = "0.62574738264084",
			["x"] = "0.4617692232132",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Êlenwë-KirinTor"] = {
			["y"] = "0.5440456867218",
			["x"] = "0.50891488790512",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Skÿrion-KirinTor"] = {
			["y"] = "0.56983542442322",
			["x"] = "0.55313539505005",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Jarvis-KirinTor"] = {
			["y"] = "0.47200226783752",
			["x"] = "0.67596989870071",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Reîner-KirinTor"] = {
			["y"] = "0.48638767004013",
			["x"] = "0.62824153900146",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Geurius-KirinTor"] = {
			["y"] = "0.63808161020279",
			["x"] = "0.45860457420349",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Shaanary-KirinTor"] = {
			["y"] = "0.73677968978882",
			["x"] = "0.61992514133453",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Anath-KirinTor"] = {
			["y"] = "0.54692983627319",
			["x"] = "0.51086533069611",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Agero-KirinTor"] = {
			["y"] = "0.04039853811264",
			["x"] = "0.18749862909317",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Mänäe-KirinTor"] = {
			["y"] = "0.5562652349472",
			["x"] = "0.53854978084564",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Winea-KirinTor"] = {
			["y"] = "0.55368793010712",
			["x"] = "0.53637450933456",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Sélinà-KirinTor"] = {
			["y"] = "0.55717158317566",
			["x"] = "0.53466963768005",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Anïs-KirinTor"] = {
			["y"] = "0.69055640697479",
			["x"] = "0.48140722513199",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Wynchester-KirinTor"] = {
			["y"] = "0.2451953291893",
			["x"] = "0.60007554292679",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Cid-KirinTor"] = {
			["y"] = "0.4674808382988",
			["x"] = "0.67281079292297",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ludivïne-KirinTor"] = {
			["y"] = "0.64550995826721",
			["x"] = "0.5912150144577",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Markal-KirinTor"] = {
			["y"] = "0.70887553691864",
			["x"] = "0.61279499530792",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Lucrézia-KirinTor"] = {
			["y"] = "0.57613229751587",
			["x"] = "0.56595313549042",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Violettë-KirinTor"] = {
			["y"] = "0.43863159418106",
			["x"] = "0.55039596557617",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Oursage-KirinTor"] = {
			["y"] = "0.36587750911713",
			["x"] = "0.60468745231628",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Nidhal-KirinTor"] = {
			["y"] = "0.82513999938965",
			["x"] = "0.4116068482399",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Gâbrielle-KirinTor"] = {
			["y"] = "0.54451274871826",
			["x"] = "0.5085254907608",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Lanae-KirinTor"] = {
			["y"] = "0.4128857254982",
			["x"] = "0.49959033727646",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Gentilhomme-KirinTor"] = {
			["y"] = "0.6873265504837",
			["x"] = "0.6393256187439",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Thendar-KirinTor"] = {
			["y"] = "0.58764708042145",
			["x"] = "0.57876652479172",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Blumwald-KirinTor"] = {
			["y"] = "0.41571509838104",
			["x"] = "0.49922144412994",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ykin-KirinTor"] = {
			["y"] = "0.65036273002625",
			["x"] = "0.61728602647781",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Elarielle-KirinTor"] = {
			["y"] = "0.777399122715",
			["x"] = "0.62649613618851",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Vaalar-KirinTor"] = {
			["y"] = "0.55474007129669",
			["x"] = "0.53483647108078",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Lysange-KirinTor"] = {
			["y"] = "0.44195753335953",
			["x"] = "0.43777847290039",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Dàllis-KirinTor"] = {
			["y"] = "0.57740449905396",
			["x"] = "0.56742715835571",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Khassim-KirinTor"] = {
			["y"] = "0.43915265798569",
			["x"] = "0.43781077861786",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Jayed-KirinTor"] = {
			["y"] = "0.5641176700592",
			["x"] = "0.53366088867188",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Rôan-KirinTor"] = {
			["y"] = "0.55791765451431",
			["x"] = "0.53596603870392",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Uldarieth-KirinTor"] = {
			["y"] = "0.67988133430481",
			["x"] = "0.62811863422394",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
	},
	["buttonIcon"] = "Achievement_GuildPerk_EverybodysFriend",
	["id"] = "playerScan",
	["buttonText"] = "Afficher les personnages",
	["scanCommand"] = "CSCAN",
	["scanTitle"] = "Personnages",
	["scanDuration"] = 2.5,
}


for k, v in pairs(MAP_PLAYER_SCAN_FAKE_DATA.saveStructure) do
	MAP_PLAYER_SCAN_FAKE_DATA.saveStructure[k].position = CreateVector2D(v.x, v.y)
	MAP_PLAYER_SCAN_FAKE_DATA.saveStructure[k].sender = k
end

local CONFIG_ENABLE_MAP_LOCATION = "register_map_location";
local CONFIG_DISABLE_MAP_LOCATION_ON_OOC = "register_map_location_ooc";

local function shouldAnswerToLocationRequest()
	return getConfigValue(CONFIG_ENABLE_MAP_LOCATION)
		and (not getConfigValue(CONFIG_DISABLE_MAP_LOCATION_ON_OOC) or get("player/character/RP") ~= 2)
end

TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()

	registerConfigKey(CONFIG_ENABLE_MAP_LOCATION, true);
	registerConfigKey(CONFIG_DISABLE_MAP_LOCATION_ON_OOC, false);

	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_LOCATION,
	});
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_ACTIVATE,
		help = loc.CO_LOCATION_ACTIVATE_TT,
		configKey = CONFIG_ENABLE_MAP_LOCATION,
	});
	insert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_LOCATION_DISABLE_OOC,
		help = loc.CO_LOCATION_DISABLE_OOC_TT,
		configKey = CONFIG_DISABLE_MAP_LOCATION_ON_OOC,
		dependentOnOptions = { CONFIG_ENABLE_MAP_LOCATION },
	});
end)

---@type MapScanner
local playerMapScanner = AddOn_TotalRP3.MapScanner("playerScan")
playerMapScanner.scanIcon = "Achievement_GuildPerk_EverybodysFriend"
playerMapScanner.scanOptionText = loc.MAP_SCAN_CHAR;
playerMapScanner.scanTitle = loc.MAP_SCAN_CHAR_TITLE;
playerMapScanner.scanCommand = "CSCAN";
playerMapScanner.dataProviderTemplate = TRP3_PlayerMapPinMixin.TEMPLATE_NAME;

function playerMapScanner:Scan()
	broadcast.broadcast(self.scanCommand, Map.getPlayerMapID());
end

function playerMapScanner:OnScanRequestReceived(sender, mapID)
	mapID = tonumber(mapID);
	if shouldAnswerToLocationRequest() and Map.playerCanSeeTarget(sender) then
		local playerMapID = Map.getPlayerMapID();
		if playerMapID ~= mapID then
			return
		end
		local x, y = Map.getPlayerCoordinates();
		if x and y then
			broadcast.sendP2PMessage(sender, self.scanCommand, x, y, playerMapID);
		end
	end
end

-- Players can only scan for other players in zones where it is possible to retrieve player coordinates.
function playerMapScanner:CanScan()
	if getConfigValue(CONFIG_ENABLE_MAP_LOCATION) then
		local x, y = Map.getPlayerCoordinates()
		if x and y then
			return true;
		end
	end
	return false;
end

broadcast.registerCommand(playerMapScanner.scanCommand, function(sender, mapId)
	if Map.playerCanSeeTarget(sender) then
		playerMapScanner:OnScanRequestReceived(sender, mapId)
	end
end)

broadcast.registerP2PCommand(playerMapScanner.scanCommand, function(sender, x, y)
	if Map.playerCanSeeTarget(sender) then
		playerMapScanner:OnScanDataReceived(sender, x, y)
	end
end)
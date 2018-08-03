----------------------------------------------------------------------------------
--- Total RP 3
--- Character data exchange
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local AddOn_TotalRP3 = AddOn_TotalRP3;

-- TRP3 imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local get = TRP3_API.profile.getData;
local Comm = AddOn_TotalRP3.Communications;
local loc = TRP3_API.loc;
local log = Utils.log.log;
local Events = TRP3_API.events;
local getCharacterExchangeData = TRP3_API.dashboard.getCharacterExchangeData;
local registerInfoTypes = TRP3_API.register.registerInfoTypes;
local isIDIgnored, shouldUpdateInformation = TRP3_API.register.isIDIgnored, TRP3_API.register.shouldUpdateInformation;
local addCharacter = TRP3_API.register.addCharacter;
local saveCurrentProfileID, saveClientInformation, saveInformation = TRP3_API.register.saveCurrentProfileID, TRP3_API.register.saveClientInformation, TRP3_API.register.saveInformation;
local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local isUnitIDKnown, hasProfile = TRP3_API.register.isUnitIDKnown, TRP3_API.register.hasProfile;
local playerAPI = TRP3_API.register.player;
local getCharExchangeData = playerAPI.getCharacteristicsExchangeData;
local getAboutExchangeData = playerAPI.getAboutExchangeData;
local getMiscExchangeData = playerAPI.getMiscExchangeData;
local boundAndCheckCompanion = TRP3_API.companions.register.boundAndCheckCompanion;
local getCurrentBattlePetQueryLine, getCurrentPetQueryLine = TRP3_API.companions.player.getCurrentBattlePetQueryLine, TRP3_API.companions.player.getCurrentPetQueryLine;
local getCurrentMountQueryLine = TRP3_API.companions.player.getCurrentMountQueryLine;
local getCompanionData = TRP3_API.companions.player.getCompanionData;
local saveCompanionInformation = TRP3_API.companions.register.saveInformation;
local getConfigValue = TRP3_API.configuration.getValue;
local displayMessage = TRP3_API.utils.message.displayMessage;
local msp = _G.msp;


-- WoW imports
local time, type, pairs, tonumber = GetTime, type, pairs, tonumber;
local newTimer = C_Timer.NewTimer;

-- Character name for profile opening command
local characterToOpen = "";
local commandOpeningTimerHandle;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local has_seen_update_alert, has_seen_extended_update_alert = false, false;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Vernum queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local LAST_QUERY, LAST_QUERY_R, LAST_QUERY_STAT = {}, {}, {};
local COOLDOWN_DURATION = 10; -- Should be integer
local VERNUM_QUERY_PREFIX = "VQ";
local VERNUM_R_QUERY_PREFIX = "VR";
local INFO_TYPE_QUERY_PREFIX = "GI";
local INFO_TYPE_SEND_PREFIX = "SI";
local VERNUM_QUERY_PRIORITY = Comm.PRIORITIES.MEDIUM;
local INFO_TYPE_QUERY_PRIORITY = Comm.PRIORITIES.MEDIUM;
local INFO_TYPE_SEND_PRIORITY = Comm.PRIORITIES.LOW;

local VERNUM_QUERY_INDEX_VERSION = 1;
local VERNUM_QUERY_INDEX_VERSION_DISPLAY = 2;
local VERNUM_QUERY_INDEX_CHARACTER_PROFILE = 3;
local VERNUM_QUERY_INDEX_CHARACTER_CHARACTERISTICS_V = 4;
local VERNUM_QUERY_INDEX_CHARACTER_ABOUT_V = 5;
local VERNUM_QUERY_INDEX_CHARACTER_MISC_V = 6;
local VERNUM_QUERY_INDEX_CHARACTER_CHARACTER_V = 7;
local VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET = 8;
local VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V1 = 9;
local VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V2 = 10;
local VERNUM_QUERY_INDEX_COMPANION_PET = 11;
local VERNUM_QUERY_INDEX_COMPANION_PET_V1 = 12;
local VERNUM_QUERY_INDEX_COMPANION_PET_V2 = 13;
local VERNUM_QUERY_INDEX_COMPANION_MOUNT = 14;
local VERNUM_QUERY_INDEX_COMPANION_MOUNT_V1 = 15;
local VERNUM_QUERY_INDEX_COMPANION_MOUNT_V2 = 16;
local VERNUM_QUERY_INDEX_EXTENDED = 17;
local VERNUM_QUERY_INDEX_TRIALS = 18;
local VERNUM_QUERY_INDEX_EXTENDED_DISPLAY = 19;

local queryInformationType, createVernumQuery;

--- Vernum query builder
function createVernumQuery()
	local query = {};
	query[VERNUM_QUERY_INDEX_VERSION] = Globals.version; -- Your TRP3 version (number)
	query[VERNUM_QUERY_INDEX_VERSION_DISPLAY] = Globals.version_display; -- Your TRP3 version (as it should be shown on tooltip)
	-- Character
	query[VERNUM_QUERY_INDEX_CHARACTER_PROFILE] = getPlayerCurrentProfileID() or "";
	query[VERNUM_QUERY_INDEX_CHARACTER_CHARACTERISTICS_V] = get("player/characteristics").v or 0;
	query[VERNUM_QUERY_INDEX_CHARACTER_ABOUT_V] = get("player/about").v or 0;
	query[VERNUM_QUERY_INDEX_CHARACTER_MISC_V] = get("player/misc").v or 0;
	query[VERNUM_QUERY_INDEX_CHARACTER_CHARACTER_V] = get("player/character").v or 1;
	-- Companion
	local battlePetLine, battlePetV1, battlePetV2 = getCurrentBattlePetQueryLine();
	query[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET] = battlePetLine or "";
	query[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V1] = battlePetV1 or 0;
	query[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V2] = battlePetV2 or 0;
	local petLine, petV1, petV2 = getCurrentPetQueryLine();
	query[VERNUM_QUERY_INDEX_COMPANION_PET] = petLine or "";
	query[VERNUM_QUERY_INDEX_COMPANION_PET_V1] = petV1 or 0;
	query[VERNUM_QUERY_INDEX_COMPANION_PET_V2] = petV2 or 0;
	local mountLine, mountV1, mountV2 = getCurrentMountQueryLine();
	query[VERNUM_QUERY_INDEX_COMPANION_MOUNT] = mountLine or "";
	query[VERNUM_QUERY_INDEX_COMPANION_MOUNT_V1] = mountV1 or 0;
	query[VERNUM_QUERY_INDEX_COMPANION_MOUNT_V2] = mountV2 or 0;

	-- Extended
	if Globals.extended_version then
		query[VERNUM_QUERY_INDEX_EXTENDED] = Globals.extended_version;
		query[VERNUM_QUERY_INDEX_EXTENDED_DISPLAY] = Globals.extended_display_version;
	end
	-- Trial accounts
	query[VERNUM_QUERY_INDEX_TRIALS] = Globals.is_trial_account;

	return query;
end

local function checkCooldown(unitID, structure)
	return not structure[unitID] or time() - structure[unitID] > COOLDOWN_DURATION;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Incoming vernum queries
-- Check version numbers and perform information queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- We will store new versions alerts to remember how many people notified us of a new version.
local newVersionAlerts, extendedNewVersionAlerts = {}, {};

local infoTypeTab = {
	registerInfoTypes.CHARACTERISTICS,
	registerInfoTypes.ABOUT,
	registerInfoTypes.MISC,
	registerInfoTypes.CHARACTER
};

local COMPANION_PREFIX = "comp_";

local function parseCompanionInfo(senderID, senderProfileID, petLine, petV1, petV2)
	if petLine and petV1 and petV2 then
		local profileID, queryV1, queryV2 = boundAndCheckCompanion(petLine, senderID, senderProfileID, petV1, petV2);
		if queryV1 then
			log(("Should update v1 for companion profileID %s"):format(profileID));
			queryInformationType(senderID, COMPANION_PREFIX .. "1" .. profileID);
		end
		if queryV2 then
			log(("Should update v2 for companion profileID %s"):format(profileID));
			queryInformationType(senderID, COMPANION_PREFIX .. "2" .. profileID);
		end
	end
end

local function checkVersion(sender, senderVersion, senderVersionText, extendedVersion, extendedVersionText)
	-- Record all versions for statistics purpose.
	newVersionAlerts[senderVersionText] = newVersionAlerts[senderVersionText] or {};
	newVersionAlerts[senderVersionText][sender] = senderVersion;
	if extendedVersion and extendedVersionText then
		extendedNewVersionAlerts[extendedVersionText] = extendedNewVersionAlerts[extendedVersionText] or {};
		extendedNewVersionAlerts[extendedVersionText][sender] = extendedVersion;
	end

	-- Test for Total RP 3
	if  senderVersion > Globals.version and not has_seen_update_alert then
		if Utils.table.size(newVersionAlerts[senderVersionText]) >= 10 then
			local newVersionAlert = loc.NEW_VERSION:format(senderVersionText:sub(1, 15));
			local numberOfVersionsBehind = senderVersion - Globals.version;
			if numberOfVersionsBehind > 3 then
				newVersionAlert = newVersionAlert .. "\n\n" .. loc.NEW_VERSION_BEHIND:format(numberOfVersionsBehind)
			end
			TRP3_UpdateFrame.popup.text:SetText(newVersionAlert);
			TRP3_UpdateFrame:Show();
			has_seen_update_alert = true;
		end
	end

	-- Test for Extended
		if extendedVersion and extendedVersionText and Globals.extended_version and extendedVersion > Globals.extended_version and not has_seen_extended_update_alert then
			if Utils.table.size(extendedNewVersionAlerts[extendedVersionText]) >= 3 then
				Utils.message.displayMessage(loc.NEW_EXTENDED_VERSION:format(extendedVersionText));
			has_seen_extended_update_alert = true;
		end
	end
end

Comm.min = 100000;
Comm.max = 0;
Comm.totalDuration = 0;
Comm.numStat = 0;
local function closeStat(senderID, structure)
	if structure[senderID] then
		local duration = GetTime() - structure[senderID];
		Comm.min = math.min(Comm.min, duration);
		Comm.max = math.max(Comm.max, duration);
		Comm.totalDuration = Comm.totalDuration + duration;
		Comm.numStat = Comm.numStat + 1;
		structure[senderID] = nil;
	end
end

--- Send vernum request to the player
local function sendQuery(unitID)
	if unitID and unitID ~= Globals.player_id and not isIDIgnored(unitID) and checkCooldown(unitID, LAST_QUERY) then
		LAST_QUERY[unitID] = time();
		LAST_QUERY_STAT[unitID] = LAST_QUERY[unitID];
		local query = createVernumQuery();
		Comm.sendObject(VERNUM_QUERY_PREFIX, query, unitID, VERNUM_QUERY_PRIORITY);
	end
end
TRP3_API.r.sendQuery = sendQuery;

--- Incoming vernum query
-- This is received when another player has "mouseovered" you.
-- His main query is to receive your vernum tab. But you can already read his tab to query information.
local function incomingVernumQuery(structure, senderID, sendBack)
	-- First: Integrity check
	if type(structure) ~= "table"
	or #structure <= 0
	or type(structure[VERNUM_QUERY_INDEX_VERSION]) ~= "number"
	or type(structure[VERNUM_QUERY_INDEX_VERSION_DISPLAY]) ~= "string"
	or type(structure[VERNUM_QUERY_INDEX_CHARACTER_PROFILE]) ~= "string"
	then
		log("Incoming vernum integrity check fails. Sender: " .. senderID);
		return;
	end

	-- First send back or own vernum
	if sendBack then
		if checkCooldown(senderID, LAST_QUERY_R) then
			LAST_QUERY_R[senderID] = time();
			local query = createVernumQuery();
			Comm.sendObject(VERNUM_R_QUERY_PREFIX, query, senderID, VERNUM_QUERY_PRIORITY);
		end
	else
		closeStat(senderID, LAST_QUERY_STAT);
	end

	-- Data processing
	local senderVersion = structure[VERNUM_QUERY_INDEX_VERSION];
	local senderVersionText = structure[VERNUM_QUERY_INDEX_VERSION_DISPLAY];
	local senderProfileID = structure[VERNUM_QUERY_INDEX_CHARACTER_PROFILE];
	local senderExtendedVersion = structure[VERNUM_QUERY_INDEX_EXTENDED];
	local senderIsTrial = structure[VERNUM_QUERY_INDEX_TRIALS];
	local senderExtendedVersionText = structure[VERNUM_QUERY_INDEX_EXTENDED_DISPLAY];

	senderVersion = tonumber(senderVersion) or 0;
	senderExtendedVersion = tonumber(senderExtendedVersion) or 0;

	local clientName = Globals.addon_name;
	if senderExtendedVersion > 0 then
		clientName = Globals.addon_name_extended;
	end

	checkVersion(senderID, senderVersion, senderVersionText, senderExtendedVersion, senderExtendedVersionText);

	if not isUnitIDKnown(senderID) then
		addCharacter(senderID);
	end
	saveClientInformation(senderID, clientName, senderVersionText, false, senderExtendedVersion, senderIsTrial, senderExtendedVersionText);
	saveCurrentProfileID(senderID, senderProfileID);

	-- Query specific data, depending on version number.
	local index = VERNUM_QUERY_INDEX_CHARACTER_CHARACTERISTICS_V;
	for _, infoType in pairs(infoTypeTab) do
		if shouldUpdateInformation(senderID, infoType, structure[index]) then
			log(("Should update: %s's %s"):format(senderID, infoType));
			queryInformationType(senderID, infoType);
		end
		index = index + 1;
	end

	-- Battle pet
	local battlePetLine = structure[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET];
	local battlePetV1 = structure[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V1];
	local battlePetV2 = structure[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V2];
	parseCompanionInfo(senderID, senderProfileID, battlePetLine, battlePetV1, battlePetV2);

	-- Pet
	local petLine = structure[VERNUM_QUERY_INDEX_COMPANION_PET];
	local petV1 = structure[VERNUM_QUERY_INDEX_COMPANION_PET_V1];
	local petV2 = structure[VERNUM_QUERY_INDEX_COMPANION_PET_V2];
	parseCompanionInfo(senderID, senderProfileID, petLine, petV1, petV2);

	-- Mount
	local mountLine = structure[VERNUM_QUERY_INDEX_COMPANION_MOUNT];
	local mountV1 = structure[VERNUM_QUERY_INDEX_COMPANION_MOUNT_V1];
	local mountV2 = structure[VERNUM_QUERY_INDEX_COMPANION_MOUNT_V2];
	parseCompanionInfo(senderID, senderProfileID, mountLine, mountV1, mountV2);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Query for information
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CURRENT_QUERY_EXCHANGES = {};
TRP3_API.register.CURRENT_QUERY_EXCHANGES = CURRENT_QUERY_EXCHANGES;

function queryInformationType(unitName, informationType)
	if CURRENT_QUERY_EXCHANGES[unitName] and CURRENT_QUERY_EXCHANGES[unitName][informationType] then
		return; -- Don't ask again for information that are incoming !
	end
	if not CURRENT_QUERY_EXCHANGES[unitName] then
		CURRENT_QUERY_EXCHANGES[unitName] = {};
	end
	CURRENT_QUERY_EXCHANGES[unitName][informationType] = time();
	Comm.sendObject(INFO_TYPE_QUERY_PREFIX, informationType, unitName, INFO_TYPE_QUERY_PRIORITY);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Incoming query for information, and send information
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function incomingInformationType(informationType, senderID)
	local data;
	if informationType == registerInfoTypes.CHARACTERISTICS then
		data = getCharExchangeData();
	elseif informationType == registerInfoTypes.ABOUT then
		data = getAboutExchangeData();
	elseif informationType == registerInfoTypes.MISC then
		data = getMiscExchangeData();
	elseif informationType == registerInfoTypes.CHARACTER then
		data = getCharacterExchangeData();
	elseif informationType:sub(1, COMPANION_PREFIX:len()) == COMPANION_PREFIX then
		local v = informationType:sub(COMPANION_PREFIX:len() + 1, COMPANION_PREFIX:len() + 1);
		local profileID = informationType:sub(COMPANION_PREFIX:len() + 2);
		data = getCompanionData(profileID, v);
	end
	if data then
		log(("Send %s info to %s"):format(informationType, senderID));
		AddOn_TotalRP3.Communications.sendObject(INFO_TYPE_SEND_PREFIX, {informationType, data}, senderID, INFO_TYPE_SEND_PRIORITY, nil, true);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Received information
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function incomingInformationTypeSent(structure, senderID, channel)
	if not channel:find("LOGGED", nil, true) and not channel:find("BATTLENET", nil, true) then
		return -- ignore non logged profiles
	end
	local informationType = structure[1];
	local data = structure[2];

	if not CURRENT_QUERY_EXCHANGES[senderID] or not CURRENT_QUERY_EXCHANGES[senderID][informationType] then
		return; -- We didn't ask for theses information ...
	end

	log(("Received %s's %s info !"):format(senderID, informationType));
	CURRENT_QUERY_EXCHANGES[senderID][informationType] = nil;

	local decodedData = data;
	-- If the data is a string, we assume that it was compressed.
	if type(data) == "string" then
		decodedData = Utils.serial.safeDecompressCodedStructure(decodedData, {});
	end

	if informationType == registerInfoTypes.CHARACTERISTICS or informationType == registerInfoTypes.ABOUT
	or informationType == registerInfoTypes.MISC or informationType == registerInfoTypes.CHARACTER then
		saveInformation(senderID, informationType, decodedData);
	elseif informationType:sub(1, COMPANION_PREFIX:len()) == COMPANION_PREFIX then
		local v = informationType:sub(COMPANION_PREFIX:len() + 1, COMPANION_PREFIX:len() + 1);
		local profileID = informationType:sub(COMPANION_PREFIX:len() + 2);
		saveCompanionInformation(profileID, v, data)
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TRIGGERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local companionIDToInfo = Utils.str.companionIDToInfo;

local function onMouseOverCharacter(unitID)
	sendQuery(unitID);
end

local function onMouseOverCompanion(companionFullID)
	local ownerID = companionIDToInfo(companionFullID);
	if isUnitIDKnown(ownerID) then
		sendQuery(ownerID);
	end
end

local function onTargetChanged()
	local unitID = Utils.str.getUnitID("target");
	if UnitIsPlayer("target") then
		sendQuery(unitID);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Check size
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ALERT_FOR_SIZE = 20;

local function checkPlayerDataWeight()
	local totalData = {getCharExchangeData(), getAboutExchangeData(), getMiscExchangeData(), getCharacterExchangeData()};
	local computedSize = Comm.estimateStructureLoad(totalData);
	if computedSize > ALERT_FOR_SIZE then
		log(("Profile too heavy ! It would take %s messages to send."):format(computedSize));
		if getConfigValue("heavy_profile_alert") then
			TRP3_API.ui.tooltip.toast(loc.REG_PLAYER_ALERT_HEAVY_SMALL, 5);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
TRP3_API.register.HAS_NOT_YET_RESPONDED = LAST_QUERY_STAT;

function TRP3_API.register.inits.dataExchangeInit()
	if not TRP3_Register then
		TRP3_Register = {};
	end

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID)
		if unitID == Globals.player_id then
			checkPlayerDataWeight();
		end
	end);

	-- Listen to the mouse over event
	TRP3_API.events.listenToEvent(TRP3_API.events.MOUSE_OVER_CHANGED, function(targetID, targetMode)
		if targetMode == TYPE_CHARACTER and targetID then
			onMouseOverCharacter(targetID);
		elseif (targetMode == TYPE_BATTLE_PET or targetMode == TYPE_PET) and targetID then
			onMouseOverCompanion(targetID);
		end
	end);
	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);

	-- Register prefix for data exchange
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(VERNUM_QUERY_PREFIX, function(structure, senderID)
		incomingVernumQuery(structure, senderID, true);
	end);
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(VERNUM_R_QUERY_PREFIX, function(structure, senderID)
		incomingVernumQuery(structure, senderID, false);
	end);
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(INFO_TYPE_QUERY_PREFIX, incomingInformationType);
	AddOn_TotalRP3.Communications.registerSubSystemPrefix(INFO_TYPE_SEND_PREFIX, incomingInformationTypeSent);

	-- When receiving HELLO from someone else (from the other side ?)
	AddOn_TotalRP3.Communications.broadcast.registerCommand(Comm.broadcast.HELLO_CMD, function(sender, version, versionDisplay, extendedVersion, extendedVersionDisplay)
		version = tonumber(version) or 0;
		extendedVersion = tonumber(extendedVersion) or 0;
		-- Only treat the message if it does not come from us
		if sender ~= Globals.player_id then
			checkVersion(sender, version, versionDisplay, extendedVersion, extendedVersionDisplay);
		end
	end);
end

local UNIT_TOKENS = { "target", "mouseover", "player", "focus" };
UNIT_TOKENS = tInvert(UNIT_TOKENS);
TRP3_API.slash.registerCommand({
	id = "open",
	helpLine = " " .. loc.PR_SLASH_OPEN_HELP,
	handler = function(...)
		local args = {...};

		if commandOpeningTimerHandle then
			commandOpeningTimerHandle:Cancel();
		end

		if #args > 1 then
			displayMessage(loc.PR_SLASH_OPEN_EXAMPLE);
			return
		elseif #args == 1 then
			characterToOpen = table.concat(args, " ");

			if UNIT_TOKENS[characterToOpen:lower()] then
				-- If we typed a unit token we resolve it
				characterToOpen = Utils.str.getUnitID(characterToOpen:lower());
			else
				-- Capitalizing first letter of the name, just in case someone is lazy.
				-- We don't have a solution for "I'm lazy but need someone from another realm" yet.
				characterToOpen = characterToOpen:gsub("^%l", string.upper);
			end

			-- If no realm has been entered, we use the player's realm automatically
			if not characterToOpen:find("-") then
				characterToOpen = characterToOpen .. "-" .. TRP3_API.globals.player_realm_id;
			end
		else
			-- If no name is provided, we use the target ID
			if UnitIsPlayer("target") then
				characterToOpen = Utils.str.getUnitID("target");
			else
				displayMessage(loc.PR_SLASH_OPEN_EXAMPLE);
				return
			end
		end

		sendQuery(characterToOpen);
		msp:Request(characterToOpen, AddOn_TotalRP3.MSP.REQUEST_FIELDS);
		-- If we already have a profile for that user in the registry, we open it and reset the name (so it doesn't try to open again afterwards)
		if characterToOpen == TRP3_API.globals.player_id or (isUnitIDKnown(characterToOpen) and hasProfile(characterToOpen)) then
			TRP3_API.navigation.openMainFrame();
			TRP3_API.register.openPageByUnitID(characterToOpen);
			characterToOpen = "";
		else
			displayMessage(loc.PR_SLASH_OPEN_WAITING);

			-- If after 1 minute they didn't reply, abort
			commandOpeningTimerHandle = newTimer(60, function()
				displayMessage(loc.PR_SLASH_OPEN_ABORTING);
				characterToOpen = "";
			end)
		end
	end
})

-- Event for the "/trp3 open" command
Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, _, dataType)
	if unitID == characterToOpen and (not dataType or dataType == "character") then
		TRP3_API.navigation.openMainFrame();
		TRP3_API.register.openPageByUnitID(characterToOpen);
		if commandOpeningTimerHandle then
			commandOpeningTimerHandle:Cancel();
		end
		characterToOpen = "";
	end
end);

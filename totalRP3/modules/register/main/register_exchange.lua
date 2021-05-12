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
local getCompanionData = TRP3_API.companions.player.getCompanionData;
local saveCompanionInformation = TRP3_API.companions.register.saveInformation;
local displayMessage = TRP3_API.utils.message.displayMessage;
local TRP3_Enums = AddOn_TotalRP3.Enums;

-- WoW imports
local newTimer = C_Timer.NewTimer;

-- Character name for profile opening command
local characterToOpen = "";
local commandOpeningTimerHandle;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local has_seen_update_alert, has_seen_extended_update_alert = false, false;

local band = bit.band;
local bxor = bit.bxor;
local floor = math.floor;
local strbyte = string.byte;

local function mul(x, y)
	return (band(x, 0xffff) * y) + (band(floor(x / 65536) * y, 0xffff) * 65536);
end

local function FNV1A(str)
	local hash = 2166136261;

	for i = 1, #str do
		local b = strbyte(str, i);
		hash = bxor(hash, b);
		hash = mul(hash, 16777619);
	end

	return hash;
end

local FNV1ACache = setmetatable({},
	{
		__mode = "k",
		__index = function(t, k)
			t[k] = FNV1A(k);
			return t[k];
		end,
	}
);

local KnownBadVersions =
{
	[97] = true,  -- 2.3.3: Affected by a bug where it thinks things are out of date.
	[98] = true,  -- 2.3.4: As above, resolved in 2.3.5.
};

local senderBadVersions = {};
local senderObjectRequestTimes = {};

local function GetOrCreateTable(t, key)
	if t[key] ~= nil then
		return t[key];
	end

	t[key] = {};
	return t[key];
end

local function RecordIncomingVersion(sender, version)
	if KnownBadVersions[version] then
		senderBadVersions[sender] = version;
	else
		senderBadVersions[sender] = nil;
	end
end

local function IsSenderRunningBadVersion(sender)
	return senderBadVersions[sender] ~= nil;
end

local function RecordSenderObjectRequestTime(sender, infoType)
	if IsSenderRunningBadVersion(sender) then
		local requestTimes = GetOrCreateTable(senderObjectRequestTimes, sender);
		requestTimes[infoType] = GetTime();
	end
end

local function ShouldRespondToObjectRequest(sender, infoType)
	local BAD_VERSION_OBJECT_THROTTLE = 180;

	local requestTimes = senderObjectRequestTimes[sender];

	if type(requestTimes) ~= "table" then
		return true;   -- They're running an okay version.
	end

	local requestTimeAt = requestTimes[infoType];

	if type(requestTimeAt) ~= "number" then
		return true;   -- They may have a bad version but they've not asked for this data.
	elseif GetTime() >= (requestTimeAt + BAD_VERSION_OBJECT_THROTTLE) then
		return true;   -- The last response was a while ago.
	else
		return false;  -- Don't respond; received another request too soon.
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Check size
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ALERT_FOR_SIZE = 20;
local cachedPlayerWeight;

local function CalculatePlayerDataWeight()
	return Comm.estimateStructureLoad(
		{
			getCharExchangeData(),
			getAboutExchangeData(),
			getMiscExchangeData(),
			getCharacterExchangeData(),
		}
	);
end

local function RecalculatePlayerDataWeight()
	cachedPlayerWeight = CalculatePlayerDataWeight();
end

local function GetPlayerDataWeight()
	if not cachedPlayerWeight then
		RecalculatePlayerDataWeight();
	end

	return cachedPlayerWeight;
end

local function checkPlayerDataWeight()
	RecalculatePlayerDataWeight();

	local computedSize = GetPlayerDataWeight();
	if computedSize > ALERT_FOR_SIZE then
		log(("Profile too heavy ! It would take %s messages to send."):format(computedSize));
		TRP3_API.ui.tooltip.toast(loc.REG_PLAYER_ALERT_HEAVY_SMALL, 5);
	end
end

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
local VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET = 11;
local VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET_V1 = 12;
local VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET_V2 = 13;
local VERNUM_QUERY_INDEX_COMPANION_MOUNT = 14;
local VERNUM_QUERY_INDEX_COMPANION_MOUNT_V1 = 15;
local VERNUM_QUERY_INDEX_COMPANION_MOUNT_V2 = 16;
local VERNUM_QUERY_INDEX_EXTENDED = 17;
local VERNUM_QUERY_INDEX_TRIALS = 18;
local VERNUM_QUERY_INDEX_EXTENDED_DISPLAY = 19;
local VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET = 20;
local VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET_V1 = 21;
local VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET_V2 = 22;

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
	local battlePetLine, battlePetV1, battlePetV2 = TRP3_API.companions.player.getCurrentBattlePetQueryLine();
	query[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET] = battlePetLine or "";
	query[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V1] = battlePetV1 or 0;
	query[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V2] = battlePetV2 or 0;
	local primaryPetLine, primaryPetV1, primaryPetV2 = TRP3_API.companions.player.getCurrentPetQueryLine();
	query[VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET] = primaryPetLine or "";
	query[VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET_V1] = primaryPetV1 or 0;
	query[VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET_V2] = primaryPetV2 or 0;
	local secondaryPetLine, secondaryPetV1, secondaryPetV2 = TRP3_API.companions.player.getCurrentSecondaryPetQueryLine();
	query[VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET] = secondaryPetLine or "";
	query[VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET_V1] = secondaryPetV1 or 0;
	query[VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET_V2] = secondaryPetV2 or 0;
	local mountLine, mountV1, mountV2 = TRP3_API.companions.player.getCurrentMountQueryLine();
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
	return not structure[unitID] or GetTime() - structure[unitID] > COOLDOWN_DURATION;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Incoming vernum queries
-- Check version numbers and perform information queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- We will store new versions alerts to remember how many people notified us of a new version.
local newVersionAlerts, extendedNewVersionAlerts = {}, {};

local QueueStrategy =
{
	-- The independent queue strategy leaves the role of queuing messages
	-- to the underlying transport mechanism. Typically this will put all
	-- messages to a single player in single per-channel queue, and is best
	-- for small streams of messages.
	Independent = 1,

	-- The pooled queue strategy uses a fixed set of queues used for all
	-- comms from the player to other people irrespective of channel. This
	-- is enabled when dealing with players who are sending profiles above
	-- a minimum weight threshold.
	--
	-- This strategy is best used for larger data transfers where the number
	-- of people we may be sending data to could be a large number. Using
	-- pooled queues should improve comms performance for both other addons
	-- and any metadata-style comms from ourselves.
	Pooled = 2,
};

local DEFAULT_QUEUE_POOL_COUNT = 10;
local MINIMUM_QUEUE_POOL_COUNT = 5;
local MAXIMUM_QUEUE_POOL_COUNT = 30;

local DEFAULT_QUEUE_POOL_MINIMUM_WEIGHT = 4;
local MINIMUM_QUEUE_POOL_MINIMUM_WEIGHT = 1;
local MAXIMUM_QUEUE_POOL_MINIMUM_WEIGHT = 20;

-- The below is exposed purely for the settings UI; don't rely on these.
TRP3_API.r.MINIMUM_QUEUE_POOL_COUNT = MINIMUM_QUEUE_POOL_COUNT;
TRP3_API.r.MAXIMUM_QUEUE_POOL_COUNT = MAXIMUM_QUEUE_POOL_COUNT;
TRP3_API.r.MINIMUM_QUEUE_POOL_MINIMUM_WEIGHT = MINIMUM_QUEUE_POOL_MINIMUM_WEIGHT;
TRP3_API.r.MAXIMUM_QUEUE_POOL_MINIMUM_WEIGHT = MAXIMUM_QUEUE_POOL_MINIMUM_WEIGHT;

local function GetQueuePoolCount()
	local count = tonumber(TRP3_API.configuration.getValue("Exchange_QueuePoolCount"));

	if type(count) ~= "number" then
		count = DEFAULT_QUEUE_POOL_COUNT;
	end

	return Clamp(count, MINIMUM_QUEUE_POOL_COUNT, MAXIMUM_QUEUE_POOL_COUNT);
end

local function GetQueuePoolMinimumWeight()
	local threshold = tonumber(TRP3_API.configuration.getValue("Exchange_QueuePoolWeightThreshold"));

	if type(threshold) ~= "number" then
		threshold = DEFAULT_QUEUE_POOL_MINIMUM_WEIGHT;
	end

	return Clamp(threshold, MINIMUM_QUEUE_POOL_MINIMUM_WEIGHT, MAXIMUM_QUEUE_POOL_MINIMUM_WEIGHT);
end

local function GetSuggestedQueueStrategy(query, infoType, target)  -- luacheck: no unused
	if query == INFO_TYPE_SEND_PREFIX and GetPlayerDataWeight() >= GetQueuePoolMinimumWeight() then
		return QueueStrategy.Pooled;
	else
		return QueueStrategy.Independent;
	end
end

local function GenerateQueueName(query, infoType, target)
	local strategy = GetSuggestedQueueStrategy(query, infoType, target);

	if strategy == QueueStrategy.Independent then
		return nil;
	elseif strategy == QueueStrategy.Pooled then
		local queueIndex = Wrap(FNV1ACache[target], GetQueuePoolCount());
		return string.format("TRP3-Queue-%d", queueIndex);
	else
		error("unknown queue strategy: " .. tostring(strategy));
	end
end

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
		LAST_QUERY[unitID] = GetTime();
		LAST_QUERY_STAT[unitID] = LAST_QUERY[unitID];
		local query = createVernumQuery();
		Comm.sendObject(VERNUM_QUERY_PREFIX, query, unitID, VERNUM_QUERY_PRIORITY);
	end
end
TRP3_API.r.sendQuery = sendQuery;

local function TryQueryInformation(target, infoType, currentData)
	if shouldUpdateInformation(target, infoType, currentData) then
		log(("Should update: %s's %s"):format(target, infoType));
		queryInformationType(target, infoType);
	end
end

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
			LAST_QUERY_R[senderID] = GetTime();
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

	RecordIncomingVersion(senderID, senderVersion);

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
	TryQueryInformation(senderID, registerInfoTypes.CHARACTERISTICS, structure[VERNUM_QUERY_INDEX_CHARACTER_CHARACTERISTICS_V]);
	TryQueryInformation(senderID, registerInfoTypes.CHARACTER, structure[VERNUM_QUERY_INDEX_CHARACTER_CHARACTER_V]);
	TryQueryInformation(senderID, registerInfoTypes.MISC, structure[VERNUM_QUERY_INDEX_CHARACTER_MISC_V]);
	TryQueryInformation(senderID, registerInfoTypes.ABOUT, structure[VERNUM_QUERY_INDEX_CHARACTER_ABOUT_V]);

	-- Battle pet
	local battlePetLine = structure[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET];
	local battlePetV1 = structure[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V1];
	local battlePetV2 = structure[VERNUM_QUERY_INDEX_COMPANION_BATTLE_PET_V2];
	parseCompanionInfo(senderID, senderProfileID, battlePetLine, battlePetV1, battlePetV2);

	-- Primary Pet
	local primaryPetLine = structure[VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET];
	local primaryPetV1 = structure[VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET_V1];
	local primaryPetV2 = structure[VERNUM_QUERY_INDEX_COMPANION_PRIMARY_PET_V2];
	parseCompanionInfo(senderID, senderProfileID, primaryPetLine, primaryPetV1, primaryPetV2);

	-- Secondary Pet
	local secondaryPetLine = structure[VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET];
	local secondaryPetV1 = structure[VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET_V1];
	local secondaryPetV2 = structure[VERNUM_QUERY_INDEX_COMPANION_SECONDARY_PET_V2];

	if secondaryPetLine then
		parseCompanionInfo(senderID, senderProfileID, secondaryPetLine, secondaryPetV1, secondaryPetV2);
	end

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
	CURRENT_QUERY_EXCHANGES[unitName][informationType] = GetTime();
	Comm.sendObject(INFO_TYPE_QUERY_PREFIX, informationType, unitName, INFO_TYPE_QUERY_PRIORITY);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Incoming query for information, and send information
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function incomingInformationType(informationType, senderID)
	if not ShouldRespondToObjectRequest(senderID, informationType) then
		return;
	end

	RecordSenderObjectRequestTime(senderID, informationType);

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

		local prefix = INFO_TYPE_SEND_PREFIX;
		local object = { informationType, data };
		local channel = "WHISPER";
		local target = senderID;
		local priority = INFO_TYPE_SEND_PRIORITY;
		local messageToken = nil;
		local useLoggedMessages = true;
		local queue = GenerateQueueName(prefix, informationType, senderID);

		AddOn_TotalRP3.Communications.sendObject(prefix, object, channel, target, priority, messageToken, useLoggedMessages, queue);
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
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.register.HAS_NOT_YET_RESPONDED = LAST_QUERY_STAT;

function TRP3_API.register.inits.dataExchangeInit()
	if not TRP3_Register then
		TRP3_Register = {};
	end

	TRP3_API.configuration.registerConfigKey("Exchange_QueuePoolCount", DEFAULT_QUEUE_POOL_COUNT);
	TRP3_API.configuration.registerConfigKey("Exchange_QueuePoolWeightThreshold", DEFAULT_QUEUE_POOL_MINIMUM_WEIGHT);

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID)
		if unitID == Globals.player_id then
			checkPlayerDataWeight();
		end
	end);

	-- Listen to the mouse over event
	TRP3_API.events.listenToEvent(TRP3_API.events.MOUSE_OVER_CHANGED, function(targetID, targetMode)
		if targetMode == TRP3_Enums.UNIT_TYPE.CHARACTER and targetID then
			onMouseOverCharacter(targetID);
		elseif (targetMode == TRP3_Enums.UNIT_TYPE.BATTLE_PET or targetMode == TRP3_Enums.UNIT_TYPE.PET) and targetID then
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

function TRP3_API.slash.openProfile(...)
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
			-- Capitalizing first letter of the name/realm, just in case someone is lazy.
			local name, realm = AddOn_Chomp.NameSplitRealm(characterToOpen);

			-- If the split fails due to the user only giving a name then
			-- neither a name/realm will be returned; in this case we'll
			-- assume the input is name-only and use the current realm.

			name  = name or characterToOpen;
			realm = realm or TRP3_API.globals.player_realm_id;

			name  = string.gsub(name, "^%l", string.upper);
			realm = string.gsub(realm, "^%l", string.upper);

			characterToOpen = AddOn_Chomp.NameMergedRealm(name, realm);
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
	TRP3_API.r.sendMSPQuery(characterToOpen);
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

TRP3_API.slash.registerCommand({
	id = "open",
	helpLine = " " .. loc.PR_SLASH_OPEN_HELP,
	handler = TRP3_API.slash.openProfile,
})

-- Event for the "/trp3 open" command
Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, _, dataType)
	if AddOn_Chomp.InsensitiveStringEquals(characterToOpen, unitID)
		and (not dataType or dataType == "character") then
		-- Use the unitID when opening the UI as it will be precisely what's
		-- in the register, whereas characterToOpen might have incorrect
		-- casing if, for example, the user typed the name in all-caps.

		TRP3_API.navigation.openMainFrame();
		TRP3_API.register.openPageByUnitID(unitID);
		if commandOpeningTimerHandle then
			commandOpeningTimerHandle:Cancel();
		end
		characterToOpen = "";
	end
end);

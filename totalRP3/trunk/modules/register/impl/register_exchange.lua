--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Data exchange
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- TRP3 imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local get = TRP3_API.profile.getData;
local Comm = TRP3_API.communication;
local log = Utils.log.log;
local Events = TRP3_API.events;
local getPlayerCharacter = TRP3_API.profile.getPlayerCharacter;
local getCharacterExchangeData = TRP3_API.register.getCharacterExchangeData;
local registerInfoTypes = TRP3_API.register.registerInfoTypes;
local isIDIgnored, shouldUpdateInformation = TRP3_API.register.isIDIgnored, TRP3_API.register.shouldUpdateInformation;
local addCharacter = TRP3_API.register.addCharacter;
local saveCurrentProfileID, saveClientInformation, saveInformation = TRP3_API.register.saveCurrentProfileID, TRP3_API.register.saveClientInformation, TRP3_API.register.saveInformation;
local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local playerAPI = TRP3_API.register.player;
local getCharExchangeData = playerAPI.getCharacteristicsExchangeData;
local getAboutExchangeData = playerAPI.getAboutExchangeData;
local getMiscExchangeData = playerAPI.getMiscExchangeData;

-- WoW imports
local UnitName, UnitIsPlayer, UnitFactionGroup, CheckInteractDistance = UnitName, UnitIsPlayer, UnitFactionGroup, CheckInteractDistance;
local tinsert, time, type, pairs = tinsert, time, type, pairs;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function configIsAutoAdd()
	return true; --TODO : config
end

local function configShowVersionAlert()
	return false; --TODO : config
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Outgoing queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local LAST_QUERY = {};
local COOLDOWN_DURATION = 1; -- Should be integer
local VERNUM_QUERY_PREFIX = "VQ";
local VERNUM_R_QUERY_PREFIX = "VR";
local INFO_TYPE_QUERY_PREFIX = "GI";
local INFO_TYPE_SEND_PREFIX = "SI";
local VERNUM_QUERY_PRIORITY = "NORMAL";
local INFO_TYPE_QUERY_PRIORITY = "NORMAL";
local INFO_TYPE_SEND_PRIORITY = "BULK";

--- Vernum query builder
local function createVernumQuery()
	local query = {};
	tinsert(query, Globals.version); -- Your TRP3 version (number)
	tinsert(query, Globals.version_display); -- Your TRP3 version (as it should be shown on tooltip)
	tinsert(query, getPlayerCurrentProfileID());
	tinsert(query, get("player/characteristics").v);
	tinsert(query, get("player/about").v);
	tinsert(query, get("player/misc").v);
	tinsert(query, getPlayerCharacter().v or 1);
	return query;
end

local function queryVernum(unitName)
	local query = createVernumQuery();
	Comm.sendObject(VERNUM_QUERY_PREFIX, query, unitName, VERNUM_QUERY_PRIORITY);
end

local function queryMarySueProtocol(unitName)

end

local CURRENT_QUERY_EXCHANGES = {};

local function queryInformationType(unitName, informationType)
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
-- Incoming queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local infoTypeTab = {
	registerInfoTypes.CHARACTERISTICS,
	registerInfoTypes.ABOUT,
	registerInfoTypes.MISC,
	registerInfoTypes.CHARACTER
};

--- Incoming vernum query
-- This is received when another player has "mouseovered" you.
-- His main query is to receive your vernum tab. But you can already read his tab to query information.
local function incomingVernumQuery(structure, senderID, bResponse)
	-- First: Integrity check
	if type(structure) ~= "table"
	or #structure <= 0
	or type(structure[1]) ~= "number"
	or type(structure[2]) ~= "string"
	or type(structure[3]) ~= "string"
	then
		log("Incoming vernum integrity check fails. Sender: " .. senderID);
		return;
	end

	-- First send back or own vernum
	if not bResponse and (not LAST_QUERY[senderID] or time() - LAST_QUERY[senderID] > COOLDOWN_DURATION) then
		local query = createVernumQuery();
		Comm.sendObject(VERNUM_R_QUERY_PREFIX, query, senderID, VERNUM_QUERY_PRIORITY);
	end

	-- Data processing
	local senderVersion = structure[1];
	local senderVersionText = structure[2];
	local senderProfileID = structure[3];

	if configShowVersionAlert() and senderVersion > Globals.version then
	-- TODO: show version alert.
	end

	if isUnitIDKnown(senderID) or configIsAutoAdd() then
		if not isUnitIDKnown(senderID) then
			addCharacter(senderID);
		end
		saveClientInformation(senderID, Globals.addon_name, senderVersionText, false);
		saveCurrentProfileID(senderID, senderProfileID);

		-- Query specific data, depending on version number.
		local index = 4;
		for _, infoType in pairs(infoTypeTab) do
			if shouldUpdateInformation(senderID, infoType, structure[index]) then
				log(("Should update: %s's %s"):format(senderID, infoType));
				queryInformationType(senderID, infoType);
			end
			index = index + 1;
		end
	end
end

--- Incoming vernum response
-- This is received when you asked a player for his vernum tab and he responses.
-- In that case we shouldn't query him anymore as it would bring an infinite loop.
local function incomingVernumResponseQuery(structure, senderID)
	incomingVernumQuery(structure, senderID, true);
end

local function incomingInformationType(informationType, senderID)
	local data = nil;
	if informationType == registerInfoTypes.CHARACTERISTICS then
		data = getCharExchangeData();
	elseif informationType == registerInfoTypes.ABOUT then
		data = getAboutExchangeData();
	elseif informationType == registerInfoTypes.MISC then
		data = getMiscExchangeData();
	elseif informationType == registerInfoTypes.CHARACTER then
		data = getCharacterExchangeData();
	end
	Comm.sendObject(INFO_TYPE_SEND_PREFIX, {informationType, data}, senderID, INFO_TYPE_SEND_PRIORITY);
end

local function incomingInformationTypeSent(structure, senderID)
	local informationType = structure[1];
	local data = structure[2];
	
	if not CURRENT_QUERY_EXCHANGES[senderID] or not CURRENT_QUERY_EXCHANGES[senderID][informationType] then
		return; -- We didn't ask for theses information ...
	end
	
	log(("Received %s's %s info !"):format(senderID, informationType));
	local decodedData = data;
	if type(data) == "string" then
		decodedData = Utils.serial.decompressCodedStructure(decodedData);
	end
	saveInformation(senderID, informationType, decodedData);
	
	CURRENT_QUERY_EXCHANGES[senderID][informationType] = nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TRIGGERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Send vernum request to the player
local function sendQuery(type)
	local unitID = Utils.str.getUnitID(type);
	if unitID -- unitID equals nil if no character under the mouse (possible if the event trigger is delayed), or if UNKOWN (if player not loaded)
		and UnitIsPlayer(type) -- Don't query NPC
		and unitID ~= Globals.player_id -- Don't query yourself
		and UnitFactionGroup(type) == UnitFactionGroup(type) -- Don't query other faction !
		and (type ~= "mouseover" or CheckInteractDistance(type, 4)) -- Should be at range, this is kind of optimization
		and (type ~= "mouseover" or isUnitIDKnown(unitID)) -- Only query known characters
		and not isIDIgnored(unitID)
		and (not LAST_QUERY[unitID] or time() - LAST_QUERY[unitID] > COOLDOWN_DURATION) -- Optimization (cooldown from last query)
	then
		LAST_QUERY[unitID] = time();
		queryVernum(unitID);
		queryMarySueProtocol(unitID);
	end
end

local function onMouseOver(...)
	sendQuery("mouseover");
end

local function onTargetChanged(...)
	sendQuery("target");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Check size
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ALERT_FOR_SIZE = 20;

local function checkPlayerDataWeight()
	local totalData = {getCharExchangeData(), getAboutExchangeData(), getMiscExchangeData(), getCharacterExchangeData()};
	local computedSize = Comm.estimateStructureLoad(totalData);
	if computedSize > ALERT_FOR_SIZE then
		log(("Profile to heavy ! It would take %s messages to send."):format(computedSize));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.register.inits.dataExchangeInit()

	if not TRP3_Register then
		TRP3_Register = {};
	end
	
	Events.listenToEvents({Events.REGISTER_ABOUT_SAVED, Events.REGISTER_CHARACTERISTICS_SAVED}, checkPlayerDataWeight);

	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);
	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);

	-- Register prefix for data exchange
	Comm.registerProtocolPrefix(VERNUM_QUERY_PREFIX, incomingVernumQuery);
	Comm.registerProtocolPrefix(VERNUM_R_QUERY_PREFIX, incomingVernumResponseQuery);
	Comm.registerProtocolPrefix(INFO_TYPE_QUERY_PREFIX, incomingInformationType);
	Comm.registerProtocolPrefix(INFO_TYPE_SEND_PREFIX, incomingInformationTypeSent);
end
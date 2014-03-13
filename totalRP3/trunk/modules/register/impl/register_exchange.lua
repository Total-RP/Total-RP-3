--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Data exchange
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- TRP3 API
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local get = TRP3_PROFILE.getData;
local Comm = TRP3_COMM;
local log = Utils.log.log;
-- WoW API
local UnitName = UnitName;
local CheckInteractDistance = CheckInteractDistance;
local UnitIsPlayer = UnitIsPlayer;
local UnitFactionGroup = UnitFactionGroup;
local tinsert = tinsert;
local type = type;
local time = time;

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
	tinsert(query, TRP3_GetProfileID());
	tinsert(query, get("player/characteristics").v);
	tinsert(query, get("player/about").v);
	tinsert(query, get("player/misc").v);
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
	TRP3_RegisterInfoTypes.CHARACTERISTICS,
	TRP3_RegisterInfoTypes.ABOUT,
	TRP3_RegisterInfoTypes.MISC
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

	if TRP3_IsUnitIDKnown(senderID) or configIsAutoAdd() then
		if not TRP3_IsUnitIDKnown(senderID) then
			TRP3_RegisterAddCharacter(senderID);
		end
		TRP3_RegisterSetClient(senderID, Globals.clients.TRP3, senderVersionText);
		TRP3_RegisterSetCurrentProfile(senderID, senderProfileID);

		-- Query specific data, depending on version number.
		local index = 4;
		for _, infoType in pairs(infoTypeTab) do
			if TRP3_RegisterShouldUpdateInfo(senderID, infoType, structure[index]) then
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
	if informationType == TRP3_RegisterInfoTypes.CHARACTERISTICS then
		data = TRP3_RegisterCharacteristicsGetExchangeData();
	elseif informationType == TRP3_RegisterInfoTypes.ABOUT then
		data = TRP3_RegisterAboutGetExchangeData();
	elseif informationType == TRP3_RegisterInfoTypes.MISC then
		data = TRP3_RegisterMiscGetExchangeData();
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
	TRP3_RegisterSetInforType(senderID, informationType, decodedData);
	TRP3_ShouldRefreshTooltip(senderID);
	
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
		and (type ~= "mouseover" or TRP3_IsUnitIDKnown(unitID)) -- Only query known characters
		
		and not TRP3_IsPlayerIgnored(unitID)
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
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_DataExchangeInit()

	if not TRP3_Register then
		TRP3_Register = {};
	end

	-- Listen to the mouse over event
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);
	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);

	-- Register prefix for data exchange
	Comm.registerProtocolPrefix(VERNUM_QUERY_PREFIX, incomingVernumQuery);
	Comm.registerProtocolPrefix(VERNUM_R_QUERY_PREFIX, incomingVernumResponseQuery);
	Comm.registerProtocolPrefix(INFO_TYPE_QUERY_PREFIX, incomingInformationType);
	Comm.registerProtocolPrefix(INFO_TYPE_SEND_PREFIX, incomingInformationTypeSent);
end
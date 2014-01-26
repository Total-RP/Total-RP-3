--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Data exchange
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- TRP3 API
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local get = TRP3_Profile_DataGetter;
-- WoW API
local UnitName = UnitName;
local CheckInteractDistance = CheckInteractDistance;
local UnitIsPlayer = UnitIsPlayer;
local UnitFactionGroup = UnitFactionGroup;

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
	tinsert(query, TRP3_VERSION); -- Your TRP3 version (number)
	tinsert(query, TRP3_VERSION_USER); -- Your TRP3 version (as it should be shown on tooltip)
	tinsert(query, TRP3_GetProfileID());
	tinsert(query, get("player/characteristics").v);
	tinsert(query, get("player/about").v);
	tinsert(query, get("player/style").v);
	tinsert(query, get("player/misc").v);
	return query;
end

local function queryVernum(unitName)
	local query = createVernumQuery();
	TRP3_SendObject(VERNUM_QUERY_PREFIX, query, unitName, VERNUM_QUERY_PRIORITY);
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
	TRP3_SendObject(INFO_TYPE_QUERY_PREFIX, informationType, unitName, INFO_TYPE_QUERY_PRIORITY);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Incoming queries
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local infoTypeTab = {
	TRP3_RegisterInfoTypes.CHARACTERISTICS,
	TRP3_RegisterInfoTypes.ABOUT,
	TRP3_RegisterInfoTypes.STYLE,
	TRP3_RegisterInfoTypes.MISC
};

--- Incoming vernum query
-- This is received when another player has "mouseovered" you.
-- His main query is to receive your vernum tab. But you can already read his tab to query information.
local function incomingVernumQuery(structure, sender, bResponse)
	-- First: Integrity check
	if type(structure) ~= "table"
	or #structure <= 0
	or type(structure[1]) ~= "number"
	or type(structure[2]) ~= "string"
	or type(structure[3]) ~= "string"
	then
		log("Incoming vernum integrity check fails. Sender: " .. sender);
		return;
	end

	-- First send back or own vernum
	if not bResponse and (not LAST_QUERY[sender] or time() - LAST_QUERY[sender] > COOLDOWN_DURATION) then
		local query = createVernumQuery();
		TRP3_SendObject(VERNUM_R_QUERY_PREFIX, query, sender, VERNUM_QUERY_PRIORITY);
	end

	-- Data processing
	local senderVersion = structure[1];
	local senderVersionText = structure[2];
	local senderProfileID = structure[3];

	if configShowVersionAlert() and senderVersion > TRP3_VERSION then
	-- TODO: show version alert.
	end

	if TRP3_IsUnitKnown(sender) or configIsAutoAdd() then
		if not TRP3_IsUnitKnown(sender) then
			TRP3_RegisterAddCharacter(sender);
		end
		TRP3_RegisterSetClient(sender, TRP3_CLIENTS.TRP3, senderVersionText);
		TRP3_RegisterSetCurrentProfile(sender, senderProfileID);

		-- Query specific data, depending on version number.
		local index = 4;
		for _, infoType in pairs(infoTypeTab) do
			if TRP3_RegisterShouldUpdateInfo(sender, infoType, structure[index]) then
				log(("Should update: %s's %s"):format(sender, infoType));
				queryInformationType(sender, infoType);
			end
			index = index + 1;
		end
	end
end

--- Incoming vernum response
-- This is received when you asked a player for his vernum tab and he responses.
-- In that case we shouldn't query him anymore as it would bring an infinite loop.
local function incomingVernumResponseQuery(structure, sender)
	incomingVernumQuery(structure, sender, true);
end

local function incomingInformationType(informationType, sender)
	local data = nil;
	if informationType == TRP3_RegisterInfoTypes.CHARACTERISTICS then
		data = TRP3_RegisterCharacteristicsGetExchangeData();
	elseif informationType == TRP3_RegisterInfoTypes.ABOUT then
		data = TRP3_RegisterAboutGetExchangeData();
	elseif informationType == TRP3_RegisterInfoTypes.STYLE then
		data = TRP3_RegisterRPStyleGetExchangeData();
	elseif informationType == TRP3_RegisterInfoTypes.MISC then
		data = TRP3_RegisterMiscGetExchangeData();
	end
	TRP3_SendObject(INFO_TYPE_SEND_PREFIX, {informationType, data}, sender, INFO_TYPE_SEND_PRIORITY);
end

local function incomingInformationTypeSent(structure, sender)
	local informationType = structure[1];
	local data = structure[2];
	
	if not CURRENT_QUERY_EXCHANGES[sender] or not CURRENT_QUERY_EXCHANGES[sender][informationType] then
		return; -- We didn't ask for theses information ...
	end
	
	log(("Received %s's %s info !"):format(sender, informationType));
	local decodedData = data;
	if type(data) == "string" then
		decodedData = TRP3_DecompressCodedStructure(decodedData);
	end
	TRP3_RegisterSetInforType(sender, informationType, decodedData);
	TRP3_ShouldRefreshTooltip(sender);
	
	CURRENT_QUERY_EXCHANGES[sender][informationType] = nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TRIGGERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Send vernum request to the player if this is a known TRP player
-- The main rule is : we send a vernum query only to known characters
-- Note: we can't send query to a player from another realm.
local function onMouseOver(...)
	local unitName, unitRealm = UnitName("mouseover");

	if unitName -- unitName equals nil if no character under the mouse (possible if the event trigger is delayed)
		and unitRealm == nil -- Don't send query to players from other realm. You just can't.
		and UnitIsPlayer("mouseover") -- Don't query NPC
		and unitName ~= TRP3_PLAYER -- Don't query yourself
		and unitName ~= UNKNOWNOBJECT -- Name could equals UNKNOWNOBJECT if the player is not "loaded" (far away, disconnected ...)
		and UnitFactionGroup("mouseover") == UnitFactionGroup("player") -- Don't query other faction !
		and CheckInteractDistance("mouseover", 4) -- Should be at range, this is kind of optimization
		and not TRP3_IsPlayerIgnored(unitName)
		and TRP3_IsUnitKnown(unitName) -- Only query known characters
		and (not LAST_QUERY[unitName] or time() - LAST_QUERY[unitName] > COOLDOWN_DURATION) -- Optimization (cooldown from last query)
	then
		LAST_QUERY[unitName] = time();
		queryVernum(unitName);
		queryMarySueProtocol(unitName);
	end
end

--- Send vernum request to the player if this is a known TRP player
-- The main rule is : we send a vernum query only to unknown characters
-- Note: we can't send query to a player from another realm.
local function onTargetChanged(...)
	local unitName, unitRealm = UnitName("target");
	if unitName -- unitName equals nil if no character under the mouse (possible if the event trigger is delayed)
		and unitRealm == nil -- Don't send query to players from other realm. You just can't.
		and UnitIsPlayer("target") -- Don't query NPC
		and unitName ~= TRP3_PLAYER -- Don't query yourself
		and unitName ~= UNKNOWNOBJECT -- Name could equals UNKNOWNOBJECT if the player is not "loaded" (far away, disconnected ...)
		and UnitFactionGroup("target") == UnitFactionGroup("player") -- Don't query other faction !
		and not TRP3_IsPlayerIgnored(unitName)
		and not TRP3_IsUnitKnown(unitName)
		and (not LAST_QUERY[unitName] or time() - LAST_QUERY[unitName] > COOLDOWN_DURATION) -- Optimization (cooldown from last query)
	then
		LAST_QUERY[unitName] = time();
		queryVernum(unitName);
		queryMarySueProtocol(unitName);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_DataExchangeInit()

	if not TRP3_Register then
		TRP3_Register = {};
	end

	-- Listen to the mouse over event
	TRP3_RegisterToEvent("UPDATE_MOUSEOVER_UNIT", onMouseOver);
	TRP3_RegisterToEvent("PLAYER_TARGET_CHANGED", onTargetChanged);

	-- Register prefix for data exchange
	TRP3_RegisterProtocolPrefix(VERNUM_QUERY_PREFIX, incomingVernumQuery);
	TRP3_RegisterProtocolPrefix(VERNUM_R_QUERY_PREFIX, incomingVernumResponseQuery);
	TRP3_RegisterProtocolPrefix(INFO_TYPE_QUERY_PREFIX, incomingInformationType);
	TRP3_RegisterProtocolPrefix(INFO_TYPE_SEND_PREFIX, incomingInformationTypeSent);
end
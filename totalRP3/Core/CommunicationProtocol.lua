-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- AddOn imports
local Chomp = AddOn_Chomp;

-- Total RP 3 imports
local Compression = AddOn_TotalRP3.Compression;

local PROTOCOL_PREFIX = "TRP3.3";
local PROTOCOL_SETTINGS = {
	permitUnlogged = true,
	permitLogged = true,
	permitBattleNet = true,
	fullMsgOnly = true,
	validTypes = {
		["string"] = true,
		["table"] = true,
	},
	broadcastPrefix = "TRP3.3"
}
local PRIORITIES = {
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
}

local VALID_CHANNELS = {"PARTY", "RAID", "GUILD", "BATTLEGROUND", "WHISPER", "CHANNEL"};
local VALID_PRIORITIES = {"HIGH", "MEDIUM", "LOW"};

local subSystemsDispatcher = Ellyb.EventsDispatcher();
local subSystemsOnProgressDispatcher = Ellyb.EventsDispatcher();
local internalMessageIDToChompSessionIDMatching = {};

--[[ Deprecated ]] local function CTLToChompPriority(priority)
	if priority == "BULK" then
		priority = PRIORITIES.LOW
	end
	if priority == "NORMAL" then
		priority = PRIORITIES.MEDIUM
	end
	if priority == "ALERT" then
		priority = PRIORITIES.HIGH
	end
	return priority
end

-- Message IDs are 74 base number encoded on 2 chars (74*74 = 5476 available Message IDs)
local MESSAGE_ID = 1;
local ID_MOD = 74;
local ID_MOD_START = 48;
local ID_MAX_VALUE = ID_MOD*ID_MOD;
local function getNewMessageToken()
	local div = math.floor(MESSAGE_ID / ID_MOD);
	local remainder = math.fmod (MESSAGE_ID, ID_MOD);
	local toReturn = string.char(ID_MOD_START + div) .. string.char(ID_MOD_START + remainder);
	MESSAGE_ID = MESSAGE_ID + 1;
	if MESSAGE_ID >= ID_MAX_VALUE then
		MESSAGE_ID = 1;
	end
	return toReturn;
end

local function extractMessageTokenFromData(data)
	return data:sub(1, 2), data:sub(3, -1);
end

local function registerSubSystemPrefix(prefix, callback)
	local handlerID;

	Ellyb.Assertions.isType(callback, "function", "callback");
	handlerID = subSystemsDispatcher:RegisterCallback(prefix, callback);

	return handlerID;
end

local function registerMessageTokenProgressHandler(messageToken, sender, onProgressCallback)
	Ellyb.Assertions.isType(onProgressCallback, "function", "onProgressCallback");
	Ellyb.Assertions.isType(sender, "string", "sender");

	return subSystemsOnProgressDispatcher:RegisterCallback(tostring(messageToken), function(receivedSender, ...)
		if receivedSender == sender then
			onProgressCallback(receivedSender, ...)
		end
	end);
end

local function unregisterMessageTokenProgressHandler(handlerID)
	Ellyb.Assertions.isType(handlerID, "string", "handlerID");
	subSystemsOnProgressDispatcher:UnregisterCallback(handlerID)
end

local function sendObject(prefix, object, channel, target, priority, messageToken, useLoggedMessages, queue)
	if not tContains(VALID_CHANNELS, channel) then
		--if channel is ignored, default channel and bump everything along by one
		channel, target, priority, messageToken, useLoggedMessages, queue = "WHISPER", channel, target, priority, messageToken, useLoggedMessages
	end
	if tContains(VALID_PRIORITIES, target) then
		-- if target has values expected for priority, bump everything back by one
		target, priority, messageToken, useLoggedMessages, queue = nil, target, priority, messageToken, useLoggedMessages
	end

	Ellyb.Assertions.isType(prefix, "string", "prefix");
	assert(subSystemsDispatcher:HasCallbacksForEvent(prefix), "Unregistered prefix: "..prefix);
	Ellyb.Assertions.isOneOf(channel, VALID_CHANNELS, "channel");

	if not TRP3_API.register.isIDIgnored(target) then

		if priority == nil then
			priority = "LOW";
		end
		priority = CTLToChompPriority(priority);

		Ellyb.Assertions.isOneOf(priority, VALID_PRIORITIES, "priority");

		messageToken = messageToken or getNewMessageToken();

		local serializedData = Chomp.Serialize({
			modulePrefix = prefix,
			data = object,
		});

		if not useLoggedMessages then
			serializedData = Compression.compress(serializedData, true);
		end

		Chomp.SmartAddonMessage(
			PROTOCOL_PREFIX,
			messageToken .. serializedData,
			channel,
			target,
			{
				priority = priority,
				binaryBlob = not useLoggedMessages,
				allowBroadcast = true,
				queue = queue,
			}
		);
	else
		TRP3_API.Logf("[sendObject] target '%s' is ignored", target);
		return false;
	end
end

local function isLoggedChannel(channel)
	return channel:find("LOGGED");
end

local function onIncrementalMessageReceived(_, data, _, sender, _, _, _, _, _, _, _, _, sessionID, msgID, msgTotal)
	if msgID == 1 then
		local messageToken = extractMessageTokenFromData(data);
		internalMessageIDToChompSessionIDMatching[sessionID] = messageToken;
	end

	local event = internalMessageIDToChompSessionIDMatching[sessionID];
	if not event then
		-- This can be the case if a message is received out-of-order (unlikely!) or
		-- if the first part of a multipart message we receive is after the first part,
		-- for example due to us logging in or changing zones or whatever.
		return;
	end

	subSystemsOnProgressDispatcher:TriggerEvent(event, sender, msgTotal, msgID);
end
PROTOCOL_SETTINGS.rawCallback = onIncrementalMessageReceived;

local function onChatMessageReceived(_, data, channel, sender)
	_, data = extractMessageTokenFromData(data);
	if not isLoggedChannel(channel) then
		data = Compression.decompress(data, true);
	end
	data = Chomp.Deserialize(data);
	subSystemsDispatcher:TriggerEvent(data.modulePrefix, data.data, sender, channel);
end

Chomp.RegisterAddonPrefix(PROTOCOL_PREFIX, onChatMessageReceived, PROTOCOL_SETTINGS)


local function estimateStructureSize(object, shouldBeCompressed)
	Ellyb.Assertions.isNotNil(object, "object");
	local serializedObject = Chomp.Serialize(object);
	if shouldBeCompressed then
		serializedObject = Compression.compress(serializedObject);
	end
	return #serializedObject;
end

-- Estimate the number of packet needed to send a object.
local function estimateStructureLoad(object, shouldBeCompressed)
	return math.ceil(estimateStructureSize(object, shouldBeCompressed) / Chomp.GetBPS());
end

AddOn_TotalRP3.Communications = {
	getNewMessageToken = getNewMessageToken,
	registerSubSystemPrefix = registerSubSystemPrefix,
	registerMessageTokenProgressHandler = registerMessageTokenProgressHandler,
	unregisterMessageTokenProgressHandler = unregisterMessageTokenProgressHandler,
	estimateStructureLoad = estimateStructureLoad,
	estimateStructureSize = estimateStructureSize,
	sendObject = sendObject,
	extractMessageTokenFromData = extractMessageTokenFromData,
	PRIORITIES = PRIORITIES,
}

----------------------------------------------------------------------------------
--- Total RP 3
--- Communication protocol and API
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(_);
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- AddOn imports
local Chomp = AddOn_Chomp;
local logger = Ellyb.Logger("TotalRP3_Communication");

-- Total RP 3 imports
local Compression = AddOn_TotalRP3.Compression;

local PROTOCOL_PREFIX = "TRP3.2";
local PROTOCOL_SETTINGS = {
	permitUnlogged = true,
	permitLogged = true,
	permitBattleNet = true,
	fullMsgOnly = true,
	validTypes = {
		["string"] = true,
		["table"] = true,
	},
	broadcastPrefix = "TRP3"
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

-- Deprecated TODO Remove
local messageIDDispatcher = Ellyb.EventsDispatcher();

local DEPRECATED_MESSAGE_PRIORITY = [[Deprecated usage of message priority "%s". Use "%s" instead.]];
--[[ Deprecated ]] local function CTLToChompPriority(priority)
	if priority == "BULK" then
		Ellyb.DeprecationWarnings.warn(DEPRECATED_MESSAGE_PRIORITY:format("BULK", PRIORITIES.LOW));
		priority = PRIORITIES.LOW
	end
	if priority == "NORMAL" then
		Ellyb.DeprecationWarnings.warn(DEPRECATED_MESSAGE_PRIORITY:format("NORMAL", PRIORITIES.MEDIUM));
		priority = PRIORITIES.MEDIUM
	end
	if priority == "ALERT" then
		Ellyb.DeprecationWarnings.warn(DEPRECATED_MESSAGE_PRIORITY:format("ALERT", PRIORITIES.HIGH));
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

local function sendObject(prefix, object, channel, target, priority, messageToken, useLoggedMessages)
	if not tContains(VALID_CHANNELS, channel) then
		--if channel is ignored, default channel and bump everything along by one
		channel, target, priority, messageToken, useLoggedMessages = "WHISPER", channel, target, priority, messageToken
	end
	if tContains(VALID_PRIORITIES, target) then
		-- if target has values expected for priority, bump everything back by one
		target, priority, messageToken, useLoggedMessages = nil, target, priority, messageToken
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
			}
		);
	else
		logger:Warning("[sendObject]", "target is ignored", target);
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
	return estimateStructureSize(object, shouldBeCompressed) / Chomp.GetBPS();
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

Ellyb.Documentation:AddDocumentationTable("TotalRP3_Communication", {
	Name = "TotalRP3.Communications",
	Type = "System",
	Namespace = "AddOn_TotalRP3.Communications",

	Functions = {
		{
			Name = "getNewMessageToken",
			Type = "Function",
			Documentation = { "Generate a new message token to use to identify something sent in multiple messages." },

			Returns =
			{
				{ Name = "messageToken", Type = "number", Nilable = false, Documentation = { "The message token can then be passed to sendObject to be used explicitly" }  },
			},
		},
		{
			Name = "registerSubSystemPrefix",
			Type = "Function",
			Documentation = { "Register a new communication prefix to identify a sub-system." },

			Arguments = {
				{ Name = "prefix", Type = "string", Nilable = false, Documentation = { "A unique prefix for this sub-system, used to differentiate between all sub-systems using communications. An error will be thrown if the prefix has already been registered before." } },
				{ Name = "callback", Type = "function", Nilable = false, Documentation = { "This callback will be called when we receive data that uses this prefix." } },
			},
		},
		{
			Name = "registerMessageTokenProgressHandler",
			Type = "Function",
			Documentation = { "Register a new callback for a specific message token to be called when we receive new data for this message token." },

			Arguments = {
				{ Name = "messageToken", Type = "string", Nilable = false, Documentation = { "A valid message token generated using getNewMessageToken()." } },
				{ Name = "sender", Type = "string", Nilable = false, Documentation = { "The unit name for the sender of the messages that we will be receiving on the message token; It is used to filter out other sender and only listen to messages coming from the expected sender." } },
				{ Name = "onProgressCallback", Type = "function", Nilable = false, Documentation = { "This callback will be called when we receive new data for the specified message token with \"sender, amountOfMessagesIncoming, amountOfMessagesReceived\" as arguments.." } },
			},

			Returns =
			{
				{ Name = "handlerID", Type = "string", Nilable = false, Documentation = { "An identifier for the callback registered, to be used later for unregisterMessageTokenProgressHandler()." }  },
			},
		},
		{
			Name = "unregisterMessageTokenProgressHandler",
			Type = "Function",
			Documentation = { "Unregister an existing callback for a specified message token. It is best practice to unregister callbacks once we don't need them anymore." },

			Arguments = {
				{ Name = "handlerID", Type = "string", Nilable = false, Documentation = { "The identifier for the callback we want to unregister, as received when registering the callback." } },
			},
		},
		{
			Name = "estimateStructureLoad",
			Type = "Function",
			Documentation = { "Estimate the number of messages that will be required to send the given structure." },

			Arguments = {
				{ Name = "object", Type = "table", Nilable = false, Documentation = { "The structure that would be sent." } },
				{ Name = "shouldBeCompressed", Type = "boolean", Nilable = true, Documentation = { "Indicates if the structure should be compressed to reduce its size before sending." } },
			},

			Returns =
			{
				{ Name = "approximateAmountOfMessages", Type = "number", Nilable = false, Documentation = { "The approximate amount of messages need to send the structure." }  },
			},
		},
		{
			Name = "extractMessageTokenFromData",
			Type = "Function",
			Documentation = { "Extract the message token from data received from Chomp, to get proper deserializable data and the message token separately." },

			Arguments = {
				{ Name = "data", Type = "string", Nilable = false, Documentation = { "A string of data received from Chomp." } },
			},

			Returns =
			{
				{ Name = "messageToken", Type = "string", Nilable = false, Documentation = { "The internal message token used by Total RP 3 to keep track of a single structure being sent over several messages." }  },
				{ Name = "data", Type = "string", Nilable = false, Documentation = { "The actual raw data that was sent by Total RP 3. Can be deserialize using Chomp's Deserialize function. MUST be decompress using TRP3's Compression module if the message came from non-logged channels." }  },
			},
		},
	},
	Tables =
	{
		{
			Name = "AddOn_TotalRP3.Communications.PRIORITIES",
			Type = "Structure",
			Fields =
			{
				{ Name = "LOW ", Type = "string", Nilable = false},
				{ Name = "MEDIUM ", Type = "string", Nilable = false},
				{ Name = "HIGH ", Type = "string", Nilable = false},
			},
		},
	},
})

-- DEPRECATED
-- Backward compatibility layer
TRP3_API.communication = {};
TRP3_API.communication.getMessageIDAndIncrement = Ellyb.DeprecationWarnings.wrapFunction(getNewMessageToken, "TRP3_API.communication.getMessageIDAndIncrement", "AddOn_TotalRP3.Communications.getNewMessageToken");
TRP3_API.communication.registerProtocolPrefix = Ellyb.DeprecationWarnings.wrapFunction(registerSubSystemPrefix, "TRP3_API.communication.registerProtocolPrefix", "AddOn_TotalRP3.Communications.registerSubSystemPrefix");

TRP3_API.communication.addMessageIDHandler = function(sender, reservedMessageID, callback)
	Ellyb.DeprecationWarnings.warn([[Deprecated usage of TRP3_API.communication.addMessageIDHandler(sender, reservedMessageID, callback). You should now provide an onProgression callback when using AddOn_TotalRP3.registerSubSystemPrefix(prefix, callback, onProgressCallback) for the sub-system. This callback will be called with the message ID in the parameters.]]);
	messageIDDispatcher:RegisterCallback(reservedMessageID, function(senderID, msgTotal, msgID)
		if senderID == sender then
			callback(senderID, msgTotal, msgID);
		end
	end);
end

Ellyb.DeprecationWarnings.wrapAPI(AddOn_TotalRP3.Communications, "TRP3_API.communication", "AddOn_TotalRP3.Communications", TRP3_API.communication);



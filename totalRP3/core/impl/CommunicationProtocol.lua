----------------------------------------------------------------------------------
--- Total RP 3
---
--- Communication protocol and API
--- ---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

-- Lua imports
local assert = assert;
local string = string;
local math = math;

-- AddOn imports
local Chomp = AddOn_Chomp;
local logger = Ellyb.Logger("TotalRP3_Communication");
local isType = Ellyb.Assertions.isType;
local isOneOf = Ellyb.Assertions.isOneOf;
local isNotNil = Ellyb.Assertions.isNotNil;

-- Total RP 3 imports
local Compression = AddOn_TotalRP3.Compression;

local Communication = {};

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
}
Communication.PRIORITIES = {
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
}

local subSystemsDispatcher = Ellyb.EventsDispatcher();
local subSystemsOnProgressDispatcher = Ellyb.EventsDispatcher();
local internalMessageIDToChompSessionIDMatching = {};

-- Deprecated TODO Remove
local messageIDDispatcher = Ellyb.EventsDispatcher();

local DEPRECATED_MESSAGE_PRIORITY = [[Deprecated usage of message priority "%s". Use "%s" instead.]];
--[[ Deprecated ]] local function CTLToChompPriority(priority)
	if priority == "BULK" then
		Ellyb.DeprecationWarnings.warn(DEPRECATED_MESSAGE_PRIORITY:format("BULK", Communication.PRIORITIES.LOW));
		priority = Communication.PRIORITIES.LOW
	end
	if priority == "NORMAL" then
		Ellyb.DeprecationWarnings.warn(DEPRECATED_MESSAGE_PRIORITY:format("NORMAL", Communication.PRIORITIES.MEDIUM));
		priority = Communication.PRIORITIES.MEDIUM
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

local function registerSubSystemPrefix(prefix, callback, onProgressCallback)
	local handlerID, onProgressHandlerID;

	assert(isType(callback, "function", "callback"));
	handlerID = subSystemsDispatcher:RegisterCallback(prefix, callback);

	if onProgressCallback then
		assert(isType(onProgressCallback, "function", "onProgressCallback"));
		onProgressHandlerID = subSystemsOnProgressDispatcher:RegisterCallback(prefix, onProgressCallback);
	end

	return handlerID, onProgressHandlerID;
end

local function sendObject(prefix, object, target, priority, messageToken, useLoggedMessages)
	assert(isType(prefix, "string", "prefix"));
	assert(subSystemsDispatcher:HasCallbacksForEvent(prefix), "Unregistered prefix: "..prefix);

	if not TRP3_API.register.isIDIgnored(target) then

		if priority == nil then
			priority = "LOW";
		end
		priority = CTLToChompPriority(priority);

		assert(isOneOf(priority, {"HIGH", "MEDIUM", "LOW"}, "priority"));

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
			"WHISPER",
			target,
			{
				priority = priority,
				binaryBlob = not useLoggedMessages,
			});
	else
		logger:Warning("[sendObject]", "target is ignored", target);
		return false;
	end
end

local function isLoggedChannel(channel)
	return channel:find("LOGGED");
end

local function onIncrementalMessageReceived(prefix, data, channel, sender, _, _, _, _, _, _, _, _, sessionID, msgID, msgTotal)
	if msgID == 1 then
		local messageToken = extractMessageTokenFromData(data);
		internalMessageIDToChompSessionIDMatching[sessionID] = messageToken;
	end
	subSystemsOnProgressDispatcher:TriggerEvent(prefix, internalMessageIDToChompSessionIDMatching[sessionID], sender, msgTotal, msgID);
	messageIDDispatcher:TriggerEvent(internalMessageIDToChompSessionIDMatching[sessionID], sender, msgTotal, msgID)
end
PROTOCOL_SETTINGS.rawCallback = onIncrementalMessageReceived;

function Communication.addMessageIDHandler(sender, reservedMessageID, callback)
	subSystemsOnProgressDispatcher:RegisterCallback(reservedMessageID, callback)
end

local function onChatMessageReceived(prefix, data, channel, sender, _, _, _, _, _, _, _, _, sessionID, msgID, msgTotal)
	_, data = extractMessageTokenFromData(data);
	if not isLoggedChannel(channel) then
		data = Compression.decompress(data, true);
	end
	data = Chomp.Deserialize(data);
	subSystemsDispatcher:TriggerEvent(data.modulePrefix, data.data, sender, channel);
end

Chomp.RegisterAddonPrefix(PROTOCOL_PREFIX, onChatMessageReceived, PROTOCOL_SETTINGS)

-- Estimate the number of packet needed to send a object.
local function estimateStructureLoad(object, shouldBeCompressed)

	assert(isNotNil(object, "object"));
	local serializedObject = Chomp.Serialize(object);
	if shouldBeCompressed then
		serializedObject = Compression.compress(serializedObject);
	end
	return #serializedObject / Chomp.GetBPS();
end

AddOn_TotalRP3.Communications = {
	getNewMessageToken = getNewMessageToken,
	registerSubSystemPrefix = registerSubSystemPrefix,
	estimateStructureLoad = estimateStructureLoad,
	sendObject = sendObject,
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
				{ Name = "onProgressCallback", Type = "function", Nilable = true, Documentation = { "This callback will be called as the transfers are progressing, with the message token associated to the transfer and the transfer progression." } },
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
TRP3_API.communication.getMessageIDAndIncrement = Ellyb.DeprecationWarnings.wrapFunction(getNewMessageToken, "TRP3_API.communication.getMessageIDAndIncrement", "AddOn_TotalRP3.Communication.getNewMessageToken");
TRP3_API.communication.registerProtocolPrefix = Ellyb.DeprecationWarnings.wrapFunction(registerSubSystemPrefix, "TRP3_API.communication.registerProtocolPrefix", "AddOn_TotalRP3.Communication.registerSubSystemPrefix");

TRP3_API.communication.addMessageIDHandler = function(sender, reservedMessageID, callback)
	Ellyb.DeprecationWarnings.warn([[Deprecated usage of TRP3_API.communication.addMessageIDHandler(sender, reservedMessageID, callback). You should now provide an onProgression callback when using AddOn_TotalRP3.registerSubSystemPrefix(prefix, callback, onProgressCallback) for the sub-system. This callback will be called with the message ID in the parameters.]]);
	messageIDDispatcher:RegisterCallback(reservedMessageID, function(senderID, msgTotal, msgID)
		if senderID == sender then
			callback(senderID, msgTotal, msgID);
		end
	end);
end

Ellyb.DeprecationWarnings.wrapAPI(AddOn_TotalRP3.Communications, "TRP3_API.communication", "AddOn_TotalRP3.Communication", TRP3_API.communication);



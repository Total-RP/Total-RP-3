----------------------------------------------------------------------------------
--- Total RP 3
---
--- Communication protocol and API
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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
local AddOn_TotalRP3 = AddOn_TotalRP3;

-- Lua imports
local assert = assert;
local type = type;
local string = string;
local math = math;

-- AddOn imports
local Chomp = AddOn_Chomp;
local logger = Ellyb.Logger("TotalRP3_Communication");
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local isType = Ellyb.Assertions.isType;
local isOneOf = Ellyb.Assertions.isOneOf;
local numberIsBetween = Ellyb.Assertions.numberIsBetween;

local Communication = {};

local PROTOCOL_PREFIX = "TRP3.2";
local PROTOCOL_SETTINGS = {
	permitUnlogged = true,
	permitLogged = false,
	permitBattleNet = false,
	fullMsgOnly = true,
	validTypes = {
		["string"] = true,
		["table"] = true,
	},
}

local prefixesEventDispatch = Ellyb.EventsDispatcher();
local messageIDsEventDispatch = Ellyb.EventsDispatcher();
local internalMessageIDToChompSessionIDMatching = {};

local MESSAGE_ID = 1;
local ID_MOD = 74;
local ID_MOD_START = 48;
local ID_MAX_VALUE = ID_MOD*ID_MOD;

--[[ Deprecated ]] local function CTLToChompPriority(priority)
	if priority == "BULK" then
		priority = "LOW"
	end
	if priority == "NORMAL" then
		priority = "MEDIUM"
	end
	return priority
end

local function code(code)
	assert(isType(code, "number", code));
	assert(numberIsBetween(code, 1, ID_MAX_VALUE), "code");

	local div = math.floor(code / ID_MOD);
	local remainder = math.fmod (code, ID_MOD);
	return string.char(ID_MOD_START + div) .. string.char(ID_MOD_START + remainder);
end

-- Message IDs are 74 base number encoded on 2 chars (74*74 = 5476 available Message IDs)
local function getMessageIDAndIncrement()
	local toReturn = code(MESSAGE_ID);
	MESSAGE_ID = MESSAGE_ID + 1;
	if MESSAGE_ID >= ID_MAX_VALUE then
		MESSAGE_ID = 1;
	end
	return toReturn;
end
Communication.getMessageIDAndIncrement = getMessageIDAndIncrement;

local function compress(data)
	return LibDeflate:EncodeForWoWAddonChannel(LibDeflate:CompressDeflate(data));
end

local function decompress(data)
	return LibDeflate:DecompressDeflate(LibDeflate:DecodeForWoWAddonChannel(data));
end

function Communication.registerProtocolPrefix(prefix, callback)
	return prefixesEventDispatch:RegisterCallback(prefix, callback);
end

function Communication.sendObject(prefix, object, target, priority, messageID)
	assert(isType(prefix, "string", "prefix"));
	assert(prefixesEventDispatch:HasCallbacksForEvent(prefix), "Unregistered prefix: "..prefix);

	if priority == nil then
		priority = "LOW";
	end
	priority = CTLToChompPriority(priority);

	assert(isOneOf(priority, {"HIGH", "MEDIUM", "LOW"}, "priority"));

	if not TRP3_API.register.isIDIgnored(target) then
		print("Passed message ID", messageID)
		messageID = messageID or getMessageIDAndIncrement();

		local compressedData = compress(Chomp.Serialize({
			modulePrefix = prefix,
			data = object,
		}));
		Chomp.SmartAddonMessage(
			PROTOCOL_PREFIX,
			messageID .. compressedData,
			"WHISPER",
			target,
			{
				priority = priority,
			});
	else
		logger:Warning("[sendObject]", "target is ignored", target);
		return false;
	end
end

local function onIncrementalMessageReceived(prefix, data, channel, sender, _, _, _, _, _, _, _, _, sessionID, msgID, msgTotal)
	if msgID == 1 then
		local messageID = data:sub(1, 2);
		internalMessageIDToChompSessionIDMatching[sessionID] = messageID;
	end
	print("[OnProgress] messageID:", internalMessageIDToChompSessionIDMatching[sessionID], msgID, "/", msgTotal)
	messageIDsEventDispatch:TriggerEvent(internalMessageIDToChompSessionIDMatching[sessionID], sender, msgTotal, msgID);
end
PROTOCOL_SETTINGS.rawCallback = onIncrementalMessageReceived;

function Communication.addMessageIDHandler(sender, reservedMessageID, callback)
	messageIDsEventDispatch:RegisterCallback(reservedMessageID, callback)
end

local function onChatMessageReceived(prefix, data, channel, sender, _, _, _, _, _, _, _, _, sessionID, msgID, msgTotal)
	logger:Info("[onChatMessageReceived]", prefix, data, channel, sender, sessionID, msgID, msgTotal)
	data = data:sub(3, -1);
	data = Chomp.Deserialize(decompress(data));
	prefixesEventDispatch:TriggerEvent(data.modulePrefix, data.data, sender);
end

Chomp.RegisterAddonPrefix(PROTOCOL_PREFIX, onChatMessageReceived, PROTOCOL_SETTINGS)

-- Estimate the number of packet needed to send a object.
function Communication.estimateStructureLoad(object)
	assert(object, "Object nil");
	return #Chomp.Serialize(object) / Chomp.GetBPS();
end

TRP3_API.Communication = Communication;

TRP3_API.communication = Ellyb.DeprecationWarnings.wrapAPI(Communication, "TRP3_API.communication", "TRP3_API.Communication");

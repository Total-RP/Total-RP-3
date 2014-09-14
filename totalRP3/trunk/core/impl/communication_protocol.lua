----------------------------------------------------------------------------------
-- Total RP 3
-- Communication protocol and API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- Public accessor
TRP3_API.communication = {};

-- imports
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix;
local tostring, pairs, assert, string, wipe, tinsert, type, math = tostring, pairs, assert, string, wipe, tinsert, type, math;
local tconcat = table.concat;
local ChatThrottleLib = ChatThrottleLib;
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local Log = Utils.log;
local Comm, isIDIgnored = TRP3_API.communication;
local libSerializer = LibStub:GetLibrary("AceSerializer-3.0");

-- function definition
local handlePacketsIn;
local handleStructureIn;
local receiveObject;
local onAddonMessageReceived;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 0 : CONNECTION LAYER
-- Makes connection with Wow communication functions, or debug functions
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local wowCom_prefix = "TRP3";
local interface_id = {
	WOW = 1,
	DIRECT_RELAY = 2,
	DIRECT_PRINT = 3
};
Comm.interface_id = interface_id;
local selected_interface_id = interface_id.WOW;

function Comm.init()
	isIDIgnored = TRP3_API.register.isIDIgnored;
	Utils.event.registerHandler("CHAT_MSG_ADDON", onAddonMessageReceived);
	Utils.event.registerHandler("PLAYER_ENTERING_WORLD", function() 
		RegisterAddonMessagePrefix(wowCom_prefix);
	end);
end

-- This is the main communication interface, using ChatThrottleLib to
-- avoid being kicked by the server when sending a lot of data.
local function wowCommunicationInterface(packet, target, priority)
	ChatThrottleLib:SendAddonMessage(priority or "BULK", wowCom_prefix, packet, "WHISPER", target);
end

function onAddonMessageReceived(...)
	local prefix, packet , distributionType, sender = ...;
	if prefix == wowCom_prefix then
		-- TODO: check here ignore
		handlePacketsIn(packet, sender);
	end
end

-- This communication interface print all sent message to the chat frame.
-- Note that the messages are not really sent.
local function directPrint(packet, target, priority)
	Log.log("Message to: "..tostring(target).." - Priority: "..tostring(priority)..(" - Message(%s):"):format(packet:len()));
	Log.log(packet:sub(4));
end

-- A "direct relay" (like localhost) communication interface, used for development purpose.
-- Any message sent to this communication interface is directly rerouted to the user itself.
-- Note that the messages are not really sent.
local function directRelayInterface(packet, target, priority)
	directPrint(packet, target, priority)
	handlePacketsIn(packet, target);
end

-- Returns the function reference to be used as communication interface.
local function getCommunicationInterface()
	if selected_interface_id == interface_id.WOW then return wowCommunicationInterface end
	if selected_interface_id == interface_id.DIRECT_RELAY then return directRelayInterface end
	if selected_interface_id == interface_id.DIRECT_PRINT then return directPrint end
end

-- Changes the communication interface to use
function Comm.setInterfaceID(id)
	selected_interface_id = id;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 1 : PACKET LAYER
-- Packet sending and receiving
-- Handles packet sequences
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- 254 - TRP3(4) - MESSAGE_ID(2) - control character(1)
local AVAILABLE_CHARACTERS = 246;
local NEXT_PACKET_PREFIX = "\001";
local LAST_PACKET_PREFIX = "\002";
local PACKETS_RECEPTOR = {};

-- Send each packet to the current communication interface.
local function handlePacketsOut(messageID, packets, target, priority)
	if #packets ~= 0 then
		for index, packet in pairs(packets) do
			assert(packet:len() <= AVAILABLE_CHARACTERS, "Too long packet: " .. packet:len());
			local control = NEXT_PACKET_PREFIX;
			if index == #packets then
				control = LAST_PACKET_PREFIX;
			end
			getCommunicationInterface()(messageID..control..packet, target, priority);
		end
	end
end

local function savePacket(sender, messageID, packet)
	if not PACKETS_RECEPTOR[sender] then
		PACKETS_RECEPTOR[sender] = {};
	end
	if not PACKETS_RECEPTOR[sender][messageID] then
		PACKETS_RECEPTOR[sender][messageID] = {};
	end
	tinsert(PACKETS_RECEPTOR[sender][messageID], packet);
end

local function getPackets(sender, messageID)
	assert(PACKETS_RECEPTOR[sender] and PACKETS_RECEPTOR[sender][messageID], "No stored packets from "..sender.." for structure "..messageID);
	return PACKETS_RECEPTOR[sender][messageID];
end

local function endPacket(sender, messageID)
	assert(PACKETS_RECEPTOR[sender] and PACKETS_RECEPTOR[sender][messageID], "No stored packets from "..sender.." for structure "..messageID);
	wipe(PACKETS_RECEPTOR[sender][messageID]);
	PACKETS_RECEPTOR[sender][messageID] = nil;
end

function handlePacketsIn(packet, sender)
	if not isIDIgnored(sender) then
		local messageID = packet:sub(1, 2);
		local control = packet:sub(3, 3);
		savePacket(sender, messageID, packet:sub(4));
		if control == LAST_PACKET_PREFIX then
			handleStructureIn(getPackets(sender, messageID), sender);
			endPacket(sender, messageID);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 2 : MESSAGE LAYER
-- Structure-to-Message serialization / deserialization
-- Message cutting in packets / Message reconstitution
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MESSAGE_ID_1 = 1;
local MESSAGE_ID_2 = 1;
local MESSAGE_ID = string.char(MESSAGE_ID_1, MESSAGE_ID_2);
local COMPRESS_MESSAGE = true;

-- Message IDs are 256 base number encoded on 2 chars (256*256 = 65536 available Message IDs)
local function getMessageIDAndIncrement()
	local toReturn = MESSAGE_ID;
	MESSAGE_ID_2 = MESSAGE_ID_2 + 1;
	if MESSAGE_ID_2 > 255 then
		MESSAGE_ID_2 = 1;
		MESSAGE_ID_1 = MESSAGE_ID_1 + 1;
		if MESSAGE_ID_1 > 255 then
			MESSAGE_ID_1 = 1;
		end
	end
	MESSAGE_ID = string.char(MESSAGE_ID_1, MESSAGE_ID_2);
	return toReturn;
end

-- Convert structure to message, cut message in packets.
local function handleStructureOut(structure, target, priority)
	local message = libSerializer:Serialize(structure);
	local messageID = getMessageIDAndIncrement();
	local messageSize = message:len();
	local packetTab = {};
	local index = 1;
	while index <= messageSize do
		tinsert(packetTab, message:sub(index, index + (AVAILABLE_CHARACTERS - 1)));
		index = index + AVAILABLE_CHARACTERS;
	end
	handlePacketsOut(messageID, packetTab, target, priority);
end

-- Reassemble the message based on the packets, and deserialize it.
function handleStructureIn(packets, sender)
	local message = tconcat(packets);
	local status, structure = libSerializer:Deserialize(message);
	if status then
		receiveObject(structure, sender);
	else
		Log.log(("Deserialization error. Message:\n%s"):format(message), Log.level.SEVERE);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 3 : STRUCTURE LAYER
-- "What to do with the structure received / to send ?"
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local PREFIX_REGISTRATION = {};

-- Register a function to callback when receiving a object attached to the given prefix
 function Comm.registerProtocolPrefix(prefix, callback)
	assert(prefix and callback and type(callback) == "function", "Usage: prefix, callback");
	if PREFIX_REGISTRATION[prefix] == nil then
		PREFIX_REGISTRATION[prefix] = {};
	end
	tinsert(PREFIX_REGISTRATION[prefix], callback);
end

-- Send a object to a player
-- Prefix must have been registered before use this function
-- The object can be any lua type (numbers, strings, tables, but NOT functions or userdatas)
-- Priority is optional ("Bulk" by default)
function Comm.sendObject(prefix, object, target, priority)
	assert(PREFIX_REGISTRATION[prefix] ~= nil, "Unregistered prefix: "..prefix);
	if not isIDIgnored(target) then
		local structure = {prefix, object};
		handleStructureOut(structure, target, priority);
	end
end

-- Receive a structure from a player (sender)
-- Call any callback registered for this prefix.
-- Structure[1] contains the prefix, structure[2] contains the object
function receiveObject(structure, sender)
	if type(structure) == "table" and #structure == 2 then
		local prefix = structure[1];
		if PREFIX_REGISTRATION[prefix] then
			for _, callback in pairs(PREFIX_REGISTRATION[prefix]) do
				callback(structure[2], sender);
			end
		else
			Log.log("No registration for prefix: " .. prefix, Log.level.INFO);
		end
	else
		Log.log("Bad structure composition.", Log.level.SEVERE);
	end
end

-- Estimate the number of packet needed to send a object.
function Comm.estimateStructureLoad(object)
	assert(object, "Object nil");
	return math.ceil((#(libSerializer:Serialize({"MOCK", object}))) / AVAILABLE_CHARACTERS);
end
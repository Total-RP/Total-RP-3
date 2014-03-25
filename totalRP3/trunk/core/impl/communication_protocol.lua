--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3 Addon Communication protocol
-- This is a regular protocol based on layers 1 & 3 & 4 & 5 from the ISO-OSI model.
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_COMM = {
	
};

-- imports
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix;
local tostring = tostring;
local pairs = pairs;
local assert = assert;
local string = string;
local wipe = wipe;
local tinsert = tinsert;
local type = type;
local math = math;
local ChatThrottleLib = ChatThrottleLib;
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local Log = Utils.log;
local Comm = TRP3_COMM;

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

Comm.init = function()
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

onAddonMessageReceived = function(...)
	local prefix, packet , distributionType, sender = ...;
	if prefix == wowCom_prefix then
		-- TODO: check here ignore
		handlePacketsIn(packet, sender);
	end
end

-- This communication interface print all sent message to the chat frame.
-- Note that the messages are not really sent.
local function directPrint(packet, target, priority)
	Log.log("Message to: "..tostring(target).." - Priority: "..tostring(priority)..(" - Message(%s):"):format(packet:len()), Log.level.DEBUG);
	Log.log(packet:sub(4), Log.level.DEBUG);
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
Comm.setInterfaceID = function(id)
	selected_interface_id = id;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 1 : PACKET LAYER
-- Packet sending and receiving
-- Handles packet sequences
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- 254 - TRP3(4) - MESSAGE_ID(2) - control character(1)
local AVAILABLE_CHARACTERS = 246;
local NEXT_PACKET_PREFIX = 1;
local LAST_PACKET_PREFIX = 2;
local PACKETS_RECEPTOR = {};

-- Send each packet to the current communication interface.
local function handlePacketsOut(messageID, packets, target, priority)
	if #packets ~= 0 then
		for index, packet in pairs(packets) do
			assert(packet:len() <= AVAILABLE_CHARACTERS, "Too long packet: " .. packet:len());
			local control = string.char(NEXT_PACKET_PREFIX);
			if index == #packets then
				control = string.char(LAST_PACKET_PREFIX);
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

handlePacketsIn = function(packet, sender)
	local messageID = packet:sub(1, 2);
	local control = packet:sub(3, 3);
	savePacket(sender, messageID, packet:sub(4));
	if control:byte(1) == LAST_PACKET_PREFIX then
		handleStructureIn(getPackets(sender, messageID), sender);
		endPacket(sender, messageID);
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
	local message = Globals.addon:Serialize(structure);
	local messageID = getMessageIDAndIncrement();
	local messageSize = message:len();
	local packetTab = {};
	local index = 0;
	while index < messageSize do
		tinsert(packetTab, message:sub(index, index + (AVAILABLE_CHARACTERS - 1)));
		index = index + AVAILABLE_CHARACTERS;
	end
	handlePacketsOut(messageID, packetTab, target, priority);
end

-- Reassemble the message based on the packets, and deserialize it.
handleStructureIn = function(packets, sender)
	local message = "";
	for index, packet in pairs(packets) do
		message = message..packet;
	end
	local status, structure = Globals.addon:Deserialize(message);
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
Comm.registerProtocolPrefix = function(prefix, callback)
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
Comm.sendObject = function(prefix, object, target, priority)
	assert(PREFIX_REGISTRATION[prefix] ~= nil, "Unregistered prefix: "..prefix);
	local structure = {prefix, object};
	handleStructureOut(structure, target, priority);
end

-- Receive a structure from a player (sender)
-- Call any callback registered for this prefix.
-- Structure[1] contains the prefix, structure[2] contains the object
receiveObject = function(structure, sender)
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
Comm.estimateStructureLoad = function(object)
	assert(object, "Object nil");
	return math.ceil((#(Globals.addon:Serialize({"MOCK", object}))) / AVAILABLE_CHARACTERS);
end
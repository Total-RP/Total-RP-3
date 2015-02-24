----------------------------------------------------------------------------------
-- Total RP 3
-- Util API
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
TRP3_API.utils = {
	log = {},
	table = {},
	str = {},
	color = {},
	math = {},
	serial = {},
	event = {},
	music = {},
	texture = {},
	message = {},
	resources = {},
};
-- TRP3 imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local Log = Utils.log;
local loc = TRP3_API.locale.getText;

-- WOW imports
local pcall, tostring, pairs, type, print, string, date, math, strconcat, wipe, tonumber = pcall, tostring, pairs, type, print, string, date, math, strconcat, wipe, tonumber;
local tinsert, assert, _G, tremove, next = tinsert, assert, _G, tremove, next;
local PlayMusic, StopMusic = PlayMusic, StopMusic;
local UnitFullName = UnitFullName;
local UNKNOWNOBJECT = UNKNOWNOBJECT;
local SetPortraitToTexture = SetPortraitToTexture;
local getZoneText, getSubZoneText = GetZoneText, GetSubZoneText;

function Utils.pcall(func, ...)
	if func then
		return {pcall(func, ...)};
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Chat frame
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Utils.print = function(...)
	print(...);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGGING
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- The log level defines the prefix color and serves as filter
Log.level = {
	DEBUG = "-|cff00ffffDEBUG|r] ",
	INFO = "-|cff00ff00INFO|r] ",
	WARNING = "-|cffffaa00WARNING|r] ",
	SEVERE = "-|cffff0000SEVERE|r] "
}

-- Print a log message to the chatFrame.
local function log(message, level)
	if not level then level = Log.level.INFO; end
	if not Globals.DEBUG_MODE then
		return;
	end
	Utils.print( "[TRP3".. level ..tostring(message));
end
Log.log = log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Messaging
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MESSAGE_PREFIX = "[|cffffaa00TRP3|r] ";

local function getChatFrame()
	return DEFAULT_CHAT_FRAME;
end

-- CHAT_FRAME : ChatFrame (given by chatFrameIndex or default if nil)
-- ALERT_POPUP : TRP3 alert popup
-- RAID_ALERT : On screen alert (Raid notice frame)
Utils.message.type = {
	CHAT_FRAME = 1,
	ALERT_POPUP = 2,
	RAID_ALERT = 3
};
local messageTypes = Utils.message.type;

-- Display a simple message. Nil free.
Utils.message.displayMessage = function(message, messageType, noPrefix, chatFrameIndex)
	if not messageType or messageType == messageTypes.CHAT_FRAME then
		local chatFrame = _G["ChatFrame"..tostring(chatFrameIndex)] or getChatFrame();
		if noPrefix then
			chatFrame:AddMessage(tostring(message), 1, 1, 1);
		else
			chatFrame:AddMessage(MESSAGE_PREFIX..tostring(message), 1, 1, 1);
		end
	elseif messageType == messageTypes.ALERT_POPUP then
		TRP3_API.popup.showAlertPopup(tostring(message));
	elseif messageType == messageTypes.RAID_ALERT then
		RaidNotice_AddMessage(RaidWarningFrame, tostring(message), ChatTypeInfo["RAID_WARNING"]);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Table utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Print all table content (resursively)
-- Debug purpose
-- Better than /dump as it prints one message per line (avoid chat show limit)
local dumpColor1, dumpColor2, dumpColor3, dumpColor4 = "|cffffaa00", "|cff00ff00", "|cffffff00", "|cffff9900";
local function tableDump(table, level, withCount)
	local i = 0;
	local dumpIndent = "";

	for indent = 1, level, 1 do
		dumpIndent = dumpIndent .. "    ";
	end
	
	if type(table) == "table" then
		for key, value in pairs(table) do
			if type(value) == "table" then
				print(dumpIndent .. dumpColor2 .. key .. "|r=".. dumpColor3 .. "{");
				tableDump(value, level + 1);
				print(dumpIndent .. dumpColor3 .. "}");
			elseif type(value) == "function" then
				print(dumpIndent .. dumpColor2 .. key .. "|r=" .. dumpColor4 .. " <" .. type(value) ..">");
			else
				print(dumpIndent .. dumpColor2 .. key .. "|r=" .. dumpColor3 .. tostring(value) .. dumpColor4 .. " <" .. type(value) ..">");
			end
			i = i + 1;
		end
	end
	
	if withCount then
		print(dumpIndent .. dumpColor1 .. ("Level %s size: %s elements"):format(level, i));
	end
end

Utils.table.dump = function(table, withCount)
	print(dumpColor1 .. "Dump table ".. tostring(table));
	if table then
		tableDump(table, 1, withCount);
	end
end

-- Recursively copy all content from a table to another one.
-- Argument "destination" must be a non nil table reference.
local function tableCopy(destination, source)
	if destination == nil or source == nil then return end
	for k,v in pairs(source) do
		if(type(v)=="table") then
			destination[k] = {};
			tableCopy(destination[k], v);
		else
			destination[k] = v;
		end
	end
end
Utils.table.copy = tableCopy;

-- Return the table size.
-- Less effective than #table but works for hash table as well (#hashtable don't).
local function tableSize(table)
	local count = 0;
	for _,_ in pairs(table) do
		count = count + 1;
	end
	return count;
end
Utils.table.size = tableSize;

-- Remove an object from table
-- Return true if the object is found.
-- Object is search with == operator.
Utils.table.remove = function(table, object)
	for index, value in pairs(table) do
		if value == object then
			tremove(table, index);
			return true;
		end
	end
	return false;
end

function Utils.table.keys(table)
	local keys = {};
	for key, _ in pairs(table) do
		tinsert(keys, key);
	end
	return keys;
end

-- Create a weak tables pool.
local TABLE_POOL = setmetatable( {}, { __mode = "k" } );

-- Return an already created table, or a new one if the pool is empty
-- It ultra mega important to release the table once you finished using it !
function Utils.table.getTempTable()
	local t = next( TABLE_POOL );
	if t then
		TABLE_POOL[t] = nil;
		return wipe(t);
	end
	return {};
end

-- Release a temp table.
function Utils.table.releaseTempTable(table)
	TABLE_POOL[ table ] = true;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- String utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- A secure way to check if a String matches a pattern.
-- This is useful when using user-given pattern, as malformed pattern would produce lua error.
Utils.str.match = function(stringToCheck, pattern)
	local ok, result = pcall(string.find, string.lower(stringToCheck), string.lower(pattern));
	if not ok then
		return false; -- Syntax error.
	end
	-- string.find should return a number if the string matches the pattern
	return string.find(tostring(result), "%d");
end

--	Generate a pseudo-unique random ID.
--  If you encounter a collision, you really should playing lottery
--	ID's have a id_length characters length
local function generateID()
	local i;
	local ID = date("%m%d%H%M%S");
	for i=1, 5 do
		ID = ID..string.char(math.random(33,126));
	end
	return ID;
end
Utils.str.id = generateID;

-- Create a unit ID from a unit name and unit realm. If realm = nil then we use current realm.
-- This method ALWAYS return a nil free UnitName-RealmShortName string.
Utils.str.unitInfoToID = function(unitName, unitRealmID)
	return strconcat(unitName or "_", '-', unitRealmID or Globals.player_realm_id);
end

-- Separates the unit name and realm from an unit ID
Utils.str.unitIDToInfo = function(unitID)
	if not unitID:find('-') then
		return unitID, Globals.player_realm_id;
	end
	return unitID:sub(1, unitID:find('-') - 1), unitID:sub(unitID:find('-') + 1);
end

-- Separates the owner ID and companion name from a companion ID
Utils.str.companionIDToInfo = function(companionID)
	if not companionID:find('_') then
		return companionID, nil;
	end
	return companionID:sub(1, companionID:find('_') - 1), companionID:sub(companionID:find('_') + 1);
end

-- Create a unit ID based on a targetType (target, player, mouseover ...)
-- The returned id can be nil.
Utils.str.getUnitID = function(unit)
	local playerName, realm = UnitFullName(unit);
	if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then
		return nil;
	end
	if not realm then
		realm = Globals.player_realm_id;
	end
	return playerName .. "-" .. realm;
end

-- Return an texture text tag based on the given image url and size.
Utils.str.texture = function(iconPath, iconSize)
	assert(iconPath, "Icon path is nil.");
	iconSize = iconSize or 15;
	return strconcat("|T", iconPath, ":", iconSize, ":", iconSize, "|t");
end

-- Return an texture text tag based on the given icon url and size. Nil safe.
Utils.str.icon = function(iconPath, iconSize)
	iconPath = iconPath or Globals.icons.default;
	return Utils.str.texture("Interface\\ICONS\\" .. iconPath, iconSize);
end

-- Return a color tag based on a letter
Utils.str.color = function(color)
	color = color or "w"; -- default color if bad argument
	if color == "r" then return "|cffff0000" end -- red
	if color == "g" then return "|cff00ff00" end -- green
	if color == "b" then return "|cff0000ff" end -- blue
	if color == "y" then return "|cffffff00" end -- yellow
	if color == "p" then return "|cffff00ff" end -- purple
	if color == "c" then return "|cff00ffff" end -- cyan
	if color == "w" then return "|cffffffff" end -- white
	if color == "0" then return "|cff000000" end -- black
	if color == "o" then return "|cffffaa00" end -- orange
end

-- If the given string is empty, return nil
Utils.str.emptyToNil = function(text)
	if text and #text > 0 then
		return text;
	end
	return nil;
end

-- Assure that the given string will not be nil
Utils.str.nilToEmpty = function(text)
	return text or "";
end

function Utils.str.buildZoneText()
	local text = getZoneText() or ""; -- assuming that there is ALWAYS a zone text. Don't know if it's true.
	if getSubZoneText():len() > 0 then
		text = strconcat(text, " - ", getSubZoneText());
	end
	return text;
end

-- Search if the string matches the pattern in error-safe way.
-- Useful if the pattern his user writen.
function Utils.str.safeMatch(text, pattern)
	local trace = Utils.pcall(string.find, text, pattern);
	if trace[1] then
		return type(trace[2]) == "number";
	end
	return nil; -- Pattern error
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Colors
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Value must be 256 based
local function numberToHexa(number)
	local number = string.format('%x', number);
	if number:len() == 1 then
		number = '0' .. number;
	end
	return number;
end
Utils.color.numberToHexa = numberToHexa;

--- Value must be a string with hexa decimal representation
local function hexaToNumber(hexa)
	if not hexa then
		return nil, nil, nil;
	end
	local redH = tonumber(hexa:sub(1, 2), 16)
	local greenH = tonumber(hexa:sub(3, 4), 16)
	local blueH = tonumber(hexa:sub(5, 6), 16)
	return redH, greenH, blueH;
end
Utils.color.hexaToNumber = hexaToNumber;

--- Values must be 256 based
local function colorCode(red, green, blue)
	local redH = numberToHexa(red);
	local greenH = numberToHexa(green);
	local blueH = numberToHexa(blue);
	return strconcat("|cff", redH, greenH, blueH);
end
Utils.color.colorCode = colorCode;

--- Values must be 0..1 based
Utils.color.colorCodeFloat = function(red, green, blue)
	return colorCode(math.ceil(red*255), math.ceil(green*255), math.ceil(blue*255));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Math
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function incrementNumber(version, figures)
	local incremented = version + 1;
	if incremented >= math.pow(10, figures) then
		incremented = 1;
	end
	return incremented;
end
Utils.math.incrementNumber = incrementNumber;

--- Return the interpolation.
-- delta is a number between 0 and 1;
local function lerp(delta, from, to)
	local diff = to - from;
	return from + (delta * diff);
end
Utils.math.lerp = lerp;

Utils.math.color = function(delta, fromR, fromG, fromB, toR, toG, toB)
	return lerp(delta, fromR, toR), lerp(delta, fromG, toG), lerp(delta, fromB, toB);
end

--- Values must be 256 based
Utils.math.colorCode = function(delta, fromR, fromG, fromB, toR, toG, toB)
	return colorCode(lerp(delta, fromR, toR), lerp(delta, fromG, toG), lerp(delta, fromB, toB));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Text tags utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local directReplacements = {
	["/col"] = "|r",
};

local function convertTextTag(tag)

	if directReplacements[tag] then -- Direct replacement
		return directReplacements[tag];
	elseif tag:match("^col%:%a$") then -- Color replacement
		return Utils.str.color(tag:match("^col%:(%a)$"));
	elseif tag:match("^col:%x%x%x%x%x%x$") then -- Hexa color replacement
		return "|cff"..tag:match("^col:(%x%x%x%x%x%x)$");
	elseif tag:match("^icon%:[%w%s%_%-%d]+%:%d+$") then -- Icon
		local icon, size = tag:match("^icon%:([%w%s%_%-%d]+)%:(%d+)$");
		return Utils.str.icon(icon, size);
	end

	return "{"..tag.."}";
end

local function convertTextTags(text)
	if text then
		text = text:gsub("%{(.-)%}", convertTextTag);
		return text;
	end
end
Utils.str.convertTextTags = convertTextTags;

local escapedHTMLCharacters = {
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
};

local structureTags = {
	["{h(%d)}"] = "<h%1>",
	["{h(%d):c}"] = "<h%1 align=\"center\">",
	["{h(%d):r}"] = "<h%1 align=\"right\">",
	["{/h(%d)}"] = "</h%1>",

	["{p}"] = "<P>",
	["{p:c}"] = "<P align=\"center\">",
	["{p:r}"] = "<P align=\"right\">",
	["{/p}"] = "</P>",
};

-- Convert the given text by his HTML representation
Utils.str.toHTML = function(text)

	-- 1) Replacement : & character
	text = text:gsub("&", "&amp;");

	-- 2) Replacement : escape HTML characters
	for pattern, replacement in pairs(escapedHTMLCharacters) do
		text = text:gsub(pattern, replacement);
	end

	-- 3) Replacement : text tags
	for pattern, replacement in pairs(structureTags) do
		text = text:gsub(pattern, replacement);
	end

	local tab = {};
	local i=1;
	while text:find("<") and i<200 do

		local before;
		before = text:sub(1, text:find("<") - 1);
		if #before > 0 then
			tinsert(tab, before);
		end

		local tagText;

		local tag = text:match("</(.-)>");
		if tag then
			tagText = text:sub( text:find("<"), text:find("</") + #tag + 2);
			if #tagText == #tag + 3 then
				return "Error in pattern"; -- TODO locals
			end
			tinsert(tab, tagText);
		else
			return "Error in pattern : tag not closed"; -- TODO locals
		end

		local after;
		after = text:sub(#before + #tagText + 1);
		text = after;

		--		Log.log("Iteration "..i);
		--		Log.log("before ("..(#before).."): "..before);
		--		Log.log("tagText ("..(#tagText).."): "..tagText);
		--		Log.log("after ("..(#before).."): "..after);

		i = i+1;
		if i == 500 then
			log("HTML overfloooow !", Log.level.SEVERE);
		end
	end
	if #text > 0 then
		tinsert(tab, text); -- Rest of the text
	end

	--	log("Parts count "..(#tab));

	local finalText = "";
	for _, line in pairs(tab) do
		if not line:find("<") then
			line = "<P>"..line.."</P>";
		end
		line = line:gsub("\n","<br/>");

		line = line:gsub("{img%:(.-)%:(.-)%:(.-)%}",
		"</P><img src=\"%1\" align=\"center\" width=\"%2\" height=\"%3\"/><P>");

		line = line:gsub("{link%*(.-)%*(.-)}",
		"<a href=\"%1\">|cff00ff00["..loc("CM_LINK").." : %2]|r</a>");

		finalText = finalText..line;
	end

	return "<HTML><BODY>"..convertTextTags(finalText).."</BODY></HTML>";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION / Serialization / HASH
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local libCompress = LibStub:GetLibrary("LibCompress");
local libCompressEncoder = libCompress:GetAddonEncodeTable();
local libSerializer = LibStub:GetLibrary("AceSerializer-3.0");

local function serialize(structure)
	return libSerializer:Serialize(structure);
end
Utils.serial.serialize = serialize;

local function deserialize(structure)
	local status, data = libSerializer:Deserialize(structure);
	assert(status, "Deserialization error:\n" .. tostring(structure));
	return data;
end
Utils.serial.deserialize = deserialize;

local function encodeCompressMessage(message)
	return libCompressEncoder:Encode(libCompress:Compress(message));
end
Utils.serial.encodeCompressMessage = encodeCompressMessage;

Utils.serial.decompressCodedMessage = function(message)
	return libCompress:Decompress(libCompressEncoder:Decode(message));
end

Utils.serial.decompressCodedStructure = function(message)
	return deserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

Utils.serial.encodeCompressStructure = function(structure)
	return encodeCompressMessage(serialize(structure));
end

Utils.serial.hashCode = function(str)
	return libCompress:fcs32final(libCompress:fcs32update(libCompress:fcs32init(), str));
end



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
-- Handles WOW events
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};

Utils.event.registerHandler = function(event, callback)
	assert(event, "Event must be set.");
	assert(callback and type(callback) == "function", "Callback must be a function");
	if not REGISTERED_EVENTS[event] then
		REGISTERED_EVENTS[event] = {};
		TRP3_EventFrame:RegisterEvent(event);
	end
	local handlerID = generateID();
	while REGISTERED_EVENTS[event][handlerID] do -- Avoiding collision
		handlerID = generateID();
	end
	REGISTERED_EVENTS[event][handlerID] = callback;
	Log.log(("Registered event %s with id %s"):format(tostring(event), handlerID));
	return handlerID;
end

Utils.event.unregisterHandler = function(handlerID)
	assert(handlerID, "handlerID must be set.");
	for event, eventTab in pairs(REGISTERED_EVENTS) do
		if eventTab[handlerID] then
			eventTab[handlerID] = nil;
			if tableSize(eventTab) == 0 then
				REGISTERED_EVENTS[event] = nil;
				TRP3_EventFrame:UnregisterEvent(event);
			end
			Log.log(("Unregistered event %s with id %s"):format(tostring(event), handlerID));
			return;
		end
	end
	Log.log(("handlerID not found %s"):format(handlerID));
end

function TRP3_EventDispatcher(self, event, ...)
	-- Callbacks
	if REGISTERED_EVENTS[event] then
		for _, callback in pairs(REGISTERED_EVENTS[event]) do
			callback(...);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MUSIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Utils.music.play = function(music)
	assert(music, "Music can't be nil.")
	if type(music) == "number" then
		Log.log("Playing sound: " .. music);
		PlaySoundKitID(music);
	else
		Log.log("Playing music: " .. music);
		PlayMusic("Sound\\Music\\" .. music .. ".mp3");
	end
end

Utils.music.stop = function()
	StopMusic();
end

Utils.music.getTitle = function(musicURL)
	return type(musicURL) == "number" and musicURL or musicURL:match("[%\\]?([^%\\]+)$");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Textures
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Utils.texture.applyRoundTexture = function(textureFrame, texturePath, failTexture)
	local ok, errorMess = pcall(SetPortraitToTexture, textureFrame, texturePath);
	if not ok then
		Log.log("Fail to round texture: " .. tostring(errorMess));
		if failTexture then
			SetPortraitToTexture(textureFrame, failTexture);
		elseif _G[textureFrame] then
			_G[textureFrame]:SetTexture(texturePath);
		end
	end
end
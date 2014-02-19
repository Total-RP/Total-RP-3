--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_UTILS = {
	log = {},
	table = {},
	str = {},
	color = {},
	lerp = {},
	serial = {},
	event = {},
	music = {},
};
-- TRP3 API
local Globals = TRP3_GLOBALS;
local Utils = TRP3_UTILS;
local Log = Utils.log;
local loc = TRP3_L;

-- WOW API
local tostring = tostring;
local pairs = pairs;
local type = type;
local print = print;
local string = string;
local pcall = pcall;
local date = date;
local math = math;
local strconcat = strconcat;
local tinsert = tinsert;
local assert = assert;
local PlayMusic = PlayMusic;
local StopMusic = StopMusic;
local _G = _G;

local isDebug = true;
local showLog = true;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Chat frame
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Utils.print = function(...)
	print(...);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Log.level = {
	DEBUG = "-|cff6666ffDEBUG|r] ",
	INFO = "-|cff00ffffINFO|r] ",
	WARNING = "-|cffffaa00WARNING|r] ",
	SEVERE = "-|cffff0000SEVERE|r] "
}

local function log(message, level)
	if not showLog or (level == Log.level.DEBUG and not isDebug) then
		return;
	end
	Utils.print( "[TRP3"..(level or Log.level.INFO)..tostring(message));
end
Log.log = log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Table utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Utils.table.dumpTab = function(tab)
	log("Dump tab "..tostring(tab), Log.level.DEBUG);
	if tab then
		for k,v in pairs(tab) do
			log(k.." : "..tostring(v).." ( "..type(v).." )", Log.level.DEBUG);
		end
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

Utils.table.size = function(table)
    local count = 0;
    for _,_ in pairs(table) do
        count = count + 1;
    end
    return count;
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
Utils.str.id = function()
	local i;
	local ID = date("%m%d%H%M%S");
	for i=1, 5 do
		ID = ID..string.char(math.random(33,126));
	end
	return ID;
end

Utils.str.unitInfoToID = function(unitName, unitRealmID)
    return strconcat(unitName or "_", '-', unitRealmID or Globals.player_realm_id);
end

Utils.str.unitIDToInfo = function(unitID)
    return unitID:sub(1, unitID:find('-') - 1), unitID:sub(unitID:find('-') + 1);
end

Utils.str.getFullName = function(unit)
    local playerName, realm = UnitFullName(unit);
    if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then
    	return nil;
    end
    if not realm then
    	realm = Globals.player_realm_id;
    end
    return playerName .. "-" .. realm;
end

-- Return an texture text tag based on the given icon url and size. Nil safe.
Utils.str.icon = function(iconPath, iconSize)
	iconPath = iconPath or Globals.icons.default
	iconSize = iconSize or 15;
	return strconcat("|TInterface\\ICONS\\", iconPath, ":", iconSize, ":", iconSize, "|t");
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
-- Linear interpolations
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Return the interpolation.
-- delta is a number between 0 and 1;
local function lerp(delta, from, to)
	local diff = to - from;
	return from + (delta * diff);
end
Utils.lerp.lerp = lerp;

Utils.lerp.color = function(delta, fromR, fromG, fromB, toR, toG, toB)
	return lerp(delta, fromR, toR), lerp(delta, fromG, toG), lerp(delta, fromB, toB);
end

--- Values must be 256 based
Utils.lerp.colorCode = function(delta, fromR, fromG, fromB, toR, toG, toB)
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
	text = text:gsub("%{(.-)%}", convertTextTag);
	return text;
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
		if i == 200 then
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
		
		line = line:gsub("{link||(.-)||(.-)}",
			"<a href=\"%1\">|cff00ff00["..loc("CM_LINK").." : %2]|r</a>");

		finalText = finalText..line;
	end
	
	return "<HTML><BODY>"..convertTextTags(finalText).."</BODY></HTML>";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION / Serialization
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local libCompress = LibStub:GetLibrary("LibCompress");
local libCompressEncoder = libCompress:GetAddonEncodeTable();

local function serialize(structure)
	return Globals.addon:Serialize(structure);
end
Utils.serial.serialize = serialize;

local function deserialize(structure)
	local status, data = Globals.addon:Deserialize(structure);
	assert(status, "Deserialization error:\n" .. tostring(structure));
	return data;
end
Utils.serial.deserialize = deserialize;

local function encodeCompressMessage(message)
	return libCompress:GetAddonEncodeTable():Encode(libCompress:Compress(message));
end
Utils.serial.encodeCompressMessage = encodeCompressMessage;

Utils.serial.decompressCodedMessage = function(message)
	return libCompress:Decompress(libCompress:GetAddonEncodeTable():Decode(message));
end

Utils.serial.decompressCodedStructure = function(message)
	return deserialize(libCompress:Decompress(libCompress:GetAddonEncodeTable():Decode(message)));
end

Utils.serial.encodeCompressStructure = function(structure)
	return encodeCompressMessage(serialize(structure));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};

Utils.event.registerHandler = function(event, callback)
	assert(event, "Event must be set.");
	assert(callback and type(callback) == "function", "Callback must be a function");
	if not REGISTERED_EVENTS[event] then
		REGISTERED_EVENTS[event] = {};
		TRP3_EventFrame:RegisterEvent(event);
	end
	tinsert(REGISTERED_EVENTS[event], callback);
	Log.log("Registered event: " ..tostring(event));
end

function TRP3_EventDispatcher(self, event, ...)
	-- Main event function, if exists
	if _G["TRP3_onEvent_"..event] then
		_G["TRP3_onEvent_"..event](...);
	end
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
	Log.log("Playing music: " .. music);
	PlayMusic("Sound\\Music\\" .. music .. ".mp3");
end

Utils.music.stop = function()
	StopMusic();
end

Utils.music.getTitle = function(musicURL)
	local musicName = musicURL:reverse();
	return (musicName:sub(1, musicName:find("%\\")-1)):reverse();
end
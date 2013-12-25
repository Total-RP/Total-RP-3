--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local loc = TRP3_L;
local isDebug = true;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_LOG_LEVEL = {
	DEBUG = "-|cff6666ffDEBUG|r] ",
	INFO = "-|cff00ffffINFO|r] ",
	WARNING = "-|cffffaa00WARNING|r] ",
	SEVERE = "-|cffff0000SEVERE|r] "
}

function TRP3_Log(message, level)
	if level == TRP3_LOG_LEVEL.DEBUG and not isDebug then
		return;
	end
	print( "[TRP3"..(level or TRP3_LOG_LEVEL.INFO)..tostring(message));
end

function string.log(a)
	return TRP3_Log(a);
end

function TRP3_DumpTab(tab)
	TRP3_Log("Dump tab "..tostring(tab), TRP3_LOG_LEVEL.DEBUG);
	if tab then
		for k,v in pairs(tab) do
			TRP3_Log(k.." : "..tostring(v).." ( "..type(v).." )", TRP3_LOG_LEVEL.DEBUG);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Chat frame
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Print(...)
	print(...);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Common utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Recursively copy all content from a table to another one.
-- Argument "destination" must be a non nil table reference.
function TRP3_DupplicateTab(destination, source)
	if destination == nil or source == nil then return end
    for k,v in pairs(source) do
		if(type(v)=="table") then
			destination[k] = {};
			TRP3_DupplicateTab(destination[k], v);
		else
			destination[k] = v;
		end
    end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- String utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- A secure way to check if a String matches a pattern.
-- This is useful when using user-given pattern, as malformed pattern would produce lua error.
function TRP3_StringMatches(stringToCheck, pattern)
	local ok, result = pcall(string.find, string.lower(stringToCheck), string.lower(pattern));
	if not ok then
		return false; -- Syntax error.
	end
	-- string.find should return a number if the string matches the pattern
	return string.find(tostring(result), "%d");
end

--	Generate a pseudo-unique random ID.
--  If you encounter a collision, you really should playing lottery
--	ID's have a TRP3_ID_LENGTH characters length
function TRP3_GenerateID()
	local i;
	local ID = date("%m%d%H%M%S");
	for i=1, 5 do
		ID = ID..string.char(math.random(33,126));
	end
	return ID;
end

function TRP3_GetUnitID(unitName, unitRealm)
    return strconcat((unitRealm or TRP3_REALM), '|', unitName or "_");
end

-- Return an texture text tag based on the given icon url and size. Nil safe.
function TRP3_Icon(iconPath, iconSize)
	iconPath = iconPath or TRP3_ICON_DEFAULT
	iconSize = iconSize or 15;
	return strconcat("|TInterface\\ICONS\\", iconPath, ":", iconSize, ":", iconSize, "|t");
end

-- Return a color tag based on a letter
function TRP3_Color(color)
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
function TRP3_StringEmptyToNil(text)
	if text and #text > 0 then
		return text;
	end
	return nil;
end

-- Assure that the given string will not be nil
function TRP3_StringNilToEmpty(text)
	return text or "";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Linear interpolations
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Return the interpolation.
-- delta is a number between 0 and 1;
function TRP3_Lerp(delta, from, to)
	local diff = to - from;
	return from + (delta * diff);
end

function TRP3_Lerp_Color(delta, fromR, fromG, fromB, toR, toG, toB)
	return TRP3_Lerp(delta, fromR, toR), TRP3_Lerp(delta, fromG, toG), TRP3_Lerp(delta, fromB, toB);
end

--- Values must be 256 based
function TRP3_Lerp_ColorCode(delta, fromR, fromG, fromB, toR, toG, toB)
	return TRP3_ColorCode(TRP3_Lerp(delta, fromR, toR), TRP3_Lerp(delta, fromG, toG), TRP3_Lerp(delta, fromB, toB));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Colors
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Value must be 256 based
function TRP3_NumberToHexa(number)
	local number = string.format('%x', number);
	if number:len() == 1 then 
		number = '0' .. number;
	end
	return number;
end

--- Values must be 256 based
function TRP3_ColorCode(red, green, blue)
	local redH = TRP3_NumberToHexa(red);
	local greenH = TRP3_NumberToHexa(green);
	local blueH = TRP3_NumberToHexa(blue);
	return strconcat("|cff", redH, greenH, blueH);
end

--- Values must be 0..1 based
function TRP3_ColorCodeFloat(red, green, blue)
	return TRP3_ColorCode(math.ceil(red*255), math.ceil(green*255), math.ceil(blue*255));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Text tags utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local directReplacements = {
	["/col"] = "|r",
};

local function convertTextTags(tag)

	if directReplacements[tag] then -- Direct replacement
		return directReplacements[tag];
	elseif tag:match("^col%:%a$") then -- Color replacement
		 return TRP3_Color(tag:match("^col%:(%a)$"));
	elseif tag:match("^col:%x%x%x%x%x%x$") then -- Hexa color replacement
		return "|cff"..tag:match("^col:(%x%x%x%x%x%x)$");
	elseif tag:match("^icon%:[%w%s%_%-%d]+%:%d+$") then -- Icon
		local icon, size = tag:match("^icon%:([%w%s%_%-%d]+)%:(%d+)$");
		return TRP3_Icon(icon, size);
	end
	
	return "{"..tag.."}";
end

function TRP3_ConvertTextTags(text)
	text = text:gsub("%{(.-)%}", convertTextTags);
	return text;
end

function TRP3_RemoveColorTags(text)
	return text:gsub("%|c%x%x%x%x%x%x", "");
end

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
function TRP2_toHTML(text)
	
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
		
--		TRP3_Log("Iteration "..i);
--		TRP3_Log("before ("..(#before).."): "..before);
--		TRP3_Log("tagText ("..(#tagText).."): "..tagText);
--		TRP3_Log("after ("..(#before).."): "..after);
		
		i = i+1;
		if i == 200 then
			TRP3_Log("HTML overfloooow !", TRP3_LOG_LEVEL.SEVERE);
		end
	end
	if #text > 0 then
		tinsert(tab, text); -- Rest of the text
	end
	
--	TRP3_Log("Parts count "..(#tab));

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
	
	return "<HTML><BODY>"..TRP3_ConvertTextTags(finalText).."</BODY></HTML>";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION / Serialization
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local libCompress = LibStub:GetLibrary("LibCompress");
local libCompressEncoder = libCompress:GetAddonEncodeTable();

function TRP3_Serialize(structure)
	return TRP3_GetAddon():Serialize(structure);
end

function TRP3_Deserialize(structure)
	local status, data = TRP3_GetAddon():Deserialize(structure);
	assert(status, "Deserialization error:\n" .. tostring(structure));
	return data;
end

function TRP3_EncodeCompressMessage(message)
	return libCompress:GetAddonEncodeTable():Encode(libCompress:Compress(message));
end

function TRP3_DecompressCodedMessage(message)
	return libCompress:Decompress(libCompress:GetAddonEncodeTable():Decode(message));
end

function TRP3_DecompressCodedStructure(message)
	return TRP3_Deserialize(libCompress:Decompress(libCompress:GetAddonEncodeTable():Decode(message)));
end

function TRP3_EncodeCompressStructure(structure)
	return TRP3_EncodeCompressMessage(TRP3_Serialize(structure));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};

function TRP3_RegisterToEvent(event, callback)
	assert(event, "Event must be set.");
	assert(callback and type(callback) == "function", "Callback must be a function");
	if not REGISTERED_EVENTS[event] then
		REGISTERED_EVENTS[event] = {};
		TRP3_EventFrame:RegisterEvent(event);
	end
	tinsert(REGISTERED_EVENTS[event], callback);
	TRP3_Log("Registered event: " ..tostring(event));
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
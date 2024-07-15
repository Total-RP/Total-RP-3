-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;
local LibRPMedia = LibStub:GetLibrary("LibRPMedia-1.0");

-- TRP3 imports
local Globals = TRP3_API.globals;
local Utils = TRP3_API.utils;
local loc = TRP3_API.loc;

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
-- Messaging
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- CHAT_FRAME : ChatFrame (given by chatFrameIndex or default if nil)
-- ALERT_POPUP : TRP3 alert popup
-- RAID_ALERT : On screen alert (Raid notice frame)
Utils.message.type = {
	CHAT_FRAME = 1,
	ALERT_POPUP = 2,
	RAID_ALERT = 3,
	ALERT_MESSAGE = 4
};
local messageTypes = Utils.message.type;

-- Display a simple message. Nil free.
Utils.message.displayMessage = function(message, messageType)
	if not messageType or messageType == messageTypes.CHAT_FRAME then
		TRP3_Addon:Print(tostring(message));
	elseif messageType == messageTypes.ALERT_POPUP then
		TRP3_API.popup.showAlertPopup(tostring(message));
	elseif messageType == messageTypes.RAID_ALERT then
		RaidNotice_AddMessage(RaidWarningFrame, tostring(message), ChatTypeInfo["RAID_WARNING"]);
	elseif messageType == messageTypes.ALERT_MESSAGE then
		UIErrorsFrame:AddMessage(message, 1.0, 0.0, 0.0);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Table utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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

local ID_CHARS = {};
for i=48, 57 do
	tinsert(ID_CHARS, string.char(i));
end
for i=65, 90 do
	tinsert(ID_CHARS, string.char(i));
end
for i=97, 122 do
	tinsert(ID_CHARS, string.char(i));
end
local sID_CHARS = #ID_CHARS;

--- Generate a pseudo-unique random ID.
--  If you encounter a collision, you really should playing lottery
--- ID's have a id_length characters length
local function generateID()
	local ID = date("%m%d%H%M%S");
	for _=1, 5 do
		ID = ID .. ID_CHARS[math.random(1, sID_CHARS)];
	end
	return ID;
end
Utils.str.id = generateID;

-- Create a unit ID from a unit name and unit realm. If realm = nil then we use current realm.
-- This method ALWAYS return a nil free UnitName-RealmShortName string.
Utils.str.unitInfoToID = function(unitName, unitRealmID)
	-- Some functions (like GetPlayerInfoByGUID(GUID)) will return an empty string for the realm instead of null…
	-- Thanks Blizz…
	if not unitRealmID or unitRealmID == "" then
		unitRealmID = Globals.player_realm_id
	end
	return strconcat(unitName or "_", '-', unitRealmID or "_");
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
function Utils.str.getUnitID(unit)
	local playerName, realm = UnitNameUnmodified(unit);
	if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then
		return nil;
	end
	if not realm then
		realm = Globals.player_realm_id;
	end
	return playerName .. "-" .. realm;
end

local UnitGUID = UnitGUID;

function Utils.str.getUnitDataFromGUIDDirect(GUID)
	local unitType, _, _, _, _, npcID = strsplit("-", GUID or "");
	return unitType, npcID;
end

function Utils.str.getUnitDataFromGUID(unitID)
	return Utils.str.getUnitDataFromGUIDDirect(UnitGUID(unitID));
end

function Utils.str.getUnitNPCID(unitID)
	local _, npcID = Utils.str.getUnitDataFromGUID(unitID);
	return npcID;
end

function Utils.str.GetGuildName(unitID)
	local guildName = GetGuildInfo(unitID);
	return guildName;
end

function Utils.str.GetGuildRank(unitID)
	local _, rank = GetGuildInfo(unitID);
	return rank;
end

function Utils.str.GetRace(unitID)
	local _, race = UnitRace(unitID);
	return race;
end

function Utils.str.GetClass(unitID)
	local _, class = UnitClass(unitID);
	return class;
end

function Utils.str.GetFaction(unitID)
	local faction = UnitFactionGroup(unitID);
	return faction;
end

-- Return an texture text tag based on the given image url and size.
function Utils.str.texture(iconPath, iconSize)
	assert(iconPath, "Icon path is nil.");
	iconSize = iconSize or 15;

	-- Removing extra sizes
	if type(iconPath) == "string" then
		local sanitizeIndex = iconPath:find(":");
		if sanitizeIndex then
			iconPath = iconPath:sub(1, sanitizeIndex - 1);
		end
	end

	return strconcat("|T", iconPath, ":", iconSize, ":", iconSize, "|t");
end

-- Return an texture text tag based on the given icon url and size. Nil safe.
function Utils.str.icon(iconPath, iconSize)
	iconPath = iconPath or TRP3_InterfaceIcons.Default;
	return Utils.str.texture(Utils.getIconTexture(iconPath), iconSize);
end

--- Gives the full texture path of an individual icon.
--- Handle using icon as a string, a file ID or as an Ellyb.icon
--- @param icon string|Icon
--- @return string
function Utils.getIconTexture(icon)
	if type(icon) == "table" and icon.isInstanceOf and icon:isInstanceOf(Ellyb.Icon) then
		return icon:GetFileID()
	elseif type(icon) == "number" then
		return icon
	else
		return "Interface\\ICONS\\" .. tostring(icon)
	end
end

-- Return a color tag based on a letter
function Utils.str.color(color)
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
function Utils.str.emptyToNil(text)
	if text and #text > 0 then
		return text;
	end
	return nil;
end

-- Assure that the given string will not be nil
function Utils.str.nilToEmpty(text)
	return text or "";
end

function Utils.str.buildZoneText()
	local text = GetZoneText() or ""; -- assuming that there is ALWAYS a zone text. Don't know if it's true.
	if GetSubZoneText():len() > 0 then
		text = strconcat(text, " - ", GetSubZoneText());
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

local escapes = {
	["|c........"] = "", -- color start
	["|cn[^:]+:"] = "", -- 10.0 color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
	["|A.-|a"] = "", -- atlas textures
	["|K.-|k"] = "", -- protected strings
	["|W(.-)|w"] = "%1", -- word wrapping
}
function Utils.str.sanitize(text, multiLine)
	if not text then return end
	-- Repeat until nested tags are eliminated.
	repeat
		local originalText = text;
		for k, v in pairs(escapes) do
			text = text:gsub(k, v);
		end
		if not multiLine then
			text = text:gsub("\n", "");
			text = text:gsub("\r", "");
			text = text:gsub("|n", "");
		end
	until originalText == text;
	return text
end

local validSuffixes = {
	"^a", "^b", -- MRP
	"^%-alpha", "^%-beta" -- TRP3
};

function Utils.str.sanitizeVersion(text)
	if not text then return end
	-- Dev version
	if text == "-dev" or text == "v-dev" then return text end

	text = Utils.str.sanitize(text);

	local version, suffix = text:match("^(v?[%d%.]+)(.*)$");
	if not version then
		version = "0";
	end

	-- Looking for testing version suffix
	if suffix then
		for _, str in pairs(validSuffixes) do
			local validSuffix = suffix:match(str);
			if validSuffix then
				version = version .. validSuffix
				break
			end
		end
	end

	return version;
end

function Utils.str.crop(text, size)
	text = string.trim(text or "");

	if strlenutf8(text) > size then
		text = string.utf8sub(text, 1, size - 1) .. "…";
	end

	return text;
end

local tableAccents = {
	["À"] = "A",
	["Á"] = "A",
	["Â"] = "A",
	["Ã"] = "A",
	["Ä"] = "A",
	["Å"] = "A",
	["Æ"] = "AE",
	["Ç"] = "C",
	["È"] = "E",
	["É"] = "E",
	["Ê"] = "E",
	["Ë"] = "E",
	["Ì"] = "I",
	["Í"] = "I",
	["Î"] = "I",
	["Ï"] = "I",
	["Ð"] = "D",
	["Ñ"] = "N",
	["Ò"] = "O",
	["Ó"] = "O",
	["Ô"] = "O",
	["Õ"] = "O",
	["Ö"] = "O",
	["Ø"] = "O",
	["Ù"] = "U",
	["Ú"] = "U",
	["Û"] = "U",
	["Ü"] = "U",
	["Ý"] = "Y",
	["Þ"] = "P",
	["ß"] = "s",
	["à"] = "a",
	["á"] = "a",
	["â"] = "a",
	["ã"] = "a",
	["ä"] = "a",
	["å"] = "a",
	["æ"] = "ae",
	["ç"] = "c",
	["è"] = "e",
	["é"] = "e",
	["ê"] = "e",
	["ë"] = "e",
	["ì"] = "i",
	["í"] = "i",
	["î"] = "i",
	["ï"] = "i",
	["ð"] = "eth",
	["ñ"] = "n",
	["ò"] = "o",
	["ó"] = "o",
	["ô"] = "o",
	["õ"] = "o",
	["ö"] = "o",
	["ø"] = "o",
	["ù"] = "u",
	["ú"] = "u",
	["û"] = "u",
	["ü"] = "u",
	["ý"] = "y",
	["þ"] = "p",
	["ÿ"] = "y",
};

-- Convert special characters into regular a-z characters for alphabetical order purposes
function Utils.str.convertSpecialChars(text)
	local convertedText = text:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents);
	return convertedText;
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- GUID
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--[[
http://wow.gamepedia.com/API_UnitGUID
GUID formats (since 6.0.2):

For players: Player-[server ID]-[player UID] (Example: "Player-976-0002FD64")
For creatures, pets, objects, and vehicles: [Unit type]-0-[server ID]-[instance ID]-[zone UID]-[ID]-[Spawn UID] (Example: "Creature-0-976-0-11-31146-000136DF91")
Unit Type Names: "Creature", "Pet", "GameObject", and "Vehicle"
For vignettes: Vignette-0-[server ID]-[instance ID]-[zone UID]-0-[spawn UID] (Example: "Vignette-0-970-1116-7-0-0017CAE465" for rare mob Sulfurious)
]]
Utils.guid = {};

local GUID_TYPES = {
	PLAYER = "Player",
	CREATURE = "Creature",
	PET = "Pet",
	GAME_OBJECT = "GameObject",
	VEHICLE = "Vehicle",
	VIGNETTE = "Vignette"
}

--- Check that the given GUID is correctly formatted to be a player GUID
-- @param GUID
--
function Utils.guid.getUnitType(GUID)
	return GUID:match("%a+");
end

--- Check that the given GUID is correctly formatted to be a player GUID
-- I made this because WIM sends invalid GUID at us so I have to check that…
-- @param GUID
--
function Utils.guid.isAPlayerGUID(GUID)
	return Utils.guid.getUnitType(GUID) == GUID_TYPES.PLAYER;
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
	elseif tag:match("^icon%:[^:]+%:%d+$") then -- Icon
		local icon, size = tag:match("^icon%:([^:]+)%:(%d+)$");
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

--- alignmentAttributes is a conversion table for taking a single-character
--  alignment specifier and getting a value suitable for use in the HTML
--  "align" attribute.
local alignmentAttributes = {
	["c"] = "center",
	["l"] = "left",
	["r"] = "right",
};

--- IMAGE_PATTERN is the string pattern used for performing image replacements
--  in strings that should be rendered as HTML.
---
--- The accepted form this is "{img:<src>:<width>:<height>[:align]}".
---
--- Each individual segment matches up to the next present colon. The third
--- match (height) and everything thereafter needs to check up-to the next
--- colon -or- ending bracket since they could be the final segment.
---
--- Optional segments should of course have the "?" modifer attached to
--- their preceeding colon, and should use * for the content match rather
--- than +.
local IMAGE_PATTERN = [[{img%:([^:]+)%:([^:]+)%:([^:}]+)%:?([^:}]*)%}]];

--- Note that the image tag has to be outside a <P> tag.
---@language HTML
local IMAGE_TAG = [[</P><img src="%s" width="%s" height="%s" align="%s"/><P>]];

local function GenerateLinkFormatter(line, defaultLinkColor, includeBraces, isMarkdown)
	local function FormatLink(position, url, text)
		-- If a link is preceeded by a "{col}" tag then we won't insert any
		-- coloring for this link to allow users to customize things more.

		local linkColor;

		local shortColor = string.sub(line, position - 7, position - 1);
		local hexColor   = string.sub(line, position - 12, position - 1);

		if string.find(shortColor, "^{col:%w}$") then
			linkColor = nil;  -- Preceeded by a short color tag, ignore.
		elseif string.find(hexColor, "^{col:%x%x%x%x%x%x}$") then
			linkColor = nil;  -- Preceeded by a hexadecimal color tag, ignore.
		else
			linkColor = defaultLinkColor;  -- No preceeding color, use default.
		end

		if isMarkdown then
			-- Markdown style links invert the order of the text/url components.
			url, text = text, url;
		end

		if includeBraces then
			text = "[" .. text .. "]";
		end

		if linkColor then
			text = WrapTextInColorCode(text, "ff" .. linkColor);
		end

		return string.format([[<a href="%1$s">%2$s</a>]], url, text);
	end

	return FormatLink;
end

-- Convert the given text by his HTML representation
Utils.str.toHTML = function(text, noColor, noBrackets)

	local linkColor = "00ff00";
	if noColor then
		linkColor = nil;
	end

	-- 1) Replacement : & character
	text = text:gsub("&", "&amp;");

	-- 2) Replacement : escape HTML characters
	for pattern, replacement in pairs(escapedHTMLCharacters) do
		text = text:gsub(pattern, replacement);
	end

	-- 3) Replace Markdown
	local titleFunction = function(titleChars, title)
		local titleLevel = #titleChars;
		return "\n<h" .. titleLevel .. ">" .. strtrim(title) .. "</h" .. titleLevel .. ">";
	end;

	text = text:gsub("^(#+)(.-)\n", titleFunction);
	text = text:gsub("\n(#+)(.-)\n", titleFunction);
	text = text:gsub("\n(#+)(.-)$", titleFunction);
	text = text:gsub("^(#+)(.-)$", titleFunction);

	-- 4) Replacement : text tags
	for pattern, replacement in pairs(structureTags) do
		text = text:gsub(pattern, replacement);
	end

	local tab = {};
	local i=1;
	while text:find("<") and i<500 do

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
				return loc.PATTERN_ERROR;
			end
			tinsert(tab, tagText);
		else
			return loc.PATTERN_ERROR;
		end

		local after;
		after = text:sub(#before + #tagText + 1);
		text = after;

		--- 	TRP3_API.Log("Iteration "..i);
		--- 	TRP3_API.Log("before ("..(#before).."): "..before);
		--- 	TRP3_API.Log("tagText ("..(#tagText).."): "..tagText);
		--- 	TRP3_API.Log("after ("..(#before).."): "..after);

		i = i+1;
		if i == 500 then
			TRP3_API.Log("HTML overfloooow !");
		end
	end
	if #text > 0 then
		tinsert(tab, text); -- Rest of the text
	end

	--- TRP3_API.Log("Parts count "..(#tab));

	local finalText = "";
	for _, line in pairs(tab) do

		if not line:find("<") then
			line = "<P>" .. line .. "</P>";
		end

		-- Replace newlines with <br/> tags unless following the immediate
		-- start or end of a block element. This assumes no inline elements
		-- have been added yet (namely - images).
		line = line:gsub("()>?()\n", function(pos1, pos2)
			if pos1 ~= pos2 then
				return ">";
			else
				return "<br/>";
			end
		end);

		-- Image tag. Specifiers after the height are optional, so they
		-- must be suitably defaulted and validated.
		line = line:gsub(IMAGE_PATTERN, function(img, width, height, align)
			-- If you've not given an alignment, or it's entirely invalid,
			-- you'll get the old default of center.
			align = alignmentAttributes[align] or "center";

			-- Don't blow up on non-numeric inputs. They won't display properly
			-- but that's a separate issue.
			width = tonumber(width) or 128;
			height = tonumber(height) or 128;

			-- Width and height should be absolute.
			-- The tag accepts negative value but people used that to fuck up their profiles
			return string.format(IMAGE_TAG, img, math.abs(width), math.abs(height), align);
		end);

		line = line:gsub("%!%[(.-)%]%((.-)%)", function(icon, size)
			if icon:find("\\") then
				-- If icon text contains \ we have a full texture path
				local width, height;
				if size:find("%,") then
					width, height = strsplit(",", size);
				else
					width = tonumber(size) or 128;
					height = width;
				end
				-- Width and height should be absolute.
				-- The tag accepts negative value but people used that to fuck up their profiles
				return string.format(IMAGE_TAG, icon, math.abs(width), math.abs(height), "center");
			end
			return Utils.str.icon(icon, tonumber(size) or 25);
		end);

		do  -- Markdown Links
			local includeBraces = true;
			local isMarkdown    = true;
			local formatter     = GenerateLinkFormatter(line, linkColor, includeBraces, isMarkdown);

			line = line:gsub("()%[(.-)%]%((.-)%)", formatter);
		end

		do  -- Link tags with embedded icons
			local includeBraces = false;
			local isMarkdown    = false;
			local formatter     = GenerateLinkFormatter(line, linkColor, includeBraces, isMarkdown);

			line = line:gsub("(){link%*([^*]+)%*({icon:[^}]+})}", formatter);
		end

		do  -- Link tags
			local includeBraces = not noBrackets;
			local isMarkdown    = false;
			local formatter     = GenerateLinkFormatter(line, linkColor, includeBraces, isMarkdown);

			line = line:gsub("(){link%*([^*]+)%*([^}]+)}", formatter);
		end

		line = line:gsub("{twitter%*(.-)%*(.-)}", "<a href=\"twitter%1\">|cff61AAEE%2|r</a>");

		finalText = finalText .. line;
	end

	finalText = convertTextTags(finalText);

	return "<HTML><BODY>" .. finalText .. "</BODY></HTML>";
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
	assert(status, "Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data));
	return data;
end
Utils.serial.deserialize = deserialize;

Utils.serial.errorCount = 0;
local function safeDeserialize(structure, default)
	local status, data = libSerializer:Deserialize(structure);
	if not status then
		TRP3_API.Log("Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data));
		return default;
	end
	return data;
end
Utils.serial.safeDeserialize = safeDeserialize;

local function encodeCompressMessage(message)
	return libCompressEncoder:Encode(libCompress:Compress(message));
end
Utils.serial.encodeCompressMessage = encodeCompressMessage;

Utils.serial.decompressCodedMessage = function(message)
	return libCompress:Decompress(libCompressEncoder:Decode(message));
end

Utils.serial.safeEncodeCompressMessage = function(serial)
	local encoded = encodeCompressMessage(serial);
	-- Rollback test
	local decoded = Utils.serial.decompressCodedMessage(encoded);
	if decoded == serial then
		return encoded;
	else
		TRP3_API.Log("safeEncodeCompressStructure error:\n" .. tostring(serial));
		return nil;
	end
end

Utils.serial.decompressCodedStructure = function(message)
	return deserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

Utils.serial.safeDecompressCodedStructure = function(message)
	return safeDeserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

Utils.serial.encodeCompressStructure = function(structure)
	return encodeCompressMessage(serialize(structure));
end

Utils.serial.hashCode = function(str)
	return libCompress:fcs32final(libCompress:fcs32update(libCompress:fcs32init(), str));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MUSIC / SOUNDS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local soundHandlers = {};

function Utils.music.getHandlers()
	return soundHandlers;
end

function Utils.music.clearHandlers()
	return wipe(soundHandlers);
end

function Utils.music.playSoundID(soundID, channel, source)
	assert(soundID, "soundID can't be nil.")
	local willPlay, handlerID = PlaySound(soundID, channel, false);
	if willPlay then
		tinsert(soundHandlers, {channel = channel, id = soundID, handlerID = handlerID, source = source, date = date("%H:%M:%S"), stopped = false});
		if TRP3_SoundsHistoryFrame then
			TRP3_SoundsHistoryFrame.onSoundPlayed();
		end
	end
	return willPlay, handlerID;
end

function Utils.music.playSoundFileID(soundFileID, channel, source)
	assert(soundFileID, "soundFileID can't be nil.")
	local willPlay, handlerID = PlaySoundFile(soundFileID, channel);
	if willPlay then
		tinsert(soundHandlers, {channel = channel, id = soundFileID, handlerID = handlerID, source = source, date = date("%H:%M:%S"), stopped = false, soundFile = true});
		if TRP3_SoundsHistoryFrame then
			TRP3_SoundsHistoryFrame.onSoundPlayed();
		end
	end
	return willPlay, handlerID;
end

function Utils.music.stopSound(handlerID, fadeoutDuration)
	StopSound(handlerID, fadeoutDuration);
end

function Utils.music.stopSoundID(soundID, channel, source, fadeoutDuration)
	for _, handler in pairs(soundHandlers) do
		if (not handler.stopped) and (not soundID or soundID == "0" or handler.id == soundID) and (not channel or handler.channel == channel) and (not source or handler.source == source) then
			if (handler.channel == "Music" and handler.handlerID == 0) then
				StopMusic();
			else
				Utils.music.stopSound(handler.handlerID, fadeoutDuration);
			end
			handler.stopped = true;
		end
	end
end

function Utils.music.stopChannel(channel)
	Utils.music.stopSoundID(nil, channel, nil);
end

function Utils.music.stopMusic()
	Utils.music.stopChannel("Music");
	StopMusic();
end

function Utils.music.playMusic(music, source)
	assert(music, "Music can't be nil.")
	Utils.music.stopMusic();
	TRP3_API.Log("Playing music: " .. music);
	PlayMusic(music);
	tinsert(soundHandlers, {channel = "Music", id = Utils.music.getTitle(music), handlerID = 0, source = source or Globals.player_id, date = date("%H:%M:%S"), stopped = false});
	if TRP3_SoundsHistoryFrame then
		TRP3_SoundsHistoryFrame.onSoundPlayed();
	end
end

function Utils.music.getTitle(musicURL)
	local musicName;
	local musicTitle;

	if type(musicURL) == "number" then
		musicName = LibRPMedia:GetMusicNameByFile(musicURL);
	end

	if not musicName then
		musicName = format("<File: %s>", tostring(musicURL));
	end

	musicTitle = musicName:match("[%/]?([^%/]+)$");
	return musicTitle or musicName;
end

function Utils.music.convertPathToID(musicURL)
	assert(musicURL, "Music path can't be nil.")
	return LibRPMedia:GetMusicFileByName(musicURL);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Textures
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function Rainbow(value, max)
	local movedValue = value - 1;    -- screw Lua lmao
	local fifth = (max - 1) / 5;
	if movedValue < fifth then
		return TRP3_API.CreateColor(1, 0.3 + 0.7 * movedValue / fifth, 0.3)
	elseif movedValue < 2 * fifth then
		return TRP3_API.CreateColor(1 - 0.7 * (movedValue - fifth) / fifth, 1, 0.3)
	elseif movedValue < 3 * fifth then
		return TRP3_API.CreateColor(0.3, 1, 0.3 + 0.7 * (movedValue - 2 * fifth) / fifth)
	elseif movedValue < 4 * fifth then
		return TRP3_API.CreateColor(0.3, 1 - 0.7 * (movedValue - 3 * fifth) / fifth, 1)
	elseif movedValue ~= max - 1 then
		return TRP3_API.CreateColor(0.3 + 0.7 * (movedValue - 4 * fifth) / fifth, 0.3, 1)
	else
		return TRP3_API.CreateColor(1, 0.3, 1)
	end
end

local function Rainbowify(text)
	local finalText = ""
	local i = 1

	local characterCount = 0;
	for _ in string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)") do
		characterCount = characterCount + 1
	end

	for character in string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)") do
		---@type Color
		local color = Rainbow(i, characterCount)
		finalText = finalText .. color:WrapTextInColorCode(character)
		i = i + 1
	end
	return finalText
end
TRP3_API.utils.Rainbowify = Rainbowify;

local function OldgodCharacterColor(value, max)
	local movedValue = value - 1;    -- screw Lua lmao
	local third = (max - 1) / 3;
	if movedValue < 2 * third then
		return TRP3_API.CreateColor(0.5 + 0.5 * movedValue / (2 * third), 0.3, 1 - 0.7 * movedValue / (2 * third))
	elseif movedValue ~= max - 1 then
		return TRP3_API.CreateColor(1, 0.3 + 0.2 * (movedValue - 2 * third) / third, 0.3)
	else
		return TRP3_API.CreateColor(1, 0.5, 0.3)
	end
end

local function Oldgodify(text)
	local finalText = ""
	local i = 1

	local characterCount = 0;
	for _ in string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)") do
		characterCount = characterCount + 1
	end

	for character in string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)") do
		---@type Color
		local color = OldgodCharacterColor(i, characterCount)
		finalText = finalText .. color:WrapTextInColorCode(character)
		i = i + 1
	end
	return finalText
end
TRP3_API.utils.Oldgodify = Oldgodify;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Settings
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function Utils.GetDefaultLocale()
	return GAME_LOCALE or GetLocale();
end

function Utils.GetPreferredLocale()
	-- TODO: Our addon locale setting unfortunately defaults to the client
	--       locale and gets sticky - if you install the addon on an esMX client
	--       and then change to a ptBR one it'd stay set to esMX. As such, the
	--       default fallback will almost always never actually occur.

	return TRP3_API.configuration.getValue("AddonLocale") or Utils.GetDefaultLocale();
end

-- Ref: <https://en.wikipedia.org/wiki/Date_format_by_country>
local LOCALIZED_DATE_FORMATS =
{
	deDE = "%d/%m/%Y %H:%M",
	enGB = "%d/%m/%Y %H:%M",
	enUS = "%m/%d/%Y %H:%M",
	esES = "%d/%m/%Y %H:%M",
	esMX = "%d/%m/%Y %H:%M",
	frFR = "%d/%m/%Y %H:%M",
	itIT = "%d/%m/%Y %H:%M",
	koKR = "%Y-%m-%d %H:%M",
	ptBR = "%d/%m/%Y %H:%M",
	ptPT = "%d/%m/%Y %H:%M",
	ruRU = "%Y-%m-%d %H:%M",
	zhCN = "%Y-%m-%d %H:%M",
	zhTW = "%Y-%m-%d %H:%M",
};

function Utils.GetDefaultDateFormat()
	local locale = Utils.GetPreferredLocale();

	if locale == "enUS" and LOCALE_enGB then
		locale = "enGB";
	end

	return LOCALIZED_DATE_FORMATS[locale] or LOCALIZED_DATE_FORMATS.enGB;
end

function Utils.GetPreferredDateFormat()
	local format = TRP3_API.configuration.getValue("date_format");

	if type(format) ~= "string" or format == "" then
		format = Utils.GetDefaultDateFormat();
	end

	return format;
end

function Utils.GenerateFormattedDateString(time)
	local format = Utils.GetPreferredDateFormat();
	local result = securecall(date, format, time);

	if not result then
		format = Utils.GetDefaultDateFormat();
		result = date(format, time);
	end

	return result;
end

function Utils.IsAddOnEnabled(addonName)
	local characterName = UnitNameUnmodified("player");
	local enableState = C_AddOns.GetAddOnEnableState(addonName, characterName);
	return enableState == 2;
end

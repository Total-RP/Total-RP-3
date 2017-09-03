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
local strtrim = strtrim;
local tinsert, assert, _G, tremove, next = tinsert, assert, _G, tremove, next;
local PlayMusic, StopMusic = PlayMusic, StopMusic;
local UnitFullName = UnitFullName;
local UNKNOWNOBJECT = UNKNOWNOBJECT;
local SetPortraitToTexture = SetPortraitToTexture;
local getZoneText, getSubZoneText = GetZoneText, GetSubZoneText;
local PlaySound, select, StopSound = PlaySound, select, StopSound;

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
	RAID_ALERT = 3,
	ALERT_MESSAGE = 4
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
	elseif messageType == messageTypes.ALERT_MESSAGE then
		UIErrorsFrame:AddMessage(message, 1.0, 0.0, 0.0);
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
				log(dumpIndent .. dumpColor2 .. key .. "|r=".. dumpColor3 .. "{", Log.level.DEBUG);
				tableDump(value, level + 1);
				log(dumpIndent .. dumpColor3 .. "}", Log.level.DEBUG);
			elseif type(value) == "function" then
				log(dumpIndent .. dumpColor2 .. key .. "|r=" .. dumpColor4 .. " <" .. type(value) ..">", Log.level.DEBUG);
			else
				log(dumpIndent .. dumpColor2 .. key .. "|r=" .. dumpColor3 .. tostring(value) .. dumpColor4 .. " <" .. type(value) ..">", Log.level.DEBUG);
			end
			i = i + 1;
		end
	end
	
	if withCount then
		log(dumpIndent .. dumpColor1 .. ("Level %s size: %s elements"):format(level, i), Log.level.DEBUG);
	end
end

Utils.table.dump = function(table, withCount)
	log(dumpColor1 .. "Dump: ".. tostring(table), Log.level.DEBUG);
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

--	Generate a pseudo-unique random ID.
--  If you encounter a collision, you really should playing lottery
--	ID's have a id_length characters length
local function generateID()
	local ID = date("%m%d%H%M%S");
	for i=1, 5 do
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
	return strconcat(unitName or "_", '-', unitRealmID);
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
	local playerName, realm = UnitFullName(unit);
	if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then
		return nil;
	end
	if not realm then
		realm = Globals.player_realm_id;
	end
	return playerName .. "-" .. realm;
end

local strsplit, UnitGUID = strsplit, UnitGUID;

function Utils.str.getUnitDataFromGUIDDirect(GUID)
	local unitType, _, _, _, _, npcID = strsplit("-", GUID or "");
	return unitType, npcID;
end

function Utils.str.getUnitDataFromGUID(unitID)
	return Utils.str.getUnitDataFromGUIDDirect(UnitGUID(unitID));
end

function Utils.str.getUnitNPCID(unitID)
	local unitType, npcID = Utils.str.getUnitDataFromGUID(unitID);
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
	return strconcat("|T", iconPath, ":", iconSize, ":", iconSize, "|t");
end

-- Return an texture text tag based on the given icon url and size. Nil safe.
function Utils.str.icon(iconPath, iconSize)
	iconPath = iconPath or Globals.icons.default;
	return Utils.str.texture("Interface\\ICONS\\" .. iconPath, iconSize);
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

local escapes = {
	["|c%x%x%x%x%x%x%x%x"] = "", -- color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
}
function Utils.str.sanitize(text)
	if not text then return end
	for k, v in pairs(escapes) do
		text = text:gsub(k, v);
	end
	return text;
end

function Utils.str.crop(text, size)
	text = strtrim(text or "");
	if text:len() > size then
		text = text:sub(1, size) .. "…";
	end
	return text
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
-- Return 256 based
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

local function hexaToFloat(hexa)
	local r, g, b = hexaToNumber(hexa);
	return r / 255, g / 255, b / 255;
end
Utils.color.hexaToFloat = hexaToFloat;

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

--- From r, g, b tab
Utils.color.colorCodeFloatTab = function(tab)
	return colorCode(math.ceil(tab.r*255), math.ceil(tab.g*255), math.ceil(tab.b*255));
end

---
-- Function to test if a color is correctly readable on a specified.
-- We will calculate the luminance of the text color
-- using known values that take into account how the human eye perceive color
-- and then compute the contrast ratio.
-- The contrast ratio should be higher than 50%.
-- @external [](http://www.whydomath.org/node/wavlets/imagebasics.html)
--
-- @param textColor Color of the text {r, g, b}, must be 256 based
-- @return True if the text will be readable
--
local textColorIsReadableOnBackground = function(textColor)
    return ((0.299 * textColor.r + 0.587 * textColor.g + 0.114 * textColor.b)) >= 0.5;
end

Utils.color.textColorIsReadableOnBackground = textColorIsReadableOnBackground;

Utils.color.lightenColorUntilItIsReadable = function(textColor)
	-- If the color is too dark to be displayed in the tooltip, we will ligthen it up a notch
	while not textColorIsReadableOnBackground(textColor) do
		textColor.r = textColor.r + 0.01;
		textColor.g = textColor.g + 0.01;
		textColor.b = textColor.b + 0.01;
	end

	if textColor.r > 1 then textColor.r = 1 end
	if textColor.g > 1 then textColor.g = 1 end
	if textColor.b > 1 then textColor.b = 1 end

	return textColor;
end

-- I quite like Blizzard's Color mixins, it has some nice functions like :WrapTextInColorCode(text)
-- But I will extend them with my own functions like :LightenColorUntilItIsReadable();
local BlizzardCreateColor = CreateColor;

---@return ColorMixin
local function CreateColor(r, g, b, a)
	local color = BlizzardCreateColor(r, g, b, a);
	color.LightenColorUntilItIsReadable = Utils.color.lightenColorUntilItIsReadable;
	return color;
end
Utils.color.CreateColor = CreateColor;

--- Returns a Color using Blizzard's ColorMixin for a given hexadecimal color code
-- @see ColorMixin
function Utils.color.getColorFromHexadecimalCode(hexadecimalCode)
	local r, g, b = Utils.color.hexaToFloat(hexadecimalCode);
	return CreateColor(r, g, b, 1);
end

--- Returns a Color using Blizzard's ColorMixin for a given class (english, not localized)
-- @see ColorMixin
function Utils.color.getClassColor(englishClass)
	if not RAID_CLASS_COLORS[englishClass] then return end
	local classColorTable = RAID_CLASS_COLORS[englishClass];
	return CreateColor(classColorTable.r, classColorTable.g, classColorTable.b, 1);
end

local CONFIG_CHARACT_CONTRAST = "tooltip_char_contrast";

--- Returns the custom color defined in the unitID's profile as a Color using Blizzard's ColorMixing.
-- @param unitID
-- @return Color
-- @see ColorMixin
function Utils.color.getUnitCustomColor(unitID)
	local info = TRP3_API.register.getUnitIDCurrentProfileSafe(unitID);

	if info.characteristics and info.characteristics.CH then
		-- If we do have a custom color code (in hexa) defined, get the RGB float values
		local r, g, b = Utils.color.hexaToFloat(info.characteristics.CH);
		local color = CreateColor(r, g, b, 1);
		return color;
	end
end

function Utils.color.getChatColorForChannel(channel)
	local chatInfo = ChatTypeInfo[channel];
	return CreateColor(chatInfo.r, chatInfo.g, chatInfo.b, 1);
end

local GetPlayerInfoByGUID = GetPlayerInfoByGUID;

---GetClassColorByGUID
---@param GUID string
---@return ColorMixin
function TRP3_API.utils.color.GetClassColorByGUID(GUID)
	local localizedClass, englishClass, localizedRace, englishRace, sex, name, realm = GetPlayerInfoByGUID(GUID);
	local classColorTable = RAID_CLASS_COLORS[englishClass];
	if classColorTable then
		return CreateColor(classColorTable.r, classColorTable.g, classColorTable.b, 1);
	end
end

---GetCustomColorByGUID
---@param GUID string
---@return ColorMixin
function TRP3_API.utils.color.GetCustomColorByGUID(GUID)
	local localizedClass, englishClass, localizedRace, englishRace, sex, name, realm = GetPlayerInfoByGUID(GUID);

	local unitID = Utils.str.unitInfoToID(name, realm);
	return Utils.color.getUnitCustomColor(unitID)
end
	
---
-- Returns the color for the unit corresponding to the given GUID.
-- @param GUID The GUID to use to retrieve player information
-- @param useCustomColors If we should use custom color or not (usually defined in settings)
-- @param lightenColorUntilItIsReadable If we should increase the color so it is readable on dark background (usually defined in settings)
--
function Utils.color.getUnitColorByGUID(GUID, useCustomColors, lightenColorUntilItIsReadable)
	assert(GUID, "Invalid GUID given to Utils.color.getUnitColorByGUID(GUID)");
	local localizedClass, englishClass, localizedRace, englishRace, sex, name, realm = GetPlayerInfoByGUID(GUID);
	local color;

	if not englishClass then return end

	color = Utils.color.getClassColor(englishClass);

	if useCustomColors then
		local unitID = Utils.str.unitInfoToID(name, realm);
		color = Utils.color.getUnitCustomColor(unitID) or color;

		if lightenColorUntilItIsReadable then
			color:LightenColorUntilItIsReadable();
		end
	end

	return color ;
end

function Utils.color.extractColorFromText(text)
	local r, g, b = 1, 1, 1;
	local rgb = text:match("|c%x%x(%x%x%x%x%x%x)");

	if rgb then
		r, g, b = hexaToFloat(rgb);
	end

	return CreateColor(r, g, b, 1);
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

function Utils.math.round(value, decimals)
	local mult = 10 ^ (decimals or 0)
	return math.floor(value * mult) / mult;
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

local strtrim = strtrim;

-- Convert the given text by his HTML representation
Utils.str.toHTML = function(text, noColor)

	local linkColor = "|cff00ff00";
	if noColor then
		linkColor = "";
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
				return loc("PATTERN_ERROR");
			end
			tinsert(tab, tagText);
		else
			return loc("PATTERN_ERROR");
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
			line = "<P>" .. line .. "</P>";
		end
		line = line:gsub("\n","<br/>");

		line = line:gsub("{img%:(.-)%:(.-)%:(.-)%}",
			"</P><img src=\"%1\" align=\"center\" width=\"%2\" height=\"%3\"/><P>");

		line = line:gsub("%!%[(.-)%]%((.-)%)", function(icon, size)
			if icon:find("\\") then
				local width, height;
				if size:find("%,") then
					width, height = strsplit(",", size);
				else
					width = tonumber(size) or 128;
					height = width;
				end
				return "</P><img src=\"".. icon .. "\" align=\"center\" width=\"".. width .. "\" height=\"" .. height .. "\"/><P>";
			end
			return Utils.str.icon(icon, tonumber(size) or 25);
		end);

		line = line:gsub("%[(.-)%]%((.-)%)",
			"<a href=\"%2\">" .. linkColor .. "[%1]|r</a>");

		line = line:gsub("{link%*(.-)%*(.-)}",
			"<a href=\"%1\">" .. linkColor .. "[%2]|r</a>");

		line = line:gsub("{twitter%*(.-)%*(.-)}",
			"<a href=\"twitter%1\">|cff61AAEE%2|r</a>");

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
		Log.log("Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data), Log.level.WARNING);
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
		Log.log("safeEncodeCompressStructure error:\n" .. tostring(serial), Log.level.WARNING);
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
		local temp = Utils.table.getTempTable();

		for _, callback in pairs(REGISTERED_EVENTS[event]) do
			tinsert(temp, callback);
		end

		-- We use a separate structure as the callback could change REGISTERED_EVENTS[event]
		for _, callback in pairs(temp) do
			callback(...);
		end

		Utils.table.releaseTempTable(temp);
	else
		self:UnregisterEvent(event);
	end
end

function Utils.event.fireEvent(event, ...)
	TRP3_EventDispatcher(TRP3_EventFrame, event, ...)
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
		tinsert(soundHandlers, {channel = channel, id = soundID, handlerID = handlerID, source = source, date = date("%H:%M:%S")});
		if TRP3_SoundsHistoryFrame then
			TRP3_SoundsHistoryFrame.onSoundPlayed();
		end
	end
	return willPlay, handlerID;
end

function Utils.music.stopSound(handlerID)
	StopSound(handlerID);
end

function Utils.music.stopChannel(channel)
	for index, handler in pairs(soundHandlers) do
		if not channel or handler.channel == channel then
			Utils.music.stopSound(handler.handlerID);
		end
	end
end

function Utils.music.stopMusic()
	StopMusic();
	Utils.music.stopChannel("Music");
end

function Utils.music.playMusic(music, source)
	assert(music, "Music can't be nil.")
	Utils.music.stopMusic();
	if type(music) == "number" then
		Log.log("Playing sound: " .. music);
		Utils.music.playSoundID(music, "Music");
	else
		Log.log("Playing music: " .. music);
		PlayMusic("Sound\\Music\\" .. music .. ".mp3");
		tinsert(soundHandlers, {channel = "Music", id = music, handlerID = 0, source = source or Globals.player_id, date = date("%H:%M:%S")});
		if TRP3_SoundsHistoryFrame then
			TRP3_SoundsHistoryFrame.onSoundPlayed();
		end
	end
end

function Utils.music.getTitle(musicURL)
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
		elseif type(textureFrame) == string and _G[textureFrame] then
			_G[textureFrame]:SetTexture(texturePath);
		elseif textureFrame.SetTexture then
			textureFrame:SetTexture(texturePath);
		end
	end
end
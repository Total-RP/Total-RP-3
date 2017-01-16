----------------------------------------------------------------------------------
-- Total RP 3
-- Chat management
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

-- imports
local Globals, Utils = TRP3_API.globals, TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local unitIDToInfo, unitInfoToID = Utils.str.unitIDToInfo, Utils.str.unitInfoToID;
local get = TRP3_API.profile.getData;
local IsUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local getUnitIDCurrentProfile, isIDIgnored = TRP3_API.register.getUnitIDCurrentProfile, TRP3_API.register.isIDIgnored;
local strsub, strlen, format, _G, pairs, tinsert, time, strtrim = strsub, strlen, format, _G, pairs, tinsert, time, strtrim;
local GetPlayerInfoByGUID, RemoveExtraSpaces, GetTime, PlaySound = GetPlayerInfoByGUID, RemoveExtraSpaces, GetTime, PlaySound;
local getConfigValue, registerConfigKey, registerHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;
local ChatFrame_RemoveMessageEventFilter, ChatFrame_AddMessageEventFilter = ChatFrame_RemoveMessageEventFilter, ChatFrame_AddMessageEventFilter;
local ChatEdit_GetActiveWindow, IsAltKeyDown = ChatEdit_GetActiveWindow, IsAltKeyDown;
local oldChatFrameOnEvent;
local handleCharacterMessage, hooking;
local tContains = tContains;
local assert = assert;

TRP3_API.chat = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local POSSIBLE_CHANNELS;

-- Used by other modules like our own Prat or WIM modules to get the list of channels we handle
function TRP3_API.chat.getPossibleChannels()
	return POSSIBLE_CHANNELS;
end;

local CONFIG_NAME_METHOD = "chat_name";
local CONFIG_NAME_COLOR = "chat_color";
local CONFIG_NPC_TALK = "chat_npc_talk";
local CONFIG_NPC_TALK_PREFIX = "chat_npc_talk_p";
local CONFIG_EMOTE = "chat_emote";
local CONFIG_EMOTE_PATTERN = "chat_emote_pattern";
local CONFIG_USAGE = "chat_use_";
local CONFIG_OOC = "chat_ooc";
local CONFIG_OOC_PATTERN = "chat_ooc_pattern";
local CONFIG_OOC_COLOR = "chat_ooc_color";
local CONFIG_YELL_NO_EMOTE = "chat_yell_no_emote";
local CONFIG_INSERT_FULL_RP_NAME = "chat_insert_full_rp_name";
local CONFIG_INCREASE_CONTRAST = "chat_color_contrast";

local function configNoYelledEmote()
	return getConfigValue(CONFIG_YELL_NO_EMOTE);
end

local function configNameMethod()
	return getConfigValue(CONFIG_NAME_METHOD);
end

local function configShowNameCustomColors()
	return getConfigValue(CONFIG_NAME_COLOR);
end

local function configIsChannelUsed(channel)
	return getConfigValue(CONFIG_USAGE .. channel);
end

local function configDoHandleNPCTalk()
	return getConfigValue(CONFIG_NPC_TALK);
end

local function configNPCTalkPrefix()
	return getConfigValue(CONFIG_NPC_TALK_PREFIX);
end

local function configDoEmoteDetection()
	return getConfigValue(CONFIG_EMOTE);
end

local function configEmoteDetectionPattern()
	return getConfigValue(CONFIG_EMOTE_PATTERN);
end

local function configDoOOCDetection()
	return getConfigValue(CONFIG_OOC);
end

local function configOOCDetectionPattern()
	return getConfigValue(CONFIG_OOC_PATTERN);
end

local function configOOCDetectionColor()
	return getConfigValue(CONFIG_OOC_COLOR);
end

local function configInsertFullRPName()
    return getConfigValue(CONFIG_INSERT_FULL_RP_NAME);
end

local function createConfigPage()
	-- Config default value
	registerConfigKey(CONFIG_NAME_METHOD, 3);
	registerConfigKey(CONFIG_NAME_COLOR, true);
	registerConfigKey(CONFIG_INCREASE_CONTRAST, false);
	registerConfigKey(CONFIG_NPC_TALK, true);
	registerConfigKey(CONFIG_NPC_TALK_PREFIX, "|| ");
	registerConfigKey(CONFIG_EMOTE, true);
	registerConfigKey(CONFIG_EMOTE_PATTERN, "(%*.-%*)");
	registerConfigKey(CONFIG_OOC, true);
	registerConfigKey(CONFIG_OOC_PATTERN, "(%(.-%))");
	registerConfigKey(CONFIG_OOC_COLOR, "aaaaaa");
	registerConfigKey(CONFIG_YELL_NO_EMOTE, false);
    registerConfigKey(CONFIG_INSERT_FULL_RP_NAME, true);

	local NAMING_METHOD_TAB = {
		{loc("CO_CHAT_MAIN_NAMING_1"), 1},
		{loc("CO_CHAT_MAIN_NAMING_2"), 2},
		{loc("CO_CHAT_MAIN_NAMING_3"), 3},
		{loc("CO_CHAT_MAIN_NAMING_4"), 4},
	}
	
	local EMOTE_PATTERNS = {
		{"* Emote *", "(%*.-%*)"},
		{"** Emote **", "(%*%*.-%*%*)"},
		{"< Emote >", "(%<.-%>)"},
		{"* Emote * + < Emote >", "([%*%<].-[%*%>])"},
	}
	
	local OOC_PATTERNS = {
		{"( OOC )", "(%(.-%))"},
		{"(( OOC ))", "(%(%(.-%)%))"},
	}

	-- Build configuration page
	local CONFIG_STRUCTURE = {
		id = "main_config_chatframe",
		menuText = loc("CO_CHAT"),
		pageText = loc("CO_CHAT"),
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_CHAT_MAIN"),
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Chat_NamingMethod",
				title = loc("CO_CHAT_MAIN_NAMING"),
				listContent = NAMING_METHOD_TAB,
				configKey = CONFIG_NAME_METHOD,
				listCancel = true,
			},
            {
                inherit = "TRP3_ConfigCheck",
                title = loc("CO_CHAT_INSERT_FULL_RP_NAME"),
                configKey = CONFIG_INSERT_FULL_RP_NAME,
                help = loc("CO_CHAT_INSERT_FULL_RP_NAME_TT")
            },
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_CHAT_MAIN_COLOR"),
				configKey = CONFIG_NAME_COLOR,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = "Increase color contrast",
				configKey = CONFIG_INCREASE_CONTRAST,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_CHAT_MAIN_NPC"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_CHAT_MAIN_NPC_USE"),
				configKey = CONFIG_NPC_TALK,
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc("CO_CHAT_MAIN_NPC_PREFIX"),
				configKey = CONFIG_NPC_TALK_PREFIX,
				help = loc("CO_CHAT_MAIN_NPC_PREFIX_TT")
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_CHAT_MAIN_EMOTE"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_CHAT_MAIN_EMOTE_YELL"),
				help = loc("CO_CHAT_MAIN_EMOTE_YELL_TT"),
				configKey = CONFIG_YELL_NO_EMOTE,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_CHAT_MAIN_EMOTE_USE"),
				configKey = CONFIG_EMOTE,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Chat_EmotePattern",
				title = loc("CO_CHAT_MAIN_EMOTE_PATTERN"),
				listContent = EMOTE_PATTERNS,
				configKey = CONFIG_EMOTE_PATTERN,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_CHAT_MAIN_OOC"),
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_CHAT_MAIN_OOC_USE"),
				configKey = CONFIG_OOC,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationTooltip_Chat_OOCPattern",
				title = loc("CO_CHAT_MAIN_OOC_PATTERN"),
				listContent = OOC_PATTERNS,
				configKey = CONFIG_OOC_PATTERN,
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = loc("CO_CHAT_MAIN_OOC_COLOR"),
				configKey = CONFIG_OOC_COLOR,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc("CO_CHAT_USE"),
			},
		}
	};

	for _, channel in pairs(POSSIBLE_CHANNELS) do
		registerConfigKey(CONFIG_USAGE .. channel, true);
		registerHandler(CONFIG_USAGE .. channel, hooking);
		tinsert(CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = _G[channel],
			configKey = CONFIG_USAGE .. channel,
		});
	end

	TRP3_API.configuration.registerConfigurationPage(CONFIG_STRUCTURE);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getCharacterClassColor(chatInfo, event, text, characterID, language, arg4, arg5, arg6, arg7, arg8, arg9, arg10, messageID, GUID)
	local color;
	if ( chatInfo and chatInfo.colorNameByClass and GUID ) then
		local localizedClass, englishClass = GetPlayerInfoByGUID(GUID);
		if englishClass and RAID_CLASS_COLORS[englishClass] then
			local classColorTable = RAID_CLASS_COLORS[englishClass];
			return ("|cff%.2x%.2x%.2x"):format(classColorTable.r*255, classColorTable.g*255, classColorTable.b*255);
		end
	end
end

local function getCharacterInfoTab(unitID)
	if unitID == Globals.player_id then
		return get("player");
	elseif IsUnitIDKnown(unitID) then
		return getUnitIDCurrentProfile(unitID) or {};
	end
	return {};
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Emote and OOC detection
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function detectEmoteAndOOC(type, message)
	if configDoEmoteDetection() and message:find(configEmoteDetectionPattern()) then
		local chatInfo = ChatTypeInfo["EMOTE"];
		local color = ("|cff%.2x%.2x%.2x"):format(chatInfo.r*255, chatInfo.g*255, chatInfo.b*255);
		message = message:gsub(configEmoteDetectionPattern(), function(content)
			return color .. content .. "|r";
		end);
	end
	if configDoOOCDetection() and message:find(configOOCDetectionPattern()) then
		message = message:gsub(configOOCDetectionPattern(), function(content)
			return "|cff" .. configOOCDetectionColor() .. content .. "|r";
		end);
	end
	return message;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NPC talk detection
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local NPC_TALK_CHANNELS = {
	CHAT_MSG_SAY = 1, CHAT_MSG_EMOTE = 1, CHAT_MSG_PARTY = 1, CHAT_MSG_RAID = 1, CHAT_MSG_PARTY_LEADER = 1, CHAT_MSG_RAID_LEADER = 1
};
local NPC_TALK_PATTERNS;

local stringInColorCode = "|cff%02x%02x%02x%s|r";
local bracketedColoredStringCode = "|cff%02x%02x%02x[%s]|r"

local function handleNPCEmote(message)

	-- Go through all talk types
	for TALK_TYPE, TALK_CHANNEL in pairs(NPC_TALK_PATTERNS) do
		if message:find(TALK_TYPE) then
			local chatInfo = ChatTypeInfo[TALK_CHANNEL];
			local name = message:sub(4, message:find(TALK_TYPE) - 2); -- Isolate the name
			local content = message:sub(name:len() + 5);

			return string.format(bracketedColoredStringCode, chatInfo.r*255, chatInfo.g*255, chatInfo.b*255, name), string.format(stringInColorCode, chatInfo.r*255, chatInfo.g*255, chatInfo.b*255, content);
		end
	end

	-- If none was found, we default to emote
	local chatInfo = ChatTypeInfo["MONSTER_EMOTE"];
	return string.format("|cff%02x%02x%02x%s|r", chatInfo.r*255, chatInfo.g*255, chatInfo.b*255, message:sub(4)), " ";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Chatframe management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- These variables will hold data between the handleCharacterMessage message filter and our custom GetColoredName
-- So we are able to flag messages as needing their player name's to be modified
local npcMessageId, npcMessageName, ownershipNameId;

function handleCharacterMessage(chatFrame, event, ...)

	local message, characterID, language, arg4, arg5, arg6, arg7, arg8, arg9, arg10, messageID, arg12, arg13, arg14, arg15, arg16 = ...;

	-- Detect NPC talk pattern on authorized channels
	if event == "CHAT_MSG_EMOTE" then
		if message:sub(1, 3) == configNPCTalkPrefix() and configDoHandleNPCTalk() then
			npcMessageId = messageID;
			npcMessageName, message = handleNPCEmote(message);

		-- This is one of Saelora's neat modification
		-- If the emote starts with 's (the subject of the sentence might be someone's pet or mount)
		-- the game would insert a space between the player's name and the 's (like "Kristoff 's reindeer eats Olaf's nose.").
		-- We store the message ID in the possessiveMarkBucket table as it will be checked in the function to colore player names.
		-- The 's is removed from the original message, it will be inserted in the name of the player
		--
		-- I actually really like this.
		-- — Ellypse
		elseif message:sub(1, 3) == "'s " then
			ownershipNameId = messageID; -- pass the messageID to the name altering functionality. This uses a separate variable to identify wich method should be used. - Lora
			message = message:sub(4);
		end
	end

	-- No yelled emote ?
	if event == "CHAT_MSG_YELL" and configNoYelledEmote() then
		message = message:gsub("%*.-%*", "");
		message = message:gsub("%<.-%>", "");
	end

	-- Colorize emote and OOC
	message = detectEmoteAndOOC(type, message);

	return false, message, characterID, language, arg4, arg5, arg6, arg7, arg8, arg9, arg10, messageID, arg12, arg13, arg14, arg15, arg16;
end

local function getFullnameUsingChatMethod(info, characterName)
	local nameMethod = configNameMethod();
	if nameMethod ~= 1 then -- TRP3 names
		local characteristics = info.characteristics or {};
		if characteristics.FN then
			characterName = characteristics.FN;
		end

		if nameMethod == 4 and characteristics.TI then
			characterName = characteristics.TI .. " " .. characterName;
		end

		if (nameMethod == 3 or nameMethod == 4) and characteristics.LN then -- With last name
			characterName = characterName .. " " .. characteristics.LN;
		end
	end
	return characterName;
end
TRP3_API.chat.getFullnameUsingChatMethod = getFullnameUsingChatMethod;

local function getColoredName(info)
	local characterColor;
	if configShowNameCustomColors() and info.characteristics and info.characteristics.CH then
		local color = info.characteristics.CH;
		if getConfigValue(CONFIG_INCREASE_CONTRAST) then
			local r, g, b = Utils.color.hexaToFloat(color);
			local ligthenColor = Utils.color.lightenColorUntilItIsReadable({r = r, g = g, b = b});
			color = Utils.color.numberToHexa(ligthenColor.r * 255) .. Utils.color.numberToHexa(ligthenColor.g * 255) .. Utils.color.numberToHexa(ligthenColor.b * 255);
		end
		characterColor = color;
	end
	return characterColor;
end
TRP3_API.chat.getColoredName = getColoredName;

-- I have renamed this function from beta 1 to beta 2 because Saelora commented on its name :P
local defaultGetColoredNameFunction = GetColoredName;

-- This is our custom GetColoredName function that will replace player's names with their full RP names
-- and use their custom colors.
-- (It is stored in Utils as we need it in other modules like Prat or WIM)
-- It must receive a fallback function as first parameter. It is the function it will use if we don't handle name customizations ourselves
function Utils.customGetColoredNameWithCustomFallbackFunction(fallback, event, ...)

	assert(fallback, "Trying to call TRP3_API.utils.customGetColoredNameWithCustomFallbackFunction(fallback, event, ...) without a fallback function!")

	-- Do not change stuff if the is disabled for this channel, use the default function
	if not tContains(POSSIBLE_CHANNELS, event) or not configIsChannelUsed(event) then return fallback(event, ...) end;

	local characterName, characterColor;
	local message, characterID, language, arg4, arg5, arg6, arg7, arg8, arg9, arg10, messageID, arg12, arg13, arg14, arg15, arg16 = ...;
	local character, realm = unitIDToInfo(characterID);
	if not realm then -- Thanks Blizzard to not always send a full character ID
		realm = Globals.player_realm_id;
		if realm == nil then
			-- if realm is nil (i.e. globals haven't been set yet) just run the vanilla version of the code to prevent errors.
			return fallback(event, ...);
		end
	end
	characterID = unitInfoToID(character, realm);
	local info = getCharacterInfoTab(characterID);

	-- Get chat type and configuration
	local type = strsub(event, 10);
	local chatInfo = ChatTypeInfo[type];

	-- Check if this message ID was flagged as containing NPC chat
	-- If it does we use the NPC name that was saved before.
	if npcMessageId == messageID then
		return npcMessageName or UNKNOWN;
	end

	-- WHISPER and WHISPER_INFORM have the same chat info
	if ( strsub(type, 1, 7) == "WHISPER" ) then
		chatInfo = ChatTypeInfo["WHISPER"];
	end

	-- Character name
	if realm == Globals.player_realm_id then
		characterName = character;
	else
		characterName = characterID;
	end

	characterName = getFullnameUsingChatMethod(info, character);

	-- Check if this message was flagged as containing a 's at the beggning.
	-- To avoid having a space between the name of the player and the 's we previously removed the 's
	-- from the message. We now need to insert it after the player's name, without a space.
	if ownershipNameId == messageID then
		characterName = characterName .. "'s";
	end

	if characterName ~= character and characterName ~= characterID then
		characterColor = getColoredName(info);
		-- Then class color
		if not characterColor then
			characterColor = getCharacterClassColor(chatInfo, event, ...);
		else
			characterColor =  "|cff" .. characterColor;
		end
		if characterColor then
			characterName = characterColor .. characterName .. "|r";
		end
		return characterName;
	else
		return fallback(event, ...);
	end
end

-- This is the actual GetColoredName replacement function.
-- It calls our custom GetColoredName function with the default Blizzard function as a fallback.
function Utils.customGetColoredName(...)
	return Utils.customGetColoredNameWithCustomFallbackFunction(defaultGetColoredNameFunction, ...);
end

function hooking()
	for _, channel in pairs(POSSIBLE_CHANNELS) do
		ChatFrame_RemoveMessageEventFilter(channel, handleCharacterMessage);
		if configIsChannelUsed(channel) then
			ChatFrame_AddMessageEventFilter(channel, handleCharacterMessage);
		end
	end

	-- We hard replace the game GetColoredName function by ours so we can display our own custom colors
	-- And the full RP name of the players
	GetColoredName = Utils.customGetColoredName;

	-- Hook the ChatEdit_InsertLink() function that is called when the user SHIFT-Click a player name
	-- in the chat frame to insert it into a text field.
	-- We can replace the name inserted by the complete RP name of the player if we have it.
	hooksecurefunc("ChatEdit_InsertLink", function(name)

		-- Do not modify the name inserted if the option is not enabled or if the ALT key is down.
		if not configInsertFullRPName() or IsAltKeyDown() then return end;

		local activeChatFrame = ChatEdit_GetActiveWindow();
		if activeChatFrame and activeChatFrame.chatFrame and activeChatFrame.chatFrame.editBox then
			local editBox = activeChatFrame.chatFrame.editBox;
			local currentText = editBox:GetText();
			local currentCursorPosition = editBox:GetCursorPosition();

			-- Save the text that is before and after the name inserted
			local textBefore = currentText:sub(1, currentCursorPosition - name:len() - 1);
			local textAfter = currentText:sub(currentCursorPosition+1 );

			-- Retreive the info for the character and the naming method to use
			local info = getCharacterInfoTab(name);
			local nameMethod = configNameMethod();

			if info and info.characteristics and nameMethod ~= 1 then -- TRP3 names
			local characteristics = info.characteristics;
			-- Replace the name by the RP name
			if characteristics.FN then
				name = characteristics.FN;
			end

			-- If the naming method is to use titles, add the short title before the name
			if nameMethod == 4 and characteristics.TI then
				name = characteristics.TI .. " " .. name;
			end

			-- If the naming method is to use lastnames, add the lastname behind the name
			if (nameMethod == 3 or nameMethod == 4) and characteristics.LN then -- With last name
			name = name .. " " .. characteristics.LN;
			end

			-- Replace the text of the edit box
			editBox:SetText(textBefore .. name .. textAfter);
			-- Move the cursor to the end of the insertion
			editBox:SetCursorPosition(textBefore:len() + name:len());
			end
		end
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStart()

	POSSIBLE_CHANNELS = {
		"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
		"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM"
	};


	NPC_TALK_PATTERNS = {
		[loc("NPC_TALK_SAY_PATTERN")] = "MONSTER_SAY",
		[loc("NPC_TALK_YELL_PATTERN")] = "MONSTER_YELL",
		[loc("NPC_TALK_WHISPER_PATTERN")] = "MONSTER_WHISPER",
	};
	createConfigPage();
	hooking();
end

local MODULE_STRUCTURE = {
	["name"] = "Chat frames",
	["description"] = "Global enhancement for chat frames. Use roleplay information, detect emotes and OOC sentences and use colors.",
	["version"] = 1.000,
	["id"] = "trp3_chatframes",
	["onStart"] = onStart,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
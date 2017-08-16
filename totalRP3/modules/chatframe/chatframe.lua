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

-- Removed NPC talk prefix option and changed prefix to a hardcoded one (Paul Corlay) [RIP NPC talk prefix option 2014 - 2017]

-- imports
local Globals, Utils = TRP3_API.globals, TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local unitIDToInfo, unitInfoToID = Utils.str.unitIDToInfo, Utils.str.unitInfoToID;
local get = TRP3_API.profile.getData;
local IsUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local getUnitIDCurrentProfile, isIDIgnored = TRP3_API.register.getUnitIDCurrentProfile, TRP3_API.register.isIDIgnored;
local strsub, strlen, format, _G, pairs, tinsert, time, strtrim = strsub, strlen, format, _G, pairs, tinsert, time, strtrim;
local getConfigValue, registerConfigKey, registerHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;
local ChatFrame_RemoveMessageEventFilter, ChatFrame_AddMessageEventFilter = ChatFrame_RemoveMessageEventFilter, ChatFrame_AddMessageEventFilter;
local ChatEdit_GetActiveWindow, IsAltKeyDown = ChatEdit_GetActiveWindow, IsAltKeyDown;
local handleCharacterMessage, hooking;
local tContains = tContains;
local assert = assert;
local getUnitColorByGUID = Utils.color.getUnitColorByGUID;
local getChatColorForChannel = Utils.color.getChatColorForChannel;
local getColorFromHexadecimalCode = Utils.color.getColorFromHexadecimalCode;
local select = select;

TRP3_API.chat = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local POSSIBLE_CHANNELS;

-- Used by other modules like our own Prat or WIM modules to check if a channel is handled by Total RP 3
local function isChannelHandled(channel)
	return tContains(POSSIBLE_CHANNELS, channel);
end
TRP3_API.chat.isChannelHandled = isChannelHandled;

local CONFIG_NAME_METHOD = "chat_name";
local CONFIG_REMOVE_REALM = "remove_realm";
local CONFIG_NAME_COLOR = "chat_color";
local CONFIG_NPC_TALK = "chat_npc_talk";
local CONFIG_EMOTE = "chat_emote";
local CONFIG_EMOTE_PATTERN = "chat_emote_pattern";
local CONFIG_USAGE = "chat_use_";
local CONFIG_OOC = "chat_ooc";
local CONFIG_OOC_PATTERN = "chat_ooc_pattern";
local CONFIG_OOC_COLOR = "chat_ooc_color";
local CONFIG_YELL_NO_EMOTE = "chat_yell_no_emote";
local CONFIG_INSERT_FULL_RP_NAME = "chat_insert_full_rp_name";
local CONFIG_INCREASE_CONTRAST = "chat_color_contrast";
local CONFIG_SHOW_ICON = "chat_show_icon";

local function configNoYelledEmote()
	return getConfigValue(CONFIG_YELL_NO_EMOTE);
end

local function configNameMethod()
	return getConfigValue(CONFIG_NAME_METHOD);
end

local function configShowNameCustomColors()
	return getConfigValue(CONFIG_NAME_COLOR);
end
TRP3_API.chat.configShowNameCustomColors = configShowNameCustomColors;

local function configIncreaseNameColorContrast()
	return getConfigValue(CONFIG_INCREASE_CONTRAST);
end
TRP3_API.chat.configIncreaseNameColorContrast = configIncreaseNameColorContrast;

local function configIsChannelUsed(channel)
	return getConfigValue(CONFIG_USAGE .. channel);
end
TRP3_API.chat.configIsChannelUsed = configIsChannelUsed;

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
	return getColorFromHexadecimalCode(getConfigValue(CONFIG_OOC_COLOR));
end

local function configInsertFullRPName()
    return getConfigValue(CONFIG_INSERT_FULL_RP_NAME);
end

local function createConfigPage()
	-- Config default value
	registerConfigKey(CONFIG_NAME_METHOD, 3);
	registerConfigKey(CONFIG_REMOVE_REALM, true);
	registerConfigKey(CONFIG_NAME_COLOR, true);
	registerConfigKey(CONFIG_INCREASE_CONTRAST, false);
	registerConfigKey(CONFIG_NPC_TALK, true);
	registerConfigKey(CONFIG_EMOTE, true);
	registerConfigKey(CONFIG_EMOTE_PATTERN, "(%*.-%*)");
	registerConfigKey(CONFIG_OOC, true);
	registerConfigKey(CONFIG_OOC_PATTERN, "(%(.-%))");
	registerConfigKey(CONFIG_OOC_COLOR, "aaaaaa");
	registerConfigKey(CONFIG_YELL_NO_EMOTE, false);
    registerConfigKey(CONFIG_INSERT_FULL_RP_NAME, true);
    registerConfigKey(CONFIG_SHOW_ICON, false);

	local NAMING_METHOD_TAB = {
		{loc("CO_CHAT_MAIN_NAMING_1"), TRP3_API.register.NAMING_METHODS.DONT_CHANGE_NAME },
		{loc("CO_CHAT_MAIN_NAMING_2"), TRP3_API.register.NAMING_METHODS.FIRST_NAME },
		{loc("CO_CHAT_MAIN_NAMING_3"), TRP3_API.register.NAMING_METHODS.FIRST_NAME_AND_LAST_NAME },
		{loc("CO_CHAT_MAIN_NAMING_4"), TRP3_API.register.NAMING_METHODS.SHORT_TITLE_AND_FIRST_NAME_AND_LAST_NAME },
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
		{"(OOC) + (( OOC )) ", "(%(+[^%)]+%)+)"},
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
                title = loc("CO_CHAT_REMOVE_REALM"),
                configKey = CONFIG_REMOVE_REALM
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
				title = loc("CO_CHAT_INCREASE_CONTRAST"),
				configKey = CONFIG_INCREASE_CONTRAST,
				dependentOnOptions = {CONFIG_NAME_COLOR},
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc("CO_CHAT_USE_ICONS"),
				configKey = CONFIG_SHOW_ICON,
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
				dependentOnOptions = {CONFIG_EMOTE},
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
				dependentOnOptions = {CONFIG_OOC},
			},
			{
				inherit = "TRP3_ConfigColorPicker",
				title = loc("CO_CHAT_MAIN_OOC_COLOR"),
				configKey = CONFIG_OOC_COLOR,
				dependentOnOptions = {CONFIG_OOC},
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

local function getCharacterInfoTab(unitID)
	if unitID == Globals.player_id then
		return get("player");
	elseif IsUnitIDKnown(unitID) then
		return getUnitIDCurrentProfile(unitID) or {};
	end
	return {};
end
TRP3_API.utils.getCharacterInfoTab = getCharacterInfoTab;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Emote and OOC detection
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function detectEmoteAndOOC(message)
	
	if configDoEmoteDetection() and message:find(configEmoteDetectionPattern()) then
		local chatColor = getChatColorForChannel("EMOTE");
		message = message:gsub(configEmoteDetectionPattern(), function(content)
			return chatColor:WrapTextInColorCode(content);
		end);
	end
	
	if configDoOOCDetection() and message:find(configOOCDetectionPattern()) then
		local OOCColor = configOOCDetectionColor();
		message = message:gsub(configOOCDetectionPattern(), function(content)
			return OOCColor:WrapTextInColorCode(content);
		end);
	end
	
	return message;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NPC talk detection
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local NPC_TALK_PATTERNS;

local function handleNPCEmote(message)

	-- Go through all talk types
	for talkType, talkChannel in pairs(NPC_TALK_PATTERNS) do
		if message:find(talkType) then
			local chatColor = getChatColorForChannel(talkChannel);
			local name = message:sub(4, message:find(talkType) - 2); -- Isolate the name
			local content = message:sub(name:len() + 5);

			return chatColor:WrapTextInColorCode(name), chatColor:WrapTextInColorCode(content);
		end
	end

	-- If none was found, we default to emote
	local chatColor = getChatColorForChannel("MONSTER_EMOTE");
	return chatColor:WrapTextInColorCode(message:sub(4)), " ";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Chatframe management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- These variables will hold data between the handleCharacterMessage message filter and our custom GetColoredName
-- So we are able to flag messages as needing their player name's to be modified
local npcMessageId, npcMessageName, ownershipNameId, emoteStartingWithACommaID;

function TRP3_API.chat.getNPCMessageID()
	return npcMessageId;
end

function TRP3_API.chat.getNPCMessageName()
	return npcMessageName;
end

function TRP3_API.chat.getOwnershipNameID()
	return ownershipNameId;
end

function handleCharacterMessage(_, event, message, ...)
	
	local messageID = select(10, ...);

	-- Detect NPC talk pattern on authorized channels
	if event == "CHAT_MSG_EMOTE" then
		if message:sub(1, 3) == "|| " and configDoHandleNPCTalk() then
			npcMessageId = messageID;
			npcMessageName, message = handleNPCEmote(message);

		-- This is one of Saelora's neat modification
		-- If the emote starts with 's (the subject of the sentence might be someone's pet or mount)
		-- the game would insert a space between the player's name and the 's (like "Kristoff 's reindeer eats Olaf's nose.").
		-- We store the message ID in the ownershipNameId variable that will be checked in the function to colore player names.
		-- The 's is removed from the original message, it will be inserted in the name of the player
		--
		-- I actually really like this.
		-- — Ellypse
		elseif message:sub(1, 3) == "'s " then
			ownershipNameId = messageID; -- pass the messageID to the name altering functionality. This uses a separate variable to identify wich method should be used. - Lora
			message = message:sub(4);
		elseif message:sub(1, 2) == ", " then -- Added support for , at the start of an emote
			emoteStartingWithACommaID = messageID;
			message = message:sub(3);
		end
	end

	-- No yelled emote ?
	if event == "CHAT_MSG_YELL" and configNoYelledEmote() then
		message = message:gsub("%*.-%*", "");
		message = message:gsub("%<.-%>", "");
	end

	-- Colorize emote and OOC
	message = detectEmoteAndOOC(message);

	return false, message, ...;
end

local function getFullnameUsingChatMethod(profile, name)
	return TRP3_API.register.getNameFromProfileUsingNamingMethod(profile, configNameMethod(), name)
end
TRP3_API.chat.getFullnameUsingChatMethod = getFullnameUsingChatMethod;

local function getFullnameForUnitUsingChatMethod(unitID, name)
	local info = getCharacterInfoTab(unitID);
	return getFullnameUsingChatMethod(info, name);
end
TRP3_API.chat.getFullnameForUnitUsingChatMethod = getFullnameForUnitUsingChatMethod;

local function getChatTypeForEvent(event, channelNumber)
	local chatType = strsub(event, 10);
	if ( strsub(chatType, 1, 7) == "WHISPER" ) then
		chatType = "WHISPER";
	end
	if ( strsub(chatType, 1, 7) == "CHANNEL" ) then
		chatType = "CHANNEL".. channelNumber;
	end
	return chatType
end

--- Check if class color is enabled for names for a specified chat type
---	@param chatType string
---	@return boolean
local function classColorNameIsEnableOnChatType(chatType)
	local info = ChatTypeInfo[chatType];
	return info and info.colorNameByClass;
end

-- I have renamed this function from beta 1 to beta 2 because Saelora commented on its name :P
local defaultGetColoredNameFunction = GetColoredName;

local GetClassColorByGUID = TRP3_API.utils.color.GetClassColorByGUID;
local GetCustomColorByGUID = TRP3_API.utils.color.GetCustomColorByGUID;

-- This is our custom GetColoredName function that will replace player's names with their full RP names
-- and use their custom colors.
-- (It is stored in Utils as we need it in other modules like Prat or WIM)
-- It must receive a fallback function as first parameter. It is the function it will use if we don't handle name customizations ourselves
function Utils.customGetColoredNameWithCustomFallbackFunction(fallback, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, channelNumber, arg9, arg10, arg11, arg12)

	assert(fallback, "Trying to call TRP3_API.utils.customGetColoredNameWithCustomFallbackFunction(fallback, event, ...) without a fallback function!")

	local GUID = arg12;
	local unitID = arg2;
	local messageID = arg11;

	-- Do not change stuff if the customizations are disabled for this channel or the GUID is invalid (WIM…), use the default function
	if not isChannelHandled(event) or not configIsChannelUsed(event) or not GUID or not Utils.guid.isAPlayerGUID(GUID) then
		return fallback(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, channelNumber, arg9, arg10, arg11, arg12)
	end;

	local characterName = unitID;
	--@type ColorMixin
	local characterColor;

	-- We don't have a unit ID for this message (WTF? Some other add-on must be doing some weird shit again…)
	-- Bail out, let the fallback function handle that shit.
	if not unitID then return fallback(event, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, channelNumber, arg9, arg10, arg11, arg12) end;

	-- Check if this message ID was flagged as containing NPC chat
	-- If it does we use the NPC name that was saved before.
	if npcMessageId == messageID then
		return npcMessageName or UNKNOWN;
	end

	-- Extract the character name and realm from the unit ID
	local character, realm = unitIDToInfo(unitID);
	if not realm then
		-- if realm is nil (i.e. globals haven't been set yet) just run the vanilla version of the code to prevent errors.
		return fallback(event, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, channelNumber, arg9, arg10, arg11, arg12);
	end
	-- Make sure we have a unitID formatted as "Player-Realm"
	unitID = unitInfoToID(character, realm);

	-- Character name is without the server name is they are from the same realm or if the option to remove realm info is enabled
	if realm == Globals.player_realm_id or getConfigValue(CONFIG_REMOVE_REALM) then
		characterName = character;
	end

	-- Retrieve the character full RP name
	characterName = getFullnameForUnitUsingChatMethod(unitID, characterName);

	if classColorNameIsEnableOnChatType(getChatTypeForEvent(event, channelNumber)) then
		characterColor = GetClassColorByGUID(GUID);
	end

	if configShowNameCustomColors() then
		local customColor = GetCustomColorByGUID(GUID);

		if customColor then
			if configIncreaseNameColorContrast() then
				customColor:LightenColorUntilItIsReadable();
			end

			characterColor = customColor;
		end
	end

	-- If we did get a color wrap the name inside the color code
	if characterColor then
		-- And wrap the name inside the color's code
		characterName = characterColor:WrapTextInColorCode(characterName);
	end

	if getConfigValue(CONFIG_SHOW_ICON) then
		local info = getCharacterInfoTab(unitID);
		if info and info.characteristics and info.characteristics.IC then
			characterName = Utils.str.icon(info.characteristics.IC, 15) .. " " .. characterName;
		end
	end

	-- Check if this message was flagged as containing a 's at the beggning.
	-- To avoid having a space between the name of the player and the 's we previously removed the 's
	-- from the message. We now need to insert it after the player's name, without a space.
	if ownershipNameId == messageID then
		characterName = characterName .. "'s";
	end
	-- Support for emotes starting with a ,
	-- We remove the space so the comma is placed right after the name
	if emoteStartingWithACommaID == messageID then
		characterName = characterName .. ",";
	end

	return characterName;
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
	hooksecurefunc("ChatEdit_InsertLink", function(unitID)

		-- If we didn't get a name at all then we have nothing to do here
		if not unitID then return end;

		-- Do not modify the name inserted if the option is not enabled or if the ALT key is down.
		if not configInsertFullRPName() or IsAltKeyDown() then return end;

		-- Do not modify the name if we don't know that character
		if not (IsUnitIDKnown(unitID) or unitID == Globals.player_id) then return end;

		local activeChatFrame = ChatEdit_GetActiveWindow();

		if activeChatFrame and activeChatFrame.chatFrame and activeChatFrame.chatFrame.editBox then
			local editBox = activeChatFrame.chatFrame.editBox;
			local currentText = editBox:GetText();
			local currentCursorPosition = editBox:GetCursorPosition();

			-- Save the text that is before and after the name inserted
			local textBefore = currentText:sub(1, currentCursorPosition - unitID:len() - 1);
			local textAfter = currentText:sub(currentCursorPosition+1 );

			local name = getFullnameForUnitUsingChatMethod(unitID, unitID);

			-- Replace the text of the edit box
			editBox:SetText(textBefore .. name .. textAfter);
			-- Move the cursor to the end of the insertion
			editBox:SetCursorPosition(textBefore:len() + name:len());

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
	["version"] = 1.100,
	["id"] = "trp3_chatframes",
	["onStart"] = onStart,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
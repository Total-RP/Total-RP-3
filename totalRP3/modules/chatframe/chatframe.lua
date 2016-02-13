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
local oldChatFrameOnEvent;
local handleCharacterMessage, hooking;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Config
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local POSSIBLE_CHANNELS

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

local function createConfigPage(useWIM)
	-- Config default value
	registerConfigKey(CONFIG_NAME_METHOD, 3);
	registerConfigKey(CONFIG_NAME_COLOR, true);
	registerConfigKey(CONFIG_NPC_TALK, true);
	registerConfigKey(CONFIG_NPC_TALK_PREFIX, "|| ");
	registerConfigKey(CONFIG_EMOTE, true);
	registerConfigKey(CONFIG_EMOTE_PATTERN, "(%*.-%*)");
	registerConfigKey(CONFIG_OOC, true);
	registerConfigKey(CONFIG_OOC_PATTERN, "(%(.-%))");
	registerConfigKey(CONFIG_OOC_COLOR, "aaaaaa");
	registerConfigKey(CONFIG_YELL_NO_EMOTE, false);registerConfigKey(CONFIG_YELL_NO_EMOTE, false);

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
				title = loc("CO_CHAT_MAIN_COLOR"),
				configKey = CONFIG_NAME_COLOR,
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
	if useWIM then
		tinsert(CONFIG_STRUCTURE.elements, {
			inherit = "TRP3_ConfigNote",
			help = loc("CO_WIM_TT"),
			title = loc("CO_WIM"),
		});
	end

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

local function handleNPCTalk(chatFrame, message, characterID, messageID)
	local playerLink = "|Hplayer:".. characterID .. ":" .. messageID .. "|h";
	for TALK_TYPE, TALK_CHANNEL in pairs(NPC_TALK_PATTERNS) do
		if message:find(TALK_TYPE) then
			local chatInfo = ChatTypeInfo[TALK_CHANNEL];
			local name = message:sub(4, message:find(TALK_TYPE) - 2); -- Isolate the name
			local content = message:sub(name:len() + 4);
			playerLink = playerLink .. name;
			chatFrame:AddMessage("|cffff9900" .. playerLink .. "|h|r" .. content, chatInfo.r, chatInfo.g, chatInfo.b, chatInfo.id);
			return;
		end
	end
	local chatInfo = ChatTypeInfo["MONSTER_EMOTE"];
	chatFrame:AddMessage(playerLink .. message:sub(4) .. "|h", chatInfo.r, chatInfo.g, chatInfo.b, chatInfo.id);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Chatframe management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Ideas:
-- Ignored to another chatframe (config)
-- Limit name length (config)

function handleCharacterMessage(chatFrame, event, ...)
	local characterName, characterColor;
	local message, characterID, language, arg4, arg5, arg6, arg7, arg8, arg9, arg10, messageID, arg12, arg13, arg14, arg15, arg16 = ...;
	local languageHeader = "";
	local character, realm = unitIDToInfo(characterID);
	if not realm then -- Thanks Blizzard to not always send a full character ID
		realm = Globals.player_realm_id;
		characterID = unitInfoToID(character, realm);
	end
	local info = getCharacterInfoTab(characterID);
	
	-- Get chat type and configuration
	local type = strsub(event, 10);
	local chatInfo = ChatTypeInfo[type];
	
	-- Detect NPC talk pattern on authorized channels
	if message:sub(1, 3) == configNPCTalkPrefix() and configDoHandleNPCTalk() and NPC_TALK_CHANNELS[event] then
		handleNPCTalk(chatFrame, message, characterID, messageID);
		return true;
	end

	-- WHISPER and WHISPER_INFORM have the same chat info
	if ( strsub(type, 1, 7) == "WHISPER" ) then
		chatInfo = ChatTypeInfo["WHISPER"];
	end

	-- WHISPER respond
	if type == "WHISPER" then
		ChatEdit_SetLastTellTarget(characterID, type);
		if ( chatFrame.tellTimer and (GetTime() > chatFrame.tellTimer) ) then
			PlaySound("TellMessage");
		end
		chatFrame.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
	end

	-- Character name
	if realm == Globals.player_realm_id then
		characterName = character;
	else
		characterName = characterID;
	end

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

	-- Custom character name color first
	if configShowNameCustomColors() and info.characteristics and info.characteristics.CH then
		characterColor = "|cff" .. info.characteristics.CH;
	end
	-- Then class color
	if not characterColor then
		characterColor = getCharacterClassColor(chatInfo, event, ...);
	end
	if characterColor then
		characterName = characterColor .. characterName .. "|r";
	end

	-- Language
	if ( (strlen(language) > 0) and (language ~= chatFrame.defaultLanguage) ) then
		languageHeader = "[" .. language .. "] ";
	end

	-- Show
	message = RemoveExtraSpaces(message);
	
	-- No yelled emote ?
	if event == "CHAT_MSG_YELL" and configNoYelledEmote() then
		message = message:gsub("%*.-%*", "");
		message = message:gsub("%<.-%>", "");
	end
	
	-- Colorize emote and OOC
	message = detectEmoteAndOOC(type, message);
	
	-- Is there still something to show ?
	if strtrim(message):len() == 0 then
		return true;
	end
	
	local playerLink = "|Hplayer:".. characterID .. ":" .. messageID .. "|h";
	local body;
	if type == "EMOTE" then
		body = format(_G["CHAT_"..type.."_GET"], playerLink .. characterName .. "|h") .. message;
	elseif type == "TEXT_EMOTE" then
		body = message;
		if characterID ~= Globals.player_id and body:sub(1, character:len()) == character then
			body = body:gsub("^([^%s]+)", playerLink .. characterName .. "|h");
		end
	else
		body = format(_G["CHAT_"..type.."_GET"], playerLink .. "[" .. characterName .. "]" .. "|h")  .. languageHeader .. message;
	end

	--Add Timestamps
	if ( CHAT_TIMESTAMP_FORMAT ) then
		body = BetterDate(CHAT_TIMESTAMP_FORMAT, time()) .. body;
	end

	chatFrame:AddMessage(body, chatInfo.r, chatInfo.g, chatInfo.b, chatInfo.id, false);

	return true;
end

function hooking()
	for _, channel in pairs(POSSIBLE_CHANNELS) do
		ChatFrame_RemoveMessageEventFilter(channel, handleCharacterMessage);
		if configIsChannelUsed(channel) then
			ChatFrame_AddMessageEventFilter(channel, handleCharacterMessage);
		end
	end
end

hooksecurefunc("ChatEdit_InsertLink", function(name)
	local activeChatFrame = ChatEdit_GetActiveWindow()
	if activeChatFrame and activeChatFrame.chatFrame and activeChatFrame.chatFrame.editBox then
		local editBox = activeChatFrame.chatFrame.editBox;
		local currentText = editBox:GetText();
		local currentCursorPosition = editBox:GetCursorPosition();

		local textBefore = currentText:sub(1, currentCursorPosition - name:len() - 1);
		local textAfter = currentText:sub(currentCursorPosition+1 );

		local info = getCharacterInfoTab(name);
		local nameMethod = configNameMethod();
		if nameMethod ~= 1 then -- TRP3 names
			local characteristics = info.characteristics or {};
			if characteristics.FN then
				name = characteristics.FN;
			end

			if nameMethod == 4 and characteristics.TI then
				name = characteristics.TI .. " " .. name;
			end

			if (nameMethod == 3 or nameMethod == 4) and characteristics.LN then -- With last name
				name = name .. " " .. characteristics.LN;
			end
		end

		editBox:SetText(textBefore .. name .. textAfter);
		editBox:SetCursorPosition(textBefore:len() + name:len());

	end
end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStart()
	local useWIM = WIM ~= nil;

	if useWIM then
		POSSIBLE_CHANNELS = {
			"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
			"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
			"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER"
		};
	else
		POSSIBLE_CHANNELS = {
			"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE",
			"CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER",
			"CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM"
		};
	end


	NPC_TALK_PATTERNS = {
		[loc("NPC_TALK_SAY_PATTERN")] = "MONSTER_SAY",
		[loc("NPC_TALK_YELL_PATTERN")] = "MONSTER_YELL",
		[loc("NPC_TALK_WHISPER_PATTERN")] = "MONSTER_WHISPER",
	};
	createConfigPage(useWIM);
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
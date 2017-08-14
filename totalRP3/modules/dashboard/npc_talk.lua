----------------------------------------------------------------------------------
-- Total RP 3
-- Dashboard
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--	Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
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
---------------------------------------------------------------------------------

-- Changed NPC talk prefix to a hardcoded one following option removal (Paul Corlay)

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local strconcat = strconcat;
	local loc = TRP3_API.locale.getText;
	local getConfigValue = TRP3_API.configuration.getValue;
	local displayMessage = TRP3_API.utils.message.displayMessage;
	local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
	local setupMovableFrame = TRP3_API.ui.frame.setupMove;
	local setupListBox = TRP3_API.ui.listbox.setupListBox;
	local SendChatMessage = SendChatMessage;
	local strtrim, pairs, tinsert = strtrim, pairs, tinsert;
	local ChatTypeInfo = ChatTypeInfo;
	local messageTypes = TRP3_API.utils.message.type;
	local CreateColor = CreateColor;
	local colorTool = CreateColor();
	local strlen = strlen;

	local frame = TRP3_NPCTalk;
	---@type Button
	local SendButton = frame.send;

	local CHANNEL_TYPES = {
		SAY = "MONSTER_SAY",
		EMOTE = "MONSTER_EMOTE",
		YELL = "MONSTER_YELL",
		WHISPER = "MONSTER_WHISPER"
	}

	local CHANNEL_TYPES_TO_PATTERNS = {
		[CHANNEL_TYPES.SAY] = loc("NPC_TALK_SAY_PATTERN"),
		[CHANNEL_TYPES.YELL] = loc("NPC_TALK_YELL_PATTERN"),
		[CHANNEL_TYPES.WHISPER] = loc("NPC_TALK_WHISPER_PATTERN"),
	}

	--- Returns the channel action string (says:, yells:, etc.) corresponding to the given CHANNEL_TYPE
	---@param channelType string
	---@return string
	local function getChannelActionString(channelType)
		local channelActionString = ""; -- Unknown types will be ignored (shown as simple emotes)

		if CHANNEL_TYPES_TO_PATTERNS[channelType] then -- Use the action string if it exists
			channelActionString = CHANNEL_TYPES_TO_PATTERNS[channelType] .. " ";
		end

		return channelActionString;
	end

	--- Build the full message using the given NPC name, channel type and message
	--- @param NPCName string
	--- @param channel string
	--- @param message string
	--- @return string
	local function constructMessage(NPCName, channel, message)
		return strconcat("|| ", NPCName or "", " ", getChannelActionString(channel), message or "");
	end

	local function sendNPCTalk()

		local NPCName = strtrim(frame.name:GetText());
		local channel = frame.channelDropdown:GetSelectedValue();
		local message = frame.messageText.scroll.text:GetText();

		-- Send a chat message via the EMOTE channel
		SendChatMessage(constructMessage(NPCName, channel, message), "EMOTE");
		-- Empty the message field (we leave the NPC name field as is in case the user wants to send multiple messages with the same NPC)
		frame.messageText.scroll.text:SetText("");

	end

	local MAX_CHARACTERS_PER_MESSAGES = 254;
	local WARNING_NUMBER_OF_CHARACTERS = 239;
	local NORMAL_COLOR = CreateColor(1.0000, 1.0000, 1.0000, 1.0000);
	local WARNING_COLOR = CreateColor(1.0000, 0.4902, 0.0392, 1.0000);
	local ERROR_COLOR = CreateColor(0.7686, 0.1216, 0.2314, 1.0000);

	local function checkCharactersLimit()

		local NPCName = strtrim(frame.name:GetText());
		local channel = frame.channelDropdown:GetSelectedValue();
		local message = frame.messageText.scroll.text:GetText();

		local fullMessage = constructMessage(NPCName, channel, message)
		local numberOfCharactersInMessage = strlen(fullMessage);

		-- Always re-enabled the button, we will then check if we need to disable it
		SendButton:Enable();
		---@type ColorMixin
		local color = NORMAL_COLOR;
		if numberOfCharactersInMessage >= WARNING_NUMBER_OF_CHARACTERS then
			color = WARNING_COLOR;
		end
		if numberOfCharactersInMessage > MAX_CHARACTERS_PER_MESSAGES then
			color = ERROR_COLOR;
			-- Too many characters, disable send butto
			SendButton:Disable();
		end

		-- Always disable send button if the message text is empty
		if strlen(message) == 0 then
			SendButton:Disable();
		end

		frame.charactersCounter:SetTextColor(color:GetRGBA())
		frame.charactersCounter:SetText(strconcat(MAX_CHARACTERS_PER_MESSAGES - numberOfCharactersInMessage));
	end

	local function buildChannelDropdown()
		local channelTypes = {};

		for channelLabel, channelName in pairs(CHANNEL_TYPES) do
			local chatInfo = ChatTypeInfo[channelName];
			colorTool:SetRGB(chatInfo.r, chatInfo.g, chatInfo.b)
			tinsert(channelTypes, {"|cfff2bf03Channel:|r " .. colorTool:WrapTextInColorCode(_G[channelLabel]), channelName});
		end

		-- Set the dropdown for the channels
		-- The checkCharactersLimit() function will be called when a new channel is selected
		-- as we switching channels changes the string use for the channel (says:, etc.) and so the message length too
		setupListBox(frame.channelDropdown, channelTypes, checkCharactersLimit, nil, 120, false);

		-- Select the SAY channel by default
		frame.channelDropdown:SetSelectedValue(CHANNEL_TYPES.SAY);
	end

	---
	-- Display the frame and do everything that needs to be done at show time
	local function showNPCTalkFrame()
		-- We always rebuild the dropdown on show as some of the colors can change during the session
		buildChannelDropdown();
		frame:Show();
	end
	TRP3_API.r.showNPCTalkFrame = showNPCTalkFrame;

	SendButton:SetScript("OnClick", sendNPCTalk);
	frame.messageText.scroll.text:SetScript("OnEnterPressed", sendNPCTalk);
	frame.title:SetText(loc("NPC_TALK_TITLE"));
	frame.name.title:SetText(loc("NPC_TALK_NAME"));
	frame.messageLabel:SetText(loc("NPC_TALK_MESSAGE"));
	frame.send:SetText(loc("NPC_TALK_SEND"));

	-- Add hooks to check for the length of the message and make sure we don't try to send a message to big
	frame.messageText.scroll.text:HookScript("OnTextChanged", checkCharactersLimit);
	frame.messageText.scroll.text:HookScript("OnEditFocusGained", checkCharactersLimit);
	frame.name:HookScript("OnTextChanged", checkCharactersLimit);
	frame.name:HookScript("OnEditFocusGained", checkCharactersLimit);

	setTooltipForSameFrame(frame.name.help, "RIGHT", 0, 5, loc("NPC_TALK_NAME"), loc("NPC_TALK_NAME_TT"));

	setupMovableFrame(frame);


	if TRP3_API.toolbar then

		-- Create a button for the toolbar to show/hide the NPC Talk frame
		TRP3_API.toolbar.toolbarAddButton({
			id = "bb_trp3_npctalk",
			icon = "Ability_Warrior_CommandingShout",
			configText = loc("NPC_TALK_TITLE"),
			tooltip = loc("NPC_TALK_TITLE"),
			tooltipSub = loc("NPC_TALK_BUTTON_TT"),
			onClick = function(Uibutton, buttonStructure, button)
				if frame:IsShown() then
					frame:Hide();
				else
					showNPCTalkFrame();
				end
			end,
		});
	end

	-- We also register a slash command, so people who disable the toolbar button
	-- or the toolbar module entirely can still access the feature
	TRP3_API.slash.registerCommand({
		id = "npc_speeches",
		helpLine = " " .. loc("NPC_TALK_COMMAND_HELP"),
		handler = showNPCTalkFrame
	});

end);
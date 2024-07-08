-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type
local _, TRP3_API = ...;

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()

	local loc = TRP3_API.loc;
	local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
	local setupMovableFrame = TRP3_API.ui.frame.setupMove;
	local setupListBox = TRP3_API.ui.listbox.setupListBox;

	local frame = TRP3_NPCTalkFrame;
	---@type Button
	local SendButton = frame.Send;

	local CHANNEL_TYPES = {
		SAY = "MONSTER_SAY",
		EMOTE = "MONSTER_EMOTE",
		YELL = "MONSTER_YELL",
		WHISPER = "MONSTER_WHISPER"
	}

	local CHANNEL_TYPES_TO_PATTERNS = {
		[CHANNEL_TYPES.SAY] = loc.NPC_TALK_SAY_PATTERN,
		[CHANNEL_TYPES.YELL] = loc.NPC_TALK_YELL_PATTERN,
		[CHANNEL_TYPES.WHISPER] = loc.NPC_TALK_WHISPER_PATTERN,
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
		return strconcat(TRP3_API.chat.configNPCTalkPrefix(), NPCName or "", " ", getChannelActionString(channel), message or "");
	end

	local function sendNPCTalk()

		local NPCName = strtrim(frame.Name:GetText());
		local channel = frame.ChannelDropdown:GetSelectedValue();
		local message = frame.MessageText.scroll.text:GetText();

		-- Always check that the message is not empty before trying to send it
		if not message or strlen(strtrim(message)) < 1 then return end

		-- Send a chat message via the EMOTE channel
		SendChatMessage(constructMessage(NPCName, channel, message), "EMOTE");
		-- Empty the message field (we leave the NPC name field as is in case the user wants to send multiple messages with the same NPC)
		frame.MessageText.scroll.text:SetText("");

	end

	local MAX_CHARACTERS_PER_MESSAGES = 254;
	local WARNING_NUMBER_OF_CHARACTERS = 239;
	local NORMAL_COLOR = TRP3_API.CreateColor(1.0000, 1.0000, 1.0000, 1.0000);
	local WARNING_COLOR = TRP3_API.CreateColor(1.0000, 0.4902, 0.0392, 1.0000);
	local ERROR_COLOR = TRP3_API.CreateColor(0.7686, 0.1216, 0.2314, 1.0000);

	local function checkCharactersLimit()

		local NPCName = strtrim(frame.Name:GetText());
		local channel = frame.ChannelDropdown:GetSelectedValue();
		local message = frame.MessageText.scroll.text:GetText();

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

		frame.CharactersCounter:SetTextColor(color:GetRGBA())
		frame.CharactersCounter:SetText(strconcat(MAX_CHARACTERS_PER_MESSAGES - numberOfCharactersInMessage));
	end

	local function buildChannelDropdown()
		local channelTypes = {};

		for channelLabel, channelName in pairs(CHANNEL_TYPES) do
			local channelColor = TRP3_API.GetChatTypeColor(channelName);
			tinsert(channelTypes, { TRP3_API.Colors.Yellow(loc.NPC_TALK_CHANNEL) .. channelColor(_G[channelLabel]), channelName});
		end

		-- Set the dropdown for the channels
		-- The checkCharactersLimit() function will be called when a new channel is selected
		-- as we switching channels changes the string use for the channel (says:, etc.) and so the message length too
		setupListBox(frame.ChannelDropdown, channelTypes, checkCharactersLimit, nil, 120, false);

		-- Select the SAY channel by default
		frame.ChannelDropdown:SetSelectedValue(CHANNEL_TYPES.SAY);
	end

	---
	-- Display the frame and do everything that needs to be done at show time
	local function toggleNPCTalkFrame()
		if frame:IsShown() then
			frame:Hide();
			return;
		end

		-- We always rebuild the dropdown on show as some of the colors can change during the session
		buildChannelDropdown();
		frame:Show();
	end
	TRP3_API.r.toggleNPCTalkFrame = toggleNPCTalkFrame;

	SendButton:SetScript("OnClick", sendNPCTalk);
	frame.MessageText.scroll.text:SetScript("OnEnterPressed", sendNPCTalk);
	frame.Title:SetText(loc.NPC_TALK_TITLE);
	frame.Name.title:SetText(loc.NPC_TALK_NAME);
	frame.MessageLabel:SetText(loc.NPC_TALK_MESSAGE);
	frame.Send:SetText(loc.NPC_TALK_SEND);

	-- Add hooks to check for the length of the message and make sure we don't try to send a message to big
	frame.MessageText.scroll.text:HookScript("OnTextChanged", checkCharactersLimit);
	frame.MessageText.scroll.text:HookScript("OnEditFocusGained", checkCharactersLimit);
	frame.Name:HookScript("OnTextChanged", checkCharactersLimit);
	frame.Name:HookScript("OnEditFocusGained", checkCharactersLimit);

	setTooltipForSameFrame(frame.Name.help, "RIGHT", 0, 5, loc.NPC_TALK_NAME, loc.NPC_TALK_NAME_TT);

	TRP3_API.Ellyb.EditBoxes.setupTabKeyNavigation(frame.Name, frame.MessageText.scroll.text);

	setupMovableFrame(frame);


	if TRP3_API.toolbar then

		-- Create a button for the toolbar to show/hide the NPC Talk frame
		TRP3_API.toolbar.toolbarAddButton({
			id = "bb_trp3_npctalk",
			icon = TRP3_InterfaceIcons.ToolbarNPCTalk,
			configText = loc.NPC_TALK_TITLE,
			tooltip = loc.NPC_TALK_TITLE,
			tooltipSub = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.NPC_TALK_BUTTON_TT),
			onClick = function()
				toggleNPCTalkFrame();
			end,
		});
	end

	-- We also register a slash command, so people who disable the toolbar button
	-- or the toolbar module entirely can still access the feature
	TRP3_API.slash.registerCommand({
		id = "npc_speech",
		helpLine = " " .. loc.NPC_TALK_COMMAND_HELP,
		handler = toggleNPCTalkFrame
	});

end);

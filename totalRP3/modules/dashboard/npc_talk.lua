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


TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

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
	local colorTool = CreateColor();

	local frame = TRP3_NPCTalk;
	local CONFIG_NPC_TALK_PREFIX = "chat_npc_talk_p";

	local CHANNEL_TYPES = {
		SAY = "MONSTER_SAY",
		EMOTE = "MONSTER_EMOTE",
		YELL = "MONSTER_YELL",
		WHISPER = "MONSTER_WHISPER"
	}

	local function sendNPCTalk()

		local NPCName = strtrim(frame.name:GetText());
		local channel = frame.channelDropdown:GetSelectedValue();
		local message = frame.messageText.scroll.text:GetText();

		if not message or message == "" then
			return displayMessage(loc("NPC_TALK_ERROR_EMPTY_MESSAGE"), messageTypes.ALERT_MESSAGE);
		end

		if NPCName and NPCName ~= "" then
			if channel == CHANNEL_TYPES.SAY then
				NPCName = NPCName .. " " .. loc("NPC_TALK_SAY_PATTERN") .. " ";
			elseif channel == CHANNEL_TYPES.YELL then
				NPCName = NPCName .. " " .. loc("NPC_TALK_YELL_PATTERN") .. " ";
			elseif channel == CHANNEL_TYPES.WHISPER then
				NPCName = NPCName .. " " .. loc("NPC_TALK_WHISPER_PATTERN") .. " ";
			elseif channel == CHANNEL_TYPES.EMOTE then
				NPCName = NPCName .. " ";
			end
			message = NPCName .. message;
		end

		message = getConfigValue(CONFIG_NPC_TALK_PREFIX) .. message;

		SendChatMessage(message, "EMOTE");
		frame.messageText.scroll.text:SetText("");

	end

	local function buildChannelDropdown()
		local channelTypes = {};

		for channelLabel, channelName in pairs(CHANNEL_TYPES) do
			local chatInfo = ChatTypeInfo[channelName];
			colorTool:SetRGB(chatInfo.r, chatInfo.g, chatInfo.b)
			tinsert(channelTypes, {"|cfff2bf03Channel:|r " .. colorTool:WrapTextInColorCode(_G[channelLabel]), channelName});
		end

		setupListBox(frame.channelDropdown, channelTypes, nil, nil, 120, false);
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

	frame.send:SetScript("OnClick", sendNPCTalk);
	frame.messageText.scroll.text:SetScript("OnEnterPressed", sendNPCTalk);
	frame.title:SetText(loc("NPC_TALK_TITLE"));
	frame.name.title:SetText(loc("NPC_TALK_NAME"));
	frame.messageLabel:SetText(loc("NPC_TALK_MESSAGE"));
	frame.send:SetText(loc("NPC_TALK_SEND"));

	setTooltipForSameFrame(frame.name.help, "RIGHT", 0, 5, loc("NPC_TALK_NAME"), loc("NPC_TALK_NAME_TT"));

	setupMovableFrame(frame);


	if TRP3_API.toolbar then

		-- Create a button for the toolbar to show/hide the NPC Talk frame
		local button = {
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
		};

		TRP3_API.toolbar.toolbarAddButton(button);
	end

	-- We also register a slash command, so people who disable the toolbar button
	-- or the toolbar module entirely can still access the feature
	TRP3_API.slash.registerCommand({
		id = "npc_speeches",
		helpLine = " " .. loc("NPC_TALK_COMMAND_HELP"),
		handler = showNPCTalkFrame
	});

end);
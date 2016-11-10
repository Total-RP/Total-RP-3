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

	local CONFIG_NPC_TALK_PREFIX = "chat_npc_talk_p";

	local CHANNEL_TYPE = {
		SAY = "SAY",
		EMOTE = "EMOTE",
		YELL = "YELL"
	}

	TRP3_NPCTalk.title:SetText("NPC talk");
	TRP3_NPCTalk.channelLabel:SetText("Channel");
	TRP3_NPCTalk.nameLabel:SetText("NPC name");
	TRP3_NPCTalk.messageLabel:SetText("Message");
	TRP3_NPCTalk.send:SetText("Send");

	TRP3_API.ui.tooltip.setTooltipForSameFrame(TRP3_NPCTalk.nameText.help, "RIGHT", 0, 5, "NPC Name", "You can use standard chat tags like %t to insert your target's name or %f to insert your focus' name.\n\nYou can also leave this field empty to create emotes without an NPC name at the start.");

	TRP3_NPCTalk.nameText:SetText("Anna");
	TRP3_NPCTalk.messageText.scroll.text:SetText("Do you wanna build a snowman?");

	TRP3_API.ui.frame.setupMove(TRP3_NPCTalk);

	TRP3_NPCTalk.send:SetScript("OnClick", function()
		local NPCName = TRP3_NPCTalk.nameText:GetText();
		local channel = TRP3_NPCTalk.channelDropdown:GetSelectedValue();
		local message = TRP3_NPCTalk.messageText.scroll.text:GetText();

		if not message or message == "" then
			message("The message cannot be empty");
		end

		if NPCName and NPCName ~= "" then
			if channel == CHANNEL_TYPE.SAY then
				NPCName = NPCName .. " " .. loc("NPC_TALK_SAY_PATTERN");
			end

			message = NPCName .. message;
		end

		message = getConfigValue(CONFIG_NPC_TALK_PREFIX) .. message;

		-- If the channel is Say, we will send it via emote anyway so it is not shown in the chat bubble on the player's head
		if channel == CHANNEL_TYPE.SAY then
			channel = CHANNEL_TYPE.EMOTE
		end

		SendChatMessage(message, channel);
	end)

	TRP3_API.ui.listbox.setupListBox(TRP3_NPCTalk.channelDropdown, {
		{SAY, CHANNEL_TYPE.SAY},
		{EMOTE, CHANNEL_TYPE.EMOTE},
		{YELL, CHANNEL_TYPE.YELL}
	}, nil, nil, 145, false);

	TRP3_NPCTalk.channelDropdown:SetSelectedValue("SAY");

	if TRP3_API.toolbar then

		local button = {
			id = "aa_trp3_npctalk",
			icon = "Ability_Warrior_CommandingShout",
			configText = "",
			onEnter = function(Uibutton, buttonStructure) end,
			onUpdate = function(Uibutton, buttonStructure)

			end,
			onClick = function(Uibutton, buttonStructure, button)
				if TRP3_NPCTalk:IsShown() then
					TRP3_NPCTalk:Hide();
				else
					TRP3_NPCTalk:Show();
				end
			end,
			onLeave = function()
			end,
		};

		TRP3_API.toolbar.toolbarAddButton(button);
	end
end);
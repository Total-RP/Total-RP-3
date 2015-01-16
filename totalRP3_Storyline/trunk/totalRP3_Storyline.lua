----------------------------------------------------------------------------------
-- Total RP 3
-- Storyline module
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

assert(TRP3_API ~= nil, "Can't find Total RP 3 API.");

local DEBUG = true;

-- imports
local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local TRP3_NPCDialogFrame = TRP3_NPCDialogFrame;
local TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou = TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou;
local TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText = TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText;
local tostring, strsplit, wipe = tostring, strsplit, wipe;
local ChatTypeInfo, GetGossipText, GetGreetingText, GetProgressText = ChatTypeInfo, GetGossipText, GetGreetingText, GetProgressText;
local GetRewardText, GetQuestText = GetRewardText, GetQuestText;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STRUCTURES & VARIABLES
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_SEQUENCE_SPEED = 1000;
local ANIMATION_TEXT_SPEED = 40;
local ANIMATION_SEQUENCE_DURATION = {
	["64"] = 3000,
	["65"] = 3000,
	["60"] = 4000,
	["0"] = 2000,
}
local CHAT_TEXT_WIDTH = 550;
local ANIMATION_EMPTY = {0};
local animTab = {};
local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;

local EVENT_INFO = {
	["QUEST_GREETING"] = {
		text = GetGreetingText,
		cancelMethod = CloseQuest,
		titleGetter = GetTitleText,
	},
	["QUEST_DETAIL"] = {
		text = GetQuestText,
		cancelMethod = DeclineQuest,
		finishText = DECLINE,
		finishMethod = DeclineQuest,
		titleGetter = GetTitleText,
	},
	["QUEST_PROGRESS"] = {
		text = GetProgressText,
		finishMethod = function()
			if IsQuestCompletable() then
				CompleteQuest();
			else
				CloseQuest();
			end
		end,
		finishText = function()
			if IsQuestCompletable() then
				return CONTINUE;
			else
				return GOODBYE;
			end
		end,
		cancelMethod = CloseQuest,
		titleGetter = GetTitleText,
	},
	["QUEST_COMPLETE"] = {
		text = GetRewardText,
		finishText = function()
			if GetNumQuestChoices() > 0 then
				return REWARDS;
			else
				return COMPLETE_QUEST;
			end
		end,
		finishMethod = function()
			if GetNumQuestChoices() > 0 then
				message("Please choose a reward from the original quest interface.");
			else
				GetQuestReward();
			end
		end,
		cancelMethod = CloseQuest,
		titleGetter = GetTitleText,
	},
	["GOSSIP_SHOW"] = {
		text = GetGossipText,
		finishMethod = CloseGossip,
		finishText = GOODBYE,
		cancelMethod = CloseGossip,
	},
	["REPLAY"] = {
		titleGetter = function()
			local questTitle = GetQuestLogTitle(GetQuestLogSelection());
			return questTitle;
		end,
		nameGetter = function()
			return QUEST_LOG;
		end
	}
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SELECTION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tinsert = tinsert;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local GetNumGossipOptions, GetGossipOptions, SelectGossipOption = GetNumGossipOptions, GetGossipOptions, SelectGossipOption;
local GetNumGossipAvailableQuests, GetGossipAvailableQuests, SelectGossipAvailableQuest = GetNumGossipAvailableQuests, GetGossipAvailableQuests, SelectGossipAvailableQuest;
local TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2 = TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2;
local multiGossipList = {};

local function selectFirstGossip()
	SelectGossipOption(1);
end

local function selectMultipleGossip()
	wipe(multiGossipList);
	local gossips = {GetGossipOptions()};
	tinsert(multiGossipList, {"Select dialog option", nil}); -- TODO: locale
	for i=1, GetNumGossipOptions() do
		local gossip, gossipType = gossips[(i*2) - 1], gossips[(i*2)];
		tinsert(multiGossipList, {"|TInterface\\GossipFrame\\" .. gossipType .. "GossipIcon:25:25|t" .. gossip, i});
	end
	displayDropDown(TRP3_NPCDialogFrameChatOption2, multiGossipList, SelectGossipOption, 0, true);
end

local function selectFirstAvailable()
	SelectGossipAvailableQuest(1);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CHAT_MARGIN, CHAT_NAME = 70, 20;
local gossipColor = "|cffffffff";
local TRP3_NPCDialogFrameChatNext = TRP3_NPCDialogFrameChatNext;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;

local function playText(textIndex)
	local text = TRP3_NPCDialogFrameChat.texts[textIndex];
	local sound;
	wipe(animTab);
	text:gsub("[%.%?%!]+", function(finder)
		if finder:sub(1, 1) == "!" then
			animTab[#animTab+1] = 64;
		elseif finder:sub(1, 1) == "?" then
			animTab[#animTab+1] = 65;
		else
			animTab[#animTab+1] = 60;
		end
	end);
	animTab[#animTab+1] = 0;
	
	if text:byte() == 60 then -- Emote if begins with <
		TRP3_NPCDialogFrameChatText:SetTextColor(ChatTypeInfo["MONSTER_EMOTE"].r, ChatTypeInfo["MONSTER_EMOTE"].g, ChatTypeInfo["MONSTER_EMOTE"].b);
		TRP3_NPCDialogFrameChatText:SetText(text:sub(2, text:len() - 1));
		wipe(animTab);
		animTab[1] = 0;
	else
		TRP3_NPCDialogFrameChatText:SetTextColor(ChatTypeInfo["MONSTER_SAY"].r, ChatTypeInfo["MONSTER_SAY"].g, ChatTypeInfo["MONSTER_SAY"].b);
		TRP3_NPCDialogFrameChatText:SetText(text);
	end



	TRP3_NPCDialogFrameModelsYou.seqtime = 0;
	TRP3_NPCDialogFrameModelsYou.sequenceTab = animTab;
	TRP3_NPCDialogFrameModelsYou.sequence = 1;
	
	TRP3_NPCDialogFrameChat.start = 0;

	if textIndex > 1 then
		TRP3_NPCDialogFrameChatPrevious:Show();
	end

	-- Options
	local optionsSize = 0;
	TRP3_NPCDialogFrameChatOption1:Hide();
	TRP3_NPCDialogFrameChatOption2:Hide();
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption1);
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption2);

	if TRP3_NPCDialogFrameChat.event == "GOSSIP_SHOW" and textIndex == #TRP3_NPCDialogFrameChat.texts then
		local hasGossip, hasAvailable, hasActive = GetNumGossipOptions() > 0, GetNumGossipAvailableQuests() > 0, GetNumGossipActiveQuests() > 0;
		local previous;

		-- Available quests
		if hasAvailable then
			optionsSize = optionsSize + 20;
			TRP3_NPCDialogFrameChatOption1:Show();
			previous = TRP3_NPCDialogFrameChatOption1;
			local availables = {GetGossipAvailableQuests()};
			if GetNumGossipAvailableQuests() == 1 then
				local title, lvl, isTrivial, frequency, isRepeatable, isLegendary = GetGossipAvailableQuests();
				TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. title);
				if ( isLegendary ) then
					TRP3_NPCDialogFrameChatOption1GossipIcon:SetTexture("Interface\\GossipFrame\\AvailableLegendaryQuestIcon");
				elseif ( frequency == LE_QUEST_FREQUENCY_DAILY or frequency == LE_QUEST_FREQUENCY_WEEKLY ) then
					TRP3_NPCDialogFrameChatOption1GossipIcon:SetTexture("Interface\\GossipFrame\\DailyQuestIcon");
				elseif ( isRepeatable ) then
					TRP3_NPCDialogFrameChatOption1GossipIcon:SetTexture("Interface\\GossipFrame\\DailyActiveQuestIcon");
				else
					TRP3_NPCDialogFrameChatOption1GossipIcon:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon");
				end
				TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectFirstAvailable);
			end

		end

		-- Gossip options
		if hasGossip then
			TRP3_NPCDialogFrameChatOption2:Show();
			TRP3_NPCDialogFrameChatOption2:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption2:SetPoint("LEFT", 50, 0);
			TRP3_NPCDialogFrameChatOption2:SetPoint("RIGHT", -50, 0);
			if previous then
				TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
			else
				TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", TRP3_NPCDialogFrameChatText, "BOTTOM", 0, -10);
			end
			previous = TRP3_NPCDialogFrameChatOption2;

			optionsSize = optionsSize + 20;
			local gossips = {GetGossipOptions()};
			if GetNumGossipOptions() == 1 then
				local gossip, gossipType = gossips[1], gossips[2];
				TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. gossip);
				TRP3_NPCDialogFrameChatOption2GossipIcon:SetTexture("Interface\\GossipFrame\\" .. gossipType .. "GossipIcon");
				TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectFirstGossip);
			else
				TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "Well ..."); -- TODO: locale
				TRP3_NPCDialogFrameChatOption2GossipIcon:SetTexture("Interface\\GossipFrame\\PetitionGossipIcon");
				TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectMultipleGossip);
			end
		end

	elseif TRP3_NPCDialogFrameChat.event == "QUEST_DETAIL" and textIndex == #TRP3_NPCDialogFrameChat.texts then
		optionsSize = optionsSize + 40;
		TRP3_NPCDialogFrameChatOption1:Show();
		TRP3_NPCDialogFrameChatOption2:Show();
		TRP3_NPCDialogFrameChatOption2:ClearAllPoints();
		TRP3_NPCDialogFrameChatOption2:SetPoint("LEFT", 50, 0);
		TRP3_NPCDialogFrameChatOption2:SetPoint("RIGHT", -50, 0);
		TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", TRP3_NPCDialogFrameChatOption1, "BOTTOM", 0, -5);

		TRP3_NPCDialogFrameChatOption1GossipIcon:SetTexture("Interface\\FriendsFrame\\InformationIcon");
		TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. QUEST_OBJECTIVES); -- TODO: locale
		TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", nil);
		setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption1, "TOP", 0, 5, QUEST_OBJECTIVES, GetObjectiveText());

		TRP3_NPCDialogFrameChatOption2GossipIcon:SetTexture("Interface\\Scenarios\\ScenarioIcon-Check");
		TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "I accept !"); -- TODO: locale
		TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", AcceptQuest);

	end

	TRP3_NPCDialogFrameChat:SetHeight(TRP3_NPCDialogFrameChatText:GetHeight() + CHAT_MARGIN + CHAT_NAME + optionsSize);
end

local TRP3_NPCDialogFrameChatNext = TRP3_NPCDialogFrameChatNext;

local function playNext()
	TRP3_NPCDialogFrameChat.currentIndex = TRP3_NPCDialogFrameChat.currentIndex + 1;
	if TRP3_NPCDialogFrameChat.currentIndex <= #TRP3_NPCDialogFrameChat.texts then
		playText(TRP3_NPCDialogFrameChat.currentIndex);
		if TRP3_NPCDialogFrameChat.currentIndex < #TRP3_NPCDialogFrameChat.texts then
			TRP3_NPCDialogFrameChatNext:SetText(gossipColor .. "Next"); -- TODO: Locals
		else
			if type(TRP3_NPCDialogFrameChat.eventInfo.finishText) == "function" then
				TRP3_NPCDialogFrameChatNext:SetText(gossipColor .. TRP3_NPCDialogFrameChat.eventInfo.finishText());
			else
				TRP3_NPCDialogFrameChatNext:SetText(gossipColor .. (TRP3_NPCDialogFrameChat.eventInfo.finishText or "Finish"));
			end
		end
	else
		if TRP3_NPCDialogFrameChat.eventInfo.finishMethod then
			TRP3_NPCDialogFrameChat.eventInfo.finishMethod();
		else
			TRP3_NPCDialogFrame:Hide();
		end
	end
end

local function closeDialog()
	if TRP3_NPCDialogFrameChat.eventInfo and TRP3_NPCDialogFrameChat.eventInfo.cancelMethod then
		TRP3_NPCDialogFrameChat.eventInfo.cancelMethod();
	else
		TRP3_NPCDialogFrame:Hide();
	end
end

local function resetDialog()
	TRP3_NPCDialogFrameChat.currentIndex = 0;
	playNext();
end

local function startDialog(targetType, fullText, event, eventInfo)
	-- Ca marche pas, merci Blizzard d'ajouter des fonctions que tu n'implementes pas toi meme.
--	local forced = ForceGossip();
--	if not forced then
--		return;
--	end

	if DEBUG then
		TRP3_NPCDialogFrameDebug:SetText("[debug] " .. event);
	end

	local targetName = UnitName(targetType);

	if targetName and targetName:len() > 0 and targetName ~= UNKNOWN then
		TRP3_NPCDialogFrameChatName:SetText(targetName);
	else
		if eventInfo.nameGetter and eventInfo.nameGetter() then
			TRP3_NPCDialogFrameChatName:SetText(eventInfo.nameGetter());
		else
			TRP3_NPCDialogFrameChatName:SetText("");
		end
	end

	if eventInfo.titleGetter and eventInfo.titleGetter() then
		TRP3_NPCDialogFrameTitle:SetText(eventInfo.titleGetter());
	else
		TRP3_NPCDialogFrameTitle:SetText("");
	end


	TRP3_NPCDialogFrameModelsYou:SetCamera(1);
	TRP3_NPCDialogFrameModelsYou:SetFacing(-0.75);
	TRP3_NPCDialogFrameModelsYou:SetUnit(targetType);
	TRP3_NPCDialogFrameModelsYou:SetLight(1, 0, 0, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	
	fullText = fullText:gsub(LINE_FEED_CODE .. "+", "\n");
	fullText = fullText:gsub(WEIRD_LINE_BREAK, "\n");
	
	local texts = {strsplit("\n", fullText)};
	TRP3_NPCDialogFrameChat.texts = texts;
	TRP3_NPCDialogFrameChat.currentIndex = 0;
	TRP3_NPCDialogFrameChat.eventInfo = eventInfo;
	TRP3_NPCDialogFrameChat.event = event;

	TRP3_NPCDialogFrameChatPrevious:Hide();
	
	TRP3_NPCDialogFrame:Show();

	playNext();

	print()
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ANIMATIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onUpdateModel(self, elapsed)
	if self.seqtime and self.sequence and self.sequenceTab then
		self.seqtime = self.seqtime + (elapsed * ANIMATION_SEQUENCE_SPEED);
		if self.sequenceTab[self.sequence] ~= 0 then
			self:SetSequenceTime(self.sequenceTab[self.sequence], self.seqtime);
		end
		local sequenceString = tostring(self.sequenceTab[self.sequence]);
		-- Once the anim is finished, go to the next one.
		if ANIMATION_SEQUENCE_DURATION[sequenceString] and self.seqtime > ANIMATION_SEQUENCE_DURATION[sequenceString] then
			self.seqtime = 0;
			if self.sequence < #self.sequenceTab then
				self.sequence = self.sequence + 1;
			end
		end
	end
end

local function onUpdateChatText(self, elapsed)
	if self.start then
		self.time = 0;
		self.start = self.start + (elapsed * ANIMATION_TEXT_SPEED);
		if self.start == TRP3_NPCDialogFrameChatText:GetText():len() then
			self.start = nil;
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(0,0);
		else
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(self.start, 30);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function init()
	ForceGossip = function() return true end

	TRP3_NPCDialogFrameChatText:SetWidth(CHAT_TEXT_WIDTH);
	TRP3_NPCDialogFrameModelsMe:SetCamera(1);
	TRP3_NPCDialogFrameModelsMe:SetFacing(0.75);
	TRP3_NPCDialogFrameModelsMe:SetUnit("player");
	TRP3_NPCDialogFrameModelsMe:SetLight(1, 0, 0, -1, -1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);

	TRP3_NPCDialogFrameChatPrevious:SetText("Reset");

	TRP3_NPCDialogFrameChatNext:SetScript("OnClick", playNext);
	TRP3_NPCDialogFrameChatPrevious:SetScript("OnClick", resetDialog);
	TRP3_NPCDialogFrameModelsYou:SetScript("OnUpdate", onUpdateModel);
	TRP3_NPCDialogFrameChat:SetScript("OnUpdate", onUpdateChatText);
	TRP3_NPCDialogClose:SetScript("OnClick", closeDialog);

	-- Showing
	for event, info in pairs(EVENT_INFO) do
		Utils.event.registerHandler(event, function()
			startDialog("npc", info.text(), event, info);
		end);
	end

	-- Closing
	Utils.event.registerHandler("GOSSIP_CLOSED", function()
		TRP3_NPCDialogFrame:Hide();
	end);
	Utils.event.registerHandler("QUEST_FINISHED", function()
		TRP3_NPCDialogFrame:Hide();
	end);

	-- Replay buttons
	local questButton = CreateFrame("Button", nil, QuestLogPopupDetailFrame, "TRP3_CommonButton");
	questButton:SetText("Storyline"); -- TODO: Locals
	questButton:SetPoint("TOP");
	questButton:SetScript("OnClick", function()
		local questDescription = GetQuestLogQuestText();
		startDialog("none", questDescription, "REPLAY", EVENT_INFO["REPLAY"]);
	end);
end

local MODULE_STRUCTURE = {
	["name"] = "Storyline",
	["description"] = "Enhance the way questlines are told.",
	["version"] = 1.000,
	["id"] = "better_npc_chat",
	["onStart"] = init,
	["minVersion"] = 0.1,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
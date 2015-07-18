----------------------------------------------------------------------------------
-- Total RP 3
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

-- TRP3 API
local Utils = TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local setTooltipForSameFrame, setTooltipAll = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_API.ui.tooltip.setTooltipAll;

-- Storyline API
local playSelfAnim, getDuration, playAnimationDelay = TRP3_StorylineAPI.playSelfAnim, TRP3_StorylineAPI.getDuration, TRP3_StorylineAPI.playAnimationDelay;
local getQuestIcon, getQuestActiveIcon = TRP3_StorylineAPI.getQuestIcon, TRP3_StorylineAPI.getQuestActiveIcon;
local getQuestTriviality = TRP3_StorylineAPI.getQuestTriviality;
local selectMultipleAvailableGreetings = TRP3_StorylineAPI.selectMultipleAvailableGreetings;
local selectMultipleActiveGreetings = TRP3_StorylineAPI.selectMultipleActiveGreetings;
local selectMultipleActive = TRP3_StorylineAPI.selectMultipleActive;
local selectFirstActive = TRP3_StorylineAPI.selectFirstActive;
local selectMultipleAvailable = TRP3_StorylineAPI.selectMultipleAvailable;
local selectFirstAvailable = TRP3_StorylineAPI.selectFirstAvailable;
local selectFirstGossip, selectMultipleGossip = TRP3_StorylineAPI.selectFirstGossip, TRP3_StorylineAPI.selectMultipleGossip;
local selectMultipleRewards, selectFirstGreetingActive = TRP3_StorylineAPI.selectMultipleRewards, TRP3_StorylineAPI.selectFirstGreetingActive;
local getAnimationByModel = TRP3_StorylineAPI.getAnimationByModel;

-- WOW API
local pairs, CreateFrame, wipe, type = pairs, CreateFrame, wipe, type;
local ChatTypeInfo = ChatTypeInfo;
local UnitIsUnit, UnitExists, DeclineQuest, AcceptQuest = UnitIsUnit, UnitExists, DeclineQuest, AcceptQuest;
local IsQuestCompletable, CompleteQuest, CloseQuest, GetQuestLogTitle = IsQuestCompletable, CompleteQuest, CloseQuest, GetQuestLogTitle;
local GetNumQuestChoices, GetQuestReward, GetQuestLogSelection = GetNumQuestChoices, GetQuestReward, GetQuestLogSelection;
local GetQuestLogQuestText, GetGossipAvailableQuests, GetGossipActiveQuests = GetQuestLogQuestText, GetGossipAvailableQuests, GetGossipActiveQuests;
local GetNumGossipOptions, GetNumGossipAvailableQuests, GetNumGossipActiveQuests = GetNumGossipOptions, GetNumGossipAvailableQuests, GetNumGossipActiveQuests;
local GetQuestItemInfo, GetNumQuestItems, GetGossipOptions = GetQuestItemInfo, GetNumQuestItems, GetGossipOptions;
local GetObjectiveText, GetCoinTextureString, GetRewardXP = GetObjectiveText, GetCoinTextureString, GetRewardXP;
local GetQuestItemLink, GetNumQuestRewards, GetRewardMoney = GetQuestItemLink, GetNumQuestRewards, GetRewardMoney;
local GetAvailableQuestInfo, GetNumAvailableQuests, GetNumActiveQuests = GetAvailableQuestInfo, GetNumAvailableQuests, GetNumActiveQuests;
local GetAvailableTitle, GetActiveTitle, CloseGossip = GetAvailableTitle, GetActiveTitle, CloseGossip;
local GetProgressText, GetTitleText, GetGreetingText = GetProgressText, GetTitleText, GetGreetingText;
local GetGossipText, GetRewardText, GetQuestText = GetGossipText, GetRewardText, GetQuestText;

-- UI
local TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2, TRP3_NPCDialogFrameChatOption3 = TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2, TRP3_NPCDialogFrameChatOption3;
local TRP3_NPCDialogFrameObjectives, TRP3_NPCDialogFrameObjectivesNo, TRP3_NPCDialogFrameObjectivesYes = TRP3_NPCDialogFrameObjectives, TRP3_NPCDialogFrameObjectivesNo, TRP3_NPCDialogFrameObjectivesYes;
local TRP3_NPCDialogFrameObjectivesImage = TRP3_NPCDialogFrameObjectivesImage;
local TRP3_NPCDialogFrameRewardsItemIcon, TRP3_NPCDialogFrameRewardsItem, TRP3_NPCDialogFrameRewards = TRP3_NPCDialogFrameRewardsItemIcon, TRP3_NPCDialogFrameRewardsItem, TRP3_NPCDialogFrameRewards;
local TRP3_NPCDialogFrame, TRP3_NPCDialogFrameChatNextText = TRP3_NPCDialogFrame, TRP3_NPCDialogFrameChatNextText;
local TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText = TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText;
local TRP3_NPCDialogFrameChatNext, TRP3_NPCDialogFrameChatPrevious = TRP3_NPCDialogFrameChatNext, TRP3_NPCDialogFrameChatPrevious;
local TRP3_NPCDialogFrameConfigButton = TRP3_NPCDialogFrameConfigButton;

-- Constants
local OPTIONS_MARGIN, OPTIONS_TOP = 175, -175;
local CHAT_MARGIN = 70;
local gossipColor = "|cffffffff";

local function handleEventSpecifics(event, texts, textIndex, eventInfo)
	-- Options
	local previous;
	TRP3_NPCDialogFrameObjectives:Hide();
	TRP3_NPCDialogFrameChatOption1:Hide();
	TRP3_NPCDialogFrameChatOption2:Hide();
	TRP3_NPCDialogFrameChatOption3:Hide();
	TRP3_NPCDialogFrameObjectivesYes:Hide();
	TRP3_NPCDialogFrameObjectivesNo:Hide();
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption1);
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption2);
	setTooltipForSameFrame(TRP3_NPCDialogFrameChatOption3);
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives);
	TRP3_NPCDialogFrameChatOption1:SetScript("OnEnter", nil);
	TRP3_NPCDialogFrameChatOption2:SetScript("OnEnter", nil);
	TRP3_NPCDialogFrameChatOption3:SetScript("OnEnter", nil);
	TRP3_NPCDialogFrameObjectives:SetScript("OnClick", nil);
	TRP3_NPCDialogFrameObjectivesImage:SetTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon");

	if event == "GOSSIP_SHOW" and textIndex == #texts then
		local hasGossip, hasAvailable, hasActive = GetNumGossipOptions() > 0, GetNumGossipAvailableQuests() > 0, GetNumGossipActiveQuests() > 0;

		-- Available quests
		if hasAvailable then
			TRP3_NPCDialogFrameChatOption1:Show();
			TRP3_NPCDialogFrameChatOption1:SetScript("OnEnter", function() playSelfAnim(65) end);
			TRP3_NPCDialogFrameChatOption1:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption1:SetPoint("LEFT", OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption1:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption1:SetPoint("TOP", 0, OPTIONS_TOP);

			previous = TRP3_NPCDialogFrameChatOption1;
			if GetNumGossipAvailableQuests() == 1 then
				local title, lvl, isTrivial, frequency, isRepeatable, isLegendary = GetGossipAvailableQuests();
				local icon = "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t ";
				TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. icon .. title .. getQuestTriviality(isTrivial));
				TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectFirstAvailable);
			else
				TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. "|TInterface\\GossipFrame\\AvailableQuestIcon:20:20|t " .. loc("SL_WELL"));
				TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectMultipleAvailable);
			end
		end

		-- Active options
		if hasActive then
			TRP3_NPCDialogFrameChatOption2:Show();
			TRP3_NPCDialogFrameChatOption2:SetScript("OnEnter", function() playSelfAnim(60) end);
			TRP3_NPCDialogFrameChatOption2:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption2:SetPoint("LEFT", OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption2:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
			if previous then
				TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
			else
				TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", 0, OPTIONS_TOP);
			end
			previous = TRP3_NPCDialogFrameChatOption2;
			if GetNumGossipActiveQuests() == 1 then
				local title, lvl, isTrivial, isComplete, isRepeatable = GetGossipActiveQuests();
				TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "|T" .. getQuestActiveIcon(isComplete, isRepeatable) .. ":20:20|t " .. title .. getQuestTriviality(isTrivial));
				TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectFirstActive);
			else
				TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "|TInterface\\GossipFrame\\ActiveQuestIcon:20:20|t " .. loc("SL_WELL"));
				TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectMultipleActive);
			end
		end

		-- Gossip options
		if hasGossip then
			TRP3_NPCDialogFrameChatOption3:Show();
			TRP3_NPCDialogFrameChatOption3:SetScript("OnEnter", function() playSelfAnim(60) end);
			TRP3_NPCDialogFrameChatOption3:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption3:SetPoint("LEFT", OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption3:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
			if previous then
				TRP3_NPCDialogFrameChatOption3:SetPoint("TOP", previous, "BOTTOM", 0, -5);
			else
				TRP3_NPCDialogFrameChatOption3:SetPoint("TOP", 0, OPTIONS_TOP);
			end
			previous = TRP3_NPCDialogFrameChatOption3;

			local gossips = { GetGossipOptions() };
			if GetNumGossipOptions() == 1 then
				local gossip, gossipType = gossips[1], gossips[2];
				TRP3_NPCDialogFrameChatOption3:SetText(gossipColor .. "|TInterface\\GossipFrame\\" .. gossipType .. "GossipIcon:20:20|t " .. gossip);
				TRP3_NPCDialogFrameChatOption3:SetScript("OnClick", selectFirstGossip);
			else
				TRP3_NPCDialogFrameChatOption3:SetText(gossipColor .. "|TInterface\\GossipFrame\\PetitionGossipIcon:20:20|t " .. loc("SL_WELL"));
				TRP3_NPCDialogFrameChatOption3:SetScript("OnClick", selectMultipleGossip);
			end
		end

	end

	if event == "QUEST_DETAIL" and textIndex == #texts then
		TRP3_NPCDialogFrameObjectives:Show();
		TRP3_NPCDialogFrameObjectivesYes:Show();
		TRP3_NPCDialogFrameObjectivesNo:Show();
		TRP3_NPCDialogFrameObjectivesImage:SetDesaturated(false);
		setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives, "BOTTOM", 0, 0, QUEST_OBJECTIVES, "|cff00ff00" .. GetObjectiveText());
		if GetNumQuestItems() > 0 then
			local _, icon = GetQuestItemInfo("required", 1);
			TRP3_NPCDialogFrameObjectivesImage:SetTexture(icon);
		end
	end

	if event == "QUEST_PROGRESS" and textIndex == #texts then
		TRP3_NPCDialogFrameObjectives:Show();
		local objectives = "";
		if GetNumQuestItems() > 0 then
			local _, icon = GetQuestItemInfo("required", 1);
			TRP3_NPCDialogFrameObjectivesImage:SetTexture(icon);
			for i = 1, GetNumQuestItems() do
				local name, texture, numItems, quality, isUsable = GetQuestItemInfo("required", i);
				if GetNumQuestItems() > 1 then
					objectives = objectives .. numItems .. "x " .. name;
				else
					objectives = objectives .. numItems .. "x |T".. texture .. ":25:25|t " .. name;
				end
				if i ~= GetNumQuestItems() then
					objectives = objectives .. "\n";
				end
			end
		end
		TRP3_NPCDialogFrameObjectivesImage:SetDesaturated(not IsQuestCompletable());
		if IsQuestCompletable() then
			TRP3_NPCDialogFrameObjectives:SetScript("OnClick", CompleteQuest);
			objectives = objectives .. "\n\n|cff00ff00" .. loc("SL_CONTINUE");
		end
		if objectives ~= "" then
			setTooltipForSameFrame(TRP3_NPCDialogFrameObjectives, "BOTTOM", 0, 0, QUEST_OBJECTIVES, objectives);
		end
	end

	-- Rewards
	TRP3_NPCDialogFrameRewards:Hide();
	if event == "QUEST_COMPLETE" and textIndex == #texts then
		playSelfAnim(68);
		TRP3_NPCDialogFrameRewards:Show();
		setTooltipForSameFrame(TRP3_NPCDialogFrameRewardsItem, "BOTTOM", 0, 0);
		local xp = GetRewardXP();
		local money = GetCoinTextureString(GetRewardMoney());
		local TTReward = loc("SL_REWARD_MORE");
		local subTTReward = loc("SL_REWARD_MORE_SUB"):format(money, xp);
		TRP3_NPCDialogFrameRewards.itemLink = nil;

		if GetNumQuestChoices() > 1 then
			TRP3_NPCDialogFrameRewardsItem:SetScript("OnClick", function()
				selectMultipleRewards(TRP3_NPCDialogFrameRewardsItem);
			end);
		else
			TRP3_NPCDialogFrameRewardsItem:SetScript("OnClick", eventInfo.finishMethod);
		end

		if GetNumQuestChoices() == 1 or GetNumQuestRewards() > 0 then
			local type = GetNumQuestChoices() == 1 and "choice" or "reward";
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo(type, 1);
			local link = GetQuestItemLink(type, 1);

			TRP3_NPCDialogFrameRewards.itemLink = link;
			TRP3_NPCDialogFrameRewardsItemIcon:SetTexture(texture);
		else
			-- No item
			TTReward = REWARDS;
			if xp > 0 then
				TRP3_NPCDialogFrameRewardsItemIcon:SetTexture("Interface\\ICONS\\xp_icon");
			else
				TRP3_NPCDialogFrameRewardsItemIcon:SetTexture("Interface\\ICONS\\inv_misc_coin_03");
			end
		end

		setTooltipForSameFrame(TRP3_NPCDialogFrameRewardsItem, "BOTTOM", 0, -20, TTReward, subTTReward);
	end

	if event == "QUEST_GREETING" and textIndex == #texts then

		local numActiveQuests = GetNumActiveQuests();
		local numAvailableQuests = GetNumAvailableQuests();

		if numActiveQuests > 0 then
			TRP3_NPCDialogFrameChatOption1:Show();
			TRP3_NPCDialogFrameChatOption1:SetScript("OnEnter", function() playSelfAnim(65) end);
			TRP3_NPCDialogFrameChatOption1:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption1:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption1:SetPoint("LEFT", OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption1:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption1:SetPoint("TOP", 0, OPTIONS_TOP);

			previous = TRP3_NPCDialogFrameChatOption1;
			if numActiveQuests == 1 then
				local title, isComplete = GetActiveTitle(1);
				local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(1);
				local icon = "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t ";
				TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. "|T" .. getQuestActiveIcon(isComplete, isRepeatable) .. ":20:20|t " .. title .. getQuestTriviality(isTrivial));
				TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectFirstGreetingActive);
			else
				TRP3_NPCDialogFrameChatOption1:SetText(gossipColor .. "|TInterface\\GossipFrame\\ActiveQuestIcon:20:20|t " .. loc("SL_WELL"));
				TRP3_NPCDialogFrameChatOption1:SetScript("OnClick", selectMultipleActiveGreetings);
			end
		end

		if numAvailableQuests > 0 then
			TRP3_NPCDialogFrameChatOption2:Show();
			TRP3_NPCDialogFrameChatOption2:SetScript("OnEnter", function() playSelfAnim(60) end);
			TRP3_NPCDialogFrameChatOption2:ClearAllPoints();
			TRP3_NPCDialogFrameChatOption2:SetPoint("LEFT", OPTIONS_MARGIN, 0);
			TRP3_NPCDialogFrameChatOption2:SetPoint("RIGHT", -OPTIONS_MARGIN, 0);
			if previous then
				TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", previous, "BOTTOM", 0, -5);
			else
				TRP3_NPCDialogFrameChatOption2:SetPoint("TOP", 0, OPTIONS_TOP);
			end
			previous = TRP3_NPCDialogFrameChatOption2;
			if numAvailableQuests == 1 then
				local title, isComplete = GetAvailableTitle(1);
				local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(numActiveQuests + 1);
				local icon = "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t ";
				TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. icon .. title .. getQuestTriviality(isTrivial));
				TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectFirstAvailable);
			else
				TRP3_NPCDialogFrameChatOption2:SetText(gossipColor .. "|TInterface\\GossipFrame\\AvailableQuestIcon:20:20|t " .. loc("SL_WELL"));
				TRP3_NPCDialogFrameChatOption2:SetScript("OnClick", selectMultipleAvailableGreetings);
			end
		end
	end
end

local function playText(textIndex, targetModel)
	local animTab = targetModel.animTab;
	wipe(animTab);

	local text = TRP3_NPCDialogFrameChat.texts[textIndex];
	local sound;
	local delay = 0;
	local textLineToken = Utils.str.id();

	TRP3_NPCDialogFrameChatText:SetTextColor(ChatTypeInfo["MONSTER_SAY"].r, ChatTypeInfo["MONSTER_SAY"].g, ChatTypeInfo["MONSTER_SAY"].b);

	if text:byte() == 60 or not UnitExists("npc") or UnitIsUnit("player", "npc") then -- Emote if begins with <
		local color = Utils.color.colorCodeFloat(ChatTypeInfo["MONSTER_EMOTE"].r, ChatTypeInfo["MONSTER_EMOTE"].g, ChatTypeInfo["MONSTER_EMOTE"].b);
		local finalText = text:gsub("<", color .. "<");
		finalText = finalText:gsub(">", ">|r");
		if not UnitExists("npc") or UnitIsUnit("player", "npc") then
			TRP3_NPCDialogFrameChatText:SetText(color .. finalText);
		else
			TRP3_NPCDialogFrameChatText:SetText(finalText);
		end
	else
		TRP3_NPCDialogFrameChatText:SetText(text);
		text:gsub("[%.%?%!]+", function(finder)
			animTab[#animTab + 1] = getAnimationByModel(targetModel.model, finder:sub(1, 1));
			animTab[#animTab + 1] = 0;
		end);
	end

	if #animTab == 0 then
		animTab[1] = 0;
	end

	for _, sequence in pairs(animTab) do
		delay = playAnimationDelay(targetModel, sequence, getDuration(targetModel.model, sequence), delay, textLineToken);
	end

	TRP3_NPCDialogFrameChat.start = 0;

	if #TRP3_NPCDialogFrameChat.texts > 1 then
		TRP3_NPCDialogFrameChatPrevious:Show();
	end

	handleEventSpecifics(TRP3_NPCDialogFrameChat.event, TRP3_NPCDialogFrameChat.texts, textIndex, TRP3_NPCDialogFrameChat.eventInfo);

	TRP3_NPCDialogFrameChat:SetHeight(TRP3_NPCDialogFrameChatText:GetHeight() + CHAT_MARGIN + 5);
end

function TRP3_StorylineAPI.playNext(targetModel)
	TRP3_NPCDialogFrameChatNext:Hide();
	TRP3_NPCDialogFrameChatNextText:SetText("");
	TRP3_NPCDialogFrameChat.currentIndex = TRP3_NPCDialogFrameChat.currentIndex + 1;
	if TRP3_NPCDialogFrameChat.currentIndex <= #TRP3_NPCDialogFrameChat.texts then
		if TRP3_NPCDialogFrameChat.currentIndex == #TRP3_NPCDialogFrameChat.texts then
			if TRP3_NPCDialogFrameChat.eventInfo.finishText and (type(TRP3_NPCDialogFrameChat.eventInfo.finishText) ~= "function" or TRP3_NPCDialogFrameChat.eventInfo.finishText()) then
				TRP3_NPCDialogFrameChatNext:Show();
				if type(TRP3_NPCDialogFrameChat.eventInfo.finishText) == "function" then
					TRP3_NPCDialogFrameChatNextText:SetText(TRP3_NPCDialogFrameChat.eventInfo.finishText());
				else
					TRP3_NPCDialogFrameChatNextText:SetText(TRP3_NPCDialogFrameChat.eventInfo.finishText);
				end
			end
		else
			TRP3_NPCDialogFrameChatNext:Show();
			TRP3_NPCDialogFrameChatNextText:SetText(loc("SL_NEXT"));
		end
		playText(TRP3_NPCDialogFrameChat.currentIndex, targetModel);
	else
		if TRP3_NPCDialogFrameChat.eventInfo.finishMethod then
			TRP3_NPCDialogFrameChat.eventInfo.finishMethod();
		else
			TRP3_NPCDialogFrame:Hide();
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_StorylineAPI.initEventsStructure()
	local startDialog = TRP3_StorylineAPI.startDialog;

	local EVENT_INFO = {
		["QUEST_GREETING"] = {
			text = GetGreetingText,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["QUEST_DETAIL"] = {
			text = GetQuestText,
			cancelMethod = CloseQuest,
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
					return loc("SL_CONTINUE");
				else
					return loc("SL_NOT_YET");
				end
			end,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["QUEST_COMPLETE"] = {
			text = GetRewardText,
			finishMethod = function()
				if GetNumQuestChoices() == 1 then
					GetQuestReward(1);
				elseif GetNumQuestChoices() > 0 then
					message("Please choose a reward using the icon above."); -- TODO: TEMP
				else
					GetQuestReward();
				end
			end,
			finishText = function()
				if GetNumQuestChoices() > 1 then
					return "Please choose a reward using the icon above."; -- TODO: TEMP
				else
					return loc("SL_GET_REWARD");
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
			end,
			finishText = CLOSE,
		}
	};

	for event, info in pairs(EVENT_INFO) do
		Utils.event.registerHandler(event, function()
			startDialog("npc", info.text(), event, info);
		end);
	end

	-- Replay buttons
	local questButton = CreateFrame("Button", nil, QuestLogPopupDetailFrame, "TRP3_CommonButton");
	questButton:SetText(loc("SL_STORYLINE"));
	questButton:SetPoint("TOP");
	questButton:SetScript("OnClick", function()
		local questDescription = GetQuestLogQuestText();
		startDialog("none", questDescription, "REPLAY", EVENT_INFO["REPLAY"]);
	end);

	-- UI
	setTooltipAll(TRP3_NPCDialogFrameChatPrevious, "BOTTOM", 0, 0, loc("SL_RESET"), loc("SL_RESET_TT"));
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectivesYes, "BOTTOM", 0, 0,  loc("SL_ACCEPTANCE"));
	setTooltipForSameFrame(TRP3_NPCDialogFrameObjectivesNo, "BOTTOM", 0, 0, loc("SL_DECLINE"));
	TRP3_NPCDialogFrameObjectivesYes:SetScript("OnClick", AcceptQuest);
	TRP3_NPCDialogFrameObjectivesYes:SetScript("OnEnter", function(self)
		playSelfAnim(185);
		TRP3_RefreshTooltipForFrame(self);
	end);
	TRP3_NPCDialogFrameObjectivesNo:SetScript("OnClick", DeclineQuest);
	TRP3_NPCDialogFrameObjectivesNo:SetScript("OnEnter", function(self)
		playSelfAnim(186);
		TRP3_RefreshTooltipForFrame(self);
	end);
end
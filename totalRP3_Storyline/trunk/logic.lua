----------------------------------------------------------------------------------
-- Total RP 3
-- Storyline module
-- ---------------------------------------------------------------------------
-- Copyright 2015 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHECK VERSION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

assert(TRP3_API ~= nil, "Can't find Total RP 3 API.");
if TRP3_API.globals.version < 12 then
	local errorText = "Storyline module requires at least version 1.0.1 of Total RP 3.";
	message(errorText); -- For those not showing lua error
	error(errorText); -- Abord loading!
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STRUCTURES & VARIABLES
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DEBUG = false;

-- imports
local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local loc = TRP3_API.locale.getText;
local TRP3_NPCDialogFrame = TRP3_NPCDialogFrame;
local TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou = TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou;
local TRP3_NPCDialogFrameModelsMeFull = TRP3_NPCDialogFrameModelsMeFull;
local TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText = TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText;
local tostring, strsplit, wipe, pairs, tinsert = tostring, strsplit, wipe, pairs, tinsert;
local ChatTypeInfo, GetGossipText, GetGreetingText, GetProgressText = ChatTypeInfo, GetGossipText, GetGreetingText, GetProgressText;
local GetRewardText, GetQuestText = GetRewardText, GetQuestText;
local TRP3_ANIM_MAPPING, TRP3_DEFAULT_ANIM_MAPPING = TRP3_ANIM_MAPPING, TRP3_DEFAULT_ANIM_MAPPING;
local TRP3_ANIMATION_SEQUENCE_DURATION = TRP3_ANIMATION_SEQUENCE_DURATION;
local TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL = TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL;

local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;
local EVENT_INFO;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTILS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getQuestIcon(frequency, isRepeatable, isLegendary)
	if (isLegendary) then
		return "Interface\\GossipFrame\\AvailableLegendaryQuestIcon";
	elseif (frequency == LE_QUEST_FREQUENCY_DAILY or frequency == LE_QUEST_FREQUENCY_WEEKLY) then
		return "Interface\\GossipFrame\\DailyQuestIcon";
	elseif (isRepeatable) then
		return "Interface\\GossipFrame\\DailyActiveQuestIcon";
	else
		return "Interface\\GossipFrame\\AvailableQuestIcon";
	end
end

local function getQuestActiveIcon(isComplete)
	if (isComplete) then
		return "Interface\\GossipFrame\\ActiveQuestIcon";
	else
		return "Interface\\GossipFrame\\IncompleteQuestIcon";
	end
end

local function getQuestTriviality(isTrivial)
	if isTrivial then
		return " (|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20:20|t)";
	else
		return "";
	end
end

local function getQuestLevelColor(questLevel)
	return 0.9, 0.6, 0;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SOME ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getAnimationByModel(model, animationType)
	if model and TRP3_ANIM_MAPPING[model] and TRP3_ANIM_MAPPING[model][animationType] then
		return TRP3_ANIM_MAPPING[model][animationType];
	end
	return TRP3_DEFAULT_ANIM_MAPPING[animationType];
end

local function playAnimationDelay(model, sequence, duration, delay, token)
	if delay == 0 then
--		print("Playing: " .. sequence);
		model:SetAnimation(sequence);
	else
		model.token = token;
		C_Timer.After(delay, function()
			if model.token == token then
--				print("Playing: " .. sequence .. " (" .. duration .. "s)");
				model:SetAnimation(sequence);
			end
		end)
	end

	return delay + duration;
end

local DEFAULT_SEQUENCE_TIME = 4;

local function getDuration(model, sequence)
	sequence = tostring(sequence);
	if TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model] and TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model][sequence] then
		return TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model][sequence];
	end
	return TRP3_ANIMATION_SEQUENCE_DURATION[sequence] or DEFAULT_SEQUENCE_TIME;
end

local function playAndStand(sequence, duration)
	local token = Utils.str.id();
	TRP3_NPCDialogFrameModelsMe.token = token
	TRP3_NPCDialogFrameModelsMe:SetAnimation(sequence);
	C_Timer.After(duration, function()
		if TRP3_NPCDialogFrameModelsMe.token == token then
			TRP3_NPCDialogFrameModelsMe:SetAnimation(0);
		end
	end);
end

local function playSelfAnim(sequence)
	playAndStand(sequence, getDuration(TRP3_NPCDialogFrameModelsMe:GetModel(), sequence));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SELECTION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local GetNumGossipOptions, GetGossipOptions, SelectGossipOption = GetNumGossipOptions, GetGossipOptions, SelectGossipOption;
local GetNumGossipAvailableQuests, GetGossipAvailableQuests, SelectGossipAvailableQuest = GetNumGossipAvailableQuests, GetGossipAvailableQuests, SelectGossipAvailableQuest;
local TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2, TRP3_NPCDialogFrameChatOption3 = TRP3_NPCDialogFrameChatOption1, TRP3_NPCDialogFrameChatOption2, TRP3_NPCDialogFrameChatOption3;
local multiList = {};

local function selectFirstGossip()
	SelectGossipOption(1);
end

local function selectMultipleGossip(button)
	wipe(multiList);
	local gossips = { GetGossipOptions() };
	tinsert(multiList, { loc("SL_SELECT_DIALOG_OPTION"), nil });
	for i = 1, GetNumGossipOptions() do
		local gossip, gossipType = gossips[(i * 2) - 1], gossips[(i * 2)];
		tinsert(multiList, { "|TInterface\\GossipFrame\\" .. gossipType .. "GossipIcon:25:25|t" .. gossip, i });
	end
	displayDropDown(button, multiList, SelectGossipOption, 0, true);
end

local function selectFirstAvailable()
	SelectGossipAvailableQuest(1);
end

local function selectMultipleAvailable(button)
	wipe(multiList);
	local data = { GetGossipAvailableQuests() };
	tinsert(multiList, { loc("SL_SELECT_AVAILABLE_QUEST"), nil });
	for i = 1, GetNumGossipAvailableQuests() do
		local title, lvl, isTrivial, frequency, isRepeatable, isLegendary =
		data[(i * 6) - 5], data[(i * 6) - 4], data[(i * 6) - 3], data[(i * 6) - 2], data[(i * 6) - 1], data[(i * 6)];
		tinsert(multiList, { "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t" .. title .. getQuestTriviality(isTrivial), i });
	end
	displayDropDown(button, multiList, SelectGossipAvailableQuest, 0, true);
end

local function selectFirstActive()
	SelectGossipActiveQuest(1);
end

local function selectMultipleActive(button)
	wipe(multiList);
	local data = { GetGossipActiveQuests() };
	tinsert(multiList, { loc("SL_SELECT_AVAILABLE_QUEST"), nil });
	for i = 1, GetNumGossipActiveQuests() do
		local title, lvl, isTrivial, isComplete, isRepeatable = data[(i * 5) - 4], data[(i * 5) - 3], data[(i * 5) - 2], data[(i * 5) - 1], data[(i * 5)];
		tinsert(multiList, { "|T" .. getQuestActiveIcon(isComplete) .. ":20:20|t" .. title .. getQuestTriviality(isTrivial), i });
	end
	displayDropDown(button, multiList, SelectGossipActiveQuest, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CHAT_MARGIN = 70;
local OPTIONS_MARGIN, OPTIONS_TOP = 175, -175;
local gossipColor = "|cffffffff";
local TRP3_NPCDialogFrameChatNext = TRP3_NPCDialogFrameChatNext;
local setTooltipForSameFrame, setTooltipAll = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_API.ui.tooltip.setTooltipAll;

local function playText(textIndex)
	local animTab = TRP3_NPCDialogFrameModelsYou.animTab;
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
			animTab[#animTab + 1] = getAnimationByModel(TRP3_NPCDialogFrameModelsYou.model, finder:sub(1, 1));
			animTab[#animTab + 1] = 0;
		end);
	end

	if #animTab == 0 then
		animTab[1] = 0;
	end

	for index, sequence in pairs(animTab) do
		delay = playAnimationDelay(TRP3_NPCDialogFrameModelsYou, animTab[index],
			getDuration(TRP3_NPCDialogFrameModelsYou.model, animTab[index]), delay, textLineToken);
	end

	TRP3_NPCDialogFrameChat.start = 0;

	if #TRP3_NPCDialogFrameChat.texts > 1 then
		TRP3_NPCDialogFrameChatPrevious:Show();
	end

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

	if TRP3_NPCDialogFrameChat.event == "GOSSIP_SHOW" and textIndex == #TRP3_NPCDialogFrameChat.texts then
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

	if TRP3_NPCDialogFrameChat.event == "QUEST_DETAIL" and textIndex == #TRP3_NPCDialogFrameChat.texts then
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

	if TRP3_NPCDialogFrameChat.event == "QUEST_PROGRESS" and textIndex == #TRP3_NPCDialogFrameChat.texts then
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
	if TRP3_NPCDialogFrameChat.event == "QUEST_COMPLETE" and textIndex == #TRP3_NPCDialogFrameChat.texts then
		playSelfAnim(68);
		TRP3_NPCDialogFrameRewards:Show();
		setTooltipForSameFrame(TRP3_NPCDialogFrameRewardsItem, "BOTTOM", 0, 0);
		local xp = GetRewardXP();
		local money = GetCoinTextureString(GetRewardMoney());
		local TTReward = loc("SL_REWARD_MORE");
		local subTTReward = loc("SL_REWARD_MORE_SUB"):format(money, xp);
		TRP3_NPCDialogFrameRewards.itemLink = nil;
		TRP3_NPCDialogFrameRewardsItem:SetScript("OnClick", TRP3_NPCDialogFrameChat.eventInfo.finishMethod);

		if GetNumQuestChoices() > 1 then

		elseif GetNumQuestChoices() == 1 or GetNumQuestRewards() > 0 then
			local type = GetNumQuestChoices() == 1 and "choice" or "reward";
			local name, texture, numItems, quality, isUsable = GetQuestItemInfo(type, 1);
			local link = GetQuestItemLink(type, 1);

			TRP3_NPCDialogFrameRewards.itemLink = link;
			TRP3_NPCDialogFrameRewardsItemIcon:SetTexture(texture);
		else
			-- No item
			TTReward = REWARDS;
			TRP3_NPCDialogFrameRewardsItemIcon:SetTexture("Interface\\ICONS\\xp_icon");
		end

		setTooltipForSameFrame(TRP3_NPCDialogFrameRewardsItem, "BOTTOM", 0, -20, TTReward, subTTReward);
	end

	TRP3_NPCDialogFrameChat:SetHeight(TRP3_NPCDialogFrameChatText:GetHeight() + CHAT_MARGIN + 5);
end

local function playNext()
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
		playText(TRP3_NPCDialogFrameChat.currentIndex);
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
		TRP3_NPCDialogFrameDEBUG:Show();
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
		TRP3_NPCDialogFrameBanner:Show();
		TRP3_NPCDialogFrameTitle:SetText(eventInfo.titleGetter());
		if eventInfo.getTitleColor and eventInfo.getTitleColor() then
			TRP3_NPCDialogFrameTitle:SetTextColor(eventInfo.getTitleColor());
		else
			TRP3_NPCDialogFrameTitle:SetTextColor(0.95, 0.95, 0.95);
		end
	else
		TRP3_NPCDialogFrameTitle:SetText("");
		TRP3_NPCDialogFrameBanner:Hide();
	end

	TRP3_NPCDialogFrame.targetType = targetType;
	TRP3_NPCDialogFrame:Show();
	TRP3_NPCDialogFrameModelsYou.model = nil;
	TRP3_NPCDialogFrameModelsMe:SetLight(1, 0, 0, -1, -1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	TRP3_NPCDialogFrameModelsMe:SetCamera(1);
	TRP3_NPCDialogFrameModelsMe:SetFacing(.75);
	TRP3_NPCDialogFrameModelsMe:SetUnit("player");
	TRP3_NPCDialogFrameModelsMe.model = TRP3_NPCDialogFrameModelsMe:GetModel();
	TRP3_NPCDialogFrameModelsYou:SetLight(1, 0, 0, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	TRP3_NPCDialogFrameModelsYou:SetCamera(1);
	TRP3_NPCDialogFrameModelsYou:SetFacing(-.75);

	if UnitExists(targetType) and not UnitIsUnit("player", "npc") then
		TRP3_NPCDialogFrameModelsYou:SetUnit(targetType);
	else
		TRP3_NPCDialogFrameModelsMe:SetAnimation(520);
		TRP3_NPCDialogFrameModelsYou:SetModel("world/expansion04/doodads/pandaren/scroll/pa_scroll_10.mo3");
	end
	TRP3_NPCDialogFrameModelsYou.model = TRP3_NPCDialogFrameModelsYou:GetModel();

	if DEBUG and TRP3_NPCDialogFrameModelsYou.model then
		ChatFrame1EditBox:SetText(TRP3_NPCDialogFrameModelsYou.model:gsub("\\", "\\\\"));
	end

	fullText = fullText:gsub(LINE_FEED_CODE .. "+", "\n");
	fullText = fullText:gsub(WEIRD_LINE_BREAK, "\n");

	local texts = { strsplit("\n", fullText) };
	TRP3_NPCDialogFrameChat.texts = texts;
	TRP3_NPCDialogFrameChat.currentIndex = 0;
	TRP3_NPCDialogFrameChat.eventInfo = eventInfo;
	TRP3_NPCDialogFrameChat.event = event;

	TRP3_NPCDialogFrameChatPrevious:Hide();

	playNext();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ANIMATIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_TEXT_SPEED = 40;

local function onUpdateChatText(self, elapsed)
	if self.start then
		self.start = self.start + (elapsed * ANIMATION_TEXT_SPEED);
		if self.start >= TRP3_NPCDialogFrameChatText:GetText():len() then
			self.start = nil;
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(TRP3_NPCDialogFrameChatText:GetText():len(), 1);
		else
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(self.start, 30);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function registerEventStructure()
	EVENT_INFO = {
		["QUEST_GREETING"] = {
			text = GetGreetingText,
			cancelMethod = CloseQuest,
			titleGetter = GetTitleText,
		},
		["QUEST_DETAIL"] = {
			text = GetQuestText,
			cancelMethod = DeclineQuest,
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
					message("Please choose a reward from the original quest interface."); -- TODO: TEMP
				else
					GetQuestReward();
				end
			end,
			finishText = function()
				if GetNumQuestChoices() > 1 then
					return "Please choose a reward from the original quest interface."; -- TODO: TEMP
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
	}
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	ForceGossip = function() return true end

	-- Register locales
	for localeID, localeStructure in pairs(TRP3_StoryLine_LOCALE) do
		local locale = TRP3_API.locale.getLocale(localeID);
		for localeKey, text in pairs(localeStructure) do
			locale.localeContent[localeKey] = text;
		end
	end

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

	TRP3_NPCDialogFrameBG:SetDesaturated(true);
	TRP3_NPCDialogFrameChatNext:SetScript("OnClick", function()
		if TRP3_NPCDialogFrameChat.start and TRP3_NPCDialogFrameChat.start < TRP3_NPCDialogFrameChatText:GetText():len() then
			TRP3_NPCDialogFrameChat.start = TRP3_NPCDialogFrameChatText:GetText():len();
		else
			playNext();
		end
	end);
	TRP3_NPCDialogFrameChatPrevious:SetScript("OnClick", resetDialog);
	TRP3_NPCDialogFrameChat:SetScript("OnUpdate", onUpdateChatText);
	TRP3_NPCDialogFrameClose:SetScript("OnClick", closeDialog);
	TRP3_NPCDialogFrameRewardsItem:SetScale(1.5);

	TRP3_NPCDialogFrameModelsYou.animTab = {};
	TRP3_NPCDialogFrameModelsMe.animTab = {};

	TRP3_NPCDialogFrameModelsYou:SetScript("OnUpdate", function(self, elapsed)
		if self.spin then
			self.spinAngle = self.spinAngle - (elapsed / 2);
			self:SetFacing(self.spinAngle);
		end
	end);

	TRP3_NPCDialogFrameDebug:Hide();

	-- Showing events
	registerEventStructure();
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
	questButton:SetText(loc("SL_STORYLINE"));
	questButton:SetPoint("TOP");
	questButton:SetScript("OnClick", function()
		local questDescription = GetQuestLogQuestText();
		startDialog("none", questDescription, "REPLAY", EVENT_INFO["REPLAY"]);
	end);

	-- Resizing
	TRP3_NPCDialogFrameChatText:SetWidth(550);
	TRP3_NPCDialogFrameResizeButton.onResizeStop = function()
		TRP3_NPCDialogFrameChatText:SetWidth(TRP3_NPCDialogFrame:GetWidth() - 150);
		TRP3_NPCDialogFrameChat:SetHeight(TRP3_NPCDialogFrameChatText:GetHeight() + CHAT_MARGIN + 5);
	end;
end);
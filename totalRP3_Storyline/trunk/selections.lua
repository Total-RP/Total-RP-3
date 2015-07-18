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

local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local tostring, strsplit, wipe, pairs, tinsert = tostring, strsplit, wipe, pairs, tinsert;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local loc = TRP3_API.locale.getText;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CHOICE SELECTION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GetNumGossipOptions, GetGossipOptions, SelectGossipOption = GetNumGossipOptions, GetGossipOptions, SelectGossipOption;
local GetNumGossipAvailableQuests, GetGossipAvailableQuests, SelectGossipAvailableQuest = GetNumGossipAvailableQuests, GetGossipAvailableQuests, SelectGossipAvailableQuest;
local GetNumGossipActiveQuests, GetNumActiveQuests, GetNumAvailableQuests = GetNumGossipActiveQuests, GetNumActiveQuests, GetNumAvailableQuests;
local SelectAvailableQuest, SelectActiveQuest, SelectGossipActiveQuest = SelectAvailableQuest, SelectActiveQuest, SelectGossipActiveQuest;
local GetAvailableTitle, GetActiveTitle, GetAvailableQuestInfo, GetGossipActiveQuests = GetAvailableTitle, GetActiveTitle, GetAvailableQuestInfo, GetGossipActiveQuests;
local GetNumQuestChoices, GetQuestItemInfo, GetQuestItemLink, GetQuestReward = GetNumQuestChoices, GetQuestItemInfo, GetQuestItemLink, GetQuestReward;
local IsControlKeyDown, IsShiftKeyDown, IsAltKeyDown  = IsControlKeyDown, IsShiftKeyDown, IsAltKeyDown;

local getQuestIcon, getQuestActiveIcon = TRP3_StorylineAPI.getQuestIcon, TRP3_StorylineAPI.getQuestActiveIcon;
local getQuestTriviality = TRP3_StorylineAPI.getQuestTriviality;

local multiList = {};

function TRP3_StorylineAPI.selectFirstGossip()
	SelectGossipOption(1);
end

function TRP3_StorylineAPI.selectMultipleGossip(button)
	wipe(multiList);
	local gossips = { GetGossipOptions() };
	tinsert(multiList, { loc("SL_SELECT_DIALOG_OPTION"), nil });
	for i = 1, GetNumGossipOptions() do
		local gossip, gossipType = gossips[(i * 2) - 1], gossips[(i * 2)];
		tinsert(multiList, { "|TInterface\\GossipFrame\\" .. gossipType .. "GossipIcon:25:25|t" .. gossip, i });
	end
	displayDropDown(button, multiList, SelectGossipOption, 0, true);

end

local function dropdownRewardsClick(index, button)
	local itemLink = GetQuestItemLink("choice", index);

	if IsControlKeyDown() and IsAltKeyDown() then
		TRP3_NPCDialogFrameModelsMe:Dress();
	elseif IsControlKeyDown() then
		TRP3_NPCDialogFrameModelsMe:TryOn(itemLink);
	elseif IsAltKeyDown() then
		TRP3_NPCDialogFrameModelsMe:Undress();
		TRP3_NPCDialogFrameModelsMe:TryOn(itemLink);
	elseif IsShiftKeyDown() then
		HandleModifiedItemClick(itemLink);

		GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
		GameTooltip:SetQuestItem("choice", index);
		GameTooltip_ShowCompareItem(GameTooltip);
	else
		GetQuestReward(index);
		return;
	end
	TRP3_StorylineAPI.selectMultipleRewards(button);
end

function TRP3_StorylineAPI.selectMultipleRewards(button)
	wipe(multiList);
	tinsert(multiList, { "Select reward", nil });
	local rewards = {};
	for i = 1, GetNumQuestChoices() do
		local rewardName, rewardIcon = GetQuestItemInfo("choice", i);
		local itemLink = GetQuestItemLink("choice", i);
		tinsert(multiList, { "|T" .. rewardIcon .. "GossipIcon:25:25|t " .. itemLink .. "|r", i });
	end
	--displayDropDown(button, multiList, GetQuestReward, 0, true);
	displayDropDown(button, multiList, dropdownRewardsClick, 0, true);
end

function TRP3_StorylineAPI.selectFirstAvailable()
	SelectGossipAvailableQuest(1);
end

function TRP3_StorylineAPI.selectFirstGreetingAvailable()
	SelectAvailableQuest(1);
end
function TRP3_StorylineAPI.selectFirstGreetingActive()
	SelectActiveQuest(1);
end

function TRP3_StorylineAPI.selectMultipleAvailable(button)
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

function TRP3_StorylineAPI.selectFirstActive()
	SelectGossipActiveQuest(1);
end

function TRP3_StorylineAPI.selectMultipleActive(button)
	wipe(multiList);
	local data = { GetGossipActiveQuests() };
	tinsert(multiList, { loc("SL_SELECT_AVAILABLE_QUEST"), nil });
	for i = 1, GetNumGossipActiveQuests() do
		local title, lvl, isTrivial, isComplete, isRepeatable = data[(i * 5) - 4], data[(i * 5) - 3], data[(i * 5) - 2], data[(i * 5) - 1], data[(i * 5)];
		tinsert(multiList, { "|T" .. getQuestActiveIcon(isComplete) .. ":20:20|t" .. title .. getQuestTriviality(isTrivial), i });
	end
	displayDropDown(button, multiList, SelectGossipActiveQuest, 0, true);
end

function TRP3_StorylineAPI.selectMultipleActiveGreetings(button)
	wipe(multiList);

	local numActiveQuests = GetNumActiveQuests();
	tinsert(multiList, { loc("SL_SELECT_AVAILABLE_QUEST"), nil });

	for i = 1, numActiveQuests do
		local title, isComplete = GetActiveTitle(i);
		local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(i);
		tinsert(multiList, { "|T" .. getQuestActiveIcon(isComplete) .. ":20:20|t" .. title .. getQuestTriviality(isTrivial), i });
	end

	displayDropDown(button, multiList, SelectActiveQuest, 0, true);
end

function TRP3_StorylineAPI.selectMultipleAvailableGreetings(button)
	wipe(multiList);

	local numActiveQuests = GetNumActiveQuests();
	local numAvailableQuests = GetNumAvailableQuests();
	tinsert(multiList, { loc("SL_SELECT_AVAILABLE_QUEST"), nil });


	-- Available quests
	for i = 1, numAvailableQuests do
		local title, isComplete = GetAvailableTitle(i);
		local isTrivial, frequency, isRepeatable, isLegendary = GetAvailableQuestInfo(numActiveQuests + i);
		tinsert(multiList, { "|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t" .. title .. getQuestTriviality(isTrivial), i});
	end

	displayDropDown(button, multiList, SelectAvailableQuest, 0, true);
end
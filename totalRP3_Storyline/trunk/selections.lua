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

function TRP3_StorylineAPI.selectFirstAvailable()
	SelectGossipAvailableQuest(1);
end

function TRP3_StorylineAPI.selectFirstGreetingAvailable()
	SelectAvailableQuest(1);
end
function TRP3_StorylineAPI.selectFirstGreetingActive()
	SelectActiveQuest(1);
end

local selectionStrings = {};

local function getSelectionFontString(placeOn)
	local available;
	for _, button in pairs(selectionStrings) do
		if not button:IsShown() then
			available = button;
			break;
		end
	end
	if not available then
		available = CreateFrame("Button", "TRP3_StorylineChoiceString" .. #selectionStrings, TRP3_NPCDialogFrameGossipChoices, "TRP3_StorylineMultiChoiceButton");
		tinsert(selectionStrings, available);
	end
	available:Show();
	available:ClearAllPoints();
	available:SetPoint("LEFT", 10, 0);
	available:SetPoint("RIGHT", -10, 0);
	available:SetPoint("TOP", placeOn, "BOTTOM", 0, -5);
	return available;
end

function TRP3_StorylineAPI.selectMultipleAvailable(button)
	for _, button in pairs(selectionStrings) do
		button:Hide();
	end
	TRP3_API.ui.frame.configureHoverFrame(TRP3_NPCDialogFrameGossipChoices, button, "TOP");
	TRP3_NPCDialogFrameGossipChoices.Title:SetText(loc("SL_SELECT_AVAILABLE_QUEST"));
	local previous = TRP3_NPCDialogFrameGossipChoices.Title;
	local data = { GetGossipAvailableQuests() };
	local height = 40;
	for i = 1, GetNumGossipAvailableQuests() do
		local title, lvl, isTrivial, frequency, isRepeatable, isLegendary =
		data[(i * 6) - 5], data[(i * 6) - 4], data[(i * 6) - 3], data[(i * 6) - 2], data[(i * 6) - 1], data[(i * 6)];
		previous = getSelectionFontString(previous);
		previous.Text:SetText("|T" .. getQuestIcon(frequency, isRepeatable, isLegendary) .. ":20:20|t" .. title .. getQuestTriviality(isTrivial));
		previous:SetScript("OnClick", function(self)
			SelectGossipAvailableQuest(i);
		end);
		height = height + 25;
	end
	TRP3_NPCDialogFrameGossipChoices:SetHeight(height);
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
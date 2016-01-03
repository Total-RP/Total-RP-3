----------------------------------------------------------------------------------
-- Total RP 3: Quest log
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
local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local _G, assert, tostring, tinsert, wipe, pairs = _G, assert, tostring, tinsert, wipe, pairs;
local CreateFrame = CreateFrame;
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;
local Log = Utils.log;
local getCampaignClass, getClassDataSafe = TRP3_API.quest.getCampaignClass, TRP3_API.quest.getClassDataSafe;
local getQuestLog = TRP3_API.quest.getQuestLog;

local TRP3_QuestLogPage = TRP3_QuestLogPage;

local goToPage;
local TAB_CAMPAIGNS = "campaigns";
local TAB_QUESTS = "quests";
local TAB_STEPS = "steps";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CAMPAIGN
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onCampaignActionSelected(value, button)
	assert(button.campaignID, "No campaign ID in button");
	if value == 1 then
		TRP3_API.quest.resetCampaign(button.campaignID);
	elseif value == 2 then
		TRP3_API.quest.activateCampaign(button.campaignID);
	end
end

local function onCampaignButtonClick(button, mouseButton)
	assert(button.campaignID, "No campaign ID in button");
	local campaignID = button.campaignID;
	local _, campaignName = getClassDataSafe(getCampaignClass(campaignID));
	if mouseButton == "LeftButton" then
		goToPage(TAB_QUESTS, campaignID, campaignName, true);
	else
		local values = {};
		tinsert(values, {loc("QE_CAMPAIGN_RESET"), 1});
		tinsert(values, {loc("QE_CAMPAIGN_START_BUTTON"), 2});
		TRP3_API.ui.listbox.displayDropDown(button, values, onCampaignActionSelected, 0, true);
	end
end

local BASE_BKG = "Interface\\Garrison\\GarrisonUIBackground";

local function decorateCampaignButton(button, campaignID, campaignClass, onCampaignClick)
	local campaignIcon, campaignName, campaignDescription = getClassDataSafe(campaignClass);
	local image = (campaignClass.BA or EMPTY).IM;
	local range = (campaignClass.BA or EMPTY).RA;

	button:Show();
	button.name:SetText(campaignName);
	if image then
		button.bgImage:SetTexture(image);
		button.Icon:Hide();
	else
		button.bgImage:SetTexture(BASE_BKG);
		button.Icon:Show();
		TRP3_API.ui.frame.setupIconButton(button, campaignIcon);
	end

	if range then
		button.range:Show();
		button.range:SetText(range[1] .. "-" .. range[2]);
	else
		button.range:Hide();
	end

	if getQuestLog().currentCampaign == campaignID then
		button.current:Show();
		button:GetNormalTexture():SetVertexColor(0, 0.95, 0);
	else
		button.current:Hide();
		button:GetNormalTexture():SetVertexColor(1, 1, 1);
	end

	button.campaignID = campaignID;
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	button:SetScript("OnClick", onCampaignClick);
	button.Icon:SetVertexColor(0.7, 0.7, 0.7);
	button.current:SetText(loc("QE_CAMPAIGN_CURRENT"));
end

local function reattachCaimpacnButtons()
	local previous = TRP3_QuestLogPage.Campaign.slots[1];
	for index, slot in pairs(TRP3_QuestLogPage.Campaign.slots) do
		if index ~= 1 then
			slot:ClearAllPoints();
			slot:SetPoint("TOPLEFT", previous, "TOPRIGHT", 15, 0);
			previous = slot;
		end
	end
end

local function refreshCampaignList()
	for _, slot in pairs(TRP3_QuestLogPage.Campaign.slots) do
		slot:Hide();
	end

	local index = 1;
	for campaignID, campaign in pairs(TRP3_DB.campaign or EMPTY) do
		local button = TRP3_QuestLogPage.Campaign.slots[index];
		if not button then
			button = CreateFrame("Button", TRP3_QuestLogPage.Campaign:GetName() .. "Slot" .. index, TRP3_QuestLogPage.Campaign, "TRP3_CampaignButtonTemplate");
			tinsert(TRP3_QuestLogPage.Campaign.slots, button);
		end

		decorateCampaignButton(button, campaignID, campaign, onCampaignButtonClick);
		index = index + 1;
	end

	reattachCaimpacnButtons();
end

local function swapCampaignActivation(campaignID)
	TRP3_API.quest.activateCampaign(campaignID);
end

local function goToCampaignPage()
	NavBar_Reset(TRP3_QuestLogPage.navBar);
	refreshCampaignList();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- QUEST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local onQuestTabClick;

local function onQuestButtonEnter(button)
	local questClass = TRP3_API.quest.getQuestClass(button.campaignID, button.questID) or EMPTY;
	local questIcon, questName, questDescription = getClassDataSafe(questClass);
	local currentStep = button.questInfo.CS;
	local objectives = button.questInfo.OB;
	local stepText, objectivesText;

	if currentStep then
		if questClass.ST and questClass.ST[currentStep] then
			stepText = questClass.ST[currentStep].TX;
		else
			stepText = "|cffff0000Missing step information.|r" -- TODO: locals
		end
		stepText = loc("QE_QUEST_TT_STEP"):format(stepText);
	end

	if objectives then
		for objectiveID, state in pairs(objectives) do
			local objectiveClass = questClass.OB[objectiveID];
			if objectiveClass and state == false then
				if not objectivesText then
					objectivesText = "|cff00ff00- " .. objectiveClass.TX;
				else
					objectivesText = objectivesText .. "\n- " .. objectiveClass.TX;
				end
			end
		end
	end

	local finalText;
	if stepText and not objectivesText then finalText = stepText; end
	if objectivesText and not stepText then finalText = objectivesText; end
	if objectivesText and stepText then finalText = stepText .. "\n\n" .. objectivesText; end

	setTooltipForSameFrame(button, "RIGHT", 0, 5, questName, finalText);
	TRP3_RefreshTooltipForFrame(button);
end

local function decorateQuestButton(questFrame, campaignID, questID, questInfo, questClick)
	local questClass = TRP3_API.quest.getQuestClass(campaignID, questID);
	local questIcon, questName, questDescription = getClassDataSafe(questClass);

	TRP3_API.ui.frame.setupIconButton(questFrame, questIcon);
	questFrame.Name:SetText(questName);
	questFrame.InfoText:SetText(questDescription);
	questFrame:SetScript("OnClick", questClick);
	questFrame:SetScript("OnEnter", onQuestButtonEnter);
	questFrame.campaignID = campaignID;
	questFrame.questID = questID;
	questFrame.questInfo = questInfo;
end

local function refreshQuestList(campaignID)
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Current:Hide();
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Finished:Hide();
	TRP3_QuestLogPage.Quest.List.Empty:Show();
	local questFrames = TRP3_QuestLogPage.Quest.List.scroll.child.Content.frames;

	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Finished:Hide();
	for _, questFrame in pairs(questFrames) do
		questFrame:Hide();
		questFrame:ClearAllPoints();
	end

	local questLog = TRP3_API.quest.getQuestLog();
	local y = -50;
	if questLog[campaignID] then

		local index = 1;
		for questID, questInfo in pairs(questLog[campaignID]) do
			local questFrame = questFrames[index];
			if not questFrame then
				questFrame = CreateFrame("Button", TRP3_QuestLogPage.Quest.List:GetName() .. "Slot" .. index,
					TRP3_QuestLogPage.Quest.List.scroll.child.Content, "TRP3_QuestButtonTemplate");
				tinsert(questFrames, questFrame);
			end

			local _, questName, _ = getClassDataSafe(TRP3_API.quest.getQuestClass(campaignID, questID));
			decorateQuestButton(questFrame, campaignID, questID, questInfo, function()
				goToPage(TAB_STEPS, campaignID, questID, questName);
			end);
			questFrame:SetPoint("TOPLEFT", 50, y);
			questFrame:Show();

			index = index + 1;
			y = y - 60;
		end

		if index > 1 then
			TRP3_QuestLogPage.Quest.List.Empty:Hide();
			TRP3_QuestLogPage.Quest.List.scroll.child.Content.Current:Show();
		else
			TRP3_QuestLogPage.Quest.List.Empty:SetText(loc("QE_CAMPAIGN_NOQUEST"));
		end
	else
		TRP3_QuestLogPage.Quest.List.Empty:SetText(loc("QE_CAMPAIGN_UNSTARTED"));
	end
end

local function refreshQuestVignette(campaignID)
	local campaignClass = getCampaignClass(campaignID);
	decorateCampaignButton(TRP3_QuestLogPage.Quest.Campaign.Vignette, campaignID, campaignClass, function()
		swapCampaignActivation(campaignID);
		refreshQuestVignette(campaignID);
		refreshQuestList(campaignID);
	end);
	TRP3_QuestLogPage.Quest.Campaign.Text.scroll.child.Desc.Text:SetText((campaignClass.BA or EMPTY).DE or "");
end

local function goToQuestPage(campaignID, campaignName, createTab)
	if createTab then
		NavBar_AddButton(TRP3_QuestLogPage.navBar, {id = campaignID, name = campaignName, OnClick = onQuestTabClick});
	end
	refreshQuestList(campaignID);
	refreshQuestVignette(campaignID);
end

function onQuestTabClick(button)
	goToPage(TAB_QUESTS, button.id, button.name, false);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STEPS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local stepHTML = TRP3_QuestLogPage.Step.Objectives.Text.scroll.child.HTML;

local function refreshStepVignette(campaignID, questID, questInfo)
	decorateQuestButton(TRP3_QuestLogPage.Step.Title, campaignID, questID, questInfo);
end

local function refreshStepContent()
	local html = "";

	html = html .. "{h1}Overview{/h1}";

	html = html .. "{h1}Objectives{/h1}";

	html = html .. "{h1}Previous steps{/h1}";


	stepHTML.html = Utils.str.toHTML(html);
	stepHTML:SetText(stepHTML.html);
end

local function goToStepPage(campaignID, questID, questName)
	NavBar_AddButton(TRP3_QuestLogPage.navBar, {id = questID, name = questName});

	local questLog = TRP3_API.quest.getQuestLog();
	assert(questLog[campaignID] and questLog[campaignID][questID], "Trying to goToStepPage from an unstarted campaign or quest");

	refreshStepVignette(campaignID, questID, questLog[campaignID][questID]);
	refreshStepContent(campaignID, questID, questLog[campaignID][questID]);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NAVIGATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local currentPage;

function goToPage(page, ...)
	currentPage = page;
	TRP3_QuestLogPage.Campaign:Hide();
	TRP3_QuestLogPage.Quest:Hide();
	TRP3_QuestLogPage.Step:Hide();

	if page == TAB_CAMPAIGNS then
		TRP3_QuestLogPage.Campaign:Show();
		goToCampaignPage(...)
	elseif page == TAB_QUESTS then
		TRP3_QuestLogPage.Quest:Show();
		goToQuestPage(...)
	elseif page == TAB_STEPS then
		TRP3_QuestLogPage.Step:Show();
		goToStepPage(...)
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function init()

	-- Quest log page and menu
	TRP3_API.navigation.menu.registerMenu({
		id = "main_14_player_quest",
		text = QUEST_LOG,
		onSelected = function()
			TRP3_API.navigation.page.setPage("player_quest");
		end,
		isChildOf = "main_10_player",
	});

	TRP3_API.navigation.page.registerPage({
		id = "player_quest",
		frame = TRP3_QuestLogPage,
		onPagePostShow = function()
			goToPage(TAB_CAMPAIGNS);
		end
	});

	-- Quest log button on target bar
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		if TRP3_API.target then
			TRP3_API.target.registerButton({
				id = "aa_player_e_quest",
				onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
				configText = QUEST_LOG,
				condition = function(_, unitID)
					return unitID == Globals.player_id;
				end,
				onClick = function(_, _, button, _)
					if button == "LeftButton" then
						TRP3_API.navigation.openMainFrame();
						TRP3_API.navigation.menu.selectMenu("main_14_player_quest");
					end
				end,
				tooltip = QUEST_LOG,
				tooltipSub = loc("IT_INV_SHOW_CONTENT"),
				icon = "achievement_quests_completed_06"
			});
		end
	end);

	-- Tab bar init
	local homeData = {
		name = loc("QE_CAMPAIGNS"),
		OnClick = function()
			goToPage(TAB_CAMPAIGNS);
		end,
	}
	TRP3_QuestLogPage.navBar.home:SetWidth(110);
	NavBar_Initialize(TRP3_QuestLogPage.navBar, "NavButtonTemplate", homeData, TRP3_QuestLogPage.navBar.home, TRP3_QuestLogPage.navBar.overflow);

	-- Campaign page init
	TRP3_API.ui.frame.setupFieldPanel(TRP3_QuestLogPage.Campaign, loc("QE_CAMPAIGN_LIST"), 200);
	TRP3_QuestLogPage.Campaign.slots = {};
	tinsert(TRP3_QuestLogPage.Campaign.slots, TRP3_QuestLogPage.Campaign.scroll.child.Slot1);

	-- Quest page init
	TRP3_API.ui.frame.setupFieldPanel(TRP3_QuestLogPage.Quest.Campaign, loc("QE_CAMPAIGN"), 150);
	TRP3_API.ui.frame.setupFieldPanel(TRP3_QuestLogPage.Quest.List, loc("QE_QUEST_LIST"), 200);
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Current:SetText(loc("QE_STEP_LIST_CURRENT"));
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Finished:SetText(loc("QE_STEP_LIST_FINISHED"));
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.frames = {};

	-- Step page init
	TRP3_QuestLogPage.Step.Title.Name:SetTextColor(0.1, 0.1, 0.1);
	TRP3_QuestLogPage.Step.Title.InfoText:SetTextColor(0.1, 0.1, 0.1);
	TRP3_API.ui.frame.setupFieldPanel(TRP3_QuestLogPage.Step.Objectives, loc("QE_QUEST_OBJ_AND_HIST"), 200);
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerwidth, containerHeight)
		stepHTML:SetSize(containerwidth - 150, 5);
		stepHTML:SetText(stepHTML.html);
	end);
end
TRP3_API.quest.questLogInit = init;
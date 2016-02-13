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
local getClass, getClassDataSafe, getClassesByType = TRP3_API.extended.getClass, TRP3_API.extended.getClassDataSafe, TRP3_API.extended.getClassesByType;
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
	local _, campaignName = getClassDataSafe(getClass(campaignID));
	if mouseButton == "LeftButton" then
		goToPage(false, TAB_QUESTS, campaignID, campaignName);
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
	for campaignID, campaign in pairs(getClassesByType(TRP3_DB.types.CAMPAIGN) or EMPTY) do
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

local function goToCampaignPage(skipButton)
	if not skipButton then
		NavBar_Reset(TRP3_QuestLogPage.navBar);
	end
	refreshCampaignList();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- QUEST
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local onQuestTabClick;

local function onQuestButtonEnter(button)
	local questClass = getClass(button.campaignID, button.questID) or EMPTY;
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
	local questClass = getClass(campaignID, questID);
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

	local campaignLog = getQuestLog()[campaignID];
	local y = -50;
	if campaignLog then

		local index = 1;
		for questID, questInfo in pairs(campaignLog.QUEST) do
			local questFrame = questFrames[index];
			if not questFrame then
				questFrame = CreateFrame("Button", TRP3_QuestLogPage.Quest.List:GetName() .. "Slot" .. index,
					TRP3_QuestLogPage.Quest.List.scroll.child.Content, "TRP3_QuestButtonTemplate");
				tinsert(questFrames, questFrame);
			end

			local _, questName, _ = getClassDataSafe(getClass(campaignID, questID));
			decorateQuestButton(questFrame, campaignID, questID, questInfo, function()
				goToPage(false, TAB_STEPS, campaignID, questID, questName);
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
	local campaignClass = getClass(campaignID);
	decorateCampaignButton(TRP3_QuestLogPage.Quest.Campaign.Vignette, campaignID, campaignClass, function()
		swapCampaignActivation(campaignID);
		refreshQuestVignette(campaignID);
		refreshQuestList(campaignID);
	end);
	TRP3_QuestLogPage.Quest.Campaign.Text.scroll.child.Desc.Text:SetText((campaignClass.BA or EMPTY).DE or "");
end

local function goToQuestPage(skipButton, campaignID, campaignName)
	if not skipButton then
		NavBar_AddButton(TRP3_QuestLogPage.navBar, {id = campaignID, name = campaignName, OnClick = onQuestTabClick});
	end
	refreshQuestList(campaignID);
	refreshQuestVignette(campaignID);
end

function onQuestTabClick(button)
	goToPage(true, TAB_QUESTS, button.id, button.name);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STEPS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local stepHTML = TRP3_QuestLogPage.Step.Objectives.Text.scroll.child.HTML;

local function refreshStepVignette(campaignID, questID, questInfo)
	decorateQuestButton(TRP3_QuestLogPage.Step.Title, campaignID, questID, questInfo);
end

local function refreshStepContent(campaignID, questID, questInfo)
	local questClass = getClass(campaignID, questID);
	local questIcon, questName, questDescription = getClassDataSafe(questClass);
	local currentStep = questInfo.CS;
	local objectives = questInfo.OB;
	local html = "";

	if currentStep then
		local currentStepText;
		if questClass.ST and questClass.ST[currentStep] then
			currentStepText = questClass.ST[currentStep].TX;
		else
			currentStepText = "|cffff0000Missing step information.|r" -- TODO: locals
		end
		html = html .. ("{h2}%s{/h2}"):format(OVERVIEW);
		html = html .. ("\n%s\n\n"):format(currentStepText);
	end

	if objectives and Utils.table.size(objectives) > 0 then
		local objectivesText = "";
		for objectiveID, state in pairs(objectives) do
			local objectiveClass = questClass.OB[objectiveID];
			local objText = UNKNOWN;
			if objectiveClass then
				if state == true then
					objText = "|TInterface\\Scenarios\\ScenarioIcon-Check:12:12|t " .. objectiveClass.TX;
				else
					objText = "|TInterface\\GossipFrame\\IncompleteQuestIcon:12:12|t " .. objectiveClass.TX;
				end
			end
			objectivesText = objectivesText .. "{p}" .. objText .. "{/p}";
		end
		html = html .. ("{h2}%s{/h2}"):format(QUEST_OBJECTIVES);
		html = html .. ("\n%s"):format(objectivesText);
	end

	if questInfo.PS and Utils.table.size(questInfo.PS) > 0 then
		html = html .. ("\n{img:%s:256:32}\n"):format("Interface\\QUESTFRAME\\UI-HorizontalBreak");

		local previousStepText = "";
		for _, stepID in pairs(questInfo.PS) do
			local stepClass = getClass(campaignID, questID, stepID);
			if stepClass and stepClass.DX then
				previousStepText = previousStepText .. stepClass.DX;
			end
		end

		html = html .. ("{h2}%s{/h2}"):format("Previous steps");
		html = html .. ("\n%s\n"):format(previousStepText);
	end

	stepHTML.html = Utils.str.toHTML(html);
	stepHTML:SetText(stepHTML.html);
end

local function goToStepPage(skipButton, campaignID, questID, questName)
	if not skipButton then
		NavBar_AddButton(TRP3_QuestLogPage.navBar, {id = questID, name = questName});
	end

	local campaignLog = getQuestLog()[campaignID];
	assert(campaignLog and campaignLog.QUEST[questID], "Trying to goToStepPage from an unstarted campaign or quest: " .. tostring(questID));

	refreshStepVignette(campaignID, questID, campaignLog.QUEST[questID]);
	refreshStepContent(campaignID, questID, campaignLog.QUEST[questID]);
end

local function initStepFrame()
	TRP3_QuestLogPage.Step.Title.Name:SetTextColor(0.1, 0.1, 0.1);
	TRP3_QuestLogPage.Step.Title.InfoText:SetTextColor(0.1, 0.1, 0.1);
	TRP3_API.ui.frame.setupFieldPanel(TRP3_QuestLogPage.Step.Objectives, loc("QE_QUEST_OBJ_AND_HIST"), 200);
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerwidth, containerHeight)
		stepHTML:SetSize(containerwidth - 150, 5);
		stepHTML:SetText(stepHTML.html);
	end);

	stepHTML:SetFontObject("p", GameTooltipHeader);
	stepHTML:SetTextColor("p", 0.2824, 0.0157, 0.0157);
	stepHTML:SetShadowOffset("p", 0, 0)

	stepHTML:SetFontObject("h1", DestinyFontHuge);
	stepHTML:SetTextColor("h1", 0, 0, 0);

	stepHTML:SetFontObject("h2", QuestFont_Huge);
	stepHTML:SetTextColor("h2", 0, 0, 0);

	stepHTML:SetFontObject("h3", GameFontNormalLarge);
	stepHTML:SetTextColor("h3", 1, 1, 1);

end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NAVIGATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function goToPage(skipButton, page,  ...)
	TRP3_QuestLogPage.currentPage = page;
	TRP3_QuestLogPage.args = {...};
	TRP3_QuestLogPage.Campaign:Hide();
	TRP3_QuestLogPage.Quest:Hide();
	TRP3_QuestLogPage.Step:Hide();

	if page == TAB_CAMPAIGNS then
		TRP3_QuestLogPage.Campaign:Show();
		goToCampaignPage(skipButton, ...)
	elseif page == TAB_QUESTS then
		TRP3_QuestLogPage.Quest:Show();
		goToQuestPage(skipButton, ...)
	elseif page == TAB_STEPS then
		TRP3_QuestLogPage.Step:Show();
		goToStepPage(skipButton, ...)
	end
end

local getCurrentPageID = TRP3_API.navigation.page.getCurrentPageID;
local function refreshLog()
	if getCurrentPageID() == "player_quest" then
		goToPage(true, TRP3_QuestLogPage.currentPage, unpack(TRP3_QuestLogPage.args));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function init()

	Events.listenToEvent(Events.CAMPAIGN_REFRESH_LOG, refreshLog);

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
			goToPage(false, TAB_CAMPAIGNS);
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
			goToPage(false, TAB_CAMPAIGNS);
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
	initStepFrame();
end
TRP3_API.quest.questLogInit = init;
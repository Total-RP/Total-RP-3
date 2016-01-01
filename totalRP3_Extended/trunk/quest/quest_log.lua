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

local function onCampaignOpen(button)
	local campaignID = button.campaignID;
	local _, campaignName = getClassDataSafe(getCampaignClass(campaignID));
	goToPage(TAB_QUESTS, campaignID, campaignName);
end

local BASE_BKG = "Interface\\Garrison\\GarrisonUIBackground";

local function decorateCampaignButton(button, campaignID, campaignClass, onCampaignOpen)
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
	button:SetScript("OnClick", onCampaignOpen);
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

		decorateCampaignButton(button, campaignID, campaign, onCampaignOpen);
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

local function decorateQuestButton(questFrame, campaignID, questID, questInfo)
	local questClass = TRP3_API.quest.getQuestClass(campaignID, questID);
	local questIcon, questName, questDescription = getClassDataSafe(questClass);

	TRP3_API.ui.frame.setupIconButton(questFrame, questIcon);
	questFrame.Name:SetText(questName);
	questFrame.InfoText:SetText(questDescription);
	questFrame:SetScript("OnClick", function(self)

	end);
end

local function refreshQuestList(campaignID)
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Current:SetText("Available quests");
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.Finished:SetText("Finished quests");

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

			decorateQuestButton(questFrame, campaignID, questID, questInfo);
			questFrame:SetPoint("TOPLEFT", 50, y);
			questFrame:Show();

			index = index + 1;
			y = y - 50;
		end
	end
end

local function refreshQuestVignette(campaignID)
	local campaignClass = getCampaignClass(campaignID);
	decorateCampaignButton(TRP3_QuestLogPage.Quest.Campaign.Vignette, campaignID, campaignClass, function()
		swapCampaignActivation(campaignID);
		refreshQuestVignette(campaignID);
	end);
	TRP3_QuestLogPage.Quest.Campaign.Text.scroll.child.Desc.Text:SetText((campaignClass.BA or EMPTY).DE or "");
end

local function goToQuestPage(campaignID, campaignName)
	NavBar_AddButton(TRP3_QuestLogPage.navBar, {id = campaignID, name = campaignName});
	refreshQuestList(campaignID);
	refreshQuestVignette(campaignID);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STEPS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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
	TRP3_QuestLogPage.Quest.List.scroll.child.Content.frames = {};
end
TRP3_API.quest.questLogInit = init;
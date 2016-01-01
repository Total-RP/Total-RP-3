----------------------------------------------------------------------------------
-- Total RP 3: Campaign system
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
local CAMPAIGN_DB = TRP3_DB.campaign;
local EMPTY = TRP3_API.globals.empty;
local tostring, assert, pairs, wipe, tinsert = tostring, assert, pairs, wipe, tinsert;
local loc = TRP3_API.locale.getText;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local Log = Utils.log;

local TRP3_QuestLogPage = TRP3_QuestLogPage;

local playerQuestLog;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTILS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.quest.getQuestLog()
	-- Structures
	local playerProfile = TRP3_API.profile.getPlayerCurrentProfile();
	if not playerProfile.questlog then
		playerProfile.questlog = {};
	end
	return playerProfile.questlog;
end

local function getCampaignClass(campaignID)
	return CAMPAIGN_DB[campaignID];
end
TRP3_API.quest.getCampaignClass = getCampaignClass;

local function getClassDataSafe(class)
	local icon = "TEMP";
	local name = UNKNOWN;
	local description = "";
	if class and class.BA then
		if class.BA.IC then
			icon = class.BA.IC;
		end
		if class.BA.NA then
			name = class.BA.NA;
		end
		if class.BA.DE then
			description = class.BA.DE;
		end
	end
	return icon, name, description;
end
TRP3_API.quest.getClassDataSafe = getClassDataSafe;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- HANDLERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local campaignHandlers = {};

local function onCampaignCallback(campaignID, campaignClass, scriptID, ...)
	if campaignClass and campaignClass.SC and campaignClass.SC[scriptID] then
		local retCode = TRP3_API.script.executeClassScript(scriptID, campaignClass.SC, {campaignClass = campaignClass, campaignLog = playerQuestLog[campaignID]});
	end
end

local function clearCampaignHandlers()
	for handlerID, _ in pairs(campaignHandlers) do
		Utils.event.unregisterHandler(handlerID);
	end
	TRP3_API.quest.clearQuestHandlers();
end

local function activateCampaignHandlers(campaignID, campaignClass)
	for eventID, scriptID in pairs(campaignClass.HA or EMPTY) do
		local handlerID = Utils.event.registerHandler(eventID, function(...)
			onCampaignCallback(campaignID, campaignClass, scriptID, ...);
		end);
		campaignHandlers[handlerID] = eventID;
	end
	-- Active handlers for kown quests
	for questID, questClass in pairs(campaignClass.QE or EMPTY) do
		if playerQuestLog[campaignID][questID] then
			TRP3_API.quest.activateQuestHandlers(campaignID, campaignClass, questID, questClass);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CAMPAIGN API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function deactivateCurrentCampaign(skipMessage)
	if playerQuestLog.currentCampaign then
		if not skipMessage then
			Utils.message.displayMessage(loc("QE_CAMPAIGN_PAUSE"), Utils.message.type.CHAT_FRAME);
		end
		playerQuestLog.currentCampaign = nil;
	end
	clearCampaignHandlers();
end
TRP3_API.quest.deactivateCurrentCampaign = deactivateCurrentCampaign;

local function activateCampaign(campaignID, force)

	local oldCurrent = playerQuestLog.currentCampaign;

	-- First, deactivate current campaign
	deactivateCurrentCampaign(force);

	if not force and oldCurrent == campaignID then
		return;
	end

	local campaignClass = getCampaignClass(campaignID);
	local _, campaignName = getClassDataSafe(campaignClass);

	local init;
	if not playerQuestLog[campaignID] then
		init = true;

		-- If not already started
		playerQuestLog[campaignID] = {};
		Utils.message.displayMessage(loc("QE_CAMPAIGN_START"):format(campaignName), Utils.message.type.CHAT_FRAME);
	else
		-- If already started, just resuming
		Utils.message.displayMessage(loc("QE_CAMPAIGN_RESUME"):format(campaignName), Utils.message.type.CHAT_FRAME);
	end

	activateCampaignHandlers(campaignID, campaignClass);

	playerQuestLog.currentCampaign = campaignID;

	if init then
		-- Initial script
		if campaignClass.OS then
			local retCode = TRP3_API.script.executeClassScript(campaignClass.OS, campaignClass.SC,
				{campaignID = campaignID, campaignClass = campaignClass, campaignLog = playerQuestLog[campaignID]});
		end
	end
end
TRP3_API.quest.activateCampaign = activateCampaign;

local function resetCampaign(campaignID)
	if playerQuestLog[campaignID] then
		wipe(playerQuestLog[campaignID]);
		playerQuestLog[campaignID] = nil;
	end
	if playerQuestLog.currentCampaign == campaignID then
		activateCampaign(campaignID, true);
	end
end
TRP3_API.quest.resetCampaign = resetCampaign;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- /run TRP3_API.quest.activateCampaign("myFirstCampaign");
-- /run TRP3_API.quest.deactivateCurrentCampaign();
-- /run TRP3_API.quest.resetCampaign("myFirstCampaign");
-- /run TRP3_API.utils.table.dump(TRP3_API.quest.getQuestLog());

local function init()
	local refreshQuestLog = function()
		playerQuestLog = TRP3_API.quest.getQuestLog();
	end
	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, refreshQuestLog);
	refreshQuestLog();

	-- Effect and operands
	TRP3_API.script.registerEffects(TRP3_API.quest.EFFECTS);

	-- Resuming last campaign
	if playerQuestLog.currentCampaign then
		activateCampaign(playerQuestLog.currentCampaign, true); -- Force reloading the current campaign
	end
end
TRP3_API.quest.campaignInit = init;
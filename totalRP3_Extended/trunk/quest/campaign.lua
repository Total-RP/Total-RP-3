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
local tostring, assert, pairs = tostring, assert, pairs;
local loc = TRP3_API.locale.getText;

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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- HANDLERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local campaignHandlers = {};

local function onCampaignCallback(campaignID, campaignClass, scriptID, ...)
	if campaignClass and campaignClass.SC and campaignClass.SC[scriptID] then
		local retCode = TRP3_API.script.executeClassScript(scriptID, campaignClass.SC, {class = campaignClass, campaignLog = playerQuestLog[campaignID]});
	end
end

local function clearCampaignHandlers()
	for handlerID, _ in pairs(campaignHandlers) do
		Utils.event.unregisterHandler(handlerID);
	end
end

local function activateCampaignHandlers(campaignID, campaignClass)
	for eventID, scriptID in pairs(campaignClass.HA or EMPTY) do
		local handlerID = Utils.event.registerHandler(eventID, function(...)
			onCampaignCallback(campaignID, campaignClass, scriptID, ...);
		end);
		campaignHandlers[handlerID] = eventID;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- CAMPAIGN API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function deactivateCampaign(campaignID)
	if campaignID then
		assert(playerQuestLog.currentCampaign == campaignID, ("Campaign %s is not the current campaign."):format(campaignID));
		playerQuestLog.currentCampaign = nil;
	end
	clearCampaignHandlers();
end

local function activateCampaign(campaignID)

	-- First, deactivate current campaign
	deactivateCampaign(playerQuestLog.currentCampaign);

	local campaignClass = getCampaignClass(campaignID);
	assert(campaignClass, "Unknown campaign Id: " .. tostring(campaignID));

	local campaignName = (campaignClass.BA or EMPTY).NA or UNKNOWN;

	if not playerQuestLog[campaignID] then
		-- If not already started
		playerQuestLog[campaignID] = {};
		Utils.message.displayMessage(loc("QE_CAMPAIGN_START"):format(campaignName), Utils.message.type.CHAT_FRAME);

		-- Initial script
		if campaignClass.OS then
			local retCode = TRP3_API.script.executeClassScript(campaignClass.OS, campaignClass.SC, {class = campaignClass, campaignLog = playerQuestLog[campaignID]});
		end

	else
		-- If already started, just resuming
		Utils.message.displayMessage(loc("QE_CAMPAIGN_RESUME"):format(campaignName), Utils.message.type.CHAT_FRAME);
	end

	activateCampaignHandlers(campaignID, campaignClass);

	playerQuestLog.currentCampaign = campaignID;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function init()
	local refreshQuestLog = function()
		playerQuestLog = TRP3_API.quest.getQuestLog();
	end
	Events.listenToEvent(Events.REGISTER_PROFILES_LOADED, refreshQuestLog);
	refreshQuestLog();
end
TRP3_API.quest.campaignInit = init;
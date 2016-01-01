----------------------------------------------------------------------------------
-- Total RP 3: Quest system
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
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;
local Log = Utils.log;
local getCampaignClass = TRP3_API.quest.getCampaignClass;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- HANDLERS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local questHandlers = {};

local function onQuestCallback(campaignID, campaignClass, questID, questClass, scriptID, ...)
	if questClass and questClass.SC and questClass.SC[scriptID] then
		local playerQuestLog = TRP3_API.quest.getQuestLog();
		local retCode = TRP3_API.script.executeClassScript(scriptID, questClass.SC,
			{
				campaignID = campaignID, campaignClass = campaignClass, campaignLog = playerQuestLog[campaignID],
				questID = questID, questClass = questClass, questLog = playerQuestLog[campaignID][questID],
			});
	end
end

local function clearQuestHandlers()
	for handlerID, _ in pairs(questHandlers) do
		Utils.event.unregisterHandler(handlerID);
	end
end
TRP3_API.quest.clearQuestHandlers = clearQuestHandlers;

local function activateQuestHandlers(campaignID, campaignClass, questID, questClass)
	for eventID, scriptID in pairs(questClass.HA or EMPTY) do
		local handlerID = Utils.event.registerHandler(eventID, function(...)
			onQuestCallback(campaignID, campaignClass, questID, questClass, scriptID, ...);
		end);
		questHandlers[handlerID] = eventID;
	end
end
TRP3_API.quest.activateQuestHandlers = activateQuestHandlers;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- QUEST API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local CAMPAIGN_DB = TRP3_DB.campaign;

local function getQuestClass(campaignID, questID)
	if CAMPAIGN_DB[campaignID] and CAMPAIGN_DB[campaignID].QE[questID] then
		return CAMPAIGN_DB[campaignID].QE[questID];
	end
end
TRP3_API.quest.getQuestClass = getQuestClass;

local function startQuest(campaignID, questID)
	assert(campaignID and questID, "Illegal args");

	local playerQuestLog = TRP3_API.quest.getQuestLog();
	if playerQuestLog.currentCampaign == campaignID then
		local campaignLog = playerQuestLog[campaignID];
		assert(campaignLog, "Trying to start quest from an unstarted campaign.");
		if not campaignLog[questID] then
			Log.log("Starting quest " .. campaignID .. " " .. questID);

			local campaignClass = getCampaignClass(campaignID);
			local questClass = getQuestClass(campaignID, questID);

			if not campaignClass or not questClass then
				print("CAN'T FIND CAMPAIGN OR QUEST"); -- TODO: locale / message
				return;
			end

			campaignLog[questID] = {
				OB = {},
			};

			local questName = (questClass.BA or EMPTY).NA or UNKNOWN;
			Utils.message.displayMessage(loc("QE_QUEST_START"):format(questName), Utils.message.type.CHAT_FRAME);

			-- Initial script
			if questClass.OS then
				local retCode = TRP3_API.script.executeClassScript(questClass.OS, questClass.SC,
					{
						campaignID = campaignID, campaignClass = campaignClass, campaignLog = playerQuestLog[campaignID],
						questID = questID, questClass = questClass, questLog = playerQuestLog[campaignID][questID],
					});
			end

			activateQuestHandlers(campaignID, campaignClass, questID, questClass);
		else
			Log.log("Can't start quest because already starterd " .. campaignID .. " " .. questID);
		end
	else
		Log.log("Can't start quest because current campaign is not " .. campaignID);
	end
end
TRP3_API.quest.startQuest = startQuest;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStart()
	TRP3_API.quest.campaignInit();
	TRP3_API.quest.questLogInit();
end

local MODULE_STRUCTURE = {
	["name"] = "Quest",
	["description"] = "Quest system",
	["version"] = 1.000,
	["id"] = "trp3_quest",
	["onStart"] = onStart,
	["minVersion"] = 12,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
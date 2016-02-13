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
local getClass = TRP3_API.extended.getClass;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- QUEST API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local questHandlers = {};

local function onQuestCallback(campaignID, campaignClass, questID, questClass, scriptID, ...)
	if questClass and questClass.SC and questClass.SC[scriptID] then
		local playerQuestLog = TRP3_API.quest.getQuestLog();
		local retCode = TRP3_API.script.executeClassScript(scriptID, questClass.SC,
			{
				campaignID = campaignID, campaignClass = campaignClass, campaignLog = playerQuestLog[campaignID],
				questID = questID, questClass = questClass, questLog = playerQuestLog[campaignID].QUEST[questID],
			});
	end
end

local function clearAllQuestHandlers()
	for _, struct in pairs(questHandlers) do
		for handlerID, _ in pairs(struct) do
			Utils.event.unregisterHandler(handlerID);
		end
	end
	wipe(questHandlers);
end
TRP3_API.quest.clearAllQuestHandlers = clearAllQuestHandlers;

local function clearQuestHandlers(questID)
	if questHandlers[questID] then
		for handlerID, _ in pairs(questHandlers[questID]) do
			Utils.event.unregisterHandler(handlerID);
		end
		wipe(questHandlers[questID]);
		questHandlers[questID] = nil;
	end
end
TRP3_API.quest.clearQuestHandlers = clearQuestHandlers;

local function activateQuestHandlers(campaignID, campaignClass, questID, questClass)
	for eventID, scriptID in pairs(questClass.HA or EMPTY) do
		local handlerID = Utils.event.registerHandler(eventID, function(...)
			onQuestCallback(campaignID, campaignClass, questID, questClass, scriptID, ...);
		end);
		if not questHandlers[questID] then
			questHandlers[questID] = {};
		end
		questHandlers[questID][handlerID] = eventID;
	end
end
TRP3_API.quest.activateQuestHandlers = activateQuestHandlers;

local function startQuest(campaignID, questID)
	-- Checks
	assert(campaignID and questID, "Illegal args");
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	assert(playerQuestLog.currentCampaign == campaignID, ("Can't start quest because current campaign (%s) is not %s."):format(tostring(playerQuestLog.currentCampaign), campaignID));
	local campaignLog = playerQuestLog[campaignID];
	assert(campaignLog, "Trying to start quest from an unstarted campaign.");

	if not campaignLog.QUEST[questID] then
		Log.log("Starting quest " .. campaignID .. " " .. questID);

		local campaignClass = getClass(campaignID);
		local questClass = getClass(campaignID, questID);

		if not campaignClass or not questClass then
			print("CAN'T FIND CAMPAIGN OR QUEST"); -- TODO: locale / message
			return;
		end

		campaignLog.QUEST[questID] = {
			OB = {},
		};

		local questName = (questClass.BA or EMPTY).NA or UNKNOWN;
		Utils.message.displayMessage(loc("QE_QUEST_START"):format(questName), Utils.message.type.CHAT_FRAME);

		activateQuestHandlers(campaignID, campaignClass, questID, questClass);

		-- Register NPC
		if questClass.ND then
			TRP3_API.quest.registerNPCs(questClass.ND);
		end

		-- Initial script
		if questClass.OS then
			local retCode = TRP3_API.script.executeClassScript(questClass.OS, questClass.SC,
				{
					campaignID = campaignID, campaignClass = campaignClass, campaignLog = campaignLog,
					questID = questID, questClass = questClass, questLog = campaignLog.QUEST[questID],
				});
		end

		Events.fireEvent(Events.CAMPAIGN_REFRESH_LOG);
		return 1;
	else
		Log.log("Can't start quest because already starterd " .. campaignID .. " " .. questID);
	end

	return 0;
end
TRP3_API.quest.startQuest = startQuest;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STEP API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function goToStep(campaignID, questID, stepID)
	-- Checks
	assert(campaignID and questID and stepID, "Illegal args");
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	assert(playerQuestLog.currentCampaign == campaignID, "Can't goToStep because current campaign is not " .. campaignID);
	local campaignLog = playerQuestLog[campaignID];
	assert(campaignLog, "Trying to goToStep from an unstarted campaign: " .. campaignID);
	local questLog = campaignLog.QUEST[questID];
	assert(questLog, "Trying to goToStep from an unstarted quest: " .. campaignID .. " " .. questID);

	-- Change the current step
	if questLog.CS then
		if not questLog.PS then questLog.PS = {}; end
		tinsert(questLog.PS, questLog.CS);
	end
	questLog.CS = stepID;
	Events.fireEvent(Events.CAMPAIGN_REFRESH_LOG);

	-- Only then, check if the step exists.
	local campaignClass = getClass(campaignID);
	local questClass = getClass(campaignID, questID);
	local stepClass = getClass(campaignID, questID, stepID);

	if stepClass then

		-- Register NPC
		if stepClass.ND then
			TRP3_API.quest.registerNPCs(stepClass.ND);
		end

		-- Initial script
		if stepClass.OS then
			local retCode = TRP3_API.script.executeClassScript(stepClass.OS, stepClass.SC,
				{
					campaignID = campaignID, campaignClass = campaignClass, campaignLog = campaignLog,
					questID = questID, questClass = questClass, questLog = questLog,
					stepID = stepID, stepClass = stepClass,
				});
		end

	else
		Log.log("Unknown step class (" .. campaignID .. ") (" .. questID .. ") (" .. stepID .. ")");
	end

	return 1;
end
TRP3_API.quest.goToStep = goToStep;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- OBJECTIVES
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function revealObjective(campaignID, questID, objectiveID)
	-- Checks
	assert(campaignID and questID and objectiveID, "Illegal args");
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	assert(playerQuestLog.currentCampaign == campaignID, "Can't revealObjective because current campaign is not " .. campaignID);
	local campaignLog = playerQuestLog[campaignID];
	assert(campaignLog, "Trying to revealObjective from an unstarted campaign: " .. campaignID);
	local questLog = campaignLog.QUEST[questID];
	assert(questLog, "Trying to revealObjective from an unstarted quest: " .. campaignID .. " " .. questID);

	local questClass = getClass(campaignID, questID);
	local objectiveClass = (questClass or EMPTY).OB[objectiveID];
	if objectiveClass then
		if not questLog.OB then questLog.OB = {} end

		if questLog.OB[objectiveID] == nil then

			if not objectiveClass.CT then
				-- Boolean objective
				questLog.OB[objectiveID] = false;
			else
				-- Counter objective
				questLog.OB[objectiveID] = {
					VA = 0
				};
			end

			-- Message
			Utils.message.displayMessage(loc("QE_QUEST_OBJ_REVEALED"):format(objectiveClass.TX), Utils.message.type.ALERT_MESSAGE);
			Events.fireEvent(Events.CAMPAIGN_REFRESH_LOG);
		end

		return 1;
	else
		Log.log("Unknown objectiveID (" .. campaignID .. ") (" .. questID .. ") (" .. objectiveID .. ")");
		return 0;
	end
end
TRP3_API.quest.revealObjective = revealObjective;

local function markObjectiveDone(campaignID, questID, objectiveID)
	-- Checks
	assert(campaignID and questID and objectiveID, "Illegal args");
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	assert(playerQuestLog.currentCampaign == campaignID, "Can't showObjective because current campaign is not " .. campaignID);
	local campaignLog = playerQuestLog[campaignID];
	assert(campaignLog, "Trying to showObjective from an unstarted campaign: " .. campaignID);
	local questLog = campaignLog.QUEST[questID];
	assert(questLog, "Trying to showObjective from an unstarted quest: " .. campaignID .. " " .. questID);

	local questClass = getClass(campaignID, questID);
	local objectiveClass = (questClass or EMPTY).OB[objectiveID];
	if objectiveClass then
		if questLog.OB and questLog.OB[objectiveID] ~= nil then

			if questLog.OB[objectiveID] ~= true then
				-- Message
				Utils.message.displayMessage(loc("QE_QUEST_OBJ_FINISHED"):format(objectiveClass.TX), Utils.message.type.ALERT_MESSAGE);
				questLog.OB[objectiveID] = true;
				Events.fireEvent(Events.CAMPAIGN_REFRESH_LOG);
			end
			return 1;
		else
			Log.log("Objective not revealed yet (" .. campaignID .. ") (" .. questID .. ") (" .. objectiveID .. ")");
			return 0;
		end
	else
		Log.log("Unknown objectiveID (" .. campaignID .. ") (" .. questID .. ") (" .. objectiveID .. ")");
		return 0;
	end
end
TRP3_API.quest.markObjectiveDone = markObjectiveDone;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- PLAYER ACTIONS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ACTION_TYPES = {
	LOOK = "LOOK",
	LISTEN = "LISTEN",
	TALK = "TALK",
	ACTION = "ACTION",
};

local function performAction(actionType)
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	if playerQuestLog.currentCampaign and playerQuestLog[playerQuestLog.currentCampaign] then

		local campaignID = playerQuestLog.currentCampaign;
		local campaignLog = playerQuestLog[campaignID];
		local campaignClass = getClass(campaignID);

		-- Campaign level
		if campaignClass then

			-- First check all the available quests
			for questID, questLog in pairs(campaignLog.QUEST) do
				if not questLog.DO then
					local questClass = getClass(campaignID, questID);

					-- Quest level
					if questClass then

						-- First check step
						local stepID = questLog.CS;
						if stepID then
							local stepClass = getClass(campaignID, questID, stepID);
							if stepClass and stepClass.AC and stepClass.AC[actionType] then
								for _, scriptID in pairs(stepClass.AC[actionType]) do
									local retCode = TRP3_API.script.executeClassScript(scriptID, stepClass.SC,
										{
											campaignID = campaignID, campaignClass = campaignClass, campaignLog = campaignLog,
											questID = questID, questClass = questClass, questLog = questLog,
											stepID = stepID, stepClass = stepClass,
										});
								end
							end
						end

						-- Then check quest
						if questClass.AC and questClass.AC[actionType] then
							for _, scriptID in pairs(questClass.AC[actionType]) do
								local retCode = TRP3_API.script.executeClassScript(scriptID, questClass.SC,
									{
										campaignID = campaignID, campaignClass = campaignClass, campaignLog = campaignLog,
										questID = questID, questClass = questClass, questLog = questLog,
									});
							end
						end
					end
				end
			end

			-- Then check the campaign
			if campaignClass.AC and campaignClass.AC[actionType] then
				for _, scriptID in pairs(campaignClass.AC[actionType]) do
					local retCode = TRP3_API.script.executeClassScript(scriptID, campaignClass.SC,
						{campaignID = campaignID, campaignClass = campaignClass, campaignLog = campaignLog});
				end
			end
		end
	end
end
TRP3_API.quest.performAction = performAction;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.quest.onStart()
	Events.CAMPAIGN_REFRESH_LOG = "CAMPAIGN_REFRESH_LOG";
	Events.registerEvent(Events.CAMPAIGN_REFRESH_LOG);

	TRP3_API.quest.npcInit();
	TRP3_API.quest.campaignInit();
	TRP3_API.quest.questLogInit();
end
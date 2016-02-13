----------------------------------------------------------------------------------
-- Total RP 3: Campaign system
-- ---------------------------------------------------------------------------
-- Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local CAMPAIGN_DB = TRP3_DB.campaign;
local EMPTY = TRP3_API.globals.empty;
local tostring, assert, pairs, wipe, tinsert = tostring, assert, pairs, wipe, tinsert;
local loc = TRP3_API.locale.getText;
local Log = Utils.log;
local getClass, getClassDataSafe = TRP3_API.extended.getClass, TRP3_API.extended.getClassDataSafe;

local tooltip = TRP3_NPCTooltip;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- NPC API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getCurrentNPCLog()
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	if playerQuestLog.currentCampaign then
		local campaignLog = playerQuestLog[playerQuestLog.currentCampaign];
		if campaignLog and campaignLog.NPC then
			return campaignLog.NPC;
		end
	end
end

local function getCurrentNPCLogStrict()
	local playerQuestLog = TRP3_API.quest.getQuestLog();
	assert(playerQuestLog.currentCampaign, "Try to register NPC but no active campaign.");
	local campaignLog = playerQuestLog[playerQuestLog.currentCampaign];
	assert(campaignLog, "Trying to register NPC from an unstarted campaign.");
	if not campaignLog.NPC then
		campaignLog.NPC = {};
	end
	return campaignLog.NPC;
end

local function registerNPCs(NPCs)
	local npcLog = getCurrentNPCLogStrict();
	for npcID, npcData in pairs(NPCs) do
		if not npcLog[npcID] then
			npcLog[npcID] = {};
		end
		npcLog[npcID].IC = npcData.IC;
		npcLog[npcID].NA = npcData.NA;
		npcLog[npcID].DE = npcData.DE;
	end
end

TRP3_API.quest.registerNPCs = registerNPCs;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- On target
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getUnitDataFromGUID(unitID)
	local unitType, _, _, _, _, npcID = strsplit("-", UnitGUID(unitID) or "");
	return unitType, npcID;
end

local function onTargetChanged()
	local unitType, npcID = getUnitDataFromGUID("target");
	if unitType == "Creature" and npcID then
		local npcLog = getCurrentNPCLog();
		if npcLog and npcLog[npcID] then
			local npcData = npcLog[npcID];
			if npcData.NA then
				TargetFrameTextureFrameName:SetText(npcData.NA);
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- On mouse over
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local npcTooltipBuilder = TRP3_API.ui.tooltip.createTooltipBuilder(tooltip);

local function getCurrentMaxSize()
	return 300;
end

local function showIcon()
	return true;
end

local function showOriginalTexts()
	return true;
end

local function onMouseOver()
	tooltip:Hide();
	local unitType, npcID = getUnitDataFromGUID("mouseover");
	if unitType == "Creature" and npcID then
		local npcLog = getCurrentNPCLog();
		if npcLog and npcLog[npcID] then
			local npcData = npcLog[npcID];
			local originalName = UnitName("mouseover");
			local originalTexts = TRP3_API.ui.tooltip.getGameTooltipTexts(GameTooltip);

			tooltip.unitType = unitType;
			tooltip.targetID = npcID;
			tooltip:SetOwner(GameTooltip, "ANCHOR_TOPRIGHT");

			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
			-- Icon and name
			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

			local leftIcons = "";

			if showIcon() then
				-- Companion icon
				if npcData.IC then
					leftIcons = strconcat(Utils.str.icon(npcData.IC, 25), leftIcons, " ");
				end
			end

			npcTooltipBuilder:AddLine(leftIcons .. (npcData.NA or originalName), 1, 1, 1, TRP3_API.ui.tooltip.getMainLineFontSize());

			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
			-- Description
			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

			if (npcData.DE or ""):len() > 0 then
				local text = strtrim(npcData.DE);
				if text:len() > getCurrentMaxSize() then
					text = text:sub(1, getCurrentMaxSize()) .. "…";
				end
				npcTooltipBuilder:AddLine("\"" .. text .. "\"", 1, 0.75, 0, TRP3_API.ui.tooltip.getSmallLineFontSize(), true);
			end

			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
			-- Original text
			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

			if showOriginalTexts() then
				npcTooltipBuilder:AddSpace();
				for _, text in pairs(originalTexts) do
					npcTooltipBuilder:AddLine(text, 1, 1, 1, TRP3_API.ui.tooltip.getSmallLineFontSize());
				end
			end

			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
			-- Build
			--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

			npcTooltipBuilder:Build();

			if TRP3_API.ui.tooltip.shouldHideGameTooltip() then
				GameTooltip:Hide();
			end
			tooltip:ClearAllPoints();
		end
	end
end

local function onTooltipUpdate(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
	if self.TimeSinceLastUpdate > 0.5 then
		self.TimeSinceLastUpdate = 0;
		if self.targetID and not self.isFading then
			local unitType, npcID = getUnitDataFromGUID("mouseover");
			if self.unitType ~= unitType or self.targetID ~= npcID then
				self.isFading = true;
				self.targetID = nil;
				self:FadeOut();
			end
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function init()
	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", onMouseOver);

	tooltip.TimeSinceLastUpdate = 0;
	tooltip:SetScript("OnUpdate", onTooltipUpdate);

	-- Slash command to reset frames
	TRP3_API.slash.registerCommand({
		id = "getID",
		helpLine = " get targeted npc id", -- TODO: locals
		handler = function()
			print(getUnitDataFromGUID("target"));
		end
	});
end

TRP3_API.quest.npcInit = init;
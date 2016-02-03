----------------------------------------------------------------------------------
-- Storyline ConsolePort support
-- ---------------------------------------------------------------------------
-- Copyright 2015 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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

Storyline_API.consolePort = {
	moveCursorToFirstAvailableReward = function() end;
}

Storyline_API.consolePort.init = function()
	-- If ConsolePort is not available, we immediately exit the function, nothing to do here
	if not ConsolePort then return end

	-- The moveCursorToFirstAvailableReward function will be called by our code when we open the rewards box
	-- If we have to choose between multiple rewards, we want to move ConsolePort's custom cursor to the first choice available.
	-- (We've previsouly saved the first choice available in Storyline_NPCFrameRewards.Content.firstChoice when fetching the quests rewards)
	Storyline_API.consolePort.moveCursorToFirstAvailableReward = function()
		-- Check if we registered a firstChoice in the reward frame first
		if not Storyline_NPCFrameRewards.Content.firstChoice then return end

		-- ...move ConsolePort's cursor focus to the first reward, so the user can pick the reward they want.
		ConsolePort:SetCurrentNode(Storyline_NPCFrameRewards.Content.firstChoice);

		-- Manually trigger the comparison tooltip (maybe we can ask ConsolePort to trigger the OnEnter script)
		GameTooltip:SetOwner(Storyline_NPCFrameRewards.Content.firstChoice, "ANCHOR_RIGHT");
		GameTooltip:SetQuestItem(Storyline_NPCFrameRewards.Content.firstChoice.type, Storyline_NPCFrameRewards.Content.firstChoice.index);
		GameTooltip_ShowCompareItem(GameTooltip);
	end


	-- Register Storyline's frame to ConsolePort
	for _, frame in pairs({
		"Storyline_NPCFrame",
		"Storyline_NPCFrameChatOption1",
		"Storyline_NPCFrameChatOption2",
		"Storyline_NPCFrameChatOption3",
		"Storyline_NPCFrameGossipChoices",
	}) do
		ConsolePort:AddFrame(frame);
	end

	-- Give cursor focus priority to our main buttons
	for _, node in pairs({
		Storyline_NPCFrameChatNext, -- Our invisible button over the chatframe text used for going to the next paragraph/action
		Storyline_NPCFrameObjectivesYes, -- The green tick button used for accepting quests
	}) do node.hasPriority = true
	end

	-- Define a custom anchor for the invisible button used for the chatframe so the cursor is not in the middle of the text
	Storyline_NPCFrameChatNext.customAnchor = {
		"TOPLEFT", 					-- Keep the anchor point at the top left of the cursor,
		Storyline_NPCFrameChatNext, -- Keep the cursor anchored to the chatframe,
		"BOTTOM", 					-- But we want it on the bottom of the frame.
		0, -20
	};

	-- Ignore the following frames, they should not take the cursor focus
	-- since they are useless for console controlers and could annoyingly intercept the focus
	for _, node in pairs({
		Storyline_NPCFrameModels,
		Storyline_NPCFrameLock,
		Storyline_NPCFrameResizeButton,
	}) do node.ignoreNode = true
	end

	-- Ignore specific clickable frames that are no use to console controllers but have children we still need
	for _, node in pairs({
		Storyline_NPCFrameObjectives -- The round button for objectives
	}) do node.includeChildren = true
	end

	-- Hook OnShow script for key frames that should be focused when they are shown
	for _, node in pairs({
		Storyline_NPCFrameChatOption1,
		Storyline_NPCFrameChatOption2,
		Storyline_NPCFrameChatOption3,
		Storyline_NPCFrameObjectivesYes
	}) do
		node:HookScript("OnShow", function()
			ConsolePort:SetCurrentNode(node);
		end)
	end

	-- Our keyboard shortcuts feature interfere with ConsolePorts, so we disable them
	Storyline_Data.config.useKeyboard = false;
end
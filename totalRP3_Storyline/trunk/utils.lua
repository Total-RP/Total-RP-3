----------------------------------------------------------------------------------
-- Total RP 3
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

local Globals, Utils, Comm, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.communication, TRP3_API.events;
local after, tostring = C_Timer.After, tostring;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UTILS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getQuestIcon(frequency, isRepeatable, isLegendary)
	if (isLegendary) then
		return "Interface\\GossipFrame\\AvailableLegendaryQuestIcon";
	elseif (frequency == LE_QUEST_FREQUENCY_DAILY or frequency == LE_QUEST_FREQUENCY_WEEKLY) then
		return "Interface\\GossipFrame\\DailyQuestIcon";
	elseif (isRepeatable) then
		return "Interface\\GossipFrame\\DailyActiveQuestIcon";
	else
		return "Interface\\GossipFrame\\AvailableQuestIcon";
	end
end
TRP3_StorylineAPI.getQuestIcon = getQuestIcon;

local function getQuestActiveIcon(isComplete)
	if (isComplete) then
		return "Interface\\GossipFrame\\ActiveQuestIcon";
	else
		return "Interface\\GossipFrame\\IncompleteQuestIcon";
	end
end
TRP3_StorylineAPI.getQuestActiveIcon = getQuestActiveIcon;

local function getQuestTriviality(isTrivial)
	if isTrivial then
		return " (|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20:20|t)";
	else
		return "";
	end
end
TRP3_StorylineAPI.getQuestTriviality = getQuestTriviality;

local function getQuestLevelColor(questLevel)
	return 0.9, 0.6, 0;
end
TRP3_StorylineAPI.getQuestLevelColor = getQuestLevelColor;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SOME ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_ANIM_MAPPING, TRP3_DEFAULT_ANIM_MAPPING = TRP3_ANIM_MAPPING, TRP3_DEFAULT_ANIM_MAPPING;
local TRP3_ANIMATION_SEQUENCE_DURATION = TRP3_ANIMATION_SEQUENCE_DURATION;
local TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL = TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL;
local TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou = TRP3_NPCDialogFrameModelsMe, TRP3_NPCDialogFrameModelsYou;

function TRP3_StorylineAPI.getAnimationByModel(model, animationType)
	if model then
		if TRP3_ANIM_MAPPING[model] and TRP3_ANIM_MAPPING[model][animationType] then
			return TRP3_ANIM_MAPPING[model][animationType];
		end
	end
	return TRP3_DEFAULT_ANIM_MAPPING[animationType];
end

local function playAnim(model, sequence)
	model:SetAnimation(sequence);
	if model.debug then
		model.debug:SetText(sequence);
	end
end

function TRP3_StorylineAPI.playAnimationDelay(model, sequence, duration, delay, token)
	if delay == 0 then
		playAnim(model, sequence)
	else
		model.token = token;
		after(delay, function()
			if model.token == token then
				playAnim(model, sequence);
			end
		end)
	end

	return delay + duration;
end

local DEFAULT_SEQUENCE_TIME = 4;

local function getDuration(model, sequence)
	sequence = tostring(sequence);
	if TRP3_Storyline.debug.timing[model] and TRP3_Storyline.debug.timing[model][sequence] then
		return TRP3_Storyline.debug.timing[model][sequence];
	elseif TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model] and TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model][sequence] then
		return TRP3_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model][sequence];
	end
	return TRP3_ANIMATION_SEQUENCE_DURATION[sequence] or DEFAULT_SEQUENCE_TIME;
end
TRP3_StorylineAPI.getDuration = getDuration;

local function playAndStand(model, sequence, duration)
	local token = Utils.str.id();
	model.token = token
	playAnim(model, sequence);
	after(duration, function()
		if model.token == token then
			playAnim(model, 0);
		end
	end);
end

function TRP3_StorylineAPI.playSelfAnim(sequence)
	playAndStand(TRP3_NPCDialogFrameModelsMe, sequence, getDuration(TRP3_NPCDialogFrameModelsMe:GetModel(), sequence));
end

local function playTargetAnim(sequence)
	playAndStand(TRP3_NPCDialogFrameModelsYou, sequence, getDuration(TRP3_NPCDialogFrameModelsYou:GetModel(), sequence));
end
TRP3_NPCDialogFrameDebugSequenceYou.playTargetAnim = playTargetAnim;
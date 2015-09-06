----------------------------------------------------------------------------------
--  Storyline
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
--	Copyright 2015 Renaud "Ellypse" Parize (ellypse@totalrp3.info)
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

-- Storyline API
local getId = Storyline_API.lib.generateID;

-- WOW API
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
Storyline_API.getQuestIcon = getQuestIcon;

local function getQuestActiveIcon(isComplete)
	if (isComplete) then
		return "Interface\\GossipFrame\\ActiveQuestIcon";
	else
		return "Interface\\GossipFrame\\IncompleteQuestIcon";
	end
end
Storyline_API.getQuestActiveIcon = getQuestActiveIcon;

local function getQuestTriviality(isTrivial)
	if isTrivial then
		return " (|TInterface\\TARGETINGFRAME\\UI-TargetingFrame-Seal:20:20|t)";
	else
		return "";
	end
end
Storyline_API.getQuestTriviality = getQuestTriviality;

local function getQuestLevelColor(questLevel)
	return 0.9, 0.6, 0;
end
Storyline_API.getQuestLevelColor = getQuestLevelColor;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SOME ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Storyline_ANIM_MAPPING, Storyline_DEFAULT_ANIM_MAPPING = Storyline_ANIM_MAPPING, Storyline_DEFAULT_ANIM_MAPPING;
local Storyline_ANIMATION_SEQUENCE_DURATION = Storyline_ANIMATION_SEQUENCE_DURATION;
local Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL = Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL;
local Storyline_NPCFrameModelsMe, Storyline_NPCFrameModelsYou = Storyline_NPCFrameModelsMe, Storyline_NPCFrameModelsYou;

function Storyline_API.getAnimationByModel(model, animationType)
	if model then
		if Storyline_ANIM_MAPPING[model] and Storyline_ANIM_MAPPING[model][animationType] then
			return Storyline_ANIM_MAPPING[model][animationType];
		end
	end
	return Storyline_DEFAULT_ANIM_MAPPING[animationType];
end

local function playAnim(model, sequence)
	model:SetAnimation(sequence);
	if model.debug then
		model.debug:SetText(sequence);
	end
end

function Storyline_API.playAnimationDelay(model, sequence, duration, delay, token)
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
	if Storyline_Data.debug.timing[model] and Storyline_Data.debug.timing[model][sequence] then
		return Storyline_Data.debug.timing[model][sequence];
	elseif Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model] and Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model][sequence] then
		return Storyline_ANIMATION_SEQUENCE_DURATION_BY_MODEL[model][sequence];
	end
	return Storyline_ANIMATION_SEQUENCE_DURATION[sequence] or DEFAULT_SEQUENCE_TIME;
end
Storyline_API.getDuration = getDuration;

local function playAndStand(model, sequence, duration)
	local token = getId();
	model.token = token
	playAnim(model, sequence);
	after(duration, function()
		if model.token == token then
			playAnim(model, 0);
		end
	end);
end

function Storyline_API.playSelfAnim(sequence)
	playAndStand(Storyline_NPCFrameModelsMe, sequence, getDuration(Storyline_NPCFrameModelsMe:GetModel(), sequence));
end

local function playTargetAnim(sequence)
	playAndStand(Storyline_NPCFrameModelsYou, sequence, getDuration(Storyline_NPCFrameModelsYou:GetModel(), sequence));
end
Storyline_NPCFrameDebugSequenceYou.playTargetAnim = playTargetAnim;
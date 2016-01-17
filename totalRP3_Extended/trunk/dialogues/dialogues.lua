----------------------------------------------------------------------------------
-- Total RP 3: Dialogues system
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
local _G, wipe, tostring, tinsert, strsplit, pairs, type = _G, wipe, tostring, tinsert, strsplit, pairs, type;
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;
local Log = Utils.log;
local getClass = TRP3_API.extended.getClass;

local dialogFrame = TRP3_DialogFrame;
local CHAT_MARGIN = 70;

local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Models structures
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DEFAULT_SCALE = {
	me = {
		scale = 1.45,
		feet = 0.4,
		offset = 0.215,
		facing = 0.75
	}
};
DEFAULT_SCALE.you = DEFAULT_SCALE.me;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Models and animations
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local modelMe, modelYou = dialogFrame.Models.Me, dialogFrame.Models.You;

local function setModelHeight(scale, isMe)
	local frame = (isMe and modelMe or modelYou);
	frame.scale = scale;
	frame:InitializeCamera(scale);
end

local function setModelFacing(facing, isMe)
	local frame = (isMe and modelMe or modelYou);
	frame.facing = facing;
	frame:SetFacing(facing * (isMe and 1 or -1));
end

local function setModelFeet(feet, isMe)
	local frame = (isMe and modelMe or modelYou);
	frame.feet = feet;
	frame:SetHeightFactor(feet);
end

local function setModelOffset(offset, isMe)
	local frame = (isMe and modelMe or modelYou);
	frame.offset = offset;
	frame:SetTargetDistance(offset * (isMe and 1 or -1));
end

local function modelsLoaded()
	if modelMe.modelLoaded and modelYou.modelLoaded then

		modelMe.model = modelMe:GetModel();
		if modelMe.model:len() > 0 then
			setModelHeight(DEFAULT_SCALE.me.scale, true);
			setModelFeet(DEFAULT_SCALE.me.feet, true);
			setModelOffset(DEFAULT_SCALE.me.offset, true);
			setModelFacing(DEFAULT_SCALE.me.facing, true);
		end

		modelYou.model = modelYou:GetModel();
		if modelYou.model:len() > 0 then
			setModelHeight(DEFAULT_SCALE.you.scale, false);
			setModelFeet(DEFAULT_SCALE.you.feet, false);
			setModelOffset(DEFAULT_SCALE.you.offset, false);
			setModelFacing(DEFAULT_SCALE.you.facing, false);
		end
	end
end

local function reinitModel(frame)
	frame.modelLoaded = false;
	frame.model = nil;
	frame.unit = nil;
end

local function loadModel(frame, unit)
	reinitModel(frame);
	frame.unit = unit;
	frame:SetUnit(unit, false);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEXT ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_TEXT_SPEED = 80;

local function onUpdateChatText(self, elapsed)
	if self.start and dialogFrame.Chat.Text:GetText() and dialogFrame.Chat.Text:GetText():len() > 0 then
		local speedFactor = 0.5;
		self.start = self.start + (elapsed * (ANIMATION_TEXT_SPEED * speedFactor));
		if speedFactor == 0 or self.start >= dialogFrame.Chat.Text:GetText():len() then
			self.start = nil;
			dialogFrame.Chat.Text:SetAlphaGradient(dialogFrame.Chat.Text:GetText():len(), 1);
		else
			dialogFrame.Chat.Text:SetAlphaGradient(self.start, 30);
		end
	end
end


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local UnitName = UnitName;
local getAnimationByModel = TRP3_API.extended.animations.getAnimationByModel
local playAnimationDelay = TRP3_API.extended.animations.playAnimationDelay;
local getDuration = TRP3_API.extended.animations.getDuration;
local generateID = Utils.str.id;

local function finishDialog()
	dialogFrame:Hide();
end

-- Called to play one text
local function playDialogStep(data)
	-- Texts
	dialogFrame.Chat.Name:SetText(data.name);
	dialogFrame.Chat.Name:SetJustifyH(data.nameDirection);
	dialogFrame.Chat.Text:SetText(data.text);

	-- Animation cut
	local targetModel = data.nameDirection == "RIGHT" and modelYou or modelMe;
	local animTab = targetModel.animTab;
	wipe(animTab);
	data.text:gsub("[%.%?%!]+", function(finder)
		animTab[#animTab + 1] = getAnimationByModel(targetModel.model, finder:sub(1, 1));
		animTab[#animTab + 1] = 0;
	end);
	if #animTab == 0 then
		animTab[1] = 0;
	end

	-- Play animations
	local delay = 0;
	local textLineToken = generateID();
	for _, sequence in pairs(animTab) do
		delay = playAnimationDelay(targetModel, sequence, getDuration(targetModel.model, sequence), delay, textLineToken);
	end

	-- Load models
	if modelMe.unit ~= data.meUnit then
		loadModel(modelMe, data.meUnit);
	end
	if modelYou.unit ~= data.youUnit then
		loadModel(modelYou, data.youUnit);
	end

	-- Play text
	dialogFrame.Chat.start = 0;

	-- What to do next
	if dialogFrame.stepTab[dialogFrame.stepIndex + 1] then -- Next in same step
		dialogFrame.Chat.NextButton:SetScript("OnClick", function()
			dialogFrame.stepIndex = dialogFrame.stepIndex + 1;
			playDialogStep(dialogFrame.stepTab[dialogFrame.stepIndex]);
		end);
	else
		-- Choice
		-- Next step
		-- Finish
		dialogFrame.Chat.NextButton:SetScript("OnClick", finishDialog);
	end
end

-- Prepare all the texts for a step
local function processDialogStep(dialogClass, dialogStepClass)
	wipe(dialogFrame.stepTab);
	local meUnitStep = dialogStepClass.MM or dialogClass.MM or "player";
	local youUnitStep = dialogStepClass.MY or dialogClass.MY or "target";
	local nameStep = dialogStepClass.NA or dialogClass.NA or "target";
	if nameStep == "player" or nameStep == "target" then
		nameStep = UnitName(nameStep);
	end
	local nameDirectionStep = dialogStepClass.ND or dialogClass.ND or "RIGHT";

	-- Process text
	if dialogStepClass.IN then
		if type(dialogStepClass.IN) == "string" then
			local fullText = dialogStepClass.IN;

			fullText = fullText:gsub(LINE_FEED_CODE .. "+", "\n");
			fullText = fullText:gsub(WEIRD_LINE_BREAK, "\n");

			local texts = { strsplit("\n", fullText) };
			-- If last is empty, remove last
			if texts[#texts]:len() == 0 then
				texts[#texts] = nil;
			end

			for _, text in pairs(texts) do
				tinsert(dialogFrame.stepTab, {
					meUnit = meUnitStep,
					youUnit = youUnitStep,
					name = nameStep,
					nameDirection = nameDirectionStep,
					text = text,
				});
			end


		elseif type(dialogStepClass.IN) == "table" then
			-- Complex dialog step
		end
	end

	dialogFrame.stepIndex = 1;
	playDialogStep(dialogFrame.stepTab[1]);
end

local function startDialog(dialogID)
	local dialogClass = getClass(dialogID);
	-- By default, launch the step 1
	processDialogStep(dialogClass, (dialogClass.ST or EMPTY)["1"] or EMPTY);
	dialogFrame:Show();
end

TRP3_API.extended.dialog.startDialog = startDialog;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onLoaded()

end

function TRP3_API.extended.dialog.onStart()

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, onLoaded);

	-- Effect and operands
	TRP3_API.script.registerEffects({
		dialog_start = {
			codeReplacementFunc = function(args)
				local dialogID = args[1];
				return ("lastEffectReturn = startDialog(\"%s\");"):format(dialogID);
			end,
			env = {
				startDialog = "TRP3_API.extended.dialog.startDialog",
			}
		},
	});

	modelMe.animTab = {};
	modelYou.animTab = {};
	dialogFrame.stepTab = {};
	dialogFrame.Chat:SetScript("OnUpdate", onUpdateChatText);
	dialogFrame:SetScript("OnHide", function()
		reinitModel(modelMe);
		reinitModel(modelYou);
	end);

	-- 3D models loaded
	modelMe:SetScript("OnModelLoaded", function()
		modelMe.modelLoaded = true;
		modelsLoaded();
	end);
	modelYou:SetScript("OnModelLoaded", function()
		modelYou.modelLoaded = true;
		modelsLoaded();
	end);

	-- Resizing
	local resizeChat = function()
		dialogFrame.Chat.Text:SetWidth(dialogFrame:GetWidth() - 150);
		dialogFrame.Chat:SetHeight(dialogFrame.Chat.Text:GetHeight() + CHAT_MARGIN + 5);
--		Storyline_NPCFrameGossipChoices:SetWidth(Storyline_NPCFrame:GetWidth() - 400);
	end
	dialogFrame.Chat.Text:SetWidth(550);
	dialogFrame.Resize.onResizeStop = function(width, height)
		resizeChat();
		dialogFrame.width = width;
		dialogFrame.height = height;
	end;
	dialogFrame:SetSize(dialogFrame.width or 950, dialogFrame.height or 670);
	resizeChat();
end
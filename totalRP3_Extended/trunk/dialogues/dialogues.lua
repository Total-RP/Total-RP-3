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
local _G, wipe, tostring, tinsert, strsplit, pairs, type, tonumber = _G, wipe, tostring, tinsert, strsplit, pairs, type, tonumber;
local loc = TRP3_API.locale.getText;
local EMPTY = TRP3_API.globals.empty;
local Log = Utils.log;
local getClass = TRP3_API.extended.getClass;

local dialogFrame = TRP3_DialogFrame;
local CHAT_MARGIN = 70;

local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;

local scalingLib = LibStub:GetLibrary("TRP-Dialog-Scaling-DB");
local animationLib = LibStub:GetLibrary("TRP-Dialog-Animation-DB");

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Models and animations
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local modelMe, modelYou = dialogFrame.Models.Me, dialogFrame.Models.You;
local generateID = Utils.str.id;

local function modelsLoaded()
	if modelMe.modelLoaded and modelYou.modelLoaded then

		local modelMePath = modelMe:GetModel();
		local modelYouPath = modelYou:GetModel();
		local modelScalingMe, modelScalingYou, isInverted = scalingLib:GetModelScaling(modelMePath, modelYouPath);

		modelMe.model = modelMePath;
		if modelMePath:len() > 0 then
			scalingLib:SetModelHeight(modelScalingMe.scale, modelMe);
			scalingLib:SetModelFeet(modelScalingMe.feet, modelMe);
			scalingLib:SetModelOffset(modelScalingMe.offset, modelMe, true);
			scalingLib:SetModelFacing(modelScalingMe.facing, modelMe, true);

			-- Play animations
			local delay = 0;
			local textLineToken = generateID();
			for _, sequence in pairs(modelMe.animTab) do
				delay = animationLib:PlayAnimationDelay(modelMe, sequence, animationLib:GetAnimationDuration(modelMe.model, sequence), delay, textLineToken);
			end
		end

		modelYou.model = modelYouPath;
		if modelYouPath:len() > 0 then
			scalingLib:SetModelHeight(modelScalingYou.scale, modelYou);
			scalingLib:SetModelFeet(modelScalingYou.feet, modelYou);
			scalingLib:SetModelOffset(modelScalingYou.offset, modelYou, false);
			scalingLib:SetModelFacing(modelScalingYou.facing, modelYou, false);

			-- Play animations
			local delay = 0;
			local textLineToken = generateID();
			for _, sequence in pairs(modelYou.animTab) do
				delay = animationLib:PlayAnimationDelay(modelYou, sequence, animationLib:GetAnimationDuration(modelYou.model, sequence), delay, textLineToken);
			end
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
local processDialogStep;

local function finishDialog()
	dialogFrame:Hide();
end

local function setupChoices(choices)
	for choiceIndex, choiceData in pairs(choices) do
		local choiceButton = modelMe.choices[choiceIndex];
		choiceButton.Text:SetText(choiceData.TX);
		choiceButton.Click:SetScript("OnClick", function()
			dialogFrame.stepIndex = choiceData.N;
			processDialogStep();
		end);
		choiceButton:Show();
	end
end

-- Called to play one text
local function playDialogStep()
	local data = dialogFrame.stepTab[dialogFrame.stepDialogIndex];
	local dialogClass = dialogFrame.class;

	-- Choices
	for _, choiceButton in pairs(modelMe.choices) do
		choiceButton:Hide();
	end

	-- Names
	dialogFrame.Chat.Right:Hide();
	dialogFrame.Chat.Left:Hide();
	if data.nameDirection == "RIGHT" then
		dialogFrame.Chat.Right:Show();
		dialogFrame.Chat.Right.Name:SetText(data.youName);
		dialogFrame.Chat.Right:SetWidth(dialogFrame.Chat.Right.Name:GetStringWidth() + 20);
	else
		dialogFrame.Chat.Left:Show();
		dialogFrame.Chat.Left.Name:SetText(data.meName);
		dialogFrame.Chat.Left:SetWidth(dialogFrame.Chat.Left.Name:GetStringWidth() + 20);
	end

	-- Texts
	dialogFrame.Chat.Text:SetText(data.text);

	-- Animation cut
	wipe(modelYou.animTab);
	wipe(modelMe.animTab);
	local targetModel = data.nameDirection == "RIGHT" and modelYou or modelMe;
	local animTab = targetModel.animTab;
	data.text:gsub("[%.%?%!]+", function(finder)
		animTab[#animTab + 1] = animationLib:GetDialogAnimation(targetModel.model, finder:sub(1, 1));
		animTab[#animTab + 1] = 0;
	end);
	if #animTab == 0 then
		animTab[1] = 0;
	end

	-- Load models
	loadModel(modelMe, data.meUnit);
	loadModel(modelYou, data.youUnit);

	-- Play text
	dialogFrame.Chat.start = 0;

	-- What to do next
	if dialogFrame.stepTab[dialogFrame.stepDialogIndex + 1] then -- Next in same step
		dialogFrame.Chat.NextButton:SetScript("OnClick", function()
			dialogFrame.stepDialogIndex = dialogFrame.stepDialogIndex + 1;
			playDialogStep();
		end);
	else
		-- Choice
		if data.choices then
			setupChoices(data.choices);
			dialogFrame.Chat.NextButton:SetScript("OnClick", nil);
		else
			-- Next step
			dialogFrame.stepIndex = data.next or (dialogFrame.stepIndex + 1);

			if (dialogClass.ST or EMPTY)[dialogFrame.stepIndex] then
				-- Next
				dialogFrame.Chat.NextButton:SetScript("OnClick", function()
					processDialogStep();
				end);
			else
				-- Finish
				dialogFrame.Chat.NextButton:SetScript("OnClick", finishDialog);
			end
		end
	end
end

-- Prepare all the texts for a step
function processDialogStep()
	wipe(dialogFrame.stepTab);
	local dialogClass = dialogFrame.class;
	local dialogStepClass  = (dialogClass.ST or EMPTY)[dialogFrame.stepIndex] or EMPTY;
	local meUnitStep = dialogStepClass.MM or dialogClass.MM or "player";
	local youUnitStep = dialogStepClass.MY or dialogClass.MY or "target";
	local meNameStep = dialogStepClass.NM or dialogClass.NM or "player";
	local youNameStep = dialogStepClass.NY or dialogClass.NY or "target";
	if youNameStep == "player" or youNameStep == "target" then
		youNameStep = UnitName(youNameStep);
	end
	if meNameStep == "player" or meNameStep == "target" then
		meNameStep = UnitName(meNameStep);
	end
	local nameDirectionStep = dialogStepClass.ND or dialogClass.ND or "RIGHT";

	-- Process text
	if dialogStepClass.TX then
		if type(dialogStepClass.TX) == "string" then
			local fullText = dialogStepClass.TX;

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
					meName = meNameStep,
					youName = youNameStep,
					nameDirection = nameDirectionStep,
					text = text,
					next = dialogStepClass.N,
					choices = dialogStepClass.CH
				});
			end


		elseif type(dialogStepClass.TX) == "table" then
			-- Complex dialog step
		end
	end

	dialogFrame.stepDialogIndex = 1;
	playDialogStep();
end

local function startDialog(dialogID)
	local dialogClass = getClass(dialogID);
	-- By default, launch the step 1
	dialogFrame.class = dialogClass;
	dialogFrame.stepIndex = dialogClass.FS or 1;
	processDialogStep(dialogClass);
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

	-- Choices
	local setupButton = function(button, iconIndex)
		local QUEST_POI_ICONS_PER_ROW = 8;
		local QUEST_POI_ICON_SIZE = 0.125;
		local yOffset = 0.5 + floor(iconIndex / QUEST_POI_ICONS_PER_ROW) * QUEST_POI_ICON_SIZE;
		local xOffset = mod(iconIndex, QUEST_POI_ICONS_PER_ROW) * QUEST_POI_ICON_SIZE;
		button.Number:SetTexCoord(xOffset, xOffset + QUEST_POI_ICON_SIZE, yOffset, yOffset + QUEST_POI_ICON_SIZE);
	end
	setupButton(modelMe.Choice1.Num, 0);
	setupButton(modelMe.Choice2.Num, 1);
	setupButton(modelMe.Choice3.Num, 2);
	setupButton(modelMe.Choice4.Num, 3);
	setupButton(modelMe.Choice5.Num, 4);
	modelMe.choices = {modelMe.Choice1, modelMe.Choice2, modelMe.Choice3, modelMe.Choice4, modelMe.Choice5}

end
----------------------------------------------------------------------------------
-- Storyline
-- ---------------------------------------------------------------------------
-- Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

-- Storyline API
local setTooltipForSameFrame, setTooltipAll = Storyline_API.lib.setTooltipForSameFrame, Storyline_API.lib.setTooltipAll;
local registerHandler = Storyline_API.lib.registerHandler;
local loc = Storyline_API.locale.getText;
local playNext = Storyline_API.playNext;
local showStorylineFame = Storyline_API.layout.showStorylineFame;
local hideStorylineFrame = Storyline_API.layout.hideStorylineFrame;

-- WOW API
local strsplit, pairs = strsplit, pairs;
local UnitIsUnit, UnitExists, UnitName = UnitIsUnit, UnitExists, UnitName;
local IsAltKeyDown, IsShiftKeyDown = IsAltKeyDown, IsShiftKeyDown;
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory;

-- UI
local Storyline_NPCFrame = Storyline_NPCFrame;
local Storyline_NPCFrameChat, Storyline_NPCFrameChatText = Storyline_NPCFrameChat, Storyline_NPCFrameChatText;
local Storyline_NPCFrameChatNext, Storyline_NPCFrameChatPrevious = Storyline_NPCFrameChatNext, Storyline_NPCFrameChatPrevious;
local Storyline_NPCFrameModelsYou, Storyline_NPCFrameModelsMe = Storyline_NPCFrameModelsYou, Storyline_NPCFrameModelsMe;
local Storyline_NPCFrameDebugText, Storyline_NPCFrameChatName, Storyline_NPCFrameBanner = Storyline_NPCFrameDebugText, Storyline_NPCFrameChatName, Storyline_NPCFrameBanner;
local Storyline_NPCFrameTitle, Storyline_NPCFrameDebugModelYou, Storyline_NPCFrameDebugModelMe = Storyline_NPCFrameTitle, Storyline_NPCFrameDebugModelYou, Storyline_NPCFrameDebugModelMe;

local Storyline_NPCFrameDebugMeFeetSlider, Storyline_NPCFrameDebugYouFeetSlider = Storyline_NPCFrameDebugMeFeetSlider, Storyline_NPCFrameDebugYouFeetSlider;
local Storyline_NPCFrameDebugMeOffsetSlider, Storyline_NPCFrameDebugYouOffsetSlider = Storyline_NPCFrameDebugMeOffsetSlider, Storyline_NPCFrameDebugYouOffsetSlider;

-- Constants
local DEBUG = true;
local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;
local CHAT_MARGIN = 70;
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
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function closeDialog()
	if Storyline_NPCFrameChat.eventInfo and Storyline_NPCFrameChat.eventInfo.cancelMethod then
		Storyline_NPCFrameChat.eventInfo.cancelMethod();
	end
	hideStorylineFrame();
end

local function resetDialog()
	Storyline_NPCFrameObjectivesContent:Hide();
	Storyline_NPCFrameChat.currentIndex = 0;
	playNext(Storyline_NPCFrameModelsYou);
end

local function getDataStuctures(modelMeName, modelYouName)
	local key, invertedKey = modelMeName .. "~" .. modelYouName, modelYouName .. "~" .. modelMeName;
	local savedDataMe, savedDataYou, dataMe, dataYou;

	if Storyline_Data.scaling[key] then
		savedDataMe = Storyline_Data.scaling[key].me;
		savedDataYou = Storyline_Data.scaling[key].you;
	elseif Storyline_Data.scaling[invertedKey] then
		savedDataMe = Storyline_Data.scaling[invertedKey].you;
		savedDataYou = Storyline_Data.scaling[invertedKey].me;
	end
	if Storyline_SCALE_MAPPING[key] then
		dataMe = Storyline_SCALE_MAPPING[key].me;
		dataYou = Storyline_SCALE_MAPPING[key].you;
	elseif Storyline_SCALE_MAPPING[invertedKey] then
		dataMe = Storyline_SCALE_MAPPING[invertedKey].you;
		dataYou = Storyline_SCALE_MAPPING[invertedKey].me;
	end

	return savedDataMe, savedDataYou, dataMe, dataYou;
end

local function resetStructure(resetMe)
	local modelMeName, modelYouName = Storyline_NPCFrameModelsMe.model, Storyline_NPCFrameModelsYou.model;
	local key, invertedKey = modelMeName .. "~" .. modelYouName, modelYouName .. "~" .. modelMeName;
	if Storyline_Data.scaling[key] then
		if resetMe and Storyline_Data.scaling[key].me then
			wipe(Storyline_Data.scaling[key].me);
			Storyline_Data.scaling[key].me = nil;
		elseif not resetMe and Storyline_Data.scaling[key].you then
			wipe(Storyline_Data.scaling[key].you);
			Storyline_Data.scaling[key].you = nil;
		end
		if not Storyline_Data.scaling[key].me and not Storyline_Data.scaling[key].you then
			Storyline_Data.scaling[key] = nil;
		end
	end
	if Storyline_Data.scaling[invertedKey] then
		if not resetMe and Storyline_Data.scaling[invertedKey].me then
			wipe(Storyline_Data.scaling[invertedKey].me);
			Storyline_Data.scaling[invertedKey].me = nil;
		elseif resetMe and Storyline_Data.scaling[invertedKey].you then
			wipe(Storyline_Data.scaling[invertedKey].you);
			Storyline_Data.scaling[invertedKey].you = nil;
		end
		if not Storyline_Data.scaling[invertedKey].me and not Storyline_Data.scaling[invertedKey].you then
			Storyline_Data.scaling[invertedKey] = nil;
		end
	end
end

local function getSavedStructure()
	local modelMeName, modelYouName = Storyline_NPCFrameModelsMe.model, Storyline_NPCFrameModelsYou.model;
	local key, invertedKey = modelMeName .. "~" .. modelYouName, modelYouName .. "~" .. modelMeName;
	if not Storyline_Data.scaling[key] and not Storyline_Data.scaling[invertedKey] then
		Storyline_Data.scaling[key] = {};
	end
	return Storyline_Data.scaling[key] or Storyline_Data.scaling[invertedKey], Storyline_Data.scaling[key] == nil;
end

local function saveStructureData(dataName, isMe, value)
	local structure, isInverted = getSavedStructure();
	local meYou;
	if (isMe and not isInverted) or (not isMe and isInverted) then
		meYou = "me";
	elseif (isMe and isInverted) or (not isMe and not isInverted) then
		meYou = "you";
	end
	if not structure[meYou] then
		structure[meYou] = {};
	end
	structure[meYou][dataName] = value;
end

local function setModelHeight(scale, isMe, save)
	local frame = (isMe and Storyline_NPCFrameModelsMe or Storyline_NPCFrameModelsYou);
	frame.scale = scale;
	frame:InitializeCamera(scale);
	if save then
		saveStructureData("scale", isMe, scale);
	end
end

local function setModelFacing(facing, isMe, save)
	local frame = (isMe and Storyline_NPCFrameModelsMe or Storyline_NPCFrameModelsYou);
	frame.facing = facing;
	frame:SetFacing(facing * (isMe and 1 or -1));
	if save then
		saveStructureData("facing", isMe, facing);
	end
end

local function setModelFeet(feet, isMe, save)
	local frame = (isMe and Storyline_NPCFrameModelsMe or Storyline_NPCFrameModelsYou);
	frame.feet = feet;
	frame:SetHeightFactor(feet);
	if save then
		saveStructureData("feet", isMe, feet);
	end
end

local function setModelOffset(offset, isMe, save)
	local frame = (isMe and Storyline_NPCFrameModelsMe or Storyline_NPCFrameModelsYou);
	frame.offset = offset;
	frame:SetTargetDistance(offset * (isMe and 1 or -1));
	if save then
		saveStructureData("offset", isMe, offset);
	end
end

local function getBestValue(dataName, savedData, data, default)
	if savedData and savedData[dataName] then return savedData[dataName] end
	if data and data[dataName] then return data[dataName] end
	return default[dataName];
end

local function modelsLoaded()
	if Storyline_NPCFrameModelsYou.modelLoaded and Storyline_NPCFrameModelsMe.modelLoaded then

		Storyline_NPCFrameModelsYou.model = Storyline_NPCFrameModelsYou:GetModel();
		Storyline_NPCFrameModelsMe.model = Storyline_NPCFrameModelsMe:GetModel();

		local savedDataMe, savedDataYou, dataMe, dataYou = getDataStuctures(Storyline_NPCFrameModelsMe.model, Storyline_NPCFrameModelsYou.model);

		setModelHeight(getBestValue("scale", savedDataMe, dataMe, DEFAULT_SCALE.me), true, false);
		setModelFeet(getBestValue("feet", savedDataMe, dataMe, DEFAULT_SCALE.me), true, false);

		setModelOffset(getBestValue("offset", savedDataMe, dataMe, DEFAULT_SCALE.me), true, false);
		setModelFacing(getBestValue("facing", savedDataMe, dataMe, DEFAULT_SCALE.me), true, false);

		if Storyline_NPCFrameModelsYou.model:len() > 0 then
			setModelOffset(getBestValue("offset", savedDataYou, dataYou, DEFAULT_SCALE.you), false, false);
			setModelFacing(getBestValue("facing", savedDataYou, dataYou, DEFAULT_SCALE.you), false, false);
			setModelFeet(getBestValue("feet", savedDataYou, dataYou, DEFAULT_SCALE.you), false, false);
			setModelHeight(getBestValue("scale", savedDataYou, dataYou, DEFAULT_SCALE.you), false, false);
		else
			Storyline_NPCFrameModelsMe:SetAnimation(520);
		end

		if Storyline_NPCFrameModelsYou.model then
			Storyline_NPCFrameDebugModelYou:SetText(Storyline_NPCFrameModelsYou.model:gsub("\\", "\\\\"));
		end
		if Storyline_NPCFrameModelsMe.model then
			Storyline_NPCFrameDebugModelMe:SetText(Storyline_NPCFrameModelsMe.model:gsub("\\", "\\\\"));
		end
	end
end

function Storyline_API.startDialog(targetType, fullText, event, eventInfo)
	Storyline_NPCFrameDebugText:SetText(event);

	local guid = UnitGUID(targetType);
	local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid or "");
	Storyline_NPCFrameModelsYou.npc_id = npc_id;
	-- Dirty if to fix the flavor text appearing on naval mission table because Blizzard…
	if tContains(Storyline_NPC_BLACKLIST, npc_id) or tContains(Storyline_Data.npc_blacklist, npc_id)then
		SelectGossipOption(1);
		return;
	end

	local targetName = UnitName(targetType);

	if targetName and targetName:len() > 0 and targetName ~= UNKNOWN then
		Storyline_NPCFrameChatName:SetText(targetName);
	else
		if eventInfo.nameGetter and eventInfo.nameGetter() then
			Storyline_NPCFrameChatName:SetText(eventInfo.nameGetter());
		else
			Storyline_NPCFrameChatName:SetText("");
		end
	end

	if eventInfo.titleGetter and eventInfo.titleGetter() and eventInfo.titleGetter():len() > 0 then
		Storyline_NPCFrameBanner:Show();
		Storyline_NPCFrameTitle:SetText(eventInfo.titleGetter());
		if eventInfo.getTitleColor and eventInfo.getTitleColor() then
			Storyline_NPCFrameTitle:SetTextColor(eventInfo.getTitleColor());
		else
			Storyline_NPCFrameTitle:SetTextColor(0.95, 0.95, 0.95);
		end
	else
		Storyline_NPCFrameTitle:SetText("");
		Storyline_NPCFrameBanner:Hide();
	end

	Storyline_NPCFrameModelsMe.modelLoaded = false;
	Storyline_NPCFrameModelsYou.modelLoaded = false;
	Storyline_NPCFrameModelsYou.model = "";
	Storyline_NPCFrameModelsMe.model = "";
	Storyline_NPCFrameModelsMe:SetUnit("player", false);

	if UnitExists(targetType) and not UnitIsUnit("player", "npc") then
		Storyline_NPCFrameModelsYou:SetUnit(targetType, false);
	else
		Storyline_NPCFrameModelsYou:SetUnit("none");
		Storyline_NPCFrameModelsYou.modelLoaded = true;
	end

	fullText = fullText:gsub(LINE_FEED_CODE .. "+", "\n");
	fullText = fullText:gsub(WEIRD_LINE_BREAK, "\n");

	local texts = { strsplit("\n", fullText) };
	if texts[#texts]:len() == 0 then
		texts[#texts] = nil;
	end
	Storyline_NPCFrameChat.texts = texts;
	Storyline_NPCFrameChat.currentIndex = 0;
	Storyline_NPCFrameChat.eventInfo = eventInfo;
	Storyline_NPCFrameChat.event = event;
	Storyline_NPCFrameObjectivesContent:Hide();
	Storyline_NPCFrameChatPrevious:Hide();
	showStorylineFame();

	playNext(Storyline_NPCFrameModelsYou);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEXT ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_TEXT_SPEED = 80;

local function onUpdateChatText(self, elapsed)
	if self.start and Storyline_NPCFrameChatText:GetText() and Storyline_NPCFrameChatText:GetText():len() > 0 then
		self.start = self.start + (elapsed * (ANIMATION_TEXT_SPEED * Storyline_Data.config.textSpeedFactor or 0.5));
		if Storyline_Data.config.textSpeedFactor == 0 or self.start >= Storyline_NPCFrameChatText:GetText():len() then
			self.start = nil;
			Storyline_NPCFrameChatText:SetAlphaGradient(Storyline_NPCFrameChatText:GetText():len(), 1);
		else
			Storyline_NPCFrameChatText:SetAlphaGradient(self.start, 30);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function debugInit()
	if not Storyline_Data.config.debug then
		Storyline_NPCFrameDebug:Hide();
	end
	Storyline_NPCFrameDebugMeResetButton:SetScript("OnClick", function(self)
		resetStructure(true);
		modelsLoaded();
	end);
	Storyline_NPCFrameDebugYouResetButton:SetScript("OnClick", function(self)
		resetStructure(false);
		modelsLoaded();
	end);

	-- Scrolling on the 3D model frame to adjust the size of the models
	Storyline_NPCFrameModelsMeScrollZone:EnableMouseWheel(true);
	Storyline_NPCFrameModelsMeScrollZone:SetScript("OnMouseWheel", function(self, delta)
		if IsAltKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelHeight(Storyline_NPCFrameModelsMe.scale - 0.1 * delta, true, true);
			else
				setModelHeight(Storyline_NPCFrameModelsMe.scale - 0.01 * delta, true, true);
			end
		elseif IsControlKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelFacing(Storyline_NPCFrameModelsMe.facing - 0.2 * delta, true, true);
			else
				setModelFacing(Storyline_NPCFrameModelsMe.facing - 0.02 * delta, true, true);
			end
		end
	end);
	Storyline_NPCFrameModelsMeScrollZone:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	Storyline_NPCFrameModelsMeScrollZone:SetScript("OnClick", function(self, button)
		local factor = button == "LeftButton" and 1 or -1;
		if IsAltKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelOffset(Storyline_NPCFrameModelsMe.offset - 0.1 * factor, true, true);
			else
				setModelOffset(Storyline_NPCFrameModelsMe.offset - 0.01 * factor, true, true);
			end
		elseif IsControlKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelFeet(Storyline_NPCFrameModelsMe.feet - 0.1 * factor, true, true);
			else
				setModelFeet(Storyline_NPCFrameModelsMe.feet - 0.01 * factor, true, true);
			end
		end
	end);

	Storyline_NPCFrameModelsYouScrollZone:EnableMouseWheel(true);
	Storyline_NPCFrameModelsYouScrollZone:SetScript("OnMouseWheel", function(self, delta)
		if IsAltKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelHeight(Storyline_NPCFrameModelsYou.scale - 0.1 * delta, false, true);
			else
				setModelHeight(Storyline_NPCFrameModelsYou.scale - 0.01 * delta, false, true);
			end
		elseif IsControlKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelFacing(Storyline_NPCFrameModelsYou.facing - 0.2 * delta, false, true);
			else
				setModelFacing(Storyline_NPCFrameModelsYou.facing - 0.02 * delta, false, true);
			end
		end
	end);
	Storyline_NPCFrameModelsYouScrollZone:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	Storyline_NPCFrameModelsYouScrollZone:SetScript("OnClick", function(self, button)
		local factor = button == "LeftButton" and 1 or -1;
		if IsAltKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelOffset(Storyline_NPCFrameModelsYou.offset - 0.1 * factor, false, true);
			else
				setModelOffset(Storyline_NPCFrameModelsYou.offset - 0.01 * factor, false, true);
			end
		elseif IsControlKeyDown() then
			if IsShiftKeyDown() then -- If shift key down adjust my model
			setModelFeet(Storyline_NPCFrameModelsYou.feet - 0.1 * factor, false, true);
			else
				setModelFeet(Storyline_NPCFrameModelsYou.feet - 0.01 * factor, false, true);
			end
		end
	end);

	-- Debug for scaling
	Storyline_API.addon:RegisterChatCommand("storydebug", function()
		Storyline_API.startDialog("target", "Pouic", "SCALING_DEBUG", Storyline_API.EVENT_INFO.SCALING_DEBUG);
	end);

	setTooltipAll(Storyline_NPCFrameDebugMeResetButton, "TOP", 0, 0, "Reset values for 'my' model"); -- Debug, not localized
	setTooltipAll(Storyline_NPCFrameDebugYouResetButton, "TOP", 0, 0, "Reset values for 'his' model"); -- Debug, not localized
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Storyline_API.addon = LibStub("AceAddon-3.0"):NewAddon("Storyline", "AceConsole-3.0");

function Storyline_API.addon:OnEnable()

	if not Storyline_Data then
		Storyline_Data = {};
	end
	if not Storyline_Data.debug then
		Storyline_Data.debug = {};
	end
	if not Storyline_Data.scaling then
		Storyline_Data.scaling = {};
	end
	if not Storyline_Data.debug.timing then
		Storyline_Data.debug.timing = {};
	end
	if not Storyline_Data.config then
		Storyline_Data.config = {};
	end
	if not Storyline_Data.npc_blacklist then
		Storyline_Data.npc_blacklist = {};
	end

	ForceGossip = function() return Storyline_Data.config.forceGossip == true end

	Storyline_API.locale.init();
	Storyline_API.consolePort.init();

	Storyline_NPCFrameBG:SetDesaturated(true);
	Storyline_NPCFrameChatNext:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	Storyline_NPCFrameChatNext:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			if Storyline_NPCFrameChat.start and Storyline_NPCFrameChat.start < Storyline_NPCFrameChatText:GetText():len() then
				Storyline_NPCFrameChat.start = Storyline_NPCFrameChatText:GetText():len();  -- Stop current text animation
			end
			Storyline_NPCFrameChat.currentIndex = #Storyline_NPCFrameChat.texts - 1; -- Set current text index to the one before the last one
			playNext(Storyline_NPCFrameModelsYou); -- Play the next text (the last one)
			if Storyline_NPCFrameChat.start and Storyline_NPCFrameChat.start < Storyline_NPCFrameChatText:GetText():len() then
				Storyline_NPCFrameChat.start = Storyline_NPCFrameChatText:GetText():len();  -- Stop current text animation
			end
			playNext(Storyline_NPCFrameModelsYou); -- Execute next action (display gossip options, quest objectives, quest rewards or close dialog)
		else
			if Storyline_NPCFrameChat.start and Storyline_NPCFrameChat.start < Storyline_NPCFrameChatText:GetText():len() then
				Storyline_NPCFrameChat.start = Storyline_NPCFrameChatText:GetText():len();
			else
				playNext(Storyline_NPCFrameModelsYou);
			end
		end
	end);
	Storyline_NPCFrameChatPrevious:SetScript("OnClick", resetDialog);
	Storyline_NPCFrameChat:SetScript("OnUpdate", onUpdateChatText);
	Storyline_NPCFrameClose:SetScript("OnClick", closeDialog);
	Storyline_NPCFrameRewardsItem:SetScale(1.5);

	Storyline_NPCFrame:SetScript("OnKeyDown", function(self, key)
		if not Storyline_Data.config.useKeyboard then
			self:SetPropagateKeyboardInput(true);
			return;
		end

		if key == "SPACE" then
			self:SetPropagateKeyboardInput(false);
			Storyline_NPCFrameChatNext:Click(IsShiftKeyDown() and "RightButton" or "LeftButton");
		elseif key == "BACKSPACE" then
			self:SetPropagateKeyboardInput(false);
			Storyline_NPCFrameChatPrevious:Click();
		elseif key == "ESCAPE" then
			closeDialog();
		else
			local keyNumber = tonumber(key);
			if not keyNumber then
				self:SetPropagateKeyboardInput(true);
				return;
			end

			local foundFrames = 0;
			for i = 1, 9 do
				if _G["Storyline_NPCFrameChatOption" .. i] and _G["Storyline_NPCFrameChatOption" .. i].IsVisible and _G["Storyline_NPCFrameChatOption" .. i]:IsVisible() then
					foundFrames = foundFrames + 1;
					if foundFrames == keyNumber then
						_G["Storyline_NPCFrameChatOption" .. i]:Click();
						self:SetPropagateKeyboardInput(false);
						return;
					end
				end
			end

			self:SetPropagateKeyboardInput(true);
			return;
		end
	end);

	Storyline_NPCFrameGossipChoices:SetScript("OnKeyDown", function(self, key)
		if not Storyline_Data.config.useKeyboard then
			self:SetPropagateKeyboardInput(true);
			return;
		end

		if key == "ESCAPE" then
			Storyline_NPCFrameGossipChoices:Hide();
			self:SetPropagateKeyboardInput(false);
			return;
		end

		local keyNumber = tonumber(key);
		if not keyNumber then
			self:SetPropagateKeyboardInput(true);
			return;
		end

		if keyNumber == 0 then
			keyNumber = 10;
		end

		local foundFrames = 0;
		for i = 0, 9 do
			if _G["Storyline_ChoiceString" .. i] and _G["Storyline_ChoiceString" .. i].IsVisible and _G["Storyline_ChoiceString" .. i]:IsVisible() then
				foundFrames = foundFrames + 1;
				if foundFrames == keyNumber then
					_G["Storyline_ChoiceString" .. i]:Click();
					self:SetPropagateKeyboardInput(false);
					return;
				end
			end
		end

		self:SetPropagateKeyboardInput(true);
		return;

	end);

	Storyline_NPCFrameModelsYou.animTab = {};
	Storyline_NPCFrameModelsMe.animTab = {};

	Storyline_NPCFrameModelsYou:SetScript("OnUpdate", function(self, elapsed)
		if self.spin then
			self.spinAngle = self.spinAngle - (elapsed / 2);
			self:SetFacing(self.spinAngle);
		end
	end);

	-- Register events
	Storyline_API.initEventsStructure();

	-- 3D models loaded
	Storyline_NPCFrameModelsMe:SetScript("OnModelLoaded", function()
		Storyline_NPCFrameModelsMe.modelLoaded = true;
		modelsLoaded();
	end);

	Storyline_NPCFrameModelsYou:SetScript("OnModelLoaded", function()
		Storyline_NPCFrameModelsYou.modelLoaded = true;
		modelsLoaded();
	end);

	-- Closing
	registerHandler("GOSSIP_CLOSED", function()
		hideStorylineFrame();
	end);
	registerHandler("QUEST_FINISHED", function()
		hideStorylineFrame();
	end);

	-- Resizing
	local resizeChat = function()
		Storyline_NPCFrameChatText:SetWidth(Storyline_NPCFrame:GetWidth() - 150);
		Storyline_NPCFrameChat:SetHeight(Storyline_NPCFrameChatText:GetHeight() + CHAT_MARGIN + 5);
		Storyline_NPCFrameGossipChoices:SetWidth(Storyline_NPCFrame:GetWidth() - 400);
	end
	Storyline_NPCFrameChatText:SetWidth(550);
	Storyline_NPCFrameResizeButton.onResizeStop = function(width, height)
		resizeChat();
		Storyline_Data.config.width = width;
		Storyline_Data.config.height = height;
	end;
		Storyline_NPCFrame:SetSize(Storyline_Data.config.width or 700, Storyline_Data.config.height or 450);
	resizeChat();

	-- Debug
	debugInit();

	-- Slash command to show settings frames
	Storyline_API.addon:RegisterChatCommand("storyline", function()
		InterfaceOptionsFrame_OpenToCategory(StorylineOptionsPanel);
		if not Storyline_NPCFrameConfigButton.shown then -- Dirty fix for the Interface frame shitting itself the first time
			Storyline_NPCFrameConfigButton.shown = true;
			InterfaceOptionsFrame_OpenToCategory(StorylineOptionsPanel);
		end;
	end);

	setTooltipAll(Storyline_NPCFrameConfigButton, "TOP", 0, 0, loc("SL_CONFIG"));


	Storyline_NPCFrame:RegisterForDrag("LeftButton");

	Storyline_NPCFrame:SetScript("OnDragStart", function(self)
		if not Storyline_API.layout.isFrameLocked() then
			self:StartMoving();
		end
	end);

	Storyline_NPCFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
	end);

	Storyline_API.options.init();
end
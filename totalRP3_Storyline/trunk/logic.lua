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

-- WOW API
local strsplit, pairs = strsplit, pairs;
local UnitIsUnit, UnitExists, UnitName = UnitIsUnit, UnitExists, UnitName;

-- UI
local Storyline_NPCFrame = Storyline_NPCFrame;
local Storyline_NPCFrameChat, Storyline_NPCFrameChatText = Storyline_NPCFrameChat, Storyline_NPCFrameChatText;
local Storyline_NPCFrameChatNext, Storyline_NPCFrameChatPrevious = Storyline_NPCFrameChatNext, Storyline_NPCFrameChatPrevious;
local Storyline_NPCFrameModelsYou, Storyline_NPCFrameModelsMe = Storyline_NPCFrameModelsYou, Storyline_NPCFrameModelsMe;
local Storyline_NPCFrameDebugText, Storyline_NPCFrameChatName, Storyline_NPCFrameBanner = Storyline_NPCFrameDebugText, Storyline_NPCFrameChatName, Storyline_NPCFrameBanner;
local Storyline_NPCFrameTitle, Storyline_NPCFrameDebugModelYou, Storyline_NPCFrameDebugModelMe = Storyline_NPCFrameTitle, Storyline_NPCFrameDebugModelYou, Storyline_NPCFrameDebugModelMe;

local Storyline_NPCFrameDebugMeHeightSlider, Storyline_NPCFrameDebugYouHeightSlider = Storyline_NPCFrameDebugMeHeightSlider, Storyline_NPCFrameDebugYouHeightSlider;
local Storyline_NPCFrameDebugMeFeetSlider, Storyline_NPCFrameDebugYouFeetSlider = Storyline_NPCFrameDebugMeFeetSlider, Storyline_NPCFrameDebugYouFeetSlider;
local Storyline_NPCFrameDebugMeOffsetSlider, Storyline_NPCFrameDebugYouOffsetSlider = Storyline_NPCFrameDebugMeOffsetSlider, Storyline_NPCFrameDebugYouOffsetSlider;
local Storyline_NPCFrameDebugMeFacingSlider, Storyline_NPCFrameDebugYouFacingSlider = Storyline_NPCFrameDebugMeFacingSlider, Storyline_NPCFrameDebugYouFacingSlider;

-- Constants
local DEBUG = true;
local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;
local CHAT_MARGIN = 70;
local DEFAULT_MODEL_SCALE = {
	me = {
		height = 1.3,
		feet = 0.4,
		offset = 0.2,
		facing = 0.75
	},
	you = {
		height = 1.3,
		feet = 0.4,
		offset = -0.2,
		facing = -0.75
	}
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function closeDialog()
	if Storyline_NPCFrameChat.eventInfo and Storyline_NPCFrameChat.eventInfo.cancelMethod then
		Storyline_NPCFrameChat.eventInfo.cancelMethod();
	else
		Storyline_NPCFrame:Hide();
	end
end

local function resetDialog()
	Storyline_NPCFrameObjectivesContent:Hide();
	Storyline_NPCFrameChat.currentIndex = 0;
	playNext(Storyline_NPCFrameModelsYou);
end

local _, _, screenWidth, screenHeight = WorldFrame:GetBoundsRect();

local function hideOriginalFrames()
	GossipFrame:ClearAllPoints();
	GossipFrame:SetPoint("TOPLEFT", screenWidth, screenHeight);
	QuestFrame:ClearAllPoints();
	QuestFrame:SetPoint("TOPLEFT", screenWidth, screenHeight);
end

Storyline_API.hideOriginalFrames = hideOriginalFrames;

local function showOriginalFrames()
	GossipFrame:ClearAllPoints();
	GossipFrame:SetPoint("TOPLEFT", 16, -116);
	QuestFrame:ClearAllPoints();
	QuestFrame:SetPoint("TOPLEFT", 16, -116);
end

local function modelsLoaded()
	if Storyline_NPCFrameModelsYou.modelLoaded and Storyline_NPCFrameModelsMe.modelLoaded then

		local scale = {
			me = {
				height = 1.3,
				feet = 0.4,
				offset = 0.2,
				facing = 0.75
			},
			you = {
				height = 1.3,
				feet = 0.4,
				offset = -0.2,
				facing = -0.75
			}
		};
		Storyline_NPCFrameModelsYou.model = Storyline_NPCFrameModelsYou:GetModel();
		Storyline_NPCFrameModelsMe.model = Storyline_NPCFrameModelsMe:GetModel();

		if Storyline_NPCFrameModelsYou.model:len() > 0 then
			local key, invertedKey = Storyline_NPCFrameModelsMe.model .. "~" .. Storyline_NPCFrameModelsYou.model, Storyline_NPCFrameModelsYou.model .. "~" .. Storyline_NPCFrameModelsMe.model;
			if Storyline_SCALE_MAPPING[key] then
				scale = Storyline_SCALE_MAPPING[key];
			elseif Storyline_SCALE_MAPPING[invertedKey] then
				scale.me = Storyline_SCALE_MAPPING[invertedKey].you;
				scale.you = Storyline_SCALE_MAPPING[invertedKey].me;
				scale.me.offset = -scale.me.offset;
				scale.me.facing = -scale.me.facing;
				scale.you.offset = -scale.you.offset;
				scale.you.facing = -scale.you.facing;
			end
			if Storyline_Data.debug.scaling[key] then
				scale = Storyline_Data.debug.scaling[key];
			elseif Storyline_Data.debug.scaling[invertedKey] then
				scale.me = Storyline_Data.debug.scaling[invertedKey].you;
				scale.you = Storyline_Data.debug.scaling[invertedKey].me;
				scale.me.offset = -scale.me.offset;
				scale.me.facing = -scale.me.facing;
				scale.you.offset = -scale.you.offset;
				scale.you.facing = -scale.you.facing;
			end

			Storyline_NPCFrameDebugMeOffsetSlider:SetValue(scale.me.offset);
			Storyline_NPCFrameDebugMeFacingSlider:SetValue(scale.me.facing);
			Storyline_NPCFrameDebugMeFeetSlider:SetValue(scale.me.feet);
			Storyline_NPCFrameDebugMeHeightSlider:SetValue(scale.me.height);

			Storyline_NPCFrameDebugYouOffsetSlider:SetValue(scale.you.offset);
			Storyline_NPCFrameDebugYouFacingSlider:SetValue(scale.you.facing);
			Storyline_NPCFrameDebugYouFeetSlider:SetValue(scale.you.feet);
			Storyline_NPCFrameDebugYouHeightSlider:SetValue(scale.you.height);
		else
			Storyline_NPCFrameDebugMeOffsetSlider:SetValue(0);
			Storyline_NPCFrameDebugMeFacingSlider:SetValue(0);
			Storyline_NPCFrameDebugMeFeetSlider:SetValue(scale.me.feet);
			Storyline_NPCFrameDebugMeHeightSlider:SetValue(scale.me.height);
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
	if Storyline_Data.config.hideOriginalFrames then
		hideOriginalFrames();
	end


	local guid = UnitGUID(targetType);
	local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid);
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
	Storyline_NPCFrame:Show();

	playNext(Storyline_NPCFrameModelsYou);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEXT ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_TEXT_SPEED = 80;
local textSpeedFactor = 0.5;

local function onUpdateChatText(self, elapsed)
	if self.start and Storyline_NPCFrameChatText:GetText() and Storyline_NPCFrameChatText:GetText():len() > 0 then
		self.start = self.start + (elapsed * (ANIMATION_TEXT_SPEED * textSpeedFactor));
		if textSpeedFactor == 0 or self.start >= Storyline_NPCFrameChatText:GetText():len() then
			self.start = nil;
			Storyline_NPCFrameChatText:SetAlphaGradient(Storyline_NPCFrameChatText:GetText():len(), 1);
		else
			Storyline_NPCFrameChatText:SetAlphaGradient(self.start, 30);
		end
	end
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
	if not Storyline_Data.debug.scaling then
		Storyline_Data.debug.scaling = {};
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

	Storyline_NPCFrameBG:SetDesaturated(true);
	Storyline_NPCFrameChatNext:SetScript("OnClick", function()
		if Storyline_NPCFrameChat.start and Storyline_NPCFrameChat.start < Storyline_NPCFrameChatText:GetText():len() then
			Storyline_NPCFrameChat.start = Storyline_NPCFrameChatText:GetText():len();
		else
			playNext(Storyline_NPCFrameModelsYou);
		end
	end);
	Storyline_NPCFrameChatPrevious:SetScript("OnClick", resetDialog);
	Storyline_NPCFrameChat:SetScript("OnUpdate", onUpdateChatText);
	Storyline_NPCFrameClose:SetScript("OnClick", closeDialog);
	Storyline_NPCFrameRewardsItem:SetScale(1.5);

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
		Storyline_NPCFrame:Hide();
	end);
	registerHandler("QUEST_FINISHED", function()
		Storyline_NPCFrame:Hide();
	end);

	-- DressUpFrame
	DressUpFrameCloseButton:HookScript("OnClick", function()
		if Storyline_Data.config.hideOriginalFrames and Storyline_NPCFrame:IsVisible() then
			hideOriginalFrames();
		end
	end)

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

	local function saveResizedModels()
		if Storyline_NPCFrameModelsMe.model and Storyline_NPCFrameModelsYou.model then
			Storyline_Data.debug.scaling[Storyline_NPCFrameModelsMe.model .. "~" .. Storyline_NPCFrameModelsYou.model] = {
				me = {
					height = Storyline_NPCFrameDebugMeHeightSlider:GetValue(),
					feet = Storyline_NPCFrameDebugMeFeetSlider:GetValue(),
					offset = Storyline_NPCFrameDebugMeOffsetSlider:GetValue(),
					facing = Storyline_NPCFrameDebugMeFacingSlider:GetValue()
				},
				you = {
					height = Storyline_NPCFrameDebugYouHeightSlider:GetValue(),
					feet = Storyline_NPCFrameDebugYouFeetSlider:GetValue(),
					offset = Storyline_NPCFrameDebugYouOffsetSlider:GetValue(),
					facing = Storyline_NPCFrameDebugYouFacingSlider:GetValue()
				}
			};
		end
	end

	-- Debug
	Storyline_NPCFrameDebug:Hide();
	Storyline_NPCFrameDebugMeHeightSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugMeHeightSliderValText:SetText("Height: " .. scale);
		Storyline_NPCFrameModelsMe:InitializeCamera(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugYouHeightSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugYouHeightSliderValText:SetText("Height: " .. scale);
		Storyline_NPCFrameModelsYou:InitializeCamera(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugMeFeetSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugMeFeetSliderValText:SetText("Feet: " .. scale);
		Storyline_NPCFrameModelsMe:SetHeightFactor(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugYouFeetSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugYouFeetSliderValText:SetText("Feet: " .. scale);
		Storyline_NPCFrameModelsYou:SetHeightFactor(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugMeOffsetSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugMeOffsetSliderValText:SetText("Offset: " .. scale);
		Storyline_NPCFrameModelsMe:SetTargetDistance(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugYouOffsetSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugYouOffsetSliderValText:SetText("Offset: " .. scale);
		Storyline_NPCFrameModelsYou:SetTargetDistance(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugMeFacingSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugMeFacingSliderValText:SetText("Facing: " .. scale);
		Storyline_NPCFrameModelsMe:SetFacing(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugYouFacingSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugYouFacingSliderValText:SetText("Facing: " .. scale);
		Storyline_NPCFrameModelsYou:SetFacing(scale);
		saveResizedModels();
	end);
	Storyline_NPCFrameDebugMeResetButton:SetScript("OnClick", function(self)
		Storyline_NPCFrameDebugMeHeightSlider:SetValue(DEFAULT_MODEL_SCALE.me.height);
		Storyline_NPCFrameDebugMeFeetSlider:SetValue(DEFAULT_MODEL_SCALE.me.feet);
		Storyline_NPCFrameDebugMeOffsetSlider:SetValue(DEFAULT_MODEL_SCALE.me.offset);
		Storyline_NPCFrameDebugMeFacingSlider:SetValue(DEFAULT_MODEL_SCALE.me.facing);
	end);
	Storyline_NPCFrameDebugYouResetButton:SetScript("OnClick", function(self)
		Storyline_NPCFrameDebugYouHeightSlider:SetValue(DEFAULT_MODEL_SCALE.you.height);
		Storyline_NPCFrameDebugYouFeetSlider:SetValue(DEFAULT_MODEL_SCALE.you.feet);
		Storyline_NPCFrameDebugYouOffsetSlider:SetValue(DEFAULT_MODEL_SCALE.you.offset);
		Storyline_NPCFrameDebugYouFacingSlider:SetValue(DEFAULT_MODEL_SCALE.you.facing);
	end);

	Storyline_NPCFrameModelsMe:EnableMouseWheel(true);
	Storyline_NPCFrameModelsMe:SetScript("OnMouseWheel", function(self, delta)
		if Storyline_NPCFrameDebug:IsVisible() or (IsAltKeyDown() and IsControlKeyDown()) then
			if IsShiftKeyDown() then
				Storyline_NPCFrameDebugYouHeightSlider:SetValue(Storyline_NPCFrameDebugYouHeightSlider:GetValue() - 0.01 * delta);
			else
				Storyline_NPCFrameDebugMeHeightSlider:SetValue(Storyline_NPCFrameDebugMeHeightSlider:GetValue() - 0.01 * delta);
			end
		end
	end)

	-- Slash command to reset frames
	Storyline_API.addon:RegisterChatCommand("storyline", function()
		InterfaceOptionsFrame_OpenToCategory(StorylineOptionsPanel);
	end);

	-- Config
	setTooltipAll(Storyline_NPCFrameConfigButton, "TOP", 0, 0, loc("SL_CONFIG"));
	StorylineOptionsPanelTitle:SetText(loc("SL_CONFIG"));

	-- Text speed slider
	StorylineTextOptionsPanelSpeedSliderTitle:SetText(loc("SL_CONFIG_TEXTSPEED_TITLE"));
	Storyline_NPCFrameConfigSpeedSliderLow:SetText(loc("SL_CONFIG_TEXTSPEED_INSTANT"));
	Storyline_NPCFrameConfigSpeedSliderHigh:SetText(loc("SL_CONFIG_TEXTSPEED_HIGH"));
	Storyline_NPCFrameConfigSpeedSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameConfigSpeedSliderText:SetText(loc("SL_CONFIG_TEXTSPEED"):format(scale));
		textSpeedFactor = scale;
		Storyline_Data.config.textSpeedFactor = textSpeedFactor;
	end);
	textSpeedFactor = Storyline_Data.config.textSpeedFactor or textSpeedFactor;
	Storyline_NPCFrameConfigSpeedSlider:SetValue(textSpeedFactor);

	-- Text speed slider
	StorylineTextOptionsPanelQuestTitleSizeSliderTitle:SetText("Quest title");
	StorylineTextOptionsPanelQuestTitleSizeSliderTitle:SetPoint("TOPLEFT", Storyline_NPCFrameConfigSpeedSlider, "BOTTOMLEFT", 0, -15);
	Storyline_NPCFrameConfigQuestTitleTextSizeSliderLow:SetText(9);
	Storyline_NPCFrameConfigQuestTitleTextSizeSliderHigh:SetText(25);
	Storyline_NPCFrameConfigQuestTitleTextSizeSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameConfigQuestTitleTextSizeSliderText:SetText(scale);
		local font, _, outline = Storyline_NPCFrameChatText:GetFont();
		Storyline_NPCFrameTitle:SetFont(font, scale, outline);
		Storyline_Data.config.questTitleSize = scale;
	end);
	Storyline_NPCFrameConfigQuestTitleTextSizeSlider:SetValue(Storyline_Data.config.questTitleTextSize or select(2,Storyline_NPCFrameTitle:GetFont()));

	-- Text speed slider
	StorylineTextOptionsPanelTextSizeSliderTitle:SetText("Dialog text");
	StorylineTextOptionsPanelTextSizeSliderTitle:SetPoint("TOPLEFT", Storyline_NPCFrameConfigQuestTitleTextSizeSlider, "BOTTOMLEFT", 0, -15);
	Storyline_NPCFrameConfigChatTextSizeSliderLow:SetText(9);
	Storyline_NPCFrameConfigChatTextSizeSliderHigh:SetText(25);
	Storyline_NPCFrameConfigChatTextSizeSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameConfigChatTextSizeSliderText:SetText(scale);
		local font, _, outline = Storyline_NPCFrameChatText:GetFont();
		Storyline_NPCFrameChatText:SetFont(font, scale, outline);
		Storyline_Data.config.chatTextSize = scale;
	end);
	Storyline_NPCFrameConfigChatTextSizeSlider:SetValue(Storyline_Data.config.chatTextSize or 16);
	-- Text speed slider
	StorylineTextOptionsPanelNameSizeSliderTitle:SetText("NPC name");
	StorylineTextOptionsPanelNameSizeSliderTitle:SetPoint("TOPLEFT", Storyline_NPCFrameConfigChatTextSizeSlider, "BOTTOMLEFT", 0, -15);
	Storyline_NPCFrameConfigChatNameSizeSliderLow:SetText(9);
	Storyline_NPCFrameConfigChatNameSizeSliderHigh:SetText(25);
	Storyline_NPCFrameConfigChatNameSizeSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameConfigChatNameSizeSliderText:SetText(scale);
		local font, _, outline = Storyline_NPCFrameChatName:GetFont();
		Storyline_NPCFrameChatName:SetFont(font, scale, outline);
		Storyline_Data.config.chatNameSize = scale;
	end);
	Storyline_NPCFrameConfigChatNameSizeSlider:SetValue(Storyline_Data.config.chatNameSize or 16);

	local Storyline_NPCFrameChatNextText = Storyline_NPCFrameChatNextText;
	StorylineTextOptionsPanelNextSizeSliderTitle:SetText("Next action text");
	StorylineTextOptionsPanelNextSizeSliderTitle:SetPoint("TOPLEFT", Storyline_NPCFrameConfigChatNameSizeSlider, "BOTTOMLEFT", 0, -15);
	Storyline_NPCFrameConfigChatNextSizeSliderLow:SetText(9);
	Storyline_NPCFrameConfigChatNextSizeSliderHigh:SetText(25);
	Storyline_NPCFrameConfigChatNextSizeSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameConfigChatNextSizeSliderText:SetText(scale);
		local font, _, outline = Storyline_NPCFrameChatNextText:GetFont();
		Storyline_NPCFrameChatNextText:SetFont(font, scale, outline);
		Storyline_Data.config.chatNextTextSize = scale;
	end);
	Storyline_NPCFrameConfigChatNextSizeSlider:SetValue(Storyline_Data.config.chatNextTextSize or 10);

	-- Auto equip option
	StorylineMiscellaneousOptionsPanel.AutoEquip.Text:SetText(loc("SL_CONFIG_AUTOEQUIP"));
	StorylineMiscellaneousOptionsPanel.AutoEquip.tooltip = loc("SL_CONFIG_AUTOEQUIP_TT");
	StorylineMiscellaneousOptionsPanel.AutoEquip:SetScript("OnClick", function(self)
		Storyline_Data.config.autoEquip = self:GetChecked() == true;
	end);
	StorylineMiscellaneousOptionsPanel.AutoEquip:SetChecked(Storyline_Data.config.autoEquip);

	-- Force gossip option
	StorylineMiscellaneousOptionsPanel.ForceGossip.Text:SetText(loc("SL_CONFIG_FORCEGOSSIP"));
	StorylineMiscellaneousOptionsPanel.ForceGossip.tooltip = loc("SL_CONFIG_FORCEGOSSIP_TT");
	StorylineMiscellaneousOptionsPanel.ForceGossip:SetScript("OnClick", function(self)
		Storyline_Data.config.forceGossip = self:GetChecked() == true;
	end);
	StorylineMiscellaneousOptionsPanel.ForceGossip:SetChecked(Storyline_Data.config.forceGossip);

	-- Hide original frames option
	StorylineMiscellaneousOptionsPanel.HideOriginalFrames.Text:SetText(loc("SL_CONFIG_HIDEORIGINALFRAMES"));
	StorylineMiscellaneousOptionsPanel.HideOriginalFrames.tooltip = loc("SL_CONFIG_HIDEORIGINALFRAMES_TT");
	StorylineMiscellaneousOptionsPanel.HideOriginalFrames:SetScript("OnClick", function(self)
		Storyline_Data.config.hideOriginalFrames = self:GetChecked() == true;
		if Storyline_Data.config.hideOriginalFrames then
			hideOriginalFrames();
		else
			showOriginalFrames();
		end
	end);
	if Storyline_Data.config.hideOriginalFrames == nil then
		Storyline_Data.config.hideOriginalFrames = true;
	end
	StorylineMiscellaneousOptionsPanel.HideOriginalFrames:SetChecked(Storyline_Data.config.hideOriginalFrames);

	local localeTab = {
		{ "English", "enUS" },
		{ "Français", "frFR" },
	};
	local init = true;
	Storyline_API.lib.setupListBox(Storyline_NPCFrameConfigLocale, localeTab, function(locale)
		Storyline_Data.config.locale = locale;
		if not init then
			ReloadUI();
		end
	end, nil, 100, true);
	Storyline_NPCFrameConfigLocale:SetSelectedValue(Storyline_Data.config.locale or Storyline_API.locale.DEFAULT_LOCALE);
	init = false;
end
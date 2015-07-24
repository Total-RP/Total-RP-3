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
local Storyline_NPCFrameDebugScaleSlider = Storyline_NPCFrameDebugScaleSlider;

-- Constants
local DEBUG = true;
local LINE_FEED_CODE = string.char(10);
local CARRIAGE_RETURN_CODE = string.char(13);
local WEIRD_LINE_BREAK = LINE_FEED_CODE .. CARRIAGE_RETURN_CODE .. LINE_FEED_CODE;
local CHAT_MARGIN = 70;

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

function Storyline_API.startDialog(targetType, fullText, event, eventInfo)
	Storyline_NPCFrameDebugText:SetText(event);

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

	Storyline_NPCFrame.targetType = targetType;
	Storyline_NPCFrame:Show();
	Storyline_NPCFrameModelsYou.model = nil;
	Storyline_NPCFrameModelsMe:SetLight(1, 0, 0, -1, -1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	Storyline_NPCFrameModelsMe:SetCamera(1);
	Storyline_NPCFrameModelsMe:SetFacing(.75);
	Storyline_NPCFrameModelsMe:SetUnit("player");
	Storyline_NPCFrameModelsMe.model = Storyline_NPCFrameModelsMe:GetModel();
	Storyline_NPCFrameModelsYou:SetLight(1, 0, 0, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	Storyline_NPCFrameModelsYou:SetCamera(1);
	Storyline_NPCFrameModelsYou:SetFacing(-.75);

	if UnitExists(targetType) and not UnitIsUnit("player", "npc") then
		Storyline_NPCFrameModelsYou:SetUnit(targetType);
	else
		Storyline_NPCFrameModelsMe:SetAnimation(520);
		Storyline_NPCFrameModelsYou:SetModel("world/expansion04/doodads/pandaren/scroll/pa_scroll_10.mo3");
	end
	Storyline_NPCFrameModelsYou.model = Storyline_NPCFrameModelsYou:GetModel();

	if Storyline_NPCFrameModelsYou.model then
		Storyline_NPCFrameDebugModelYou:SetText(Storyline_NPCFrameModelsYou.model:gsub("\\", "\\\\"));
	end
	if Storyline_NPCFrameModelsMe.model then
		Storyline_NPCFrameDebugModelMe:SetText(Storyline_NPCFrameModelsMe.model:gsub("\\", "\\\\"));
	end

	local scale = 0;
	if Storyline_NPCFrameModelsYou.model and Storyline_NPCFrameModelsMe.model then
		local key, invertKey = Storyline_NPCFrameModelsMe.model .. "~" .. Storyline_NPCFrameModelsYou.model, Storyline_NPCFrameModelsYou.model .. "~" .. Storyline_NPCFrameModelsMe.model;
		scale = Storyline_Data.debug.scaling[key] or Storyline_SCALE_MAPPING[key] or -(Storyline_Data.debug.scaling[invertKey] or Storyline_SCALE_MAPPING[invertKey] or 0);
	end
	Storyline_NPCFrameDebugScaleSlider:SetValue(scale);

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
	ForceGossip = function() return true end

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
	if Storyline_Data.config.autoEquip == nil then
		Storyline_Data.config.autoEquip = true;
	end

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

	-- Closing
	registerHandler("GOSSIP_CLOSED", function()
		Storyline_NPCFrame:Hide();
	end);
	registerHandler("QUEST_FINISHED", function()
		Storyline_NPCFrame:Hide();
	end);

	-- Resizing
	local resizeChat = function()
		Storyline_NPCFrameChatText:SetWidth(Storyline_NPCFrame:GetWidth() - 150);
		Storyline_NPCFrameChat:SetHeight(Storyline_NPCFrameChatText:GetHeight() + CHAT_MARGIN + 5);
	end
	Storyline_NPCFrameChatText:SetWidth(550);
	Storyline_NPCFrameResizeButton.onResizeStop = function(width, height)
		resizeChat();
		Storyline_Data.config.width = width;
		Storyline_Data.config.height = height;
	end;
	Storyline_NPCFrame:SetSize(Storyline_Data.config.width or 700, Storyline_Data.config.height or 450);
	resizeChat();


	local resizeModels = function(scale)
		local margin = scale < 0 and -scale or 0;
		Storyline_NPCFrameModelsMe:ClearAllPoints();
		Storyline_NPCFrameModelsMe:SetPoint("TOP", 0, -(margin * 2));
		Storyline_NPCFrameModelsMe:SetPoint("LEFT", margin, 0);
		Storyline_NPCFrameModelsMe:SetPoint("BOTTOM", 0, 0);
		Storyline_NPCFrameModelsMe:SetPoint("RIGHT", Storyline_NPCFrameModelsPoint, "LEFT", -margin, 0);

		margin = scale > 0 and scale or 0;
		Storyline_NPCFrameModelsYou:ClearAllPoints();
		Storyline_NPCFrameModelsYou:SetPoint("TOP", 0, -(margin * 2));
		Storyline_NPCFrameModelsYou:SetPoint("RIGHT", -margin, 0);
		Storyline_NPCFrameModelsYou:SetPoint("BOTTOM", 0, 0);
		Storyline_NPCFrameModelsYou:SetPoint("LEFT", Storyline_NPCFrameModelsPoint, "RIGHT", margin, 0);
	end

	-- Debug
	Storyline_NPCFrameDebug:Hide();
	Storyline_NPCFrameDebugScaleSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameDebugScaleSliderValText:SetText("Scale: " .. scale);
		resizeModels(scale);
		Storyline_Data.debug.scaling[Storyline_NPCFrameDebugModelMe:GetText():gsub("\\\\", "\\") .. "~" .. Storyline_NPCFrameDebugModelYou:GetText():gsub("\\\\", "\\")] = scale;
	end);

	-- Slash command to reset frames
	Storyline_API.addon:RegisterChatCommand("storyline", function()
		ToggleFrame(Storyline_NPCFrameDebug);
	end);

	-- Config
	setTooltipAll(Storyline_NPCFrameConfigButton, "TOP", 0, 0, loc("SL_CONFIG"));
	Storyline_NPCFrameConfigSpeedSliderLow:SetText(loc("SL_CONFIG_TEXTSPEED_INSTANT"));
	Storyline_NPCFrameConfigSpeedSliderHigh:SetText(loc("SL_CONFIG_TEXTSPEED_HIGH"));
	Storyline_NPCFrameConfigText:SetText(loc("SL_CONFIG"));
	Storyline_NPCFrameConfigSpeedSlider:SetScript("OnValueChanged", function(self, scale)
		Storyline_NPCFrameConfigSpeedSliderValText:SetText(loc("SL_CONFIG_TEXTSPEED"):format(scale));
		textSpeedFactor = scale;
		Storyline_Data.config.textSpeedFactor = textSpeedFactor;
	end);
	textSpeedFactor = Storyline_Data.config.textSpeedFactor or textSpeedFactor;
	Storyline_NPCFrameConfigSpeedSlider:SetValue(textSpeedFactor);
	Storyline_NPCFrameConfig.AutoEquip.Text:SetText(loc("SL_CONFIG_AUTOEQUIP"));
	setTooltipForSameFrame(Storyline_NPCFrameConfig.AutoEquip, "RIGHT", 0, 0, loc("SL_CONFIG_AUTOEQUIP"), loc("SL_CONFIG_AUTOEQUIP_TT"));
	Storyline_NPCFrameConfig.AutoEquip:SetScript("OnClick", function(self)
		Storyline_Data.config.autoEquip = self:GetChecked() == true;
	end);
	Storyline_NPCFrameConfig.AutoEquip:SetChecked(Storyline_Data.config.autoEquip);
end
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

-- TRP3 API
local Utils = TRP3_API.utils;
local loc = TRP3_API.locale.getText;
local setTooltipForSameFrame, setTooltipAll = TRP3_API.ui.tooltip.setTooltipForSameFrame, TRP3_API.ui.tooltip.setTooltipAll;

-- Storyline API
local playNext = TRP3_StorylineAPI.playNext;

-- WOW API
local strsplit, pairs = strsplit, pairs;
local UnitIsUnit, UnitExists, UnitName = UnitIsUnit, UnitExists, UnitName;

-- UI
local TRP3_NPCDialogFrame = TRP3_NPCDialogFrame;
local TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText = TRP3_NPCDialogFrameChat, TRP3_NPCDialogFrameChatText;
local TRP3_NPCDialogFrameChatNext, TRP3_NPCDialogFrameChatPrevious = TRP3_NPCDialogFrameChatNext, TRP3_NPCDialogFrameChatPrevious;
local TRP3_NPCDialogFrameModelsYou, TRP3_NPCDialogFrameModelsMe = TRP3_NPCDialogFrameModelsYou, TRP3_NPCDialogFrameModelsMe;
local TRP3_NPCDialogFrameDebugText, TRP3_NPCDialogFrameChatName, TRP3_NPCDialogFrameBanner = TRP3_NPCDialogFrameDebugText, TRP3_NPCDialogFrameChatName, TRP3_NPCDialogFrameBanner;
local TRP3_NPCDialogFrameTitle, TRP3_NPCDialogFrameDebugModelYou, TRP3_NPCDialogFrameDebugModelMe = TRP3_NPCDialogFrameTitle, TRP3_NPCDialogFrameDebugModelYou, TRP3_NPCDialogFrameDebugModelMe;
local TRP3_NPCDialogFrameDebugScaleSlider = TRP3_NPCDialogFrameDebugScaleSlider;

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
	if TRP3_NPCDialogFrameChat.eventInfo and TRP3_NPCDialogFrameChat.eventInfo.cancelMethod then
		TRP3_NPCDialogFrameChat.eventInfo.cancelMethod();
	else
		TRP3_NPCDialogFrame:Hide();
	end
end

local function resetDialog()
	TRP3_NPCDialogFrameObjectivesContent:Hide();
	TRP3_NPCDialogFrameChat.currentIndex = 0;
	playNext(TRP3_NPCDialogFrameModelsYou);
end

function TRP3_StorylineAPI.startDialog(targetType, fullText, event, eventInfo)
	TRP3_NPCDialogFrameDebugText:SetText(event);

	local targetName = UnitName(targetType);

	if targetName and targetName:len() > 0 and targetName ~= UNKNOWN then
		TRP3_NPCDialogFrameChatName:SetText(targetName);
	else
		if eventInfo.nameGetter and eventInfo.nameGetter() then
			TRP3_NPCDialogFrameChatName:SetText(eventInfo.nameGetter());
		else
			TRP3_NPCDialogFrameChatName:SetText("");
		end
	end

	if eventInfo.titleGetter and eventInfo.titleGetter() and eventInfo.titleGetter():len() > 0 then
		TRP3_NPCDialogFrameBanner:Show();
		TRP3_NPCDialogFrameTitle:SetText(eventInfo.titleGetter());
		if eventInfo.getTitleColor and eventInfo.getTitleColor() then
			TRP3_NPCDialogFrameTitle:SetTextColor(eventInfo.getTitleColor());
		else
			TRP3_NPCDialogFrameTitle:SetTextColor(0.95, 0.95, 0.95);
		end
	else
		TRP3_NPCDialogFrameTitle:SetText("");
		TRP3_NPCDialogFrameBanner:Hide();
	end

	TRP3_NPCDialogFrame.targetType = targetType;
	TRP3_NPCDialogFrame:Show();
	TRP3_NPCDialogFrameModelsYou.model = nil;
	TRP3_NPCDialogFrameModelsMe:SetLight(1, 0, 0, -1, -1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	TRP3_NPCDialogFrameModelsMe:SetCamera(1);
	TRP3_NPCDialogFrameModelsMe:SetFacing(.75);
	TRP3_NPCDialogFrameModelsMe:SetUnit("player");
	TRP3_NPCDialogFrameModelsMe.model = TRP3_NPCDialogFrameModelsMe:GetModel();
	TRP3_NPCDialogFrameModelsYou:SetLight(1, 0, 0, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
	TRP3_NPCDialogFrameModelsYou:SetCamera(1);
	TRP3_NPCDialogFrameModelsYou:SetFacing(-.75);

	if UnitExists(targetType) and not UnitIsUnit("player", "npc") then
		TRP3_NPCDialogFrameModelsYou:SetUnit(targetType);
	else
		TRP3_NPCDialogFrameModelsMe:SetAnimation(520);
		TRP3_NPCDialogFrameModelsYou:SetModel("world/expansion04/doodads/pandaren/scroll/pa_scroll_10.mo3");
	end
	TRP3_NPCDialogFrameModelsYou.model = TRP3_NPCDialogFrameModelsYou:GetModel();

	if TRP3_NPCDialogFrameModelsYou.model then
		TRP3_NPCDialogFrameDebugModelYou:SetText(TRP3_NPCDialogFrameModelsYou.model:gsub("\\", "\\\\"));
	end
	if TRP3_NPCDialogFrameModelsMe.model then
		TRP3_NPCDialogFrameDebugModelMe:SetText(TRP3_NPCDialogFrameModelsMe.model:gsub("\\", "\\\\"));
	end

	local scale = 0;
	if TRP3_NPCDialogFrameModelsYou.model and TRP3_NPCDialogFrameModelsMe.model then
		local key, invertKey = TRP3_NPCDialogFrameModelsMe.model .. "~" .. TRP3_NPCDialogFrameModelsYou.model, TRP3_NPCDialogFrameModelsYou.model .. "~" .. TRP3_NPCDialogFrameModelsMe.model;
		scale = TRP3_Storyline.debug.scaling[key] or TRP3_SCALE_MAPPING[key] or -(TRP3_Storyline.debug.scaling[invertKey] or TRP3_SCALE_MAPPING[invertKey] or 0);
	end
	TRP3_NPCDialogFrameDebugScaleSlider:SetValue(scale);

	fullText = fullText:gsub(LINE_FEED_CODE .. "+", "\n");
	fullText = fullText:gsub(WEIRD_LINE_BREAK, "\n");

	local texts = { strsplit("\n", fullText) };
	if texts[#texts]:len() == 0 then
		texts[#texts] = nil;
	end
	TRP3_NPCDialogFrameChat.texts = texts;
	TRP3_NPCDialogFrameChat.currentIndex = 0;
	TRP3_NPCDialogFrameChat.eventInfo = eventInfo;
	TRP3_NPCDialogFrameChat.event = event;
	TRP3_NPCDialogFrameObjectivesContent:Hide();
	TRP3_NPCDialogFrameChatPrevious:Hide();

	playNext(TRP3_NPCDialogFrameModelsYou);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEXT ANIMATION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local ANIMATION_TEXT_SPEED = 80;
local textSpeedFactor = 0.5;

local function onUpdateChatText(self, elapsed)
	if self.start and TRP3_NPCDialogFrameChatText:GetText() and TRP3_NPCDialogFrameChatText:GetText():len() > 0 then
		self.start = self.start + (elapsed * (ANIMATION_TEXT_SPEED * textSpeedFactor));
		if textSpeedFactor == 0 or self.start >= TRP3_NPCDialogFrameChatText:GetText():len() then
			self.start = nil;
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(TRP3_NPCDialogFrameChatText:GetText():len(), 1);
		else
			TRP3_NPCDialogFrameChatText:SetAlphaGradient(self.start, 30);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStart()
	ForceGossip = function() return true end

	if not TRP3_Storyline then
		TRP3_Storyline = {};
	end
	if not TRP3_Storyline.debug then
		TRP3_Storyline.debug = {};
	end
	if not TRP3_Storyline.debug.scaling then
		TRP3_Storyline.debug.scaling = {};
	end
	if not TRP3_Storyline.debug.timing then
		TRP3_Storyline.debug.timing = {};
	end
	if not TRP3_Storyline.config then
		TRP3_Storyline.config = {};
	end
	if TRP3_Storyline.config.autoEquip == nil then
		TRP3_Storyline.config.autoEquip = true;
	end

	-- Register locales
	for localeID, localeStructure in pairs(TRP3_StorylineAPI.LOCALE) do
		local locale = TRP3_API.locale.getLocale(localeID);
		for localeKey, text in pairs(localeStructure) do
			locale.localeContent[localeKey] = text;
		end
	end

	TRP3_NPCDialogFrameBG:SetDesaturated(true);
	TRP3_NPCDialogFrameChatNext:SetScript("OnClick", function()
		if TRP3_NPCDialogFrameChat.start and TRP3_NPCDialogFrameChat.start < TRP3_NPCDialogFrameChatText:GetText():len() then
			TRP3_NPCDialogFrameChat.start = TRP3_NPCDialogFrameChatText:GetText():len();
		else
			playNext(TRP3_NPCDialogFrameModelsYou);
		end
	end);
	TRP3_NPCDialogFrameChatPrevious:SetScript("OnClick", resetDialog);
	TRP3_NPCDialogFrameChat:SetScript("OnUpdate", onUpdateChatText);
	TRP3_NPCDialogFrameClose:SetScript("OnClick", closeDialog);
	TRP3_NPCDialogFrameRewardsItem:SetScale(1.5);

	TRP3_NPCDialogFrameModelsYou.animTab = {};
	TRP3_NPCDialogFrameModelsMe.animTab = {};

	TRP3_NPCDialogFrameModelsYou:SetScript("OnUpdate", function(self, elapsed)
		if self.spin then
			self.spinAngle = self.spinAngle - (elapsed / 2);
			self:SetFacing(self.spinAngle);
		end
	end);

	-- Register events
	TRP3_StorylineAPI.initEventsStructure();

	-- Closing
	Utils.event.registerHandler("GOSSIP_CLOSED", function()
		TRP3_NPCDialogFrame:Hide();
	end);
	Utils.event.registerHandler("QUEST_FINISHED", function()
		TRP3_NPCDialogFrame:Hide();
	end);

	-- Resizing
	local resizeChat = function()
		TRP3_NPCDialogFrameChatText:SetWidth(TRP3_NPCDialogFrame:GetWidth() - 150);
		TRP3_NPCDialogFrameChat:SetHeight(TRP3_NPCDialogFrameChatText:GetHeight() + CHAT_MARGIN + 5);
	end
	TRP3_NPCDialogFrameChatText:SetWidth(550);
	TRP3_NPCDialogFrameResizeButton.onResizeStop = function(width, height)
		resizeChat();
		TRP3_Storyline.config.width = width;
		TRP3_Storyline.config.height = height;
	end;
	TRP3_NPCDialogFrame:SetSize(TRP3_Storyline.config.width or 700, TRP3_Storyline.config.height or 450);
	resizeChat();


	local resizeModels = function(scale)
		local margin = scale < 0 and -scale or 0;
		TRP3_NPCDialogFrameModelsMe:ClearAllPoints();
		TRP3_NPCDialogFrameModelsMe:SetPoint("TOP", 0, -(margin * 2));
		TRP3_NPCDialogFrameModelsMe:SetPoint("LEFT", margin, 0);
		TRP3_NPCDialogFrameModelsMe:SetPoint("BOTTOM", 0, 0);
		TRP3_NPCDialogFrameModelsMe:SetPoint("RIGHT", TRP3_NPCDialogFrameModelsPoint, "LEFT", -margin, 0);

		margin = scale > 0 and scale or 0;
		TRP3_NPCDialogFrameModelsYou:ClearAllPoints();
		TRP3_NPCDialogFrameModelsYou:SetPoint("TOP", 0, -(margin * 2));
		TRP3_NPCDialogFrameModelsYou:SetPoint("RIGHT", -margin, 0);
		TRP3_NPCDialogFrameModelsYou:SetPoint("BOTTOM", 0, 0);
		TRP3_NPCDialogFrameModelsYou:SetPoint("LEFT", TRP3_NPCDialogFrameModelsPoint, "RIGHT", margin, 0);
	end

	-- Debug
	TRP3_NPCDialogFrameDebug:Hide();
	TRP3_NPCDialogFrameDebugScaleSlider:SetScript("OnValueChanged", function(self, scale)
		TRP3_NPCDialogFrameDebugScaleSliderValText:SetText("Scale: " .. scale);
		resizeModels(scale);
		TRP3_Storyline.debug.scaling[TRP3_NPCDialogFrameDebugModelMe:GetText():gsub("\\\\", "\\") .. "~" .. TRP3_NPCDialogFrameDebugModelYou:GetText():gsub("\\\\", "\\")] = scale;
	end);
	-- Slash command to reset frames
	TRP3_API.slash.registerCommand({
		id = "storyline",
		helpLine = " show debug frame",
		handler = function()
			ToggleFrame(TRP3_NPCDialogFrameDebug);
		end
	});

	-- Config
	setTooltipAll(TRP3_NPCDialogFrameConfigButton, "TOP", 0, 0, loc("SL_CONFIG"));
	TRP3_NPCDialogFrameConfigSpeedSliderLow:SetText(loc("SL_CONFIG_TEXTSPEED_INSTANT"));
	TRP3_NPCDialogFrameConfigSpeedSliderHigh:SetText(loc("SL_CONFIG_TEXTSPEED_HIGH"));
	TRP3_NPCDialogFrameConfigText:SetText(loc("SL_CONFIG"));
	TRP3_NPCDialogFrameConfigSpeedSlider:SetScript("OnValueChanged", function(self, scale)
		TRP3_NPCDialogFrameConfigSpeedSliderValText:SetText(loc("SL_CONFIG_TEXTSPEED"):format(scale));
		textSpeedFactor = scale;
		TRP3_Storyline.config.textSpeedFactor = textSpeedFactor;
	end);
	textSpeedFactor = TRP3_Storyline.config.textSpeedFactor or textSpeedFactor;
	TRP3_NPCDialogFrameConfigSpeedSlider:SetValue(textSpeedFactor);
	TRP3_NPCDialogFrameConfig.AutoEquip.Text:SetText(loc("SL_CONFIG_AUTOEQUIP"));
	setTooltipForSameFrame(TRP3_NPCDialogFrameConfig.AutoEquip, "RIGHT", 0, 0, loc("SL_CONFIG_AUTOEQUIP"), loc("SL_CONFIG_AUTOEQUIP_TT"));
	TRP3_NPCDialogFrameConfig.AutoEquip:SetScript("OnClick", function(self)
		TRP3_Storyline.config.autoEquip = self:GetChecked() == true;
	end);
	TRP3_NPCDialogFrameConfig.AutoEquip:SetChecked(TRP3_Storyline.config.autoEquip);
end;

local MODULE_STRUCTURE = {
	["name"] = "Storyline",
	["description"] = "Enhanced quest storytelling",
	["version"] = 1.000,
	["id"] = "trp3_storyline",
	["onStart"] = onStart,
	["minVersion"] = 12,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
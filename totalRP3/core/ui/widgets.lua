----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
--- Copyright 2020 Total RP 3 Development Team
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---   http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

--[[
	Backdrop Tables

	The 9.x Backdrop API requires using <KeyValue> elements in XML that
	reference global variables to provide color and backdrop information;
	the below tables are all of our old <Backdrop> elements converted to
	the appropriate format.

	The naming format matches the Blizzard convention to avoid bikeshedding
	over specific names.
--]]

TRP3_BACKDROP_COLOR_DARK = CreateColor(0.4, 0.4, 0.4);

TRP3_BACKDROP_DIALOG_20_20_5555 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 20,
	edgeSize = 20,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_PARTY_DIALOG_16_16_5555 = {
	bgFile   = "Interface\\CHARACTERFRAME\\UI-Party-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 16,
	edgeSize = 16,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_200_24_5555 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 200,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_400_24_5555 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 400,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_TOOLTIP_0_24_5555 = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_TOOLTIP_400_24_5555 = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 400,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_TOOLTIP_0_16 = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	edgeSize = 16,
};

TRP3_BACKDROP_TOOLTIP_0_24 = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	edgeSize = 24,
};

TRP3_BACKDROP_TOOLTIP_415_16_3333 = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 16,
	insets   = { left = 3, right = 3, top = 3, bottom = 3 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_380_16_3333 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 380,
	edgeSize = 16,
	insets   = { left = 3, right = 3, top = 3, bottom = 3 },
};

TRP3_BACKDROP_MIXED_MARBLE_TOOLTIP_415_24_5555 = {
	bgFile   = "Interface\\FrameGeneral\\UI-Background-Marble",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_BANK_TOOLTIP_400_24_5555 = {
	bgFile   = "Interface\\BankFrame\\Bank-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 400,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_BANK_TOOLTIP_100_16_4222 = {
	bgFile   = "Interface\\BankFrame\\Bank-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 100,
	edgeSize = 16,
	insets   = { left = 4, right = 2, top = 2, bottom = 2 },
};

TRP3_BACKDROP_MIXED_TUTORIAL_TOOLTIP_418_16_3353 = {
	bgFile   = "Interface\\TutorialFrame\\TutorialFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 418,
	edgeSize = 16,
	insets   = { left = 3, right = 3, top = 5, bottom = 3 },
};

TRP3_BACKDROP_ACHIEVEMENTS_32_64_5555 = {
	edgeFile = "Interface\\AchievementFrame\\UI-Achievement-WoodBorder",
	tile     = true,
	tileEdge = true,
	tileSize = 32,
	edgeSize = 64,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_PARCHMENT_TOOLTIP_415_16_5555 = {
	bgFile   = "Interface\\AchievementFrame\\UI-Achievement-Parchment",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 16,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_0_16_3333 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	edgeSize = 16,
	insets   = { left = 3, right = 3, top = 3, bottom = 3 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_415_16_3333 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 16,
	insets   = { left = 3, right = 3, top = 3, bottom = 3 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_415_24_5555 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_415_16_5555 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 16,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_DIALOG_TOOLTIP_0_16_5555 = {
	bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	edgeSize = 16,
	insets   = { left = 5, right = 5, top = 5, bottom = 3 },
};

TRP3_BACKDROP_GOLD_DIALOG_0_26 = {
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	edgeSize = 26,
};

TRP3_BACKDROP_MIXED_TUTORIAL_TOOLTIP_418_16_5353 = {
	bgFile   = "Interface\\TutorialFrame\\TutorialFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 418,
	edgeSize = 16,
	insets   = { left = 5, right = 3, top = 5, bottom = 3 },
};

TRP3_BACKDROP_MIXED_ACHIEVEMENT_TOOLTIP_415_24_5555 = {
	bgFile   = "Interface\\AchievementFrame\\UI-Achievement-StatsBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 24,
	insets   = { left = 5, right = 5, top = 5, bottom = 5 },
};

TRP3_BACKDROP_MIXED_ACHIEVEMENT_TOOLTIP_415_16_3333 = {
	bgFile   = "Interface\\AchievementFrame\\UI-Achievement-StatsBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile     = true,
	tileEdge = true,
	tileSize = 415,
	edgeSize = 16,
	insets   = { left = 3, right = 3, top = 3, bottom = 3 },
};

--[[
	BackdropTemplatePolyfillMixin

	Polyfill mixin that mirrors the API exposed by the BackdropTemplateMixin
	in 9.x clients.

	This implements all the methods provided by the Blizzard mixin, using
	no-op stubs for areas of functionality that can't be handed in pre-9.x
	client code.

	Generally, this mixin shouldn't be used directly - use the globally
	accessible TRP3_BackdropTemplateMixin instead which will default to
	preferring the Blizzard mixin on supported clients.
--]]

local BackdropTemplatePolyfillMixin = {};

function BackdropTemplatePolyfillMixin:OnBackdropLoaded()
	if not self.backdropInfo then
		return;
	end

	if not self.backdropInfo.edgeFile and not self.backdropInfo.bgFile then
		self.backdropInfo = nil;
		return;
	end

	self:ApplyBackdrop();

	if self.backdropColor then
		local r, g, b = self.backdropColor:GetRGB();
		self:SetBackdropColor(r, g, b, self.backdropColorAlpha or 1);
	end

	if self.backdropBorderColor then
		local r, g, b = self.backdropBorderColor:GetRGB();
		self:SetBackdropBorderColor(r, g, b, self.backdropBorderColorAlpha or 1);
	end

	if self.backdropBorderBlendMode then
		self:SetBackdropBorderBlendMode(self.backdropBorderBlendMode);
	end
end

function BackdropTemplatePolyfillMixin:OnBackdropSizeChanged()
	if self.backdropInfo then
		self:SetupTextureCoordinates();
	end
end

function BackdropTemplatePolyfillMixin:ApplyBackdrop()
	-- The SetBackdrop call will implicitly reset the background and border
	-- texture vertex colors to white, consistent across all client versions.

	self:SetBackdrop(self.backdropInfo);
end

function BackdropTemplatePolyfillMixin:ClearBackdrop()
	self:SetBackdrop(nil);
	self.backdropInfo = nil;
end

function BackdropTemplatePolyfillMixin:GetEdgeSize()
	-- The below will indeed error if there's no backdrop assigned; this is
	-- consistent with how it works on 9.x clients.

	return self.backdropInfo.edgeSize or 39;
end

function BackdropTemplatePolyfillMixin:HasBackdropInfo(backdropInfo)
	return self.backdropInfo == backdropInfo;
end

function BackdropTemplatePolyfillMixin:SetBorderBlendMode()
	-- The pre-9.x API doesn't support setting blend modes for backdrop
	-- borders, so this is a no-op that just exists in case we ever assume
	-- it exists.
end

function BackdropTemplatePolyfillMixin:SetupPieceVisuals()
	-- Deliberate no-op as backdrop internals are handled C-side pre-9.x.
end

function BackdropTemplatePolyfillMixin:SetupTextureCoordinates()
	-- Deliberate no-op as texture coordinates are handled C-side pre-9.x.
end

--[[
	TRP3_BackdropTemplateMixin

	Dummy mixin that either inherits the Blizzard BackdropTemplateMixin
	for 9.x clients, or our polyfill one if otherwise unavailable.
--]]

TRP3_BackdropTemplateMixin = CreateFromMixins(BackdropTemplateMixin or BackdropTemplatePolyfillMixin);

--[[
	TRP3_TruncatedTextMixin
--]]

TRP3_TruncatedTextMixin = CreateFromMixins(FontableFrameMixin);

function TRP3_TruncatedTextMixin:OnLoad()
	self.Text = self:CreateFontString(nil, self.fontStringLayer, self.fontStringTemplate, self.fontStringSubLayer);
	self.Text:SetAllPoints(self);

	if self.fontStringColor then
		self.Text:SetTextColor(self.fontStringColor);
	end

	if self.fontStringJustifyH then
		self.Text:SetJustifyH(self.fontStringJustifyH);
	end

	if self.fontStringJustifyV then
		self.Text:SetJustifyV(self.fontStringJustifyV);
	end
end

function TRP3_TruncatedTextMixin:GetText()
	return self.Text:GetText();
end

function TRP3_TruncatedTextMixin:IsTruncated()
	return self.Text:IsTruncated();
end

function TRP3_TruncatedTextMixin:SetFormattedText(format, ...)
	return self.Text:SetFormattedText(format, ...)
end

function TRP3_TruncatedTextMixin:SetText(text)
	return self.Text:SetText(text);
end

--[[override]] function TRP3_TruncatedTextMixin:OnFontObjectUpdated()
	self.Text:SetFontObject(self:GetFontObject());
end

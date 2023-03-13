-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

---@type GameTooltip
TRP3_ChatLinkTooltipMixin = {};

function TRP3_ChatLinkTooltipMixin:OnLoad()
	self:SetPadding(16, 0);
	self:SetBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	self:SetCenterColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);

	---@type FontString
	self.TitleLine = _G[self:GetName() .. "TextLeft1"];

	-- Set tooltip title font size once the settings have been loaded
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
		local fontSize = 16;
		if TRP3_API.module.isModuleLoaded("trp3_tooltips") then
			fontSize = TRP3_API.ui.tooltip.getMainLineFontSize();
			TRP3_API.configuration.registerHandler("tooltip_char_mainSize", function()
				self:SetTitleSize(TRP3_API.ui.tooltip.getMainLineFontSize());
			end)
		end
		self:SetTitleSize(fontSize);
	end)

	Ellyb.Frames.makeMovable(self, true);
end

function TRP3_ChatLinkTooltipMixin:SetTitleSize(fontSize)
	local font, _, flag = self.TitleLine:GetFont();
	self.TitleLine:SetFont(font, fontSize, flag);
	self.TitleLine:SetWordWrap(false);

	if self:IsVisible() then
		self:Refresh();
	end
end

--[[ Override]] function TRP3_ChatLinkTooltipMixin:Refresh()

end

function TRP3_ChatLinkTooltipMixin:OnUpdate()
	if
		(self.wasAltKeyDown and not IsAltKeyDown()) or
		(self.wasAltKeyDown == false and IsAltKeyDown())
	then
		self:Refresh()
	end
end

----------------------------------------------------------------------------------
--- Total RP 3
--- Chat link tooltip mixin
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

---@type GameTooltip
TRP3_ChatLinkTooltipMixin = {};

function TRP3_ChatLinkTooltipMixin:OnLoad()
	self:SetPadding(16, 0);
	self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);

	---@type FontString
	self.TitleLine = _G[self:GetName() .. "TextLeft1"];

	-- Set tooltip title font size once the settings have been loaded
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
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

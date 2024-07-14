-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_ProfileManagerListElementMixin = {};

function TRP3_ProfileManagerListElementMixin:OnLoad()
end

function TRP3_ProfileManagerListElementMixin:OnShow()
	self.CurrentText:SetText(L.PR_PROFILEMANAGER_CURRENT);
end

function TRP3_ProfileManagerListElementMixin:OnEnter()
	TRP3_RefreshTooltipForFrame(self);
end

function TRP3_ProfileManagerListElementMixin:OnLeave()
	TRP3_TooltipUtil.HideTooltip(self);
end

function TRP3_ProfileManagerListElementMixin:SetBorderColor(color)
	self.Border:SetVertexColor(color:GetRGB());
end

function TRP3_ProfileManagerListElementMixin:SetIcon(icon)
	self.Icon:SetIconTexture(icon);
end

function TRP3_ProfileManagerListElementMixin:SetNameText(text)
	self.NameText:SetText(text);
end

function TRP3_ProfileManagerListElementMixin:SetCountText(text)
	self.CountText:SetText(text);
	self.CountText:SetShown(text and text ~= "");
end

function TRP3_ProfileManagerListElementMixin:SetMenuButtonCallback(callback)
	local function OnClick(button, mouseButtonName)
		callback(self, button, mouseButtonName);
	end

	self.MenuButton:SetShown(callback ~= nil);
	self.MenuButton:SetScript("OnClick", OnClick);
end

function TRP3_ProfileManagerListElementMixin:SetMenuButtonTooltip(callback)
	local function OnEnter(button)
		TRP3_TooltipUtil.ShowTooltip(button, callback);
	end

	self.MenuButton:SetScript("OnEnter", callback and OnEnter or nil);
	self.MenuButton:SetScript("OnLeave", TRP3_TooltipUtil.HideTooltip);
end

function TRP3_ProfileManagerListElementMixin:SetTooltip(callback)
	local function OnEnter(element)
		TRP3_TooltipUtil.ShowTooltip(element, callback);
	end

	self:SetScript("OnEnter", callback and OnEnter or nil);
	self:SetScript("OnLeave", TRP3_TooltipUtil.HideTooltip);
end

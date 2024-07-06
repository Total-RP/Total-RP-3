-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_CategoryButtonArtMixin = {};

local function GetEffectiveButtonState(button, overrideState)
	if not button:IsEnabled() then
		return "DISABLED";
	else
		return overrideState;
	end
end

function TRP3_CategoryButtonArtMixin:OnDisable()
	self:SetVisualState(self:GetButtonState());
end

function TRP3_CategoryButtonArtMixin:OnEnable()
	self:SetVisualState(self:GetButtonState());
end

function TRP3_CategoryButtonArtMixin:OnShow()
	self:SetVisualState(GetEffectiveButtonState(self, "NORMAL"));
end

function TRP3_CategoryButtonArtMixin:OnMouseDown()
	self:SetVisualState(GetEffectiveButtonState(self, "PUSHED"));
end

function TRP3_CategoryButtonArtMixin:OnMouseUp()
	self:SetVisualState(GetEffectiveButtonState(self, "NORMAL"));
end
function TRP3_CategoryButtonArtMixin:SetVisualState(state)
	if state == "NORMAL" then
		self.EdgeLeft:SetTexCoord(0.25, 0.5, 0, 0.125);
		self.EdgeRight:SetTexCoord(0.5, 0.75, 0, 0.125);
		self.Center:SetTexCoord(0, 1, 0.375, 0.5);
	elseif state == "PUSHED" then
		-- self.EdgeLeft:SetTexCoord(0.5, 0.75, 0.25, 0.375);
		-- self.EdgeRight:SetTexCoord(0.75, 1, 0.25, 0.375);
		-- self.Center:SetTexCoord(0, 1, 0.625, 0.75);
		self.EdgeLeft:SetTexCoord(0, 0.25, 0.25, 0.375);
		self.EdgeRight:SetTexCoord(0.25, 0.5, 0.25, 0.375);
		self.Center:SetTexCoord(0, 1, 0.5, 0.625);
	elseif state == "DISABLED" then
		self.EdgeLeft:SetTexCoord(0.5, 0.75, 0.25, 0.375);
		self.EdgeRight:SetTexCoord(0.75, 1, 0.25, 0.375);
		self.Center:SetTexCoord(0, 1, 0.625, 0.75);
	end
end

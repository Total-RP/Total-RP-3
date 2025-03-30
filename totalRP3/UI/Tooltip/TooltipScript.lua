-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TooltipScriptMixin = {};

function TRP3_TooltipScriptMixin:OnEnter()
	self:SetTooltipShown(self:ShouldShowTooltip());
end

function TRP3_TooltipScriptMixin:OnLeave()
	self:SetTooltipShown(false);
end

function TRP3_TooltipScriptMixin:GetTooltipFrame()
	return self.tooltipFrame or TRP3_TooltipUtil.GetDefaultTooltip();
end

function TRP3_TooltipScriptMixin:ShouldShowTooltip()
	-- Override if the tooltip should only be shown conditionally when
	-- hovered, eg. if associated text is truncated.
	return true;
end

function TRP3_TooltipScriptMixin:OnTooltipShow(description)  -- luacheck: no unused (description)
	-- Override to populate the tooltip when shown or refreshed.
end

function TRP3_TooltipScriptMixin:IsTooltipShown()
	return TRP3_TooltipUtil.IsOwned(self:GetTooltipFrame(), self);
end

function TRP3_TooltipScriptMixin:ShowTooltip()
	self:SetTooltipDescription(self:GenerateTooltipDescription());
end

function TRP3_TooltipScriptMixin:RegenerateTooltip()
	if self:IsTooltipShown() then
		self:SetTooltipDescription(self:GenerateTooltipDescription());
	end
end

function TRP3_TooltipScriptMixin:RefreshTooltip()
	if self:IsTooltipShown() then
		self:ProcessTooltipDescription(self:GetTooltipDescription());
	end
end

function TRP3_TooltipScriptMixin:HideTooltip()
	self:SetTooltipDescription(nil);
end

function TRP3_TooltipScriptMixin:SetTooltipShown(shown)
	if shown then
		self:ShowTooltip();
	else
		self:HideTooltip();
	end
end

function TRP3_TooltipScriptMixin:GetTooltipDescription()
	return self.tooltipDescription;
end

function TRP3_TooltipScriptMixin:SetTooltipDescription(description)
	self.tooltipDescription = description;
	self:ProcessTooltipDescription(description);
end

function TRP3_TooltipScriptMixin:GenerateTooltipDescription()
	local description = TRP3_Tooltip.CreateTooltipDescription(self);
	TRP3_Tooltip.PopulateTooltipDescription(self.OnTooltipShow, self, description);
	return description;
end

function TRP3_TooltipScriptMixin:ProcessTooltipDescription(description)
	local tooltipFrame = self:GetTooltipFrame();

	if description then
		TRP3_Tooltip.ProcessTooltipDescription(tooltipFrame, description);
	else
		TRP3_TooltipUtil.HideTooltip(self);
	end
end

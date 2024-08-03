-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TooltipScriptMixin = {};

function TRP3_TooltipScriptMixin:OnEnter()
	self:SetTooltipShown(self:ShouldShowTooltip());
end

function TRP3_TooltipScriptMixin:OnLeave()
	self:SetTooltipShown(false);
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
	return TRP3_TooltipUtil.IsOwned(TRP3_MainTooltip, self);
end

function TRP3_TooltipScriptMixin:ShowTooltip()
	TRP3_TooltipUtil.ShowTooltip(self, self.OnTooltipShow);
end

function TRP3_TooltipScriptMixin:RefreshTooltip()
	if self:IsTooltipShown() then
		self:ShowTooltip();
	end
end

function TRP3_TooltipScriptMixin:HideTooltip()
	TRP3_TooltipUtil.HideTooltip(self);
end

function TRP3_TooltipScriptMixin:SetTooltipShown(shown)
	if shown then
		self:ShowTooltip();
	else
		self:HideTooltip();
	end
end

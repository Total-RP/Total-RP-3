-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditorTooltipInitializer = {};

function TRP3_ProfileEditorTooltipInitializer:__init(tooltip)
	self.tooltip = tooltip;
end

function TRP3_ProfileEditorTooltipInitializer:GetTooltip()
	return self.tooltip;
end

function TRP3_ProfileEditorTooltipInitializer:SetTooltip(tooltip)
	self.tooltip = tooltip;
end

TRP3_ProfileEditorTooltipMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_ProfileEditorTooltipMixin:Init(initializer)
	self.tooltip = initializer:GetTooltip();
end

function TRP3_ProfileEditorTooltipMixin:Release()
	self:HideTooltip();
	self.tooltip = nil;
end

function TRP3_ProfileEditorTooltipMixin:OnEnter()
	TRP3_TooltipScriptMixin.OnEnter(self);
end

function TRP3_ProfileEditorTooltipMixin:OnLeave()
	TRP3_TooltipScriptMixin.OnLeave(self);
end

function TRP3_ProfileEditorTooltipMixin:OnTooltipShow(description)
	self:PopulateTooltip(description);
end

function TRP3_ProfileEditorTooltipMixin:ShouldShowTooltip()
	return (self.tooltip ~= nil);
end

function TRP3_ProfileEditorTooltipMixin:PopulateTooltip(description)
	local tooltip = self.tooltip;

	if type(tooltip) == "function" then
		tooltip(description);
	elseif tooltip ~= nil and tooltip ~= "" then
		description:AddNormalLine(tooltip);
	end
end

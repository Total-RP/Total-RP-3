-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ToolbarButtonMixin = CreateFromMixins(TRP3_TooltipScriptMixin);

function TRP3_ToolbarButtonMixin:OnLoad()
	self.timeSinceLastUpdate = math.huge;
end

function TRP3_ToolbarButtonMixin:OnShow()
	self:MarkDirty();
end

function TRP3_ToolbarButtonMixin:OnHide()
	self:SetElementData(nil);
end

function TRP3_ToolbarButtonMixin:OnClick(mouseButtonName)
	local elementData = self:GetElementData();

	if not elementData or not elementData.onClick then
		return;
	end

	securecallfunction(elementData.onClick, self, elementData, mouseButtonName);

	-- Clicks often end up invalidating models, so see if we can do so to
	-- improve responsiveness of some buttons.

	if elementData.onModelUpdate then
		securecallfunction(elementData.onModelUpdate, elementData);
		self:MarkDirty();
	end
end

function TRP3_ToolbarButtonMixin:OnEnter()
	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	if elementData.onEnter then
		securecallfunction(elementData.onEnter, self, elementData);
	else
		TRP3_TooltipScriptMixin.OnEnter(self);
	end
end

function TRP3_ToolbarButtonMixin:OnLeave()
	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	if elementData.onLeave then
		securecallfunction(elementData.onLeave, self, elementData);
	else
		TRP3_TooltipScriptMixin.OnLeave(self);
	end
end

function TRP3_ToolbarButtonMixin:OnUpdate(elapsed)
	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;

	if self.timeSinceLastUpdate < 0.2 then
		return;
	end

	if elementData.onUpdate then
		securecallfunction(elementData.onUpdate, self, elementData);
	end

	self:UpdateImmediately();
end

function TRP3_ToolbarButtonMixin:OnTooltipShow(description)
	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	local title = TRP3_ToolbarUtil.GetFormattedTooltipTitle(elementData);
	local text = elementData.tooltipSub;
	local instructions = elementData.tooltipInstructions;

	TRP3_TooltipTemplates.CreateInstructionTooltip(description, title, text, instructions);

	-- Tooltip anchoring is special as we want to dodge screen edges without
	-- overlapping the bar.

	local toolbarAnchor = TRP3_ToolbarUtil.GetToolbarAnchor();
	local anchor = "ANCHOR_TOP";
	local offsetX = 0;
	local offsetY = 5;

	if string.find(toolbarAnchor.point, "^TOP") then
		anchor = "ANCHOR_BOTTOM";
		offsetY = -offsetY;
	end

	description:SetAnchorWithOffset(anchor, offsetX, offsetY);
end

function TRP3_ToolbarButtonMixin:GetElementData()
	return self.elementData;
end

function TRP3_ToolbarButtonMixin:SetElementData(elementData)
	self.elementData = elementData;
	self:MarkDirty();
end

function TRP3_ToolbarButtonMixin:Update()
	self:MarkDirty();
end

function TRP3_ToolbarButtonMixin:UpdateImmediately()
	self:MarkClean();

	local elementData = self:GetElementData();

	if not elementData then
		return;
	end

	self:SetIconTexture(elementData.icon);
	self:RefreshTooltip();
end

function TRP3_ToolbarButtonMixin:MarkDirty()
	self.timeSinceLastUpdate = math.huge;
end

function TRP3_ToolbarButtonMixin:MarkClean()
	self.timeSinceLastUpdate = 0;
end

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local function InterpolatedScrollInDirection(self, scrollPercentage, direction)
	if not self:IsScrollAllowed() then
		return;
	end

	local delta = scrollPercentage * direction;
	local currentPercentage = self:GetScrollPercentage();

	-- If scroll interpolation is in effect then the current percentage should
	-- actually be the target percentage that is currently being interpolated
	-- towards. This makes the behavior between normal and interpolated
	-- scrolling uniform in cases where the user clicks their mouse wheel
	-- multiple times in quick succession.

	if self:CanInterpolateScroll() then
		local interpolator = self:GetScrollInterpolator();

		if interpolator.timer then
			currentPercentage = interpolator:GetInterpolateTo();
		end
	end

	self:SetScrollPercentage(Saturate(currentPercentage + delta));
end

TRP3_InterpolatedScrollBoxMixin = {};

function TRP3_InterpolatedScrollBoxMixin:ScrollInDirection(scrollPercentage, direction)
	InterpolatedScrollInDirection(self, scrollPercentage, direction);
	self:Update();
end

TRP3_InterpolatedScrollBarMixin = {};

function TRP3_InterpolatedScrollBarMixin:ScrollInDirection(scrollPercentage, direction)
	InterpolatedScrollInDirection(self, scrollPercentage, direction);
	self:Update();
	self:TriggerEvent(self.Event.OnScroll, self:GetScrollPercentage());
end

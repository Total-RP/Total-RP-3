-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_FocusRegionMixin = {};

function TRP3_FocusRegionMixin:GetTargetKey()
	return self.targetKey;
end

function TRP3_FocusRegionMixin:SetTargetKey(key)
	self.targetKey = key;
	self.targetFrame = nil;
end

function TRP3_FocusRegionMixin:GetTargetFrame()
	return self.targetFrame or self:GetParent()[self.targetKey];
end

function TRP3_FocusRegionMixin:SetTargetFrame(frame)
	self.targetKey = nil;
	self.targetFrame = frame;
end

function TRP3_FocusRegionMixin:OnMouseDown()
	local target = self:GetTargetFrame();

	if target then
		target:SetFocus();
	end
end

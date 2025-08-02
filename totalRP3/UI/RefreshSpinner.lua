-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_RefreshSpinnerMixin = {};

function TRP3_RefreshSpinnerMixin:OnShow()
	if self:ShouldPlayOnShow() then
		self:Play();
	end
end

function TRP3_RefreshSpinnerMixin:OnHide()
	self:Stop();
end

function TRP3_RefreshSpinnerMixin:SetPlaying(playing)
	self.SpinAnimation:SetPlaying(playing);
end

function TRP3_RefreshSpinnerMixin:Play()
	self:SetPlaying(true);
end

function TRP3_RefreshSpinnerMixin:Stop()
	self:SetPlaying(false);
end

function TRP3_RefreshSpinnerMixin:SetPlayOnShow(playOnShow)
	self.playOnShow = playOnShow;
end

function TRP3_RefreshSpinnerMixin:ShouldPlayOnShow()
	return self.playOnShow;
end

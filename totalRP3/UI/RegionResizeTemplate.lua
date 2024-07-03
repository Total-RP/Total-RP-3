-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_RegionResizeMode = {
	Fit = "fit",
	Fill = "fill",
};

TRP3_RegionResizeMixin = {};

function TRP3_RegionResizeMixin:OnShow()
	self:MarkDirty();
end

function TRP3_RegionResizeMixin:OnSizeChanged()
	self:MarkDirty();
end

function TRP3_RegionResizeMixin:OnUpdate()
	self:MarkClean();
	self:Layout();
end

function TRP3_RegionResizeMixin:MarkDirty()
	self:SetScript("OnUpdate", self.OnUpdate);
end

function TRP3_RegionResizeMixin:MarkClean()
	self:SetScript("OnUpdate", nil);
end

local function GetResizeFunction(mode)
	if mode == TRP3_RegionResizeMode.Fill then
		return TRP3_RegionUtil.ResizeToFill;
	elseif mode == TRP3_RegionResizeMode.Fit then
		return TRP3_RegionUtil.ResizeToFit;
	else
		securecall(error, "invalid region resize mode", mode);
		return nop;
	end
end

function TRP3_RegionResizeMixin:Layout()
	local resizeMode = self:GetResizeMode();
	local resizeFunction = GetResizeFunction(resizeMode);
	local resizeRegions = self:GetResizeRegions();

	for _, region in ipairs(resizeRegions) do
		TRP3_RegionUtil.ContinueOnObjectLoaded(region, resizeFunction);
	end
end

local function CollectResizeRegions(frame)
	local regions = { frame:GetRegions() };

	for index, region in ipairs_reverse(regions) do
		if region.ignoreForResize then
			regions[index] = regions[#regions];
			regions[#regions] = nil;
		end
	end

	return regions;
end

function TRP3_RegionResizeMixin:GetResizeRegions()
	if self.resizeRegions then
		return self.resizeRegions;
	else
		return CollectResizeRegions(self);
	end
end

function TRP3_RegionResizeMixin:SetResizeRegions(regions)
	self.resizeRegions = regions;
end

function TRP3_RegionResizeMixin:GetResizeMode()
	return self.resizeMode;
end

function TRP3_RegionResizeMixin:SetResizeMode(mode)
	self.resizeMode = mode;
	self:Layout();
end

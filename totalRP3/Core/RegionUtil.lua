-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local RegionLoadWatcher = CreateFrame("Frame", "TRP3_RegionLoadWatcher");

function RegionLoadWatcher:OnLoad()
	self.callbacks = {};
	self.snapshot = {};
end

function RegionLoadWatcher:OnUpdate()
	-- Name inversion here is intentional to make loop sound more sensible.
	local snapshot = self.callbacks;
	local callbacks = self.snapshot;

	self.callbacks, self.snapshot = callbacks, snapshot;

	for region, callback in pairs(snapshot) do
		snapshot[region] = nil;

		if region:IsObjectLoaded() then
			securecallfunction(callback, region);
		elseif callbacks[region] == nil then
			callbacks[region] = callback;
		end
	end

	self:SetScript("OnUpdate", (self:HasPendingCallbacks() and self.OnUpdate or nil));
end

function RegionLoadWatcher:AddCallback(region, callback)
	self.callbacks[region] = callback;
	self:SetScript("OnUpdate", self.OnUpdate);
end

function RegionLoadWatcher:RemoveCallback(region)
	self.callbacks[region] = nil;
	self:SetScript("OnUpdate", nil);
end

function RegionLoadWatcher:EnumerateCallbacks()
	return next, self.callbacks, nil;
end

function RegionLoadWatcher:HasPendingCallbacks()
	return next(self.callbacks) ~= nil;
end

RegionLoadWatcher:OnLoad();

TRP3_RegionUtil = {};

function TRP3_RegionUtil.ContinueOnObjectLoaded(region, callback)
	if region:IsObjectLoaded(region) then
		securecallfunction(callback, region);
	else
		RegionLoadWatcher:AddCallback(region, callback);
	end
end

local function CalculateContainerSize(container)
	local w, h = container:GetSize();

	if container.fixedWidth then
		w = container.fixedWidth;
	end

	if container.fixedHeight then
		h = container.fixedHeight;
	end

	if container.paddingWidth then
		w = w - container.paddingWidth;
	end

	if container.paddingHeight then
		h = h - container.paddingHeight;
	end

	return w, h;
end

local function CalculateRegionSize(region)
	local w = region.sourceWidth;
	local h = region.sourceHeight;

	if region.GetAtlas and not (w and h) then
		local atlasName = region:GetAtlas();
		local atlasInfo = C_Texture.GetAtlasInfo(atlasName or "");

		if atlasInfo then
			w = atlasInfo.width;
			h = atlasInfo.height;
		end
	end

	w = w or region:GetWidth();
	h = h or region:GetHeight()

	return w, h;
end

local function CalculateScaledRegionSize(region, w, h)
	w = Clamp(w, region.minWidth or 0, region.maxWidth or math.huge);
	h = Clamp(h, region.minHeight or 0, region.maxHeight or math.huge);

	if region.extraWidth then
		w = w + region.extraWidth;
	end

	if region.extraHeight then
		h = h + region.extraHeight;
	end

	return w, h;
end

local function CalculateFitSize(region, container)
	local rw, rh = CalculateRegionSize(region);
	local cw, ch = CalculateContainerSize(container);
	local r = math.min(cw / rw, ch / rh);

	return CalculateScaledRegionSize(region, rw * r, rh * r);
end

local function CalculateFillSize(region, container)
	local rw, rh = CalculateRegionSize(region);
	local cw, ch = CalculateContainerSize(container);
	local r = math.max(cw / rw, ch / rh);

	return CalculateScaledRegionSize(region, rw * r, rh * r);
end

function TRP3_RegionUtil.ResizeToContent(region)
	region:SetSize(0, 0);
end

function TRP3_RegionUtil.ResizeToFill(region, container)
	if not container then
		container = region:GetParent();
	end

	TRP3_RegionUtil.ResizeToContent(region);
	region:SetSize(CalculateFillSize(region, container));
end

function TRP3_RegionUtil.ResizeToFit(region, container)
	if not container then
		container = region:GetParent();
	end

	TRP3_RegionUtil.ResizeToContent(region);
	region:SetSize(CalculateFitSize(region, container));
end

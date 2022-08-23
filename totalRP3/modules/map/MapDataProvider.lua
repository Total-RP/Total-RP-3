-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- Create a new MapDataProvider for Total RP 3
-- MapDataProviders are the new way since Battle for Azeroth to offer points of interest on the map
---@type MapCanvasDataProviderMixin|{GetMap:fun():MapCanvasMixin}
local TRP3_MapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin);

--- Removed all pins from the map
function TRP3_MapDataProvider:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(self.pinTemplate);
end

--- Called when we want to display data and also dynamically by the map frame if it needs to refresh the data providers
function TRP3_MapDataProvider:RefreshAllData()
	self:RemoveAllData();

	if not self.data then return end

	-- We "acquire" a pin for each element of the scan data and give it the template to use and the data
	for _, poiInfo in pairs(self.data) do
		self:GetMap():AcquirePin(self.pinTemplate, poiInfo);
	end

end

--- Called by the scan manager with the data to display on the map
---@param data table @ A table of data, each element of the table will be passed to the pin when displayed on the map
---@param pinTemplate string @ The name of the XML template to use for the pins (can change for each scan)
function TRP3_MapDataProvider:OnScan(data, pinTemplate)
	self.data = data;
	self.pinTemplate = pinTemplate;
	self:RefreshAllData();
end

--- This method is automatically called by the map frame when the displayed map changes
function TRP3_MapDataProvider:OnMapChanged()
	self.data = nil;
	self:RemoveAllData();
end

--- This method is automatically called by the map frame when it gets hidden
function TRP3_MapDataProvider:OnHide()
	self.data = nil;
	self:RemoveAllData();
end

TRP3_API.MapDataProvider = TRP3_MapDataProvider;

WorldMapFrame:AddDataProvider(TRP3_MapDataProvider);

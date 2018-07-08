----------------------------------------------------------------------------------
--- Total RP 3
--- World map data provider
---	---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

---@type MapCanvasDataProviderMixin|{GetMap:fun():MapCanvasMixin}
local TRP3_MapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin);

function TRP3_MapDataProvider:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(self.pinTemplate);
end

function TRP3_MapDataProvider:RefreshAllData(fromOnShow, ...)
	self:RemoveAllData();

	if not self.data then return end

	for _, POIInfo in pairs(self.data) do
		self:GetMap():AcquirePin(self.pinTemplate, POIInfo);
	end

end

function TRP3_MapDataProvider:OnScan(data, pinTemplate)
	self.data = data;
	self.pinTemplate = pinTemplate;
	self:RefreshAllData();
end

function TRP3_MapDataProvider:OnMapChanged()
	self.data = nil;
	self:RemoveAllData();
end

function TRP3_MapDataProvider:OnHide()
	self.data = nil;
	self:RemoveAllData();
end

TRP3_API.MapDataProvider = TRP3_MapDataProvider;

WorldMapFrame:AddDataProvider(TRP3_MapDataProvider);
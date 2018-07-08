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
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

--region Lua imports
local huge = math.huge;
local insert = table.insert;
local sort = table.sort;
local pairs = pairs;
--endregion

--region WoW imports
local after = C_Timer.After;
local hooksecurefunc = hooksecurefunc;
local BaseMapPoiPinMixin = BaseMapPoiPinMixin;
--endregion

local MapPOIMixins = {};

--region CoalescedMapPin
local CoalescedMapPinMixin = {};

function CoalescedMapPinMixin:OnMouseEnter()
	local tooltip = Ellyb.Tooltips.getTooltip(self);
	for marker in self:GetMap():EnumerateAllPins() do
		if marker:IsVisible() and marker:IsMouseOver() then
			tooltip:AddTempLine(marker.tooltipLine)
		end
	end
	tooltip:Show();
end
MapPOIMixins.CoalescedMapPinMixin = CoalescedMapPinMixin;
--endregion

--region GroupedCoalescedMapMixin
local GroupedCoalescedMapPinMixin = {};

local WHITE = Ellyb.ColorManager.WHITE;
local TOOLTIP_CATEGORY_SEPARATOR = [[|TInterface\Common\UI-TooltipDivider-Transparent:8:128:0:0:8:8:0:128:0:8:255:255:255|t]];

--- Custom sorting function that compares entries. The resulting order is
---  in order of their category priority (descending), or if equal, their
---  sortable name equivalent (ascending).
local function sortMarkerEntries(a, b)
	local categoryA = a.categoryPriority or -huge;
	local categoryB = b.categoryPriority or -huge;

	local nameA = a.sortName or "";
	local nameB = b.sortName or "";

	return (categoryA > categoryB)
		or (categoryA == categoryB and nameA < nameB);
end

function GroupedCoalescedMapPinMixin:OnMouseEnter()

	local tooltip = Ellyb.Tooltips.getTooltip(self);

	local markerTooltipEntries = Ellyb.Tables.getTempTable();
	-- Iterate over the blips in a first pass to build a list of all the
	-- ones we're mousing over.
	for marker in self:GetMap():EnumerateAllPins() do
		if marker:IsVisible() and marker:IsMouseOver() then
			insert(markerTooltipEntries, marker);
		end
	end

	-- Sort the entries prior to display.
	sort(markerTooltipEntries, sortMarkerEntries);

	-- Tracking variable for our last category inserted into the tip.
	-- If it changes we'll stick in a separator.
	local lastCategory;

	-- This layout will put the category status text above entries
	-- when the type changes. Requires the entries be sorted by category.
	for _, marker in pairs(markerTooltipEntries) do
		if marker.categoryName ~= lastCategory and marker.tooltipLine then
			-- If the previous category was nil we assume this is
			-- the first, so we'll not put a separating border in.
			if lastCategory ~= nil then
				tooltip:AddTempLine(TOOLTIP_CATEGORY_SEPARATOR, WHITE);
			end

			tooltip:AddTempLine(marker.categoryName or "");
			lastCategory = marker.categoryName;
		end

		tooltip:AddTempLine(marker.tooltipLine or "", WHITE);
	end

	Ellyb.Tables.releaseTempTable(markerTooltipEntries)

	tooltip:Show();
end
MapPOIMixins.GroupedCoalescedMapPinMixin = GroupedCoalescedMapPinMixin;
--endregion

--region AnimatedPinMixin
local AnimatedPinMixin = {}

function AnimatedPinMixin:OnLoad()
	BaseMapPoiPinMixin.OnLoad(self);

	hooksecurefunc(self, "OnAcquired", function(marker, poiInfo)
		if poiInfo.position and self.Bounce and TRP3_API.ui.misc.shouldPlayUIAnimation() then
			local x, y = poiInfo.position:GetXY();
			self:Hide();
			after(AddOn_TotalRP3.Map.getDistanceFromMapCenterFactor(poiInfo.position), function()
				self:Show();
				TRP3_API.ui.misc.playAnimation(self.Bounce);
			end);
		end
	end)
end
MapPOIMixins.AnimatedPinMixin = AnimatedPinMixin;
--endregion

AddOn_TotalRP3.MapPOIMixins = MapPOIMixins;
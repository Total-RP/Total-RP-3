-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);
---@type AddOn_TotalRP3
local AddOn_TotalRP3 = AddOn_TotalRP3;

--region Ellyb imports
local Tooltips = Ellyb.Tooltips;
--endregion

local MapPoiMixins = {};

--region CoalescedMapPin
-- The coalesced map pins display one single tooltip with the content of all the markers under the cursor
local CoalescedMapPinMixin = {};

function CoalescedMapPinMixin:OnMouseEnter()
	local tooltip = Tooltips.getTooltip(self);

	local function coalesceMarkerTooltip(marker)
		if marker:IsVisible() and marker:IsMouseOver() then
			tooltip:AddTempLine(marker.tooltipLine)
		end
	end

	if self:GetMap().ExecuteOnAllPins then
		self:GetMap():ExecuteOnAllPins(coalesceMarkerTooltip);
	else
		for marker in self:GetMap():EnumerateAllPins() do
			coalesceMarkerTooltip(marker);
		end
	end
	tooltip:Show();
end
MapPoiMixins.CoalescedMapPinMixin = CoalescedMapPinMixin;
--endregion

--region GroupedCoalescedMapMixin
-- The grouped coalesced map pins have uses categories to group the content of the markers under the cursor
local GroupedCoalescedMapPinMixin = {};

local WHITE = Ellyb.ColorManager.WHITE;
local TOOLTIP_CATEGORY_SEPARATOR = [[|TInterface\Common\UI-TooltipDivider-Transparent:8:128:0:0:8:8:0:128:0:8:255:255:255|t]];

--- Custom sorting function that compares entries. The resulting order is
---  in order of their category priority (descending), or if equal, their
---  sortable name equivalent (ascending).
local function sortMarkerEntries(a, b)
	local categoryA = a.categoryPriority or math.huge;
	local categoryB = b.categoryPriority or math.huge;

	if categoryA == math.huge and type(categoryB) == "string" then
		categoryA = "";
	elseif categoryB == math.huge and type(categoryA) == "string" then
		categoryB = "";
	end

	local nameA = a.sortName or "";
	local nameB = b.sortName or "";

	return (categoryA < categoryB)
		or (categoryA == categoryB and nameA < nameB);
end

local function ExecuteOnAllPins(map, func)
	if map.ExecuteOnAllPins then
		map:ExecuteOnAllPins(func);
	else
		-- Classic compatibility.
		for pin in map:EnumerateAllPins() do
			func(pin);
		end
	end
end

function GroupedCoalescedMapPinMixin:GetMouseOverPins()
	local pins = {};

	local function CheckMouseOverPin(pin)
		if pin:IsMouseOver() then
			table.insert(pins, pin);
		end
	end;

	ExecuteOnAllPins(self:GetMap(), CheckMouseOverPin);
	return pins;
end

function GroupedCoalescedMapPinMixin:GetMouseOverPinsByTemplate(pinTemplate)
	local pins = {};

	for pin in self:GetMap():EnumeratePinsByTemplate(pinTemplate) do
		if pin:IsMouseOver() then
			table.insert(pins, pin);
		end
	end

	return pins;
end

function GroupedCoalescedMapPinMixin:SortPins(pins)
	table.sort(pins, sortMarkerEntries);
end

function GroupedCoalescedMapPinMixin:OnMouseEnter()
	local tooltip = Tooltips.getTooltip(self);

	local markerTooltipEntries = self:GetMouseOverPins();
	self:SortPins(markerTooltipEntries);

	local lastCategory;

	for _, marker in pairs(markerTooltipEntries) do
		if marker.categoryName ~= lastCategory and marker.tooltipLine then
			-- Insert separator between categories except for on the first.
			if lastCategory ~= nil then
				tooltip:AddTempLine(TOOLTIP_CATEGORY_SEPARATOR, WHITE);
			end

			tooltip:AddTempLine(marker.categoryName or "");
			lastCategory = marker.categoryName;
		end

		tooltip:AddTempLine(marker.tooltipLine or "", WHITE);
	end

	self:OnTooltipAboutToShow(tooltip);
	tooltip:Show();
end

function GroupedCoalescedMapPinMixin:OnTooltipAboutToShow(tooltip)  -- luacheck: no unused (prototype)
	-- No-op; implement in a derived mixin if you want to add any suffix lines.
end

MapPoiMixins.GroupedCoalescedMapPinMixin = GroupedCoalescedMapPinMixin;
--endregion

--region AnimatedPinMixin
-- The animated pin mixin automatically animates the pin when displayed so that it bounces and fade into the view
-- It will also delay the animation for the pin so that the animation starts from the pins in the center of the map and finishes with the pin at the corners of the map.
local AnimatedPinMixin = {}

---@param pin Frame
local function createBounceAnimation(pin)
	if pin.Bounce then return end
	pin.Bounce = pin:CreateAnimationGroup("Bounce")
	pin.Bounce:SetToFinalAlpha(true)

	local alpha = pin.Bounce:CreateAnimation("Alpha");
	alpha:SetFromAlpha(0);
	alpha:SetToAlpha(1);
	alpha:SetDuration(0.2);

	local bounceIn = pin.Bounce:CreateAnimation("Scale");
	bounceIn:SetScale(1.5, 1.5);
	bounceIn:SetDuration(0.2);

	local bounceOut = pin.Bounce:CreateAnimation("Scale")
	bounceOut:SetScale(0.5, 0.5);
	bounceOut:SetDuration(0.2);
	bounceOut:SetStartDelay(0.2);
end

function AnimatedPinMixin:OnLoad()
	BaseMapPoiPinMixin.OnLoad(self);
	createBounceAnimation(self)

	hooksecurefunc(self, "OnAcquired", function(_, poiInfo)
		if poiInfo.position and self.Bounce and TRP3_API.ui.misc.shouldPlayUIAnimation() then
			self:Hide();
			C_Timer.After(AddOn_TotalRP3.Map.getDistanceFromMapCenterFactor(poiInfo.position), function()
				self:Show();
				TRP3_API.ui.misc.playAnimation(self.Bounce);
			end);
		end
	end)
end
MapPoiMixins.AnimatedPinMixin = AnimatedPinMixin;
--endregion

--region BasePinMixin
---@class BasePinMixin
local BasePinMixin = {};

--- Build display data that will be used by BasePinMixin:Decorate(displayData) to decorate the mixin
--[[ Override ]] function BasePinMixin:GetDisplayDataFromPoiInfo(poiInfo) -- luacheck: ignore 212
	return {}
end

--- Decorates the pin using the display data we received from BasePinMixin:GetDisplayDataFromPoiInfo(poiInfo)
--[[ Override ]] function BasePinMixin:Decorate(displayData)  -- luacheck: ignore 212

end

function BasePinMixin:OnAcquired(poiInfo)
	-- TODO Check all the results to make sure they contain expected data
	-- Get display data
	local displayData = self:GetDisplayDataFromPoiInfo(poiInfo);
	-- Get the atlasName we should use for the pin texture
	poiInfo.atlasName = displayData.iconAtlas or "PartyMember";
	-- Call the BaseMapPoiPinMixin's OnAcquired method, to have it set the position of the POI and everything
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);
	-- Call :Decorate() to let the pin decorate itself based on the displayData we received
	self:Decorate(displayData)
end
MapPoiMixins.BasePinMixin = BasePinMixin;
--endregion

--- Create a new pin template
---@vararg table @ A list of mixins to include for this new template
---@return BaseMapPoiPinMixin|MapCanvasPinMixin|{GetMap:fun():MapCanvasMixin}
function MapPoiMixins.createPinTemplate(...)
	-- TODO Check all the results to make sure they contain expected data
	-- Create a new template for POI pins
	local pinTemplate = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_VEHICLE_ABOVE_GROUP_MEMBER");
	-- Add our base mixin to it
	Mixin(pinTemplate, AddOn_TotalRP3.MapPoiMixins.BasePinMixin);
	-- Go through all the mixins we were given and add them too
	for _, mixin in pairs({...}) do
		Mixin(pinTemplate, mixin);
	end
	return pinTemplate
end

AddOn_TotalRP3.MapPoiMixins = MapPoiMixins;

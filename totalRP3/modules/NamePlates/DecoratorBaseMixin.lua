-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
local _, TRP3_API = ...;

-- TRP3_API imports.
local TRP3_Utils = TRP3_API.utils;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Base mixin used for nameplate decorators. A decorator implements the
-- logic for styling nameplates depending upon which addon is being used
-- to customize them by the end-user.
local DecoratorBaseMixin = {};

-- Initializes the decorator. This is called at-most once when your decorator
-- is selected for use by the module.
function DecoratorBaseMixin:Init()
	-- Override this in your implementation to perform initialization logic.
end

-- Called when a nameplate unit token is attached to an allocated nameplate
-- frame. This can be used to perform setup logic.
function DecoratorBaseMixin:OnNamePlateUnitAdded()
	-- Override this in your implementation if setup logic is desired.
end

-- Called when a nameplate unit token is removed from an allocated nameplate
-- frame. This can be used to perform teardown logic.
function DecoratorBaseMixin:OnNamePlateUnitRemoved()
	-- Override this in your implementation if teardown logic is desired.
end

-- Returns the custom name text to be displayed for the given unit token.
--
-- Return nil if customizations are disabled, or if no name can be obtained.
function DecoratorBaseMixin:GetUnitCustomName(unitToken)
	-- Grab the name and prefix it with the OOC indicator.
	local nameText = NamePlates.GetUnitCustomName(unitToken);
	if nameText then
		local oocIndicator = NamePlates.GetUnitOOCIndicator(unitToken);
		if oocIndicator then
			nameText = strjoin(" ", oocIndicator, nameText);
		end
	end

	return nameText;
end

-- Returns the custom color to be displayed for the given unit token.
--
-- Return nil if customizations are disabled, or if no color can be obtained.
function DecoratorBaseMixin:GetUnitCustomColor(unitToken)
	-- Implement any custom logic to be shared between decorators if needed.
	return NamePlates.GetUnitCustomColor(unitToken);
end

-- Returns the full file path of an icon for the given unit token.
--
-- Returns nil if customization is disabled, or if no icon is available.
function DecoratorBaseMixin:GetUnitCustomIcon(unitToken)
	-- Prefix the icon name for this unit with the standard path, if present.
	local iconName = NamePlates.GetUnitCustomIcon(unitToken);
	if iconName then
		return [[Interface\Icons\]] .. iconName;
	end

	return nil;
end

-- Returns the name of an title text of a profile for the given unit token.
--
-- Returns nil if customization is disabled, or if no title is available.
function DecoratorBaseMixin:GetUnitCustomTitle(unitToken)
	-- Get the title and apply a standard amount of cropping that should be
	-- consistent across all displays.
	local titleText = NamePlates.GetUnitCustomTitle(unitToken);
	if titleText then
		titleText = TRP3_Utils.str.crop(titleText, NamePlates.MAX_TITLE_CHARS);
	end

	return titleText;
end

-- Updates the name plate for a single unit identified by the given token.
--
-- Returns true if the frame is updated successfully, or false if the given
-- unit token is invalid.
--
-- @param unitToken The unit token to update a nameplate for.
function DecoratorBaseMixin:UpdateNamePlateForUnit(_)
	-- Override this in your implementation.
	return false;
end

-- Updates all name plates managed by this decorator.
function DecoratorBaseMixin:UpdateAllNamePlates()
	-- Override this in your implementation.
end

-- Module exports.
NamePlates.DecoratorBaseMixin = DecoratorBaseMixin;

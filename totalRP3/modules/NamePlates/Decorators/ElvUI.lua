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
local L = TRP3_API.loc;
local TRP3_Utils = TRP3_API.utils;

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- NamePlates imports.
local DecoratorBaseMixin = NamePlates.DecoratorBaseMixin;

-- Decorator that integrates with Kui nameplates.
local ElvUIDecoratorMixin = CreateFromMixins(DecoratorBaseMixin);

-- Mapping of tag names to functions that return data for display. These
-- are standard oUF tag functions and have the same custom environment that
-- standard tags have, so may make use of the "magic" globals like _FRAME and
-- _TAGS.
ElvUIDecoratorMixin.Tags = {};

-- Mapping of tag names to a string of space-separated event names that should
-- trigger a refresh of that tag.
ElvUIDecoratorMixin.Events = {};

-- Mapping of shared (unitless) events to be registered with oUF.
ElvUIDecoratorMixin.SharedEvents = {};

-- Initializes the decorator.
function ElvUIDecoratorMixin:Init()
	-- Call the inherited method first.
	DecoratorBaseMixin.Init(self);

	-- Map keeping track of which frames are using which tags.
	self.trackedFrames = {};

	-- Register all the tags with ElvUI's oUF embed.
	for name, func in pairs(self.Tags) do
		self:InitCustomTag(name, func, self.Events[name]);
	end

	-- Register any shared (unitless) events as well.
	for event in pairs(self.SharedEvents) do
		ElvUI.oUF.Tags.SharedEvents[event] = true;
	end
end

-- Initializes a named custom tag with ElvUI's embedded oUF installation.
function ElvUIDecoratorMixin:InitCustomTag(name, func, events)
	-- Register the custom tag, unsetting anything that was already present.
	if ElvUI.oUF.Tags.Methods[name] then
		ElvUI.oUF.Tags.Methods[name] = nil;
	end

	ElvUI.oUF.Tags.Methods[name] = function(unit, realUnit)
		-- _FRAME is a magic global present in the function environment.
		self:SetFrameTagged(_FRAME, true); -- luacheck: no global
		return func(unit, realUnit);
	end

	-- Mirror the environment to the tag function once known. The environment
	-- table is the same for all tags, so this only needs to happen once.
	setfenv(func, getfenv(ElvUI.oUF.Tags.Methods[name]));

	-- Add in any events that our tag might possibly use.
	if events then
		ElvUI.oUF.Tags.Events[name] = events;
	end

	-- Update all the frames that were using the tag to use the function that
	-- we've installed, in case we opted to outright replace things.
	ElvUI.oUF.Tags:RefreshMethods(name);
end

-- Returns true if the given frame is actively using any of our oUF tags.
function ElvUIDecoratorMixin:IsFrameTagged(frame)
	return self.trackedFrames[frame];
end

-- Sets whether or not a given oUF unitframe is "tagged"; if true then
-- this implies that the frame is using one (or more) of our custom tags
-- and should be updated when RP information changes on a unit.
--
-- We only support nameplates for tags; non-nameplate frames will emit
-- a warning upon the first use of a tag.
function ElvUIDecoratorMixin:SetFrameTagged(frame, isTagged)
	-- If this frame is already tracked, short-circuit.
	if self.trackedFrames[frame] then
		return;
	end

	-- Track it.
	self.trackedFrames[frame] = isTagged;

	-- If this frame isn't a nameplate, we can't guarantee that tags will
	-- work as the user is expecting. We'll warn once.
	if isTagged and frame.unit then
		local nameplate = self:GetNamePlateForUnit(frame.unit);
		if nameplate ~= frame then
			local message = L("NAMEPLATES_ELVUI_INVALID_FRAME_FOR_TAG", frame.unit);
			TRP3_Utils.message.displayMessage(message);
		end
	end
end

-- Updates the given nameplate.
--[[override]] function ElvUIDecoratorMixin:UpdateNamePlate(nameplate)
	-- Force an update of all text tags on the nameplate.
	if self:IsFrameTagged(nameplate) then
		nameplate:UpdateTags();
	end
end

-- Returns the nameplate frame used by a named unit.
--[[override]] function ElvUIDecoratorMixin:GetNamePlateForUnit(unitToken)
	-- Grab the standard nameplate frame for this unit.
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitToken);
	if not nameplate then
		return nil;
	end

	-- ElvUI stores its custom unitframe portion in the "unitFrame" key.
	return nameplate.unitFrame;
end

do
	-- Wrapping iterator around next that returns the oUF unitframe portion
	-- of each nameplate that next would have normally returned.
	local function nextNamePlate(nameplates, key)
		local nextKey, nameplate = next(nameplates, key);
		if nextKey then
			return nextKey, nameplate.unitFrame;
		end
	end

	-- Returns an iterator for accessing all nameplate frames.
	--[[override]] function ElvUIDecoratorMixin:GetAllNamePlates()
		return nextNamePlate, C_NamePlate.GetNamePlates();
	end
end

-- oUF makes use of function environments and, with them, defines things
-- that Luacheck would flag as being undefined globals. These are listed
-- below as local exceptions for linting in this entire file.
--
-- See _ENV: https://github.com/oUF-wow/oUF/blob/master/elements/tags.lua
--
-- luacheck: read globals _COLORS _FRAME _TAGS _VARS ColorGradient Hex

-- oUF Tag functions.
ElvUIDecoratorMixin.Tags["trp3np:name"] = function(unit, realUnit)
	local name = NamePlates.GetUnitCustomName(unit);
	if name then
		return name;
	end

	return _TAGS["name"](unit, realUnit);
end

ElvUIDecoratorMixin.Tags["trp3np:namecolor"] = function(unit, _)
	local customColor = NamePlates.GetUnitCustomColor(unit);
	if customColor then
		return customColor:GetColorCodeStartSequence();
	end

	local classColor = NamePlates.GetUnitClassColor(unit);
	if classColor then
		return classColor:GetColorCodeStartSequence();
	end

	return "";
end

ElvUIDecoratorMixin.Tags["trp3np:icon"] = function(unit, _)
	local iconName = NamePlates.GetUnitCustomIcon(unit);
	if iconName then
		return format("|TInterface\\Icons\\%s:0:::|t", iconName);
	end

	return "";
end

ElvUIDecoratorMixin.Tags["trp3np:title"] = function(unit, _)
	local customTitle = NamePlates.GetUnitCustomTitle(unit);
	if customTitle then
		return customTitle;
	end

	local ingameTitle = NamePlates.GetUnitIngameTitle(unit);
	if ingameTitle then
		return ingameTitle;
	end

	return "";
end

ElvUIDecoratorMixin.Tags["trp3np:ooc"] = function(unit, _)
	local oocIndicator = NamePlates.GetUnitOOCIndicator(unit);
	if oocIndicator then
		return oocIndicator;
	end

	return "";
end

-- Module exports.
NamePlates.ElvUIDecoratorMixin = ElvUIDecoratorMixin;

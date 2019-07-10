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

-- Ellyb imports.
local ColorManager = TRP3_API.Ellyb.ColorManager;

-- Maximum number of characters for displayed titles.
local MAX_TITLE_SIZE = 40;

-- Size of custom icons.
local ICON_WIDTH = 16;
local ICON_HEIGHT = 16;

-- Decorator plugin for styling Blizzard's default nameplates.
local BlizzardDecoratorMixin = CreateFromMixins(NamePlates.DisplayDecoratorMixin);

-- Initializes the decorator, enabling it to modify Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:Init()
	-- Mapping of unit frame objects to a table of widgets.
	self.unitFrameWidgets = {};

	-- Pools from which widgets are sourced.
	self.fontStringPool = CreateFontStringPool(UIParent, "ARTWORK", 0, "SystemFont_NamePlate");
	self.texturePool = CreateTexturePool(UIParent, "ARTWORK", 0);

	-- Install hooks.
	hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		return self:OnUnitFrameNameChanged(frame);
	end);
end

-- Called when a nameplate unit token is attached to an allocated nameplate
-- frame. This is used to set up custom widgets on Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:OnNamePlateUnitAdded(unitToken)
	-- Grab the frame for this unit token.
	local frame = self:GetUnitFrameForUnit(unitToken);
	if not frame then
		return;
	end

	-- Set up custom widgets to the frame.
	self:SetUpUnitFrameIcon(frame);
	self:SetUpUnitFrameTitle(frame);
end

-- Called when a nameplate unit token is removed from an allocated nameplate
-- frame. This is used to remove custom widgets from Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:OnNamePlateUnitRemoved(unitToken)
	-- Grab the frame for this unit token.
	local frame = self:GetUnitFrameForUnit(unitToken);
	if not frame then
		return;
	end

	-- Tear down customizations to the frame.
	self:TearDownUnitFrameIcon(frame);
	self:TearDownUnitFrameTitle(frame);
end

-- Handler triggered when the name on a unit frame is modified by the UI.
function BlizzardDecoratorMixin:OnUnitFrameNameChanged(frame)
	-- Discard frames that don't refer to nameplate units.
	if not strfind(tostring(frame.unit), "^nameplate%d+$") then
		return;
	end

	-- Update the name portion of the unit frame.
	self:UpdateUnitFrameName(frame);
end

-- Returns true if the given frame can be customized without raising any
-- potential errors if untrusted code attempts to modify it.
function BlizzardDecoratorMixin:IsUnitFrameCustomizable(frame)
	-- Only non-forbidden frames can be customized.
	return CanAccessObject(frame);
end

-- Returns the unit frame on a nameplate for the given unit token, or nil
-- if no frame can be found.
--
-- This function will always return the frame, even if it cannot be
-- customized. It is the responsibility of the caller to ensure that
-- customizability is checked via IsUnitFrameCustomizable prior to making
-- any changes.
function BlizzardDecoratorMixin:GetUnitFrameForUnit(unitToken)
	local frame = C_NamePlate.GetNamePlateForUnit(unitToken);
	if not frame or not frame.UnitFrame then
		return nil;
	end

	return frame.UnitFrame;
end

-- Updates the name display on a given unit frame.
function BlizzardDecoratorMixin:UpdateUnitFrameName(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Apply changes to the name and color. These will return nil if
	-- customizations are disabled/impossible, in which case we'll assume
	-- that the Blizzard-provided defaults are currently set.
	local nameText = NamePlates.GetCustomUnitName(frame.unit);
	if nameText then
		frame.name:SetText(nameText);
	end

	local nameColor = NamePlates.GetCustomUnitColor(frame.unit);
	if nameColor then
		-- While SetTextColor might be more obvious, Blizzard instead calls
		-- SetVertexColor. We mirror to ensure things work.
		frame.name:SetVertexColor(nameColor:GetRGBA());
	end
end

-- Initializes the icon display on a unit frame.
function BlizzardDecoratorMixin:SetUpUnitFrameIcon(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Try to obtain a texture widget.
	local iconWidget = self:AcquireUnitFrameTexture(frame, "icon");
	if not iconWidget then
		return;
	end

	-- Set up anchoring and reparent.
	iconWidget:ClearAllPoints();
	iconWidget:SetParent(frame);
	iconWidget:SetPoint("RIGHT", frame.name, "LEFT", -4, 0);
	iconWidget:SetSize(ICON_WIDTH, ICON_HEIGHT);
	iconWidget:Hide();
end

-- Updates the icon display on a nameplate.
function BlizzardDecoratorMixin:UpdateUnitFrameIcon(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Get the icon widget if one was allocated.
	local iconWidget = self:GetUnitFrameWidget(frame, "icon");
	if not iconWidget then
		return;
	end

	-- Get the icon. If there's no icon, we'll hide it entirely.
	local iconName = NamePlates.GetCustomUnitIcon(frame.unit);
	if not iconName or iconName == "" then
		iconWidget:Hide();
	else
		iconWidget:SetTexture([[Interface\ICONS\]] .. iconName);
		iconWidget:Show();
	end
end

-- Deinitializes RP icon display on a unit frame.
function BlizzardDecoratorMixin:TearDownUnitFrameIcon(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Release the custom texture widget.
	self:ReleaseUnitFrameTexture(frame, "icon");
end

-- Initializes the title display on a unit frame.
function BlizzardDecoratorMixin:SetUpUnitFrameTitle(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Try to obtain a fontstring widget.
	local titleWidget = self:AcquireUnitFrameFontString(frame, "title");
	if not titleWidget then
		return;
	end

	-- Set up anchoring and reparent.
	titleWidget:ClearAllPoints();
	titleWidget:SetParent(frame);
	titleWidget:SetPoint("TOP", frame.name, "BOTTOM", 0, -4);
	titleWidget:SetVertexColor(ColorManager.ORANGE:GetRGBA());
	titleWidget:Hide();
end

-- Updates the title display on a nameplate.
function BlizzardDecoratorMixin:UpdateUnitFrameTitle(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Get the title widget if one was allocated.
	local titleWidget = self:GetUnitFrameWidget(frame, "title");
	if not titleWidget then
		return;
	end

	-- Grab the title text. If there's no title text, we'll hide it entirely.
	local titleText = NamePlates.GetCustomUnitTitle(frame.unit);
	if not titleText or titleText == "" then
		titleWidget:Hide();
	else
		-- Crop titles and format them appropriately.
		titleText = TRP3_Utils.str.crop(titleText, MAX_TITLE_SIZE);

		titleWidget:SetFormattedText("<%s>", titleText);
		titleWidget:Show();
	end
end

-- Deinitializes the title display on a unit frame.
function BlizzardDecoratorMixin:TearDownUnitFrameTitle(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Release the custom fontstring widget.
	self:ReleaseUnitFrameFontString(frame, "title");
end

-- Updates the name plate for a single unit identified by the given token.
--
-- Returns true if the frame is updated successfully, or false if the given
-- unit token is invalid.
--[[override]] function BlizzardDecoratorMixin:UpdateNamePlateForUnit(unitToken)
	-- Grab the frame for this unit.
	local frame = self:GetUnitFrameForUnit(unitToken);
	if not frame then
		return false;
	end

	-- A full update for this nameplate will first reset the name to the
	-- Blizzard default. This will unfortunately trigger two updates for
	-- the name, but that's life.
	if self:IsUnitFrameCustomizable(frame) then
		CompactUnitFrame_UpdateName(frame);
	end

	-- Then update all the individual customizations.
	self:UpdateUnitFrameName(frame);
	self:UpdateUnitFrameIcon(frame);
	self:UpdateUnitFrameTitle(frame);

	return true;
end

-- Updates all name plates managed by this decorator.
--[[override]] function BlizzardDecoratorMixin:UpdateAllNamePlates()
	for _, frame in pairs(C_NamePlate.GetNamePlates()) do
		self:UpdateNamePlateForUnit(frame.namePlateUnitToken);
	end
end

-- Returns a named custom widget for a unit frame, or nil if the widget
-- doesn't exist.
function BlizzardDecoratorMixin:GetUnitFrameWidget(frame, widgetName)
	local widgets = self.unitFrameWidgets[frame];
	if not widgets then
		return nil;
	end

	return widgets[widgetName];
end

-- Acquires a named custom widget for a unit frame, sourcing it from the given
-- pool and returning it.
--
-- This function will return nil if the given frame is forbidden, and
-- no widget will be acquired.
--
-- The widget returned may or may not be sourced from the reusable pool. It
-- is the responsibility of the caller to ensure that the widget is reset
-- prior to modifications.
function BlizzardDecoratorMixin:AcquireUnitFrameWidget(frame, widgetName, pool)
	-- Don't add widgets to locked down frames.
	if not CanAccessObject(frame) then
		return nil;
	end

	-- We'll store widget sets keyed by the frame. Frames themselves are
	-- pooled, so this won't leak anything.
	local widgets = self.unitFrameWidgets[frame] or {};
	self.unitFrameWidgets[frame] = widgets;

	-- There's a few cases where widgets don't get cleaned up if you toggle,
	-- but that's fine. We'll just re-use them even if they weren't put back
	-- into the pool.
	local widget = widgets[widgetName] or pool:Acquire();
	widgets[widgetName] = widget;
	return widget;
end

-- Acquires a custom font string widget and assigns it to the given frame.
function BlizzardDecoratorMixin:AcquireUnitFrameFontString(frame, widgetName)
	return self:AcquireUnitFrameWidget(frame, widgetName, self.fontStringPool);
end

-- Acquires a custom texture widget and assigns it to the given frame.
function BlizzardDecoratorMixin:AcquireUnitFrameTexture(frame, widgetName)
	return self:AcquireUnitFrameWidget(frame, widgetName, self.texturePool);
end

-- Releases a named custom widget from a unit frame, placing it back into the
-- given pool.
--
-- If the frame is inaccessible, this will not release the widget, however
-- the future acquisitions of the widget with the same name will return the
-- same widget.
function BlizzardDecoratorMixin:ReleaseUnitFrameWidget(frame, widgetName, pool)
	-- Don't release widget from to locked down frames. These should never
	-- have had them added in the first place, so this should be fine.
	if not CanAccessObject(frame) then
		return;
	end

	local widgets = self.unitFrameWidgets[frame];
	if not widgets then
		-- No widgets exist on this frame.
		return;
	end

	local widget = widgets[widgetName];
	if not widget then
		-- No widget with this name exists.
		return;
	end

	-- Remove the widget from the UI as much as possible.
	pool:Release(widget);
	widgets[widgetName] = nil;
end

-- Releases a named custom font string widget from a unit frame.
function BlizzardDecoratorMixin:ReleaseUnitFrameFontString(frame, widgetName)
	return self:ReleaseUnitFrameWidget(frame, widgetName, self.fontStringPool);
end

-- Releases a named custom texture widget from a unit frame.
function BlizzardDecoratorMixin:ReleaseUnitFrameTexture(frame, widgetName)
	return self:ReleaseUnitFrameWidget(frame, widgetName, self.texturePool);
end

-- Module exports.
NamePlates.BlizzardDecoratorMixin = BlizzardDecoratorMixin;

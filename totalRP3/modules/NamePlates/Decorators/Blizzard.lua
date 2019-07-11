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

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Decorator plugin for styling Blizzard's default nameplates.
local BlizzardDecoratorMixin = CreateFromMixins(NamePlates.DecoratorBaseMixin);
Mixin(BlizzardDecoratorMixin, NamePlates.CustomWidgetHostMixin);

-- Initializes the decorator, enabling it to modify Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:Init()
	-- Dispatch to base mixins.
	NamePlates.DecoratorBaseMixin.Init(self);
	NamePlates.CustomWidgetHostMixin.Init(self);

	-- Install hooks.
	hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		return self:OnUnitFrameNameUpdated(frame);
	end);
end

-- Called when a nameplate unit token is attached to an allocated nameplate
-- frame. This is used to set up custom widgets on Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:OnNamePlateUnitAdded(unitToken)
	-- Dispatch to base mixins.
	NamePlates.DecoratorBaseMixin.OnNamePlateUnitAdded(self, unitToken);

	-- Grab the frame for this unit token.
	local frame = self:GetUnitFrameForUnit(unitToken);
	if not frame then
		return;
	end

	-- Set up custom widgets to the frame.
	self:SetUpUnitFrameIcon(frame);
	self:SetUpUnitFrameTitle(frame);

	-- Update the frame immediately with customizations.
	self:UpdateNamePlateForUnit(unitToken);
end

-- Called when a nameplate unit token is removed from an allocated nameplate
-- frame. This is used to remove custom widgets from Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:OnNamePlateUnitRemoved(unitToken)
	-- Dispatch to base mixins.
	NamePlates.DecoratorBaseMixin.OnNamePlateUnitRemoved(self, unitToken);

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
function BlizzardDecoratorMixin:OnUnitFrameNameUpdated(frame)
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
	local nameplate = self:GetNamePlateForUnit(unitToken);
	if not nameplate or not nameplate.UnitFrame then
		return nil;
	end

	return nameplate.UnitFrame;
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
	local nameText = self:GetUnitCustomName(frame.unit);
	if nameText then
		frame.name:SetText(nameText);
	end

	local nameColor = self:GetUnitCustomColor(frame.unit);
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
	local iconWidget = self:AcquireCustomTexture(frame, "icon");
	if not iconWidget then
		return;
	end

	-- Set up anchoring and reparent.
	iconWidget:ClearAllPoints();
	iconWidget:SetParent(frame);
	iconWidget:SetPoint("RIGHT", frame.name, "LEFT", -4, 0);
	iconWidget:SetSize(NamePlates.ICON_WIDTH, NamePlates.ICON_HEIGHT);
	iconWidget:Hide();
end

-- Updates the icon display on a nameplate.
function BlizzardDecoratorMixin:UpdateUnitFrameIcon(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Get the icon widget if one was allocated.
	local iconWidget = self:GetCustomWidget(frame, "icon");
	if not iconWidget then
		return;
	end

	-- Get the icon. If there's no icon, we'll hide it entirely.
	local iconPath = self:GetUnitCustomIcon(frame.unit);
	if not iconPath or iconPath == "" then
		iconWidget:Hide();
	else
		iconWidget:SetTexture(iconPath);
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
	self:ReleaseCustomTexture(frame, "icon");
end

-- Initializes the title display on a unit frame.
function BlizzardDecoratorMixin:SetUpUnitFrameTitle(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Try to obtain a fontstring widget.
	local titleWidget = self:AcquireCustomFontString(frame, "title");
	if not titleWidget then
		return;
	end

	-- Set up anchoring and reparent.
	titleWidget:ClearAllPoints();
	titleWidget:SetParent(frame);
	titleWidget:SetPoint("TOP", frame.name, "BOTTOM", 0, -4);
	titleWidget:SetVertexColor(NamePlates.TITLE_TEXT_COLOR:GetRGBA());
	titleWidget:Hide();
end

-- Updates the title display on a nameplate.
function BlizzardDecoratorMixin:UpdateUnitFrameTitle(frame)
	-- Check if we can customize this frame.
	if not self:IsUnitFrameCustomizable(frame) then
		return;
	end

	-- Get the title widget if one was allocated.
	local titleWidget = self:GetCustomWidget(frame, "title");
	if not titleWidget then
		return;
	end

	-- Grab the title text. If there's no title text, we'll hide it entirely.
	local titleText = self:GetUnitCustomTitle(frame.unit);
	if not titleText or titleText == "" then
		titleWidget:Hide();
	else
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
	self:ReleaseCustomFontString(frame, "title");
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

-- Module exports.
NamePlates.BlizzardDecoratorMixin = BlizzardDecoratorMixin;

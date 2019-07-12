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

-- Decorator that integrates with Kui nameplates.
local KuiDecoratorMixin = CreateFromMixins(NamePlates.DecoratorBaseMixin);

-- Initializes the decorator.
function KuiDecoratorMixin:Init()
	-- Call the inherited method first.
	NamePlates.DecoratorBaseMixin.Init(self);

	-- The only supported layout for use with this module is the Core one;
	-- other layouts might do a lot of things with their texts that we can't
	-- realistically account for.
	if KuiNameplates.layout ~= KuiNameplatesCore then
		TRP3_Utils.message.displayMessage(L.NAMEPLATES_KUI_INVALID_LAYOUT);
		return;
	end

	-- We'll internally disable a lot of stuff if this isn't set.
	self.isValidLayout = true;

	-- Initialize a plugin for our augmentations.
	self.plugin = KuiNameplates:NewPlugin("TotalRP3", 250);
	self.plugin.Create = function(_, nameplate) self:OnNamePlateCreate(nameplate); end
	self.plugin.Show = function(_, nameplate) self:OnNamePlateShow(nameplate); end
	self.plugin.Hide = function(_, nameplate) self:OnNamePlateHide(nameplate); end
	self.plugin:RegisterMessage("Create");
	self.plugin:RegisterMessage("Show");
	self.plugin:RegisterMessage("Hide");

	-- Run over any already-created frames and set them up.
	for _, frame in self:GetAllNamePlates() do
		self:OnNamePlateCreate(frame);
	end
end

-- Handler called when a nameplate frame is initially created.
function KuiDecoratorMixin:OnNamePlateCreate(nameplate)
	-- Add a custom icon element to the nameplate.
	local icon = nameplate:CreateTexture(nil, "ARTWORK");
	icon:SetPoint("RIGHT", nameplate.NameText, "LEFT", -4, 0);
	icon:SetSize(NamePlates.ICON_WIDTH, NamePlates.ICON_HEIGHT);
	nameplate.handler:RegisterElement("TRP3_Icon", icon);

	-- Install hooks on a couple of the nameplate functions. We use hooks
	-- because the other choice is to either constantly monitor the core
	-- layout or each and every message it updates things on.
	hooksecurefunc(nameplate, "UpdateNameText", function(plate)
		self:OnNameTextUpdated(plate);
	end);

	hooksecurefunc(nameplate, "UpdateGuildText", function(plate)
		self:OnGuildTextUpdated(plate);
	end);

	-- Immediately update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is shown.
function KuiDecoratorMixin:OnNamePlateShow(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is hidden.
function KuiDecoratorMixin:OnNamePlateHide(nameplate)
	-- Hide the RP icon element by force.
	nameplate.TRP3_Icon:Hide();
end

-- Handler called when name text is updated on a nameplate.
function KuiDecoratorMixin:OnNameTextUpdated(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Get the custom name to be applied.
	local nameText = self:GetUnitCustomName(nameplate.unit);
	if nameText then
		-- If we're in name-only mode we need to fix up the health colouring.
		if self:IsNamePlateInNameOnlyMode(nameplate) then
			-- The NameOnlySetNameTextToHealth function reads from the state,
			-- but to ease resetting things and not pointlessly resetting
			-- things on each update we'll change it for a moment only.
			local originalName = nameplate.state.name;
			nameplate.state.name = nameText;
			KuiNameplatesCore:NameOnlySetNameTextToHealth(nameplate);
			nameplate.state.name = originalName;
		else
			-- Not in name-only mode, so we'll just apply our change.
			nameplate.NameText:SetText(nameText);
		end

		-- Once colouring is applied we'll prefix the indicator.
		local oocText = NamePlates.GetUnitOOCIndicator(nameplate.unit);
		if oocText then
			nameplate.NameText:SetText(strjoin(" ", oocText, nameplate.NameText:GetText()));
		end
	end

	-- Now for the custom color...
	local nameColor = self:GetUnitCustomColor(nameplate.unit);
	if nameColor then
		nameplate.NameText:SetTextColor(nameColor:GetRGBA());
	end
end

-- Handler called when guild text is updated on a nameplate.
function KuiDecoratorMixin:OnGuildTextUpdated(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Get the title text to be displayed.
	local titleText = self:GetUnitCustomTitle(nameplate.unit);
	if not titleText then
		return;
	end

	-- Format it somewhat and show it in the guild text field.
	nameplate.GuildText:SetFormattedText("<%s>", titleText);
end

-- Returns true if the given nameplate is valid for customizing.
function KuiDecoratorMixin:ShouldCustomizeNamePlate(nameplate)
	-- Disable if the layout was invalid.
	if not self.isValidLayout then
		return false;
	end

	-- Only allow decorations of valid, non-personal nameplates.
	return nameplate.unit ~= nil and not nameplate.state.personal;
end

-- Returns true if the given nameplate frame is in name-only mode. Some
-- customizations shouldn't display if not in name-only mode, but this
-- decision is left to the individual displays.
function KuiDecoratorMixin:IsNamePlateInNameOnlyMode(nameplate)
	return nameplate.IN_NAMEONLY;
end

-- Updates the name text display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateName(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Call the hooked function to trigger the update.
	nameplate:UpdateNameText();
end

-- Updates the icon display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateIcon(nameplate)
	-- Grab the widget from the frame.
	local iconWidget = nameplate.TRP3_Icon;

	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		-- The icon widget will be nil if the layout is invalid.
		if iconWidget then
			iconWidget:Hide();
		end

		return;
	end

	-- Hide the icon if the name text is itself hidden.
	if not nameplate.NameText:IsShown() then
		iconWidget:Hide();
		return;
	end

	local iconPath = self:GetUnitCustomIcon(nameplate.unit);
	if not iconPath then
		iconWidget:Hide();
	else
		iconWidget:SetTexture(iconPath);
		iconWidget:Show();
	end
end

-- Updates the title display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateTitle(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Call the hooked function to trigger the update.
	nameplate:UpdateGuildText();
end

-- Updates the given nameplate.
--[[override]] function KuiDecoratorMixin:UpdateNamePlate(nameplate)
	-- Apply the modifications piece by piece.
	self:UpdateNamePlateName(nameplate);
	self:UpdateNamePlateTitle(nameplate);
	self:UpdateNamePlateIcon(nameplate);
end

-- Returns the custom name text to be displayed for the given unit token.
--
-- Return nil if customizations are disabled, or if no name can be obtained.
--[[override]] function KuiDecoratorMixin:GetUnitCustomName(unitToken)
	-- The OOC indicator is handled specially.
	return NamePlates.GetUnitCustomName(unitToken);
end

-- Returns the custom color to be displayed for the given unit token.
--
-- Return nil if customizations are disabled, or if no color can be obtained.
--[[override]] function KuiDecoratorMixin:GetUnitCustomColor(unitToken)
	-- Kui already provides class coloring as a default, so just use customs.
	return NamePlates.GetUnitCustomColor(unitToken);
end

-- Returns the nameplate frame used by a named unit.
--[[override]] function KuiDecoratorMixin:GetNamePlateForUnit(unitToken)
	return KuiNameplates:GetActiveNameplateForUnit(unitToken);
end

-- Returns an iterator for accessing all nameplate frames.
--[[override]] function KuiDecoratorMixin:GetAllNamePlates()
	return KuiNameplates:Frames();
end

-- Module exports.
NamePlates.KuiDecoratorMixin = KuiDecoratorMixin;

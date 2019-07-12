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

-- Note: This module is in a temporary "just get it working" state. It does
--       a few things which will hopefully not be present in the final
--       release, and thus additionally depends upon the Core layout as
--       shipped with KNP by default to be used.

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- TEMP: Temporary function to test some invariants.
local function DebugCheck(cond, msg)
	if not cond and TRP3_API.globals.DEBUG_MODE then
		-- pcall into error means we'll get a "<file>:<line>:" prefix.
		local _, err = pcall(error, msg or "check failed!", 2);
		CallErrorHandler(err);
	end

	return cond;
end

-- Decorator that integrates with Kui nameplates.
local KuiDecoratorMixin = CreateFromMixins(NamePlates.DecoratorBaseMixin);

-- Initializes the decorator.
function KuiDecoratorMixin:Init()
	-- Call the inherited method first.
	NamePlates.DecoratorBaseMixin.Init(self);

	-- Keep a reference to the addon table locally.
	self.addon = KuiNameplates;

	-- Initialize a plugin for our augmentations.
	self.plugin = self.addon:NewPlugin("TotalRP3", 200);

	-- Register message handlers for plates.
	self.plugin:RegisterMessage("Create", function(_, frame)
		self:OnNamePlateCreate(frame);
	end);

	self.plugin:RegisterMessage("Show", function(_, frame)
		self:OnNamePlateShow(frame);
	end);

	self.plugin:RegisterMessage("HealthUpdate", function(_, frame)
		self:OnNamePlateHealthUpdate(frame);
	end);

	self.plugin:RegisterMessage("GainedTarget", function(_, frame)
		self:OnNamePlateGainedTarget(frame);
	end);

	self.plugin:RegisterMessage("LostTarget", function(_, frame)
		self:OnNamePlateLostTarget(frame);
	end);

	self.plugin:RegisterMessage("Hide", function(_, frame)
		self:OnNamePlateHide(frame);
	end);

	-- Run over all the already-created frames and set them up.
	for _, frame in self:GetAllNamePlates() do
		self:SetUpNamePlate(frame);
	end
end

-- Handler called when a nameplate frame is initially created.
function KuiDecoratorMixin:OnNamePlateCreate(nameplate)
	-- Set the nameplate up and then update it.
	self:SetUpNamePlate(nameplate);
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is shown.
function KuiDecoratorMixin:OnNamePlateShow(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate's health changes.
function KuiDecoratorMixin:OnNamePlateHealthUpdate(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate gains a target.
function KuiDecoratorMixin:OnNamePlateGainedTarget(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate loses a target.
function KuiDecoratorMixin:OnNamePlateLostTarget(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is hidden.
function KuiDecoratorMixin:OnNamePlateHide(nameplate)
	-- Hide the RP icon element by force.
	local icon = nameplate.TRP3_Icon;
	DebugCheck(icon, "Nameplate is missing a custom icon element");
	if icon then
		icon:Hide();
	end
end

-- Returns true if the given nameplate is valid for customizing.
function KuiDecoratorMixin:ShouldCustomizeNamePlate(nameplate)
	-- Only allow decorations of valid, non-personal nameplates.
	return nameplate.unit ~= nil and not nameplate.state.personal;
end

-- Returns true if the given nameplate frame is in name-only mode. Some
-- customizations shouldn't display if not in name-only mode, but this
-- decision is left to the individual displays.
function KuiDecoratorMixin:IsNamePlateInNameOnlyMode(nameplate)
	return nameplate.IN_NAMEONLY;
end

-- Sets up the given nameplate, installing custom elements and hooks.
function KuiDecoratorMixin:SetUpNamePlate(nameplate)
	-- We assume this only gets called once per nameplate.
	DebugCheck(not nameplate.TRP3_Icon, "Attempted to set up a nameplate twice");

	-- Create an icon texture and register it as an element.
	if not nameplate.TRP3_Icon then
		local icon = nameplate:CreateTexture(nil, "ARTWORK");
		icon:SetPoint("RIGHT", nameplate.NameText, "LEFT", -4, 0);
		icon:SetSize(NamePlates.ICON_WIDTH, NamePlates.ICON_HEIGHT);

		nameplate.handler:RegisterElement("TRP3_Icon", icon);
	end

	-- Install hooks on some of the update functions to apply modifications.
	if not nameplate.TRP3_UpdateNameTextHookInstalled then
		hooksecurefunc(nameplate, "UpdateNameText", function(frame)
			self:UpdateNamePlateName(frame);
		end);

		nameplate.TRP3_UpdateNameTextHookInstalled = true;
	end

	if not nameplate.TRP3_UpdateGuildTextHookInstalled then
		hooksecurefunc(nameplate, "UpdateGuildText", function(frame)
			self:UpdateNamePlateTitle(frame);
		end);

		nameplate.TRP3_UpdateGuildTextHookInstalled = true;
	end
end

-- Updates the name text display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateName(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Get the custom name to be applied.
	local nameText = self:GetUnitCustomName(nameplate.unit);
	if nameText then
		-- Format and show it.
		nameplate.state.name = nameText;
		nameplate.NameText:SetText(nameplate.state.name);

		-- If we're in name-only mode we need to fix up the health colouring.
		-- This should only apply if the Core layout is in use.
		if self:IsNamePlateInNameOnlyMode(nameplate) and KuiNameplatesCore then
			KuiNameplatesCore:NameOnlySetNameTextToHealth(nameplate);
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

-- Updates the icon display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateIcon(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Grab the custom icon element.
	local icon = nameplate.TRP3_Icon;
	DebugCheck(icon, "Nameplate is missing a custom icon element");
	if not icon then
		return;
	end

	-- Hide the icon if the name text is itself hidden.
	if not nameplate.NameText:IsShown() then
		icon:Hide();
		return;
	end

	local iconPath = self:GetUnitCustomIcon(nameplate.unit);
	if not iconPath then
		icon:Hide();
	else
		icon:SetTexture(iconPath);
		icon:Show();
	end
end

-- Updates the title display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateTitle(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Get the title text to be displayed.
	local titleText = self:GetUnitCustomTitle(nameplate.unit);
	if not titleText then
		return false;
	end

	-- Format it somewhat and show it in the guild text field.
	titleText = format("<%s>", titleText);
	nameplate.state.guild_text = titleText;
	nameplate.GuildText:SetText(nameplate.state.guild_text);
end

-- Updates the given nameplate.
--[[override]] function KuiDecoratorMixin:UpdateNamePlate(nameplate)
	-- Hide custom elements before doing customizations; this ensure we
	-- properly hide them if the nameplate state changes for the next test.
	local icon = nameplate.TRP3_Icon;
	DebugCheck(icon, "Nameplate is missing a custom icon element");
	if icon then
		icon:Hide();
	end

	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Reset the name and guild texts on this unit.
	nameplate.handler:UpdateName();

	local guildTextMod = self.addon:GetPlugin("GuildText");
	if guildTextMod then
		guildTextMod:Show(nameplate);
	end

	-- Apply modifications. We'll call the hooked functions to ensure that
	-- sensible defaults get re-applied where possible.
	nameplate:UpdateNameText();
	nameplate:UpdateGuildText();
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
	return self.addon:GetActiveNameplateForUnit(unitToken);
end

-- Returns an iterator for accessing all nameplate frames.
--[[override]] function KuiDecoratorMixin:GetAllNamePlates()
	return self.addon:Frames();
end

-- Module exports.
NamePlates.KuiDecoratorMixin = KuiDecoratorMixin;

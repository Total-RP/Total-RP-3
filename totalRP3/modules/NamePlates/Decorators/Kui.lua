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
	if not KuiNameplates.layout or KuiNameplates.layout ~= KuiNameplatesCore then
		return;
	end

	-- We'll internally disable a lot of stuff if this isn't set.
	self.isValidLayout = true;

	-- Initialize a plugin for our augmentations and define the message
	-- handler functions ahead of time.
	self.plugin = KuiNameplates:NewPlugin("TotalRP3", 250);

	-- Helper that'll create a function forwarding notifications to a
	-- local method on our mixin.
	local CreateHandler = function(fn)
		return function(_, ...)
			return fn(self, ...);
		end
	end

	self.plugin.Create = CreateHandler(self.OnNamePlateCreate);
	self.plugin.Show = CreateHandler(self.OnNamePlateShow);
	self.plugin.HealthUpdate = CreateHandler(self.OnNamePlateHealthUpdate);
	self.plugin.HealthColourChange = CreateHandler(self.OnNamePlateHealthColourChange);
	self.plugin.GlowColourChange = CreateHandler(self.OnNamePlateGlowColourChange);
	self.plugin.GainedTarget = CreateHandler(self.OnNamePlateGainedTarget);
	self.plugin.LostTarget = CreateHandler(self.OnNamePlateLostTarget);
	self.plugin.Combat = CreateHandler(self.OnNamePlateCombat);
	self.plugin.Hide = CreateHandler(self.OnNamePlateHide);

	-- Keep track of initialized nameplates and integrations.
	self.initNamePlates = {};
	self.initIntegrations = false;
end

-- Enables integrations with the KuiNameplates addon. This will register
-- message handlers for its internal events.
function KuiDecoratorMixin:EnableIntegrations()
	-- Don't allow double-initialization.
	if self.initIntegrations then
		return;
	end

	-- Register message handlers.
	self.plugin:RegisterMessage("Create");
	self.plugin:RegisterMessage("Show");
	self.plugin:RegisterMessage("HealthUpdate");
	self.plugin:RegisterMessage("HealthColourChange");
	self.plugin:RegisterMessage("GlowColourChange");
	self.plugin:RegisterMessage("GainedTarget");
	self.plugin:RegisterMessage("LostTarget");
	self.plugin:RegisterMessage("Combat");
	self.plugin:RegisterMessage("Hide");

	-- Flag ourselves as initialized.
	self.initIntegrations = true;
end

-- Disables integrations with tke KuiNameplates addon, unregistering all
-- message handlers.
function KuiDecoratorMixin:DisableIntegrations()
	-- Don't allow double-deinitialization.
	if not self.initIntegrations then
		return;
	end

	-- Unregister all the message handlers so that they stop bugging us.
	self.plugin:UnregisterAllMessages();

	-- Flag ourselves as de-initialized.
	self.initIntegrations = false;
end

-- Initializes the given nameplate, populating it with hooks and custom
-- widgets as needed.
--
-- This function will not allow initializing the same nameplate twice; once
-- initialized, future calls with the same nameplate are a no-op.
function KuiDecoratorMixin:InitNamePlate(nameplate)
	-- Don't allow double-initializing a nameplate.
	local nameplateKey = nameplate:GetName();
	if self.initNamePlates[nameplateKey] then
		return;
	end

	-- Add a custom icon element to the nameplate.
	do
		local iconWidget = nameplate:CreateTexture(nil, "ARTWORK");
		iconWidget:ClearAllPoints();
		iconWidget:SetPoint("RIGHT", nameplate.NameText, "LEFT", -4, 0);
		iconWidget:SetSize(NamePlates.ICON_WIDTH, NamePlates.ICON_HEIGHT);
		iconWidget:Hide();

		nameplate.handler:RegisterElement("TRP3_Icon", iconWidget);
	end

	-- Add a custom label for the title text.
	do
		local titleWidget = nameplate:CreateFontString(nil, "ARTWORK");
		titleWidget:ClearAllPoints();
		titleWidget:SetPoint("TOP", nameplate.NameText, "BOTTOM", 0, -2);

		-- Style to match Kui.
		titleWidget:SetTextColor(1, 1, 1, 0.8);
		titleWidget:SetShadowOffset(1, -1);
		titleWidget:SetShadowColor(0, 0, 0, 1);

		titleWidget:Hide();

		nameplate.handler:RegisterElement("TRP3_Title", titleWidget);
	end

	-- Install a hook to handle name changes. We want to override the
	-- player title text and retain the ability to color things nicely,
	-- as well as prefix OOC indicators. The cleanest way to do this is
	-- with a hook.
	hooksecurefunc(nameplate, "UpdateNameText", function(plate)
		self:OnNameTextUpdated(plate);
	end);

	-- Mark the plate as initialized.
	self.initNamePlates[nameplateKey] = true;
end

-- Handler called when a nameplate frame is initially created.
function KuiDecoratorMixin:OnNamePlateCreate(nameplate)
	-- Initialize the nameplate only if we're customizing things.
	if self:IsCustomizationEnabled() then
		self:InitNamePlate(nameplate);
	end
end

-- Handler called when a nameplate frame is shown.
function KuiDecoratorMixin:OnNamePlateShow(nameplate)
	-- Before updating, we'll mirror any font changes to that of our title.
	if self:IsCustomizationEnabled() then
		local titleWidget = nameplate.TRP3_Title;

		titleWidget:SetFont(nameplate.GuildText:GetFont());
		titleWidget:SetTextColor(nameplate.GuildText:GetTextColor());
	end

	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate's health updates.
function KuiDecoratorMixin:OnNamePlateHealthUpdate(nameplate)
	-- Update the name portion of the health plate.
	self:UpdateNamePlateName(nameplate);
end

-- Handler called when health/reaction color changes for a nameplate.
function KuiDecoratorMixin:OnNamePlateHealthColourChange(nameplate)
	-- This toggles name-only mode, so update it all.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when glow color changes for a nameplate.
function KuiDecoratorMixin:OnNamePlateGlowColourChange(nameplate)
	-- This toggles name-only mode, so update it all.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate's unit is targetted.
function KuiDecoratorMixin:OnNamePlateGainedTarget(nameplate)
	-- This toggles name-only mode, so update it all.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate's unit is no longer targetted.
function KuiDecoratorMixin:OnNamePlateLostTarget(nameplate)
	self:UpdateNamePlate(nameplate);
end

-- Handler called when combat status changes for a nameplate.
function KuiDecoratorMixin:OnNamePlateCombat(nameplate)
	-- This toggles name-only mode, so update it all.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is hidden.
function KuiDecoratorMixin:OnNamePlateHide(nameplate)
	-- Hide the custom widgets by force.
	if self:IsNamePlateCustomizable(nameplate) then
		nameplate.TRP3_Icon:Hide();
		nameplate.TRP3_Title:Hide();
	end
end

-- Handler called when name text is updated on a nameplate.
function KuiDecoratorMixin:OnNameTextUpdated(nameplate)
	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:IsNamePlateCustomizable(nameplate) then
		return;
	end

	-- Get the custom name to be applied.
	local nameText = self:GetUnitCustomName(nameplate.unit);
	if nameText then
		-- If we're in name-only mode we need to fix up the health coloring.
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

		-- Once coloring is applied we'll prefix the indicator.
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

-- Returns true if the given nameplate is valid for customizing.
function KuiDecoratorMixin:IsNamePlateCustomizable(nameplate)
	-- Disable if the layout was invalid.
	if not self.isValidLayout then
		return false;
	end

	-- Ignore nameplates that haven't been initialized.
	if not self.initNamePlates[nameplate:GetName()] then
		return false;
	end

	-- Non-personal nameplates.
	return not nameplate.state.personal;
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
	if not self:IsNamePlateCustomizable(nameplate) then
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
	if not self:IsNamePlateCustomizable(nameplate) then
		-- The icon widget may or may not exist at this point.
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
	-- Grab the widget from the frame.
	local titleWidget = nameplate.TRP3_Title;

	-- If this nameplate looks like it should be left alone, ignore it.
	if not self:IsNamePlateCustomizable(nameplate)
	or not self:IsNamePlateInNameOnlyMode(nameplate) then
		self:SetNamePlateTitleShown(nameplate, false);
		return;
	end

	-- Hide the title if the name text is itself hidden.
	if not nameplate.NameText:IsShown() then
		self:SetNamePlateTitleShown(nameplate, false);
		return;
	end

	-- Update the title text appropriately.
	local titleText = self:GetUnitCustomTitle(nameplate.unit);
	if not titleText or not titleWidget:GetFont() then
		self:SetNamePlateTitleShown(nameplate, false);
	else
		titleWidget:SetFormattedText("<%s>", titleText);
		self:SetNamePlateTitleShown(nameplate, true);
	end
end

-- Toggles the visibility of the title text in a nameplate. This function
-- must be called to ensure the guild text is appropriately repositioned.
function KuiDecoratorMixin:SetNamePlateTitleShown(nameplate, shown)
	-- Grab the widget from the frame.
	local titleWidget = nameplate.TRP3_Title;
	if not titleWidget then
		return;
	end

	-- Update visibility and re-anchor the guild line appopriately.
	titleWidget:SetShown(shown);

	local relativeWidget = nameplate.NameText;
	if shown then
		relativeWidget = titleWidget;
	end

	nameplate.GuildText:ClearAllPoints();
	nameplate.GuildText:SetPoint("TOP", relativeWidget, "BOTTOM", 0, -2);
end

-- Called when customizations for nameplates are globally enabled for all
-- frames. This can occurs either when the main enable setting is toggled,
-- or if the player's roleplay status changes.
--[[override]] function KuiDecoratorMixin:OnCustomizationEnabled()
	-- When customizations are enabled but the layout is invalid, we'll
	-- re-print the message to make it clear.
	if not self.isValidLayout then
		TRP3_Utils.message.displayMessage(L.NAMEPLATES_KUI_INVALID_LAYOUT);
	end

	-- Initialize our integrations with the addon.
	self:EnableIntegrations();

	-- Initialize all the nameplate frames.
	for _, nameplate in self:GetAllNamePlates() do
		self:InitNamePlate(nameplate);
	end
end

-- Called when customizations for nameplates are globally disabled for all
-- frames. This can occurs either when the main enable setting is toggled,
-- or if the player's roleplay status changes.
--[[override]] function KuiDecoratorMixin:OnCustomizationDisabled()
	-- Our integrations can be toggled off again when disabling things.
	self:DisableIntegrations();
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

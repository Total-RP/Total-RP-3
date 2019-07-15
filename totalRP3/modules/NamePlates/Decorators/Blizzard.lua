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

-- NamePlates module imports.
local DecoratorBaseMixin = NamePlates.DecoratorBaseMixin;
local ICON_HEIGHT = NamePlates.ICON_HEIGHT;
local ICON_WIDTH = NamePlates.ICON_WIDTH;
local TITLE_TEXT_COLOR = NamePlates.TITLE_TEXT_COLOR;

-- Decorator plugin for styling Blizzard's default nameplates.
local BlizzardDecoratorMixin = CreateFromMixins(DecoratorBaseMixin);

-- Initializes the decorator, enabling it to modify Blizzard nameplates.
--[[override]] function BlizzardDecoratorMixin:Init()
	-- Dispatch to base mixins.
	DecoratorBaseMixin.Init(self);

	-- Keep track of initialized nameplates and integrations.
	self.initNamePlates = {};
	self.initIntegrations = false;
end

-- Initializes integration with the stock UI. This function will only
-- perform initialization work once; if called multiple times, future calls
-- will have no effect.
function BlizzardDecoratorMixin:InitIntegrations()
	-- Don't double-initialize integrations.
	if self.initIntegrations then
		return;
	end

	-- Hook event notifications on the base UI's NamePlateDriverFrame.
	hooksecurefunc(NamePlateDriverFrame, "OnNamePlateCreated", function(_, nameplate)
		self:OnNamePlateCreated(nameplate);
	end);

	hooksecurefunc(NamePlateDriverFrame, "OnNamePlateAdded", function(_, unitToken)
		self:OnNamePlateAdded(unitToken);
	end);

	hooksecurefunc(NamePlateDriverFrame, "OnNamePlateRemoved", function(_, unitToken)
		self:OnNamePlateRemoved(unitToken);
	end);

	-- Hook updates for parts of unitframes so we can replace things.
	hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		return self:OnUnitFrameNameUpdated(frame);
	end);

	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		return self:OnUnitFrameHealthColorUpdated(frame);
	end);

	-- Mark integrations as initialized when done.
	self.initIntegrations = true;
end

-- Initializes the given nameplate with custom widgets.  This function will
-- only perform initialization work once; if called multiple times, future
-- calls will have no effect.
function BlizzardDecoratorMixin:InitNamePlate(nameplate)
	-- Don't allow double-initializing a nameplate.
	local nameplateKey = nameplate:GetName();
	if self.initNamePlates[nameplateKey] then
		return;
	end

	-- We'll be anchoring things to the unitframe.
	local unitFrame = nameplate.UnitFrame;

	-- Create the icon and title widgets for each nameplate.
	do
		local iconWidget = unitFrame:CreateTexture(nil, "ARTWORK");
		iconWidget:ClearAllPoints();
		iconWidget:SetPoint("RIGHT", unitFrame.name, "LEFT", -4, 0);
		iconWidget:SetSize(ICON_WIDTH, ICON_HEIGHT);
		iconWidget:Hide();

		nameplate.TRP3_Icon = iconWidget;
	end

	do
		local titleWidget = unitFrame:CreateFontString(nil, "ARTWORK");
		titleWidget:ClearAllPoints();
		titleWidget:SetPoint("TOP", unitFrame.name, "BOTTOM", 0, -4);
		titleWidget:SetVertexColor(TITLE_TEXT_COLOR:GetRGBA());
		titleWidget:SetFontObject(SystemFont_NamePlate);
		titleWidget:Hide();

		nameplate.TRP3_Title = titleWidget;
	end

	-- Mark the plate as initialized.
	self.initNamePlates[nameplateKey] = true;
end

-- Called when customizations for nameplates are globally enabled for all
-- frames. This can occurs either when the main enable setting is toggled,
-- or if the player's roleplay status changes.
--[[override]] function BlizzardDecoratorMixin:OnCustomizationEnabled()
	-- Initialize our integrations with the stock UI.
	self:InitIntegrations();

	-- Initialize all the nameplate frames.
	for _, nameplate in self:GetAllNamePlates() do
		self:InitNamePlate(nameplate);
	end
end

-- Called when a nameplate is initially created. This is used to perform
-- one-time setup logic for each plate.
function BlizzardDecoratorMixin:OnNamePlateCreated(nameplate)
	-- Initialize the nameplate only if we're customizing things.
	if self:IsCustomizationEnabled() then
		self:InitNamePlate(nameplate);
	end
end

-- Called when a nameplate unit token is attached to an allocated nameplate
-- frame.
function BlizzardDecoratorMixin:OnNamePlateAdded(unitToken)
	-- Update the nameplate immediately with customizations.
	self:UpdateNamePlateForUnit(unitToken);
end

-- Called when a nameplate unit token is removed from an allocated nameplate
-- frame. This is used to perform teardown logic.
function BlizzardDecoratorMixin:OnNamePlateRemoved(unitToken)
	-- Hide the custom widgets.
	local nameplate = self:GetNamePlateForUnit(unitToken);
	if nameplate and self:IsNamePlateCustomizable(nameplate) then
		nameplate.TRP3_Icon:Hide();
		nameplate.TRP3_Title:Hide();
	end
end

-- Handler triggered when the name on a unit frame is modified by the UI.
function BlizzardDecoratorMixin:OnUnitFrameNameUpdated(unitFrame)
	-- Grab the nameplate for this unitframe, if it's attached to one.
	local nameplate = self:GetNamePlateForUnitFrame(unitFrame);
	if not nameplate then
		return;
	end

	-- Update the name portion of the owning nameplate.
	self:UpdateNamePlateName(nameplate);
end

-- Handler triggered when the health color on a unit frame is modified.
function BlizzardDecoratorMixin:OnUnitFrameHealthColorUpdated(unitFrame)
	-- Grab the nameplate for this unitframe, if it's attached to one.
	local nameplate = self:GetNamePlateForUnitFrame(unitFrame);
	if not nameplate then
		return;
	end

	-- Update the health bar color portion of the owning nameplate.
	self:UpdateNamePlateHealthColor(nameplate);
end

-- Returns the nameplate that owns the given unitframe, or nil if none is
-- found.
function BlizzardDecoratorMixin:GetNamePlateForUnitFrame(unitFrame)
	-- Don't even think about looking at forbidden frames. Even querying
	-- their parents is a bad idea.
	if unitFrame:IsForbidden() then
		return nil;
	end

	-- Discard frames that aren't attached to nameplates.
	local nameplate = unitFrame:GetParent();
	local unitToken = unitFrame.unit;
	if not unitToken or nameplate ~= self:GetNamePlateForUnit(unitToken) then
		return nil;
	end

	return nameplate;
end

-- Returns true if the given nameplate is valid for customizing.
function BlizzardDecoratorMixin:IsNamePlateCustomizable(nameplate)
	-- Only initialized plates are valid.
	if not self.initNamePlates[nameplate:GetName()] then
		return false;
	end

	-- Additionally, reject the personal nameplate. Only test if the token
	-- is non-nil explicitly; a nil unit doesn't mean the plate is invalid.
	local unitToken = nameplate.namePlateUnitToken;
	if unitToken and UnitIsUnit("player", unitToken) then
		return false;
	end

	return true;
end

-- Returns true if the given nameplate frame is in name-only mode. Some
-- customizations shouldn't display if not in name-only mode, but this
-- decision is left to the individual displays.
function BlizzardDecoratorMixin:IsNamePlateInNameOnlyMode(nameplate)
	-- The healthbar will be visible if not in name-only mode. The CVar isn't
	-- applied until reloads, hence why we don't test that in case it got
	-- toggled.
	return not nameplate.UnitFrame.healthBar:IsShown();
end

-- Updates the name display on a nameplate.
function BlizzardDecoratorMixin:UpdateNamePlateName(nameplate)
	-- Check if we can customize this frame.
	if not self:IsNamePlateCustomizable(nameplate) then
		return;
	end

	-- Modifications occur on the unitframe.
	local unitFrame = nameplate.UnitFrame;

	-- Apply changes to the name and color. If we can't replace data, we'll
	-- leave whatever was there last alone.
	local nameText = self:GetUnitCustomName(unitFrame.unit);
	if nameText then
		unitFrame.name:SetText(nameText);
	end

	local nameColor = self:GetUnitCustomColor(unitFrame.unit);
	if nameColor then
		-- While SetTextColor might be more obvious, Blizzard instead calls
		-- SetVertexColor. We mirror to ensure things work.
		unitFrame.name:SetVertexColor(nameColor:GetRGBA());
	end
end

-- Updates the health bar color on a nameplate.
function BlizzardDecoratorMixin:UpdateNamePlateHealthColor(nameplate)
	-- Check if we can customize this frame.
	if not self:IsNamePlateCustomizable(nameplate) then
		return;
	end

	-- Apply the custom color if it exists.
	local unitFrame = nameplate.UnitFrame;
	local healthBar = unitFrame.healthBar;

	local customColor = self:GetUnitCustomColor(unitFrame.unit);
	if not customColor then
		-- Ensure we restore the original color if this hook replaced it.
		healthBar:SetStatusBarColor(healthBar.r, healthBar.g, healthBar.b);
	else
		unitFrame.healthBar:SetStatusBarColor(customColor:GetRGB());
	end
end

-- Updates the icon display on a nameplate.
function BlizzardDecoratorMixin:UpdateNamePlateIcon(nameplate)
	-- Check if we can customize this frame.
	local iconWidget = nameplate.TRP3_Icon;
	if not self:IsNamePlateCustomizable(nameplate) then
		return;
	end

	-- Hide icon if the name isn't showing for whatever reason.
	local unitFrame = nameplate.UnitFrame;
	if not unitFrame.name:IsShown() then
		iconWidget:Hide();
		return;
	end

	-- Get the icon. If there's no icon, we'll hide it entirely.
	local iconPath = self:GetUnitCustomIcon(nameplate.namePlateUnitToken);
	if not iconPath or iconPath == "" then
		iconWidget:Hide();
	else
		iconWidget:SetTexture(iconPath);
		iconWidget:Show();
	end
end

-- Updates the title display on a nameplate.
function BlizzardDecoratorMixin:UpdateNamePlateTitle(nameplate)
	-- Check if we can customize this frame.
	if not self:IsNamePlateCustomizable(nameplate) then
		return;
	end

	-- If the healthbar is showing, customizing the title won't be available
	-- since the bar overlaps the title.
	local titleWidget = nameplate.TRP3_Title;
	if not self:IsNamePlateInNameOnlyMode(nameplate) then
		titleWidget:Hide();
		return;
	end

	-- Hide title if the name isn't showing for whatever reason.
	local unitFrame = nameplate.UnitFrame;
	if not unitFrame.name:IsShown() then
		titleWidget:Hide();
		return;
	end

	-- Grab the title text. If there's no title text, we'll hide it entirely.
	local titleText = self:GetUnitCustomTitle(nameplate.namePlateUnitToken);
	if not titleText or titleText == "" then
		titleWidget:Hide();
	else
		titleWidget:SetFormattedText("<%s>", titleText);
		titleWidget:Show();
	end
end

-- Updates a given nameplate frame.
--[[override]] function BlizzardDecoratorMixin:UpdateNamePlate(nameplate)
	-- A full update for this nameplate will first reset elements to the
	-- Blizzard defaults.
	if self:IsNamePlateCustomizable(nameplate) then
		CompactUnitFrame_UpdateName(nameplate.UnitFrame);
		CompactUnitFrame_UpdateHealthColor(nameplate.UnitFrame);
	end

	-- Then update all the individual customizations.
	self:UpdateNamePlateName(nameplate);
	self:UpdateNamePlateIcon(nameplate);
	self:UpdateNamePlateTitle(nameplate);
end

-- Module exports.
NamePlates.BlizzardDecoratorMixin = BlizzardDecoratorMixin;

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

	self.plugin.Create = function(_, frame)
		self:OnNamePlateCreated(frame);
	end

	self.plugin.Show = function(_, frame)
		self:OnNamePlateShow(frame);
	end

	self.plugin.Update = function(_, frame)
		self:OnNamePlateUpdate(frame);
	end

	self.plugin.Hide = function(_, frame)
		self:OnNamePlateHidden(frame);
	end

	-- Message handlers for the plugin.
	self.plugin.GainedTarget = self.plugin.Update;
	self.plugin.LostTarget = self.plugin.Update;

	-- Register the actual messages.
	self.plugin:RegisterMessage("Create");
	self.plugin:RegisterMessage("Show");
	self.plugin:RegisterMessage("Hide");
	self.plugin:RegisterMessage("GainedTarget");
	self.plugin:RegisterMessage("LostTarget");
end

-- Handler called when a nameplate frame is initially created.
function KuiDecoratorMixin:OnNamePlateCreated(nameplate)
	-- Create an icon texture and register it as an element.
	local icon = nameplate:CreateTexture(nil, "ARTWORK");
	icon:SetPoint("RIGHT", nameplate.NameText, "LEFT", -4, 0);
	icon:SetSize(NamePlates.ICON_WIDTH, NamePlates.ICON_HEIGHT);

	nameplate.handler:RegisterElement("TRP3_RPIcon", icon);

	-- Install hooks on some of the update functions to apply modifications.
	hooksecurefunc(nameplate, "UpdateNameText", function(frame)
		self:UpdateNamePlateName(frame);
	end);

	hooksecurefunc(nameplate, "UpdateGuildText", function(frame)
		self:UpdateNamePlateTitle(frame);
	end);
end

-- Handler called when a nameplate frame is shown .
function KuiDecoratorMixin:OnNamePlateShow(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is updated.
function KuiDecoratorMixin:OnNamePlateUpdate(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);
end

-- Handler called when a nameplate frame is hidden.
function KuiDecoratorMixin:OnNamePlateHidden(nameplate)
	-- Update the nameplate.
	self:UpdateNamePlate(nameplate);

	-- Hide the RP icon element by force.
	local icon = nameplate.TRP3_RPIcon;
	if icon then
		icon:Hide();
	end
end

-- Updates the given nameplate.
function KuiDecoratorMixin:UpdateNamePlate(nameplate)
	-- Hide custom elements before doing customizations; this ensure we
	-- properly hide them if the nameplate state changes for the next test.
	local icon = nameplate.TRP3_RPIcon;
	if icon then
		icon:Hide();
	end

	-- If this nameplate looks like it should be left alone, ignore it,
	if not nameplate.unit
	or nameplate.state.personal
	or not nameplate.state.friend then
		-- It has no unit, it's the personal resource, or it's an enemy.
		return false;
	end

	-- Reset the name and guild texts on this unit.
	local nameTextMod = self.addon:GetPlugin("NameText");
	if nameTextMod then
		nameTextMod:Show(nameplate);
	end

	local guildTextMod = self.addon:GetPlugin("GuildText");
	if guildTextMod then
		guildTextMod:Show(nameplate);
	end

	-- Apply modifications. We'll call the hooked functions to ensure that
	-- sensible defaults get re-applied where possible.
	self:UpdateNamePlateIcon(nameplate);
	nameplate:UpdateNameText();
	nameplate:UpdateGuildText();

	return true;
end

-- Updates the name text display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateName(nameplate)
	-- Restore the original name text before doing anything.
	local namePlugin = self.addon:GetPlugin("NameText");
	if namePlugin then
		namePlugin:Show(nameplate);
	end

	-- Get the custom name to be applied.
	local nameText = self:GetUnitCustomName(nameplate.unit);
	if nameText then
		-- Format and show it.
		nameplate.state.name = nameText;
		nameplate.NameText:SetText(nameplate.state.name);
	end

	-- Now for the custom color...
	local nameColor = self:GetUnitCustomColor(nameplate.unit);
	if nameColor then
		nameplate.NameText:SetTextColor(nameColor:GetRGBA());
	end
end

-- Updates the icon display on a nameplate frame.
function KuiDecoratorMixin:UpdateNamePlateIcon(nameplate)
	-- Grab the custom icon element.
	local icon = nameplate.TRP3_RPIcon;
	if not icon then
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

-- Returns the nameplate frame used by a named unit.
function KuiDecoratorMixin:GetNamePlateForUnit(unitToken)
	return self.addon:GetActiveNameplateForUnit(unitToken);
end

-- Updates the name plate for a single unit identified by the given token.
--
-- Returns true if the frame is updated successfully, or false if the given
-- unit token is invalid.
function KuiDecoratorMixin:UpdateNamePlateForUnit(unitToken)
	-- Grab the nameplate for this unit.
	local nameplate = self:GetNamePlateForUnit(unitToken);
	if not nameplate then
		return false;
	end

	return self:UpdateNamePlate(nameplate);
end

-- Updates all name plates managed by this decorator.
function KuiDecoratorMixin:UpdateAllNamePlates()
	-- We'll use Kui's framelist instead of the default.
	for _, frame in self.addon:Frames() do
		self:UpdateNamePlate(frame);
	end
end

-- Module exports.
NamePlates.KuiDecoratorMixin = KuiDecoratorMixin;

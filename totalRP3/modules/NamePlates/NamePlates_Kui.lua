--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local TRP3_API = select(2, ...);
local TRP3_NamePlates = TRP3_NamePlates;
local TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
local L = TRP3_API.loc;

local function IsNamePlateInNameOnlyMode(nameplate)
	local unitframe = nameplate.parent.UnitFrame;
	return nameplate.IN_NAMEONLY and unitframe and ShouldShowName(unitframe);
end

local TRP3_KuiNamePlates = {};

function TRP3_KuiNamePlates:OnModuleInitialize()
	if not IsAddOnLoaded("Kui_Nameplates") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif not KuiNameplatesCore or KuiNameplates.layout ~= KuiNameplatesCore then
		-- For now we only support the "Core" layout for Kui.
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		-- Another nameplate decorator module met its own activation criteria.
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	-- Define TRP3_NAMEPLATES_ADDON now to claim decoration rights. This
	-- should be sanity checked on OnModuleEnable to make sure someone else
	-- didn't trample over it.

	TRP3_NAMEPLATES_ADDON = "Kui_Nameplates";

	-- Disable our (old) Kui nameplate module explicitly, we'll also tell
	-- users that they can disable it.

	if GetAddOnEnableState(nil, "totalRP3_KuiNameplates") ~= 0 then
		DisableAddOn("totalRP3_KuiNameplates", true);
		TRP3_API.popup.showAlertPopup(L.KUI_NAMEPLATES_WARN_OUTDATED_MODULE);
	end
end

function TRP3_KuiNamePlates:OnModuleEnable()
	-- Sanity check TRP3_NAMEPLATES_ADDON to ensure that we remain the chosen
	-- decorator addon, since it may get trampled by external code.

	if TRP3_NAMEPLATES_ADDON ~= "Kui_Nameplates" then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	self.unitDisplayInfo = {};
	self.initialized = {};

	self.plugin = KuiNameplates:NewPlugin("TotalRP3", 250);
	self.plugin.Create = function(_, ...) return self:OnNamePlateCreate(...); end;
	self.plugin.Show = function(_, ...) return self:OnNamePlateShow(...); end;
	self.plugin.HealthUpdate = function(_, ...) return self:OnNamePlateHealthUpdate(...); end;
	self.plugin.HealthColourChange = function(_, ...) return self:OnNamePlateHealthColourChange(...); end;
	self.plugin.GlowColourChange = function(_, ...) return self:OnNamePlateGlowColourChange(...); end;
	self.plugin.GainedTarget = function(_, ...) return self:OnNamePlateGainedTarget(...); end;
	self.plugin.LostTarget = function(_, ...) return self:OnNamePlateLostTarget(...); end;
	self.plugin.Combat = function(_, ...) return self:OnNamePlateCombat(...); end;
	self.plugin.Hide = function(_, ...) return self:OnNamePlateHide(...); end;

	self.plugin:RegisterMessage("Create");
	self.plugin:RegisterMessage("Show");
	self.plugin:RegisterMessage("HealthUpdate");
	self.plugin:RegisterMessage("HealthColourChange");
	self.plugin:RegisterMessage("GlowColourChange");
	self.plugin:RegisterMessage("GainedTarget");
	self.plugin:RegisterMessage("LostTarget");
	self.plugin:RegisterMessage("Combat");
	self.plugin:RegisterMessage("Hide");
end

function TRP3_KuiNamePlates:OnNamePlateDataUpdated(_, nameplate, unitToken, displayInfo)
	self:SetUnitDisplayInfo(unitToken, displayInfo);

	if nameplate.kui then
		self:UpdateNamePlate(nameplate.kui);
	end
end

function TRP3_KuiNamePlates:OnNamePlateCreate(nameplate)
	local nameplateKey = nameplate:GetName();

	if self.initialized[nameplateKey] then
		-- For safety, should be impossible.
		return;
	end

	-- Several integrations are applied as posthooks so as to not conflict
	-- too much with Kui's internal state.

	hooksecurefunc(nameplate, "UpdateNameText", function(...) return self:OnNameplateNameTextUpdated(...); end);

	do
		-- Icon widget.
		local iconWidget = nameplate:CreateTexture(nil, "ARTWORK");
		iconWidget:ClearAllPoints();
		iconWidget:SetPoint("RIGHT", nameplate.NameText, "LEFT", -4, 0);
		iconWidget:Hide();

		nameplate.handler:RegisterElement("TRP3_Icon", iconWidget);
	end

	do
		-- Title text widget.
		local titleWidget = nameplate:CreateFontString(nil, "ARTWORK");
		titleWidget:ClearAllPoints();
		titleWidget:SetPoint("TOP", nameplate.NameText, "BOTTOM", 0, -2);
		titleWidget:SetTextColor(1, 1, 1, 0.8);
		titleWidget:SetShadowOffset(1, -1);
		titleWidget:SetShadowColor(0, 0, 0, 1);
		titleWidget:Hide();

		nameplate.handler:RegisterElement("TRP3_Title", titleWidget);
	end

	self.initialized[nameplateKey] = true;
end

function TRP3_KuiNamePlates:OnNamePlateShow(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateHealthUpdate(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateHealthColourChange(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateGlowColourChange(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateGainedTarget(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateLostTarget(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateCombat(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateHide(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNameplateNameTextUpdated(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayText;

	if displayInfo and displayInfo.name then
		displayText = TRP3_API.utils.str.crop(displayInfo.name, TRP3_NamePlatesUtil.MAX_NAME_CHARS);
	end

	if displayText then
		nameplate.NameText:SetText(displayText);

		if nameplate.IN_NAMEONLY then
			-- In name-only mode we need to account for health coloring, which
			-- reads from the current state. We replace it long enough to
			-- update the underlying font string before restoring it.
			--
			-- Note this needs to occur after a SetText call to replace the
			-- name, as health coloring and level information is only placed
			-- onto the name if either are enabled.

			local originalText = nameplate.state.name;
			nameplate.state.name = displayText;
			KuiNameplatesCore:NameOnlyUpdateNameText(nameplate);
			nameplate.state.name = originalText;
		end
	end

	if displayInfo and displayInfo.roleplayStatus then
		TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(nameplate.NameText, displayInfo.roleplayStatus);
	end

	if displayInfo and displayInfo.shouldColorName then
		nameplate.NameText:SetTextColor(displayInfo.color:GetRGB());
	end

	-- Refresh full title/icon customizations as these depend on name-only
	-- mode which might be toggled before this hook is fired.

	self:UpdateNamePlateFullTitle(nameplate);
	self:UpdateNamePlateIcon(nameplate);
end

function TRP3_KuiNamePlates:UpdateNamePlateHealthBar(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);

	if displayInfo and displayInfo.shouldColorHealth then
		nameplate.HealthBar:SetStatusBarColor(displayInfo.color:GetRGB());
	elseif nameplate.state.healthColour and not nameplate.state.health_colour_priority then
		nameplate.HealthBar:SetStatusBarColor(unpack(nameplate.state.healthColour, 1, 3));
	end
end

function TRP3_KuiNamePlates:UpdateNamePlateIcon(nameplate)
	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayIcon = displayInfo and displayInfo.icon or nil;
	local shouldHide = displayInfo and displayInfo.shouldHide or false;
	local unitframe = nameplate.parent.UnitFrame;

	-- Only enable this if we're permitted to customize this nameplate, and
	-- if we've not been requested to hide it.

	if not self:CanCustomizeNamePlate(nameplate) or not ShouldShowName(unitframe) or shouldHide then
		displayIcon = nil;
	end

	if displayIcon then
		nameplate.TRP3_Icon:ClearAllPoints();
		nameplate.TRP3_Icon:SetTexture(TRP3_API.utils.getIconTexture(displayIcon));
		nameplate.TRP3_Icon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize());

		if IsNamePlateInNameOnlyMode(nameplate) then
			nameplate.TRP3_Icon:SetPoint("RIGHT", nameplate.NameText, "LEFT", -4, 0);
		else
			nameplate.TRP3_Icon:SetPoint("RIGHT", nameplate.HealthBar, "LEFT", -4, 0);
		end

		nameplate.TRP3_Icon:Show();
	elseif nameplate.TRP3_Icon then
		nameplate.TRP3_Icon:Hide();
	end
end

function TRP3_KuiNamePlates:UpdateNamePlateFullTitle(nameplate)
	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayText = displayInfo and displayInfo.fullTitle or nil;
	local displayFont = nameplate.GuildText:GetFont();
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Only enable this widget in name-only mode if we're permitted to
	-- customize this nameplate, and if we've not been requested to hide it.

	if not self:CanCustomizeNamePlate(nameplate) or not IsNamePlateInNameOnlyMode(nameplate) or shouldHide then
		displayText = nil;
		displayFont = nil;
	end

	if displayText and displayFont then
		nameplate.TRP3_Title:SetFont(nameplate.GuildText:GetFont());
		nameplate.TRP3_Title:SetTextColor(nameplate.GuildText:GetTextColor());
		nameplate.TRP3_Title:SetText(TRP3_API.utils.str.crop(displayText, TRP3_NamePlatesUtil.MAX_TITLE_CHARS));
		nameplate.TRP3_Title:Show();

		nameplate.GuildText:ClearAllPoints();
		nameplate.GuildText:SetPoint("TOP", nameplate.TRP3_Title, "BOTTOM", 0, -2);
	elseif nameplate.TRP3_Title then
		nameplate.TRP3_Title:Hide();

		nameplate.GuildText:ClearAllPoints();
		nameplate.GuildText:SetPoint("TOP", nameplate.NameText, "BOTTOM", 0, -2);
	end
end

function TRP3_KuiNamePlates:UpdateNamePlateNameText(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	-- Names are managed through a posthook. This will trigger icon and
	-- full title updates.

	nameplate.NameText:SetText(nameplate.state.name or UNKNOWNOBJECT);
	nameplate:UpdateNameText();
end

function TRP3_KuiNamePlates:UpdateNamePlateVisibility(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);

	if displayInfo and displayInfo.shouldHide then
		if nameplate:IsShown() then
			nameplate:Hide();
			KuiNameplatesCore:Hide(nameplate);
		end
	else
		if not nameplate:IsShown() then
			nameplate:Show();
			KuiNameplatesCore:Show(nameplate);
		end
	end
end

function TRP3_KuiNamePlates:UpdateNamePlate(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	-- Some customizations are managed by posthooks on nameplate frames,
	-- including icons and full titles which are updated in response to
	-- the name text being updated.

	self:UpdateNamePlateNameText(nameplate);
	self:UpdateNamePlateHealthBar(nameplate);
	self:UpdateNamePlateVisibility(nameplate);
end

function TRP3_KuiNamePlates:UpdateAllNamePlates()
	for _, nameplate in KuiNameplates:Frames() do
		self:UpdateNamePlate(nameplate);
	end
end

function TRP3_KuiNamePlates:CanCustomizeNamePlate(nameplate)
	local nameplateKey = nameplate:GetName();

	if not self.initialized[nameplateKey] then
		return false;  -- Reject uninitialized nameplates.
	elseif nameplate.state.personal or not nameplate.state.reaction then
		return false;  -- Reject personal and invalid nameplates.
	elseif not nameplate.parent or not nameplate.parent.UnitFrame then
		return false;  -- Nameplate doesn't have a unitframe (retail-specific).
	elseif not nameplate.unit then
		return false;  -- Nameplate doesn't have an associated unit.
	else
		return true;
	end
end

function TRP3_KuiNamePlates:GetUnitDisplayInfo(unitToken)
	return self.unitDisplayInfo[unitToken];
end

function TRP3_KuiNamePlates:SetUnitDisplayInfo(unitToken, displayInfo)
	self.unitDisplayInfo[unitToken] = displayInfo;
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_kui_nameplates",
	name = L.KUI_NAMEPLATES_MODULE_NAME,
	description = L.KUI_NAMEPLATES_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	requiredDeps = { { "trp3_nameplates", 1 } },
	onInit = function() return TRP3_KuiNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_KuiNamePlates:OnModuleEnable(); end,
});

_G.TRP3_KuiNamePlates = TRP3_KuiNamePlates;

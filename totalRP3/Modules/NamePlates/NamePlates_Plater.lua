-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local TRP3_NamePlates = TRP3_NamePlates;
local TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
local L = TRP3_API.loc;

local Plater = _G["Plater"]

local function IsNamePlateInNameOnlyMode(nameplate)
	local unitframe = nameplate.unitFramePlater;
	return nameplate.IN_NAMEONLY and unitframe and ShouldShowName(unitframe);
end

local TRP3_PlaterNamePlates = {};

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if not IsAddOnLoaded("Plater") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		-- Another nameplate decorator module met its own activation criteria.
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	TRP3_PlaterNamePlates.platerVersion = Plater.versionString
	TRP3_PlaterNamePlates.platerConfig = Plater.db.profile.plate_config

	-- Define TRP3_NAMEPLATES_ADDON now to claim decoration rights. This
	-- should be sanity checked on OnModuleEnable to make sure someone else
	-- didn't trample over it.

	TRP3_NAMEPLATES_ADDON = "Plater";
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	-- Sanity check TRP3_NAMEPLATES_ADDON to ensure that we remain the chosen
	-- decorator addon, since it may get trampled by external code.

	if TRP3_NAMEPLATES_ADDON ~= "Plater" then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	self.unitDisplayInfo = {};
	self.initialized = {};
end

function TRP3_PlaterNamePlates:OnNamePlateDataUpdated(_, nameplate, unitToken, displayInfo)
	self:SetUnitDisplayInfo(unitToken, displayInfo);
	if nameplate.Plater then
		self:UpdateNamePlate(nameplate);
	end
end

function TRP3_PlaterNamePlates:OnNamePlateCreate(nameplate)
	local nameplateKey = nameplate.unitFramePlater.namePlateUnitToken;

	if self.initialized[nameplateKey] then
		-- For safety, should be impossible.
		return;
	end

	hooksecurefunc(nameplate.unitFramePlater, "UpdateName", function(...) return self:OnNameplateNameTextUpdated(...); end);
	hooksecurefunc(nameplate.unitFramePlater, "UpdateHealthColor",
		function(...) return self:UpdateNamePlateHealthBar(...); end);

	hooksecurefunc(Plater, "UpdateUnitName",
		function(...) return self:UpdateNamePlateNameText(...); end);
	--do
	--	-- Icon widget.
	--	local iconWidget = nameplate:CreateTexture("TRP3_Icon", "ARTWORK");
	--	iconWidget:ClearAllPoints();
	--	iconWidget:SetPoint("RIGHT", nameplate.CurrentUnitNameString, "LEFT", -4, 0);
	--	iconWidget:Hide()
	--
	--	nameplate.TRP3_Icon = iconWidget;
	--
	--end
	--do
	--	-- Title text widget.
	--	local titleWidget = nameplate:CreateFontString(nil, "ARTWORK");
	--	titleWidget:ClearAllPoints();
	--	titleWidget:SetPoint("TOP", nameplate.NameText, "BOTTOM", 0, -2);
	--	titleWidget:SetTextColor(1, 1, 1, 0.8);
	--	titleWidget:SetShadowOffset(1, -1);
	--	titleWidget:SetShadowColor(0, 0, 0, 1);
	--	titleWidget:Hide()
	--
	--	--nameplate.handler:RegisterElement("TRP3_Title", titleWidget);
	--	nameplate.TRP3_Title = titleWidget;
	--end

	self.initialized[nameplateKey] = true;
end

function TRP3_PlaterNamePlates:OnNamePlateShow(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateHealthUpdate(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateHealthColourChange(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateGlowColourChange(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateGainedTarget(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateLostTarget(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateCombat(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNamePlateHide(nameplate)
	self:UpdateNamePlate(nameplate);
end

function TRP3_PlaterNamePlates:OnNameplateNameTextUpdated(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	if nameplate.actorType ~= "friendlyplayer" then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);
	local displayText;

	if displayInfo and displayInfo.name then
		displayText = TRP3_API.utils.str.crop(displayInfo.name, TRP3_NamePlatesUtil.MAX_NAME_CHARS) or
			nameplate.namePlateUnitName;
	end

	if displayText then
		nameplate.CurrentUnitNameString:SetText(displayText);

		--if nameplate.IN_NAMEONLY then
		--	-- In name-only mode we need to account for health coloring, which
		--	-- reads from the current state. We replace it long enough to
		--	-- update the underlying font string before restoring it.
		--	--
		--	-- Note this needs to occur after a SetText call to replace the
		--	-- name, as health coloring and level information is only placed
		--	-- onto the name if either are enabled.
		--
		--	local originalText = nameplate.state.name;
		--	nameplate.state.name = displayText;
		--	Plater.UpdateUnitName(nameplate.plateFrame);
		--	nameplate.state.name = originalText;
		--end
	end

	if displayInfo and displayInfo.roleplayStatus then
		TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(nameplate.CurrentUnitNameString, displayInfo.roleplayStatus);
	end

	if displayInfo and displayInfo.shouldColorName then
		nameplate.CurrentUnitNameString:SetTextColor(displayInfo.color:GetRGB());
	end

	-- Refresh full title/icon customizations as these depend on name-only
	-- mode which might be toggled before this hook is fired.

	--self:UpdateNamePlateFullTitle(nameplate);
	--self:UpdateNamePlateIcon(nameplate);
end

function TRP3_PlaterNamePlates:UpdateNamePlateHealthBar(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);

	if displayInfo and displayInfo.shouldColorHealth then
		nameplate.unitFramePlater.healthBar:SetColor(displayInfo.color:GetRGB());
		--elseif nameplate.state.healthColour and not nameplate.state.health_colour_priority then
		--	nameplate.unitFramePlater.healthBar:SetColor(unpack(nameplate.state.healthColour, 1, 3));
	end
end

function TRP3_PlaterNamePlates:UpdateNamePlateIcon(nameplate)
	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);
	local displayIcon = displayInfo and displayInfo.icon or nil;
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Only enable this if we're permitted to customize this nameplate, and
	-- if we've not been requested to hide it.

	if not self:CanCustomizeNamePlate(nameplate) or shouldHide then
		displayIcon = nil;
	end

	if displayIcon then
		nameplate.TRP3_Icon = {};
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

function TRP3_PlaterNamePlates:UpdateNamePlateFullTitle(nameplate)
	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);
	local displayText = displayInfo and displayInfo.fullTitle or nil;
	local displayFont = nameplate.ActorNameSpecial
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Only enable this widget in name-only mode if we're permitted to
	-- customize this nameplate, and if we've not been requested to hide it.

	if not self:CanCustomizeNamePlate(nameplate) or not IsNamePlateInNameOnlyMode(nameplate) or shouldHide then
		displayText = nil;
		displayFont = nil;
	end

	if displayText and displayFont then
		nameplate.TRP3_Title:SetFont(displayFont);
		nameplate.TRP3_Title:SetTextColor(nameplate.playerGuildName:GetTextColor());
		nameplate.TRP3_Title:SetText(TRP3_API.utils.str.crop(displayText, TRP3_NamePlatesUtil.MAX_TITLE_CHARS));
		nameplate.TRP3_Title:Show();

		nameplate.playerGuildName:ClearAllPoints();
		nameplate.playerGuildName:SetPoint("TOP", nameplate.TRP3_Title, "BOTTOM", 0, -2);
	elseif nameplate.TRP3_Title then
		nameplate.TRP3_Title:Hide();

		nameplate.playerGuildName:ClearAllPoints();
		nameplate.playerGuildName:SetPoint("TOP", nameplate.NameText, "BOTTOM", 0, -2);
	end
end

function TRP3_PlaterNamePlates:UpdateNamePlateNameText(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken)

	if not displayInfo then
		return;
	end

	if nameplate.actorType ~= "friendlyplayer" then
		return;
	end

	nameplate.CurrentUnitNameString:SetText(displayInfo.name or nameplate.namePlateUnitName);
	self:OnNameplateNameTextUpdated(nameplate)
end

function TRP3_PlaterNamePlates:UpdateNamePlateVisibility(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);

	if displayInfo and displayInfo.shouldHide then
		if nameplate:IsShown() then
			nameplate:Hide();
		end
	else
		if not nameplate:IsShown() then
			nameplate:Show();
		end
	end
end

function TRP3_PlaterNamePlates:UpdateNamePlate(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	if nameplate.actorType ~= "friendlyplayer" then
		return;
	end

	-- Some customizations are managed by posthooks on nameplate frames,
	-- including icons and full titles which are updated in response to
	-- the name text being updated.

	self:UpdateNamePlateNameText(nameplate);
	self:UpdateNamePlateHealthBar(nameplate);
	self:UpdateNamePlateVisibility(nameplate);
end

function TRP3_PlaterNamePlates:UpdateAllNamePlates()
	for nameplate in C_NamePlate.GetNamePlates() do
		self:UpdateNamePlate(nameplate);
	end
end

function TRP3_PlaterNamePlates:CanCustomizeNamePlate(nameplate)
	if not nameplate.Plater then
		return false; -- Reject non-plater nameplates
	elseif not nameplate.namePlateUnitReaction then
		return false; -- Reject personal and invalid nameplates.
	elseif not nameplate.unitFramePlater then
		return false; -- Nameplate doesn't have a unitframe (retail-specific).
	elseif not nameplate.unitFramePlater.IsUIParent then
		return false;
	elseif not nameplate.namePlateUnitGUID then
		return false; -- Nameplate doesn't have an associated unit.
	else
		self:OnNamePlateCreate(nameplate)
		return true;
	end
end

function TRP3_PlaterNamePlates:GetUnitDisplayInfo(unitToken)
	return self.unitDisplayInfo[unitToken];
end

function TRP3_PlaterNamePlates:SetUnitDisplayInfo(unitToken, displayInfo)
	self.unitDisplayInfo[unitToken] = displayInfo;
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_plater_nameplates",
	name = L.PLATER_NAMEPLATES_MODULE_NAME,
	description = L.PLATER_NAMEPLATES_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	requiredDeps = { { "trp3_nameplates", 1 } },
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
});

_G.TRP3_PlaterNamePlates = TRP3_PlaterNamePlates;

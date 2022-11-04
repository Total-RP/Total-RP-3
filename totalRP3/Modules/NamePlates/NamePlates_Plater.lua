-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local TRP3_NamePlates = TRP3_NamePlates;
local TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
local L = TRP3_API.loc;

local Plater = _G["Plater"]

local TRP3_PlaterNamePlates = {};

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if not IsAddOnLoaded("Plater") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		-- Another nameplate decorator module met its own activation criteria.
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	TRP3_PlaterNamePlates.platerVersion = Plater.versionString
	TRP3_PlaterNamePlates.platerProfile = Plater.db.profile

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

	TRP3_API.Events.registerCallback("CONFIGURATION_CHANGED", function(...) return self:OnConfigurationChanged(...); end);

	self.unitDisplayInfo = {};
	self.initialized = {};
end

function TRP3_PlaterNamePlates:OnConfigurationChanged(_)
	self:UpdateAllNamePlates()
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

	do
		-- Icon widget.
		if nameplate.actorType == "friendlyplayer" then
			local iconWidget = nameplate:CreateTexture(nil, "ARTWORK");
			iconWidget:ClearAllPoints();
			iconWidget:SetPoint("RIGHT", nameplate.CurrentUnitNameString, "LEFT", -4, 0);
			iconWidget:Hide()

			nameplate.unitFramePlater.TRP3PlaterIcon = iconWidget;
		end
	end

	self.initialized[nameplateKey] = true;
end

function TRP3_PlaterNamePlates:AppendGuildNameToNameString(name, nameplate)
	if nameplate.playerGuildName then
		if nameplate.PlateConfig.show_guild_name then
			return name .. "\n" .. "<" .. nameplate.playerGuildName .. ">"
		else
			return name
		end
	else
		return name
	end
end

function TRP3_PlaterNamePlates:AppendFullTitleToNameString(name, fullTitle)
	return name .. "\n" .. "" .. fullTitle .. ""
end

function TRP3_PlaterNamePlates:PrependIconToNameString(icon, nameplate)
	-- Just in case we ever want to add the icon to the beginning of the name string for whatever reason?

	local nameString = nameplate.CurrentUnitNameString

	nameString:SetFormattedText("%s %s", icon, nameString:GetText());
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
	elseif displayInfo and not displayInfo.name then
		displayText = nameplate.namePlateUnitName;
	end

	if displayText then
		nameplate.CurrentUnitNameString:SetText(self:AppendGuildNameToNameString(displayText, nameplate));
	end

	if displayInfo and displayInfo.roleplayStatus then
		TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(nameplate.CurrentUnitNameString, displayInfo.roleplayStatus);
	end

	if displayInfo and displayInfo.shouldColorName then
		nameplate.CurrentUnitNameString:SetTextColor(displayInfo.color:GetRGB());
	end

	if displayInfo and not displayInfo.shouldColorName then
		local _, classFilename, _ = UnitClass(nameplate.namePlateUnitToken)
		local color = C_ClassColor.GetClassColor(classFilename)

		nameplate.CurrentUnitNameString:SetTextColor(color:GetRGB());
	end

	self:UpdateNamePlateFullTitle(nameplate);
	self:UpdateNamePlateIcon(nameplate);
end

function TRP3_PlaterNamePlates:UpdateNamePlateHealthBar(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);

	if displayInfo and displayInfo.shouldColorHealth then
		nameplate.unitFramePlater.healthBar:SetColor(displayInfo.color:GetRGB());
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

	if displayIcon and nameplate.unitFramePlater.TRP3PlaterIcon then
		nameplate.unitFramePlater.TRP3PlaterIcon:ClearAllPoints();
		nameplate.unitFramePlater.TRP3PlaterIcon:SetTexture(TRP3_API.utils.getIconTexture(displayInfo.icon));
		nameplate.unitFramePlater.TRP3PlaterIcon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize());

		nameplate.unitFramePlater.TRP3PlaterIcon:SetPoint("RIGHT", nameplate.CurrentUnitNameString, "LEFT", -4, 0);

		nameplate.unitFramePlater.TRP3PlaterIcon:Show();
	elseif nameplate.unitFramePlater.TRP3PlaterIcon then
		nameplate.unitFramePlater.TRP3PlaterIcon:Hide();
	end
end

function TRP3_PlaterNamePlates:UpdateNamePlateFullTitle(nameplate)
	local displayInfo = self:GetUnitDisplayInfo(nameplate.unitFramePlater.namePlateUnitToken);
	local displayText = displayInfo and displayInfo.fullTitle or nil;
	local displayFont = nameplate.CurrentUnitNameString:GetFontObject()
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Only enable this widget in name-only mode if we're permitted to
	-- customize this nameplate, and if we've not been requested to hide it.

	if not self:CanCustomizeNamePlate(nameplate) or shouldHide then
		displayText = nil;
		displayFont = nil;
	end

	if displayText and displayFont then
		nameplate.CurrentUnitNameString:SetText(self:AppendFullTitleToNameString(nameplate.CurrentUnitNameString:GetText(),
			TRP3_API.utils.str.crop(displayInfo.fullTitle, TRP3_NamePlatesUtil.MAX_TITLE_CHARS)))
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
		nameplate:Hide();
	elseif not nameplate:IsShown() then
		-- we need to (for now) check if the frame is shown before showing it to prevent an ADDON_ACTION_BLOCKED error
		nameplate:Show();
	end
end

function TRP3_PlaterNamePlates:UpdateNamePlate(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	if nameplate.actorType ~= "friendlyplayer" then
		return;
	end

	-- Some customizations are updated within other functions on nameplate frames,
	-- including icons and full titles which are updated in response to
	-- the name text being updated.

	self:UpdateNamePlateNameText(nameplate);
	self:UpdateNamePlateHealthBar(nameplate);
	self:UpdateNamePlateVisibility(nameplate);
end

function TRP3_PlaterNamePlates:UpdateAllNamePlates()
	for _, nameplate in ipairs(C_NamePlate:GetNamePlates()) do
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

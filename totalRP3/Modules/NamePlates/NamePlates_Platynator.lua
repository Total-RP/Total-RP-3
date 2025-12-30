-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0


-- plusmouse has kindly provided an API to modify unit names. See https://github.com/TheMouseNest/Platynator/commit/2446f3461c598b93d7e63f4ac175a5ed0e08d119
-- We do not have access to the FontString itself. Long names may be truncated, Platynator users will have to adjust the settings themselves.
-- Custom name colors and icons need to be wrapped together in escape sequences.
-- Custom health colors will not be supported.


local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");
local L = TRP3_API.loc;



TRP3_Platynator = {};

function TRP3_Platynator:OnModuleInitialize()
	if not Platynator or not Platynator.API then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	local requirements = {
		Platynator.API.SetUnitTextOverride,
	};

	for _, func in ipairs(requirements) do
		if func == nil then
			-- Ideally we'd use a different string here ("disabled because the addon is too old").
			return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
		end
	end
end

function TRP3_Platynator:OnModuleEnable()
	self.unitDisplayInfo = {};
	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");
	self:UpdateAllNamePlates();
end

function TRP3_Platynator:OnNamePlateDataUpdated(_, nameplate, unitToken, displayInfo)
	self:SetUnitDisplayInfo(unitToken, displayInfo);
	self:UpdateNamePlate(nameplate, unitToken);
end

function TRP3_Platynator:UpdateNamePlate(nameplate, unitToken)
	if nameplate:IsForbidden() or not nameplate:IsShown() then
		return;
	end

	if not unitToken then
		unitToken = nameplate.namePlateUnitToken;
	end

	if not unitToken then return; end;

	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local shouldShow = nameplate.UnitFrame and ShouldShowName(nameplate.UnitFrame);
	if displayInfo and displayInfo.shouldHide then
		shouldShow = false;
	end

	if shouldShow then
		local overrideText;
		local overrideSubtext = nil;

		if displayInfo.name then
			overrideText = displayInfo.name;
		end

		if not overrideText then
			local originalName, realm = UnitName(unitToken);

			if canaccessvalue(originalName) then
				overrideText = originalName;
			end

			if realm and canaccessvalue(realm) then
				overrideText = overrideText.."-"..realm;
			end
		end

		if overrideText then
			if displayInfo.shouldColorName and displayInfo.color then
				overrideText = displayInfo.color:WrapTextInColorCode(overrideText);
			end

			if displayInfo.roleplayStatus then
				overrideText = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(overrideText, displayInfo.roleplayStatus);
			end

			if displayInfo.icon then
				local texture = TRP3_API.utils.getIconTexture(displayInfo.icon);
				local iconSize = TRP3_NamePlatesUtil.GetPreferredIconSize();
				local offsetX = 0;	--There is already a space between icon and text
				local offsetY = 0;
				overrideText = string.format("|T%s:%d:%d:%d:%d|t %s", texture, iconSize, iconSize, offsetX, offsetY, overrideText);
			end

			DisplayManager:SetUnitText(unitToken, overrideText, overrideSubtext);
		end
	end
end

function TRP3_Platynator:UpdateAllNamePlates()
	for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
		self:UpdateNamePlate(nameplate);
	end
end

function TRP3_Platynator:GetUnitDisplayInfo(unitToken)
	return self.unitDisplayInfo[unitToken];
end

function TRP3_Platynator:SetUnitDisplayInfo(unitToken, displayInfo)
	self.unitDisplayInfo[unitToken] = displayInfo;
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_platynator",
	name = L.PLATYNATOR_NAMEPLATES_MODULE_NAME,
	description = L.PLATYNATOR_NAMEPLATES_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	requiredDeps = { {"Platynator", "external"} },
	onInit = function() return TRP3_Platynator:OnModuleInitialize(); end,
	onStart = function() return TRP3_Platynator:OnModuleEnable(); end,
});

_G.TRP3_Platynator = TRP3_Platynator;	--Do not change the global name because Platynator detects this to disable their MSP implementation
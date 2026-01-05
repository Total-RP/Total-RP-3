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

	-- Alert the player that some unit names may be hidden due to TRP settings.
	-- Not using "CONFIGURATION_CHANGED" because the player likely doesn't pay attention to chat when MainFrame is visible
	self.visiblitySettings = {"CustomizeNPCUnits", "CustomizeOOCUnits", "CustomizeNonRoleplayUnits"};
	if not self:CheckAnyNameplateHidden() then
		TRP3_Addon.RegisterCallback(self, "MAIN_FRAME_CLOSED", "CheckAnyNameplateHidden");
	end
end

function TRP3_Platynator:CheckAnyNameplateHidden()
	local anyHidden;
	for _, key in ipairs(self.visiblitySettings) do
		if TRP3_NamePlatesSettings[key] == TRP3_NamePlateUnitCustomizationState.Hide then
			anyHidden = true;
			break;
		end
	end

	if anyHidden then
		TRP3_Addon.UnregisterCallback(self, "MAIN_FRAME_CLOSED", "CheckAnyNameplateHidden");

		-- Create a hyperlink so that the player can click it to open to nameplate settings
		local arg1 = "settings";
		local arg2 = "nameplates";
		EventRegistry:RegisterCallback("SetItemRef", function(_, link, text, button, chatFrame)
			if link then
				local _arg1, _arg2 = string.match(link, "trp3:([^:]+):([^|]+)");
				if arg1 == _arg1 and arg2 == _arg2 then
					TRP3_API.navigation.openMainFrame();
					TRP3_API.navigation.menu.selectMenu("main_91_config_main_config_nameplates");
				end
			end
		end);

		local link = string.format("|Haddon:trp3:%s:%s", arg1, arg2);
		link = string.format("|cff%s%s|h[%s]|h|r", "ffd100", link, L.PLATYNATOR_NAMEPLATES_UNIT_HIDDEN_ALERT_REASON);

		-- Display alert message
		-- Run next frame so it shows after the welcome message
		C_Timer.After(0, function()
			local msg = string.format(L.PLATYNATOR_NAMEPLATES_UNIT_HIDDEN_ALERT, link);
			TRP3_API.utils.message.displayMessage(msg);
		end);

		return true
	end
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
		Platynator.API.SetUnitTextOverride(unitToken, "", "");
		return;
	end

	if shouldShow and displayInfo then
		local overrideText = nil;
		local overrideSubtext = nil;

		if displayInfo.name then
			overrideText = displayInfo.name;
		end

		if displayInfo.guildName then
			overrideSubtext = displayInfo.guildName;
		end

		if overrideText then
			if displayInfo.shouldColorName and displayInfo.color then
				overrideText = displayInfo.color:WrapTextInColorCode(overrideText);
			end

			if displayInfo.roleplayStatus then
				overrideText = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(overrideText, displayInfo.roleplayStatus);
			end

			if displayInfo.icon then
				local size = TRP3_NamePlatesUtil.GetPreferredIconSize();
				local offsetX = 0;
				local offsetY = 0;
				local icon = LRPM12:GenerateIconMarkup(displayInfo.icon, size, size, offsetX, offsetY)
				overrideText = string.join(" ", icon, overrideText);
			end
		end

		Platynator.API.SetUnitTextOverride(unitToken, overrideText, overrideSubtext);
	else
		Platynator.API.SetUnitTextOverride(unitToken, nil, nil);
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
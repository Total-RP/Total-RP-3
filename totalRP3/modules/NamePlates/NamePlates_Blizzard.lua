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

local function GetUnitFrameForNamePlate(nameplate)
	return nameplate.UnitFrame;
end

local function GetNamePlateForUnitFrame(unitframe)
	if unitframe:IsForbidden() then
		return nil;
	end

	local parent = unitframe:GetParent();
	local nameplate = C_NamePlate.GetNamePlateForUnit(unitframe.displayedUnit or "none");

	if not nameplate or nameplate ~= parent then
		return nil;
	end

	return nameplate;
end

local TRP3_BlizzardNamePlates = {};

function TRP3_BlizzardNamePlates:OnModuleInitialize()
	if not IsAddOnLoaded("Blizzard_NamePlates") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end
end

function TRP3_BlizzardNamePlates:OnModuleEnable()
	-- External nameplate addons can define the below global before the
	-- PLAYER_LOGIN event fires to disable this integration.

	if TRP3_DISABLE_BLIZZARD_NAMEPLATES then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	self.unitDisplayInfo = {};

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	hooksecurefunc("CompactUnitFrame_UpdateName", function(...) return self:OnUnitFrameNameUpdated(...); end);
	hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(...) return self:OnUnitFrameHealthColorUpdated(...); end);

	TRP3_API.Ellyb.GameEvents.registerCallback("CVAR_UPDATE", function(...) return self:OnCVarUpdate(...); end);

	self:UpdateAllNamePlates();
end

function TRP3_BlizzardNamePlates:OnCVarUpdate(name)
	if string.find(string.lower(name), "nameplate", 1, true) then
		self:UpdateAllNamePlates();
	end
end

function TRP3_BlizzardNamePlates:OnNamePlateDataUpdated(_, nameplate, unitToken, displayInfo)
	self:SetUnitDisplayInfo(unitToken, displayInfo);
	self:UpdateNamePlate(nameplate);
end

function TRP3_BlizzardNamePlates:OnUnitFrameNameUpdated(unitframe)
	-- This is called as a post-hook on CompactUnitFrame_UpdateName.
	local nameplate = GetNamePlateForUnitFrame(unitframe);

	if not nameplate or not unitframe:IsShown() then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(unitframe.displayedUnit);
	local fontstring = unitframe.name;

	if not displayInfo then
		-- No reset logic required as this is a post-hook.
		return;
	end

	do
		local shouldCropName = false;

		-- Anything that needs to potentially be cropped should be inserted
		-- first; the name is cropped as a single unit to ensure that we
		-- don't need to worry about cropping things like titles individually.

		if displayInfo.nameText then
			fontstring:SetText(displayInfo.nameText);
			shouldCropName = true;
		end

		if displayInfo.prefixTitle then
			TRP3_NamePlatesUtil.PrependTextToFontString(fontstring, displayInfo.prefixTitle);
			shouldCropName = true;
		end

		if shouldCropName then
			TRP3_NamePlatesUtil.CropFontString(fontstring, TRP3_NamePlatesUtil.MAX_NAME_CHARS);
		end

		-- No cropping occurs after this point.

		TRP3_NamePlatesUtil.PrependRoleplayStatusToFontString(fontstring, displayInfo.roleplayStatus);
		TRP3_NamePlatesUtil.PrependIconToFontString(fontstring, displayInfo.icon);
	end

	if displayInfo.nameColor then
		local color = displayInfo.nameColor;

		if UnitIsUnit(nameplate.namePlateUnitToken, "mouseover") then
			local r = Saturate(color.r * 1.25);
			local g = Saturate(color.g * 1.25);
			local b = Saturate(color.b * 1.25);

			fontstring:SetVertexColor(r, g, b);
		else
			fontstring:SetVertexColor(color:GetRGB());
		end
	end
end

function TRP3_BlizzardNamePlates:OnUnitFrameHealthColorUpdated(unitframe)
	-- This is called as a post-hook on CompactUnitFrame_UpdateHealthColor.
	local nameplate = GetNamePlateForUnitFrame(unitframe);

	if not nameplate or not unitframe:IsShown() then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(unitframe.displayedUnit);
	local healthbar = unitframe.healthBar;

	if displayInfo and displayInfo.healthColor then
		healthbar:SetStatusBarColor(displayInfo.healthColor:GetRGB());
	else
		-- Even though this is a post-hook we need reset logic here as Blizzard
		-- doesn't change the color of the statusbar unless the fields on it
		-- are modified.

		healthbar:SetStatusBarColor(healthbar.r, healthbar.g, healthbar.b);
	end
end

function TRP3_BlizzardNamePlates:GetUnitDisplayInfo(unitToken)
	return self.unitDisplayInfo[unitToken];
end

function TRP3_BlizzardNamePlates:SetUnitDisplayInfo(unitToken, displayInfo)
	self.unitDisplayInfo[unitToken] = displayInfo;
end

function TRP3_BlizzardNamePlates:UpdateNamePlateVisibility(nameplate)
	local shouldShow = TRP3_NamePlatesUtil.ShouldShowUnitNamePlate(nameplate.namePlateUnitToken);

	local function UpdateChildVisibility(object, ...)
		if not object then
			return;
		end

		object:SetShown(shouldShow);
		return UpdateChildVisibility(...);
	end

	UpdateChildVisibility(nameplate:GetChildren());
	UpdateChildVisibility(nameplate:GetRegions());
end

function TRP3_BlizzardNamePlates:UpdateNamePlate(nameplate)
	if nameplate:IsForbidden() or not nameplate:IsShown() then
		return;
	end

	-- The name and health bar are widgets handled by the CompactUnitFrame,
	-- which we hook to apply our modifications.
	--
	-- These should only be updated if a unit is assigned to them, since
	-- the CUF framework will error out otherwise.

	local unitframe = GetUnitFrameForNamePlate(nameplate);

	if unitframe and unitframe.displayedUnit then
		CompactUnitFrame_UpdateName(unitframe);
		CompactUnitFrame_UpdateHealthColor(unitframe);
	end

	self:UpdateNamePlateVisibility(nameplate);
end

function TRP3_BlizzardNamePlates:UpdateAllNamePlates()
	for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
		self:UpdateNamePlate(nameplate);
	end
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
	id = "trp3_blizzard_nameplates",
	name = L.BLIZZARD_NAMEPLATES_MODULE_NAME,
	description = L.BLIZZARD_NAMEPLATES_MODULE_DESCRIPTION,
	version = 1,
	minVersion = 92,
	requiredDeps = { { "trp3_nameplates", 1 } },
	onInit = function() return TRP3_BlizzardNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_BlizzardNamePlates:OnModuleEnable(); end,
});

_G.TRP3_BlizzardNamePlates = TRP3_BlizzardNamePlates;

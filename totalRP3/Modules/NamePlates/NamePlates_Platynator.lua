-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local TRP3_NamePlates = TRP3_NamePlates;
local TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
local L = TRP3_API.loc;


local ShouldShowName = ShouldShowName;
local UnitIsUnit = UnitIsUnit;
local UnitName = UnitName;
local Saturate = Saturate;
local canaccessvalue = canaccessvalue or function(_) return true; end;


-- Platynator creates a "Display" as the container for their widgets.
-- Display is a child of UIParent, not nameplate

local DisplayManager = {};
do
	DisplayManager.objects = {};

	function DisplayManager:AddObject(platyDisplay)
		self.objects[platyDisplay] = true;
	end

	function DisplayManager:CleanseObject(platyDisplay)
		if self.objects[platyDisplay] then
			self.objects[platyDisplay] = false;
			if platyDisplay.TRP3_Widgets then
				for _, widget in ipairs(platyDisplay.TRP3_Widgets) do
					widget:Hide();
					widget:ClearAllPoints();
				end
			end
		end
	end

	function DisplayManager:CleanseAllObjects()
		for platyDisplay, state in pairs(self.objects) do
			self:CleanseObject(platyDisplay);
		end
	end

	function DisplayManager:GetDisplayByUnit(unitToken)
		local platyDisplay = unitToken and canaccessvalue(unitToken) and self.displayGetterFunc(unitToken);
		if platyDisplay then
			self:AddObject(platyDisplay);
			return platyDisplay;
		end
	end

	function DisplayManager:SetCreatureName(platyDisplay, creatureName, r, g, b)
		if platyDisplay.widgets then
			for _, widget in ipairs(platyDisplay.widgets) do
				if widget.kind == "texts" and widget.details then
					if widget.details.kind == "creatureName" and creatureName then
						widget.text:SetText(creatureName);
						if r then
							widget.text:SetTextColor(r, g, b);
						end
					end
				end
			end
		end
	end

	function DisplayManager:SetGuildName(platyDisplay, guildName, r, g, b)
		if platyDisplay.widgets then
			for _, widget in ipairs(platyDisplay.widgets) do
				if widget.kind == "texts" and widget.details then
					if widget.details.kind == "guildName" and guildName then
						widget.text:SetText(guildName);
						if r then
							widget.text:SetTextColor(r, g, b);
						end
					end
				end
			end
		end
	end

	function DisplayManager:InitializeDependency()
		if not C_AddOns.IsAddOnLoaded("Platynator") then
			return false;
		end

		local requiredAPIs = {
			displayGetterFunc = "Platynator_GetDisplayByUnit",	--TEMP, needs further discussion with plusmouse
		};

		local function GetGlobalObject(objNameKey)
			--Get an object via string "Name.Key1.Key2..."
			local obj = _G;
			for k in string.gmatch(objNameKey, "[_%w]+") do
				obj = obj[k];
				if not obj then
					return
				end
			end
			return obj
		end

		for k, objNameKey in pairs(requiredAPIs) do
			local getterFunc = GetGlobalObject(objNameKey);
			if getterFunc then
				self[k] = getterFunc;
			else
				return false;
			end
		end

		return true
	end
end

local TRP3_Platynator = {};

function TRP3_Platynator:OnModuleInitialize()
	if not DisplayManager:InitializeDependency() then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
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

function TRP3_Platynator:UpdateNamePlateName(unitToken, platyDisplay)
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	local overrideText, r, g, b;

	if displayInfo then
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
			if displayInfo.roleplayStatus then
				overrideText = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(overrideText, displayInfo.roleplayStatus);
			end

			if displayInfo.shouldColorName then
				local color = displayInfo.color;
				r, g, b = color.r, color.g, color.b;

				if UnitIsUnit(unitToken, "mouseover") then
					r = Saturate(color.r * 1.25);
					g = Saturate(color.g * 1.25);
					b = Saturate(color.b * 1.25);
				end
			end

			DisplayManager:SetCreatureName(platyDisplay, overrideText, r, g, b)
		end
	end
end

function TRP3_Platynator:UpdateNamePlateHealthBar(unitToken, platyDisplay)
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local overrideColor;
	if displayInfo and displayInfo.shouldColorHealth then
		overrideColor = TRP3_API.CreateColor(displayInfo.color:GetRGB());
	end
end

function TRP3_Platynator:UpdateNamePlateIcon(unitToken, platyDisplay)
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local displayIcon = displayInfo and displayInfo.icon or nil;

	if displayIcon then
		--nameplate.TRP3_Icon:SetTexture(TRP3_API.utils.getIconTexture(displayIcon));
		--nameplate.TRP3_Icon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize());
		--nameplate.TRP3_Icon:Show();
	else
		--nameplate.TRP3_Icon:Hide();
	end
end

function TRP3_Platynator:UpdateNamePlateFullTitle(unitToken, platyDisplay)
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local displayText = displayInfo and displayInfo.fullTitle or nil;
end

function TRP3_Platynator:UpdateNamePlate(nameplate, unitToken)
	if nameplate:IsForbidden() or not nameplate:IsShown() then
		return;
	end

	if not unitToken then
		unitToken = nameplate.namePlateUnitToken;
	end

	local platyDisplay = DisplayManager:GetDisplayByUnit(unitToken);

	if platyDisplay then
		DisplayManager:CleanseObject(platyDisplay);

		local displayInfo = self:GetUnitDisplayInfo(unitToken);
		local shouldShow = ShouldShowName(nameplate.UnitFrame);
		if displayInfo and displayInfo.shouldHide then
			shouldShow = false;
		end

		if shouldShow then
			self:UpdateNamePlateName(unitToken, platyDisplay);
			self:UpdateNamePlateHealthBar(nameplate);
			self:UpdateNamePlateIcon(nameplate);
			self:UpdateNamePlateFullTitle(nameplate);
		end
	end
end

function TRP3_Platynator:UpdateAllNamePlates()
	DisplayManager:CleanseAllObjects();

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

_G.TRP3_Platynator = TRP3_Platynator;
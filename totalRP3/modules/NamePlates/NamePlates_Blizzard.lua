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

local function CreateOrUpdateColor(color, r, g, b, a)
	if not color then
		return CreateColor(r, g, b, a);
	else
		color:SetRGBA(r, g, b, a);
		return color;
	end
end

local function CallUnhookedMethod(widget, methodName, ...)
	getmetatable(widget).__index[methodName](widget, ...);
end

local function UpdateWidgetVisibility(widget)
	local shouldShow = widget.TRP3_originalShown;

	if widget.TRP3_overrideShown == false then
		shouldShow = false;
	end

	CallUnhookedMethod(widget, "SetShown", shouldShow);
end

local function UpdateFontStringWidgetText(widget)
	local desiredText = widget.TRP3_overrideText or widget.TRP3_originalText;
	CallUnhookedMethod(widget, "SetText", desiredText);
end

local function UpdateFontStringWidgetColor(widget)
	local desiredColor = widget.TRP3_overrideColor or widget.TRP3_originalColor;
	CallUnhookedMethod(widget, "SetVertexColor", desiredColor:GetRGBA());
end

local function UpdateStatusBarWidgetColor(widget)
	local desiredColor = widget.TRP3_overrideColor or widget.TRP3_originalColor;
	CallUnhookedMethod(widget, "SetStatusBarColor", desiredColor:GetRGBA());
end

local function ProcessWidgetVisibilityChanged(widget)
	widget.TRP3_originalShown = widget:IsShown();
	UpdateWidgetVisibility(widget);
end

local function ProcessFontStringWidgetTextChanged(widget)
	widget.TRP3_originalText = widget:GetText();
	UpdateFontStringWidgetText(widget);
end

local function ProcessFontStringWidgetColorChanged(widget)
	widget.TRP3_originalColor = CreateOrUpdateColor(widget.TRP3_originalColor, widget:GetTextColor());
	UpdateFontStringWidgetColor(widget);
end

local function ProcessStatusBarWidgetColorChanged(widget)
	widget.TRP3_originalColor = CreateOrUpdateColor(widget.TRP3_originalColor, widget:GetStatusBarColor());
	UpdateStatusBarWidgetColor(widget);
end

local function SetWidgetOverrideShownState(widget, show)
	widget.TRP3_overrideShown = show;
	UpdateWidgetVisibility(widget);
end

local function SetFontStringWidgetOverrideText(widget, text)
	widget.TRP3_overrideText = text;
	UpdateFontStringWidgetText(widget);
end

local function SetFontStringWidgetOverrideColor(widget, color)
	widget.TRP3_overrideColor = color;
	UpdateFontStringWidgetColor(widget);
end

local function SetStatusBarWidgetOverrideColor(widget, color)
	widget.TRP3_overrideColor = color;
	UpdateStatusBarWidgetColor(widget);
end

local function TryCallWidgetFunction(func, widget, ...)
	if widget then
		return func(widget, ...);
	end
end

local TRP3_BlizzardNamePlates = {};

function TRP3_BlizzardNamePlates:OnModuleInitialize()
	if not IsAddOnLoaded("Blizzard_NamePlates") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	-- Quick hack to make these nameplates "cowardly"; if any of the below
	-- addons is enabled on this character we won't enable Blizzard
	-- customizations. We don't (yet) support these nameplate addons, but
	-- we don't want to needlessly do work if they're enabled.

	local addons = {
		"Plater",
		"TidyPlates",
	};

	for _, addon in ipairs(addons) do
		if GetAddOnEnableState(nil, addon) == 2 then
			return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
		end
	end

	-- ElvUI nameplates are an optional module within ElvUI and need special
	-- checks.

	if ElvUI then
		local E = ElvUI[1];
		if E and E.NamePlates and E.NamePlates.Initialized then
			return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
		end
	end
end

function TRP3_BlizzardNamePlates:OnModuleEnable()
	-- External nameplate addons can define the below global before the
	-- PLAYER_LOGIN event fires to disable this integration.

	if TRP3_DISABLE_BLIZZARD_NAMEPLATES then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	self.unitDisplayInfo = {};
	self.initializedNameplates = {};

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	hooksecurefunc("CompactUnitFrame_SetUpFrame", function(...) return self:OnUnitFrameSetUp(...); end)

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

function TRP3_BlizzardNamePlates:OnUnitFrameSetUp(unitframe)
	-- This is called as a post-hook on CompactUnitFrame_SetUpFrame. This
	-- occurs before a unit is assigned to the plate, so needs custom logic
	-- to verify that it is indeed a child of a nameplate.

	if unitframe:IsForbidden() then
		return;
	end

	local nameplate = unitframe:GetParent();
	local frameName = nameplate:GetName();

	if self.initializedNameplates[frameName] or not string.find(frameName, "^NamePlate%d+$") then
		return;
	end

	-- Initialize visibility hooks.

	local function InitWidgetVisibilityHooks(widget)
		if not widget then
			return;
		end

		-- Our visibility hack is implemented by way of posthooks on the
		-- Show/Hide/SetShown methods. When these are called we store the
		-- requested visibility state and then override it only if we've set
		-- a "forceHide" flag on the widget.

		hooksecurefunc(widget, "Show", ProcessWidgetVisibilityChanged);
		hooksecurefunc(widget, "Hide", ProcessWidgetVisibilityChanged);
		hooksecurefunc(widget, "SetShown", ProcessWidgetVisibilityChanged);

		ProcessWidgetVisibilityChanged(widget);
	end

	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.aggroHighlight);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.BuffFrame);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.castBar);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.ClassificationFrame);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.healthBar);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.LevelFrame);  -- Classic-only.
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.name);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.RaidTargetFrame);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.selectionHighlight);
	TryCallWidgetFunction(InitWidgetVisibilityHooks, unitframe.WidgetContainer);

	-- Initialize name text/color hooks.

	hooksecurefunc(unitframe.healthBar, "SetStatusBarColor", ProcessStatusBarWidgetColorChanged);
	hooksecurefunc(unitframe.name, "SetFormattedText", ProcessFontStringWidgetTextChanged);
	hooksecurefunc(unitframe.name, "SetText", ProcessFontStringWidgetTextChanged);
	hooksecurefunc(unitframe.name, "SetTextColor", ProcessFontStringWidgetColorChanged);
	hooksecurefunc(unitframe.name, "SetVertexColor", ProcessFontStringWidgetColorChanged);

	ProcessStatusBarWidgetColorChanged(unitframe.healthBar);
	ProcessFontStringWidgetColorChanged(unitframe.name);
	ProcessFontStringWidgetTextChanged(unitframe.name);

	-- Add full title widget.

	do
		local titleWidget = unitframe:CreateFontString(nil, "ARTWORK");
		titleWidget:ClearAllPoints();
		titleWidget:SetPoint("TOP", unitframe.name, "BOTTOM", 0, -2);
		titleWidget:SetVertexColor(TRP3_API.Ellyb.ColorManager.GREY:GetRGBA());
		titleWidget:SetFontObject(SystemFont_LargeNamePlate);
		titleWidget:Hide();

		nameplate.TRP3_Title = titleWidget;
	end

	self.initializedNameplates[frameName] = true;
end

function TRP3_BlizzardNamePlates:UpdateNamePlateName(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local unitToken = nameplate.namePlateUnitToken;
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	local overrideText = unitframe.name.TRP3_originalText;
	local overrideColor;

	if displayInfo then
		local shouldCropName = false;

		-- Anything that needs to potentially be cropped should be inserted
		-- first; the name is cropped as a single unit to ensure that we
		-- don't need to worry about cropping things like titles individually.

		if displayInfo.nameText then
			overrideText = displayInfo.nameText;
			shouldCropName = true;
		end

		if displayInfo.prefixTitle then
			overrideText = string.join(" ", displayInfo.prefixTitle, overrideText);
			shouldCropName = true;
		end

		if shouldCropName then
			overrideText = TRP3_API.utils.str.crop(overrideText, TRP3_NamePlatesUtil.MAX_NAME_CHARS);
		end

		-- No cropping occurs after this point.

		overrideText = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(overrideText, displayInfo.roleplayStatus);
		overrideText = TRP3_NamePlatesUtil.PrependIconToText(overrideText, displayInfo.icon);

		-- Process color overrides.

		if displayInfo.nameColor then
			local color = displayInfo.nameColor;
			overrideColor = unitframe.name.TRP3_overrideColor;

			if UnitIsUnit(nameplate.namePlateUnitToken, "mouseover") then
				local r = Saturate(color.r * 1.25);
				local g = Saturate(color.g * 1.25);
				local b = Saturate(color.b * 1.25);

				overrideColor = CreateOrUpdateColor(overrideColor, r, g, b);
			else
				overrideColor = CreateOrUpdateColor(overrideColor, color:GetRGB());
			end
		end
	end

	SetFontStringWidgetOverrideText(unitframe.name, overrideText);
	SetFontStringWidgetOverrideColor(unitframe.name, overrideColor);
end

function TRP3_BlizzardNamePlates:UpdateNamePlateHealthBar(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local unitToken = nameplate.namePlateUnitToken;
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	local overrideColor;

	if displayInfo and displayInfo.healthColor then
		overrideColor = unitframe.healthBar.TRP3_overrideColor;
		overrideColor = CreateOrUpdateColor(overrideColor, displayInfo.healthColor:GetRGB());
	end

	SetStatusBarWidgetOverrideColor(unitframe.healthBar, overrideColor);
end

function TRP3_BlizzardNamePlates:UpdateNamePlateFullTitle(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local unitToken = nameplate.namePlateUnitToken;
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	-- Hide the full title widget if no title is to be displayed, or if the
	-- nameplate isn't in name-only mode.

	if not displayInfo or not displayInfo.fullTitle or unitframe.healthBar:IsShown() or not unitframe.name:IsShown() then
		nameplate.TRP3_Title:Hide();
	else
		nameplate.TRP3_Title:SetText(displayInfo.fullTitle);
		nameplate.TRP3_Title:Show();
	end

	-- On Classic Blizzard shows the level text all the time in name-only
	-- mode, so we'll be nice and fix that.

	if unitframe.LevelFrame then
		unitframe.LevelFrame:SetShown(unitframe.healthBar:IsShown());
	end
end

function TRP3_BlizzardNamePlates:UpdateNamePlateVisibility(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local shouldShow; -- This is only false or nil explicitly.

	if TRP3_NamePlatesUtil.ShouldHideUnitNamePlate(unitframe.displayedUnit) then
		shouldShow = false;
	end

	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.aggroHighlight, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.BuffFrame, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.castBar, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.ClassificationFrame, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.healthBar, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.LevelFrame, shouldShow);  -- Classic-only.
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.name, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.RaidTargetFrame, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.selectionHighlight, shouldShow);
	TryCallWidgetFunction(SetWidgetOverrideShownState, unitframe.WidgetContainer, shouldShow);
end

function TRP3_BlizzardNamePlates:UpdateNamePlate(nameplate)
	if nameplate:IsForbidden() or not nameplate:IsShown() then
		return;
	end

	self:UpdateNamePlateName(nameplate);
	self:UpdateNamePlateHealthBar(nameplate);
	self:UpdateNamePlateFullTitle(nameplate);
	self:UpdateNamePlateVisibility(nameplate);
end

function TRP3_BlizzardNamePlates:CanCustomizeNamePlate(nameplate)
	if nameplate:IsForbidden() or not nameplate.UnitFrame then
		return false;
	elseif not self.initializedNameplates[nameplate:GetName()] then
		return false;
	else
		return true;
	end
end

function TRP3_BlizzardNamePlates:UpdateAllNamePlates()
	for _, nameplate in ipairs(C_NamePlate.GetNamePlates()) do
		self:UpdateNamePlate(nameplate);
	end
end

function TRP3_BlizzardNamePlates:GetUnitDisplayInfo(unitToken)
	return self.unitDisplayInfo[unitToken];
end

function TRP3_BlizzardNamePlates:SetUnitDisplayInfo(unitToken, displayInfo)
	self.unitDisplayInfo[unitToken] = displayInfo;
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

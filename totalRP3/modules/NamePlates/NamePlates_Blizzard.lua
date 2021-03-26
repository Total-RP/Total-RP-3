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
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	-- Quick hack to make these nameplates "cowardly"; if any of the below
	-- addons is enabled on this character we won't enable Blizzard
	-- customizations. Some of these we don't support, and others don't
	-- make sense to fallback on Blizzard nameplates if present.

	local addons = {
		"Kui_Nameplates",
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
	-- Note this below logic for the TRP3_NAMEPLATES_ADDON global is special
	-- in this decorator; as Blizzard plates are the "default" we check if
	-- at this point any other decorator has set the global.
	--
	-- For a more normal case, see the Kui logic.

	if TRP3_NAMEPLATES_ADDON ~= nil then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	else
		TRP3_NAMEPLATES_ADDON = "Blizzard_NamePlates";
	end

	self.unitDisplayInfo = {};
	self.initializedNameplates = {};

	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	hooksecurefunc("CompactUnitFrame_SetUpFrame", function(...) return self:OnUnitFrameSetUp(...); end);
	hooksecurefunc(NamePlateDriverFrame, "UpdateNamePlateOptions", function() return self:OnUpdateNamePlateOptions(); end);

	self:UpdateAllNamePlates();
end

function TRP3_BlizzardNamePlates:OnUpdateNamePlateOptions()
	self:UpdateAllNamePlateOptions();
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
		titleWidget:Hide();

		nameplate.TRP3_Title = titleWidget;
	end

	-- Add icon widget.

	do
		local iconWidget = unitframe:CreateTexture(nil, "ARTWORK");
		iconWidget:ClearAllPoints();
		iconWidget:SetPoint("RIGHT", unitframe.name, "LEFT", -4, 0);
		iconWidget:Hide();

		nameplate.TRP3_Icon = iconWidget;
	end


	self.initializedNameplates[frameName] = true;
	self:UpdateNamePlateOptions(nameplate);
end

function TRP3_BlizzardNamePlates:UpdateNamePlateName(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local unitToken = nameplate.namePlateUnitToken;
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	local overrideText;
	local overrideColor;

	if displayInfo then
		if displayInfo.name then
			overrideText = TRP3_API.utils.str.crop(displayInfo.name, TRP3_NamePlatesUtil.MAX_NAME_CHARS);
		end

		-- No cropping occurs after this point.

		if displayInfo.roleplayStatus then
			overrideText = overrideText or unitframe.name.TRP3_originalText;

			if overrideText then
				overrideText = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(overrideText, displayInfo.roleplayStatus);
			end
		end

		-- Process color overrides.

		if displayInfo.shouldColorName then
			local color = displayInfo.color;
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

	if displayInfo and displayInfo.shouldColorHealth then
		overrideColor = unitframe.healthBar.TRP3_overrideColor;
		overrideColor = CreateOrUpdateColor(overrideColor, displayInfo.color:GetRGB());
	end

	SetStatusBarWidgetOverrideColor(unitframe.healthBar, overrideColor);
end

function TRP3_BlizzardNamePlates:UpdateNamePlateIcon(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local unitToken = nameplate.namePlateUnitToken;
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local displayIcon = displayInfo and displayInfo.icon or nil;
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Hide the icon if explicitly requested, or if the name isn't showing as
	-- that's our only attachment point. For reference, putting it next to the
	-- health bar looks weird on Blizzard plates.

	if shouldHide or not ShouldShowName(unitframe) then
		displayIcon = nil;
	end

	if displayIcon then
		nameplate.TRP3_Icon:SetTexture(TRP3_API.utils.getIconTexture(displayIcon));
		nameplate.TRP3_Icon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize());
		nameplate.TRP3_Icon:Show();
	else
		nameplate.TRP3_Icon:Hide();
	end
end

function TRP3_BlizzardNamePlates:UpdateNamePlateFullTitle(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local unitframe = nameplate.UnitFrame;
	local unitToken = nameplate.namePlateUnitToken;
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local displayText = displayInfo and displayInfo.fullTitle or nil;
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Hide the full title widget if no title is to be displayed, or if the
	-- nameplate isn't in name-only mode.
	--
	-- Note that we don't check the name-only CVar here because Blizzard
	-- only applies it on a full UI reload; instead we check if the healthbar
	-- is showing or not.

	if shouldHide or not ShouldShowName(unitframe) or unitframe.healthBar:IsShown() then
		displayText = nil;
	end

	if displayText then
		nameplate.TRP3_Title:SetText(TRP3_API.utils.str.crop(displayInfo.fullTitle, TRP3_NamePlatesUtil.MAX_TITLE_CHARS));
		nameplate.TRP3_Title:Show();
	else
		nameplate.TRP3_Title:Hide();
	end

	-- On Classic Blizzard shows the level text all the time in name-only
	-- mode, so we'll be nice and fix that.
	--
	-- In contrast to the above this _does_ check the CVar because of an
	-- edge case with the hide nameplate options where the level text could
	-- spuriously disappear if name only mode isn't enabled because of our
	-- visibility overrides on the level frame widget.

	local isNameOnly = (GetCVar("nameplateShowOnlyNames") ~= "0");

	if unitframe.LevelFrame and isNameOnly then
		unitframe.LevelFrame:SetShown(unitframe.healthBar:IsShown());
	end
end

function TRP3_BlizzardNamePlates:UpdateNamePlateVisibility(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.namePlateUnitToken);
	local unitframe = nameplate.UnitFrame;
	local shouldShow; -- This is only false or nil explicitly.

	if displayInfo and displayInfo.shouldHide then
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

function TRP3_BlizzardNamePlates:UpdateNamePlateOptions(nameplate)
	if nameplate:IsForbidden() or not self.initializedNameplates[nameplate:GetName()] then
		return;
	end

	local namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"));
	local isUsingLargerStyle = (namePlateVerticalScale > 1.0);

	if isUsingLargerStyle then
		nameplate.TRP3_Title:SetFontObject(SystemFont_LargeNamePlate);
	else
		nameplate.TRP3_Title:SetFontObject(SystemFont_NamePlate);
	end
end

function TRP3_BlizzardNamePlates:UpdateNamePlate(nameplate)
	if nameplate:IsForbidden() or not nameplate:IsShown() then
		return;
	end

	self:UpdateNamePlateVisibility(nameplate);
	self:UpdateNamePlateName(nameplate);
	self:UpdateNamePlateHealthBar(nameplate);
	self:UpdateNamePlateIcon(nameplate);
	self:UpdateNamePlateFullTitle(nameplate);
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

function TRP3_BlizzardNamePlates:UpdateAllNamePlateOptions()
	for frameName in pairs(self.initializedNameplates) do
		self:UpdateNamePlateOptions(_G[frameName]);
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

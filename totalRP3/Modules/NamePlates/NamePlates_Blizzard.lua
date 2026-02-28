-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local TRP3_NamePlates = TRP3_NamePlates;
local TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
local L = TRP3_API.loc;

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
	widget.TRP3_originalColor = TRP3_API.CreateColor(widget:GetVertexColor());
	UpdateFontStringWidgetColor(widget);
end

local function ProcessStatusBarWidgetColorChanged(widget)
	widget.TRP3_originalColor = TRP3_API.CreateColor(widget:GetStatusBarColor());
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
	if not C_AddOns.IsAddOnLoaded("Blizzard_NamePlates") then
		return TRP3_API.module.status.MISSING_DEPENDENCY, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	-- Quick hack to make these nameplates "cowardly"; if any of the below
	-- addons is enabled on this character we won't enable Blizzard
	-- customizations. Some of these we don't support, and others don't
	-- make sense to fallback on Blizzard nameplates if present.

	local addons = {
		"Platynator",
	};

	for _, addon in ipairs(addons) do
		if AddOnUtil.IsAddOnEnabledForCurrentCharacter(addon) then
			return TRP3_API.module.status.CONFLICTED, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
		end
	end

	-- ElvUI nameplates are an optional module within ElvUI and need special
	-- checks.

	if ElvUI then
		local E = ElvUI[1];
		if E and E.NamePlates and E.NamePlates.Initialized then
			return TRP3_API.module.status.CONFLICTED, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
		end
	end

	-- Plater also has optional friendly nameplates - if they're enabled, we bail
	if Plater then
		if Plater.db.profile.plate_config.friendlyplayer.module_enabled then
			return TRP3_API.module.status.CONFLICTED, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
		end
	end
end

function TRP3_BlizzardNamePlates:OnModuleEnable()
	self.unitDisplayInfo = {};
	self.initializedNameplates = {};
	self.initializedUnitFrames = {};

	TRP3_CVarCache.RegisterCallback(self, TRP3_CVarConstants.NamePlateShowOnlyNameForFriendlyPlayerUnits, "OnNamePlateNameOnlyModeChanged");
	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");
	TRP3_NamePlatesUtil.SyncNameOnlyModeState();

	-- luacheck: no unused (self)
	hooksecurefunc(NamePlateDriverFrame, "OnNamePlateCreated", function(_self, nameplate) self:OnNamePlateCreated(nameplate); end);
	hooksecurefunc(NamePlateDriverFrame, "UpdateNamePlateOptions", function() return self:OnNamePlateSettingsChanged(); end);

	self:UpdateAllNamePlates();
end

function TRP3_BlizzardNamePlates:OnNamePlateDataUpdated(_, nameplate, unitToken, displayInfo)
	self:SetUnitDisplayInfo(unitToken, displayInfo);
	self:UpdateNamePlate(nameplate);
end

function TRP3_BlizzardNamePlates:OnNamePlateCreated(nameplate)
	self:InitializeNamePlate(nameplate);
end

function TRP3_BlizzardNamePlates:OnNamePlateUnitAssigned(nameplate, _unitToken)  -- luacheck: no unused
	-- Direct access required here as GetNamePlateUnitFrame will return nil
	-- for unit frames we've not yet initialized.
	local unitframe = nameplate.UnitFrame;

	if unitframe then
		self:InitializeUnitFrame(unitframe);
	end
end

function TRP3_BlizzardNamePlates:OnNamePlateUnitCleared(nameplate)
	local unitframe = self:GetNamePlateUnitFrame(nameplate);

	if unitframe then
		self:ResetUnitFrame(unitframe);
	end
end

function TRP3_BlizzardNamePlates:OnNamePlateNameOnlyModeChanged()
	self:UpdateAllNamePlates();
end

function TRP3_BlizzardNamePlates:OnNamePlateSettingsChanged()
	self:UpdateAllNamePlates();
end

function TRP3_BlizzardNamePlates:GetNamePlateTextHeight()
	return NamePlateSetupOptions.healthBarFontHeight;
end

function TRP3_BlizzardNamePlates:GetNamePlateUnitFrame(nameplate)
	local unitframe = nameplate.UnitFrame;

	if self:HasInitializedUnitFrame(unitframe) then
		return unitframe;
	else
		return nil;
	end
end

function TRP3_BlizzardNamePlates:GetUnitFrameIconTexture(unitframe)
	return unitframe.TRP3_Icon;
end

function TRP3_BlizzardNamePlates:GetUnitFrameGuildFontString(unitframe)
	return unitframe.TRP3_Guild;
end

function TRP3_BlizzardNamePlates:GetUnitFrameTitleFontString(unitframe)
	return unitframe.TRP3_Title;
end

function TRP3_BlizzardNamePlates:GetUnitFrameUnit(unitframe)
	return unitframe.unit;
end

function TRP3_BlizzardNamePlates:HasInitializedNamePlate(nameplate)
	return self.initializedNameplates[nameplate] == true;
end

function TRP3_BlizzardNamePlates:HasInitializedUnitFrame(unitframe)
	return self.initializedUnitFrames[unitframe] == true;
end

function TRP3_BlizzardNamePlates:SetNamePlateInitialized(nameplate)
	self.initializedNameplates[nameplate] = true;
end

function TRP3_BlizzardNamePlates:SetUnitFrameInitialized(unitframe)
	self.initializedUnitFrames[unitframe] = true;
end

function TRP3_BlizzardNamePlates:InitializeNamePlate(nameplate)
	if self:HasInitializedNamePlate(nameplate) then
		return;
	end

	-- luacheck: no redefined (shadowing 'nameplate')
	hooksecurefunc(nameplate, "SetUnit", function(nameplate, unitToken) self:OnNamePlateUnitAssigned(nameplate, unitToken); end);
	hooksecurefunc(nameplate, "ClearUnit", function(nameplate) self:OnNamePlateUnitCleared(nameplate); end);
	self:SetNamePlateInitialized(nameplate);
end

function TRP3_BlizzardNamePlates:InitializeUnitFrame(unitframe)
	if self:HasInitializedUnitFrame(unitframe) then
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
	hooksecurefunc(unitframe.name, "SetVertexColor", ProcessFontStringWidgetColorChanged);

	ProcessStatusBarWidgetColorChanged(unitframe.healthBar);
	ProcessFontStringWidgetColorChanged(unitframe.name);
	ProcessFontStringWidgetTextChanged(unitframe.name);

	-- Add full title widget.

	do
		local titleWidget = unitframe:CreateFontString(nil, "ARTWORK");
		titleWidget:SetFontObject(SystemFont_NamePlate_Outlined);
		titleWidget:ClearAllPoints();
		titleWidget:SetPoint("TOP", unitframe.name, "BOTTOM", 0, -2);
		titleWidget:SetVertexColor(TRP3_API.Colors.Grey:GetRGBA());
		titleWidget:Hide();

		unitframe.TRP3_Title = titleWidget;
	end

	-- Add guild name widget.

	do
		local guildWidget = unitframe:CreateFontString(nil, "ARTWORK");
		guildWidget:SetFontObject(SystemFont_NamePlate_Outlined);
		guildWidget:ClearAllPoints();
		guildWidget:SetPoint("TOP", unitframe.name, "BOTTOM", 0, -2);
		guildWidget:SetVertexColor(TRP3_API.Colors.Grey:GetRGBA());
		guildWidget:Hide();

		unitframe.TRP3_Guild = guildWidget;
	end

	-- Add icon widget.

	do
		local iconWidget = unitframe:CreateTexture(nil, "ARTWORK");
		iconWidget:ClearAllPoints();
		iconWidget:SetPoint("RIGHT", unitframe.name, "LEFT", -4, 0);
		iconWidget:Hide();

		unitframe.TRP3_Icon = iconWidget;
	end

	self:SetUnitFrameInitialized(unitframe);
end

function TRP3_BlizzardNamePlates:ResetUnitFrame(unitframe)
	self:GetUnitFrameTitleFontString(unitframe):Hide();
	self:GetUnitFrameGuildFontString(unitframe):Hide();
	self:GetUnitFrameIconTexture(unitframe):Hide();
end

function TRP3_BlizzardNamePlates:UpdateNamePlateName(nameplate)
	local unitframe = self:GetNamePlateUnitFrame(nameplate);

	if not unitframe then
		return;
	end

	local unitToken = self:GetUnitFrameUnit(unitframe);
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	local overrideText;
	local overrideColor;

	if displayInfo then
		if displayInfo.name then
			overrideText = displayInfo.name;
		end

		-- No cropping occurs after this point.

		if displayInfo.roleplayStatus then
			overrideText = overrideText or unitframe.name.TRP3_originalText;

			if overrideText then
				overrideText = TRP3_NamePlatesUtil.PrependRoleplayStatusToText(overrideText, displayInfo.roleplayStatus);
			end
		end

		-- Process color overrides.
		-- Do not color name when unit name is within the health bar, except when name-only mode is on.
		-- Companion nameplates don't have a name-only option, so exclude them from the name-only check.
		local hasHealthBarOverlap = NamePlateSetupOptions.unitNameInsideHealthBar and not TRP3_NamePlatesUtil.IsNameOnlyModeEnabled() or not displayInfo.isPlayerUnit;

		if displayInfo.shouldColorName and not hasHealthBarOverlap then
			local color = displayInfo.color;
			if UnitIsUnit(unitToken, "mouseover") then
				local r = Saturate(color.r * 1.25);
				local g = Saturate(color.g * 1.25);
				local b = Saturate(color.b * 1.25);

				overrideColor = TRP3_API.CreateColor(r, g, b);
			else
				overrideColor = TRP3_API.CreateColor(color:GetRGB());
			end
		end
	end

	SetFontStringWidgetOverrideText(unitframe.name, overrideText);
	SetFontStringWidgetOverrideColor(unitframe.name, overrideColor);
end

function TRP3_BlizzardNamePlates:UpdateNamePlateHealthBar(nameplate)
	local unitframe = self:GetNamePlateUnitFrame(nameplate);

	if not unitframe then
		return;
	end

	local unitToken = self:GetUnitFrameUnit(unitframe);
	local displayInfo = self:GetUnitDisplayInfo(unitToken);

	local overrideColor;

	if displayInfo and displayInfo.shouldColorHealth then
		overrideColor = TRP3_API.CreateColor(displayInfo.color:GetRGB());
	end

	SetStatusBarWidgetOverrideColor(unitframe.healthBar, overrideColor);
end

function TRP3_BlizzardNamePlates:UpdateNamePlateIcon(nameplate)
	local unitframe = self:GetNamePlateUnitFrame(nameplate);

	if not unitframe then
		return;
	end

	local unitToken = self:GetUnitFrameUnit(unitframe);
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local unitFrameIcon = self:GetUnitFrameIconTexture(unitframe);
	local displayIcon = displayInfo and displayInfo.icon or nil;
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Hide the icon if explicitly requested, or if the name isn't showing as
	-- that's our only attachment point. For reference, putting it next to the
	-- health bar looks weird on Blizzard plates.

	if shouldHide or not unitframe:ShouldShowName() then
		displayIcon = nil;
	end

	if displayIcon then
		unitFrameIcon:SetTexture(TRP3_API.utils.getIconTexture(displayIcon));
		unitFrameIcon:SetSize(TRP3_NamePlatesUtil.GetPreferredIconSize());
		unitFrameIcon:Show();
	else
		unitFrameIcon:Hide();
	end
end

function TRP3_BlizzardNamePlates:UpdateNamePlateSubText(nameplate)
	local unitframe = self:GetNamePlateUnitFrame(nameplate);

	if not unitframe then
		return;
	end

	local unitToken = self:GetUnitFrameUnit(unitframe);
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
	local unitFrameTitle = self:GetUnitFrameTitleFontString(unitframe);
	local unitFrameGuild = self:GetUnitFrameGuildFontString(unitframe);

	-- No displayInfo = no customization to apply, hide subtext widgets and leave
	if not displayInfo then
		unitFrameTitle:Hide();
		unitFrameGuild:Hide();
		return;
	end

	local displayFullTitle = nil;
	local displayGuild = nil;

	-- Hide the subtext widgets if no subtext is to be displayed, or if the
	-- nameplate isn't in name-only mode (companions are excluded).
	--

	local isNameOnly = TRP3_NamePlatesUtil.IsNameOnlyModeEnabled() and displayInfo.isPlayerUnit;
	local shouldShow = not displayInfo.shouldHide and not TRP3_NamePlatesUtil.IsSubtextDisabled() and unitframe:ShouldShowName();

	if shouldShow and isNameOnly then
		if TRP3_NamePlatesUtil.IsFullTitleEnabled() then
			displayFullTitle = displayInfo.fullTitle;
		end

		if TRP3_NamePlatesUtil.IsGuildNameEnabled() then
			displayGuild = displayInfo.guildName;
		end
	end

	if displayFullTitle then
		-- We apply colors here, and not in widget creation, so changes to the color are shown instantly.
		displayFullTitle = TRP3_API.CreateColorFromHexString(TRP3_NamePlatesSettings.TooltipFullTitleColor):WrapTextInColorCode(displayFullTitle);
		unitFrameTitle:SetTextHeight(self:GetNamePlateTextHeight());
		unitFrameTitle:SetText(displayFullTitle);
		unitFrameTitle:Show();
	else
		unitFrameTitle:Hide();
	end

	if displayGuild then
		-- We apply colors here, and not in widget creation, so changes to the color are shown instantly.
		displayGuild = TRP3_API.CreateColorFromHexString(TRP3_NamePlatesSettings.TooltipGuildNameColor):WrapTextInColorCode(displayGuild);
		unitFrameGuild:SetTextHeight(self:GetNamePlateTextHeight());
		unitFrameGuild:SetText(displayGuild);
		-- Put under FT if it is shown
		if displayFullTitle and unitFrameTitle:IsShown() then
			unitFrameGuild:SetPoint("TOP", unitFrameTitle, "BOTTOM", 0, -2);
		else
			unitFrameGuild:SetPoint("TOP", unitframe.name, "BOTTOM", 0, -2);
		end
		unitFrameGuild:Show();
	else
		unitFrameGuild:Hide();
	end

	--[[ TO:DO Requires further adjustment for Classic
	-- On Classic Blizzard shows the level text all the time in name-only
	-- mode, so we'll be nice and fix that.
	--
	-- Check the CVar because of an edge case with the hide nameplate options
	-- where the level text could spuriously disappear if name only mode isn't
	-- enabled because of our visibility overrides on the level frame widget.

	local isNameOnlyClassic = C_CVar.GetCVarBool("nameplateShowOnlyNames");

	if unitframe.LevelFrame and isNameOnlyClassic then
		unitframe.LevelFrame:SetShown(unitframe.healthBar:IsShown());
	end
	]]
end

function TRP3_BlizzardNamePlates:UpdateNamePlateVisibility(nameplate)
	local unitframe = self:GetNamePlateUnitFrame(nameplate);

	if not unitframe then
		return;
	end

	local unitToken = self:GetUnitFrameUnit(unitframe);
	local displayInfo = self:GetUnitDisplayInfo(unitToken);
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

function TRP3_BlizzardNamePlates:UpdateNamePlate(nameplate)
	if not nameplate:IsShown() then
		return;
	end

	self:UpdateNamePlateVisibility(nameplate);
	self:UpdateNamePlateName(nameplate);
	self:UpdateNamePlateHealthBar(nameplate);
	self:UpdateNamePlateIcon(nameplate);
	self:UpdateNamePlateSubText(nameplate);
end

function TRP3_BlizzardNamePlates:UpdateAllNamePlates()
	local includeForbidden = false;
	for _, nameplate in ipairs(C_NamePlate.GetNamePlates(includeForbidden)) do
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
	requiredDeps = { {"Blizzard_NamePlates", "external"} },
	onInit = function() return TRP3_BlizzardNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_BlizzardNamePlates:OnModuleEnable(); end,
});

_G.TRP3_BlizzardNamePlates = TRP3_BlizzardNamePlates;

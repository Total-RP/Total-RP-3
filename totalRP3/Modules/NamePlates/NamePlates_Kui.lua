-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local TRP3_NamePlates = TRP3_NamePlates;
local TRP3_NamePlatesUtil = TRP3_NamePlatesUtil;
local L = TRP3_API.loc;

local NIL_SENTINEL = {};

local function FormatStashToken(key)
	return "trp3_original_" .. key;
end

local function ClearStashedFields(state)
	for key in pairs(state) do
		if string.find(key, "^trp3_original_") then
			state[key] = nil;
		end
	end
end

local function OverrideStateField(state, field, value)
	local token = FormatStashToken(field);

	if state[token] == nil then
		local original = state[field];

		if original == nil then
			original = NIL_SENTINEL;
		end

		state[token] = original;
	end

	state[field] = value;
	return true;
end

local function RestoreStateField(state, field)
	local token = FormatStashToken(field);
	local original = state[token];

	if original == nil then
		return false;  -- This field isn't overridden.
	end

	if original == NIL_SENTINEL then
		original = nil;
	end

	state[field] = original;
	state[token] = nil;

	return true;
end

local function IsNamePlateInNameOnlyMode(nameplate)
	local unitframe = nameplate.parent.UnitFrame;
	return nameplate.IN_NAMEONLY and unitframe and ShouldShowName(unitframe);
end

local TRP3_KuiNamePlates = {};

function TRP3_KuiNamePlates:OnLoad()
	if not KuiNameplates then
		return;
	end

	-- Our Kui plugin needs to be eagerly registered. This is dependent upon
	-- us having it as an optional dependency in the TOC to work.

	local maxMinor = nil;
	local enableOnLoad = true;

	self.plugin = KuiNameplates:NewPlugin("TotalRP3", 250, maxMinor, enableOnLoad);
	self.plugin.OnEnable = function(_) self:OnPluginEnable() end;
	self.plugin.Create = function(_, ...) return self:OnNamePlateCreate(...); end;
	self.plugin.Show = function(_, nameplate) return self:OnNamePlateShow(nameplate); end;
	self.plugin.HealthUpdate = function(_, nameplate) return self:UpdateNamePlate(nameplate); end;
	self.plugin.HealthColourChange = function(_, nameplate) return self:UpdateNamePlate(nameplate); end;
	self.plugin.GlowColourChange = function(_, nameplate) return self:UpdateNamePlate(nameplate); end;
	self.plugin.GainedTarget = function(_, nameplate) return self:UpdateNamePlate(nameplate); end;
	self.plugin.LostTarget = function(_, nameplate) return self:UpdateNamePlate(nameplate); end;
	self.plugin.Combat = function(_, nameplate) return self:UpdateNamePlate(nameplate); end;
	self.plugin.Hide = function(_, nameplate) return self:OnNamePlateHide(nameplate); end;
end

function TRP3_KuiNamePlates:OnModuleInitialize()
	if not C_AddOns.IsAddOnLoaded("Kui_Nameplates") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif not KuiNameplatesCore or KuiNameplates.layout ~= KuiNameplatesCore then
		-- For now we only support the "Core" layout for Kui.
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif not self.plugin then
		-- Something really hecked up happened.
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	-- Disable our (old) Kui nameplate module explicitly, we'll also tell
	-- users that they can disable it.

	if TRP3_API.utils.IsAddOnEnabled("totalRP3_KuiNameplates") then
		C_AddOns.DisableAddOn("totalRP3_KuiNameplates");
		TRP3_API.popup.showAlertPopup(L.KUI_NAMEPLATES_WARN_OUTDATED_MODULE);
	end
end

function TRP3_KuiNamePlates:OnModuleEnable()
	TRP3_NamePlates.RegisterCallback(self, "OnNamePlateDataUpdated");

	self.unitDisplayInfo = {};
	self.initialized = {};

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

function TRP3_KuiNamePlates:OnPluginEnable()
	-- Nameplate visibility is handled through a fade rule. As we only ever
	-- forcefully hide nameplates with this rule we give it a high priority.
	--
	-- This has to be deferred to the OnEnable of the *plugin* and not
	-- our module due to timing issues with ADDON_LOADED/PLAYER_LOGIN.

	local FADE_PRIORITY = 15;
	local FADE_RULE_ID = "TRP3_KuiNamePlates";

	self.fading = KuiNameplates:GetPlugin("Fading");
	self.fading:AddFadeRule(GenerateClosure(self.EvaluateNamePlateVisibility, self), FADE_PRIORITY, FADE_RULE_ID);
end

function TRP3_KuiNamePlates:OnNamePlateShow(nameplate)
	ClearStashedFields(nameplate.state);
	self:UpdateNamePlate(nameplate);
end

function TRP3_KuiNamePlates:OnNamePlateHide(nameplate)
	ClearStashedFields(nameplate.state);
	self:UpdateNamePlate(nameplate);
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

function TRP3_KuiNamePlates:OnNameplateNameTextUpdated(nameplate)
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayText = displayInfo and displayInfo.name or nil;

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
	if not self:ShouldCustomizeNamePlate(nameplate) then
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
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayIcon = displayInfo and displayInfo.icon or nil;
	local shouldHide = displayInfo and displayInfo.shouldHide or false;
	local unitframe = nameplate.parent.UnitFrame;

	-- Only enable this if we're permitted to customize this nameplate, and
	-- if we've not been requested to hide it.

	if not self:ShouldCustomizeNamePlate(nameplate) or not ShouldShowName(unitframe) or shouldHide then
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
	if not self:CanCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayText = displayInfo and displayInfo.fullTitle or nil;
	local displayFont = nameplate.GuildText:GetFont();
	local shouldHide = displayInfo and displayInfo.shouldHide or false;

	-- Only enable this widget in name-only mode if we're permitted to
	-- customize this nameplate, and if we've not been requested to hide it.

	if not self:ShouldCustomizeNamePlate(nameplate) or not IsNamePlateInNameOnlyMode(nameplate) or shouldHide then
		displayText = nil;
		displayFont = nil;
	end

	if displayText and displayFont then
		local fontObject = nameplate.GuildText:GetFontObject();

		if fontObject then
			nameplate.TRP3_Title:SetFontObject(fontObject);
		else
			nameplate.TRP3_Title:SetFont(nameplate.GuildText:GetFont());
		end

		nameplate.TRP3_Title:SetTextColor(nameplate.GuildText:GetTextColor());
		nameplate.TRP3_Title:SetText(displayText);
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
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	-- Names are managed through a posthook. This will trigger icon and
	-- full title updates.

	nameplate.NameText:SetText(nameplate.state.name or UNKNOWNOBJECT);
	nameplate:UpdateNameText();
end

function TRP3_KuiNamePlates:UpdateNamePlateGuildText(nameplate)
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);
	local displayText = displayInfo and displayInfo.guildName or nil;
	local shouldUpdate;

	if displayText then
		shouldUpdate = OverrideStateField(nameplate.state, "guild_text", displayText);
	else
		shouldUpdate = RestoreStateField(nameplate.state, "guild_text");
	end

	if shouldUpdate then
		nameplate:UpdateGuildText();
	end
end

function TRP3_KuiNamePlates:EvaluateNamePlateVisibility(nameplate)
	if not self:ShouldCustomizeNamePlate(nameplate) then
		return;
	end

	local displayInfo = self:GetUnitDisplayInfo(nameplate.unit);

	if displayInfo and displayInfo.shouldHide then
		return 0;
	else
		return nil;  -- Allow lower priority rules to be processed.
	end
end

function TRP3_KuiNamePlates:UpdateNamePlateVisibility(nameplate)
	if self.fading then
		self.fading:UpdateFrame(nameplate);
	end
end

function TRP3_KuiNamePlates:UpdateNamePlate(nameplate)
	if self:ShouldCustomizeNamePlate(nameplate) then
		-- Some customizations are managed by posthooks on nameplate frames,
		-- including icons and full titles which are updated in response to
		-- the name text being updated.

		self:UpdateNamePlateNameText(nameplate);
		self:UpdateNamePlateGuildText(nameplate);
		self:UpdateNamePlateHealthBar(nameplate);
		self:UpdateNamePlateVisibility(nameplate);
	else
		-- For nameplates that we shouldn't customize, we need to force the
		-- full text and icons to update in order to hide them properly so
		-- that they don't hang around on recycled nameplates.

		self:UpdateNamePlateFullTitle(nameplate);
		self:UpdateNamePlateIcon(nameplate);
	end
end

function TRP3_KuiNamePlates:UpdateAllNamePlates()
	for _, nameplate in KuiNameplates:Frames() do
		self:UpdateNamePlate(nameplate);
	end
end

function TRP3_KuiNamePlates:CanCustomizeNamePlate(nameplate)
	local nameplateKey = nameplate:GetName();

	if not self.initialized or not self.initialized[nameplateKey] then
		return false;  -- Reject uninitialized nameplates.
	elseif not nameplate.parent or not nameplate.parent.UnitFrame then
		return false;  -- Nameplate doesn't have a unitframe (retail-specific).
	elseif not nameplate.unit then
		return false;  -- Nameplate doesn't have an associated unit.
	else
		return true;
	end
end

function TRP3_KuiNamePlates:ShouldCustomizeNamePlate(nameplate)
	if not self:CanCustomizeNamePlate(nameplate) then
		return false;  -- Reject invalid nameplates.
	elseif nameplate.state.personal or not nameplate.state.reaction then
		return false;  -- Reject personal and invalid nameplates.
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
	requiredDeps = { {"Kui_Nameplates", "external"}, {"Kui_Nameplates_Core", "external"} },
	onInit = function() return TRP3_KuiNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_KuiNamePlates:OnModuleEnable(); end,
});

_G.TRP3_KuiNamePlates = TRP3_KuiNamePlates;
TRP3_KuiNamePlates:OnLoad();

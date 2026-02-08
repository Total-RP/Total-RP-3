-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local loc = TRP3.loc;
local Globals = TRP3.globals;
local isUnitIDKnown = TRP3.register.isUnitIDKnown;
local hasProfile = TRP3.register.hasProfile;
local openMainFrame = TRP3.navigation.openMainFrame;
local getCurrentContext = TRP3.navigation.page.getCurrentContext;
local setTooltipForSameFrame = TRP3.ui.tooltip.setTooltipForSameFrame;

local GetCurrentUser = TRP3.Player.GetCurrentUser;
local getPlayerCurrentProfile = TRP3.profile.getPlayerCurrentProfile;
local getPlayerCurrentProfileID = TRP3.profile.getPlayerCurrentProfileID;
local getConfigValue = TRP3.configuration.getValue;

local function displayNotes(context)

	local profileID = context.profileID;
	if context.isPlayer then
		profileID = getPlayerCurrentProfileID();
		TRP3_RegisterNotesViewContainer.Notice:Hide();
		TRP3_RegisterNotesViewAccount:Hide();
		TRP3_RegisterNotesViewProfile:SetPoint("BOTTOM", TRP3_RegisterNotesView, "BOTTOM", 0, 10);
		TRP3_RegisterNotesViewProfile:SetPoint("TOP", 0, -25);
	else
		TRP3_RegisterNotesViewContainer.Notice:Show();
		TRP3_RegisterNotesViewProfile:SetPoint("BOTTOM", TRP3_RegisterNotesViewContainer, "CENTER", 0, -8);
		TRP3_RegisterNotesViewProfile:SetPoint("TOP", 0, -45);
		TRP3_RegisterNotesViewAccount:Show();
	end

	local currentProfileName = GetCurrentUser():GetProfileName();
	local profileNotesTitle = string.format(loc.REG_PLAYER_NOTES_PROFILE, currentProfileName);
	TRP3_RegisterNotesViewProfile.Title:SetText(profileNotesTitle);

	assert(profileID, "No profileID in context !");

	local profileNotes = getPlayerCurrentProfile().notes;
	TRP3_RegisterNotesViewProfile:SetText(profileNotes and profileNotes[profileID] or "");
	TRP3_RegisterNotesViewAccount:SetText(TRP3_Notes and TRP3_Notes[profileID] or "");
end

local function onProfileNotesChanged()
	local context = getCurrentContext();
	local profileID = context.profileID;
	if context.isPlayer then
		profileID = getPlayerCurrentProfileID();
	end

	local profile = getPlayerCurrentProfile();
	if not profile.notes then
		profile.notes = {};
	end

	local text = TRP3_RegisterNotesViewProfile:GetInputText();
	text = string.trim(text);
	text = text ~= "" and text or nil;
	profile.notes[profileID] = text;
end

local function onAccountNotesChanged()
	local context = getCurrentContext();
	local profileID = context.profileID;
	if context.isPlayer then
		profileID = getPlayerCurrentProfileID();
	end

	local text = TRP3_RegisterNotesViewAccount:GetInputText();
	text = string.trim(text);
	text = text ~= "" and text or nil;
	TRP3_Notes[profileID] = text;
end

local function showNotesTab()
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");
	context.isEditMode = false;
	TRP3_ProfileReportButton:Hide();
	displayNotes(context);
	TRP3_RegisterNotes:Show();
end
TRP3.register.ui.showNotesTab = showNotesTab;

function TRP3.register.inits.notesInit()

	if not TRP3_Notes then
		TRP3_Notes = {};
	end

	TRP3_RegisterNotesViewContainer:SetTitleText(loc.REG_PLAYER_NOTES);
	TRP3_RegisterNotesViewContainer.Notice:SetText(string.format(loc.REG_PLAYER_NOTES_NOTICE, "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-note:22:22|t"));

	TRP3_RegisterNotesViewAccount.Title:SetText(loc.REG_PLAYER_NOTES_ACCOUNT);

	setTooltipForSameFrame(TRP3_RegisterNotesViewProfile.HelpButton, "LEFT", 0, 10, loc.REG_PLAYER_NOTES_PROFILE_NONAME, loc.REG_PLAYER_NOTES_PROFILE_HELP);
	setTooltipForSameFrame(TRP3_RegisterNotesViewAccount.HelpButton, "LEFT", 0, 10, loc.REG_PLAYER_NOTES_ACCOUNT, loc.REG_PLAYER_NOTES_ACCOUNT_HELP);

	TRP3_RegisterNotesViewAccount:RegisterCallback("OnTextChanged", onAccountNotesChanged, {});
	TRP3_RegisterNotesViewProfile:RegisterCallback("OnTextChanged", onProfileNotesChanged, {});

	TRP3.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
		if not TRP3.target then
			-- Target bar module disabled.
			return;
		end

		local openPageByUnitID = TRP3.register.openPageByUnitID;
		local openNotesTab = TRP3_TabBar_Tab_5:GetScript("OnClick");    -- This was a quick workaround for RP.IO, is there a better option ?
		TRP3.target.registerButton({
			id = "za_notes",
			configText = loc.REG_NOTES_PROFILE,
			onlyForType = TRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				return (unitID == Globals.player_id and getPlayerCurrentProfileID() ~= getConfigValue("default_profile_id")) or (isUnitIDKnown(unitID) and hasProfile(unitID));
			end,
			onClick = function(unitID)
				openMainFrame();
				openPageByUnitID(unitID);
				openNotesTab();
			end,
			tooltip = loc.REG_NOTES_PROFILE,
			tooltipSub = TRP3.FormatShortcutWithInstruction("CLICK", loc.REG_NOTES_PROFILE_TT),
			icon = TRP3_InterfaceIcons.TargetNotes,
		});
	end)
end

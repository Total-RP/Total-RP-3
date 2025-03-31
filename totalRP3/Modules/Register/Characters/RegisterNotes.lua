-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

local loc = TRP3_API.loc;
local Globals = TRP3_API.globals;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local hasProfile = TRP3_API.register.hasProfile;
local openMainFrame = TRP3_API.navigation.openMainFrame;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;

local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local getConfigValue = TRP3_API.configuration.getValue;

local function displayNotes(context)
	local player;

	if context.isPlayer then
		player = AddOn_TotalRP3.Player.GetCurrentUser();
	else
		player = AddOn_TotalRP3.Player.CreateFromProfileID(context.profileID);
	end

	if context.isPlayer then
		TRP3_RegisterNotesViewContainer.Notice:Hide();
	else
		TRP3_RegisterNotesViewContainer.Notice:Show();
	end

	-- Character-specific notes setup

	do
		local currentProfileName = AddOn_TotalRP3.Player.GetCurrentUser():GetProfileName();

		local accessor = TRP3_ProfileEditor.CreateMethodAccessor(player, player.GetCharacterSpecificNotes, player.SetCharacterSpecificNotes);
		local field = TRP3_ProfileEditor.CreateField(accessor);
		local label = string.format(loc.REG_PLAYER_NOTES_PROFILE, currentProfileName);
		local maxLetters = TRP3_ProfileEditorLengthLimits.Notes;

		local function OnTooltipShow(description)
			description:ClearLines();
			description:AddTitleLine(loc.REG_PLAYER_NOTES_PROFILE_NONAME);
			description:AddNormalLine(loc.REG_PLAYER_NOTES_PROFILE_HELP);
		end

		local initializer = TRP3_ProfileEditor.CreateTextAreaInitializer(field, label, OnTooltipShow, maxLetters);
		initializer:SetLengthWarningText(loc.PROFILE_EDITOR_LENGTH_WARNING_NOTES);

		TRP3_RegisterNotesViewContainer.ProfileNotes:Init(initializer);
	end

	-- Account-wide notes setup

	if not context.isPlayer then
		local accessor = TRP3_ProfileEditor.CreateMethodAccessor(player, player.GetAccountWideNotes, player.SetAccountWideNotes);
		local field = TRP3_ProfileEditor.CreateField(accessor);
		local label = loc.REG_PLAYER_NOTES_ACCOUNT;
		local tooltip = loc.REG_PLAYER_NOTES_ACCOUNT_HELP;
		local maxLetters = TRP3_ProfileEditorLengthLimits.Notes;

		local initializer = TRP3_ProfileEditor.CreateTextAreaInitializer(field, label, tooltip, maxLetters);
		initializer:SetLengthWarningText(loc.PROFILE_EDITOR_LENGTH_WARNING_NOTES);

		TRP3_RegisterNotesViewContainer.AccountNotes:Init(initializer);
		TRP3_RegisterNotesViewContainer.AccountNotes:Show();
	else
		TRP3_RegisterNotesViewContainer.AccountNotes:Hide();
	end
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
TRP3_API.register.ui.showNotesTab = showNotesTab;

function TRP3_API.register.inits.notesInit()

	if not TRP3_Notes then
		TRP3_Notes = {};
	end

	TRP3_RegisterNotesViewContainer:SetTitleText(loc.REG_PLAYER_NOTES);
	TRP3_RegisterNotesViewContainer.Notice:SetFormattedText(loc.REG_PLAYER_NOTES_NOTICE, "|TInterface\\AddOns\\totalRP3\\Resources\\UI\\ui-icon-note:22:22|t");

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
		if not TRP3_API.target then
			-- Target bar module disabled.
			return;
		end

		local openPageByUnitID = TRP3_API.register.openPageByUnitID;
		local openNotesTab = TRP3_TabBar_Tab_5:GetScript("OnClick");    -- This was a quick workaround for RP.IO, is there a better option ?
		TRP3_API.target.registerButton({
			id = "za_notes",
			configText = loc.REG_NOTES_PROFILE,
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			condition = function(_, unitID)
				return (unitID == Globals.player_id and getPlayerCurrentProfileID() ~= getConfigValue("default_profile_id")) or (isUnitIDKnown(unitID) and hasProfile(unitID));
			end,
			onClick = function(unitID)
				openMainFrame();
				openPageByUnitID(unitID);
				openNotesTab();
			end,
			tooltip = loc.REG_NOTES_PROFILE,
			tooltipSub = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.REG_NOTES_PROFILE_TT),
			icon = TRP3_InterfaceIcons.TargetNotes,
		});
	end)
end

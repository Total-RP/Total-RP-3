-------------------------------------------------------------------------------
--- Total RP 3
--- Scoring module
--- ---------------------------------------------------------------------------
--- Copyright 2019 Solanya <solanya@totalrp3.info> @Solanya_
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

local loc = TRP3_API.loc;
local Globals = TRP3_API.globals;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local hasProfile = TRP3_API.register.hasProfile;
local openMainFrame = TRP3_API.navigation.openMainFrame;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;

local GetCurrentUser = AddOn_TotalRP3.Player.GetCurrentUser;
local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;

local NOTES_ICON = Ellyb.Icon("Inv_misc_scrollunrolled03b");

local function displayNotes(context)

    local profileID = context.profileID;
    if context.isPlayer then
        profileID = getPlayerCurrentProfileID();
    end

    assert(profileID, "No profileID in context !");

    local profileNotes = GetCurrentUser():GetProfile().notes;
    TRP3_RegisterNotesViewProfileScrollText:SetText(profileNotes and profileNotes[profileID] or "");
    TRP3_RegisterNotesViewAccountScrollText:SetText(TRP3_Notes and TRP3_Notes[profileID] or "");
end

local function onAccountNotesChanged()
    local context = getCurrentContext();
    local profileID = context.profileID;
    if context.isPlayer then
        profileID = getPlayerCurrentProfileID();
    end

    TRP3_Notes[profileID] = TRP3_RegisterNotesViewAccountScrollText:GetText();
end

local function showNotesTab()
    local context = getCurrentContext();
    assert(context, "No context for page player_main !");
    assert(context.profile, "No profile in context");
    TRP3_ProfileReportButton:Hide();
    TRP3_RegisterNotes:Show();
    displayNotes(context);
end
TRP3_API.register.ui.showNotesTab = showNotesTab;

function TRP3_API.register.inits.notesInit()

    if not TRP3_Notes then
        TRP3_Notes = {};
    end

    TRP3_RegisterNotesViewAccountScrollText:SetScript("OnTextChanged", onAccountNotesChanged);

    TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()
        local openPageByUnitID = TRP3_API.register.openPageByUnitID;
        local openNotesTab = TRP3_TabBar_Tab_5:GetScript("OnClick");    -- This was a quick workaround for RP.IO, is there a better option ?
        TRP3_API.target.registerButton({
            id = "za_notes",
            configText = loc.REG_NOTES_PROFILE,
            onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
            condition = function(_, unitID)
                return unitID == Globals.player_id or (isUnitIDKnown(unitID) and hasProfile(unitID));
            end,
            onClick = function(unitID)
                openMainFrame();
                openPageByUnitID(unitID);
                openNotesTab();
            end,
            tooltip = loc.REG_NOTES_PROFILE,
            tooltipSub = loc.REG_NOTES_PROFILE_TT,
            icon = NOTES_ICON
        });
    end)
end
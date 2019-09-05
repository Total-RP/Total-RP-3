----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local TRP3_Enums = AddOn_TotalRP3.Enums;

local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local getProfiles = TRP3_API.profile.getProfiles;
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local color = Utils.str.color;
local playUISound = TRP3_API.ui.misc.playUISound;
local refreshTooltip, mainTooltip = TRP3_API.ui.tooltip.refresh, TRP3_MainTooltip;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local setPage = TRP3_API.navigation.page.setPage;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local is_classic = Globals.is_classic;

-- Total RP 3 imports
local loc = TRP3_API.loc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local get, getDefaultProfile = TRP3_API.profile.getData, TRP3_API.profile.getDefaultProfile;

getDefaultProfile().player.character = {
	v = 1,
	RP = TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER,
	XP = TRP3_Enums.ROLEPLAY_EXPERIENCE.EXPERIENCED,
	LC = TRP3_Configuration["AddonLocale"] or GetLocale(),
}

local function incrementCharacterVernum()
	local character = get("player/character");
	character.v = Utils.math.incrementNumber(character.v or 1, 2);
	Events.fireEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getPlayerCurrentProfileID(), "character");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STATUS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onStatusChange(status)
	local character = get("player/character");
	local old = character.RP;
	character.RP = status;
	if old ~= status then
		incrementCharacterVernum();
	end
end

local function switchStatus()
	if get("player/character/RP") == TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER then
		onStatusChange(TRP3_Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
	else
		onStatusChange(TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER);
	end
end
TRP3_API.dashboard.switchStatus = switchStatus;

function TRP3_API.dashboard.isPlayerIC()
	return get("player/character/RP") == 1;
end

function TRP3_API.dashboard.getCharacterExchangeData()
	return get("player/character");
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SANITIZE
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local FIELDS_TO_SANITIZE = {
	"CO", "CU"
}
---@param structure table
---@return boolean
function TRP3_API.dashboard.sanitizeCharacter(structure)
	local somethingWasSanitized = false;
	if structure then
		for _, field in pairs(FIELDS_TO_SANITIZE) do
			if structure[field] then
				local sanitizedValue = Utils.str.sanitize(structure[field]);
				if sanitizedValue ~= structure[field] then
					structure[field] = sanitizedValue;
					somethingWasSanitized = true;
				end
			end
		end
	end
	return somethingWasSanitized;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DASHBOARD_PAGE_ID = "dashboard";
local SendChatMessage, UnitIsDND, UnitIsAFK = SendChatMessage, UnitIsDND, UnitIsAFK;

TRP3_API.dashboard.init = function()

	local TUTORIAL_STRUCTURE = {
		{
			box = {
				allPoints = TRP3_DashboardStatus
			},
			button = {
				x = -50, y = 0, anchor = "RIGHT",
				text = loc.DB_TUTO_1:format(TRP3_API.globals.player_id),
				textWidth = 425,
				arrow = "UP"
			}
		},
	}

	registerMenu({
		id = "main_00_dashboard",
		align = "CENTER",
		text = TRP3_API.globals.addon_name,
		onSelected = function() setPage(DASHBOARD_PAGE_ID); end,
	});

	registerPage({
		id = DASHBOARD_PAGE_ID,
		frame = TRP3_Dashboard,
		tutorialProvider = function() return TUTORIAL_STRUCTURE; end
	});
end

local function profileSelected(profileID)
	TRP3_API.profile.selectProfile(profileID);
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	-- Register slash command for IC/OOC status control.
	TRP3_API.slash.registerCommand({
		id = "status",
		helpLine = " " .. loc.SLASH_CMD_STATUS_USAGE,
		handler = function(subcommand)
			local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();
			if subcommand == "ic" then
				if not currentUser:IsInCharacter() then
					-- User is OOC, they want to be IC.
					switchStatus();
				end
			elseif subcommand == "ooc" then
				if currentUser:IsInCharacter() then
					-- User is IC, they want to be OOC.
					switchStatus();
				end
			elseif subcommand == "toggle" then
				-- Toggle whatever the current status is.
				switchStatus();
			else
				-- Unknown subcommand.
				TRP3_API.utils.message.displayMessage(loc.SLASH_CMD_STATUS_HELP);
			end
		end,
	});

	if TRP3_API.toolbar then

		local updateToolbarButton = TRP3_API.toolbar.updateToolbarButton;
		-- away/dnd
		local status1Text = color("w")..loc.TB_STATUS..": "..color("r")..loc.TB_DND_MODE;
		local status1SubText = color("y")..loc.CM_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("g")..loc.TB_NORMAL_MODE..color("w")));
		local status2Text = color("w")..loc.TB_STATUS..": "..color("o")..loc.TB_AFK_MODE;
		local status2SubText = color("y")..loc.CM_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("g")..loc.TB_NORMAL_MODE..color("w")));
		local status3Text = color("w")..loc.TB_STATUS..": "..color("g")..loc.TB_NORMAL_MODE;
		local status3SubText = color("y")..loc.CM_L_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("o")..loc.TB_AFK_MODE..color("w"))).."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..(loc.TB_GO_TO_MODE:format(color("r")..loc.TB_DND_MODE..color("w")));
		local Button_Status = {
			id = "aa_trp3_c",
			icon = "Ability_Rogue_MasterOfSubtlety",
			configText = loc.CO_TOOLBAR_CONTENT_STATUS,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if UnitIsDND("player") then
					buttonStructure.tooltip  = status1Text;
					buttonStructure.tooltipSub  = status1SubText;
					buttonStructure.icon = is_classic and "Ability_Warrior_Challange" or "Ability_Mage_IncantersAbsorbtion";
				elseif UnitIsAFK("player") then
					buttonStructure.tooltip  = status2Text;
					buttonStructure.tooltipSub  = status2SubText;
					buttonStructure.icon = "Spell_Nature_Sleep";
				else
					buttonStructure.tooltip  = status3Text;
					buttonStructure.tooltipSub  = status3SubText;
					buttonStructure.icon = is_classic and "Ability_Stealth" or "Ability_Rogue_MasterOfSubtlety";
				end
			end,
			onClick = function(_, _, button)
				if UnitIsAFK("player") then
					SendChatMessage("","AFK");
				elseif UnitIsDND("player") then
					SendChatMessage("","DND");
				else
					if button == "LeftButton" then
						SendChatMessage("","AFK");
					else
						SendChatMessage("","DND");
					end
				end
				playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Status);

		-- Toolbar RP status
		local RP_ICON, OOC_ICON = "spell_shadow_charm", is_classic and "Achievement_GuildPerk_EverybodysFriend" or "Inv_misc_grouplooking";
		local rpTextOn = loc.TB_RPSTATUS_ON;
		local rpTextOff = loc.TB_RPSTATUS_OFF;
		local rpText2 = color("y")..loc.CM_L_CLICK..": "..color("w")..loc.TB_RPSTATUS_TO_ON;
		rpText2 = rpText2.."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..loc.TB_SWITCH_PROFILE;
		local rpText3 = color("y")..loc.CM_L_CLICK..": "..color("w")..loc.TB_RPSTATUS_TO_OFF;
		rpText3 = rpText3.."\n"..color("y")..loc.CM_R_CLICK..": "..color("w")..loc.TB_SWITCH_PROFILE;

		local Button_RPStatus = {
			id = "aa_trp3_rpstatus",
			icon = "Inv_misc_grouplooking",
			configText = loc.CO_TOOLBAR_CONTENT_RPSTATUS,
			onEnter = function() end,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if GetMouseFocus() == Uibutton then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if get("player/character/RP") == 1 then
					buttonStructure.tooltip  = rpTextOn;
					buttonStructure.tooltipSub = rpText3;
					buttonStructure.icon = RP_ICON;
				else
					buttonStructure.tooltip  = rpTextOff;
					buttonStructure.tooltipSub  = rpText2;
					buttonStructure.icon = OOC_ICON;
				end
			end,
			onClick = function(Uibutton, _, button)

				if button == "RightButton" then

					local list = getProfiles();

					local dropdownItems = {};
					tinsert(dropdownItems,{loc.TB_SWITCH_PROFILE, nil});
					local currentProfileID = getPlayerCurrentProfileID()
					for key, value in pairs(list) do
						local icon = value.player.characteristics.IC or Globals.icons.profile_default;
						if key == currentProfileID then
							tinsert(dropdownItems,{"|Tinterface\\icons\\"..icon..":15|t|cff00ff00 "..value.profileName.."|r", nil});
						else
							tinsert(dropdownItems,{"|Tinterface\\icons\\"..icon..":15|t "..value.profileName, key});
						end
					end
					displayDropDown(Uibutton, dropdownItems, profileSelected, 0, true);
				else
					switchStatus();
					playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
				end
			end,
			onLeave = function()
				mainTooltip:Hide();
			end,
			visible = 1
		};
		TRP3_API.toolbar.toolbarAddButton(Button_RPStatus);

		if TRP3_API.globals.is_classic then
			-- Show / hide helmet
			local helmetOffIcon = Ellyb.Icon("spell_nature_invisibilty");
			local helmetOnIcon = Ellyb.Icon("INV_Helmet_13");
			local helmTextOn = loc.TB_SWITCH_HELM_ON;
			local helmTextOff = loc.TB_SWITCH_HELM_OFF;
			local helmText2 = Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.TB_SWITCH_HELM_1);
			local helmText3 = Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.TB_SWITCH_HELM_2);

			local Button_Helmet = {
				id = "aa_trp3_b",
				icon = helmetOnIcon:GetFileName(),
				configText = loc.CO_TOOLBAR_CONTENT_HELMET,
				onEnter = function() end,
				onModelUpdate = function(buttonStructure)
					if ShowingHelm() then
						buttonStructure.tooltip  = helmTextOn;
						buttonStructure.tooltipSub = helmText3;
						local currentHelmetTexture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("HeadSlot")));
						buttonStructure.icon = currentHelmetTexture and Ellyb.Icon(currentHelmetTexture) or helmetOnIcon;
					else
						buttonStructure.tooltip  = helmTextOff;
						buttonStructure.tooltipSub  = helmText2;
						buttonStructure.icon = helmetOffIcon;
					end
				end,
				onUpdate = function(Uibutton, buttonStructure)
					updateToolbarButton(Uibutton, buttonStructure);
					if GetMouseFocus() == Uibutton then
						refreshTooltip(Uibutton);
					end
				end,
				onClick = function()
					if ShowingHelm() then
						ShowHelm(false);
						playUISound(1202); -- Putdowncloth_Leather01
					else
						ShowHelm(true);
						playUISound(1185); -- Pickupcloth_Leather01
					end
				end,
				onLeave = function()
					mainTooltip:Hide();
				end,
			};
			TRP3_API.toolbar.toolbarAddButton(Button_Helmet);

			-- Show/hide cloak
			local cloakOnIcon = Ellyb.Icon("INV_Misc_Cape_18");
			local cloakOffIcon = Ellyb.Icon("inv_misc_cape_20");
			local capeTextOn =  loc.TB_SWITCH_CAPE_ON;
			local capeTextOff = loc.TB_SWITCH_CAPE_OFF;
			local capeText2 = Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.TB_SWITCH_CAPE_1);
			local capeText3 = Ellyb.Strings.clickInstruction(Ellyb.System.CLICKS.CLICK, loc.TB_SWITCH_CAPE_2);
			local Button_Cape = {
				id = "aa_trp3_a",
				icon = cloakOnIcon:GetFileName(),
				configText = loc.CO_TOOLBAR_CONTENT_CAPE,
				onEnter = function() end,
				onModelUpdate = function(buttonStructure)
					if ShowingCloak() then
						buttonStructure.tooltip  = capeTextOn;
						buttonStructure.tooltipSub = capeText3;
						local currentCloakTexture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("BackSlot")));
						buttonStructure.icon = currentCloakTexture and Ellyb.Icon(currentCloakTexture) or cloakOnIcon;
					else
						buttonStructure.tooltip  = capeTextOff;
						buttonStructure.tooltipSub  = capeText2;
						buttonStructure.icon = cloakOffIcon;
					end
				end,
				onUpdate = function(Uibutton, buttonStructure)
					updateToolbarButton(Uibutton, buttonStructure);
					if GetMouseFocus() == Uibutton then
						refreshTooltip(Uibutton);
					end
				end,
				onClick = function(_)
					if ShowingCloak() then
						ShowCloak(false);
						playUISound(1202); -- Putdowncloth_Leather01
					else
						ShowCloak(true);
						playUISound(1185); -- Pickupcloth_Leather01
					end
				end,
				onLeave = function()
					mainTooltip:Hide();
				end,
			};
			TRP3_API.toolbar.toolbarAddButton(Button_Cape);
		end
	end
end);

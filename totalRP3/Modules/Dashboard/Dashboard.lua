-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_API.dashboard = {
	NOTIF_CONFIG_PREFIX = "notification_"
};

-- imports
local TRP3_Enums = AddOn_TotalRP3.Enums;

local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;
local getProfiles = TRP3_API.profile.getProfiles;
local Utils = TRP3_API.utils;
local color = Utils.str.color;
local refreshTooltip = TRP3_API.ui.tooltip.refresh;
local registerMenu, registerPage = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.page.registerPage;
local setPage = TRP3_API.navigation.page.setPage;

-- Total RP 3 imports
local loc = TRP3_API.loc;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local get, getDefaultProfile = TRP3_API.profile.getData, TRP3_API.profile.getDefaultProfile;

getDefaultProfile().player.character = {
	v = 1,
	RP = TRP3_Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER,
	WU = TRP3_Enums.WALKUP.NO,
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- STATUS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.dashboard.switchStatus()
	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	local status = player:GetRoleplayStatus();

	if status == TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER then
		player:SetRoleplayStatus(TRP3_Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
	else
		player:SetRoleplayStatus(TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER);
	end
end

function TRP3_API.dashboard.isPlayerIC()
	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	return player:IsInCharacter();
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
				local sanitizedValue = Utils.str.sanitize(structure[field], true);
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
				arrow = "LEFT"
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

local function getPlayerProfilesAsList(currentProfileID)
	local list = {};
	for profileID, profile in pairs(getProfiles()) do
		if currentProfileID == profileID then
			tinsert(list, {profile.profileName, profile.player.characteristics.IC, nil});
		else
			tinsert(list, {profile.profileName, profile.player.characteristics.IC, profileID});
		end
	end
	table.sort(list, function(a,b) return string.lower(a[1]) < string.lower(b[1]) end);
	return list;
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	-- Register slash command for IC/OOC status control.
	TRP3_API.slash.registerCommand({
		id = "status",
		helpLine = " " .. loc.SLASH_CMD_STATUS_USAGE,
		handler = function(subcommand)
			subcommand = string.trim(subcommand or "");

			if string.find(subcommand, "^%[") then
				subcommand = TRP3_AutomationUtil.ParseMacroOption(subcommand);
			end

			local currentUser = AddOn_TotalRP3.Player.GetCurrentUser();

			if subcommand == "ic" then
				currentUser:SetRoleplayStatus(TRP3_Enums.ROLEPLAY_STATUS.IN_CHARACTER);
			elseif subcommand == "ooc" then
				currentUser:SetRoleplayStatus(TRP3_Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER);
			elseif subcommand == "toggle" then
				TRP3_API.dashboard.switchStatus();
			else
				TRP3_API.utils.message.displayMessage(loc.SLASH_CMD_STATUS_HELP);
			end
		end,
	});

	if TRP3_API.toolbar then

		local Button_TRP3_Open = {
			id = "aa_trp3_a",
			icon = TRP3_InterfaceIcons.DirectorySection,
			configText = loc.LAUNCHER_ACTION_OPEN,
			tooltip = TRP3_API.globals.addon_name,
			tooltipSub = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.LAUNCHER_ACTION_OPEN),
			onClick = function() TRP3_API.navigation.switchMainFrame(); end,
			visible = 1
		}
		TRP3_API.toolbar.toolbarAddButton(Button_TRP3_Open);

		local updateToolbarButton = TRP3_API.toolbar.updateToolbarButton;
		-- away/dnd
		local status1Text = loc.TB_STATUS..": "..color("r")..loc.TB_DND_MODE;
		local status1SubText = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_GO_TO_MODE:format(loc.TB_NORMAL_MODE));
		local status2Text = loc.TB_STATUS..": "..color("o")..loc.TB_AFK_MODE;
		local status2SubText = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_GO_TO_MODE:format(loc.TB_NORMAL_MODE));
		local status3Text = loc.TB_STATUS..": "..color("g")..loc.TB_NORMAL_MODE;
		local status3SubText = TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.TB_GO_TO_MODE:format(loc.TB_AFK_MODE)) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TB_GO_TO_MODE:format(loc.TB_DND_MODE));
		local Button_Status = {
			id = "aa_trp3_d",
			icon = TRP3_InterfaceIcons.ModeNormal,
			configText = loc.CO_TOOLBAR_CONTENT_STATUS,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if Uibutton:IsMouseMotionFocus() then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if UnitIsDND("player") then
					buttonStructure.tooltip  = status1Text;
					buttonStructure.tooltipSub  = status1SubText;
					buttonStructure.icon = TRP3_InterfaceIcons.ModeDND;
				elseif UnitIsAFK("player") then
					buttonStructure.tooltip  = status2Text;
					buttonStructure.tooltipSub  = status2SubText;
					buttonStructure.icon = TRP3_InterfaceIcons.ModeAFK;
				else
					buttonStructure.tooltip  = status3Text;
					buttonStructure.tooltipSub  = status3SubText;
					buttonStructure.icon = TRP3_InterfaceIcons.ModeNormal;
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
				PlaySound(TRP3_InterfaceSounds.ButtonClick);
			end,
		};
		TRP3_API.toolbar.toolbarAddButton(Button_Status);

		-- Toolbar RP status
		local RP_ICON, OOC_ICON = TRP3_InterfaceIcons.ToolbarStatusIC, TRP3_InterfaceIcons.ToolbarStatusOOC;
		local rpTextOn = loc.TB_RPSTATUS_ON;
		local rpTextOff = loc.TB_RPSTATUS_OFF;
		local rpText2 = TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.TB_RPSTATUS_TO_ON) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TB_SWITCH_PROFILE);
		local rpText3 = TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.TB_RPSTATUS_TO_OFF) .. "\n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.TB_SWITCH_PROFILE);

		local Button_RPStatus = {
			id = "aa_trp3_rpstatus",
			icon = OOC_ICON,
			configText = loc.CO_TOOLBAR_CONTENT_RPSTATUS,
			onUpdate = function(Uibutton, buttonStructure)
				updateToolbarButton(Uibutton, buttonStructure);
				if Uibutton:IsMouseMotionFocus() then
					refreshTooltip(Uibutton);
				end
			end,
			onModelUpdate = function(buttonStructure)
				if AddOn_TotalRP3.Player.GetCurrentUser():IsInCharacter() then
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
					local currentProfileID = getPlayerCurrentProfileID();
					local profileList = getPlayerProfilesAsList(currentProfileID);

					TRP3_MenuUtil.CreateContextMenu(Uibutton, function(_, description)
						description:CreateTitle(loc.TB_SWITCH_PROFILE);

						-- Make the dropdown list have a scrollbar on mainline.
						if description.SetScrollMode then
							local optionHeight = 20; -- 20 is the default height.
							local maxLines = 20;
							local maxScrollExtent = optionHeight * maxLines;
							description:SetScrollMode(maxScrollExtent);
						end

						for _, profile in ipairs(profileList) do
							-- Current profile has nil profileID (profile[3])
							local icon = profile[2] or TRP3_InterfaceIcons.ProfileDefault;
							if profile[3] then
								description:CreateButton("|Tinterface\\icons\\" .. icon .. ":15|t " .. profile[1], profileSelected, profile[3]);
							else
								description:CreateButton("|Tinterface\\icons\\" .. icon .. ":15|t|cnGREEN_FONT_COLOR: " .. profile[1] .."|r");
							end
						end
					end);
				else
					TRP3_API.dashboard.switchStatus();
					PlaySound(TRP3_InterfaceSounds.ButtonClick);
				end
			end,
			onLeave = function()
				TRP3_MainTooltip:Hide();
			end,
			visible = 1
		};
		TRP3_API.toolbar.toolbarAddButton(Button_RPStatus);

		if not TRP3_ClientFeatures.Transmogrification then
			-- Show / hide helmet
			local helmetOffIcon = TRP3_InterfaceIcons.ToolbarHelmetOff;
			local helmetOnIcon = TRP3_InterfaceIcons.ToolbarHelmetOn;
			local helmTextOn = loc.TB_SWITCH_HELM_ON;
			local helmTextOff = loc.TB_SWITCH_HELM_OFF;
			local helmText2 = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_SWITCH_HELM_1);
			local helmText3 = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_SWITCH_HELM_2);

			local Button_Helmet = {
				id = "aa_trp3_b",
				icon = helmetOnIcon,
				configText = loc.CO_TOOLBAR_CONTENT_HELMET,
				onModelUpdate = function(buttonStructure)
					if ShowingHelm() then
						buttonStructure.tooltip  = helmTextOn;
						buttonStructure.tooltipSub = helmText3;
						local currentHelmetTexture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("HeadSlot")));
						buttonStructure.icon = currentHelmetTexture and currentHelmetTexture or helmetOnIcon;
					else
						buttonStructure.tooltip  = helmTextOff;
						buttonStructure.tooltipSub  = helmText2;
						buttonStructure.icon = helmetOffIcon;
					end
				end,
				onUpdate = function(Uibutton, buttonStructure)
					updateToolbarButton(Uibutton, buttonStructure);
					if Uibutton:IsMouseMotionFocus() then
						refreshTooltip(Uibutton);
					end
				end,
				onClick = function()
					if ShowingHelm() then
						ShowHelm(false);
						PlaySound(1202); -- Putdowncloth_Leather01
					else
						ShowHelm(true);
						PlaySound(1185); -- Pickupcloth_Leather01
					end
				end,
				onLeave = function()
					TRP3_MainTooltip:Hide();
				end,
			};
			TRP3_API.toolbar.toolbarAddButton(Button_Helmet);

			-- Show/hide cloak
			local cloakOnIcon = TRP3_InterfaceIcons.ToolbarCloakOff;
			local cloakOffIcon = TRP3_InterfaceIcons.ToolbarCloakOn;
			local capeTextOn =  loc.TB_SWITCH_CAPE_ON;
			local capeTextOff = loc.TB_SWITCH_CAPE_OFF;
			local capeText2 = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_SWITCH_CAPE_1);
			local capeText3 = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.TB_SWITCH_CAPE_2);
			local Button_Cape = {
				id = "aa_trp3_c",
				icon = cloakOnIcon,
				configText = loc.CO_TOOLBAR_CONTENT_CAPE,
				onModelUpdate = function(buttonStructure)
					if ShowingCloak() then
						buttonStructure.tooltip  = capeTextOn;
						buttonStructure.tooltipSub = capeText3;
						local currentCloakTexture = GetInventoryItemTexture("player", select(1, GetInventorySlotInfo("BackSlot")));
						buttonStructure.icon = currentCloakTexture and currentCloakTexture or cloakOnIcon;
					else
						buttonStructure.tooltip  = capeTextOff;
						buttonStructure.tooltipSub  = capeText2;
						buttonStructure.icon = cloakOffIcon;
					end
				end,
				onUpdate = function(Uibutton, buttonStructure)
					updateToolbarButton(Uibutton, buttonStructure);
					if Uibutton:IsMouseMotionFocus() then
						refreshTooltip(Uibutton);
					end
				end,
				onClick = function(_)
					if ShowingCloak() then
						ShowCloak(false);
						PlaySound(1202); -- Putdowncloth_Leather01
					else
						ShowCloak(true);
						PlaySound(1185); -- Pickupcloth_Leather01
					end
				end,
				onLeave = function()
					TRP3_MainTooltip:Hide();
				end,
			};
			TRP3_API.toolbar.toolbarAddButton(Button_Cape);
		end
	end

	TRP3_API.configuration.registerConfigKey("secret_party", false);
	TRP3_API.configuration.registerHandler("secret_party", function()
		if TRP3_API.configuration.getValue("secret_party") then
			TRP3_PartyTimeLeft:Show();
			TRP3_PartyTimeRight:Show();
		else
			TRP3_PartyTimeLeft:Hide();
			TRP3_PartyTimeRight:Hide();
		end
	end);
	TRP3_API.slash.registerCommand({
		id = "partytime",
		handler = function()
			local oldValue = TRP3_API.configuration.getValue("secret_party");
			TRP3_API.configuration.setValue("secret_party", oldValue == false);
		end,
	});
end);

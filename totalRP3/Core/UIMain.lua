-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Config
local displayMessage = TRP3_API.utils.message.displayMessage;
local CONFIG_MINIMAP_SHOW = "minimap_show";
local CONFIG_MINIMAP_POSITION = "minimap_icon_position";
local getConfigValue, registerConfigKey = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey;
local loc = TRP3_API.loc;
local tinsert = tinsert;

local LauncherConstants = {
	HideDragDropInstruction = true,
};

local function ProcessLauncherClick(buttonName)
	if buttonName == "RightButton" and TRP3_API.toolbar then
		TRP3_API.toolbar.switch();
	else
		TRP3_API.navigation.switchMainFrame();
	end
end

local function PopulateLauncherTooltip(tooltip, hideDragDropInstruction)
	tooltip:AddLine("Total RP 3", TRP3_API.Colors.White:GetRGB());
	tooltip:AddLine(TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.MM_SHOW_HIDE_MAIN));

	if TRP3_API.toolbar then
		tooltip:AddLine(TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.MM_SHOW_HIDE_SHORTCUT));
	end

	if not hideDragDropInstruction then
		tooltip:AddLine(TRP3_API.FormatShortcutWithInstruction("DRAGDROP", loc.MM_SHOW_HIDE_MOVE));
	end
end

function TRP3_OnAddonCompartmentClick(_, buttonName)
	ProcessLauncherClick(buttonName);
end

function TRP3_OnAddonCompartmentEnter()
	local tooltip = TRP3_MainTooltip;
	GameTooltip_SetDefaultAnchor(tooltip, UIParent);
	PopulateLauncherTooltip(tooltip, LauncherConstants.HideDragDropInstruction);
	tooltip:Show()
end

function TRP3_OnAddonCompartmentLeave()
	local tooltip = TRP3_MainTooltip;
	tooltip:Hide();
end

-- Minimap button API initialization
TRP3_API.navigation.minimapicon = {};

local LDBObject;
local icon;

-- Initialize LDBIcon and display the minimap button
local showMinimapButton = function()
	icon:Show("Total RP 3");
end
TRP3_API.navigation.minimapicon.show = showMinimapButton;

-- Hide the minimap button and release LDBIcon from the memory
local hideMinimapButton = function()
	icon:Hide("Total RP 3");
end
TRP3_API.navigation.minimapicon.hide = hideMinimapButton;

TRP3_API.navigation.delayedRefresh = function()
	C_Timer.After(0.25, function()
		TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());
	end);
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()


	registerConfigKey(CONFIG_MINIMAP_SHOW, true);
	registerConfigKey(CONFIG_MINIMAP_POSITION, {});

	-- Build configuration page
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_MINIMAP_BUTTON,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_MINIMAP_BUTTON_SHOW_TITLE,
		help = loc.CO_MINIMAP_BUTTON_SHOW_HELP,
		configKey = CONFIG_MINIMAP_SHOW,
	});

	TRP3_API.configuration.registerHandler(CONFIG_MINIMAP_SHOW, function()
		if getConfigValue(CONFIG_MINIMAP_SHOW) then
			showMinimapButton();
		else
			hideMinimapButton();
		end
	end);

	LDBObject = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Total RP 3", {
		type = "launcher",
		icon = "Interface\\AddOns\\totalRP3\\resources\\trp3minimap.tga",
		tocname = "totalRP3",
		OnClick = function(_, buttonName)
			ProcessLauncherClick(buttonName);
		end,
		OnTooltipShow = function(tooltip)
			PopulateLauncherTooltip(tooltip);
		end,
	})

	icon = LibStub("LibDBIcon-1.0");
	icon:SetButtonRadius(10)
	local configKey = getConfigValue(CONFIG_MINIMAP_POSITION);
	configKey.hide = not getConfigValue(CONFIG_MINIMAP_SHOW);
	icon:Register("Total RP 3", LDBObject, getConfigValue(CONFIG_MINIMAP_POSITION));

	-- Slash command to switch frames
	TRP3_API.slash.registerCommand({
		id = "switch",
		helpLine = " main || toolbar",
		handler = function(arg1)
			if arg1 ~= "main" and arg1 ~= "toolbar" then
				displayMessage(loc.COM_SWITCH_USAGE);
			elseif arg1 == "main" then
				TRP3_API.navigation.switchMainFrame();
			else
				if TRP3_API.toolbar then
					TRP3_API.toolbar.switch();
				end
			end
		end
	});

	-- Slash command to reset frames
	TRP3_API.slash.registerCommand({
		id = "reset",
		helpLine = " frames",
		handler = function(arg1)
			if arg1 ~= "frames" then
				displayMessage(loc.COM_RESET_USAGE);
			else
				-- Target frame
				if TRP3_API.target then
					TRP3_API.target.reset();
				end
				-- Glance bar
				if TRP3_API.register.resetGlanceBar then
					TRP3_API.register.resetGlanceBar();
				end
				-- Toolbar
				if TRP3_API.toolbar then
					TRP3_API.toolbar.reset();
				end
				ReloadUI();
			end
		end
	});

	-- Resizing
	TRP3_MainFrame.Resize.onResizeStop = function(width, height)
		TRP3_MainFrame:ResizeWindow(width, height);
	end;

	TRP3_MainFrame.Maximize:SetScript("OnClick", function()
		TRP3_MainFrame:MaximizeWindow();
		TRP3_API.navigation.delayedRefresh();
	end);

	TRP3_MainFrame.Minimize:SetScript("OnClick", function()
		TRP3_MainFrame:RestoreWindow();
		TRP3_API.navigation.delayedRefresh();
	end);

	TRP3_API.ui.frame.setupMove(TRP3_MainFrame);

	-- Update frame
	TRP3_UpdateFrame.popup.title:SetText(loc.NEW_VERSION_TITLE);

	BINDING_NAME_TRP3_TOGGLE = loc.BINDING_NAME_TRP3_TOGGLE;
	BINDING_NAME_TRP3_TOOLBAR_TOGGLE = loc.BINDING_NAME_TRP3_TOOLBAR_TOGGLE;
	BINDING_NAME_TRP3_OPEN_TARGET_PROFILE = loc.BINDING_NAME_TRP3_OPEN_TARGET_PROFILE;
	BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS = loc.BINDING_NAME_TRP3_TOGGLE_CHARACTER_STATUS;
end);

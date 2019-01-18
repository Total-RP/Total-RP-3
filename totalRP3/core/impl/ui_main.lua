----------------------------------------------------------------------------------
--- Total RP 3
--- Main UI API and Widgets API
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

local Ellyb = Ellyb:GetInstance(...);

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
		TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());
	end);
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()


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
		OnClick = function(_, button)
			if button == "RightButton" and TRP3_API.toolbar then
				TRP3_API.toolbar.switch();
			else
				TRP3_API.navigation.switchMainFrame();
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine("Total RP 3", Ellyb.ColorManager.WHITE:GetRGB());
			tooltip:AddLine(Ellyb.Strings.clickInstruction(loc.CM_L_CLICK, loc.MM_SHOW_HIDE_MAIN));
			if TRP3_API.toolbar then
				tooltip:AddLine(Ellyb.Strings.clickInstruction(loc.CM_R_CLICK, loc.MM_SHOW_HIDE_SHORTCUT));
			end
			tooltip:AddLine(Ellyb.Strings.clickInstruction(loc.CM_DRAGDROP, loc.MM_SHOW_HIDE_MOVE));
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
	TRP3_MainFrame.Resize.onResizeStop = function()
		TRP3_MainFrame.Minimize:Hide();
		TRP3_MainFrame.Maximize:Show();
		TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());
	end;

	TRP3_MainFrame.Maximize:SetScript("OnClick", function()
		TRP3_MainFrame.Maximize:Hide();
		TRP3_MainFrame.Minimize:Show();
		TRP3_MainFrame:SetSize(UIParent:GetWidth(), UIParent:GetHeight());
		C_Timer.After(0.25, function()
			TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());
		end);
	end);

	TRP3_MainFrame.Minimize:SetScript("OnClick", function()
		TRP3_MainFrame:SetSize(768, 500);
		C_Timer.After(0.25, function()
			TRP3_MainFrame.Resize.onResizeStop();
		end);
	end);

	TRP3_API.ui.frame.setupMove(TRP3_MainFrame);

	-- Update frame
	TRP3_UpdateFrame.popup.title:SetText(loc.NEW_VERSION_TITLE);

	BINDING_NAME_TRP3_TOGGLE = loc.BINDING_NAME_TRP3_TOGGLE;
	BINDING_NAME_TRP3_TOOLBAR_TOGGLE = loc.BINDING_NAME_TRP3_TOOLBAR_TOGGLE;
end);

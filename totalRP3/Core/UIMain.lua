-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

function TRP3_API.navigation.delayedRefresh()
	C_Timer.After(0.25, function()
		TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());
	end);
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	-- Slash command to switch frames
	TRP3_API.slash.registerCommand({
		id = "switch",
		helpLine = " main || toolbar",
		handler = function(arg1)
			if arg1 ~= "main" and arg1 ~= "toolbar" then
				TRP3_Addon:Print(L.COM_SWITCH_USAGE);
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
				TRP3_Addon:Print(L.COM_RESET_USAGE);
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
	TRP3_UpdateFrame.popup.title:SetText(L.NEW_VERSION_TITLE);
end);

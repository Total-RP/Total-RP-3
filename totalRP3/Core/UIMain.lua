-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3.loc;

function TRP3.navigation.delayedRefresh()
	C_Timer.After(0.25, function()
		TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_RESIZED, TRP3_MainFramePageContainer:GetWidth(), TRP3_MainFramePageContainer:GetHeight());
	end);
end

TRP3.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	-- Slash command to switch frames
	TRP3.slash.registerCommand({
		id = "switch",
		helpLine = " main || toolbar",
		handler = function(arg1)
			if arg1 ~= "main" and arg1 ~= "toolbar" then
				TRP3_Addon:Print(L.COM_SWITCH_USAGE);
			elseif arg1 == "main" then
				TRP3.navigation.switchMainFrame();
			else
				if TRP3.toolbar then
					TRP3.toolbar.switch();
				end
			end
		end
	});

	-- Slash command to reset frames
	TRP3.slash.registerCommand({
		id = "reset",
		helpLine = " frames",
		handler = function(arg1)
			if arg1 ~= "frames" then
				TRP3_Addon:Print(L.COM_RESET_USAGE);
			else
				-- Target frame
				if TRP3.target then
					TRP3.target.reset();
				end
				-- Glance bar
				if TRP3.register.resetGlanceBar then
					TRP3.register.resetGlanceBar();
				end
				-- Toolbar
				if TRP3.toolbar then
					TRP3.toolbar.reset();
				end
				ReloadUI();
			end
		end
	});

	-- Update frame
	TRP3_UpdateFrame.popup.title:SetText(L.NEW_VERSION_TITLE);
end);

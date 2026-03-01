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
			if arg1 then
				arg1 = string.lower(arg1);
			end
			TRP3_Addon:TriggerEvent(TRP3_Addon.Events.RESET_FRAME_POSITION, arg1);
		end
	});

	-- Update frame
	TRP3_UpdateFrame.popup.title:SetText(L.NEW_VERSION_TITLE);
end);

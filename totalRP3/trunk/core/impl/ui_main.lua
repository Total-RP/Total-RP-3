----------------------------------------------------------------------------------
-- Total RP 3
-- Main UI API and Widgets API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Config
local Utils = TRP3_API.utils;
local displayMessage = TRP3_API.utils.message.displayMessage;
local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;
local math, GetCursorPosition, Minimap, UIParent, cos, sin, strconcat = math, GetCursorPosition, Minimap, UIParent, cos, sin, strconcat;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local color, loc, tinsert, _G = TRP3_API.utils.str.color, TRP3_API.locale.getText, tinsert, _G;
local CONFIG_MINIMAP_FRAME, CONFIG_MINIMAP_X, CONFIG_MINIMAP_Y, CONFIG_MINIMAP_LOCK = "minimap_frame", "minimap_x", "minimap_y", "minimap_lock";
local minimapButton;

local function getParentFrame()
	return _G[getConfigValue(CONFIG_MINIMAP_FRAME)] or Minimap;
end

-- Reposition the minimap button using the config values
local function minimapButton_Reposition()
	local parentFrame = getParentFrame();
	local parentScale = UIParent:GetEffectiveScale();
	minimapButton:SetParent(parentFrame);
	minimapButton:ClearAllPoints();
	minimapButton:SetPoint("CENTER", parentFrame, "BOTTOMLEFT", getConfigValue(CONFIG_MINIMAP_X) / parentScale, getConfigValue(CONFIG_MINIMAP_Y) / parentScale);
end

-- Function called when the minimap icon is dragged
local function minimapButton_DraggingFrame_OnUpdate(self)
	if not getConfigValue(CONFIG_MINIMAP_LOCK) and self.isDraging then
		local parentFrame = getParentFrame();
		local scaleFactor = UIParent:GetEffectiveScale();
		local xpos, ypos = GetCursorPosition();
		local xmin, ymin = parentFrame:GetLeft(), parentFrame:GetBottom();

		xpos = xpos - xmin * scaleFactor;
		ypos = ypos - ymin * scaleFactor;

		-- Setting the minimap coordinates
		setConfigValue(CONFIG_MINIMAP_X, xpos);
		setConfigValue(CONFIG_MINIMAP_Y, ypos);

		minimapButton_Reposition();
	end
end

local function resetPosition()
	setConfigValue(CONFIG_MINIMAP_X, 0);
	setConfigValue(CONFIG_MINIMAP_Y, 0);
	minimapButton_Reposition();
end

-- Initialize the minimap icon button
TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	local toggleMainPane = TRP3_API.navigation.switchMainFrame;
	minimapButton = TRP3_MinimapButton;

	registerConfigKey(CONFIG_MINIMAP_FRAME, "Minimap");
	registerConfigKey(CONFIG_MINIMAP_LOCK, false);
	registerConfigKey(CONFIG_MINIMAP_X, 22);
	registerConfigKey(CONFIG_MINIMAP_Y, 5);
	
	registerConfigHandler(CONFIG_MINIMAP_FRAME, function()
		minimapButton_Reposition();
	end);

	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_MINIMAP_BUTTON"),
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigEditBox",
		title = loc("CO_MINIMAP_BUTTON_FRAME"),
		help = loc("CO_MINIMAP_BUTTON_FRAME_TT"),
		configKey = CONFIG_MINIMAP_FRAME,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc("CO_MINIMAP_BUTTON_LOCK"),
		help = loc("CO_MINIMAP_BUTTON_LOCK_TT"),
		configKey = CONFIG_MINIMAP_LOCK,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigButton",
		title = loc("CO_MINIMAP_BUTTON_RESET"),
		help = loc("CO_MINIMAP_BUTTON_RESET_TT"),
		text = loc("CO_MINIMAP_BUTTON_RESET_BUTTON"),
		callback = resetPosition,
	});

	minimapButton:SetScript("OnUpdate", minimapButton_DraggingFrame_OnUpdate);
	minimapButton:SetScript("OnClick", function(self, button)
		if button == "RightButton" and TRP3_API.toolbar then
			TRP3_API.toolbar.switch();
		else
			toggleMainPane();
		end
	end);

	minimapButton_Reposition();

	local minimapTooltip = strconcat(color("y"), loc("CM_L_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_MAIN"));
	if TRP3_API.toolbar then
		minimapTooltip = strconcat(minimapTooltip, "\n", color("y"), loc("CM_R_CLICK"), ": ", color("w"), loc("MM_SHOW_HIDE_SHORTCUT"));
	end
	minimapTooltip = strconcat(minimapTooltip, "\n", color("y"), loc("CM_DRAGDROP"), ": ", color("w"), loc("MM_SHOW_HIDE_MOVE"));
	setTooltipAll(minimapButton, "BOTTOMLEFT", 0, 0, "Total RP 3", minimapTooltip);

	-- Slash command to switch frames
	TRP3_API.slash.registerCommand({
		id = "switch",
		helpLine = " main || toolbar",
		handler = function(arg1)
			if arg1 ~= "main" and arg1 ~= "toolbar" then
				displayMessage(loc("COM_SWITCH_USAGE"));
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
				displayMessage(loc("COM_RESET_USAGE"));
			else
				-- Minimap button
				setConfigValue(CONFIG_MINIMAP_FRAME, "Minimap");
				setConfigValue(CONFIG_MINIMAP_LOCK, false);
				setConfigValue(CONFIG_MINIMAP_X, 22);
				setConfigValue(CONFIG_MINIMAP_Y, 5);
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
end);

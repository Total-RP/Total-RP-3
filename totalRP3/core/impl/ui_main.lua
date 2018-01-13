----------------------------------------------------------------------------------
-- Total RP 3
-- Main UI API and Widgets API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--  Copyright 2014 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
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

local Ellyb = Ellyb:GetInstance(...);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Config
local displayMessage = TRP3_API.utils.message.displayMessage;
local CONFIG_MINIMAP_SHOW = "minimap_show";
local CONFIG_MINIMAP_POSITION = "minimap_icon_position";
local getConfigValue, registerConfigKey = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey;
local color, loc, strconcat = TRP3_API.utils.str.color, TRP3_API.locale.getText, strconcat;
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
		title = loc("CO_MINIMAP_BUTTON"),
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc("CO_MINIMAP_BUTTON_SHOW_TITLE"),
		help = loc("CO_MINIMAP_BUTTON_SHOW_HELP"),
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
			tooltip:AddLine("Total RP 3");
			tooltip:AddLine(Ellyb.Strings.clickInstruction(loc("CM_L_CLICK"), loc("MM_SHOW_HIDE_MAIN")));
			if TRP3_API.toolbar then
				tooltip:AddLine(Ellyb.Strings.clickInstruction(loc("CM_R_CLICK"), loc("MM_SHOW_HIDE_SHORTCUT")));
			end
			tooltip:AddLine(Ellyb.Strings.clickInstruction(loc("CM_DRAGDROP"), loc("MM_SHOW_HIDE_MOVE")));
		end,
	})

	icon = LibStub("LibDBIcon-1.0");
	local configKey = getConfigValue(CONFIG_MINIMAP_POSITION);
	configKey.hide = not getConfigValue(CONFIG_MINIMAP_SHOW);
	icon:Register("Total RP 3", LDBObject, getConfigValue(CONFIG_MINIMAP_POSITION));

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
	TRP3_UpdateFrame.popup.title:SetText(loc("NEW_VERSION_TITLE"));

	BINDING_NAME_TRP3_TOGGLE = loc("BINDING_NAME_TRP3_TOGGLE");
	BINDING_NAME_TRP3_TOOLBAR_TOGGLE = loc("BINDING_NAME_TRP3_TOOLBAR_TOGGLE");

	-- CTL debug frame
	local tostring, GetTime, pairs, type = tostring, GetTime, pairs, type;
	local toHTML =TRP3_API.utils.str.toHTML;
	local ctl = ChatThrottleLib;
	local ctlFrame = TRP3_CTLDebug;
	local ctlHTML = ctlFrame.scroll.child.HTML;
	local ctlHTML2 = ctlFrame.scroll.child.HTML2;
	TRP3_API.ui.frame.createRefreshOnFrame(ctlFrame, 0.2, function()
		local html = [[
## CTL Network

### Config

MAX_CPS = %s
MSG_OVERHEAD = %s
BURST = %s
MIN_FPS = %s

### Current state

securelyHooked = %s

|cffff9900Available bytes|r
avail = %0.2f bytes
LastAvailUpdate = %0.2f seconds ago

|cffff9900Queuing or choking info|r
bChoking = %s
bQueueing = %s

|cffff9900External traffic (not with CTL)|r
- nTotalSent = %s bytes
- nBypass = %s bytes

### Queues

ALERT:
-- nTotalSent = %s bytes
-- %s

NORMAL:
-- nTotalSent = %s bytes
-- %s

BULK:
-- nTotalSent = %s bytes
-- %s
]];

		local formatRing = function(ring)
			if ring.pos then
				local str = "Pipes in ring:\n"
				local size = 0;
				for index, msg in pairs(ring.pos) do
					if type(index) == "number" then
						size = size + (msg.nSize or 0);
					end
				end
				str = str .. ("----- #%s bytes\n"):format(size);
				return str;
			else
				return "No pipe in ring";
			end
		end

		html = html:format(
			tostring(ctl.MAX_CPS or "nil"),
			tostring(ctl.MSG_OVERHEAD or "nil"),
			tostring(ctl.BURST or "nil"),
			tostring(ctl.MIN_FPS or "nil"),
			tostring(ctl.securelyHooked or "nil"),
			tostring(ctl.avail or "nil"),
			ctl.LastAvailUpdate and (GetTime() - ctl.LastAvailUpdate) or 'nil',
			tostring(ctl.bChoking or "nil"),
			tostring(ctl.bQueueing or "nil"),
			tostring(ctl.nTotalSent or "nil"),
			tostring(ctl.nBypass or "nil"),

			-- Queues
			tostring(ctl.Prio.ALERT.nTotalSent or "nil"),
			tostring(formatRing(ctl.Prio.ALERT.Ring)),

			tostring(ctl.Prio.NORMAL.nTotalSent or "nil"),
			tostring(formatRing(ctl.Prio.NORMAL.Ring)),

			tostring(ctl.Prio.BULK.nTotalSent or "nil"),
			tostring(formatRing(ctl.Prio.BULK.Ring))


		);
		ctlHTML:SetText(toHTML(html));

		local hasNYR = "";
		for id, s in pairs(TRP3_API.register.HAS_NOT_YET_RESPONDED) do
			local duration = GetTime() - s;
			local character;
			if TRP3_API.register.isUnitIDKnown(id) then
				character = TRP3_API.register.getUnitIDCharacter(id);
			end
			if duration > 300 then
				-- Consider he has not TRP or MRP
				TRP3_API.register.HAS_NOT_YET_RESPONDED[id] = nil;
			else
				local text = ("\n- |cffff9900%s |cff00ff00(%s - %s)|r since %0.2f sec"):format(id,
					character and character.client or "?",
					character and character.clientVersion or "?",
					GetTime() - s);
				hasNYR = hasNYR .. text;
			end
		end
		if hasNYR:len() == 0 then
			hasNYR = "No current request";
		end

		local incoming = "";
		for unit, infos in pairs(TRP3_API.register.CURRENT_QUERY_EXCHANGES) do
			local infoString = "";
			for type, _ in pairs(infos) do
				infoString = infoString .. type .. " ";
			end
			if infoString:len() > 0 then
				incoming = incoming .. ("\n- |cffff9900%s|r: %s"):format(unit, infoString);
			end
		end
		if incoming:len() == 0 then
			incoming = "No incoming data";
		end

		html = [[
## TRP Network

Total sent: %s bytes
Total received: %s bytes

Total sent (broadcast): %s bytes
Total received (broadcast): %s bytes
Total sent (broadcast P2P): %s bytes
Total received (broadcast P2P): %s bytes

Deserialisation errors: %s

|cffff9900Response times|r
Min: %0.2f secondes
Max: %0.2f seconds
Average: %0.2f seconds

|cffff9900Not yet responded:|r %s

|cffff9900Incoming TRP3 data:|r %s
]]
		html = html:format(
			tostring(TRP3_API.communication.total),
			tostring(TRP3_API.communication.totalReceived),
			tostring(TRP3_API.communication.totalBroadcast),
			tostring(TRP3_API.communication.totalBroadcastR),
			tostring(TRP3_API.communication.totalBroadcastP2P),
			tostring(TRP3_API.communication.totalBroadcastP2PR),
			tostring(TRP3_API.utils.serial.errorCount),
			TRP3_API.communication.min,
			TRP3_API.communication.max,
			TRP3_API.communication.totalDuration / TRP3_API.communication.numStat,
			hasNYR,
			incoming
		);
		ctlHTML2:SetText(toHTML(html));

	end);

	ctlFrame.Resize.onResizeStop = function()
		local available = ctlFrame:GetWidth() - 100;
		ctlHTML2:SetWidth(available - ctlHTML:GetWidth());
	end;
	ctlFrame.Resize.onResizeStop();

	TRP3_API.slash.registerCommand({
		id = "debug",
		helpLine = " Debug network",
		handler = function()
			ctlFrame:Show();
		end
	});
	TRP3_API.ui.frame.setupMove(ctlFrame);
end);
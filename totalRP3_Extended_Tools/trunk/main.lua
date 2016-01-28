----------------------------------------------------------------------------------
-- Total RP 3: Extended features
--	---------------------------------------------------------------------------
--	Copyright 2015 Sylvain Cossement (telkostrasz@totalrp3.info)
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

local Globals, Events, Utils = TRP3_API.globals, TRP3_API.events, TRP3_API.utils;
local pairs, assert, tostring = pairs, assert, tostring;
local EMPTY = TRP3_API.globals.empty;
local Log = Utils.log;
local fireEvent = TRP3_API.events.fireEvent;
local after  = C_Timer.After;

local ToolFrame = TRP3_ToolFrame;

TRP3_API.extended.tools = {};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local BACKGROUNDS = {
	"Interface\\ENCOUNTERJOURNAL\\UI-EJ-Classic",
	"Interface\\ENCOUNTERJOURNAL\\UI-EJ-BurningCrusade",
	"Interface\\ENCOUNTERJOURNAL\\UI-EJ-WrathoftheLichKing",
	"Interface\\ENCOUNTERJOURNAL\\UI-EJ-CATACLYSM",
	"Interface\\ENCOUNTERJOURNAL\\UI-EJ-MistsofPandaria",
	"Interface\\ENCOUNTERJOURNAL\\UI-EJ-WarlordsofDraenor",
}

function TRP3_API.extended.tools.setBackground(backgroundIndex)
	assert(BACKGROUNDS[backgroundIndex], "Unknown background index:" .. tostring(backgroundIndex));
	local texture = BACKGROUNDS[backgroundIndex];
	ToolFrame.BkgMain:SetTexture(texture);
	ToolFrame.BkgHeader:SetTexture(texture);
	ToolFrame.BkgScroll:SetTexture(texture);
end
local setBackground = TRP3_API.extended.tools.setBackground;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function goToListPage(skipButton)
	if not skipButton then
		NavBar_Reset(ToolFrame.navBar);
	end
	setBackground(1);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.extended.tools.showFrame(reset)
	ToolFrame:Show();
	if reset then
		goToListPage();
	end
end

local function onStart()
	ToolFrame.Close:SetScript("OnClick", function(self) self:GetParent():Hide(); end);

	TRP3_API.events.NAVIGATION_EXTENDED_RESIZED = "NAVIGATION_EXTENDED_RESIZED";
	TRP3_API.events.registerEvent(TRP3_API.events.NAVIGATION_EXTENDED_RESIZED);

	ToolFrame.Resize.minWidth = 1150;
	ToolFrame.Resize.minHeight = 730;
	ToolFrame:SetSize(ToolFrame.Resize.minWidth, ToolFrame.Resize.minHeight);
	ToolFrame.Resize.resizableFrame = ToolFrame;
	ToolFrame.Resize.onResizeStop = function()
		ToolFrame.Minimize:Hide();
		ToolFrame.Maximize:Show();
		fireEvent(TRP3_API.events.NAVIGATION_EXTENDED_RESIZED, ToolFrame:GetWidth(), ToolFrame:GetHeight());
	end;

	ToolFrame.Maximize:SetScript("OnClick", function()
		ToolFrame.Maximize:Hide();
		ToolFrame.Minimize:Show();
		ToolFrame:SetSize(UIParent:GetWidth(), UIParent:GetHeight());
		after(0.1, function()
			fireEvent(TRP3_API.events.NAVIGATION_EXTENDED_RESIZED, ToolFrame:GetWidth(), ToolFrame:GetHeight());
		end);
	end);

	ToolFrame.Minimize:SetScript("OnClick", function()
		ToolFrame:SetSize(ToolFrame.Resize.minWidth, ToolFrame.Resize.minHeight);
		after(0.1, function()
			ToolFrame.Resize.onResizeStop();
		end);
	end);

	-- Tab bar init
	local homeData = {
		name = "Creation list",
		OnClick = function()
			goToListPage();
		end
	}
	ToolFrame.navBar.home:SetWidth(110);
	NavBar_Initialize(ToolFrame.navBar, "NavButtonTemplate", homeData, ToolFrame.navBar.home, ToolFrame.navBar.overflow);

	goToListPage();
end

local MODULE_STRUCTURE = {
	["name"] = "Extended Tools",
	["description"] = "Total RP 3 extended tools: item, document and campaign creation.",
	["version"] = 1.000,
	["id"] = "trp3_extended_tools",
	["onStart"] = onStart,
	["minVersion"] = 12,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
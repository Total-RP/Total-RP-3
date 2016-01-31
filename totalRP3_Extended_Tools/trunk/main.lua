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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- API
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.extended.tools = {};

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

local TYPE_LOCALE = { -- TODO: locals
	[TRP3_DB.types.CAMPAIGN] = "Campaign",
	[TRP3_DB.types.QUEST] = "Quest",
	[TRP3_DB.types.QUEST_STEP] = "Quest step",
	[TRP3_DB.types.ITEM] = "Item",
	[TRP3_DB.types.LOOT] = "Loot",
	[TRP3_DB.types.DOCUMENT] = "Document",
	[TRP3_DB.types.DIALOG] = "Dialog",
}
local function getTypeLocale(type)
	if TYPE_LOCALE[type] then
		return TYPE_LOCALE[type];
	end
	return UNKOWN;
end
TRP3_API.extended.tools.getTypeLocale = getTypeLocale;

local function getClassDataSafeByType(class)
	if class.TY == TRP3_DB.types.CAMPAIGN or class.TY == TRP3_DB.types.QUEST or class.TY == TRP3_DB.types.ITEM or class.TY == TRP3_DB.types.DOCUMENT then
		return TRP3_API.extended.getClassDataSafe(class);
	end
	if class.TY == TRP3_DB.types.QUEST_STEP then
		return "inv_inscription_scroll", (class.TX or ""):gsub("\n", ""):sub(1, 70) .. "...";
	end
	if class.TY == TRP3_DB.types.DIALOG then
		return "ability_warrior_rallyingcry", (class.ST[1].TX or ""):gsub("\n", ""):sub(1, 70) .. "...";
	end
	if class.TY == TRP3_DB.types.LOOT then
		return "inv_misc_coinbag_special", class.NA or "";
	end
end
TRP3_API.extended.tools.getClassDataSafeByType = getClassDataSafeByType;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Pages
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local getFullID, getClass = TRP3_API.extended.getFullID, TRP3_API.extended.getClass;

local function goToListPage(skipButton)
	if not skipButton then
		NavBar_Reset(ToolFrame.navBar);
	end
	setBackground(1);
	TRP3_API.extended.tools.toList();
end

local PAGE_BY_TYPE = {
	[TRP3_DB.types.CAMPAIGN] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Campaign: " .. id; -- TODO: locals
		end,
		background = 2,
	},
	[TRP3_DB.types.QUEST] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Quest: " .. id; -- TODO: locals
		end,
		background = 2,
	},
	[TRP3_DB.types.QUEST_STEP] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Quest step: " .. id; -- TODO: locals
		end,
		background = 2,
	},
	[TRP3_DB.types.ITEM] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Item: " .. id; -- TODO: locals
		end,
		background = 3,
	},
	[TRP3_DB.types.DOCUMENT] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Document: " .. id; -- TODO: locals
		end,
		background = 4,
	},
	[TRP3_DB.types.DIALOG] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Dialog: " .. id; -- TODO: locals
		end,
		background = 5,
	},
	[TRP3_DB.types.LOOT] = {
		frame = nil,
		tabTextGetter = function(id)
			return "Loot: " .. id; -- TODO: locals
		end,
		background = 6,
	},
}

local function goToPage(classID)
	-- Ensure buttons up to the target
	NavBar_Reset(ToolFrame.navBar);
	local parts = {strsplit(TRP3_API.extended.ID_SEPARATOR, classID)};
	local fullId = "";
	for _, part in pairs(parts) do
		fullId = getFullID(fullId, part);
		local reconstruct = fullId;
		local class = getClass(reconstruct);
		local text = PAGE_BY_TYPE[class.TY].tabTextGetter(part);
		NavBar_AddButton(ToolFrame.navBar, {id = reconstruct, name = text, OnClick = function(self)
			goToPage(reconstruct);
		end});
	end

	-- Go to page
	ToolFrame.list:Hide();
	local class = getClass(classID);
	for classType, pageData in pairs(PAGE_BY_TYPE) do
		if class.TY ~= classType then
			if pageData.frame then
				pageData.frame:Hide();
			end
		else
			if pageData.frame then
				pageData.frame:Show();
			end
			setBackground(pageData.background or 1);
		end
	end
end
TRP3_API.extended.tools.goToPage = goToPage;

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
		name = "Database", -- TODO: locale
		OnClick = function()
			goToListPage();
		end
	}
	ToolFrame.navBar.home:SetWidth(110);
	NavBar_Initialize(ToolFrame.navBar, "NavButtonTemplate", homeData, ToolFrame.navBar.home, ToolFrame.navBar.overflow);

	-- Init tabs
	TRP3_API.extended.tools.initList();

	goToListPage();

	TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_EXTENDED_RESIZED, ToolFrame:GetWidth(), ToolFrame:GetHeight());
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
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
local wipe, pairs, strsplit, tinsert, table = wipe, pairs, strsplit, tinsert, table;
local tsize = Utils.table.size;
local getClass = TRP3_API.extended.getClass;
local getTypeLocale = TRP3_API.extended.tools.getTypeLocale;
local loc = TRP3_API.locale.getText;

local ToolFrame = TRP3_ToolFrame;
local ID_SEPARATOR = TRP3_API.extended.ID_SEPARATOR;
local DB = TRP3_DB.global;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local refresh;
local linesWidget = {};
local idData = {};
local idList = {};
local LINE_TOP_MARGIN = 25;
local LEFT_DEPTH_STEP_MARGIN = 30;

local function objectHasChildren(class)
	if class then
		if class.IN and tsize(class.IN) > 0 then
			return true;
		end
		if class.TY == TRP3_DB.types.CAMPAIGN and class.QE and tsize(class.QE) > 0 then
			return true;
		end
		if class.TY == TRP3_DB.types.QUEST and class.ST and tsize(class.ST) > 0 then
			return true;
		end
	end
	return false;
end

local function isFirstLevelChild(parentID, childID)
	return childID ~= parentID and childID:sub(1, parentID:len()) == parentID and not childID:sub(parentID:len() + 2):find("%s");
end

local function addChildrenToPool(parentID)
	for objectID, _ in pairs(DB) do
		if isFirstLevelChild(parentID, objectID) then
			tinsert(idList, objectID);
		end
	end
	refresh();
end

local function removeChildrenFromPool(parentID)
	for objectID, _ in pairs(DB) do
		if objectID ~= parentID and objectID:sub(1, parentID:len()) == parentID then
			Utils.table.remove(idList, objectID);
		end
	end
	refresh();
end

function refresh()
	for _, lineWidget in pairs(linesWidget) do
		lineWidget:Hide();
	end

	table.sort(idList);
	wipe(idData);
	for index, objectID in pairs(idList) do
		local class = getClass(objectID);
		local parts = {strsplit(ID_SEPARATOR, objectID)};
		local depth = #parts;
		local isOpen = idList[index + 1] and idList[index + 1]:sub(1, objectID:len()) == objectID;
		local hasChildren = isOpen or objectHasChildren(class);
		local icon, name, description = TRP3_API.extended.tools.getClassDataSafeByType(class);

		idData[index] = {
			type = class.TY,
			icon = icon,
			text = name,
			text2 = description,
			depth = depth,
			ID = parts[#parts],
			fullID = objectID,
			isOpen = isOpen,
			hasChildren = hasChildren,
		}

	end

	for index, idData in pairs(idData) do

		local lineWidget = linesWidget[index];
		if not lineWidget then
			lineWidget = CreateFrame("Frame", "TRP3_ToolFrameListLine" .. index, ToolFrame.list.scroll.child, "TRP3_Tools_ListLineTemplate");
			tinsert(linesWidget, lineWidget);
		end

		lineWidget.Text:SetText(("|cff00ff00%s: |r\"%s|r\" |cff00ffff(ID: %s)"):format(getTypeLocale(idData.type), idData.text, idData.ID));

		lineWidget.Expand:Hide();
		if idData.hasChildren then
			lineWidget.Expand:Show();
			lineWidget.Expand:SetScript("OnClick", function(self)
				if not self.isOpen then
					addChildrenToPool(idData.fullID);
				else
					removeChildrenFromPool(idData.fullID);
				end
			end);
			lineWidget.Expand.isOpen = idData.isOpen;
			if idData.isOpen then
				lineWidget.Expand:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP");
				lineWidget.Expand:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN");
			else
				lineWidget.Expand:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
				lineWidget.Expand:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
			end
		end

		lineWidget:ClearAllPoints();
		lineWidget:SetPoint("LEFT", LEFT_DEPTH_STEP_MARGIN * (idData.depth - 1), 0);
		lineWidget:SetPoint("RIGHT", -15, 0);
		lineWidget:SetPoint("TOP", 0, (-LINE_TOP_MARGIN) * (index - 1));

		local fullID = idData.fullID;
		lineWidget.Click:SetScript("OnClick", function(self)
			TRP3_API.extended.tools.goToPage(fullID);
		end);

		lineWidget:Show();
	end
end

function TRP3_API.extended.tools.toList()
	-- Here we will filter
	wipe(idList);

	for objectID, _ in pairs(DB) do
		if not objectID:find("%s") then -- Only take the first level objects
			tinsert(idList, objectID);
		end
	end

	ToolFrame.list:Show();
	refresh();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.extended.tools.initList()
	TRP3_API.ui.frame.setupFieldPanel(ToolFrame.list, "Full database", 150); -- TODO: locals

	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_EXTENDED_RESIZED, function(containerwidth, containerHeight)
		ToolFrame.list.scroll.child:SetWidth(containerwidth - 75);
	end);

	-- Quest log button on target bar
	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
		if TRP3_API.toolbar then
			local toolbarButton = {
				id = "bb_extended_tools",
				icon = "Inv_gizmo_01",
				configText = "Open Extended tools", -- TODO: locals
				tooltip = "Open Extended tools", -- TODO: locals
				tooltipSub = "Create your own items and quests.", -- TODO: locals
				onClick = function()
					TRP3_API.extended.tools.showFrame(true);
				end,
				visible = 1
			};
			TRP3_API.toolbar.toolbarAddButton(toolbarButton);
		end
	end);
end
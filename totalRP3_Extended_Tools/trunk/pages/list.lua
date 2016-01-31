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

local wipe, pairs, strsplit, tinsert, table = wipe, pairs, strsplit, tinsert, table;
local getClass = TRP3_API.extended.getClass;
local getTypeLocale = TRP3_API.extended.tools.getTypeLocale;

local ToolFrame = TRP3_ToolFrame;
local ID_SEPARATOR = TRP3_API.extended.ID_SEPARATOR;
local DB = TRP3_DB.global;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local linesWidget = {};
local idData = {};
local idList = {};
local LINE_TOP_MARGIN = 25;
local LEFT_DEPTH_STEP_MARGIN = 30;

local function refresh(idList)
	for _, lineWidget in pairs(linesWidget) do
		lineWidget:Hide();
	end

	table.sort(idList);
	wipe(idData);
	for index, objectID in pairs(idList) do
		local parts = {strsplit(ID_SEPARATOR, objectID)};
		local depth = #parts;
		local hasChild = true -- To be determined in DB
		local isOpen = idList[index + 1] and idList[index + 1]:sub(1, objectID:len()) == objectID;

		local class = getClass(objectID);
		local icon, name, description = TRP3_API.extended.tools.getClassDataSafeByType(class);

		idData[index] = {
			type = class.TY,
			icon = icon,
			text = name,
			text2 = description,
			depth = depth,
			ID = parts[#parts],
			fullID = objectID,
			isOpen = isOpen == true,
			hasChild = isOpen == true,
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
		if idData.hasChild then
			lineWidget.Expand:Show();

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
	for objectID, objectData in pairs(DB) do
		tinsert(idList, objectID);
	end

	ToolFrame.list:Show();
	refresh(idList);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.extended.tools.initList()
	TRP3_API.ui.frame.setupFieldPanel(ToolFrame.list, "Full database", 150); -- TODO: locals

	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_EXTENDED_RESIZED, function(containerwidth, containerHeight)
		ToolFrame.list.scroll.child:SetWidth(containerwidth - 75);
	end);
end
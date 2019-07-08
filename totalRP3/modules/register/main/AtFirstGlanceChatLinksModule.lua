----------------------------------------------------------------------------------
--- Total RP 3
--- At first glance chat links module
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---   http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local tcopy = TRP3_API.utils.table.copy;
local Utils = TRP3_API.utils;
local Globals = TRP3_API.globals;
local crop = TRP3_API.Ellyb.Strings.crop;
local shouldCropTexts = TRP3_API.ui.tooltip.shouldCropTexts;

local GLANCE_TOOLTIP_CROP = 400;
local GLANCE_TITLE_CROP = 150;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()

	local AtFirstGlanceChatLinksModule = TRP3_API.ChatLinks:InstantiateModule(loc.CL_GLANCE, "AT_FIRST_GLANCE");

	--- Get a copy of the data for the link, using the information provided when using AtFirstGlanceChatLinksModule:InsertLink
	function AtFirstGlanceChatLinksModule:GetLinkData(glanceTab, canBeImported)

		local tooltipData = {
			glanceTab = {},
		};

		tcopy(tooltipData.glanceTab, glanceTab);
		tooltipData.canBeImported = canBeImported == true;

		return glanceTab.TI or "...", tooltipData;
	end

	--- Creates and decorates tooltip lines for the given data
	---@return ChatLinkTooltipLines
	function AtFirstGlanceChatLinksModule:GetTooltipLines(tooltipData)
		local tooltipLines = TRP3_API.ChatLinkTooltipLines();

		local glance = tooltipData.glanceTab;

		local icon = Globals.icons.default;
		if glance.IC and glance.IC:len() > 0 then
			icon = glance.IC;
		end
		local TTText = glance.TX or "...";
		local glanceTitle = glance.TI or "...";
		if shouldCropTexts() then
			TTText = crop(TTText, GLANCE_TOOLTIP_CROP);
			glanceTitle = crop(glanceTitle, GLANCE_TITLE_CROP);
		end

		tooltipLines:SetTitle(Utils.str.icon(icon, 30) .. " " .. glanceTitle, TRP3_API.Ellyb.ColorManager.WHITE);
		tooltipLines:AddLine(TTText, TRP3_API.Ellyb.ColorManager.ORANGE);
		return tooltipLines;
	end

	-- Import glance action button
	local ImportGlanceButton = AtFirstGlanceChatLinksModule:NewActionButton("IMPORT_GLANCE", loc.CL_IMPORT_GLANCE, "GLNC_I_Q", "GLNC_I_A");

	function ImportGlanceButton:IsVisible(tooltipData)
		return tooltipData.canBeImported;
	end

	function ImportGlanceButton:OnAnswerCommandReceived(tooltipData)
		local glance = tooltipData.glanceTab;
		TRP3_API.register.glance.saveSlotPreset(glance);
	end

	TRP3_API.AtFirstGlanceChatLinksModule = AtFirstGlanceChatLinksModule;
end);

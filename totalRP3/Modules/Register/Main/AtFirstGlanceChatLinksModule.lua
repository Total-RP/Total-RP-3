-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Total RP 3 imports
local loc = TRP3.loc;
local tcopy = TRP3.utils.table.copy;
local Utils = TRP3.utils;
local crop = TRP3.utils.str.crop;
local shouldCropTexts = TRP3.ui.tooltip.shouldCropTexts;

local GLANCE_TOOLTIP_CROP = 400;
local GLANCE_TITLE_CROP = 150;

TRP3.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()

	local AtFirstGlanceChatLinksModule = TRP3.ChatLinks:InstantiateModule(loc.CL_GLANCE, "AT_FIRST_GLANCE");

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
		local tooltipLines = TRP3.ChatLinkTooltipLines();

		local glance = tooltipData.glanceTab;

		local icon = TRP3_InterfaceIcons.Default;
		if glance.IC and glance.IC:len() > 0 then
			icon = glance.IC;
		end
		local TTText = glance.TX or "";
		local glanceTitle = glance.TI or "...";
		if shouldCropTexts() then
			TTText = crop(TTText, GLANCE_TOOLTIP_CROP);
			glanceTitle = crop(glanceTitle, GLANCE_TITLE_CROP);
		end

		tooltipLines:SetTitle(Utils.str.icon(icon, 30) .. " " .. glanceTitle, TRP3.Colors.White);
		tooltipLines:AddLine(TTText, TRP3.Colors.Orange);
		return tooltipLines;
	end

	-- Import glance action button
	local ImportGlanceButton = AtFirstGlanceChatLinksModule:NewActionButton("IMPORT_GLANCE", loc.CL_IMPORT_GLANCE, "GLNC_I_Q", "GLNC_I_A");

	function ImportGlanceButton:IsVisible(tooltipData)
		return tooltipData.canBeImported;
	end

	function ImportGlanceButton:OnAnswerCommandReceived(tooltipData)
		local glance = tooltipData.glanceTab;
		TRP3.register.glance.saveSlotPreset(glance);
	end

	TRP3.AtFirstGlanceChatLinksModule = AtFirstGlanceChatLinksModule;
end);

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local loc = TRP3_API.loc;

local function ResolveFrame(tbl, name, ...)
	local frame = tbl[name];

	if frame and ... then
		return ResolveFrame(frame, ...);
	else
		return frame;
	end
end

TRP3_API.module.registerModule({
	["name"] = "ElvUI",
	["id"] = "trp3_elvui",
	["description"] = loc.MO_TOOLTIP_CUSTOMIZATIONS_DESCRIPTION:format("ElvUI"),
	["requiredDeps"] = {
		{ "trp3_tooltips", 1.0 }
	},
	["version"] = 1.000,
	["minVersion"] = 45,
	["onStart"] = function()

		-- Stop right here if ElvUI is not installed
		if not ElvUI then
			return false, loc.MO_ADDON_NOT_INSTALLED:format("ElvUI");
		end

		local skinFrame, skinTooltips;

		local CONFIG = {
			SKIN_TOOLTIPS = "elvui_skin_tooltips",
			SKIN_TARGET_FRAME = "elvui_skin_target_frame",
			SKIN_TOOLBAR_FRAME = "elvui_skin_toolbar_frame",
		}

		-- List of the tooltips we want to be customized by ElvUI
		local TOOLTIPS = {
			-- Total RP 3
			"TRP3_MainTooltip",
			"TRP3_CharacterTooltip",
			"TRP3_CompanionTooltip",
			-- Total RP 3: Extended
			"TRP3_ItemTooltip",
			"TRP3_NPCTooltip"
		}

		local SKINNABLE_TARGET_FRAMES = {
			"TRP3_TargetFrame",
			"TRP3_TargetFrame.Header",
			"TRP3_GlanceBar",
			"TRP3_GlanceBarSlot1",
			"TRP3_GlanceBarSlot2",
			"TRP3_GlanceBarSlot3",
			"TRP3_GlanceBarSlot4",
			"TRP3_GlanceBarSlot5",
		}

		local SKINNABLE_TOOLBAR_FRAMES = {
			"TRP3_ToolbarFrame",
			"TRP3_ToolbarFrame.Container.Backdrop",
			"TRP3_ToolbarFrame.Title",
		}

		TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
			-- Register configurations options
			TRP3_API.configuration.registerConfigKey(CONFIG.SKIN_TOOLTIPS, true);
			TRP3_API.configuration.registerConfigKey(CONFIG.SKIN_TARGET_FRAME, true);
			TRP3_API.configuration.registerConfigKey(CONFIG.SKIN_TOOLBAR_FRAME, true);

			-- Build configuration page
			TRP3_API.configuration.registerConfigurationPage({
				id = "main_config_elvui",
				menuText = "ElvUI",
				pageText = "ElvUI",
				elements = {
					-- Category header for the ElvUI tooltip skin configurations
					{
						inherit = "TRP3_ConfigH1",
						title = loc.TT_ELVUI_SKIN,
					},
					-- Checkbox to toggle tooltip skinning
					{
						inherit = "TRP3_ConfigCheck",
						title = loc.TT_ELVUI_SKIN_ENABLE_TOOLTIPS,
						configKey = CONFIG.SKIN_TOOLTIPS,
					},
					-- Checkbox to toggle target frame skinning
					{
						inherit = "TRP3_ConfigCheck",
						title = loc.TT_ELVUI_SKIN_ENABLE_TARGET_FRAME,
						configKey = CONFIG.SKIN_TARGET_FRAME,
					},
					-- Checkbox to toggle toolbar frame skinning
					{
						inherit = "TRP3_ConfigCheck",
						title = loc.TT_ELVUI_SKIN_ENABLE_TOOLBAR_FRAME,
						configKey = CONFIG.SKIN_TOOLBAR_FRAME,
					},
				}
			});

			-- Register configuration handlers to apply the changes
			TRP3_API.configuration.registerHandler(CONFIG.SKIN_TOOLTIPS, function()
				if TRP3_API.configuration.getValue(CONFIG.SKIN_TOOLTIPS) then
					skinTooltips();
				end
				TRP3_API.popup.showConfirmPopup(loc.CO_UI_RELOAD_WARNING, ReloadUI);
			end);
			TRP3_API.configuration.registerHandler(CONFIG.SKIN_TARGET_FRAME, function()
				if TRP3_API.configuration.getValue(CONFIG.SKIN_TARGET_FRAME) then
					skinFrame(SKINNABLE_TARGET_FRAMES);
				end
				TRP3_API.popup.showConfirmPopup(loc.CO_UI_RELOAD_WARNING, ReloadUI);
			end);
			TRP3_API.configuration.registerHandler(CONFIG.SKIN_TOOLBAR_FRAME, function()
				if TRP3_API.configuration.getValue(CONFIG.SKIN_TOOLBAR_FRAME) then
					skinFrame(SKINNABLE_TOOLBAR_FRAMES);
				end
				TRP3_API.popup.showConfirmPopup(loc.CO_UI_RELOAD_WARNING, ReloadUI);
			end);
		end)

		-- Wait for the add-on to be fully loaded so all the tooltips are available
		TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()

			local TT = _G["ElvUI"][1]:GetModule('Tooltip');

			function skinTooltips()
				-- Go through each tooltips from our table
				for _, tooltip in pairs(TOOLTIPS) do
					if _G[tooltip] then
						-- We check that the tooltip exists and then add it to ElvUI
						TT:SecureHookScript(_G[tooltip], 'OnShow', 'SetStyle');
					end
				end
			end

			-- 9.2 changed Tooltips to use NineSlice but TargetFrame doesn't use it, therefore we need to use the old styling function
			local function SetStyleForFrame(tt)
				if not tt or (tt == _G["ElvUI"][1].ScanTooltip or tt.IsEmbedded or not tt.SetTemplate or not tt.SetBackdrop) or tt:IsForbidden() then return; end
				tt.customBackdropAlpha = TT.db.colorAlpha;
				tt:SetTemplate('Transparent');
			end

			function skinFrame(skinnableFrames)
				-- Go through each skinnable frames from our table
				for _, frameName in pairs(skinnableFrames) do
					local frame = ResolveFrame(_G, string.split(frameName, "."));

					if frame then
						TT:SecureHookScript(frame, 'OnShow', SetStyleForFrame);

						if frame:IsShown() then
							SetStyleForFrame(frame);
						end
					end
				end
			end

			-- Override default tooltip anchoring behavior to use ElvUI anchors
			local function setElvUITooltipDefaultAnchor(tooltip, parent)
				TT:GameTooltip_SetDefaultAnchor(tooltip, parent);
			end
			TRP3_API.ui.tooltip.setTooltipDefaultAnchor = setElvUITooltipDefaultAnchor;

			-- Apply the skinning if the settings are enabled
			if TRP3_API.configuration.getValue(CONFIG.SKIN_TOOLTIPS) then
				skinTooltips();
			end
			if TRP3_API.configuration.getValue(CONFIG.SKIN_TARGET_FRAME) then
				skinFrame(SKINNABLE_TARGET_FRAMES);
			end
			if TRP3_API.configuration.getValue(CONFIG.SKIN_TOOLBAR_FRAME) then
				skinFrame(SKINNABLE_TOOLBAR_FRAMES);
			end

			-- Adjusting the default border color to be black for ElvUI tooltips
			TRP3_API.ui.tooltip.tooltipBorderColor = TRP3_API.Colors.Black;
		end);
	end,
});

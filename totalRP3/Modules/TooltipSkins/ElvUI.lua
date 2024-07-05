-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local loc = TRP3_API.loc;

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

		local skinTargetFrame, skinTooltips;

		local CONFIG = {
			SKIN_TOOLTIPS = "elvui_skin_tooltips",
			SKIN_TARGET_FRAME = "elvui_skin_target_frame",
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

		local SKINNABLE_FRAMES = {
			"TRP3_TargetFrame",
			"TRP3_TargetFrame.Header",
			"TRP3_GlanceBar",
			"TRP3_GlanceBarSlot1",
			"TRP3_GlanceBarSlot2",
			"TRP3_GlanceBarSlot3",
			"TRP3_GlanceBarSlot4",
			"TRP3_GlanceBarSlot5",
		}

		TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
			-- Register configurations options
			TRP3_API.configuration.registerConfigKey(CONFIG.SKIN_TOOLTIPS, true);
			TRP3_API.configuration.registerConfigKey(CONFIG.SKIN_TARGET_FRAME, true);

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
				}
			});

			-- Register configuration handlers to apply the changes
			TRP3_API.configuration.registerHandler(CONFIG.SKIN_TOOLTIPS, function()
				if TRP3_API.configuration.getValue(CONFIG.SKIN_TOOLTIPS) then
					skinTooltips();
				else
					TRP3_API.popup.showConfirmPopup(loc.CO_UI_RELOAD_WARNING, ReloadUI);
				end
			end);
			TRP3_API.configuration.registerHandler(CONFIG.SKIN_TARGET_FRAME, function()
				if TRP3_API.configuration.getValue(CONFIG.SKIN_TARGET_FRAME) then
					skinTargetFrame();
				else
					TRP3_API.popup.showConfirmPopup(loc.CO_UI_RELOAD_WARNING, ReloadUI);
				end
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
			local function SetStyleForTargetFrame(tt)
				if not tt or (tt == _G["ElvUI"][1].ScanTooltip or tt.IsEmbedded or not tt.SetTemplate or not tt.SetBackdrop) or tt:IsForbidden() then return; end
				tt.customBackdropAlpha = TT.db.colorAlpha;
				tt:SetTemplate('Transparent');
			end

			function skinTargetFrame()
				-- Go through each skinnable frames from our table
				for _, frame in pairs(SKINNABLE_FRAMES) do
					local parentKey;
					frame, parentKey = string.split(".", frame, 2);

					if _G[frame] then
						-- If parentKey is not nil, check if a frame exists with said parentKey within this frame
						if parentKey ~= nil and _G[frame][parentKey] then
							TT:SecureHookScript(_G[frame][parentKey], 'OnShow', SetStyleForTargetFrame);
						elseif parentKey == nil then
							TT:SecureHookScript(_G[frame], 'OnShow', SetStyleForTargetFrame);
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
				skinTargetFrame();
			end
		end);
	end,
});

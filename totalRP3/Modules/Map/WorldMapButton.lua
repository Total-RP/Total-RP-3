-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

--region Total RP 3 imports
local loc = TRP3_API.loc;
local Events = TRP3_Addon.Events;
local getConfigValue = TRP3_API.configuration.getValue;
local setConfigValue = TRP3_API.configuration.setValue;
local registerConfigKey = TRP3_API.configuration.registerConfigKey;
--endregion

--region Ellyb imports
local YELLOW = TRP3_API.Colors.Yellow
--endregion

--region WoW imports
local after = C_Timer.After;
local GetTime = GetTime;
--endregion

local CONFIG_MAP_BUTTON_POSITION = "MAP_BUTTON_POSITION";
local CONFIG_HIDE_BUTTON_IF_EMPTY = "HIDE_MAP_BUTTON_IF_EMPTY";
---@type Button
local WorldMapButton = TRP3_WorldMapButton;

local NORMAL_STATE_MAP_ICON = Ellyb.Icon(TRP3_InterfaceIcons.ScanReady);
local ON_COOLDOWN_STATE_MAP_ICON = Ellyb.Icon(TRP3_InterfaceIcons.ScanCooldown);

--region Configuration
TRP3_API.RegisterCallback(TRP3_Addon, Events.WORKFLOW_ON_LOADED, function()
	registerConfigKey(CONFIG_MAP_BUTTON_POSITION, "BOTTOMLEFT");
	registerConfigKey(CONFIG_HIDE_BUTTON_IF_EMPTY, false);

	local function placeMapButton(newPosition)
		if getConfigValue(CONFIG_HIDE_BUTTON_IF_EMPTY) and next(TRP3_API.MapScannersManager.getAllScans()) == nil then
			WorldMapButton:Hide();
			return
		else
			WorldMapButton:Show();
		end

		if newPosition then setConfigValue(CONFIG_MAP_BUTTON_POSITION, newPosition) end
		local position = newPosition or getConfigValue(CONFIG_MAP_BUTTON_POSITION)

		WorldMapButton:SetParent(WorldMapFrame.ScrollContainer);
		WorldMapButton:SetFrameStrata("FULLSCREEN");
		WorldMapButton:SetFrameLevel(WorldMapFrame.ScrollContainer:GetScrollChild():GetFrameLevel() + 1);
		WorldMapButton:ClearAllPoints();

		local xPadding = 10;
		local yPadding = 10;

		if position == "TOPRIGHT" then
			xPadding = -10;
			yPadding = -45;
		elseif position == "TOPLEFT" then
			yPadding = -30;
		elseif position == "BOTTOMRIGHT" then
			xPadding = -10;
			yPadding = 40;
		end

		WorldMapButton:SetPoint(position, WorldMapFrame.ScrollContainer, position, xPadding, yPadding);
	end

	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_MAP_BUTTON,
	});

	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigurationFrame_MapButtonWidget",
		title = loc.CO_MAP_BUTTON_POS,
		listContent = {
			{loc.CO_ANCHOR_BOTTOM_LEFT, "BOTTOMLEFT"},
			{loc.CO_ANCHOR_TOP_LEFT, "TOPLEFT"},
			{loc.CO_ANCHOR_BOTTOM_RIGHT, "BOTTOMRIGHT"},
			{loc.CO_ANCHOR_TOP_RIGHT, "TOPRIGHT"}
		},
		listCallback = placeMapButton,
		listCancel = true,
		configKey = CONFIG_MAP_BUTTON_POSITION,
	});

	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc.CO_HIDE_EMPTY_MAP_BUTTON,
		configKey = CONFIG_HIDE_BUTTON_IF_EMPTY
	});

	TRP3_API.configuration.registerHandler(CONFIG_HIDE_BUTTON_IF_EMPTY, function()
		placeMapButton();
	end)

	--{{{ UI setup
	NORMAL_STATE_MAP_ICON:Apply(WorldMapButton.Icon);
	---@type Tooltip
	Ellyb.Tooltips.getTooltip(WorldMapButton)
		:SetTitle(loc.MAP_BUTTON_TITLE)
		:OnShow(function(tooltip)
		tooltip:ClearTempLines();
		tooltip:AddTempLine(WorldMapButton.subtitle)
	end)
	--}}}

	placeMapButton();
end)
--endregion

--region Broadcast Lifecycle
-- When we get BROADCAST_CHANNEL_CONNECTING we'll ensure the button is
-- disabled and tell the user things are firing up.
TRP3_API.RegisterCallback(TRP3_Addon, Events.BROADCAST_CHANNEL_CONNECTING, function()
	WorldMapButton:SetEnabled(false);
	WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE_CONNECTING);
	WorldMapButton.Icon:SetDesaturated(true);
end);

-- If we get BROADCAST_CHANNEL_OFFLINE we'll ensure the button remains
-- disabled and dump the localised error into the tooltip, to be useful.
TRP3_API.RegisterCallback(TRP3_Addon, Events.BROADCAST_CHANNEL_OFFLINE, function(_, reason)
	WorldMapButton:SetEnabled(false);
	WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE_OFFLINE):format(reason);
	WorldMapButton.Icon:SetDesaturated(true);
end);

-- When we get BROADCAST_CHANNEL_READY it's time to enable the button use the
-- standard tooltip description.
TRP3_API.RegisterCallback(TRP3_Addon, Events.BROADCAST_CHANNEL_READY, function()
	WorldMapButton:SetEnabled(true);
	WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE);
	WorldMapButton.Icon:SetDesaturated(false);
end);

--endregion

WorldMapButton:SetScript("OnMouseDown", function(self)
	local structure = {};
	local scans = TRP3_API.MapScannersManager.getAllScans();
	---@param scan MapScanner
	for scanID, scan in pairs(scans) do
		if scan:CanScan() then
			tinsert(structure, { scan:GetActionString(), scanID });
		end
	end

	local function SortCompareScanNames(a, b)
		local scanA = scans[a[2]];
		local scanB = scans[b[2]];
		local scanIndexA = scanA:GetSortIndex();
		local scanIndexB = scanB:GetSortIndex();

		if scanIndexA ~= scanIndexB then
			return scanIndexA < scanIndexB;
		end

		-- Fallback; if scan index is equal then sort by (localized) text.
		local scanLabelA = scanA:GetActionText();
		local scanLabelB = scanB:GetActionText();

		return scanLabelA < scanLabelB;
	end

	table.sort(structure, SortCompareScanNames);

	if #structure == 0 then
		tinsert(structure, {loc.MAP_BUTTON_NO_SCAN, nil});
	end

	TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
		for _, scan in pairs(structure) do
			local responder;

			if scan[2] ~= nil then
				responder = TRP3_API.MapScannersManager.launch;
			end

			description:CreateButton(scan[1], responder, scan[2]);
		end
	end);
end);

function WorldMapButton.resetCooldown()
	WorldMapButton:Enable();
	NORMAL_STATE_MAP_ICON:Apply(WorldMapButton.Icon);
end

function WorldMapButton.startCooldown(timer)
	WorldMapButton:Disable();
	ON_COOLDOWN_STATE_MAP_ICON:Apply(WorldMapButton.Icon);
	WorldMapButton.Cooldown:SetCooldown(GetTime(), timer)
	after(timer, WorldMapButton.resetCooldown)
end

TRP3_API.WorldMapButton = WorldMapButton;

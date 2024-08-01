-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Utils = TRP3_API.utils;
local loc = TRP3_API.loc;
local color = Utils.str.color;

local CONFIG_CONTENT_PREFIX = "toolbar_content_";

local function onStart()
	-- Public accessor
	TRP3_API.toolbar = {};

	local LDBObjects = {};

	-- imports
	local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Toolbar Logic
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local buttonStructures = {};

	local function SortToolbarButtons(a, b)
		return a.id < b.id;  -- Keeping old logic for now, bleh.
	end

	local function BuildToolbar()
		local elements = {};

		for _, buttonStructure in pairs(buttonStructures) do
			if buttonStructure.visible then
				tinsert(elements, buttonStructure);
			end
		end

		table.sort(elements, SortToolbarButtons);

		local provider = CreateDataProvider(elements);
		TRP3_ToolbarFrame:SetDataProvider(provider);
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Databroker integration
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local LDB = LibStub:GetLibrary("LibDataBroker-1.1");

	---
	-- Register a Databroker plugin using a button structure
	-- @param buttonStructure
	--
	local function registerDatabrokerButton(buttonStructure)
		local LDBObject = LDB:NewDataObject(
			TRP3_API.globals.addon_name_short .. " — " .. buttonStructure.configText,
			{
				type= "data source",
				icon = Utils.getIconTexture(buttonStructure.icon),
				OnClick = function(Uibutton, button)
					if buttonStructure.onClick then
						buttonStructure.onClick(Uibutton, buttonStructure, button);
					end
				end,
				tooltipTitle = TRP3_ToolbarUtil.GetFormattedTooltipTitle(buttonStructure),
				tooltipSub = buttonStructure.tooltipSub,
				OnTooltipShow = function(tooltip)
					local LDBButton = LDBObjects[buttonStructure.id];
					tooltip:AddLine(color("w") .. LDBButton.tooltipTitle);
					tooltip:AddLine(LDBButton.tooltipSub, nil, nil, nil, true);

					if buttonStructure.tooltipInstructions then
						tooltip:AddLine(" ");

						for _, instruction in ipairs(buttonStructure.tooltipInstructions) do
							local text = TRP3_API.FormatShortcutWithInstruction(instruction[1], instruction[2]);
							tooltip:AddLine(text);
						end
					end
				end
			});
		LDBObjects[buttonStructure.id] = LDBObject;

	end

	--- Refresh the UI of an databroker object corresponding to the given buttonStructure
	-- @param buttonStructure
	--
	local function refreshLDBPLugin(buttonStructure)
		assert(buttonStructure.id, "The buttonStructure given to refreshLDBPLugin does not have an id.")
		local LDBButton = LDBObjects[buttonStructure.id];
		assert(LDBButton, "Could not find a registered LDB object for id " .. buttonStructure.id)

		LDBButton.icon = Utils.getIconTexture(buttonStructure.icon);

		LDBButton.tooltipTitle = TRP3_ToolbarUtil.GetFormattedTooltipTitle(buttonStructure);
		LDBButton.tooltipSub = buttonStructure.tooltipSub;

	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Toolbar API
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local loaded = false;

	-- Add a new button to the toolbar. The toolbar layout is automatically handled.
	-- Button structure :
	function TRP3_API.toolbar.toolbarAddButton(buttonStructure)
		assert(not loaded, "All button must be registered on addon load. You're too late !");
		assert(buttonStructure and buttonStructure.id, "Usage: button structure containing 'id' field");
		assert(not buttonStructures[buttonStructure.id], "The toolbar button with id "..buttonStructure.id.." already exists.");
		buttonStructures[buttonStructure.id] = buttonStructure;
		registerDatabrokerButton(buttonStructure);
	end

	function TRP3_API.toolbar.updateToolbarButton(button, buttonStructure)  -- luacheck: no unused
		button:Update();
	end


	local function RefreshToolbarButtons()
		for _, buttonStructure in pairs(buttonStructures) do
			if buttonStructure.onModelUpdate then
				securecallfunction(buttonStructure.onModelUpdate, buttonStructure);
				refreshLDBPLugin(buttonStructure);
			end
		end

		TRP3_ToolbarFrame:RefreshButtons();
	end

	-- Holding off on making toolbutton updates more flexible for now in favour
	-- of *just* relying on periodic updates and a few hand-selected callbacks.

	C_Timer.NewTicker(0.5, RefreshToolbarButtons);
	TRP3_API.RegisterCallback(TRP3_Addon, "ROLEPLAY_STATUS_CHANGED", RefreshToolbarButtons);

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Position
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	registerConfigKey(TRP3_ToolbarConfigKeys.AnchorPoint, "TOP");
	registerConfigKey(TRP3_ToolbarConfigKeys.AnchorOffsetX, 0);
	registerConfigKey(TRP3_ToolbarConfigKeys.AnchorOffsetY, -30);

	function TRP3_API.toolbar.reset()
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorPoint, "TOP");
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorOffsetX, 0);
		setConfigValue(TRP3_ToolbarConfigKeys.AnchorOffsetY, -30);
		setConfigValue(TRP3_ToolbarConfigKeys.Visibility, TRP3_ToolbarVisibilityOption.AlwaysShow);
		TRP3_ToolbarFrame:LoadPosition();
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- INIT & TRP3 toolbar content
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_FINISH, function()
		loaded = true;

		registerConfigKey(TRP3_ToolbarConfigKeys.Visibility, TRP3_ToolbarVisibilityOption.AlwaysShow);
		registerConfigKey(TRP3_ToolbarConfigKeys.ButtonExtent, 25);
		registerConfigKey(TRP3_ToolbarConfigKeys.ButtonStride, 7);
		registerConfigKey(TRP3_ToolbarConfigKeys.HideTitle, false);

		registerConfigHandler({
			TRP3_ToolbarConfigKeys.ButtonExtent,
			TRP3_ToolbarConfigKeys.ButtonStride,
			TRP3_ToolbarConfigKeys.HideTitle,
		}, BuildToolbar);

		-- Build configuration page
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigH1",
			title = loc.CO_TOOLBAR_CONTENT,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigDropDown",
			widgetName = "TRP3_ConfigToolbarVisibility",
			title = loc.CO_TOOLBAR_VISIBILITY,
			help = loc.CO_TOOLBAR_VISIBILITY_HELP,
			listContent = {
				{loc.CM_DO_NOT_SHOW, TRP3_ToolbarVisibilityOption.AlwaysHidden},
				{loc.CO_TOOLBAR_VISIBILITY_2, TRP3_ToolbarVisibilityOption.OnlyShowInCharacter},
				{loc.CO_TOOLBAR_VISIBILITY_1, TRP3_ToolbarVisibilityOption.AlwaysShow}
			},
			configKey = TRP3_ToolbarConfigKeys.Visibility,
			listCancel = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TOOLBAR_ICON_SIZE,
			configKey = TRP3_ToolbarConfigKeys.ButtonExtent,
			min = 15,
			max = 50,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigSlider",
			title = loc.CO_TOOLBAR_MAX,
			help = loc.CO_TOOLBAR_MAX_TT,
			configKey = TRP3_ToolbarConfigKeys.ButtonStride,
			min = 1,
			max = 25,
			step = 1,
			integer = true,
		});
		tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
			inherit = "TRP3_ConfigCheck",
			title = loc.CO_TOOLBAR_HIDE_TITLE,
			help = loc.CO_TOOLBAR_HIDE_TITLE_HELP,
			configKey = TRP3_ToolbarConfigKeys.HideTitle,
		});

		local ids = {};
		for buttonID, _ in pairs(buttonStructures) do
			tinsert(ids, buttonID);
		end
		table.sort(ids);
		for _, buttonID in pairs(ids) do
			local button = buttonStructures[buttonID];
			local configKey = CONFIG_CONTENT_PREFIX .. buttonID;
			registerConfigKey(configKey, true);
			registerConfigHandler(configKey, function()
				button.visible = getConfigValue(configKey);
				BuildToolbar();
			end);
			button.visible = getConfigValue(configKey);
			tinsert(TRP3_API.configuration.CONFIG_TOOLBAR_PAGE.elements, {
				inherit = "TRP3_ConfigCheck",
				title = button.configText or buttonID,
				configKey = configKey,
			});
		end

		TRP3_ToolbarFrame:Init();
		BuildToolbar();
	end);

	function TRP3_API.toolbar.switch()
		TRP3_ToolbarFrame:Toggle();
	end
end

local MODULE_STRUCTURE = {
	["name"] = "Toolbar",
	["description"] = "Add a toolbar containing several handy actions!",
	["version"] = 1.000,
	["id"] = "trp3_tool_bar",
	["onStart"] = onStart,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);

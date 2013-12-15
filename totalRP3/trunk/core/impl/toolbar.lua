--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_UI_InitToolbar()
	TRP3_ToolbarTopFrameText:SetText(TRP3_ADDON_NAME);
	-- Show/hide cape
	TRP3_ToolbarAddButton({
		id = "trp3_main_a",
		icon = "INV_Misc_Cape_18",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if GetMouseFocus() == Uibutton then
				if not ShowingCloak() then
					TRP3_SetTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, TRP3_Icon("INV_Misc_Cape_18", 20) .. " " .. SHOW_CLOAK,
						strconcat(TRP3_Color("y"), TRP3_L("CM_CLICK"), ": ", TRP3_Color("w"), TRP3_L("TB_SWITCH_CAPE_1")));
				else
					TRP3_SetTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, TRP3_Icon("INV_Misc_Cape_18", 20) .. " "..SHOW_CLOAK,
						strconcat(TRP3_Color("y"), TRP3_L("CM_CLICK"), ": ", TRP3_Color("w"), TRP3_L("TB_SWITCH_CAPE_2")));
				end
				TRP3_RefreshTooltipForFrame(Uibutton);
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			ShowCloak(not ShowingCloak());
		end,
		onLeave = function()
			TRP3_MainTooltip:Hide();
		end,
	});
	-- Show / hide helmet
	TRP3_ToolbarAddButton({
		id = "trp3_main_b",
		icon = "INV_Helmet_13",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if GetMouseFocus() == Uibutton then
				if not ShowingHelm() then
					TRP3_SetTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, TRP3_Icon("INV_Helmet_13", 20) .. " "..SHOW_HELM,
						TRP3_Color("y")..TRP3_L("CM_CLICK")..": "..TRP3_Color("w")..TRP3_L("TB_SWITCH_HELM_1"));
				else
					TRP3_SetTooltipForFrame(Uibutton, Uibutton, "BOTTOM", 0, 0, TRP3_Icon("INV_Helmet_13", 20) .. " "..SHOW_HELM,
						TRP3_Color("y")..TRP3_L("CM_CLICK")..": "..TRP3_Color("w")..TRP3_L("TB_SWITCH_HELM_2"));
				end
				TRP3_RefreshTooltipForFrame(Uibutton);
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			ShowHelm(not ShowingHelm());
		end,
		onLeave = function()
			TRP3_MainTooltip:Hide();
		end,
	});
	-- away/dnd
	TRP3_ToolbarAddButton({
		id = "trp3_main_c",
		icon = "Ability_Rogue_MasterOfSubtlety",
		onEnter = function(Uibutton, buttonStructure) end,
		onUpdate = function(Uibutton, buttonStructure)
			if UnitIsDND("player") then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Ability_Mage_IncantersAbsorbtion.blp");
				TRP3_SetTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0, TRP3_Icon("Ability_Mage_IncantersAbsorbtion", 20).." "..TRP3_Color("w")..MODE..": "..TRP3_Color("r")..DEFAULT_DND_MESSAGE,
					TRP3_Color("y")..TRP3_L("CM_CLICK")..": "..TRP3_Color("w")..(TRP3_L("TB_GO_TO_MODE"):format(TRP3_Color("g")..TRP3_L("TB_NORMAL_MODE")..TRP3_Color("w"))));
			elseif UnitIsAFK("player") then
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Spell_Nature_Sleep.blp");
				TRP3_SetTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0,TRP3_Icon("Spell_Nature_Sleep", 20).." "..TRP3_Color("w")..MODE..": "..TRP3_Color("o")..DEFAULT_AFK_MESSAGE,
					TRP3_Color("y")..TRP3_L("CM_CLICK")..": "..TRP3_Color("w")..(TRP3_L("TB_GO_TO_MODE"):format(TRP3_Color("g")..TRP3_L("TB_NORMAL_MODE")..TRP3_Color("w"))));
			else
				_G[Uibutton:GetName().."Normal"]:SetTexture("Interface\\ICONS\\Ability_Rogue_MasterOfSubtlety.blp");
				TRP3_SetTooltipForFrame(Uibutton,Uibutton,"BOTTOM",0,0,TRP3_Icon("Ability_Rogue_MasterOfSubtlety", 20).." "..TRP3_Color("w")..MODE..": "..TRP3_Color("g")..PLAYER_DIFFICULTY1,
					TRP3_Color("y")..TRP3_L("CM_L_CLICK")..": "..TRP3_Color("w")..(TRP3_L("TB_GO_TO_MODE"):format(TRP3_Color("o")..TRP3_L("TB_AFK_MODE")..TRP3_Color("w")))
					.."\n"..TRP3_Color("y")..TRP3_L("CM_R_CLICK")..": "..TRP3_Color("w")..(TRP3_L("TB_GO_TO_MODE"):format(TRP3_Color("r")..TRP3_L("TB_DND_MODE")..TRP3_Color("w"))));
			end
			if GetMouseFocus() == Uibutton then
				TRP3_RefreshTooltipForFrame(Uibutton);
			end
		end,
		onClick = function(Uibutton, buttonStructure, button)
			
		end,
		onLeave = function()
			TRP3_MainTooltip:Hide();
		end,
	});
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Toolbar methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local buttonStructures = {};
local uiButtons = {};
local hiddenButtonIds = {};
local maxButtonPerLine = 10;
local buttonSize = 25;
local marginLeft = 7;
local marginTop = 7;

local function buildToolbar()
	local ids = {};
	for id, buttonStructure in pairs(buttonStructures) do
		if not tContains(hiddenButtonIds, id) then
			tinsert(ids, id);
		end
	end
	table.sort(ids);
	--Hide all
	for _,uiButton in pairs(uiButtons) do
		uiButton:Hide();
	end
	
	local index = 0;
	local x = marginLeft;
	local y = -marginTop;
	local numLines = 1;
	for i, id in pairs(ids) do
		local buttonStructure = buttonStructures[id];
		local uiButton = uiButtons[index+1];
		if uiButton == nil then -- Create the button
			uiButton = CreateFrame("Button", "TRP3_ToolbarButton"..index, TRP3_ToolbarContainer, "TRP3_ToolbarButtonTemplate");
			uiButton:ClearAllPoints();
			uiButton:RegisterForClicks("LeftButtonUp", "RightButtonUp");
			tinsert(uiButtons, uiButton);
		end
		uiButton:SetNormalTexture("Interface\\ICONS\\"..buttonStructure.icon);
		uiButton:SetPushedTexture("Interface\\ICONS\\"..buttonStructure.icon);
		uiButton:GetPushedTexture():SetDesaturated(1);
		uiButton:SetPoint("TOPLEFT", x, y);
		uiButton:SetScript("OnClick", function(self, button)
			if buttonStructure.onClick then
				buttonStructure.onClick(uiButton, buttonStructure, button);
			end
		end);
		uiButton:SetScript("OnEnter", function()
			if buttonStructure.onEnter then
				buttonStructure.onEnter(uiButton, buttonStructure);
			end
		end);
		uiButton:SetScript("OnLeave", function()
			if buttonStructure.onLeave then
				buttonStructure.onLeave(uiButton, buttonStructure);
			end
		end);
		uiButton.TimeSinceLastUpdate = 10;
		uiButton:SetScript("OnUpdate", function(self, elapsed)
			self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 	
			if (self.TimeSinceLastUpdate > 0.2) then
				self.TimeSinceLastUpdate = 0;
				if buttonStructure.onUpdate then
					buttonStructure.onUpdate(uiButton, buttonStructure);
				end
			end
		end);
		uiButton:SetWidth(buttonSize);
		uiButton:SetHeight(buttonSize);
		uiButton:Show();
		uiButton.buttonId = id;
		
		index = index+1;
		if math.fmod(index, maxButtonPerLine) == 0 then
			y = y - buttonSize;
			x = marginLeft;
			if i ~= #ids then
				numLines = numLines + 1;
			end
		else
			x = x + buttonSize;
		end
		
	end
	if index <= maxButtonPerLine then
		TRP3_ToolbarContainer:SetWidth(14 + index*buttonSize);
	else
		TRP3_ToolbarContainer:SetWidth(14 + maxButtonPerLine*buttonSize);
	end
	TRP3_ToolbarContainer:SetHeight(14 + numLines*buttonSize);
	TRP3_Toolbar:SetHeight(34 + numLines*buttonSize);
	-- TODO: header type (small, normal)
	TRP3_Toolbar:SetWidth(TRP3_ToolbarContainer:GetWidth() + 10);
end

-- Switch the toolbar visibility.
function TRP3_SwitchToolbar()
	if TRP3_Toolbar:IsVisible() then
		TRP3_Toolbar:Hide()
	else
		TRP3_Toolbar:Show();
	end
end

-- Changes the number max of button per line in the toolbar and rebuilds it.
function TRP3_SetToolbarButtonSize(toolbarButtonSize)
	buttonSize = toolbarButtonSize;
	buildToolbar();
end

-- Changes the number max of button per line in the toolbar and rebuilds it.
function TRP3_SetToolbarMaxButtonPerLine(iMaxButtonPerLine)
	maxButtonPerLine = iMaxButtonPerLine;
	buildToolbar();
end

-- Add a new button to the toolbar. The toolbar layout is automatically handled.
-- Button structure :
-- { id [string], icon [string], onClick [function(button, buttonStructure)] };
function TRP3_ToolbarAddButton(buttonStructure)
	assert(buttonStructure and buttonStructure.id, "Usage: button structure containing 'id' field");
	assert(not buttonStructures[buttonStructure.id], "The toolbar button with id "..buttonStructure.id.." already exists.");
	buttonStructures[buttonStructure.id] = buttonStructure;
	buildToolbar();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Minimap button widget
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Init the minimap icon button. Shouldn't be called manually
function TRP3_InitMinimapButton(frame)
	frame:RegisterForClicks("LeftButtonUp","RightButtonUp");
	frame:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			TRP3_SwitchToolbar();
		else
			TRP3_SwitchMainFrame();
		end
	end);
end

-- Refresh the minimap icon position
function TRP3_UI_PlaceMinimapIcon()
	local minimap = _G[TRP3_GetConfigValue("MiniMapToUse")];
	if minimap then
		local x = sin(TRP3_GetConfigValue("MiniMapIconDegree"))*TRP3_GetConfigValue("MiniMapIconPosition");
		local y = cos(TRP3_GetConfigValue("MiniMapIconDegree"))*TRP3_GetConfigValue("MiniMapIconPosition");
		TRP3_MinimapButton:SetParent(minimap);
		TRP3_MinimapButton:SetPoint("CENTER", minimap, "CENTER", x, y);
	end
end
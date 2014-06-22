--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.ui = {
	tooltip = {},
	listbox = {},
	list = {},
	misc = {},
	frame = {}
}

-- imports
local globals = TRP3_API.globals;
local loc = TRP3_API.locale.getText;
local floor, tinsert, pairs, wipe, assert, _G, tostring, table, type = floor, tinsert, pairs, wipe, assert, _G, tostring, table, type;
local MouseIsOver, CreateFrame, PlaySound, ToggleDropDownMenu = MouseIsOver, CreateFrame, PlaySound, ToggleDropDownMenu;
local UIDropDownMenu_Initialize, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton = UIDropDownMenu_Initialize, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton;
local TRP3_MainTooltip, TRP3_MainTooltipTextRight1, TRP3_MainTooltipTextLeft1, TRP3_MainTooltipTextLeft2 = TRP3_MainTooltip, TRP3_MainTooltipTextRight1, TRP3_MainTooltipTextLeft1, TRP3_MainTooltipTextLeft2;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Frame utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tiledBackgrounds = {
	"Interface\\DialogFrame\\UI-DialogBox-Background",
	"Interface\\BankFrame\\Bank-Background",
	"Interface\\FrameGeneral\\UI-Background-Marble",
	"Interface\\FrameGeneral\\UI-Background-Rock",
	"Interface\\GuildBankFrame\\GuildVaultBG",
	"Interface\\HELPFRAME\\DarkSandstone-Tile",
	"Interface\\HELPFRAME\\Tileable-Parchment",
	"Interface\\QuestionFrame\\question-background",
	"Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg",
	"Interface\\Destiny\\EndscreenBG",
	"Interface\\Stationery\\AuctionStationery1",
	"Interface\\Stationery\\Stationery_ill1",
	"Interface\\Stationery\\Stationery_OG1",
	"Interface\\Stationery\\Stationery_TB1",
	"Interface\\Stationery\\Stationery_UC1",
	"Interface\\Stationery\\StationeryTest1",
	"Interface\\WorldMap\\UI-WorldMap-Middle1",
	"Interface\\WorldMap\\UI-WorldMap-Middle2",
	"Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
};

function TRP3_API.ui.frame.getTiledBackground(index)
	return tiledBackgrounds[index] or tiledBackgrounds[1];
end

function TRP3_API.ui.frame.getTiledBackgroundList()
	local tab = {};
	for index, _ in pairs(tiledBackgrounds) do
		tinsert(tab, {loc("UI_BKG"):format(tostring(index)), index});
	end
	return tab;
end

function TRP3_API.ui.frame.showIfMouseOverFrame(frame, frameOver)
	assert(frame and frameOver, "Frames can't be nil");
	if MouseIsOver(frameOver) then
		frame:Show();
	else
		frame:Hide();
	end
end

function TRP3_API.ui.frame.createRefreshOnFrame(frame, time, callback)
	assert(frame and time and callback, "Argument must be not nil");
	frame.refreshTimer = 1000;
	frame:SetScript("OnUpdate", function(arg, elapsed)
		frame.refreshTimer = frame.refreshTimer + elapsed;
		if frame.refreshTimer > time then
			frame.refreshTimer = 0;
			callback(frame);
		end
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Drop down
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DROPDOWN_FRAME = "TRP3_UIDD";
local dropDownFrame;

TRP3_API.ui.listbox.toggle = function()
	ToggleDropDownMenu(nil, nil, dropDownFrame);
end

local function openDropDown(anchoredFrame, values, callback, space, addCancel)
	if not dropDownFrame then
		dropDownFrame = CreateFrame("Frame", DROPDOWN_FRAME, UIParent, "UIDropDownMenuTemplate");
	end
	UIDropDownMenu_Initialize(dropDownFrame,
		function(uiFrame, level, menuList)
			local levelValues = menuList or values;

			level = level or 1;
			for index, tab in pairs(levelValues) do
				assert(type(tab) == "table", "Level value is not a table !");
				local text = tab[1];
				local value = tab[2];
				local info = UIDropDownMenu_CreateInfo();
				info.notCheckable = "true";
				info.text = text;
				info.isTitle = false;
				if type(value) == "table" then
					info.hasArrow = true;
					info.keepShownOnClick = true;
					info.menuList = value;
				elseif value then
					info.func = function()
						if callback then
							callback(value, anchoredFrame);
						end
						anchoredFrame:GetParent().selectedValue = value;
					end;
				else
					info.func = function() end;
					info.isTitle = true;
				end
				UIDropDownMenu_AddButton(info, level);
			end
			if menuList == nil and addCancel then
				local info = UIDropDownMenu_CreateInfo();
				info.notCheckable = "true";
				info.text = CANCEL;
				UIDropDownMenu_AddButton(info, level);
			end

		end,
		"MENU"
	);
	dropDownFrame:SetParent(anchoredFrame);
	ToggleDropDownMenu(1, nil, dropDownFrame, anchoredFrame:GetName(), -((space or -10)), 0);
	PlaySound("igMainMenuOptionCheckBoxOn");
end
TRP3_API.ui.listbox.displayDropDown = openDropDown;

--- Setup a drop down menu for a clickable (Button ...)
local function setupDropDownMenu(hasClickFrame, values, callback, space, addCancel, rightClick)
	hasClickFrame:SetScript("OnClick", function(self, button)
		if (rightClick and button ~= "RightButton") or (not rightClick and button ~= "LeftButton") then return; end
		openDropDown(hasClickFrame, values, callback, space, addCancel);
	end);
end
TRP3_API.ui.listbox.setupDropDownMenu = setupDropDownMenu;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ListBox tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function listBoxSetSelected(self, index)
	assert(self and self.values, "Badly initialized listbox");
	assert(self.values[index], "Array index out of bound");
	_G[self:GetName().."Text"]:SetText(self.values[index][1]);
	self.selectedValue = self.values[index][2];
	if self.callback then
		self.callback(self.values[index][2], self);
	end
end

local function listBoxSetSelectedValue(self, value)
	assert(self and self.values, "Badly initialized listbox");
	for index, tab in pairs(self.values) do
		local val = tab[2];
		if val == value then
			listBoxSetSelected(self, index);
			break;
		end
	end
end

local function listBoxGetValue(self)
	return self.selectedValue;
end

-- Setup a ListBox. When the player choose a value, it triggers the function passing the value of the selected element
local function setupListBox(listBox, values, callback, defaultText, boxWidth, addCancel)
	assert(listBox and values, "Invalid arguments");
	assert(_G[listBox:GetName().."Button"], "Invalid arguments: listbox doesn't have a button");
	boxWidth = boxWidth or 115;
	listBox.values = values;
	listBox.callback = callback;
	local listCallback = function(value)
		for index, tab in pairs(values) do
			local text = tab[1];
			local val = tab[2];
			if val == value then
				_G[listBox:GetName().."Text"]:SetText(text);
			end
		end
		if callback then
			callback(value, listBox);
		end
	end;

	setupDropDownMenu(_G[listBox:GetName().."Button"], values, listCallback, boxWidth, addCancel, false);

	listBox.SetSelectedIndex = listBoxSetSelected;
	listBox.GetSelectedValue = listBoxGetValue;
	listBox.SetSelectedValue = listBoxSetSelectedValue;

	if defaultText then
		_G[listBox:GetName().."Text"]:SetText(defaultText);
	end
	_G[listBox:GetName().."Middle"]:SetWidth(boxWidth);
	_G[listBox:GetName().."Text"]:SetWidth(boxWidth-20);
end
TRP3_API.ui.listbox.setupListBox = setupListBox;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Handle the mouse wheel for the frame in order to slide the slider
TRP3_API.ui.list.handleMouseWheel = function(frame,slider)
	frame:SetScript("OnMouseWheel",function(self,delta)
		local mini,maxi = slider:GetMinMaxValues();
		if delta == 1 and slider:GetValue() > mini then
			slider:SetValue(slider:GetValue()-1);
		elseif delta == -1 and slider:GetValue() < maxi then
			slider:SetValue(slider:GetValue()+1);
		end
	end);
	frame:EnableMouseWheel(1);
end

local function listShowPage(infoTab, pageNum)
	assert(infoTab.uiTab, "Error : no uiTab in infoTab.");

	-- Hide all widgets
	for k=1,infoTab.maxPerPage do
		infoTab.widgetTab[k]:Hide();
	end

	-- Show list
	for widgetIndex=1, infoTab.maxPerPage do
		local dataIndex = pageNum*infoTab.maxPerPage + widgetIndex;
		if dataIndex <= #infoTab.uiTab then
			infoTab.widgetTab[widgetIndex]:Show();
			infoTab.decorate(infoTab.widgetTab[widgetIndex], infoTab.uiTab[dataIndex]);
		else
			break;
		end
	end
end

-- Init a list.
-- Arguments :
-- 		infoTab, a structure containing :
-- 			- A widgetTab (the list of all widget used in a full page)
-- 			- A decorate function, which will receive 3 arguments : a widget and an ID. Decorate will be called on every couple "widget from widgetTab" and "id from dataTab".
--		dataTab, all the possible values
--		slider, the slider :3
TRP3_API.ui.list.initList = function(infoTab, dataTab, slider)
	assert(infoTab and dataTab and slider, "Error : no argument can be nil.");
	assert(infoTab.widgetTab, "Error : no widget tab in infoTab.");
	assert(infoTab.decorate, "Error : no decorate function in infoTab.");

	local count = 0;
	local maxPerPage = #infoTab.widgetTab;
	infoTab.maxPerPage = maxPerPage;

	if not infoTab.uiTab then
		infoTab.uiTab = {};
	end

	slider:Hide();
	slider:SetValueStep(1);
	slider:SetObeyStepOnDrag(true);
	wipe(infoTab.uiTab);

	if type(dataTab) == "table" then
		for key,_ in pairs(dataTab) do
			tinsert(infoTab.uiTab, key);
		end
	else
		for i=1, dataTab, 1 do
			tinsert(infoTab.uiTab, i);
		end
	end
	count = #infoTab.uiTab;

	table.sort(infoTab.uiTab);

	slider:SetScript("OnValueChanged", nil);
	if count > maxPerPage then
		slider:Show();
		local total = floor((count-1)/maxPerPage);
		slider:SetMinMaxValues(0, total);
	else
		slider:SetValue(0);
	end
	slider:SetScript("OnValueChanged",function(self)
		if self:IsVisible() then
			listShowPage(infoTab, floor(self:GetValue()));
		end
	end);
	listShowPage(infoTab, slider:GetValue());
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tooltip tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.ui.tooltip.CONFIG_TOOLTIP_SIZE = "CONFIG_TOOLTIP_SIZE";
local CONFIG_TOOLTIP_SIZE = TRP3_API.ui.tooltip.CONFIG_TOOLTIP_SIZE;
local getConfigValue;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	TRP3_API.configuration.registerConfigKey(TRP3_API.ui.tooltip.CONFIG_TOOLTIP_SIZE, 11);
	getConfigValue = TRP3_API.configuration.getValue;
end);

local function getTooltipSize()
	return getConfigValue(CONFIG_TOOLTIP_SIZE) or 11;
end

-- Show the tooltip for this Frame (the frame must have been set up with setTooltipForFrame).
-- If already shown, the tooltip text will be refreshed.
local function refreshTooltip(Frame)
	if Frame.titleText and Frame.GenFrame and Frame.GenFrameX and Frame.GenFrameY and Frame.GenFrameAnch then
		TRP3_MainTooltip:Hide();
		TRP3_MainTooltip:SetOwner(Frame.GenFrame, Frame.GenFrameAnch,Frame.GenFrameX,Frame.GenFrameY);
		if not Frame.rightText then
			TRP3_MainTooltip:AddLine(Frame.titleText, 1, 1, 1, true);
		else
			TRP3_MainTooltip:AddDoubleLine(Frame.titleText, Frame.rightText);
			TRP3_MainTooltipTextRight1:SetFont("Fonts\\FRIZQT__.TTF", getTooltipSize()+4);
			TRP3_MainTooltipTextRight1:SetNonSpaceWrap(true);
			TRP3_MainTooltipTextRight1:SetTextColor(1, 1, 1);
		end
		TRP3_MainTooltipTextLeft1:SetFont("Fonts\\FRIZQT__.TTF", getTooltipSize()+4);
		TRP3_MainTooltipTextLeft1:SetNonSpaceWrap(true);
		TRP3_MainTooltipTextLeft1:SetTextColor(1, 1, 1);
		if Frame.bodyText then
			TRP3_MainTooltip:AddLine(Frame.bodyText, 1, 0.6666, 0, true);
			TRP3_MainTooltipTextLeft2:SetFont("Fonts\\FRIZQT__.TTF", getTooltipSize());
			TRP3_MainTooltipTextLeft2:SetNonSpaceWrap(true);
			TRP3_MainTooltipTextLeft2:SetTextColor(1, 0.75, 0);
		end
		TRP3_MainTooltip:Show();
	end
end
TRP3_API.ui.tooltip.refresh = refreshTooltip;
TRP3_RefreshTooltipForFrame = refreshTooltip; -- For XML integration without too much perf' issue

local function tooltipSimpleOnEnter(self)
	refreshTooltip(self);
end

local function tooltipSimpleOnLeave(self)
	TRP3_MainTooltip:Hide();
end

-- Setup the frame tooltip (position and text)
-- The tooltip can be shown by using refreshTooltip(Frame)
local function setTooltipForFrame(Frame, GenFrame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	assert(Frame and GenFrame, "Frame and GenFrame cannot be nil.");
	if Frame and GenFrame then
		Frame.GenFrame = GenFrame;
		Frame.GenFrameX = GenFrameX;
		Frame.GenFrameY = GenFrameY;
		Frame.titleText = titleText;
		Frame.bodyText = bodyText;
		Frame.rightText = rightText;
		if GenFrameAnch then
			Frame.GenFrameAnch = "ANCHOR_"..GenFrameAnch;
		else
			Frame.GenFrameAnch = "ANCHOR_TOPRIGHT";
		end
	end
end
TRP3_API.ui.tooltip.setTooltipForFrame = setTooltipForFrame;

-- Setup the frame tooltip (position and text)
-- The tooltip can be shown by using refreshTooltip(Frame)
TRP3_API.ui.tooltip.setTooltipForSameFrame = function(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

-- Setup the frame tooltip and add the Enter and Leave scripts
TRP3_API.ui.tooltip.setTooltipAll = function(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	Frame:SetScript("OnEnter", tooltipSimpleOnEnter);
	Frame:SetScript("OnLeave", tooltipSimpleOnLeave);
	setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Toast
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local TRP3_Toast, TRP3_ToastTextLeft1 = TRP3_Toast, TRP3_ToastTextLeft1;

local function toastUpdate(self, elapsed)
	self.delay = self.delay - elapsed;
	if self.delay <= 0 and not self.isFading then
		self.isFading = true;
		self:FadeOut();
	end
end

TRP3_Toast.delay = 0;
TRP3_Toast:SetScript("OnUpdate", toastUpdate);

function TRP3_API.ui.tooltip.toast(text, duration)
	TRP3_Toast:Hide();
	TRP3_Toast:SetOwner(TRP3_MainFramePageContainer, "ANCHOR_BOTTOM", 0, 60);
	TRP3_Toast:AddLine(text, 1, 1, 1, true);
	TRP3_ToastTextLeft1:SetFont("Fonts\\FRIZQT__.TTF", getTooltipSize());
	TRP3_ToastTextLeft1:SetNonSpaceWrap(true);
	TRP3_ToastTextLeft1:SetTextColor(1, 1, 1);
	TRP3_Toast:Show();
	TRP3_Toast.delay = duration or 3;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_API.ui.frame.setupIconButton(self, icon)
	assert(self, "Frame is nil");
	assert(_G[self:GetName().."Icon"], "Frame must have a Icon");
	_G[self:GetName().."Icon"]:SetTexture("Interface\\ICONS\\"..icon);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Fieldsets
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local FIELDSET_DEFAULT_CAPTION_WIDTH = 100;

function TRP3_API.ui.frame.setupFieldPanel(fieldset, text, size)
	if fieldset and _G[fieldset:GetName().."CaptionPanelCaption"] then
		_G[fieldset:GetName().."CaptionPanelCaption"]:SetText(text);
		if _G[fieldset:GetName().."CaptionPanel"] then
			_G[fieldset:GetName().."CaptionPanel"]:SetWidth(size or FIELDSET_DEFAULT_CAPTION_WIDTH);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tab bar
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabBar_index = 0;
local tabBar_HEIGHT_SELECTED = 34;
local tabBar_HEIGHT_NORMAL = 32;

local function tabBar_onSelect(tabGroup, index)
	assert(#tabGroup.tabs >= index, "Index out of bound.");
	local i;
	for i=1, #tabGroup.tabs do
		local widget = tabGroup.tabs[i];
		if i == index then
			widget:SetAlpha(1);
			widget:Disable();
			widget:LockHighlight();
			_G[widget:GetName().."Left"]:SetHeight(tabBar_HEIGHT_SELECTED);
			_G[widget:GetName().."Middle"]:SetHeight(tabBar_HEIGHT_SELECTED);
			_G[widget:GetName().."Right"]:SetHeight(tabBar_HEIGHT_SELECTED);
			widget:GetHighlightTexture():SetAlpha(0.7);
			widget:GetHighlightTexture():SetDesaturated(1);
			tabGroup.current = index;
		else
			widget:SetAlpha(0.85);
			widget:Enable();
			widget:UnlockHighlight();
			_G[widget:GetName().."Left"]:SetHeight(tabBar_HEIGHT_NORMAL);
			_G[widget:GetName().."Middle"]:SetHeight(tabBar_HEIGHT_NORMAL);
			_G[widget:GetName().."Right"]:SetHeight(tabBar_HEIGHT_NORMAL);
			widget:GetHighlightTexture():SetAlpha(0.5);
			widget:GetHighlightTexture():SetDesaturated(0);
		end
	end
end

local function tabBar_redraw(tabGroup)
	local lastWidget = nil;
	for _, tabWidget in pairs(tabGroup.tabs) do
		if tabWidget:IsShown() then
			tabWidget:ClearAllPoints();
			if lastWidget == nil then
				tabWidget:SetPoint("LEFT", 0, 0);
			else
				tabWidget:SetPoint("LEFT", lastWidget, "RIGHT", 2, 0);
			end
			lastWidget = tabWidget;
		end
	end
end

local function tabBar_size(tabGroup)
	return #tabGroup.tabs;
end

local function tabBar_setTabVisible(tabGroup, index, isVisible)
	assert(tabGroup.tabs[index], "Tab index out of bound.");
	if isVisible then
		tabGroup.tabs[index]:Show();
	else
		tabGroup.tabs[index]:Hide();
	end
	tabGroup:Redraw();
end

local function tabBar_selectTab(tabGroup, index)
	assert(tabGroup.tabs[index], "Tab index out of bound.");
	assert(tabGroup.tabs[index]:IsShown(), "Try to select a hidden tab.");
	tabGroup.tabs[index]:GetScript("OnClick")(tabGroup.tabs[index]);
end

function TRP3_API.ui.frame.createTabPanel(tabBar, data, callback)
	assert(tabBar, "The tabBar can't be nil");

	local tabGroup = {};
	tabGroup.tabs = {};
	for index, tabData in pairs(data) do
		local text = tabData[1];
		local value = tabData[2];
		local width = tabData[3];
		local tabWidget = CreateFrame("Button", "TRP3_TabBar_Tab_" .. tabBar_index, tabBar, "TRP3_TabBar_Tab");
		tabWidget:SetText(text);
		tabWidget:SetWidth(width or (text:len() * 11));
		tabWidget:SetScript("OnClick", function(self)
			tabBar_onSelect(tabGroup, index);
			if callback then
				callback(tabWidget, value);
			end
		end);

		tinsert(tabGroup.tabs, tabWidget);
		tabBar_index = tabBar_index + 1;
	end

	tabGroup.Redraw = tabBar_redraw;
	tabGroup.Size = tabBar_size;
	tabGroup.SetTabVisible = tabBar_setTabVisible;
	tabGroup.SelectTab = tabBar_selectTab;
	tabGroup:Redraw();

	return tabGroup;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Textures tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local unitTexture = {
	Human = {
		"Achievement_Character_Human_Male",
		"Achievement_Character_Human_Female",
	},
	Gnome = {
		"Achievement_Character_Gnome_Male",
		"Achievement_Character_Gnome_Female",
	},
	Scourge = {
		"Achievement_Character_Undead_Male",
		"Achievement_Character_Undead_Female",
	},
	NightElf = {
		"Achievement_Character_Nightelf_Male",
		"Achievement_Character_Nightelf_Female",
	},
	Dwarf = {
		"Achievement_Character_Dwarf_Male",
		"Achievement_Character_Dwarf_Female",
	},
	Draenei = {
		"Achievement_Character_Draenei_Male",
		"Achievement_Character_Draenei_Female",
	},
	Orc = {
		"Achievement_Character_Orc_Male",
		"Achievement_Character_Orc_Female",
	},
	BloodElf = {
		"Achievement_Character_Bloodelf_Male",
		"Achievement_Character_Bloodelf_Female",
	},
	Troll = {
		"Achievement_Character_Troll_Male",
		"Achievement_Character_Troll_Female",
	},
	Tauren = {
		"Achievement_Character_Tauren_Male",
		"Achievement_Character_Tauren_Female",
	},
	Worgen = {
		"achievement_worganhead",
		"Ability_Racial_Viciousness",
	},
	Goblin = {
		"Ability_Racial_RocketJump",
		"Ability_Racial_RocketJump",
	},
	Pandaren = {
		"Achievement_Guild_ClassyPanda",
		"Achievement_Character_Pandaren_Female",
	},
};

local classTexture = {
	ROGUE = "Ability_Rogue_DualWeild",
	WARLOCK = "Ability_Warlock_Eradication",
	PALADIN = "Spell_Paladin_Clarityofpurpose",
	MONK = "Monk_Ability_Transcendence",
	MAGE = "spell_Mage_NetherTempest",
	HUNTER = "Ability_Hunter_MasterMarksman",
	WARRIOR = "Ability_Warrior_OffensiveStance",
	DEATHKNIGHT = "Spell_Deathknight_FrostPresence",
	DRUID = "Spell_druid_tirelesspursuit",
	SHAMAN = "Ability_Shaman_WindwalkTotem",
	PRIEST = "Priest_icon_Chakra",
}

TRP3_API.ui.misc.getUnitTexture = function(race, gender)
	if unitTexture[race] and unitTexture[race][gender - 1] then
		return unitTexture[race][gender - 1];
	end
	return globals.icons.default;
end

TRP3_API.ui.misc.getClassTexture = function (class)
	return classTexture[class] or globals.icons.default;
end

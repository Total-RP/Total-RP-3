----------------------------------------------------------------------------------
--  Storyline
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

local date, math, string, assert, strconcat, tostring, _G = date, math, string, assert, strconcat, tostring, _G;

local function generateID()
	local ID = date("%m%d%H%M%S");
	for i=1, 5 do
		ID = ID .. string.char(math.random(33, 126));
	end
	return ID;
end
Storyline_API.lib.generateID = generateID;

local function getTextureString(iconPath, iconSize)
	assert(iconPath, "Icon path is nil.");
	iconSize = iconSize or 15;
	return strconcat("|T", iconPath, ":", iconSize, ":", iconSize, "|t");
end
Storyline_API.lib.getTextureString = getTextureString;

local debug = false;
local function log(message)
	if debug then
		print("[StoryLog] " .. tostring(message));
	end
end
Storyline_API.lib.log = log;

-- Return the table size.
-- Less effective than #table but works for hash table as well (#hashtable don't).
local function tableSize(table)
	local count = 0;
	for _,_ in pairs(table) do
		count = count + 1;
	end
	return count;
end
Storyline_API.lib.tsize = tableSize;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COLORS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- Value must be 256 based
local function numberToHexa(number)
	local number = string.format('%x', number);
	if number:len() == 1 then
		number = '0' .. number;
	end
	return number;
end
Storyline_API.lib.numberToHexa = numberToHexa;

--- Values must be 256 based
local function colorCode(red, green, blue)
	local redH = numberToHexa(red);
	local greenH = numberToHexa(green);
	local blueH = numberToHexa(blue);
	return strconcat("|cff", redH, greenH, blueH);
end
Storyline_API.lib.colorCode = colorCode;

--- Values must be 0..1 based
Storyline_API.lib.colorCodeFloat = function(red, green, blue)
	return colorCode(math.ceil(red*255), math.ceil(green*255), math.ceil(blue*255));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- EVENT HANDLING
-- Handles WOW events
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local REGISTERED_EVENTS = {};
local type, tostring, pairs = type, tostring, pairs;

Storyline_API.lib.registerHandler = function(event, callback)
	assert(event, "Event must be set.");
	assert(callback and type(callback) == "function", "Callback must be a function");
	if not REGISTERED_EVENTS[event] then
		REGISTERED_EVENTS[event] = {};
		Storyline_EventFrame:RegisterEvent(event);
	end
	local handlerID = generateID();
	while REGISTERED_EVENTS[event][handlerID] do -- Avoiding collision
		handlerID = generateID();
	end
	REGISTERED_EVENTS[event][handlerID] = callback;
	log(("Registered event %s with id %s"):format(tostring(event), handlerID));
	return handlerID;
end

Storyline_API.lib.unregisterHandler = function(handlerID)
	assert(handlerID, "handlerID must be set.");
	for event, eventTab in pairs(REGISTERED_EVENTS) do
		if eventTab[handlerID] then
			eventTab[handlerID] = nil;
			if tableSize(eventTab) == 0 then
				REGISTERED_EVENTS[event] = nil;
				Storyline_EventFrame:UnregisterEvent(event);
			end
			log(("Unregistered event %s with id %s"):format(tostring(event), handlerID));
			return;
		end
	end
	log(("handlerID not found %s"):format(handlerID));
end

function Storyline_EventDispatcher(self, event, ...)
	-- Callbacks
	if REGISTERED_EVENTS[event] then
		for _, callback in pairs(REGISTERED_EVENTS[event]) do
			callback(...);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tooltip tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Storyline_MainTooltip = Storyline_MainTooltip;

local function getTooltipSize()
	return 11;
end

-- Show the tooltip for this Frame (the frame must have been set up with setTooltipForFrame).
-- If already shown, the tooltip text will be refreshed.
local function refreshTooltip(Frame)
	local localeFont = Storyline_API.locale.localeFont;
	if Frame.titleText and Frame.GenFrame and Frame.GenFrameX and Frame.GenFrameY and Frame.GenFrameAnch then
		Storyline_MainTooltip:Hide();
		Storyline_MainTooltip:SetOwner(Frame.GenFrame, Frame.GenFrameAnch,Frame.GenFrameX,Frame.GenFrameY);
		if not Frame.rightText then
			Storyline_MainTooltip:AddLine(Frame.titleText, 1, 1, 1, true);
		else
			Storyline_MainTooltip:AddDoubleLine(Frame.titleText, Frame.rightText);
			Storyline_MainTooltipTextRight1:SetFont(localeFont, getTooltipSize() + 4);
			Storyline_MainTooltipTextRight1:SetNonSpaceWrap(true);
			Storyline_MainTooltipTextRight1:SetTextColor(1, 1, 1);
		end
		Storyline_MainTooltipTextLeft1:SetFont(localeFont, getTooltipSize() + 4);
		Storyline_MainTooltipTextLeft1:SetNonSpaceWrap(true);
		Storyline_MainTooltipTextLeft1:SetTextColor(1, 1, 1);
		if Frame.bodyText then
			Storyline_MainTooltip:AddLine(Frame.bodyText, 1, 0.6666, 0, true);
			Storyline_MainTooltipTextLeft2:SetFont(localeFont, getTooltipSize());
			Storyline_MainTooltipTextLeft2:SetNonSpaceWrap(true);
			Storyline_MainTooltipTextLeft2:SetTextColor(1, 0.75, 0);
		end
		Storyline_MainTooltip:Show();
	end
end
Storyline_API.lib.refreshTooltip = refreshTooltip;
Storyline_RefreshTooltipForFrame = refreshTooltip; -- For XML integration without too much perf' issue

local function tooltipSimpleOnEnter(self)
	refreshTooltip(self);
end

local function tooltipSimpleOnLeave(self)
	Storyline_MainTooltip:Hide();
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
Storyline_API.lib.setTooltipForFrame = setTooltipForFrame;

-- Setup the frame tooltip (position and text)
-- The tooltip can be shown by using refreshTooltip(Frame)
Storyline_API.lib.setTooltipForSameFrame = function(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

-- Setup the frame tooltip and add the Enter and Leave scripts
Storyline_API.lib.setTooltipAll = function(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	Frame:SetScript("OnEnter", tooltipSimpleOnEnter);
	Frame:SetScript("OnLeave", tooltipSimpleOnLeave);
	setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end
local setTooltipAll = Storyline_API.lib.setTooltipAll;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Hovered frames
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function Storyline_API.lib.configureHoverFrame(frame, hoveredFrame, arrowPosition, x, y)
	x = x or 0;
	y = y or 0;
	frame:ClearAllPoints();
	frame:SetParent(hoveredFrame:GetParent());
	frame:SetFrameStrata("DIALOG");
	frame.ArrowRIGHT:Hide();
	frame.ArrowGlowRIGHT:Hide();
	frame.ArrowUP:Hide();
	frame.ArrowGlowUP:Hide();
	frame.ArrowDOWN:Hide();
	frame.ArrowGlowDOWN:Hide();
	frame.ArrowLEFT:Hide();
	frame.ArrowGlowLEFT:Hide();

	if arrowPosition == "RIGHT" then
		frame:SetPoint("RIGHT", hoveredFrame, "LEFT", -10 + x, 0 + y);
		frame.ArrowLEFT:Show();
		frame.ArrowGlowLEFT:Show();
	elseif arrowPosition == "LEFT" then
		frame:SetPoint("LEFT", hoveredFrame, "RIGHT", 10 + x, 0 + y);
		frame.ArrowRIGHT:Show();
		frame.ArrowGlowRIGHT:Show();
	elseif arrowPosition == "TOP" then
		frame:SetPoint("TOP", hoveredFrame, "BOTTOM", 0 + x, -20 + y);
		frame.ArrowDOWN:Show();
		frame.ArrowGlowDOWN:Show();
	else
		frame:SetPoint("BOTTOM", hoveredFrame, "TOP", 0 + x, 20 + y);
		frame.ArrowUP:Show();
		frame.ArrowGlowUP:Show();
	end

	frame:Show();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Resize button
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Storyline_ResizeShadowFrame = Storyline_ResizeShadowFrame;

function Storyline_API.lib.initResize(resizeButton)
	assert(resizeButton.resizableFrame, "resizableFrame key is not set.");
	assert(resizeButton.minWidth, "minWidth key is not set.");
	assert(resizeButton.minHeight, "minHeight key is not set.");
	setTooltipAll(resizeButton, "BOTTOMLEFT", 0, 0, Storyline_API.locale.getText("SL_RESIZE"), Storyline_API.locale.getText("SL_RESIZE_TT"));
	local parent = resizeButton.resizableFrame;
	resizeButton:RegisterForDrag("LeftButton");
	resizeButton:SetScript("OnDragStart", function(self)
		if not self.onResizeStart or not self.onResizeStart() then
			Storyline_ResizeShadowFrame.minWidth = self.minWidth;
			Storyline_ResizeShadowFrame.minHeight = self.minHeight;
			Storyline_ResizeShadowFrame:ClearAllPoints();
			Storyline_ResizeShadowFrame:SetPoint("CENTER", self.resizableFrame, "CENTER", 0, 0);
			Storyline_ResizeShadowFrame:SetWidth(self.resizableFrame:GetWidth());
			Storyline_ResizeShadowFrame:SetHeight(self.resizableFrame:GetHeight());
			Storyline_ResizeShadowFrame:Show();
			Storyline_ResizeShadowFrame:StartSizing();
			self.resizableFrame.isSizing = true;
		end
	end);
	resizeButton:SetScript("OnDragStop", function(self)
		if self.resizableFrame.isSizing then
			Storyline_ResizeShadowFrame:StopMovingOrSizing();
			self.resizableFrame.isSizing = false;
			local height, width = Storyline_ResizeShadowFrame:GetHeight(), Storyline_ResizeShadowFrame:GetWidth()
			Storyline_ResizeShadowFrame:Hide();
			if height < self.minHeight then
				height = self.minHeight;
			end
			if width < self.minWidth then
				width = self.minWidth;
			end
			local screenWidth = GetScreenWidth();
			local screenHeight = GetScreenHeight();
			if width > screenWidth then
				width = screenWidth;
			end
			if height > screenHeight then
				height = screenHeight;
			end
			self.resizableFrame:SetSize(width, height);
			if self.onResizeStop then
				C_Timer.After(0.1, function()
					self.onResizeStop(width, height);
				end);
			end
		end
	end);
end

Storyline_ResizeShadowFrame:SetScript("OnUpdate", function(self)
	local height, width = self:GetHeight(), self:GetWidth();
	local heightColor, widthColor = "|cff00ff00", "|cff00ff00";
	if height < self.minHeight then
		heightColor = "|cffff0000";
	end
	if width < self.minWidth then
		widthColor = "|cffff0000";
	end
	Storyline_ResizeShadowFrameText:SetText(widthColor .. math.ceil(width) .. "|r x " .. heightColor .. math.ceil(height));
end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Listbox
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local UIDropDownMenu_Initialize, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton = UIDropDownMenu_Initialize, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton;
local DROPDOWN_FRAME, DropDownList1, CloseDropDownMenus = "Storyline_UIDD", DropDownList1, CloseDropDownMenus;
local CreateFrame, ToggleDropDownMenu = CreateFrame, ToggleDropDownMenu;
local dropDownFrame, currentlyOpenedDrop;

local function openDropDown(anchoredFrame, values, callback, space, addCancel)
	if not dropDownFrame then
		dropDownFrame = CreateFrame("Frame", DROPDOWN_FRAME, UIParent, "UIDropDownMenuTemplate");
	end

	if DropDownList1:IsVisible() then
		CloseDropDownMenus();
		return;
	end

	UIDropDownMenu_Initialize(dropDownFrame,
		function(uiFrame, level, menuList)
			local levelValues = menuList or values;
			level = level or 1;
			for index, tab in pairs(levelValues) do
				assert(type(tab) == "table", "Level value is not a table !");
				local text = tab[1];
				local value = tab[2];
				local tooltipText = tab[3];
				local info = UIDropDownMenu_CreateInfo();
				info.notCheckable = "true";
				info.text = text;
				info.isTitle = false;
				info.tooltipOnButton = tooltipText ~= nil;
				info.tooltipTitle = text;
				info.tooltipText = tooltipText;
				if tab[3] then
					info.tooltipTitle = tab[1];
					info.tooltipText = tab[3];
					info.tooltipOnButton = true;
				end
				if type(value) == "table" then
					info.hasArrow = true;
					info.keepShownOnClick = true;
					info.menuList = value;
				elseif value ~= nil then
					info.func = function()
						if callback then
							callback(value, anchoredFrame);
						end
						anchoredFrame:GetParent().selectedValue = value;
						if level > 1 then
							ToggleDropDownMenu(nil, nil, dropDownFrame);
						end
						currentlyOpenedDrop = nil;
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
	PlaySound("igMainMenuOptionCheckBoxOn","SFX");
	currentlyOpenedDrop = anchoredFrame;
end

--- Setup a drop down menu for a clickable (Button ...)
local function setupDropDownMenu(hasClickFrame, values, callback, space, addCancel, rightClick)
	hasClickFrame:SetScript("OnClick", function(self, button)
		if (rightClick and button ~= "RightButton") or (not rightClick and button ~= "LeftButton") then return; end
		openDropDown(hasClickFrame, values, callback, space, addCancel);
	end);
end

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
function Storyline_API.lib.setupListBox(listBox, values, callback, defaultText, boxWidth, addCancel, isFontDropdown)
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
				if isFontDropdown then
					local font = Storyline_API.lib.getFontPath(text);
					local _, scale, outline = _G[listBox:GetName().."Text"]:GetFont();
					_G[listBox:GetName().."Text"]:SetFont(font, scale, outline);
				end
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

-- LibSharedMedia stuff

local LSM3 = LibStub("LibSharedMedia-3.0")

-- Register OpenDyslexic as a shared font
LSM3:Register(LSM3.MediaType.FONT, "OpenDyslexic", [[Interface\AddOns\Storyline\assets\fonts\OpenDyslexic-Regular.ttf]]);

function Storyline_API.lib.getFonts()
	local fonts = LSM3:List(LSM3.MediaType.FONT);
	local fontsTable = {};
	for index, font in pairs(fonts) do
		tinsert(fontsTable, {font, font })
	end
	return fontsTable;
end

function Storyline_API.lib.getDefaultFont()
	return LSM3:GetDefault(LSM3.MediaType.FONT)
end

function Storyline_API.lib.getFontPath(font)
	return LSM3:Fetch(LSM3.MediaType.FONT, font);
end
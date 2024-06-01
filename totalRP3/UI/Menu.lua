-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local DISABLE_MODERN_MENUS = false;

TRP3_MenuResponse = MenuResponse or {
	Open = 1,
	Refresh = 2,
	Close = 3,
	CloseAll = 3,
};

TRP3_MenuInputContext = MenuInputContext or {
	None = 1,
	MouseButton = 2,
	MouseWheel = 3,
}

local BaseMenuDescription = {};

function BaseMenuDescription:__init()
	self.elementDescriptions = {};
end

function BaseMenuDescription:Insert(description, index)
	if index then
		table.insert(self.elementDescriptions, index, description);
	else
		table.insert(self.elementDescriptions, description);
	end

	return description;
end

function BaseMenuDescription:EnumerateElementDescriptions()
	return ipairs(self.elementDescriptions);
end

function BaseMenuDescription:HasElements()
	return next(self.elementDescriptions) ~= nil;
end

function BaseMenuDescription:GetMinimumWidth()
	return self.minimumWidth or 0;
end

function BaseMenuDescription:SetMinimumWidth(width)
	self.minimumWidth = width;
end

local MenuElementDescription = CreateFromMixins(BaseMenuDescription);

function MenuElementDescription:GetData()
	return self.data;
end

function MenuElementDescription:SetData(data)
	self.data = data;
end

-- Note: Both Get/SetIcon are extensions not present in modern descriptions.
function MenuElementDescription:GetIcon()
	return self.icon;
end

function MenuElementDescription:SetIcon(icon)
	self.icon = icon;
end

function MenuElementDescription:IsEnabled()
	if self.isEnabled == nil then
		return true;
	elseif type(self.isEnabled) == "boolean" then
		return self.isEnabled;
	else
		return self.isEnabled(self);
	end
end

function MenuElementDescription:SetEnabled(isEnabled)
	self.isEnabled = isEnabled;
end

function MenuElementDescription:SetRadio(isRadio)
	self.isRadio = isRadio;
end

function MenuElementDescription:IsRadio()
	return self.isRadio;
end

function MenuElementDescription:IsSelected()
	if self.isSelected == nil then
		return false;
	elseif type(self.isSelected) == "boolean" then
		return self.isSelected;
	else
		return self.isSelected(self:GetData());
	end
end

function MenuElementDescription:SetIsSelected(isSelected)
	self.isSelected = isSelected;
end

function MenuElementDescription:CanSelect()
	if not self:IsEnabled() then
		return false;
	elseif self.canSelect == nil then
		-- Note: This returns true in modern descriptions.
		return false;
	elseif type(self.canSelect) == "boolean" then
		return self.canSelect;
	else
		return self.canSelect(self:GetData());
	end
end

function MenuElementDescription:SetCanSelect(canSelect)
	self.canSelect = canSelect;
end

function MenuElementDescription:GetOnEnter()
	return self.onEnter;
end

function MenuElementDescription:HandleOnEnter(frame)
	if self.onEnter then
		self.onEnter(frame, self);
	end
end

function MenuElementDescription:SetOnEnter(onEnter)
	self.onEnter = onEnter;
end

function MenuElementDescription:GetOnLeave()
	return self.onLeave;
end

function MenuElementDescription:HandleOnLeave(frame)
	if self.onLeave then
		self.onLeave(frame, self);
	end
end

function MenuElementDescription:SetOnLeave(onLeave)
	self.onLeave = onLeave;
end

local function DefaultTooltipInitializer(tooltip, elementDescription)
	local titleText = TRP3_MenuUtil.GetElementText(elementDescription);
	GameTooltip_SetTitle(tooltip, titleText);
end

function MenuElementDescription:SetTooltip(initializer)
	if not initializer then
		initializer = DefaultTooltipInitializer;
	end

	local function OnEnter(frame)
		TRP3_MenuUtil.ShowTooltip(frame, initializer, self);
	end

	self:SetOnEnter(OnEnter);
end

function MenuElementDescription:SetResponder(callback)
	self.responder = callback;
end

function MenuElementDescription:Pick(menuInputData)
	local response;

	if self.responder then
		response = self.responder(self:GetData(), menuInputData);
	end

	if response == nil then
		response = self:GetDefaultResponse();
	end

	return response;
end

function MenuElementDescription:WillRespond()
	-- Note: This is an extension API not present in modern descriptions.
	return self.responder ~= nil;
end

function MenuElementDescription:GetDefaultResponse()
	return self.defaultResponse;
end

function MenuElementDescription:SetResponse(response)
	self.defaultResponse = response;
end

function MenuElementDescription:GetSoundKit()
	if type(self.soundKit) == "number" then
		return self.soundKit;
	else
		return self.soundKit(self);
	end
end

function MenuElementDescription:SetSoundKit(soundKit)
	self.soundKit = soundKit;
end

function MenuElementDescription:CreateButton(text, callback, data)
	return self:Insert(TRP3_MenuUtil.CreateButton(text, callback, data));
end

function MenuElementDescription:CreateCheckbox(text, isSelected, setSelected, data)
	return self:Insert(TRP3_MenuUtil.CreateCheckbox(text, isSelected, setSelected, data));
end

function MenuElementDescription:CreateDivider()
	return self:Insert(TRP3_MenuUtil.CreateDivider());
end

function MenuElementDescription:CreateRadio(text, isSelected, setSelected, data)
	return self:Insert(TRP3_MenuUtil.CreateRadio(text, isSelected, setSelected, data));
end

function MenuElementDescription:CreateTitle(text, color)
	return self:Insert(TRP3_MenuUtil.CreateTitle(text, color));
end

local function CreateMenuElementDescription()
	return TRP3_API.CreateObject(MenuElementDescription);
end

local function CreateTextElementDescription(text)
	local elementDescription = CreateMenuElementDescription();
	TRP3_MenuUtil.SetElementText(elementDescription, text);
	return elementDescription;
end

local function CreateRootMenuDescription()
	return TRP3_API.CreateObject(MenuElementDescription);
end

TRP3_MenuUtil = {};

function TRP3_MenuUtil.GetElementText(elementDescription)
	local text;

	if MenuUtil and MenuUtil.GetElementText and not DISABLE_MODERN_MENUS then
		text = MenuUtil.GetElementText(elementDescription);
	else
		text = elementDescription.text;
	end

	return text;
end

function TRP3_MenuUtil.SetElementText(elementDescription, text)
	if MenuUtil and MenuUtil.SetElementText and not DISABLE_MODERN_MENUS then
		MenuUtil.SetElementText(elementDescription, text);
	else
		elementDescription.text = text;
	end
end

function TRP3_MenuUtil.SetElementIcon(elementDescription, icon)
	if elementDescription.AddInitializer then
		local function IconInitializer(button)
			local iconTexture = button:AttachTexture();
			iconTexture:SetPoint("RIGHT");
			iconTexture:SetSize(16, 16);

			if C_Texture.GetAtlasInfo(icon) then
				local useAtlasSize = false;
				iconTexture:SetAtlas(icon, useAtlasSize);
			else
				iconTexture:SetTexture(icon);
			end
		end

		elementDescription:AddInitializer(IconInitializer);
	elseif elementDescription.SetIcon then
		elementDescription:SetIcon(icon);
	end
end

function TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText)
	local function OnTooltipShow(tooltip)
		local tooltipTitle = TRP3_MenuUtil.GetElementText(elementDescription);

		GameTooltip_SetTitle(tooltip, tooltipTitle);
		GameTooltip_AddNormalLine(tooltip, tooltipText, true);
	end

	elementDescription:SetTooltip(OnTooltipShow);
end

function TRP3_MenuUtil.ShowTooltip(owner, func, ...)
	local tooltip = GameTooltip;
	tooltip:SetOwner(owner, "ANCHOR_RIGHT");
	func(tooltip, ...);
	tooltip:Show();
end

function TRP3_MenuUtil.HideTooltip(owner)
	local tooltip = GameTooltip;

	if tooltip:GetOwner() == owner then
		tooltip:Hide();
	end
end

function TRP3_MenuUtil.CreateButton(text, callback, data)
	local elementDescription;

	if MenuUtil and MenuUtil.CreateButton and not DISABLE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateButton(text, callback, data);
	else
		elementDescription = CreateTextElementDescription(text);
		elementDescription:SetData(data);
		elementDescription:SetResponder(callback);
		elementDescription:SetSoundKit(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

	return elementDescription;
end

local function GetCheckboxSoundKit(description)
	if description:IsSelected() then
		return SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON;
	else
		return SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF;
	end
end

function TRP3_MenuUtil.CreateCheckbox(text, isSelected, setSelected, data)
	local elementDescription;

	if MenuUtil and MenuUtil.CreateCheckbox and not DISABLE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateCheckbox(text, isSelected, setSelected, data);
	else
		elementDescription = CreateTextElementDescription(text);
		elementDescription:SetCanSelect(true);
		elementDescription:SetData(data);
		elementDescription:SetIsSelected(isSelected);
		elementDescription:SetResponder(setSelected);
		elementDescription:SetResponse(TRP3_MenuResponse.Refresh);
		elementDescription:SetSoundKit(GetCheckboxSoundKit);
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateDivider()
	local elementDescription;

	if MenuUtil and MenuUtil.CreateDivider and not DISABLE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateDivider();
	else
		elementDescription = CreateMenuElementDescription();
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateRadio(text, isSelected, setSelected, data)
	local elementDescription;

	if MenuUtil and MenuUtil.CreateRadio and not DISABLE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateRadio(text, isSelected, setSelected, data);
	else
		elementDescription = CreateTextElementDescription(text);
		elementDescription:SetCanSelect(true);
		elementDescription:SetData(data);
		elementDescription:SetIsSelected(isSelected);
		elementDescription:SetRadio(true);
		elementDescription:SetResponder(setSelected);
		elementDescription:SetSoundKit(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

	return elementDescription;
end

function TRP3_MenuUtil.CreateTitle(text, color)
	local elementDescription;

	if MenuUtil and MenuUtil.CreateTitle and not DISABLE_MODERN_MENUS then
		elementDescription = MenuUtil.CreateTitle(text, color);
	else
		elementDescription = CreateTextElementDescription(text);
	end

	return elementDescription;
end

TRP3_LegacyDropdownButtonMixin = {};

function TRP3_LegacyDropdownButtonMixin:OnLoad()
	self.Inner = CreateFrame("Frame", "$parentMenu", self, "UIDropDownMenuTemplate");
	self.Inner:SetAllPoints(self);
	self.Inner:SetScript("OnShow", function() self:Update(); end);
	self.defaultText = "";

	UIDropDownMenu_SetWidth(self.Inner, self:GetWidth());
	self:SetHeight(28);
end

function TRP3_LegacyDropdownButtonMixin:GetDefaultText()
	return self.defaultText;
end

function TRP3_LegacyDropdownButtonMixin:SetDefaultText(defaultText)
	self.defaultText = defaultText;
	self:UpdateText();
end

function TRP3_LegacyDropdownButtonMixin:GetText()
	return UIDropDownMenu_GetText(self.Inner);
end

function TRP3_LegacyDropdownButtonMixin:SetText(text)
	UIDropDownMenu_SetText(self.Inner, text);
end

function TRP3_LegacyDropdownButtonMixin:GetUpdateText()
	local text = self:GetText();

	if not text or text == "" or text == VIDEO_QUALITY_LABEL6 then
		text = self:GetDefaultText();
	end

	return text;
end

function TRP3_LegacyDropdownButtonMixin:UpdateText()
	UIDropDownMenu_SetText(self.Inner, self:GetUpdateText());
end

function TRP3_LegacyDropdownButtonMixin:GenerateMenu()
	-- TODO: Sanity check this later UwU senpai
	if self.Inner.initialize then
		UIDropDownMenu_Initialize(self.Inner, self.Inner.initialize);
		UIDropDownMenu_RefreshAll(UIDROPDOWNMENU_INIT_MENU);
	end
end

function TRP3_LegacyDropdownButtonMixin:SetupMenu(generator)
	local function OnMenuButtonClick(_, elementDescription, _, _, buttonName)
		local menuInputData = {
			context = TRP3_MenuInputContext.MouseButton,
			buttonName = buttonName,
		};

		local response = elementDescription:Pick(menuInputData);

		if response == TRP3_MenuResponse.Refresh then
			UIDropDownMenu_RefreshAll(UIDROPDOWNMENU_OPEN_MENU);
			self:UpdateText();
		elseif elementDescription:IsRadio() then
			UIDropDownMenu_SetText(self.Inner, TRP3_MenuUtil.GetElementText(elementDescription));
		end
	end

	local function OnMenuInitialize(_, level, menuList)
		if level == nil or level == 1 then
			menuList = CreateRootMenuDescription();
			generator(self, menuList);
		end

		local info = {};

		if menuList.GetMinimumWidth then
			info.minWidth = menuList:GetMinimumWidth();
		end

		for _, elementDescription in menuList:EnumerateElementDescriptions() do
			info.disabled = false;
			info.text = TRP3_MenuUtil.GetElementText(elementDescription);
			info.funcOnEnter = function(button) elementDescription:HandleOnEnter(button); end;
			info.funcOnLeave = function(button) elementDescription:HandleOnLeave(button); end;

			if elementDescription:WillRespond() then
				info.arg1 = elementDescription;
				info.func = OnMenuButtonClick;
				info.isTitle = false;
			elseif elementDescription:HasElements() then
				info.arg1 = nil;
				info.func = nil;
				info.isTitle = false;
			else
				info.arg1 = nil;
				info.func = nil;
				info.isTitle = true;
			end

			if elementDescription:HasElements() then
				info.hasArrow = true;
				info.keepShownOnClick = true;
				info.menuList = elementDescription;
			else
				info.hasArrow = false;
				info.keepShownOnClick = (elementDescription:GetDefaultResponse() == TRP3_MenuResponse.Refresh);
				info.menuList = nil;
			end

			if elementDescription:CanSelect() then
				info.checked = function() return elementDescription:IsSelected(); end;
				info.isNotRadio = not elementDescription:IsRadio();
				info.notCheckable = false;
			else
				info.checked = nil;
				info.isNotRadio = true;
				info.notCheckable = true;
			end

			if elementDescription.GetIcon then
				info.icon = elementDescription:GetIcon();
				info.iconXOffset = -4;
			else
				info.icon = nil;
			end

			if info.text == nil then
				UIDropDownMenu_AddSeparator(level);
			else
				UIDropDownMenu_AddButton(info, level);
			end
		end

	end

	UIDropDownMenu_SetInitializeFunction(self.Inner, OnMenuInitialize);
	self:Update();
end

function TRP3_LegacyDropdownButtonMixin:Update()
	self:GenerateMenu();
	self:UpdateText();
end

local TRP3_ModernDropdownButtonMixin = {};

function TRP3_ModernDropdownButtonMixin:OnLoad()
	self.Inner = CreateFrame("DropdownButton", nil, self, "WowStyle1DropdownTemplate");
	self.Inner:SetAllPoints(self);

	-- Classic has chonkier dropdowns.
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		self:SetHeight(25);
	else
		self:SetHeight(30);
	end
end

function TRP3_ModernDropdownButtonMixin:GetDefaultText()
	return self.Inner:GetDefaultText();
end

function TRP3_ModernDropdownButtonMixin:SetDefaultText(defaultText)
	self.Inner:SetDefaultText(defaultText);
end

function TRP3_ModernDropdownButtonMixin:GetText()
	return self.Inner:GetText();
end

function TRP3_ModernDropdownButtonMixin:SetText(text)
	self.Inner:SetText(text);
end

function TRP3_ModernDropdownButtonMixin:GetUpdateText()
	return self.Inner:GetUpdateText();
end

function TRP3_ModernDropdownButtonMixin:UpdateText()
	self.Inner:UpdateText();
end

function TRP3_ModernDropdownButtonMixin:SetupMenu(generator)
	self.Inner:SetupMenu(generator);
end

function TRP3_ModernDropdownButtonMixin:Update()
	self.Inner:Update();
end

if Menu and Menu.GetManager and not DISABLE_MODERN_MENUS then
	TRP3_DropdownButtonMixin = TRP3_ModernDropdownButtonMixin;
else
	TRP3_DropdownButtonMixin = TRP3_LegacyDropdownButtonMixin;
end

local SHOW_TEST_MENU = true;

C_Timer.After(0, function()
if SHOW_TEST_MENU then
	local TestDropdown = CreateFrame("Frame", "TestDropdown", UIParent, "TRP3_DropdownButtonTemplate");
	TestDropdown:SetPoint("CENTER");
	TestDropdown:SetDefaultText("Default Text");

	local checks = {};
	local radio = nil;

	TestDropdown:SetupMenu(function(_, rootDescription)
		rootDescription:SetMinimumWidth(400);
		rootDescription:CreateTitle("Buttons");

		local button1 = rootDescription:CreateButton("Button 1", print, "foo");
		button1:SetTooltip();

		local button2 = rootDescription:CreateButton("Button 2", print, "foo");
		button2:SetTooltip(function(tt) tt:AddLine("foo"); end);

		local button3 = rootDescription:CreateButton("Button 3", print, "foo");
		TRP3_MenuUtil.SetElementIcon(button3, [[Interface\Scenarios\ScenarioIcon-Interact]]);

		rootDescription:CreateDivider();
		rootDescription:CreateTitle("Checkboxes");
		local function IsCheckSelected(key) return checks[key]; end
		local function SetCheckSelected(key) checks[key] = not checks[key]; end
		rootDescription:CreateCheckbox("Option 1", IsCheckSelected, SetCheckSelected, 1);
		rootDescription:CreateCheckbox("Option 2", IsCheckSelected, SetCheckSelected, 2);
		rootDescription:CreateCheckbox("Option 3", IsCheckSelected, SetCheckSelected, 3);

		rootDescription:CreateDivider();
		rootDescription:CreateTitle("Radios");
		local function IsRadioSelected(key) return radio == key; end
		local function SetRadioSelected(key) radio = key end
		rootDescription:CreateRadio("Option 1", IsRadioSelected, SetRadioSelected, 1);
		rootDescription:CreateRadio("Option 2", IsRadioSelected, SetRadioSelected, 2);
		rootDescription:CreateRadio("Option 3", IsRadioSelected, SetRadioSelected, 3);

		rootDescription:CreateDivider();
		rootDescription:CreateTitle("Submenu");
		local top = rootDescription:CreateButton("Submenu");
		for i = 1, 3 do
			local child = top:CreateButton("Option " .. i);
			child:SetMinimumWidth(200);

			for j = 1, 3 do
				local subchild = child:CreateButton("Option " .. i .. "." .. j);
				subchild:SetResponder(print);
				subchild:SetData(i .. "." .. j);
				subchild:SetResponse(TRP3_MenuResponse.Refresh);
			end
		end
	end);
end
end);

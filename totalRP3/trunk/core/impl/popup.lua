--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local log = TRP3_Log;
local loc = TRP3_L;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Static popups definition
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

StaticPopupDialogs["TRP3_INFO"] = {
	button1 = OKAY,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
};

StaticPopupDialogs["TRP3_CONFIRM"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept then
			StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept();
		end
	end,
	OnCancel = function(arg1,arg2)
		if StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel then
			StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel();
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	showAlert = true,
};

StaticPopupDialogs["TRP3_INPUT_TEXT"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnShow = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(0);
	end,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept then
			StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept(_G[self:GetName().."EditBox"]:GetText());
		end
	end,
	OnHide = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(0);
	end,
	OnCancel = function(arg1,arg2)
		if StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel then
			StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel();
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
};

StaticPopupDialogs["TRP3_INPUT_NUMBER"] = {
	button1 = ACCEPT,
	button2 = CANCEL,
	OnShow = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(1);
	end,
	OnAccept = function(self)
		if StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept then
			StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept(_G[self:GetName().."EditBox"]:GetNumber());
		end
	end,
	OnHide = function(self)
		_G[self:GetName().."EditBox"]:SetNumeric(0);
	end,
	OnCancel = function(arg1,arg2)
		if StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel then
			StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel();
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	hasEditBox = 1,
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Static popups methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local POPUP_HEAD = "|TInterface\\AddOns\\totalRP3\\resources\\trp3logo:75:175|t\n \n";

-- Show a simple alert with a OK button.
function TRP3_ShowAlertPopup(text)
	StaticPopupDialogs["TRP3_INFO"].text = POPUP_HEAD..text;
	local dialog = StaticPopup_Show("TRP3_INFO");
    if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER",UIParent,"CENTER");
	end
end

function TRP3_ShowConfirmPopup(text, onAccept, onCancel)
	StaticPopupDialogs["TRP3_CONFIRM"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_CONFIRM"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_CONFIRM"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_CONFIRM");
    if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER",UIParent,"CENTER");
	end
end

function TRP3_ShowTextInputPopup(text, onAccept, onCancel, default)
	StaticPopupDialogs["TRP3_INPUT_TEXT"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_INPUT_TEXT"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_INPUT_TEXT");
    if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER",UIParent,"CENTER");
		_G[dialog:GetName().."EditBox"]:SetText(default);
		_G[dialog:GetName().."EditBox"]:HighlightText();
	end
end

function TRP3_ShowNumberInputPopup(text, onAccept, onCancel, default)
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].text = POPUP_HEAD..text.."\n\n";
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onAccept = onAccept;
	StaticPopupDialogs["TRP3_INPUT_NUMBER"].trp3onCancel = onCancel;
	local dialog = StaticPopup_Show("TRP3_INPUT_NUMBER");
    if dialog then
		dialog:ClearAllPoints();
		dialog:SetPoint("CENTER",UIParent,"CENTER");
		_G[dialog:GetName().."EditBox"]:SetNumber(default);
		_G[dialog:GetName().."EditBox"]:HighlightText();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Dynamic popup
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_ShowPopup(popup)
	for _, frame in pairs({TRP3_PopupsFrame:GetChildren()}) do
		frame:Hide();
	end
	TRP3_PopupsFrame:Show();
	popup:Show();
end

function TRP3_HidePopups()
	TRP3_PopupsFrame:Hide();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local iconWidgetTab = {};
local filteredIconList = {};

local function decorateIcon(icon, index)
	icon:SetNormalTexture("Interface\\ICONS\\"..filteredIconList[index]);
	icon:SetPushedTexture("Interface\\ICONS\\"..filteredIconList[index]);
	icon.index = index;
end

local function onIconClick(icon)
	if TRP3_IconBrowserContent.callback then
		TRP3_IconBrowserContent.callback(filteredIconList[icon.index]);
	end
	TRP3_HidePopups();
end

local function filteredIconBrowser()
	local filter = TRP3_IconBrowserFilterBox:GetText();
	filteredIconList = {}; -- TODO: possible memory leak
	filteredIconList = TRP3_GetIconList(filter);
	TRP3_IconBrowserTotal:SetText( (#filteredIconList) .. " / " .. TRP3_GetIconListSize() );
	TRP3_InitList(
		{
			widgetTab = iconWidgetTab,
			decorate = decorateIcon
		},
		filteredIconList,
		TRP3_IconBrowserContentSlider
	);
end

function TRP3_UI_InitIconBrowser()
	TRP3_HandleMouseWheel(TRP3_IconBrowserContent, TRP3_IconBrowserContentSlider);
	-- Create icons
	local row, column;
	
	for row = 0, 5 do
		for column = 0, 7 do
			local button = CreateFrame("Button", "TRP3_IconBrowserButton_"..row.."_"..column, TRP3_IconBrowserContent, "TRP3_IconBrowserButton");
			button:ClearAllPoints();
			button:SetPoint("TOPLEFT", TRP3_IconBrowserContent, "TOPLEFT", 15 + (column * 45), -15 + (row * (-45)));
			button:SetScript("OnClick", onIconClick);
			tinsert(iconWidgetTab, button);
		end
	end
	
	TRP3_IconBrowserFilterBox:SetScript("OnTextChanged", filteredIconBrowser);
	
	TRP3_IconBrowserTitle:SetText(loc("UI_ICON_BROWSER"));
	TRP3_IconBrowserFilterBoxText:SetText(loc("UI_FILTER"));
	filteredIconBrowser();
end

function TRP3_OpenIconBrowser(callback)
	TRP3_IconBrowserContent.callback = callback;
	TRP3_IconBrowserFilterBox:SetText("");
	TRP3_ShowPopup(TRP3_IconBrowser);
	TRP3_IconBrowserFilterBox:SetFocus();
end
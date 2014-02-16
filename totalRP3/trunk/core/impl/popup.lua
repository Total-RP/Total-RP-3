--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local Utils = TRP3_UTILS;
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
-- Music browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local musicWidgetTab = {};
local filteredMusicList;

local function decorateMusic(lineFrame, musicURL)
	musicURL = filteredMusicList[musicURL];
	local musicName = musicURL:reverse();
	musicName = (musicName:sub(1, musicName:find("%\\")-1)):reverse();
	
	TRP3_SetTooltipForFrame(lineFrame, lineFrame, "RIGHT", 0, -30, musicName,
		("|cff00ff00%s\n\n|cffff9900%s: |cffffffff%s\n|cffff9900%s: |cffffffff%s"):format(musicURL, loc("CM_L_CLICK"), loc("REG_PLAYER_ABOUT_MUSIC_SELECT2"), loc("CM_R_CLICK"), loc("REG_PLAYER_ABOUT_MUSIC_LISTEN")));
	_G[lineFrame:GetName().."Text"]:SetText(musicName);
	lineFrame.musicURL = musicURL;
end

local function onMusicClick(lineFrame, mousebutton)
	if mousebutton == "LeftButton" then
		TRP3_HidePopups();
		if TRP3_MusicBrowserContent.callback then
			TRP3_MusicBrowserContent.callback(lineFrame.musicURL);
		end
	elseif lineFrame.musicURL then
		Utils.music.play(lineFrame.musicURL);
	end
	
end

local function filteredMusicBrowser()
	local filter = TRP3_MusicBrowserFilterBox:GetText();
	if filteredMusicList and filteredMusicList ~= TRP3_GetMusicList() then
		wipe(filteredMusicList);
		filteredMusicList = nil;
	end
	filteredMusicList = TRP3_GetMusicList(filter); -- Music tab is unfiltered
	
	TRP3_MusicBrowserTotal:SetText( (#filteredMusicList) .. " / " .. TRP3_GetMusicListSize() );
	TRP3_InitList(
		{
			widgetTab = musicWidgetTab,
			decorate = decorateMusic
		},
		filteredMusicList,
		TRP3_MusicBrowserContentSlider
	);
end

function TRP3_UI_InitMusicBrowser()
	TRP3_HandleMouseWheel(TRP3_MusicBrowserContent, TRP3_MusicBrowserContentSlider);
	TRP3_MusicBrowserContentSlider:SetValue(0);
	-- Create lines
	for line = 0, 8 do
		local lineFrame = CreateFrame("Button", "TRP3_MusicBrowserButton_"..line, TRP3_MusicBrowserContent, "TRP3_MusicBrowserLine");
		lineFrame:SetPoint("TOP", TRP3_MusicBrowserContent, "TOP", 0, -10 + (line * (-31)));
		lineFrame:SetScript("OnClick", onMusicClick);
		tinsert(musicWidgetTab, lineFrame);
	end
	
	TRP3_MusicBrowserFilterBox:SetScript("OnTextChanged", filteredMusicBrowser);
	
	TRP3_MusicBrowserTitle:SetText(loc("UI_MUSIC_BROWSER"));
	TRP3_MusicBrowserFilterBoxText:SetText(loc("UI_FILTER"));
	TRP3_MusicBrowserFilterStop:SetText(loc("REG_PLAYER_ABOUT_MUSIC_STOP"));
	filteredMusicBrowser();
end

function TRP3_OpenMusicBrowser(callback)
	TRP3_MusicBrowserContent.callback = callback;
	TRP3_MusicBrowserFilterBox:SetText("");
	TRP3_ShowPopup(TRP3_MusicBrowser);
	TRP3_MusicBrowserFilterBox:SetFocus();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Icon browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local iconWidgetTab = {};
local filteredIconList = {};

local function decorateIcon(icon, index)
	icon:SetNormalTexture("Interface\\ICONS\\"..filteredIconList[index]);
	icon:SetPushedTexture("Interface\\ICONS\\"..filteredIconList[index]);
	TRP3_SetTooltipForFrame(icon, TRP3_IconBrowser, "RIGHT", 0, -100, Utils.str.icon(filteredIconList[index], 75), filteredIconList[index]);
	icon.index = index;
end

local function onIconClick(icon)
	TRP3_HidePopups();
	if TRP3_IconBrowserContent.callback then
		TRP3_IconBrowserContent.callback(filteredIconList[icon.index], icon);
	end
end

local function filteredIconBrowser()
	local filter = TRP3_IconBrowserFilterBox:GetText();
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
	TRP3_IconBrowserContentSlider:SetValue(0);
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

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Color browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onColorSliderChanged()
	local red = TRP3_ColorBrowserRed:GetValue() / 255;
	local green = TRP3_ColorBrowserGreen:GetValue() / 255;
	local blue = TRP3_ColorBrowserBlue:GetValue() / 255;
	TRP3_ColorBrowserView:SetTexture(red, green, blue);
	TRP3_ColorBrowserViewText:SetTextColor(red, green, blue);
end

function TRP3_UI_InitColorBrowser()
	TRP3_ColorBrowserViewText:SetText(loc("UI_COLOR_BROWSER_PREVIEW"));
	TRP3_ColorBrowserSelect:SetText(loc("UI_COLOR_BROWSER_SELECT"));
	TRP3_ColorBrowserTitle:SetText(loc("UI_COLOR_BROWSER"));
	TRP3_ColorBrowserRedText:SetText(loc("UI_COLOR_BROWSER_RED"));
	TRP3_ColorBrowserRedHigh:SetText(loc("UI_COLOR_BROWSER_MAX"));
	TRP3_ColorBrowserRedLow:SetText(loc("UI_COLOR_BROWSER_MIN"));
	TRP3_ColorBrowserGreenText:SetText(loc("UI_COLOR_BROWSER_GREEN"));
	TRP3_ColorBrowserGreenHigh:SetText(loc("UI_COLOR_BROWSER_MAX"));
	TRP3_ColorBrowserGreenLow:SetText(loc("UI_COLOR_BROWSER_MIN"));
	TRP3_ColorBrowserBlueText:SetText(loc("UI_COLOR_BROWSER_BLUE"));
	TRP3_ColorBrowserBlueHigh:SetText(loc("UI_COLOR_BROWSER_MAX"));
	TRP3_ColorBrowserBlueLow:SetText(loc("UI_COLOR_BROWSER_MIN"));
	TRP3_ColorBrowserRed:SetValue(255);
	TRP3_ColorBrowserGreen:SetValue(255);
	TRP3_ColorBrowserBlue:SetValue(255);
	onColorSliderChanged();
	
	TRP3_ColorBrowserRed:SetScript("OnValueChanged", onColorSliderChanged);
	TRP3_ColorBrowserGreen:SetScript("OnValueChanged", onColorSliderChanged);
	TRP3_ColorBrowserBlue:SetScript("OnValueChanged", onColorSliderChanged);
	TRP3_ColorBrowserSelect:SetScript("OnClick", function()
		local red = math.ceil(TRP3_ColorBrowserRed:GetValue());
		local green = math.ceil(TRP3_ColorBrowserGreen:GetValue());
		local blue = math.ceil(TRP3_ColorBrowserBlue:GetValue());
		TRP3_HidePopups();
		if TRP3_ColorBrowser.callback ~= nil then
			TRP3_ColorBrowser.callback(red, green, blue);
		end
	end);
end

function TRP3_OpenColorBrowser(callback)
	TRP3_ColorBrowser.callback = callback;
	TRP3_ShowPopup(TRP3_ColorBrowser);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Color browser
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local imageWidgetTab = {};
local filteredImageList = {};

local function onImageSelect()
	assert(TRP3_ImageBrowserContent.currentImage, "No current image ...");
	TRP3_HidePopups();
	if TRP3_ImageBrowser.callback then
		TRP3_ImageBrowser.callback(filteredImageList[TRP3_ImageBrowserContent.currentImage]);
	end
end

local function decorateImage(texture, index)
	local image = filteredImageList[index];
	local ratio = image.height / image.width;
	texture:SetHeight(texture:GetWidth() * ratio);
	texture:SetTexture(image.url);
	TRP3_ImageBrowserContentURL:SetText(image.url:sub(11));
	TRP3_ImageBrowserContent.currentImage = index;
end

local function filteredImageBrowser()
--	TRP3_ImageBrowserContentTexture
	local filter = TRP3_ImageBrowserFilterBox:GetText();
	filteredImageList = TRP3_GetImageList(filter);
	local size = #filteredImageList;
	TRP3_ImageBrowserTotal:SetText( size .. " / " .. TRP3_GetImageListSize() );
	if size > 0 then
		TRP3_ImageBrowserSelect:Enable();
	else
		TRP3_ImageBrowserSelect:Disable();
	end
	TRP3_InitList(
		{
			widgetTab = imageWidgetTab,
			decorate = decorateImage
		},
		filteredImageList,
		TRP3_ImageBrowserContentSlider
	);
end

function TRP3_UI_InitImageBrowser()
	TRP3_HandleMouseWheel(TRP3_ImageBrowserContent, TRP3_ImageBrowserContentSlider);
	TRP3_ImageBrowserContentSlider:SetValue(0);
	TRP3_ImageBrowserFilterBox:SetScript("OnTextChanged", filteredImageBrowser);
	TRP3_ImageBrowserSelect:SetScript("OnClick", onImageSelect);
	
	tinsert(imageWidgetTab, TRP3_ImageBrowserContentTexture);
	
	TRP3_ImageBrowserTitle:SetText(loc("UI_IMAGE_BROWSER"));
	TRP3_ImageBrowserFilterBoxText:SetText(loc("UI_FILTER"));
	TRP3_ImageBrowserSelect:SetText(loc("UI_IMAGE_SELECT"));
	filteredImageBrowser();
end

function TRP3_OpenImageBrowser(callback)
	TRP3_ImageBrowser.callback = callback;
	TRP3_ShowPopup(TRP3_ImageBrowser);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_UI_InitPopups()
	TRP3_UI_InitIconBrowser();
	TRP3_UI_InitMusicBrowser();
	TRP3_UI_InitColorBrowser();
	TRP3_UI_InitImageBrowser();
end

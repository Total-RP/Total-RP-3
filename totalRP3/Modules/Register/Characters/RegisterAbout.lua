-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- imports
local Globals, Utils, Events = TRP3_API.globals, TRP3_API.utils, TRP3_Addon.Events;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_API.profile.getData;
local tcopy = Utils.table.copy;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local showIfMouseOver = TRP3_API.ui.frame.showIfMouseOverFrame;
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
local hasProfile, getProfile = TRP3_API.register.hasProfile, TRP3_API.register.getProfile;
local getConfigValue, registerConfigKey, registerHandler = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler;

-- Total RP 3 imports
local loc = TRP3_API.loc;

-- Config keys
local CONFIG_REGISTER_ABOUT_P_SIZE = "config_register_about_p_size";
local CONFIG_REGISTER_ABOUT_H1_SIZE = "config_register_about_h1_size";
local CONFIG_REGISTER_ABOUT_H2_SIZE = "config_register_about_h2_size";
local CONFIG_REGISTER_ABOUT_H3_SIZE = "config_register_about_h3_size";

local defaultFontParameters;
local refreshTemplate2EditDisplay, saveInDraft, template2SaveToDraft; -- Function reference

local showIconBrowser = function(callback, selectedIcon)
	TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {callback, nil, nil, selectedIcon});
end;

local function CreateFontFamily(fontName, inherits)
	-- Note that 'inherits' needs to be an XML FontFamily object, not a Font.
	local fontFamily = CreateFont(fontName);
	fontFamily:CopyFontObject(inherits);
	return fontFamily;
end

CreateFontFamily("TRP3_AboutParagraphFont", SystemFont_Shadow_Med1);
CreateFontFamily("TRP3_AboutHeader1Font", SystemFont_Shadow_Huge3);
CreateFontFamily("TRP3_AboutHeader2Font", SystemFont_Shadow_Huge1);
CreateFontFamily("TRP3_AboutHeader3Font", SystemFont_Shadow_Large);

local function updateAllAboutTemplateFonts()
	TRP3_FontUtil.SetFontOptions(TRP3_AboutParagraphFont, getConfigValue(CONFIG_REGISTER_ABOUT_P_SIZE));
	TRP3_FontUtil.SetFontOptions(TRP3_AboutHeader1Font, getConfigValue(CONFIG_REGISTER_ABOUT_H1_SIZE));
	TRP3_FontUtil.SetFontOptions(TRP3_AboutHeader2Font, getConfigValue(CONFIG_REGISTER_ABOUT_H2_SIZE));
	TRP3_FontUtil.SetFontOptions(TRP3_AboutHeader3Font, getConfigValue(CONFIG_REGISTER_ABOUT_H3_SIZE));
end

local function setupHTMLFonts(frame)
	frame:SetFontObject("p", TRP3_AboutParagraphFont);
	frame:SetFontObject("h1", TRP3_AboutHeader1Font);
	frame:SetFontObject("h2", TRP3_AboutHeader2Font);
	frame:SetFontObject("h3", TRP3_AboutHeader3Font);

	frame:SetTextColor("h1", 1, 1, 1);
	frame:SetTextColor("h2", 1, 1, 1);
	frame:SetTextColor("h3", 1, 1, 1);

	-- Only need to fill once
	if not defaultFontParameters then
		defaultFontParameters = { p = {}, h1 = {}, h2 = {}, h3 = {}};
		defaultFontParameters.p.font, defaultFontParameters.p.size = frame:GetFont("p");
		defaultFontParameters.h1.font, defaultFontParameters.h1.size = frame:GetFont("h1");
		defaultFontParameters.h2.font, defaultFontParameters.h2.size = frame:GetFont("h2");
		defaultFontParameters.h3.font, defaultFontParameters.h3.size = frame:GetFont("h3");
	end
end

local function setToolbarTextFrameScript(toolbar, frame)
	frame:SetScript("OnEditFocusGained", function() TRP3_API.ui.text.changeToolbarTextFrame(toolbar, frame) end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

getDefaultProfile().player.about = {
	v = 1,
	TE = 1,
	T1 = {

	},
	T2 = {

	},
	T3 = {
		PH = {}, PS = {}, HI = {}
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ABOUT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local draftData;

local function setConsultBkg(bkg)
	TRP3_API.ui.frame.setBackdropToBackground(TRP3_RegisterAbout, bkg);
end

local function setEditBkg(bkg)
	draftData.BK = bkg;
	TRP3_API.ui.frame.setBackdropToBackground(TRP3_RegisterAbout, bkg);
end

local function selectMusic(music)
	if music then
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc.REG_PLAYER_ABOUT_MUSIC_THEME, Utils.music.getTitle(music) or UNKNOWN));
	else
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc.REG_PLAYER_ABOUT_MUSIC_THEME, loc.REG_PLAYER_ABOUT_NOMUSIC));
	end
end

--- pasteCopiedIcon handles receiving an icon from the right-click menu.
---@param frame Frame The frame the icon belongs to.
---@param frameData Frame The draftData frame that holds all the info.
local function pasteCopiedIcon(frame, frameData)
	local icon = TRP3_API.GetLastCopiedIcon() or TRP3_InterfaceIcons.Default;
	frameData.IC = icon;
	setupIconButton(frame, icon);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 1
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--- shouldShowTemplate1 checks if the frame in T1 has data in it.
---@param dataTab table Given profile's about tab data.
---@return boolean # Whether the T1 frame has data in it.
local function shouldShowTemplate1(dataTab)
	local templateData = dataTab.T1 or {};
	return templateData.TX and strtrim(templateData.TX):len() > 0;
end

local function showTemplate1(dataTab)
	local templateData = dataTab.T1 or {};
	if shouldShowTemplate1(dataTab) then
		local text = Utils.str.toHTML(templateData.TX or "");
		TRP3_RegisterAbout_AboutPanel_Template1:SetText(text);
		TRP3_RegisterAbout_AboutPanel_Template1.html = text;
	else
		TRP3_RegisterAbout_AboutPanel_Empty:Show();
		TRP3_RegisterAbout_AboutPanel_Template1:SetText("");
		TRP3_RegisterAbout_AboutPanel_Template1.html = "";
	end
	TRP3_RegisterAbout_AboutPanel_Template1:Show();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 2
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local template2Frames = {};
local TEMPLATE2_PADDING = 30;

--- shouldShowTemplate2 checks if at least one frame in T2 has data in it.
---@param dataTab table Given profile's about tab data.
---@return boolean # Whether at least one frame has data in it.
local function shouldShowTemplate2(dataTab)
	local templateData = dataTab.T2 or {};
	for _, frameTab in pairs(templateData) do
		if frameTab.TX and strtrim(frameTab.TX):len() > 0 then
			return true;
		end
	end
	return false;
end

local function resizeTemplate2()
	for _, frame in pairs(template2Frames) do
		local text = frame.Text;
		local height = 0;

		local numRegions = select("#", text:GetRegions());
		for j = 1, numRegions do
			local region = select(j, text:GetRegions());
			height = height + region:GetHeight();
		end

		height = math.max(height, 50) + TEMPLATE2_PADDING;
		frame:SetHeight(height);
	end
end

local function showTemplate2(dataTab)
	local templateData = dataTab.T2 or {};

	-- Hide all
	for _, frame in pairs(template2Frames) do
		local text = frame.Text;
		text:SetText("");
		frame:Hide();
	end

	local frameIndex = 1;
	local previous = TRP3_RegisterAbout_AboutPanel_Template2Title;
	local bool = true;
	for _, frameTab in pairs(templateData) do
		local frame = template2Frames[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Frame"..frameIndex, TRP3_RegisterAbout_AboutPanel_Template2, "TRP3_RegisterAbout_Template2_Frame");
			tinsert(template2Frames, frame);
		end
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
		frame:SetPoint("RIGHT", -5, 0);

		local icon = frame.Icon;
		local text = frame.Text;
		TRP3_API.ui.frame.setBackdropToBackground(frame, frameTab.BK);
		frame.Icon:SetIconTexture(frameTab.IC);

		setupHTMLFonts(text);

		-- We'll need to access the HTML later when resizing things.
		text.html = Utils.str.toHTML(frameTab.TX or "")
		text:SetText(text.html);

		icon:ClearAllPoints();
		text:ClearAllPoints();
		if bool then
			icon:SetPoint("LEFT", 15, 0);
			text:SetPoint("LEFT", icon, "RIGHT", 10, 0);
			text:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -10)
		else
			icon:SetPoint("RIGHT", -15, 0);
			text:SetPoint("RIGHT", icon, "LEFT", -10, 0);
			text:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -10)
		end

		if frameTab.TX and frameTab.TX:len() > 0 then
			frame:Show();
			previous = frame;
		else
			frame:Hide();
		end

		frameIndex = frameIndex + 1;
		bool = not bool;
	end
	resizeTemplate2();

	if not shouldShowTemplate2(dataTab) then
		TRP3_RegisterAbout_AboutPanel_Empty:Show();
	end

	TRP3_RegisterAbout_AboutPanel_Template2:Show();
end

local template2EditFrames = {};

local function setTemplate2EditBkg(bkg, frame)
	frame = frame:GetParent();
	assert(frame.frameData, "No frameData in the frame ...");
	TRP3_API.ui.frame.setBackdropToBackground(frame, bkg);
	frame.frameData.BK = bkg;
end

local function template2DeleteFrame(button)
	template2SaveToDraft();
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	tremove(templateData, frame.index);
	refreshTemplate2EditDisplay();
end

local function template2UpFrame(button)
	template2SaveToDraft();
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index - 1, frameData);
	refreshTemplate2EditDisplay();
end

local function template2DownFrame(button)
	template2SaveToDraft();
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.T2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index + 1, frameData);
	refreshTemplate2EditDisplay();
end

local function createTemplate2Frame(frameIndex)
	local frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Edit"..frameIndex, TRP3_RegisterAbout_Edit_Template2_Container, "TRP3_RegisterAbout_Template2_Edit");

	local BackgroundButton = _G["TRP3_RegisterAbout_Template2_Edit"..frameIndex.."Bkg"];
	BackgroundButton:SetText(loc.UI_BKG_BUTTON);
	BackgroundButton:SetScript("OnClick", function()
		local function OnBackgroundSelected(imageInfo)
			setTemplate2EditBkg(imageInfo and imageInfo.id or nil, BackgroundButton);
		end

		TRP3_API.popup.ShowBackgroundBrowser(OnBackgroundSelected, frame.frameData.BK);
	end);

	_G[frame:GetName().."Delete"]:SetScript("OnClick", template2DeleteFrame);
	_G[frame:GetName().."Delete"]:SetText(loc.CM_REMOVE);
	_G[frame:GetName().."Up"]:SetScript("OnClick", template2UpFrame);
	_G[frame:GetName().."Down"]:SetScript("OnClick", template2DownFrame);
	setTooltipAll(_G[frame:GetName().."Up"], "RIGHT", 0, 5, loc.REG_PLAYER_REORDER, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.CM_MOVE_UP));
	setTooltipAll(_G[frame:GetName().."Down"], "RIGHT", 0, 5, loc.REG_PLAYER_REORDER, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.CM_MOVE_DOWN));
	setTooltipAll(_G[frame:GetName().."Icon"], "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, _G["TRP3_RegisterAbout_Template2_Edit"..frameIndex.."TextScrollText"]);
	tinsert(template2EditFrames, frame);
	return frame;
end

function refreshTemplate2EditDisplay()
	-- Hide all
	for _, frame in pairs(template2EditFrames) do
		frame:Hide();
		frame.frameData = nil; -- Helps garbage collection
	end

	local templateData = draftData.T2;
	assert(type(templateData) == "table", "Error: Nil template 2 data or not a table.");

	local previous;
	for frameIndex, frameData in pairs(templateData) do
		local frame = template2EditFrames[frameIndex];
		if frame == nil then
			frame = createTemplate2Frame(frameIndex);
		end
		-- Position
		frame:ClearAllPoints();
		frame:SetPoint("LEFT", 0, 0);
		frame:SetPoint("RIGHT", -5, 0);
		if previous == nil then
			frame:SetPoint("TOPLEFT", TRP3_RegisterAbout_Edit_Template2_Container, "TOPLEFT", 10, -10);
		else
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
		end
		-- Values
		frame.index = frameIndex;
		frame.frameData = frameData;
		_G[frame:GetName().."TextScrollText"]:SetText(frameData.TX or "");
		setupIconButton(_G[frame:GetName().."Icon"], frameData.IC or TRP3_InterfaceIcons.Default);
		_G[frame:GetName().."Icon"]:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				showIconBrowser(function(icon)
					frame.frameData.IC = icon;
					setupIconButton(_G[frame:GetName().."Icon"], icon);
				end, frameData.IC);
			elseif button == "RightButton" then
				local icon = frameData.IC or TRP3_InterfaceIcons.Default;
				TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
					description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
					description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
					description:CreateButton(loc.UI_ICON_PASTE, function() pasteCopiedIcon(_G[frame:GetName().."Icon"], frameData); end);
				end);
			end
		end);
		-- Buttons
		if frameIndex == 1 then
			_G[frame:GetName().."Up"]:Hide();
		else
			_G[frame:GetName().."Up"]:Show();
		end
		if frameIndex == #templateData then
			_G[frame:GetName().."Down"]:Hide();
		else
			_G[frame:GetName().."Down"]:Show();
		end

		TRP3_API.ui.frame.setBackdropToBackground(frame, frameData.BK);

		frame:Show();
		previous = frame;
	end
end

local function template2AddFrame()
	template2SaveToDraft();
	local templateData = draftData.T2;
	tinsert(templateData, {TX = loc.REG_PLAYER_ABOUT_SOME});
	TRP3_RegisterAbout_AboutPanel_Edit:Hide(); -- Hack to prevent invisible ScrollFontString bug
	refreshTemplate2EditDisplay();
	TRP3_RegisterAbout_AboutPanel_Edit:Show();
end

--- Save to draft all the frames texts
function template2SaveToDraft()
	for _, frame in pairs(template2EditFrames) do
		if frame:IsVisible() then
			assert(frame.frameData, "Frame has no frameData !");
			frame.frameData.TX = stEtN(_G[frame:GetName().."TextScrollText"]:GetText());
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 3
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TEMPLATE3_MARGIN = 30;
local TEMPLATE3_ICON_PHYSICAL = TRP3_InterfaceIcons.PhysicalSection;
local TEMPLATE3_ICON_PSYCHO = TRP3_InterfaceIcons.TraitSection;
local TEMPLATE3_ICON_HISTORY = TRP3_InterfaceIcons.HistorySection;

local function setTemplate3PhysBkg(bkg)
	draftData.T3.PH.BK = bkg;
	TRP3_API.ui.frame.setBackdropToBackground(TRP3_RegisterAbout_Edit_Template3_Phys, bkg);
end

local function setTemplate3PsyBkg(bkg)
	draftData.T3.PS.BK = bkg;
	TRP3_API.ui.frame.setBackdropToBackground(TRP3_RegisterAbout_Edit_Template3_Psy, bkg);
end

local function setTemplate3HistBkg(bkg)
	draftData.T3.HI.BK = bkg;
	TRP3_API.ui.frame.setBackdropToBackground(TRP3_RegisterAbout_Edit_Template3_Hist, bkg);
end

local function onPhisIconSelected(icon)
	draftData.T3.PH.IC = icon;
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, icon or TEMPLATE3_ICON_PHYSICAL);
end

local function onPsychoIconSelected(icon)
	draftData.T3.PS.IC = icon;
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, icon or TEMPLATE3_ICON_PSYCHO);
end

local function onHistoIconSelected(icon)
	draftData.T3.HI.IC = icon;
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, icon or TEMPLATE3_ICON_HISTORY);
end

--- shouldShowTemplate3 checks if at least one frame in T3 has data in it.
---@param dataTab table Given profile's about tab data.
---@return boolean # Whether at least one frame has data in it.
local function shouldShowTemplate3(dataTab)
	local templateData = dataTab.T3 or {};
	local datas = {templateData.PH, templateData.PS, templateData.HI};
	for i=1, 3 do
		local data = datas[i] or {};
		if data.TX and strtrim(data.TX):len() > 0 then
			return true;
		end
	end
	return false;
end

local function resizeTemplate3()
	for i=1, 3 do
		local frame = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s"):format(i)];
		local text = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Text"):format(i)];
		local title = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Title"):format(i)];

		if not text.html or text.html:len() == 0 then
			frame:SetHeight(1)
		else
			-- Use the height of the title text, the margin, and sum up
			-- the regions within the HTML frame itself.
			local frameHeight = title:GetHeight() + (TEMPLATE3_MARGIN);

			local numRegions = select("#", text:GetRegions());
			for j = 1, numRegions do
				local region = select(j, text:GetRegions());
				frameHeight = frameHeight + region:GetHeight();
			end

			frame:SetHeight(frameHeight);
		end
	end
end

local function showTemplate3(dataTab)
	local templateData = dataTab.T3 or {};
	local datas = {templateData.PH, templateData.PS, templateData.HI};
	local titles = {loc.REG_PLAYER_PHYSICAL, loc.REG_PLAYER_PSYCHO, loc.REG_PLAYER_HISTORY};
	local icons = {TEMPLATE3_ICON_PHYSICAL, TEMPLATE3_ICON_PSYCHO, TEMPLATE3_ICON_HISTORY};

	for i=1, 3 do
		local data = datas[i] or {};
		local frame = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s"):format(i)];
		local text = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Text"):format(i)];
		text:SetText("");
		if data.TX and data.TX:len() > 0 then
			local icon = Utils.str.icon(data.IC or icons[i], 25);
			local title = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Title"):format(i)];
			title:SetText(icon .. "    " .. titles[i] .. "    " .. icon);

			-- We'll need to access the HTML later when resizing things.
			text.html = Utils.str.toHTML(data.TX or "")
			text:SetText(text.html);

			TRP3_API.ui.frame.setBackdropToBackground(frame, data.BK);
			frame:Show();
		else
			frame:Hide();
		end
	end
	resizeTemplate3();

	if not shouldShowTemplate3(dataTab) then
		TRP3_RegisterAbout_AboutPanel_Empty:Show();
	end
	TRP3_RegisterAbout_AboutPanel_Template3:Show();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function getOptimizedData()
	local dataTab = get("player/about");
	-- Optimize : only send the selected template
	local dataToSend = {};
	tcopy(dataToSend, dataTab);
	-- Don't send data about templates you don't use ...
	local template = dataToSend.TE or 1;
	if template ~= 1 then
		dataToSend.T1 = nil;
	end
	if template ~= 2 then
		dataToSend.T2 = nil;
	end
	if template ~= 3 then
		dataToSend.T3 = nil;
	end
	return dataToSend;
end

function TRP3_API.register.player.getAboutExchangeData()
	return getOptimizedData();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local templatesFunction = {
	showTemplate1,
	showTemplate2,
	showTemplate3
}

local function resetHTMLText(frame)
	frame:SetText(frame.html or "");
end

local function ResizeTemplateViews()
	local containerWidth, containerHeight = TRP3_MainFramePageContainer:GetSize();

	TRP3_RegisterAbout_AboutPanel_Container:SetSize(containerWidth - 40, 5);
	TRP3_RegisterAbout_AboutPanel_Template1:SetSize(containerWidth - 50, 5);
	TRP3_RegisterAbout_AboutPanel_Template3_1_Text:SetWidth(containerWidth - 75);
	resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template3_1_Text);
	TRP3_RegisterAbout_AboutPanel_Template3_2_Text:SetWidth(containerWidth - 75);
	resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template3_2_Text);
	TRP3_RegisterAbout_AboutPanel_Template3_3_Text:SetWidth(containerWidth - 75);
	resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template3_3_Text);
	TRP3_RegisterAbout_Edit_Template3_Phys:SetHeight((containerHeight - 165) * 0.33);
	TRP3_RegisterAbout_Edit_Template3_Psy:SetHeight((containerHeight - 165) * 0.33);
	TRP3_RegisterAbout_Edit_Template1ScrollText:SetSize(containerWidth - 65, 5);
	TRP3_RegisterAbout_Edit_Template2_Container:SetSize(containerWidth - 60, 5);
	resizeTemplate3();
	resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template1);
	for _, frame in pairs(template2Frames) do
		frame.Text:SetWidth(containerWidth - 150);
		resetHTMLText(frame.Text);
	end
	for _, frame in pairs(template2EditFrames) do
		frame:SetHeight(containerHeight * 0.45);
		_G[frame:GetName().."TextScrollText"]:SetWidth(containerWidth - 180);
	end
	resizeTemplate2();

	TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:SetWidth(containerWidth - 200);
	TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:SetWidth(containerWidth - 200);
	TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:SetWidth(containerWidth - 200);
end

local function refreshConsultDisplay(context)
	local dataTab = context.profile.about or Globals.empty;
	local template = dataTab.TE or 1;
	TRP3_RegisterAbout_AboutPanel.isMine = context.isPlayer;

	TRP3_ProfileReportButton:Hide();
	if not context.isPlayer then
		if dataTab ~= Globals.empty then
			dataTab.read = true;
		end
		TRP3_Addon:TriggerEvent(Events.REGISTER_ABOUT_READ);
		if context.profile and context.profile.link then
			TRP3_ProfileReportButton:Show();
		end
	end

	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	assert(template, "Error: No about template ID.");
	assert(type(templatesFunction[template]) == "function", "Error: no function for about template: " .. tostring(template));

	TRP3_RegisterAbout_AboutPanel.musicURL = dataTab.MU;
	if dataTab.MU then
		TRP3_RegisterAbout_AboutPanel_MusicPlayer_URL:SetText(Utils.music.getTitle(dataTab.MU));
	end

	TRP3_RegisterAbout_AboutPanel_EditButton:Hide();
	TRP3_RegisterAbout_AboutPanel:Show();
	-- Putting the right templates
	templatesFunction[template](dataTab);
	-- Putting the righ background
	setConsultBkg(dataTab.BK);
	ResizeTemplateViews();
end

function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.TE = TRP3_RegisterAbout_Edit_TemplateField:GetSelectedValue();
	-- Template 1
	draftData.T1.TX = TRP3_RegisterAbout_Edit_Template1ScrollText:GetText();
	-- Template 2
	template2SaveToDraft();
	-- Template 3
	draftData.T3.PH.TX = stEtN(TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:GetText());
	draftData.T3.PS.TX = stEtN(TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:GetText());
	draftData.T3.HI.TX = stEtN(TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:GetText());
end

local function setEditTemplate(value)
	TRP3_RegisterAbout_Edit_Template1:Hide();
	TRP3_RegisterAbout_Edit_Template2:Hide();
	TRP3_RegisterAbout_Edit_Template3:Hide();
	_G["TRP3_RegisterAbout_Edit_Template"..value]:Show();

	if value == 1 then
		TRP3_API.ui.text.changeToolbarTextFrame(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template1ScrollText);
	elseif value == 2 then
		TRP3_API.ui.text.changeToolbarTextFrame(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Template2_Edit1TextScrollText);
	else
		TRP3_API.ui.text.changeToolbarTextFrame(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText);
	end

	draftData.TE = value;
	TRP3_Addon:TriggerEvent(TRP3_Addon.Events.NAVIGATION_TUTORIAL_REFRESH, "player_main");
	TRP3_API.navigation.delayedRefresh();
end

local function save()
	saveInDraft();

	local dataTab = get("player/about");
	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.v) == "number", "Error: No version in draftData or not a number.");
	dataTab.v = Utils.math.incrementNumber(dataTab.v, 2);

	TRP3_Addon:TriggerEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getCurrentContext().profileID, "about");
end

local function refreshEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/about");
		assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end

	TRP3_RegisterAbout_Edit_TemplateField:SetSelectedIndex(draftData.TE or 1);
	selectMusic(draftData.MU);
	-- Template 1
	local template1Data = draftData.T1;
	assert(type(template1Data) == "table", "Error: Nil template1 data or not a table.");
	TRP3_RegisterAbout_Edit_Template1ScrollText:SetText(template1Data.TX or "");
	-- Template 2
	refreshTemplate2EditDisplay();
	-- Template 3
	local template3Data = draftData.T3;
	assert(type(template3Data) == "table", "Error: Nil template3 data or not a table.");
	setTemplate3PhysBkg(template3Data.PH.BK or 1);
	setTemplate3PsyBkg(template3Data.PS.BK or 1);
	setTemplate3HistBkg(template3Data.HI.BK or 1);
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, template3Data.PH.IC or TEMPLATE3_ICON_PHYSICAL);
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, template3Data.PS.IC or TEMPLATE3_ICON_PSYCHO);
	setupIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, template3Data.HI.IC or TEMPLATE3_ICON_HISTORY);
	TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:SetText(template3Data.PH.TX or "");
	TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:SetText(template3Data.PS.TX or "");
	TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:SetText(template3Data.HI.TX or "");

	TRP3_RegisterAbout_AboutPanel_Edit:Show();
	setEditTemplate(draftData.TE or 1);
end

local function refreshDisplay()
	local context = getCurrentContext();
	assert(context, "No context for page player_main !");
	assert(context.profile, "No profile in context");

	--Hide all templates
	TRP3_RegisterAbout_AboutPanel_Template1:Hide();
	TRP3_RegisterAbout_AboutPanel_Template2:Hide();
	TRP3_RegisterAbout_AboutPanel_Template3:Hide();
	TRP3_RegisterAbout_AboutPanel_Empty:Hide();
	TRP3_RegisterAbout_AboutPanel:Hide();
	TRP3_RegisterAbout_AboutPanel_Edit:Hide();

	if context.isEditMode then
		assert(context.isPlayer, "Trying to show About edition for another than mine ...");
		refreshEditDisplay();
	else
		refreshConsultDisplay(context);
	end
end

local function showAboutTab()
	TRP3_RegisterAbout_AboutPanel_MusicPlayer:Hide();
	TRP3_MainTutorialButton:Hide();
	TRP3_RegisterAbout:Show();
	getCurrentContext().isEditMode = false;
	refreshDisplay();
end
TRP3_API.register.ui.showAboutTab = showAboutTab;

local function onEdit()
	if draftData then
		wipe(draftData);
		draftData = nil;
	end
	getCurrentContext().isEditMode = true;
	refreshDisplay();
	PlaySound(TRP3_InterfaceSounds.ButtonClick);
end

function TRP3_API.register.ui.shouldShowAboutTab(profile)
	if profile and profile.about then
		local dataTab = profile.about;
		return (dataTab.TE == 1 and shouldShowTemplate1(dataTab))
		or (dataTab.TE == 2 and shouldShowTemplate2(dataTab))
		or (dataTab.TE == 3 and shouldShowTemplate3(dataTab));
	end
	return false;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MUSIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onMusicSelected(music)
	draftData.MU = music;
	selectMusic(draftData.MU);
end

local function onMusicEditSelected(value)
	if value == 1 then
		TRP3_API.popup.showPopup(TRP3_API.popup.MUSICS, nil, {onMusicSelected});
	elseif value == 2 and draftData.MU then
		draftData.MU = nil;
		selectMusic(draftData.MU);
	elseif value == 3 and draftData.MU then
		Utils.music.playMusic(draftData.MU);
	elseif value == 4 and draftData.MU then
		Utils.music.stopMusic();
	end
end

local function onMusicEditClicked(button)
	TRP3_MenuUtil.CreateContextMenu(button, function(_, description)
		description:CreateButton(loc.REG_PLAYER_ABOUT_MUSIC_SELECT, onMusicEditSelected, 1);
		if draftData.MU then
			description:CreateButton(loc.REG_PLAYER_ABOUT_MUSIC_REMOVE, onMusicEditSelected, 2);
			description:CreateButton(loc.REG_PLAYER_ABOUT_MUSIC_LISTEN, onMusicEditSelected, 3);
			description:CreateButton(loc.REG_PLAYER_ABOUT_MUSIC_STOP, onMusicEditSelected, 4);
		end
	end);
end

local function getUnitIDTheme(unitID)
	if unitID == Globals.player_id then
		return get("player/about/MU");
	elseif isUnitIDKnown(unitID) and hasProfile(unitID) and getUnitIDProfile(unitID).about then
		return getUnitIDProfile(unitID).about.MU;
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI MISC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TRP3_RegisterAbout_AboutPanel_EditButton = TRP3_RegisterAbout_AboutPanel_EditButton;
local TRP3_RegisterAbout_AboutPanel_MusicPlayer = TRP3_RegisterAbout_AboutPanel_MusicPlayer;

local function onPlayerAboutRefresh()
	if TRP3_RegisterAbout_AboutPanel.isMine then
		showIfMouseOver(TRP3_RegisterAbout_AboutPanel_EditButton, TRP3_RegisterAbout_AboutPanel);
	end
	if TRP3_RegisterAbout_AboutPanel.musicURL then
		showIfMouseOver(TRP3_RegisterAbout_AboutPanel_MusicPlayer, TRP3_RegisterAbout_AboutPanel);
	end
end

local function onSave()
	save();
	showAboutTab();
end

local function onAboutReceived(profileID)
	local aboutData = getProfile(profileID).about;
	-- Check that there is a description. If not => set read to true !
	local noDescr = (aboutData.TE == 1 and not shouldShowTemplate1(aboutData)) or (aboutData.TE == 2 and not shouldShowTemplate2(aboutData)) or (aboutData.TE == 3 and not shouldShowTemplate3(aboutData));
	if noDescr then
		aboutData.read = true;
		TRP3_Addon:TriggerEvent(Events.REGISTER_ABOUT_READ);
	end
	if aboutData.MU and type(aboutData) == "string" then
		aboutData.MU = Utils.music.convertPathToID(aboutData.MU);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TUTORIAL
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TUTORIAL_EDIT_COMMON, TUTORIAL_EDIT_FORMATTING, TUTORIAL_EDIT_T1, TUTORIAL_EDIT_T2, TUTORIAL_EDIT_T3

local function createTutorialStructures()
	TUTORIAL_EDIT_COMMON = {
		box = {
			allPoints = TRP3_RegisterAbout_Edit_Options
		},
		button = {
			x = 0, y = 0, anchor = "CENTER",
			text = loc.REG_PLAYER_TUTO_ABOUT_COMMON,
			textWidth = 450,
			arrow = "DOWN"
		}
	};

	TUTORIAL_EDIT_FORMATTING = {
		box = {
			allPoints = TRP3_RegisterAbout_Edit_Toolbar
		},
		button = {
			x = 0, y = 0, anchor = "CENTER",
			text = loc.REG_PLAYER_TUTO_FORMATTING_TOOLS,
			textWidth = 450,
			arrow = "DOWN"
		}
	};

	TUTORIAL_EDIT_T1 = {
		{
			box = {
				allPoints = TRP3_RegisterAbout_Edit_Template1
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_PLAYER_TUTO_ABOUT_T1,
				textWidth = 450,
				arrow = "UP"
			}
		},
		TUTORIAL_EDIT_COMMON,
		TUTORIAL_EDIT_FORMATTING
	}

	TUTORIAL_EDIT_T2 = {
		{
			box = {
				allPoints = TRP3_RegisterAbout_Edit_Template2
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_PLAYER_TUTO_ABOUT_T2,
				textWidth = 450,
				arrow = "UP"
			}
		},
		TUTORIAL_EDIT_COMMON,
		TUTORIAL_EDIT_FORMATTING
	}

	TUTORIAL_EDIT_T3 = {
		{
			box = {
				allPoints = TRP3_RegisterAbout_Edit_Template3
			},
			button = {
				x = 0, y = 0, anchor = "CENTER",
				text = loc.REG_PLAYER_TUTO_ABOUT_T3,
				textWidth = 450,
				arrow = "UP"
			}
		},
		TUTORIAL_EDIT_COMMON,
		TUTORIAL_EDIT_FORMATTING
	}
end


function TRP3_API.register.ui.aboutTutorialProvider()
	local context = getCurrentContext();
	if context and context.isEditMode and draftData then
		if draftData.TE == 1 then
			return TUTORIAL_EDIT_T1;
		elseif draftData.TE == 2 then
			return TUTORIAL_EDIT_T2;
		else
			return TUTORIAL_EDIT_T3;
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_b_music",
			onlyForType = AddOn_TotalRP3.Enums.UNIT_TYPE.CHARACTER,
			configText = loc.TF_CHAR_THEME,
			condition = function(_, unitID)
				return getUnitIDTheme(unitID) ~= nil;
			end,
			onClick = function(unitID, _, button)
				if button == "LeftButton" then
					Utils.music.playMusic(getUnitIDTheme(unitID));
				else
					Utils.music.stopMusic();
				end
			end,
			adapter = function(buttonStructure, unitID)
				local theme = getUnitIDTheme(unitID);
				if theme then
					buttonStructure.tooltipSub = TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.TF_CHAR_THEME_PLAY:format(Utils.music.getTitle(theme))) .. "\n" ..  TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.REG_PLAYER_ABOUT_MUSIC_STOP);
				end
			end,
			tooltip = loc.TF_CHAR_THEME,
			icon = TRP3_InterfaceIcons.TargetPlayMusic,
		});
	end
end);

function TRP3_API.register.inits.aboutInit()
	createTutorialStructures();

	-- UI
	createRefreshOnFrame(TRP3_RegisterAbout_AboutPanel, 0.2, onPlayerAboutRefresh);

	TRP3_RegisterAbout_Edit_BckField:SetText(loc.UI_BKG_BUTTON);
	TRP3_RegisterAbout_Edit_BckField:SetScript("OnClick", function()
		local function OnBackgroundSelected(imageInfo)
			setEditBkg(imageInfo and imageInfo.id or nil);
		end

		TRP3_API.popup.ShowBackgroundBrowser(OnBackgroundSelected, draftData.BK);
	end);

	setupListBox(TRP3_RegisterAbout_Edit_TemplateField, {{"Template 1", 1}, {"Template 2", 2}, {"Template 3", 3}}, setEditTemplate, nil, 150, true);
	setTooltipAll(TRP3_RegisterAbout_Edit_Template3_PhysIcon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	TRP3_RegisterAbout_Edit_Template3_PhysIcon:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			showIconBrowser(onPhisIconSelected, draftData.T3.PH.IC);
		elseif button == "RightButton" then
			local icon = draftData.T3.PH.IC or TEMPLATE3_ICON_PHYSICAL;
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
				description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
				description:CreateButton(loc.UI_ICON_PASTE, function() onPhisIconSelected(TRP3_API.GetLastCopiedIcon()); end);
			end);
		end
	end);

	TRP3_RegisterAbout_Edit_Template3_PhysBkg:SetText(loc.UI_BKG_BUTTON);
	TRP3_RegisterAbout_Edit_Template3_PhysBkg:SetScript("OnClick", function()
		local function OnBackgroundSelected(imageInfo)
			setTemplate3PhysBkg(imageInfo and imageInfo.id or nil);
		end

		TRP3_API.popup.ShowBackgroundBrowser(OnBackgroundSelected, draftData.T3.PH.BK);
	end);

	TRP3_RegisterAbout_Edit_Template3_PsyBkg:SetText(loc.UI_BKG_BUTTON);
	TRP3_RegisterAbout_Edit_Template3_PsyBkg:SetScript("OnClick", function()
		local function OnBackgroundSelected(imageInfo)
			setTemplate3PsyBkg(imageInfo and imageInfo.id or nil);
		end

		TRP3_API.popup.ShowBackgroundBrowser(OnBackgroundSelected, draftData.T3.PS.BK);
	end);

	TRP3_RegisterAbout_Edit_Template3_HistBkg:SetText(loc.UI_BKG_BUTTON);
	TRP3_RegisterAbout_Edit_Template3_HistBkg:SetScript("OnClick", function()
		local function OnBackgroundSelected(imageInfo)
			setTemplate3HistBkg(imageInfo and imageInfo.id or nil);
		end

		TRP3_API.popup.ShowBackgroundBrowser(OnBackgroundSelected, draftData.T3.HI.BK);
	end);

	setTooltipAll(TRP3_RegisterAbout_Edit_Template3_PsyIcon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	TRP3_RegisterAbout_Edit_Template3_PsyIcon:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			showIconBrowser(onPsychoIconSelected, draftData.T3.PS.IC);
		elseif button == "RightButton" then
			local icon = draftData.T3.PS.IC or TEMPLATE3_ICON_PSYCHO;
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
				description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
				description:CreateButton(loc.UI_ICON_PASTE, function() onPsychoIconSelected(TRP3_API.GetLastCopiedIcon()); end);
			end);
		end
	end);

	setTooltipAll(TRP3_RegisterAbout_Edit_Template3_HistIcon, "RIGHT", 0, 5, loc.UI_ICON_SELECT, TRP3_API.FormatShortcutWithInstruction("LCLICK", loc.UI_ICON_OPENBROWSER) .. "|n" .. TRP3_API.FormatShortcutWithInstruction("RCLICK", loc.UI_ICON_OPTIONS));
	TRP3_RegisterAbout_Edit_Template3_HistIcon:SetScript("OnClick", function(self, button)
		if button == "LeftButton" then
			showIconBrowser(onHistoIconSelected, draftData.T3.HI.IC);
		elseif button == "RightButton" then
			local icon = draftData.T3.HI.IC or TEMPLATE3_ICON_HISTORY;
			TRP3_MenuUtil.CreateContextMenu(self, function(_, description)
				description:CreateButton(loc.UI_ICON_COPY, TRP3_API.SetLastCopiedIcon, icon);
				description:CreateButton(loc.UI_ICON_COPYNAME, function() TRP3_API.popup.showCopyDropdownPopup({icon}); end);
				description:CreateButton(loc.UI_ICON_PASTE, function() onHistoIconSelected(TRP3_API.GetLastCopiedIcon()); end);
			end);
		end
	end);
	TRP3_RegisterAbout_Edit_Music_Action:SetScript("OnClick", onMusicEditClicked);
	TRP3_RegisterAbout_Edit_Template2_Add:SetScript("OnClick", template2AddFrame);
	TRP3_RegisterAbout_AboutPanel_EditButton:SetScript("OnClick", onEdit);
	TRP3_RegisterAbout_Edit_SaveButton:SetScript("OnClick", onSave);
	TRP3_RegisterAbout_Edit_CancelButton:SetScript("OnClick", showAboutTab);

	TRP3_RegisterAbout_AboutPanel_Empty:SetText(loc.REG_PLAYER_ABOUT_EMPTY);
	TRP3_API.ui.text.setupToolbar(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template1ScrollText);

	TRP3_RegisterAbout_Edit_Template3_PhysTitle:SetText(loc.REG_PLAYER_PHYSICAL);
	TRP3_RegisterAbout_Edit_Template3_PsyTitle:SetText(loc.REG_PLAYER_PSYCHO);
	TRP3_RegisterAbout_Edit_Template3_HistTitle:SetText(loc.REG_PLAYER_HISTORY);
	TRP3_RegisterAbout_Edit_Template2_Add:SetText(loc.REG_PLAYER_ABOUT_ADD_FRAME);
	TRP3_RegisterAbout_Edit_SaveButton:SetText(loc.CM_SAVE);
	TRP3_RegisterAbout_Edit_CancelButton:SetText(loc.CM_CANCEL);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetText(loc.CM_PLAY);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetText(loc.CM_STOP);
	TRP3_RegisterAbout_Edit_Music_Action:SetText(loc.TF_CHAR_THEME);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Title:SetText(loc.REG_PLAYER_ABOUT_MUSIC_THEME);

	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template1);

	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template3_1_Text);
	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template3_2_Text);
	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template3_3_Text);

	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template1ScrollText);
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText);
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText);
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_HistTextScrollText);

	registerConfigKey(CONFIG_REGISTER_ABOUT_P_SIZE, defaultFontParameters.p.size);
	registerConfigKey(CONFIG_REGISTER_ABOUT_H1_SIZE, defaultFontParameters.h1.size);
	registerConfigKey(CONFIG_REGISTER_ABOUT_H2_SIZE, defaultFontParameters.h2.size);
	registerConfigKey(CONFIG_REGISTER_ABOUT_H3_SIZE, defaultFontParameters.h3.size);

	updateAllAboutTemplateFonts();

	registerHandler(CONFIG_REGISTER_ABOUT_P_SIZE, updateAllAboutTemplateFonts);
	registerHandler(CONFIG_REGISTER_ABOUT_H1_SIZE, updateAllAboutTemplateFonts);
	registerHandler(CONFIG_REGISTER_ABOUT_H2_SIZE, updateAllAboutTemplateFonts);
	registerHandler(CONFIG_REGISTER_ABOUT_H3_SIZE, updateAllAboutTemplateFonts);

	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_REGISTER_ABOUT_SETTINGS,
	});
	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigSlider",
		title = loc.CO_REGISTER_ABOUT_P_SIZE,
		help = loc.CO_REGISTER_ABOUT_P_SIZE_TT:format(defaultFontParameters.p.size),
		configKey = CONFIG_REGISTER_ABOUT_P_SIZE,
		min = 8,
		max = 30,
		step = 1,
		integer = true,
	});
	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigSlider",
		title = loc.CO_REGISTER_ABOUT_H3_SIZE,
		help = loc.CO_REGISTER_ABOUT_H3_SIZE_TT:format(defaultFontParameters.h3.size),
		configKey = CONFIG_REGISTER_ABOUT_H3_SIZE,
		min = 8,
		max = 30,
		step = 1,
		integer = true,
	});
	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigSlider",
		title = loc.CO_REGISTER_ABOUT_H2_SIZE,
		help = loc.CO_REGISTER_ABOUT_H2_SIZE_TT:format(defaultFontParameters.h2.size),
		configKey = CONFIG_REGISTER_ABOUT_H2_SIZE,
		min = 8,
		max = 30,
		step = 1,
		integer = true,
	});
	tinsert(TRP3_API.register.CONFIG_STRUCTURE.elements, {
		inherit = "TRP3_ConfigSlider",
		title = loc.CO_REGISTER_ABOUT_H1_SIZE,
		help = loc.CO_REGISTER_ABOUT_H1_SIZE_TT:format(defaultFontParameters.h1.size),
		configKey = CONFIG_REGISTER_ABOUT_H1_SIZE,
		min = 8,
		max = 30,
		step = 1,
		integer = true,
	});

	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetScript("OnClick", function()
		Utils.music.playMusic(TRP3_RegisterAbout_AboutPanel.musicURL);
	end);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetScript("OnClick", function()
		Utils.music.stopMusic();
	end);

	TRP3_API.RegisterCallback(TRP3_Addon, Events.REGISTER_DATA_UPDATED, function(_, unitID, profileID, dataType)
		if dataType == "about" and unitID and unitID ~= Globals.player_id then
			onAboutReceived(profileID);
		end
	end);

	-- Resizing
	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.NAVIGATION_RESIZED, function()
		ResizeTemplateViews();
	end);

	TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.REGISTER_PROFILE_OPENED, function()
		TRP3_RegisterAbout_AboutPanel_Scroll.ScrollBar:ScrollToBegin();
		TRP3_RegisterAbout_Edit_Template2_Scroll.ScrollBar:ScrollToBegin();
	end);
end

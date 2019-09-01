----------------------------------------------------------------------------------
--- Total RP 3
--- Character page : About
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

-- imports
local Globals, Utils, Events = TRP3_API.globals, TRP3_API.utils, TRP3_API.events;
local stEtN = Utils.str.emptyToNil;
local get = TRP3_API.profile.getData;
local tcopy = Utils.table.copy;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local CreateFrame = CreateFrame;
local getTiledBackground = TRP3_API.ui.frame.getTiledBackground;
local getTiledBackgroundList = TRP3_API.ui.frame.getTiledBackgroundList;
local showIfMouseOver = TRP3_API.ui.frame.showIfMouseOverFrame;
local createRefreshOnFrame = TRP3_API.ui.frame.createRefreshOnFrame;
local TRP3_RegisterAbout_AboutPanel = TRP3_RegisterAbout_AboutPanel;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local setTooltipAll = TRP3_API.ui.tooltip.setTooltipAll;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local getUnitIDProfile = TRP3_API.register.getUnitIDProfile;
local hasProfile, getProfile = TRP3_API.register.hasProfile, TRP3_API.register.getProfile;

-- Total RP 3 imports
local loc = TRP3_API.loc;

local refreshTemplate2EditDisplay, saveInDraft, template2SaveToDraft; -- Function reference

local showIconBrowser = function(callback)
	TRP3_API.popup.showPopup(TRP3_API.popup.ICONS, nil, {callback});
end;

local function setupHTMLFonts(frame)
	frame:SetFontObject("p", GameFontNormal);
	frame:SetFontObject("h1", GameFontNormalHuge3);
	frame:SetFontObject("h2", GameFontNormalHuge);
	frame:SetFontObject("h3", GameFontNormalLarge);
	frame:SetTextColor("h1", 1, 1, 1);
	frame:SetTextColor("h2", 1, 1, 1);
	frame:SetTextColor("h3", 1, 1, 1);
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

local function setBkg(frame, bkg)
	local backdrop = frame:GetBackdrop();
	backdrop.bgFile = getTiledBackground(bkg or 1);
	frame:SetBackdrop(backdrop);
end

local function setConsultBkg(bkg)
	setBkg(TRP3_RegisterAbout, bkg);
end

local function setEditBkg(bkg)
	setBkg(TRP3_RegisterAbout, bkg);
end

local function selectMusic(music)
	if music then
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc.REG_PLAYER_ABOUT_MUSIC_THEME, Utils.music.getTitle(music)));
	else
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc.REG_PLAYER_ABOUT_MUSIC_THEME, loc.REG_PLAYER_ABOUT_NOMUSIC));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 1
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

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

local function shouldShowTemplate2(dataTab)
	local templateData = dataTab.T2 or {};
	local atLeastOneFrame = false;
	for _, frameTab in pairs(templateData) do
		if frameTab.TX and strtrim(frameTab.TX):len() > 0 then
			atLeastOneFrame = true;
		end
	end
	return atLeastOneFrame;
end

local function resizeTemplate2()
	for _, frame in pairs(template2Frames) do
		local text = _G[frame:GetName().."Text"];
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
		local text = _G[frame:GetName().."Text"];
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
		frame:SetPoint("RIGHT", 0, 0);

		local icon = _G[frame:GetName().."Icon"];
		local text = _G[frame:GetName().."Text"];
		local backdrop = frame:GetBackdrop();
		backdrop.bgFile = getTiledBackground(frameTab.BK or 1);
		frame:SetBackdrop(backdrop);
		setupIconButton(icon, frameTab.IC or Globals.icons.default);

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
			text:SetJustifyH("LEFT")
		else
			icon:SetPoint("RIGHT", -15, 0);
			text:SetPoint("RIGHT", icon, "LEFT", -10, 0);
			text:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -10)
			text:SetJustifyH("RIGHT")
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
	setBkg(frame, bkg);
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
	setupListBox(_G["TRP3_RegisterAbout_Template2_Edit"..frameIndex.."Bkg"], getTiledBackgroundList(), setTemplate2EditBkg, nil, 120, true);
	_G[frame:GetName().."Delete"]:SetScript("OnClick", template2DeleteFrame);
	_G[frame:GetName().."Delete"]:SetText(loc.CM_REMOVE);
	_G[frame:GetName().."Up"]:SetScript("OnClick", template2UpFrame);
	_G[frame:GetName().."Down"]:SetScript("OnClick", template2DownFrame);
	setTooltipAll(_G[frame:GetName().."Up"], "TOP", 0, 0, loc.CM_MOVE_UP);
	setTooltipAll(_G[frame:GetName().."Down"], "TOP", 0, 0, loc.CM_MOVE_DOWN);
	setTooltipAll(_G[frame:GetName().."Delete"], "TOP", 0, 5, loc.REG_PLAYER_ABOUT_REMOVE_FRAME);
	setTooltipAll(_G[frame:GetName().."Icon"], "TOP", 0, 5, loc.UI_ICON_SELECT);
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
	assert(type(templateData) == "table", "Error: Nil template3 data or not a table.");

	local previous;
	for frameIndex, frameData in pairs(templateData) do
		local frame = template2EditFrames[frameIndex];
		if frame == nil then
			frame = createTemplate2Frame(frameIndex);
		end
		-- Position
		frame:ClearAllPoints();
		frame:SetPoint("LEFT", 0, 0);
		frame:SetPoint("RIGHT", 0, 0);
		if previous == nil then
			frame:SetPoint("TOPLEFT", TRP3_RegisterAbout_Edit_Template2_Container, "TOPLEFT", -5, -5);
		else
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -5);
		end
		-- Values
		frame.index = frameIndex;
		frame.frameData = frameData;
		_G[frame:GetName().."Bkg"]:SetSelectedIndex(frameData.BK or 1);
		_G[frame:GetName().."TextScrollText"]:SetText(frameData.TX or "");
		setupIconButton(_G[frame:GetName().."Icon"], frameData.IC or Globals.icons.default);
		_G[frame:GetName().."Icon"]:SetScript("OnClick", function()
			showIconBrowser(function(icon)
				frame.frameData.IC = icon;
				setupIconButton(_G[frame:GetName().."Icon"], icon);
			end);
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
local TEMPLATE3_ICON_PHYSICAL = Globals.is_classic and "spell_holy_fistofjustice" or "Ability_Warrior_StrengthOfArms";
local TEMPLATE3_ICON_PSYCHO = Globals.is_classic and "spell_holy_mindvision" or "Spell_Arcane_MindMastery";
local TEMPLATE3_ICON_HISTORY = "INV_Misc_Book_12";

local function setTemplate3PhysBkg(bkg)
	setBkg(TRP3_RegisterAbout_Edit_Template3_Phys, bkg);
end

local function setTemplate3PsyBkg(bkg)
	setBkg(TRP3_RegisterAbout_Edit_Template3_Psy, bkg);
end

local function setTemplate3HistBkg(bkg)
	setBkg(TRP3_RegisterAbout_Edit_Template3_Hist, bkg);
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

local function shouldShowTemplate3(dataTab)
	local atLeastOneFrame = false;
	local templateData = dataTab.T3 or {};
	local datas = {templateData.PH, templateData.PS, templateData.HI};
	for i=1, 3 do
		local data = datas[i] or {};
		if data.TX and strtrim(data.TX):len() > 0 then
			atLeastOneFrame = true;
		end
	end
	return atLeastOneFrame;
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

			setBkg(frame, data.BK);
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

local function refreshConsultDisplay(context)
	local dataTab = context.profile.about or Globals.empty;
	local template = dataTab.TE or 1;
	TRP3_RegisterAbout_AboutPanel.isMine = context.isPlayer;

	TRP3_ProfileReportButton:Hide();
	if not context.isPlayer then
		if dataTab ~= Globals.empty then
			dataTab.read = true;
		end
		Events.fireEvent(Events.REGISTER_ABOUT_READ);
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
end

function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.BK = TRP3_RegisterAbout_Edit_BckField:GetSelectedValue();
	draftData.TE = TRP3_RegisterAbout_Edit_TemplateField:GetSelectedValue();
	-- Template 1
	draftData.T1.TX = TRP3_RegisterAbout_Edit_Template1ScrollText:GetText();
	-- Template 2
	template2SaveToDraft();
	-- Template 3
	draftData.T3.PH.BK = TRP3_RegisterAbout_Edit_Template3_PhysBkg:GetSelectedValue();
	draftData.T3.PS.BK = TRP3_RegisterAbout_Edit_Template3_PsyBkg:GetSelectedValue();
	draftData.T3.HI.BK = TRP3_RegisterAbout_Edit_Template3_HistBkg:GetSelectedValue();
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
	TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_TUTORIAL_REFRESH, "player_main");
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

	Events.fireEvent(Events.REGISTER_DATA_UPDATED, Globals.player_id, getCurrentContext().profileID, "about");
end

local function refreshEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/about");
		assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end

	TRP3_RegisterAbout_Edit_BckField:SetSelectedIndex(draftData.BK or 1);
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
	TRP3_RegisterAbout_Edit_Template3_PhysBkg:SetSelectedIndex(template3Data.PH.BK or 1);
	TRP3_RegisterAbout_Edit_Template3_PsyBkg:SetSelectedIndex(template3Data.PS.BK or 1);
	TRP3_RegisterAbout_Edit_Template3_HistBkg:SetSelectedIndex(template3Data.HI.BK or 1);
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
	local values = {};
	tinsert(values, {loc.REG_PLAYER_ABOUT_MUSIC_SELECT, 1});
	if draftData.MU then
		tinsert(values, {loc.REG_PLAYER_ABOUT_MUSIC_REMOVE, 2});
		tinsert(values, {loc.REG_PLAYER_ABOUT_MUSIC_LISTEN, 3});
		tinsert(values, {loc.REG_PLAYER_ABOUT_MUSIC_STOP, 4});
	end
	displayDropDown(button, values, onMusicEditSelected, 0, true);
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
	local aboutData = getProfile(profileID);
	-- Check that there is a description. If not => set read to true !
	local noDescr = (aboutData.TE == 1 and not shouldShowTemplate1(aboutData)) or (aboutData.TE == 2 and not shouldShowTemplate2(aboutData)) or (aboutData.TE == 3 and not shouldShowTemplate3(aboutData))
	if noDescr then
		aboutData.read = true;
		Events.fireEvent(Events.REGISTER_ABOUT_READ);
	end
	if aboutData.MU and type(aboutData) == "string" then
		aboutData.MU = Utils.music.convertPathToID(aboutData.MU);
	end
end

local function resetHTMLText(frame)
	frame:SetText(frame.html);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TUTORIAL
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TUTORIAL_EDIT_COMMON, TUTORIAL_EDIT_T1, TUTORIAL_EDIT_T2, TUTORIAL_EDIT_T3

local function createTutorialStructures()
	TUTORIAL_EDIT_COMMON = {
		box = {
			width = 510,
			height = 70,
			anchor = "TOP",
			x = 1,
			y = -40
		},
		button = {
			x = 125, y = 0, anchor = "CENTER",
			text = loc.REG_PLAYER_TUTO_ABOUT_COMMON,
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
				x = 0, y = 20, anchor = "BOTTOM",
				text = loc.REG_PLAYER_TUTO_ABOUT_T1,
				textWidth = 450,
				arrow = "UP"
			}
		},
		TUTORIAL_EDIT_COMMON
	}

	TUTORIAL_EDIT_T2 = {
		{
			box = {
				allPoints = TRP3_RegisterAbout_Edit_Template1
			},
			button = {
				x = 0, y = 20, anchor = "BOTTOM",
				text = loc.REG_PLAYER_TUTO_ABOUT_T2,
				textWidth = 450,
				arrow = "UP"
			}
		},
		TUTORIAL_EDIT_COMMON
	}

	TUTORIAL_EDIT_T3 = {
		{
			box = {
				allPoints = TRP3_RegisterAbout_Edit_Template3
			},
			button = {
				x = 0, y = 20, anchor = "BOTTOM",
				text = loc.REG_PLAYER_TUTO_ABOUT_T3,
				textWidth = 450,
				arrow = "UP"
			}
		},
		TUTORIAL_EDIT_COMMON
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if TRP3_API.target then
		TRP3_API.target.registerButton({
			id = "aa_player_b_music",
			onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
			configText = loc.TF_PLAY_THEME,
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
					buttonStructure.tooltipSub = loc.TF_PLAY_THEME_TT:format(Utils.music.getTitle(theme));
				end
			end,
			tooltip = loc.TF_PLAY_THEME,
			icon = Globals.is_classic and "INV_Misc_Drum_01" or "inv_misc_drum_06"
		});
	end
end);

function TRP3_API.register.inits.aboutInit()
	createTutorialStructures();

	-- UI
	createRefreshOnFrame(TRP3_RegisterAbout_AboutPanel, 0.2, onPlayerAboutRefresh);
	local bkgTab = getTiledBackgroundList();
	setupListBox(TRP3_RegisterAbout_Edit_BckField, bkgTab, setEditBkg, nil, 150, true);
	setupListBox(TRP3_RegisterAbout_Edit_TemplateField, {{"Template 1", 1}, {"Template 2", 2}, {"Template 3", 3}}, setEditTemplate, nil, 150, true);
	setupListBox(TRP3_RegisterAbout_Edit_Template3_PhysBkg, bkgTab, setTemplate3PhysBkg, nil, 150, true);
	setupListBox(TRP3_RegisterAbout_Edit_Template3_PsyBkg, bkgTab, setTemplate3PsyBkg, nil, 150, true);
	setupListBox(TRP3_RegisterAbout_Edit_Template3_HistBkg, bkgTab, setTemplate3HistBkg, nil, 150, true);
	TRP3_RegisterAbout_Edit_Template3_PhysIcon:SetScript("OnClick", function() showIconBrowser(onPhisIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_PsyIcon:SetScript("OnClick", function() showIconBrowser(onPsychoIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_HistIcon:SetScript("OnClick", function() showIconBrowser(onHistoIconSelected) end );
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
	TRP3_RegisterAbout_AboutPanel_EditButton:SetText(loc.CM_EDIT);
	TRP3_RegisterAbout_Edit_SaveButton:SetText(loc.CM_SAVE);
	TRP3_RegisterAbout_Edit_CancelButton:SetText(loc.CM_CANCEL);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetText(loc.CM_PLAY);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetText(loc.CM_STOP);
	TRP3_RegisterAbout_Edit_Music_Action:SetText(loc.REG_PLAYER_EDIT_MUSIC_THEME);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Title:SetText(loc.REG_PLAYER_ABOUT_MUSIC_THEME);

	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template1);

	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template3_1_Text);
	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template3_2_Text);
	setupHTMLFonts(TRP3_RegisterAbout_AboutPanel_Template3_3_Text);

	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template1ScrollText);
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText);
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText);
	setToolbarTextFrameScript(TRP3_RegisterAbout_Edit_Toolbar, TRP3_RegisterAbout_Edit_Template3_HistTextScrollText);

	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetScript("OnClick", function()
		Utils.music.playMusic(TRP3_RegisterAbout_AboutPanel.musicURL);
	end);
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetScript("OnClick", function()
		Utils.music.stopMusic();
	end);

	Events.listenToEvent(Events.REGISTER_DATA_UPDATED, function(unitID, profileID, dataType)
		if dataType == "about" and unitID and unitID ~= Globals.player_id then
			onAboutReceived(profileID);
		end
	end);

	-- Resizing
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_RESIZED, function(containerwidth, containerHeight)
		TRP3_RegisterAbout_AboutPanel_Container:SetSize(containerwidth - 40, 5);
		TRP3_RegisterAbout_AboutPanel_Template1:SetSize(containerwidth - 50, 5);
		TRP3_RegisterAbout_AboutPanel_Template3_1_Text:SetWidth(containerwidth - 70);
		resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template3_1_Text);
		TRP3_RegisterAbout_AboutPanel_Template3_2_Text:SetWidth(containerwidth - 70);
		resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template3_2_Text);
		TRP3_RegisterAbout_AboutPanel_Template3_3_Text:SetWidth(containerwidth - 70);
		resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template3_3_Text);
		TRP3_RegisterAbout_Edit_Template3_Phys:SetHeight((containerHeight - 165) * 0.33);
		TRP3_RegisterAbout_Edit_Template3_Psy:SetHeight((containerHeight - 165) * 0.33);
		TRP3_RegisterAbout_Edit_Template1ScrollText:SetSize(containerwidth - 75, 5);
		TRP3_RegisterAbout_Edit_Template2_Container:SetSize(containerwidth - 70, 5);
		resizeTemplate3();
		resetHTMLText(TRP3_RegisterAbout_AboutPanel_Template1);
		for _, frame in pairs(template2Frames) do
			_G[frame:GetName().."Text"]:SetWidth(containerwidth - 150);
			resetHTMLText(_G[frame:GetName().."Text"]);
		end
		for _, frame in pairs(template2EditFrames) do
			frame:SetHeight(containerHeight * 0.26);
			_G[frame:GetName().."TextScrollText"]:SetWidth(containerwidth - 150);
		end
		resizeTemplate2();

		TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:SetWidth(containerwidth - 290);
		TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:SetWidth(containerwidth - 290);
		TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:SetWidth(containerwidth - 290);
	end);
end

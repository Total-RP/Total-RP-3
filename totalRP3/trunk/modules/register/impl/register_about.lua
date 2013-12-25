--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : About section
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- functions
local stEtN = TRP3_StringEmptyToNil;
local log = TRP3_Log;
local color = TRP3_Color;
local get = TRP3_Profile_DataGetter;
local safeGet = TRP3_Profile_NilSafeDataAccess;
local loc = TRP3_L;
local stNtE = TRP3_StringNilToEmpty;
local tcopy = TRP3_DupplicateTab;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- SCHEMA
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--TRP3_GetDefaultProfile().player.about = {
--	version = 1,
--	currentTemplate = 1,
--  backgroundId = 1,
--	template1 = {
--	
--	},
--	template2 = {
--	
--	},
--	template3 = {
--		ph = {}, ps = {}, hi = {}
--	},
--}

-- Mock
TRP3_GetDefaultProfile().player.about = {
	version = 1,
	currentTemplate = 1,
	bkg = 1,
	music = "ZoneMusic\\GrizzlyHills\\GH_Intro1Uni01",
	template1 = {
		text = [[{h1}A big left title{/h1}
{h1:c}A big centered title{/h1}
{h1:r}A big right title{/h1}
{h3}A left title{/h3}
{h3:c}A centered title{/h3}
{h3:r}A right title{/h3}
{img:Interface\Challenges\challenges-bronze:128:128}
{p}{col:r}This is my description as a {col:ff00ff}dragon !{/col}

Le poème en prose a pour origine la prose poétique. Toutefois,{fake_balise} la prose poétique restait de la prose, un moyen supplémentaire pour le romancier, une marque de son style, sans constituer une véritable forme de poème. Autour de 1800, pendant que se constitue le romantisme, les aspirations des écrivains tendent de plus en plus vers l'absolu. La poésie suscite à nouveau de l'intérêt (contrairement au siècle des Lumières où elle était considérée comme un ornement) et la versification sera assouplie. Cependant, cela ne suffit pas pour certains tempéraments, qui se soumettent plus difficilement à la tyrannie de la rime et du mètre. François-René de Chateaubriand, très porté vers le lyrisme, mais peu vers le vers, écrit une épopée en prose, Les Martyrs (1809).{/p}
{p:r}{icon:Ability_Rogue_CheatDeath:50}{/p}]],
	},
	template2 = {
		{
			text = "Mon beau texte",
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_LADYLUCK",
			text = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
			bkg = 2,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 3,
		},
	},
	template3 = {
		ph = {
			text = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
		},
		ps = {
			text = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
		},
		hi = {
			text = [[This Widget API reference and the term Widget refer to the UIObject Lua API and the specific APIs of those Lua UIObjects found in WoW. This is a list of all of the Widget API UIObject specific functions found by scanning the in-game environment. You may also be interested in the various Widget handlers and XML UI.]],
		},
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ABOUT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local draftData = nil;

local function setBkg(frame, bkg)
	local backdrop = frame:GetBackdrop();
	backdrop.bgFile = TRP3_getTiledBackground(bkg or 1);
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
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc("REG_PLAYER_ABOUT_MUSIC"), TRP3_GetMusicTitle(music)));
	else
		TRP3_RegisterAbout_Edit_Music_Text:SetText(("%s: |cff00ff00%s"):format(loc("REG_PLAYER_ABOUT_MUSIC"), loc("REG_PLAYER_ABOUT_NOMUSIC")));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 1
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TAGS_INFO = {
	{
		openTags = {"{h1}", "{h1:c}", "{h1:r}"},
		closeTag = "{/h1}",
	},
	{
		openTags = {"{h2}", "{h2:c}", "{h2:r}"},
		closeTag = "{/h2}",
	},
	{
		openTags = {"{h3}", "{h3:c}", "{h3:r}"},
		closeTag = "{/h3}",
	},
	{
		openTags = {"{p:c}", "{p:r}"},
		closeTag = "{/p}",
	}
}

local function showTemplate1()
	local dataTab = get("player/about/template1");
	assert(type(dataTab) == "table", "Error: Nil template1 data or not a table.");
	
	local text = TRP2_toHTML(dataTab.text or "");
	TRP3_RegisterAbout_AboutPanel_Template1:Show();
	TRP3_RegisterAbout_AboutPanel_Template1:SetText(text);
end

local function insertTag(tag, index)
	local text = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetText();
	local pre = text:sub(1, index);
	local post = text:sub(index + 1);
	text = strconcat(pre, tag, post);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetText(text);
end

local function postInsertHighlight(index, tagSize, textSize)
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(index + tagSize + textSize);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:HighlightText(index + tagSize, index + tagSize + textSize);
end

local function insertContainerTag(alignIndex, button)
	assert(button.tagIndex and TAGS_INFO[button.tagIndex], "Button is not properly init with a tag index");
	local tagInfo = TAGS_INFO[button.tagIndex];
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	insertTag(strconcat(tagInfo.openTags[alignIndex], loc("REG_PLAYER_ABOUT_T1_YOURTEXT"), tagInfo.closeTag), cursorIndex);
	postInsertHighlight(cursorIndex, tagInfo.openTags[alignIndex]:len(), loc("REG_PLAYER_ABOUT_T1_YOURTEXT"):len());
end

local function onColorTagSelected(red, green, blue)
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{col:%s}"):format(strconcat(TRP3_NumberToHexa(red), TRP3_NumberToHexa(green), TRP3_NumberToHexa(blue)));
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + tag:len());
end

local function onIconTagSelected(icon)
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{icon:%s:25}"):format(icon);
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + tag:len());
end

local function onImageTagSelected(image)
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{img:%s:%s:%s}"):format(image.url, math.min(image.width, 512), math.min(image.height, 512));
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + tag:len());
end

local function onLinkTagClicked()
	local cursorIndex = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetCursorPosition();
	local tag = ("{link||%s||%s}"):format(loc("UI_LINK_URL"), loc("UI_LINK_TEXT"));
	insertTag(tag, cursorIndex);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetCursorPosition(cursorIndex + 6);
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:HighlightText(cursorIndex + 6, cursorIndex + 6 + loc("UI_LINK_URL"):len());
end

-- Drop down
local function onContainerTagClicked(button)
	local values = {};
	tinsert(values, {loc("REG_PLAYER_ABOUT_HEADER")});
	tinsert(values, {loc("CM_LEFT"), 1});
	tinsert(values, {loc("CM_CENTER"), 2});
	tinsert(values, {loc("CM_RIGHT"), 3});
	TRP3_DisplayDropDown(button, values, insertContainerTag, 0, true);
end

local function onContainerPTagClicked(button)
	local values = {};
	tinsert(values, {loc("REG_PLAYER_ABOUT_P")});
	tinsert(values, {loc("CM_CENTER"), 1});
	tinsert(values, {loc("CM_RIGHT"), 2});
	TRP3_DisplayDropDown(button, values, insertContainerTag, 0, true);
end

local function onLinkClicked(self, url)
	TRP3_ShowTextInputPopup(loc("UI_LINK_WARNING"), nil, nil, url);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 2
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local template2Frames = {};
local TEMPLATE2_PADDING = 30;

local function showTemplate2()
	local dataTab = get("player/about/template2");
	assert(type(dataTab) == "table", "Error: Nil template2 data or not a table.");
	
	-- Hide all
	for _, frame in pairs(template2Frames) do
		frame:Hide();
	end
	
	local frameIndex = 1;
	local previous = TRP3_RegisterAbout_AboutPanel_Template2Title;
	local bool = true;
	for _, frameTab in pairs(dataTab) do
		local frame = template2Frames[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Frame"..frameIndex, TRP3_RegisterAbout_AboutPanel_Template2, "TRP3_RegisterAbout_Template2_Frame");
			tinsert(template2Frames, frame);
		end
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
		
		local icon = _G[frame:GetName().."Icon"];
		local text = _G[frame:GetName().."Text"];
		local backdrop = frame:GetBackdrop();
		backdrop.bgFile = TRP3_getTiledBackground(frameTab.bkg or 1);
		frame:SetBackdrop(backdrop);
		TRP3_InitIconButton(icon, frameTab.icon or TRP3_ICON_DEFAULT);
		text:SetText(frameTab.text);
		icon:ClearAllPoints();
		text:ClearAllPoints();
		if bool then
			icon:SetPoint("LEFT", 15, 0);
			text:SetPoint("LEFT", icon, "RIGHT", 10, 0);
			text:SetJustifyH("LEFT")
		else
			icon:SetPoint("RIGHT", -15, 0);
			text:SetPoint("RIGHT", icon, "LEFT", -10, 0);
			text:SetJustifyH("RIGHT")
		end
		
		local height = math.max(text:GetHeight(), icon:GetHeight()) + TEMPLATE2_PADDING;
		frame:SetHeight(height);
		
		frame:Show();
		previous = frame;
		frameIndex = frameIndex + 1;
		bool = not bool;
	end
	
	TRP3_RegisterAbout_AboutPanel_Template2:Show();
	TRP3_RegisterAbout_AboutPanel_Template2Title:SetText(safeGet("player/characteristics/firstName", TRP3_PLAYER));
end

local template2EditFrames = {};
local refreshTemplate2EditDisplay; -- Function reference

local function setTemplate2EditBkg(bkg, frame)
	frame = frame:GetParent();
	assert(frame.frameData, "No frameData in the frame ...");
	setBkg(frame, bkg);
	frame.frameData.bkg = bkg;
end

local function template2DeleteFrame(button)
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.template2;
	tremove(templateData, frame.index);
	refreshTemplate2EditDisplay();
end

local function template2UpFrame(button)
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.template2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index - 1, frameData);
	refreshTemplate2EditDisplay();
end

local function template2DownFrame(button)
	local frame = button:GetParent();
	assert(frame.index, "No index in the frame ...");
	local templateData = draftData.template2;
	local frameData = templateData[frame.index];
	tremove(templateData, frame.index);
	tinsert(templateData, frame.index + 1, frameData);
	refreshTemplate2EditDisplay();
end

refreshTemplate2EditDisplay = function()
	-- Hide all
	for _, frame in pairs(template2EditFrames) do
		frame:Hide();
		frame.frameData = nil; -- Helps garbage collection
	end
	
	local templateData = draftData.template2;
	assert(type(templateData) == "table", "Error: Nil template3 data or not a table.");
	
	local previous = nil;
	for frameIndex, frameData in pairs(templateData) do
		local frame = template2EditFrames[frameIndex];
		if frame == nil then
			frame = CreateFrame("Frame", "TRP3_RegisterAbout_Template2_Edit"..frameIndex, TRP3_RegisterAbout_Edit_Template2_Container, "TRP3_RegisterAbout_Template2_Edit");
			TRP3_ListBox_Setup(_G["TRP3_RegisterAbout_Template2_Edit"..frameIndex.."Bkg"], TRP3_getTiledBkgListForListbox(), setTemplate2EditBkg, nil, 120, true);
			_G[frame:GetName().."Delete"]:SetScript("OnClick", template2DeleteFrame);
			_G[frame:GetName().."Delete"]:SetText(loc("CM_REMOVE"));
			_G[frame:GetName().."Up"]:SetScript("OnClick", template2UpFrame);
			_G[frame:GetName().."Down"]:SetScript("OnClick", template2DownFrame);
			TRP3_SetTooltipAll(_G[frame:GetName().."Up"], "TOP", 0, 0, loc("CM_MOVE_UP"));
			TRP3_SetTooltipAll(_G[frame:GetName().."Down"], "TOP", 0, 0, loc("CM_MOVE_DOWN"));
			tinsert(template2EditFrames, frame);
		end
		-- Position
		frame:ClearAllPoints();
		if previous == nil then
			frame:SetPoint("TOPLEFT", TRP3_RegisterAbout_Edit_Template2_Container, "TOPLEFT", -5, -5);
		else
			frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -5);
		end
		-- Values
		frame.index = frameIndex;
		frame.frameData = frameData;
		_G[frame:GetName().."Bkg"]:SetSelectedIndex(frameData.bkg or 1);
		_G[frame:GetName().."TextScrollBox"]:SetText(frameData.text or "");
		TRP3_InitIconButton(_G[frame:GetName().."Icon"], frameData.icon or TRP3_ICON_DEFAULT);
		_G[frame:GetName().."Icon"]:SetScript("OnClick", function()
			TRP3_OpenIconBrowser(function(icon)
				frame.frameData.icon = icon;
				TRP3_InitIconButton(_G[frame:GetName().."Icon"], icon);
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
	local templateData = draftData.template2;
	tinsert(templateData, {text = loc("REG_PLAYER_ABOUT_SOME")});
	refreshTemplate2EditDisplay();
end

--- Save to draft all the frames texts
local function template2SaveToDraft()
	for _, frame in pairs(template2EditFrames) do
		if frame:IsVisible() then
			assert(frame.frameData, "Frame has no frameData !");
			frame.frameData.text = stEtN(_G[frame:GetName().."TextScrollBox"]:GetText());
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 3
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TEMPLATE3_MINIMAL_HEIGHT = 100;
local TEMPLATE3_MARGIN = 30;

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
	draftData.template3.ph.icon = icon;
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, icon or TRP3_ICON_DEFAULT);
end

local function onPsychoIconSelected(icon)
	draftData.template3.ps.icon = icon;
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, icon or TRP3_ICON_DEFAULT);
end

local function onHistoIconSelected(icon)
	draftData.template3.hi.icon = icon;
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, icon or TRP3_ICON_DEFAULT);
end

local function showTemplate3()
	local datas = {get("player/about/template3/ph"), get("player/about/template3/ps"), get("player/about/template3/hi")};
	local titles = {loc("REG_PLAYER_PHYSICAL"), loc("REG_PLAYER_PSYCHO"), loc("REG_PLAYER_HISTORY")};
	for i=1, 3 do
		local data = datas[i];
		assert(type(data) == "table", "Error: Nil template3 data or not a table.");
		local icon = TRP3_Icon(data.icon or TRP3_ICON_DEFAULT, 25);
		local title = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Title"):format(i)];
		local frame = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s"):format(i)];
		local text = _G[("TRP3_RegisterAbout_AboutPanel_Template3_%s_Text"):format(i)];
		title:SetText(icon.."    "..titles[i].."    "..icon);
		text:SetText(TRP3_ConvertTextTags(data.text));
		setBkg(frame, data.bkg or 1);
		frame:SetHeight(title:GetHeight() + text:GetHeight() + TEMPLATE3_MARGIN);
	end

	TRP3_RegisterAbout_AboutPanel_Template3:Show();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LOGIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local isEditMode;
local templatesFunction = {
	showTemplate1,
	showTemplate2,
	showTemplate3
}

local function refreshConsultDisplay()
	local dataTab = get("player/about");
	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	assert(dataTab.currentTemplate, "Error: no player.about.currentTemplate detected");
	assert(type(templatesFunction[dataTab.currentTemplate]) == "function", "Error: no function for about template: " .. tostring(dataTab.currentTemplate));
	
	TRP3_RegisterAbout_AboutPanel.musicURL = dataTab.music;
	if dataTab.music then
		TRP3_RegisterAbout_AboutPanel_MusicPlayer_URL:SetText(TRP3_GetMusicTitle(dataTab.music));
	end
	
	TRP3_RegisterAbout_AboutPanel:Show();
	-- Putting the right templates
	templatesFunction[dataTab.currentTemplate]();
	-- Putting the righ background
	setConsultBkg(dataTab.bkg);
end

local function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.bkg = TRP3_RegisterAbout_Edit_BckField:GetSelectedValue();
	draftData.currentTemplate = TRP3_RegisterAbout_Edit_TemplateField:GetSelectedValue();
	-- Template 1
	draftData.template1.text = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetText();
	-- Template 2
	template2SaveToDraft();
	-- Template 3
	draftData.template3.ph.bkg = TRP3_RegisterAbout_Edit_Template3_PhysBkg:GetSelectedValue();
	draftData.template3.ps.bkg = TRP3_RegisterAbout_Edit_Template3_PsyBkg:GetSelectedValue();
	draftData.template3.hi.bkg = TRP3_RegisterAbout_Edit_Template3_HistBkg:GetSelectedValue();
	draftData.template3.ph.text = stEtN(TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:GetText());
	draftData.template3.ps.text = stEtN(TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:GetText());
	draftData.template3.hi.text = stEtN(TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:GetText());
end

local function setEditTemplate(value)
	TRP3_RegisterAbout_Edit_Template1:Hide();
	TRP3_RegisterAbout_Edit_Template2:Hide();
	TRP3_RegisterAbout_Edit_Template3:Hide();
	_G["TRP3_RegisterAbout_Edit_Template"..value]:Show();
end

local function save()
	saveInDraft();
	
	--TODO: check size and warn if too long
	local aboutSize = TRP3_EstimateStructureLoad(draftData);
	
	local dataTab = get("player/about");
	assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
	wipe(dataTab);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab, draftData);
	-- version increment
	assert(type(dataTab.version) == "number", "Error: No version in draftData or not a number.");
	dataTab.version = TRP3_IncrementVersion(dataTab.version, 2);
end

local function refreshEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/about");
		assert(type(dataTab) == "table", "Error: Nil about data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end
	
	TRP3_RegisterAbout_Edit_BckField:SetSelectedIndex(draftData.bkg or 1);
	TRP3_RegisterAbout_Edit_TemplateField:SetSelectedIndex(draftData.currentTemplate or 1);
	selectMusic(draftData.music);
	-- Template 1
	local template1Data = draftData.template1;
	assert(type(template1Data) == "table", "Error: Nil template1 data or not a table.");
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetText(template1Data.text or "");
	-- Template 2
	refreshTemplate2EditDisplay();
	-- Template 3
	local template3Data = draftData.template3;
	assert(type(template3Data) == "table", "Error: Nil template3 data or not a table.");
	setTemplate3PhysBkg(template3Data.ph.bkg or 1);
	setTemplate3PsyBkg(template3Data.ps.bkg or 1);
	setTemplate3HistBkg(template3Data.hi.bkg or 1);
	TRP3_RegisterAbout_Edit_Template3_PhysBkg:SetSelectedIndex(template3Data.ph.bkg or 1);
	TRP3_RegisterAbout_Edit_Template3_PsyBkg:SetSelectedIndex(template3Data.ps.bkg or 1);
	TRP3_RegisterAbout_Edit_Template3_HistBkg:SetSelectedIndex(template3Data.hi.bkg or 1);
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PhysIcon, template3Data.ph.icon or TRP3_ICON_DEFAULT);
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_PsyIcon, template3Data.ps.icon or TRP3_ICON_DEFAULT);
	TRP3_InitIconButton(TRP3_RegisterAbout_Edit_Template3_HistIcon, template3Data.hi.icon or TRP3_ICON_DEFAULT);
	TRP3_RegisterAbout_Edit_Template3_PhysTextScrollText:SetText(template3Data.ph.text or "");
	TRP3_RegisterAbout_Edit_Template3_PsyTextScrollText:SetText(template3Data.ps.text or "");
	TRP3_RegisterAbout_Edit_Template3_HistTextScrollText:SetText(template3Data.hi.text or "");
	
	TRP3_RegisterAbout_AboutPanel_Edit:Show();
	setEditTemplate(draftData.currentTemplate or 1);
end

local function refreshDisplay()
	--Hide all templates
	TRP3_RegisterAbout_AboutPanel_Template1:Hide();
	TRP3_RegisterAbout_AboutPanel_Template2:Hide();
	TRP3_RegisterAbout_AboutPanel_Template3:Hide();
	TRP3_RegisterAbout_AboutPanel:Hide();
	TRP3_RegisterAbout_AboutPanel_Edit:Hide();
	
	if isEditMode then
		refreshEditDisplay()
	else
		refreshConsultDisplay()
	end
end

function TRP3_onPlayerAboutShow()
	TRP3_RegisterAbout_AboutPanel_MusicPlayer:Hide();
	TRP3_RegisterAbout:Show();
	isEditMode = false;
	refreshDisplay();
end

function TRP3_UI_AboutEditButton()
	if draftData then
		wipe(draftData);
		draftData = nil;
	end
	isEditMode = true;
	refreshDisplay();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- MUSIC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onMusicSelected(music)
	draftData.music = music;
	selectMusic(draftData.music);
end

local function onMusicEditSelected(value, button)
	if value == 1 then
		TRP3_OpenMusicBrowser(onMusicSelected);
	elseif value == 2 and draftData.music then
		draftData.music = nil;
		selectMusic(draftData.music);
	elseif value == 3 and draftData.music then
		TRP3_PlayMusic(draftData.music);
	elseif value == 4 and draftData.music then
		TRP3_StopMusic();
	end
end

local function onMusicEditClicked(button)
	local profileID = button:GetParent().profileID;
	local values = {};
	tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_SELECT"), 1});
	if draftData.music then
		tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_REMOVE"), 2});
		tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_LISTEN"), 3});
		tinsert(values, {loc("REG_PLAYER_ABOUT_MUSIC_STOP"), 4});
	end
	TRP3_DisplayDropDown(button, values, onMusicEditSelected, 0, true);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI MISC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPlayerAboutRefresh()
	TRP3_ShowIfMouseOver(TRP3_RegisterAbout_AboutPanel_EditButton, TRP3_RegisterAbout_AboutPanel);
	if TRP3_RegisterAbout_AboutPanel.musicURL then
		TRP3_ShowIfMouseOver(TRP3_RegisterAbout_AboutPanel_MusicPlayer, TRP3_RegisterAbout_AboutPanel);
	end
end

function TRP3_UI_AboutSaveButton()
	save();
	TRP3_onPlayerAboutShow();
end

function TRP3_UI_AboutCancelButton()
	TRP3_onPlayerAboutShow();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_AboutInit()
	
	-- UI
	TRP3_CreateRefreshOnFrame(TRP3_RegisterAbout_AboutPanel, 0.2, onPlayerAboutRefresh);
	local bkgTab = TRP3_getTiledBkgListForListbox();
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_BckField, bkgTab, setEditBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_TemplateField, {{"Template 1", 1}, {"Template 2", 2}, {"Template 3", 3}}, setEditTemplate, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_PhysBkg, bkgTab, setTemplate3PhysBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_PsyBkg, bkgTab, setTemplate3PsyBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_HistBkg, bkgTab, setTemplate3HistBkg, nil, 120, true);
	TRP3_RegisterAbout_Edit_Template3_PhysIcon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onPhisIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_PsyIcon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onPsychoIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_HistIcon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onHistoIconSelected) end );
	TRP3_RegisterAbout_Edit_Music_Action:SetScript("OnClick", onMusicEditClicked);
	TRP3_RegisterAbout_Edit_Template2_Add:SetScript("OnClick", template2AddFrame);
	
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Title:SetText(loc("REG_PLAYER_ABOUT_TAGS"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Image:SetText(loc("CM_IMAGE"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Icon:SetText(loc("CM_ICON"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Color:SetText(loc("CM_COLOR"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Link:SetText(loc("CM_LINK"));
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H1.tagIndex = 1;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H2.tagIndex = 2;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H3.tagIndex = 3;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_P.tagIndex = 4;
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H1:SetScript("OnClick", onContainerTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H2:SetScript("OnClick", onContainerTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_H3:SetScript("OnClick", onContainerTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_P:SetScript("OnClick", onContainerPTagClicked);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Icon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onIconTagSelected) end);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Color:SetScript("OnClick", function() TRP3_OpenColorBrowser(onColorTagSelected) end);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Image:SetScript("OnClick", function() TRP3_OpenImageBrowser(onImageTagSelected) end);
	TRP3_RegisterAbout_Edit_Template1_Toolbar_Link:SetScript("OnClick", onLinkTagClicked);
	TRP3_RegisterAbout_AboutPanel_Template1:SetScript("OnHyperlinkClick", onLinkClicked);
	
	TRP3_RegisterAbout_AboutPanel_Template1:SetScript("OnHyperlinkEnter", function(self, link, text)
		TRP3_MainTooltip:Hide();
		TRP3_MainTooltip:SetOwner(TRP3_RegisterAbout_AboutPanel, "ANCHOR_CURSOR");
		TRP3_MainTooltip:AddLine(text, 1, 1, 1, true);
		TRP3_MainTooltip:AddLine(link, 1, 1, 1, true);
		TRP3_MainTooltip:Show();
	end);
	TRP3_RegisterAbout_AboutPanel_Template1:SetScript("OnHyperlinkLeave", function() TRP3_MainTooltip:Hide(); end);

	TRP3_RegisterAbout_AboutPanel_Template3_1_Text:SetWidth(450);
	TRP3_RegisterAbout_AboutPanel_Template3_2_Text:SetWidth(450);
	TRP3_RegisterAbout_AboutPanel_Template3_3_Text:SetWidth(450);
	TRP3_RegisterAbout_Edit_Template3_PhysTitle:SetText(loc("REG_PLAYER_PHYSICAL"));
	TRP3_RegisterAbout_Edit_Template3_PsyTitle:SetText(loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterAbout_Edit_Template3_HistTitle:SetText(loc("REG_PLAYER_HISTORY"));
	TRP3_RegisterAbout_AboutPanel_EditButton:SetText(loc("CM_EDIT"));
	TRP3_RegisterAbout_Edit_SaveButton:SetText(loc("CM_SAVE"));
	TRP3_RegisterAbout_Edit_CancelButton:SetText(loc("CM_CANCEL"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Play:SetText(loc("CM_PLAY"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Stop:SetText(loc("CM_STOP"));
	TRP3_RegisterAbout_AboutPanel_MusicPlayer_Title:SetText(loc("REG_PLAYER_ABOUT_MUSIC"));
	
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("p",GameFontNormal);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h1",GameFontNormalHuge3);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h2",GameFontNormalHuge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h3",GameFontNormalLarge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h1",1,1,1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h2",1,1,1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h3",1,1,1);
end
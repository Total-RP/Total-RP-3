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
			size = 150,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 3,
			size = 180,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 4,
			size = 100,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 5,
			size = 90,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 6,
			size = 250,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 7,
		},
		{
			icon = "ACHIEVEMENT_GUILDPERK_CASHFLOW_RANK2",
			text = "Mon beau texte 3",
			bkg = 8,
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

local backgrounds = {
	"Interface\\SPELLBOOK\\Spellbook-Page-1",
	"Interface\\AchievementFrame\\UI-Achievement-StatsBackground",
	"Interface\\ARCHEOLOGY\\Arch-BookCompletedLeft",
	"Interface\\ARCHEOLOGY\\Arch-BookItemLeft",
};

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
	setBkg(TRP3_RegisterAbout_AboutPanel, bkg);
end

local function setEditBkg(bkg)
	setBkg(TRP3_RegisterAbout_AboutPanel_Edit, bkg);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 1
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function showTemplate1()
	local dataTab = get("player/about/template1");
	assert(type(dataTab) == "table", "Error: Nil template1 data or not a table.");
	
	local text = TRP2_toHTML(dataTab.text or "");
--	log(text);
	TRP3_RegisterAbout_AboutPanel_Template1:Show();
	TRP3_RegisterAbout_AboutPanel_Template1:SetText(text);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 2
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local template2Frames = {};

local function showTemplate2()
	local dataTab = get("player/about/template2");
	assert(type(dataTab) == "table", "Error: Nil template2 data or not a table.");
	
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
		frame:SetHeight(frameTab.size or 75);
		frame:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -10);
		frame:SetPoint("RIGHT", 0, 0);
		
		local icon = _G[frame:GetName().."Icon"];
		local text = _G[frame:GetName().."Text"];
		local backdrop = frame:GetBackdrop();
		backdrop.bgFile = TRP3_getTiledBackground(frameTab.bkg or 1);
		frame:SetBackdrop(backdrop);
		TRP3_InitIconButton(icon, frameTab.icon or TRP3_ICON_DEFAULT);
		text:SetText(frameTab.text);
		icon:ClearAllPoints();
		text:ClearAllPoints();
		text:SetPoint("TOP", 0, -10);
		text:SetPoint("BOTTOM", 0, 10);
		if bool then
			icon:SetPoint("LEFT", 10, 0);
			text:SetPoint("LEFT", icon, "RIGHT", 10, -2);
			text:SetPoint("RIGHT", -10, 0);
			text:SetJustifyH("LEFT")
		else
			icon:SetPoint("RIGHT", -10, 0);
			text:SetPoint("RIGHT", icon, "LEFT", -10, -2);
			text:SetPoint("LEFT", 10, 0);
			text:SetJustifyH("RIGHT")
		end
		
		frame:Show();
		previous = frame;
		frameIndex = frameIndex + 1;
		bool = not bool;
	end
	
	TRP3_RegisterAbout_AboutPanel_Template2:Show();
	TRP3_RegisterAbout_AboutPanel_Template2Title:SetText(safeGet("player/characteristics/firstName", TRP3_PLAYER));
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- TEMPLATE 3
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TEMPLATE3_MINIMAL_HEIGHT = 100;

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

	--TODO: factorise moi ca + optional pour tous
	-- Physical
	local physical = get("player/about/template3/ph");
	assert(type(physical) == "table", "Error: Nil template3 physical data or not a table.");
	local icon = TRP3_Icon(physical.icon or TRP3_ICON_DEFAULT, 25);
	TRP3_RegisterAbout_AboutPanel_Template3_1_Title:SetText(icon.."    "..loc("REG_PLAYER_PHYSICAL").."    "..icon);
	TRP3_RegisterAbout_AboutPanel_Template3_1_Text:SetText(physical.text);
	setBkg(TRP3_RegisterAbout_AboutPanel_Template3_1, physical.bkg or 1);
	TRP3_RegisterAbout_AboutPanel_Template3_1:SetHeight(physical.size or TEMPLATE3_MINIMAL_HEIGHT);
	
	local psycho = get("player/about/template3/ps");
	assert(type(psycho) == "table", "Error: Nil template3 psycho data or not a table.");
	icon = TRP3_Icon(psycho.icon or TRP3_ICON_DEFAULT, 25);
	TRP3_RegisterAbout_AboutPanel_Template3_2_Title:SetText(icon.."    "..loc("REG_PLAYER_PSYCHO").."    "..icon);
	TRP3_RegisterAbout_AboutPanel_Template3_2_Text:SetText(psycho.text);
	setBkg(TRP3_RegisterAbout_AboutPanel_Template3_2, psycho.bkg or 1);
	TRP3_RegisterAbout_AboutPanel_Template3_2:SetHeight(psycho.size or TEMPLATE3_MINIMAL_HEIGHT);
	
	local history = get("player/about/template3/hi");
	assert(type(history) == "table", "Error: Nil template3 history data or not a table.");
	icon = TRP3_Icon(history.icon or TRP3_ICON_DEFAULT, 25);
	TRP3_RegisterAbout_AboutPanel_Template3_3_Title:SetText(icon.."    "..loc("REG_PLAYER_HISTORY").."    "..icon);
	TRP3_RegisterAbout_AboutPanel_Template3_3_Text:SetText(history.text);
	setBkg(TRP3_RegisterAbout_AboutPanel_Template3_3, history.bkg or 1);
	TRP3_RegisterAbout_AboutPanel_Template3_3:SetHeight(history.size or TEMPLATE3_MINIMAL_HEIGHT);
	
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
	
	TRP3_RegisterAbout_AboutPanel:Show();
	-- Putting the right templates
	templatesFunction[dataTab.currentTemplate]();
	-- Putting the righ background
	setConsultBkg(dataTab.bkg);
end

local function saveInDraft()
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.bkg = TRP3_RegisterAbout_Edit_BckFieldDD:GetSelectedValue();
	draftData.currentTemplate = TRP3_RegisterAbout_Edit_TemplateFieldDD:GetSelectedValue();
	-- Template 1
	draftData.template1.text = TRP3_RegisterAbout_Edit_Template1_Scroll_Text:GetText();
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
	dataTab.version = dataTab.version + 1;
end

local function refreshEditDisplay()
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = get("player/about");
		assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end
	
	TRP3_RegisterAbout_Edit_BckFieldDD:SetSelectedIndex(draftData.bkg or 1);
	TRP3_RegisterAbout_Edit_TemplateFieldDD:SetSelectedIndex(draftData.currentTemplate or 1);
	-- Template 1
	local template1Data = get("player/about/template1");
	assert(type(template1Data) == "table", "Error: Nil template1 data or not a table.");
	TRP3_RegisterAbout_Edit_Template1_Scroll_Text:SetText(template1Data.text or "");
	-- Template 3
	local template3Data = get("player/about/template3");
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
	
	TRP3_FieldSet_SetCaption(TRP3_RegisterAbout_AboutPanel, TRP3_L("REG_PLAYER_ABOUTS"):format(safeGet("player/characteristics/firstName", TRP3_PLAYER)), 175);
	TRP3_FieldSet_SetCaption(TRP3_RegisterAbout_AboutPanel_Edit, TRP3_L("REG_PLAYER_ABOUTS"):format(safeGet("player/characteristics/firstName", TRP3_PLAYER)), 175);
	
	if isEditMode then
		refreshEditDisplay()
	else
		refreshConsultDisplay()
	end
end

local function onPlayerAboutShow()
	isEditMode = false;
	refreshDisplay();
end

function TRP3_UI_AboutEditButton()
	isEditMode = true;
	refreshDisplay();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI MISC
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onPlayerAboutRefresh()
	TRP3_ShowIfMouseOver(TRP3_RegisterAbout_AboutPanel_EditButton, TRP3_RegisterAbout_AboutPanel);
end

function TRP3_UI_AboutSaveButton()
	save();
	onPlayerAboutShow();
end

function TRP3_UI_AboutCancelButton()
	onPlayerAboutShow();
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_Register_AboutInit()
	TRP3_RegisterMenu({
		id = "main_02_player_about",
		text = TRP3_L("REG_PLAYER_ABOUT"),
		isChildOf = "main_00_player",
		onSelected = function() TRP3_SetPage("player_about"); end,
	});
	TRP3_RegisterPage({
		id = "player_about",
		templateName = "TRP3_RegisterAbout",
		frameName = "TRP3_RegisterAbout",
		frame = TRP3_RegisterAbout,
		background = "Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground",
		onPagePostShow = function() onPlayerAboutShow(); end,
	});
	
	-- UI
	TRP3_CreateRefreshOnFrame(TRP3_RegisterAbout_AboutPanel, 0.2, onPlayerAboutRefresh);
	local bkgTab = TRP3_getTiledBkgListForListbox();
	TRP3_LabelledListBox_Setup("Background", TRP3_RegisterAbout_Edit_BckFieldDD, bkgTab, setEditBkg, nil, 120, true);  -- TODO: local background
	TRP3_LabelledListBox_Setup("Template", TRP3_RegisterAbout_Edit_TemplateFieldDD, {{"Template 1", 1}, {"Template 2", 2}, {"Template 3", 3}}, setEditTemplate, nil, 120, true);  -- TODO: local template
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_PhysBkg, bkgTab, setTemplate3PhysBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_PsyBkg, bkgTab, setTemplate3PsyBkg, nil, 120, true);
	TRP3_ListBox_Setup(TRP3_RegisterAbout_Edit_Template3_HistBkg, bkgTab, setTemplate3HistBkg, nil, 120, true);
	TRP3_RegisterAbout_Edit_Template3_PhysIcon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onPhisIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_PsyIcon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onPsychoIconSelected) end );
	TRP3_RegisterAbout_Edit_Template3_HistIcon:SetScript("OnClick", function() TRP3_OpenIconBrowser(onHistoIconSelected) end );

	-- Locals
	TRP3_SetTooltipForSameFrame(TRP3_RegisterAbout_AboutPanel_EditButton, "TOP", 0, 5, TRP3_L("REG_PLAYER_EDIT_NAME"));
	TRP3_RegisterAbout_Edit_Template3_PhysTitle:SetText(loc("REG_PLAYER_PHYSICAL"));
	TRP3_RegisterAbout_Edit_Template3_PsyTitle:SetText(loc("REG_PLAYER_PSYCHO"));
	TRP3_RegisterAbout_Edit_Template3_HistTitle:SetText(loc("REG_PLAYER_HISTORY"));
	
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h1",GameFontNormalHuge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h2",GameFontNormalLarge);
	TRP3_RegisterAbout_AboutPanel_Template1:SetFontObject("h3",GameFontNormal);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h1",1,1,1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h2",1,1,1);
	TRP3_RegisterAbout_AboutPanel_Template1:SetTextColor("h3",1,1,1);
end
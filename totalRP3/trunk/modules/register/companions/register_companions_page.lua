--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Register : Pets/mounts managements
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- imports
local Globals, loc, Utils, Events = TRP3_API.globals, TRP3_API.locale.getText, TRP3_API.utils, TRP3_API.events;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;
local companionIDToInfo = TRP3_API.utils.str.companionIDToInfo;
local getCompanionProfile = TRP3_API.companions.player.getCompanionProfile;
local setupFieldSet = TRP3_API.ui.frame.setupFieldPanel;
local setupDropDownMenu = TRP3_API.ui.listbox.setupDropDownMenu;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local color, getIcon, tableRemove = Utils.str.color, Utils.str.icon, Utils.table.remove;
local assert, tostring, type, _G = assert, tostring, type, _G;
local hidePopups = TRP3_API.popup.hidePopups;
local displayConsult;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.navigation.page.id.COMPANIONS_PAGE = "companions_page";


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peek management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local PEEK_PRESETS; -- Read only
local GLANCE_NOT_USED_ICON = "INV_Misc_QuestionMark";
local setupGlanceButton, openGlanceEditor = TRP3_API.register.setupGlanceButton, TRP3_API.register.openGlanceEditor;

local function refreshIfNeeded()
	if getCurrentPageID() == TRP3_API.navigation.page.id.COMPANIONS_PAGE then
		local context = getCurrentContext();
		assert(context, "No context for page player_main !");
		if not context.isEditMode then
			hidePopups();
			displayConsult(context);
		end
	end
end

local function applyPeekSlotProfile(slot, dataTab, ic, ac, ti, tx)
	assert(slot, "No selection ...");
	if not dataTab.PE then
		dataTab.PE = {};
	end
	if not dataTab.PE[slot] then
		dataTab.PE[slot] = {};
	end
	local peekTab = dataTab.PE[slot];
	peekTab.IC = ic;
	peekTab.AC = ac;
	peekTab.TI = ti;
	peekTab.TX = tx;
	-- version increment
	dataTab.v2 = Utils.math.incrementNumber(dataTab.v2 or 0, 2);
	-- Refresh display & target frame
	Events.fireEvent(Events.TARGET_SHOULD_REFRESH);
end

local function applyPeekSlot(slot, companionID, ic, ac, ti, tx)
	local dataTab = (getCompanionProfile(companionID) or {}).data or {};
	applyPeekSlotProfile(slot, dataTab, ic, ac, ti, tx);
end

function TRP3_API.companions.player.setGlanceSlotPreset(slot, presetID, companionFullID)
	local owner, companionID = companionIDToInfo(companionFullID);
	if presetID == -1 then
		applyPeekSlot(slot, companionID, nil, nil, nil, nil);
	else
		assert(PEEK_PRESETS[presetID], "Unknown peek preset: " .. tostring(presetID));
		local preset = PEEK_PRESETS[presetID];
		applyPeekSlot(slot, companionID, preset.icon, true, preset.title, preset.text);
	end
	refreshIfNeeded();
end

local function onGlanceEditorConfirm(button, ic, ac, ti, tx)
	local context = getCurrentContext();
	assert(context and context.profile, "No profile in context !");
	applyPeekSlotProfile(button.index, context.profile.data, ic, ac, ti, tx);
	refreshIfNeeded();
end

local function onGlanceClick(button)
	openGlanceEditor(button, onGlanceEditorConfirm);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Edit Mode
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function displayEdit()
	local context = getCurrentContext();
	assert(context, "No context !");
	assert(context.profile, "No profile in context");

end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Consult Mode
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function displayConsult(context)
	local profileName = context.profile.profileName;
	local dataTab = context.profile.data or Globals.empty;

	TRP3_CompanionsPageInformationConsult_NamePanel_Name:SetText(dataTab.NA or UNKNOWN);
	TRP3_CompanionsPageInformationConsult_NamePanel_Title:SetText(dataTab.FT or "");
	setupIconButton(TRP3_CompanionsPageInformationConsult_NamePanel_Icon, dataTab.IC or Globals.icons.profile_default);

	for i=1,5 do
		local glanceData = (dataTab.PE or {})[tostring(i)] or {};
		local button = _G["TRP3_CompanionsPageInformationConsult_GlanceSlot" .. i];
		button.data = glanceData;
		setupGlanceButton(button, glanceData.AC, glanceData.IC, glanceData.TI, glanceData.TX, context.isPlayer);
	end

	TRP3_CompanionsPageInformationConsult_About_Empty:Show();
	if dataTab.TX and dataTab.TX:len() > 0 then
		TRP3_CompanionsPageInformationConsult_About_Empty:Hide();

	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- UI: TAB MANAGEMENT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabGroup;

local function refresh()
	local context = getCurrentContext();
	assert(context, "No context !");
	assert(context.profile, "No profile in context");

	TRP3_CompanionsPageInformationConsult:Hide();
	TRP3_CompanionsPageInformationEdit:Hide();
	TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:Hide();

	if context.isPlayer then
		TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:Show();
	end

	if getCurrentContext().isEditMode then
		assert(context.isPlayer, "Trying to show companion edition but is not mine ...");
		displayEdit();
		TRP3_CompanionsPageInformationEdit:Show();
	else
		displayConsult(context);
		TRP3_CompanionsPageInformationConsult:Show();
	end

	TRP3_CompanionsPageInformation:Show();
end

local function showInformationTab()
	getCurrentContext().isEditMode = false;
	refresh();
end

local function toEditMode()
	getCurrentContext().isEditMode = true;
	refresh();
end

local function createTabBar()
	local frame = CreateFrame("Frame", "TRP3_CompanionInfoTabBar", TRP3_CompanionsPage);
	frame:SetSize(400, 30);
	frame:SetPoint("TOPLEFT", 17, -5);
	frame:SetFrameLevel(1);
	tabGroup = TRP3_API.ui.frame.createTabPanel(frame,
		{
			{loc("REG_COMPANION_INFO"), 1, 150}
		},
		function(tabWidget, value)
			-- Clear all
			TRP3_CompanionsPageInformation:Hide();
			if value == 1 then
				showInformationTab();
			end
		end
	);
end

local function onPageShow(context)
	assert(context.profileID, "Missing profileID in context.");
	assert(context.profile, "Missing profile in context.");
	tabGroup:SelectTab(1);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	PEEK_PRESETS = TRP3_Presets.peek;

	registerPage({
		id = TRP3_API.navigation.page.id.COMPANIONS_PAGE,
		frame = TRP3_CompanionsPage,
		onPagePostShow = function(context)
			assert(context, "Missing context.");
			onPageShow(context);
		end,
	});

	TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:SetScript("OnClick", toEditMode);

	setupFieldSet(TRP3_CompanionsPageInformationConsult_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	setupFieldSet(TRP3_CompanionsPageInformationConsult_Glance, loc("REG_PLAYER_GLANCE"), 150);
	setupFieldSet(TRP3_CompanionsPageInformationConsult_About, loc("REG_PLAYER_ABOUT"), 150);
	TRP3_CompanionsPageInformationConsult_About_Empty:SetText(loc("REG_PLAYER_ABOUT_EMPTY"));
	TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:SetText(loc("CM_EDIT"));

	for index=1,5,1 do
		-- DISPLAY
		local button = _G["TRP3_CompanionsPageInformationConsult_GlanceSlot" .. index];
		button:SetDisabledTexture("Interface\\ICONS\\" .. GLANCE_NOT_USED_ICON);
		button:GetDisabledTexture():SetDesaturated(1);
		button:SetScript("OnClick", onGlanceClick);
		button.index = tostring(index);
	end

	createTabBar();
end);
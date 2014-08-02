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
local numberToHexa, hexaToNumber = Utils.color.numberToHexa, Utils.color.hexaToNumber;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local getCurrentContext, getCurrentPageID = TRP3_API.navigation.page.getCurrentContext, TRP3_API.navigation.page.getCurrentPageID;
local color, getIcon, tableRemove = Utils.str.color, Utils.str.icon, Utils.table.remove;
local assert, tostring, type, _G, wipe, strtrim, strconcat, pairs = assert, tostring, type, _G, wipe, strtrim, strconcat, pairs;
local hidePopups = TRP3_API.popup.hidePopups;
local displayConsult;
local tcopy, tsize, tinsert, EMPTY = Utils.table.copy, Utils.table.size, tinsert, Globals.empty;
local stEtN = Utils.str.emptyToNil;
local stNtE = Utils.str.nilToEmpty;
local getTiledBackground = TRP3_API.ui.frame.getTiledBackground;
local getTiledBackgroundList = TRP3_API.ui.frame.getTiledBackgroundList;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local isUnitIDKnown, hasProfile, getUnitIDProfile = TRP3_API.register.isUnitIDKnown, TRP3_API.register.hasProfile, TRP3_API.register.getUnitIDProfile;
local getCompleteName, openPageByUnitID = TRP3_API.register.getCompleteName;
local deleteProfile = TRP3_API.companions.register.deleteProfile;
local showConfirmPopup = TRP3_API.popup.showConfirmPopup;

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
	if not dataTab[slot] then
		dataTab[slot] = {};
	end
	local peekTab = dataTab[slot];
	peekTab.IC = ic;
	peekTab.AC = ac;
	peekTab.TI = ti;
	peekTab.TX = tx;
	-- version increment
	dataTab.v = Utils.math.incrementNumber(dataTab.v or 1, 2);
	-- Refresh display & target frame
	Events.fireEvent(Events.TARGET_SHOULD_REFRESH);
end

local function applyPeekSlot(slot, companionID, ic, ac, ti, tx)
	local dataTab = (getCompanionProfile(companionID) or {}).PE or {};
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
	applyPeekSlotProfile(button.index, context.profile.PE, ic, ac, ti, tx);
	refreshIfNeeded();
end

local function onGlanceClick(button)
	local context = getCurrentContext();
	if context.isPlayer then
		openGlanceEditor(button, onGlanceEditorConfirm);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Edit Mode
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local draftData;

local function saveInDraft(profileName)
	assert(type(draftData) == "table", "Error: Nil draftData or not a table.");
	draftData.NA = stEtN(strtrim(TRP3_CompanionsPageInformationEdit_NamePanel_NameField:GetText())) or profileName;
	draftData.TI = stEtN(strtrim(TRP3_CompanionsPageInformationEdit_NamePanel_TitleField:GetText()));
	draftData.BK = TRP3_CompanionsPageInformationEdit_About_BckField:GetSelectedValue();
	draftData.TX = stEtN(strtrim(TRP3_CompanionsPageInformationEdit_About_TextScrollText:GetText()));
end

local function onNameColorSelected(red, green, blue)
	if red and green and blue then
		local hexa = strconcat(numberToHexa(red), numberToHexa(green), numberToHexa(blue))
		draftData.NH = hexa;
	else
		draftData.NH = nil;
	end
end

local function setBkg(frame, bkg)
	local backdrop = frame:GetBackdrop();
	backdrop.bgFile = getTiledBackground(bkg or 1);
	frame:SetBackdrop(backdrop);
end

local function saveInformation()
	local context = getCurrentContext();
	assert(context, "No context !");
	assert(context.profile, "No profile in context");

	local dataTab = context.profile;
	assert(type(dataTab.data) == "table", "Error: Nil information data or not a table.");
	
	saveInDraft(context.profile.profileName);
	
	wipe(dataTab.data);
	-- By simply copy the draftData we get everything we need about ordering and structures.
	tcopy(dataTab.data, draftData);
	-- version increment
	dataTab.data.v = Utils.math.incrementNumber(dataTab.data.v or 0, 2);

--	compressData();
	Events.fireEvent(Events.TARGET_SHOULD_REFRESH);
end

local function onPlayerIconSelected(icon)
	draftData.IC = icon;
	setupIconButton(TRP3_CompanionsPageInformationEdit_NamePanel_Icon, draftData.IC or Globals.icons.profile_default);
end

local function displayEdit()
	local context = getCurrentContext();
	assert(context, "No context !");
	assert(context.profile, "No profile in context");
	
	-- Copy character's data into draft structure : We never work directly on saved_variable structures !
	if not draftData then
		local dataTab = context.profile.data;
		assert(type(dataTab) == "table", "Error: Nil characteristics data or not a table.");
		draftData = {};
		tcopy(draftData, dataTab);
	end

	setupIconButton(TRP3_CompanionsPageInformationEdit_NamePanel_Icon, draftData.IC or Globals.icons.profile_default);
	TRP3_CompanionsPageInformationEdit_NamePanel_TitleField:SetText(draftData.TI or "");
	TRP3_CompanionsPageInformationEdit_NamePanel_NameField:SetText(draftData.NA or Globals.player);
	TRP3_CompanionsPageInformationEdit_About_BckField:SetSelectedIndex(draftData.BK or 1);
	TRP3_CompanionsPageInformationEdit_About_TextScrollText:SetText(draftData.TX or "");
	TRP3_CompanionsPageInformationEdit_NamePanel_NameColor.setColor(hexaToNumber(draftData.NH))
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Consult Mode
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function displayConsult(context)
	local profileName = context.profile.profileName;
	local dataTab = context.profile.data or Globals.empty;

	TRP3_CompanionsPageInformationConsult_NamePanel_Name:SetText("|cff" .. (dataTab.NH or "ffffff") .. (dataTab.NA or UNKNOWN));
	TRP3_CompanionsPageInformationConsult_NamePanel_Title:SetText(dataTab.TI or "");
	setupIconButton(TRP3_CompanionsPageInformationConsult_NamePanel_Icon, dataTab.IC or Globals.icons.profile_default);

	for i=1,5 do
		local glanceData = (context.profile.PE or {})[tostring(i)] or {};
		local button = _G["TRP3_CompanionsPageInformationConsult_GlanceSlot" .. i];
		button.data = glanceData;
		setupGlanceButton(button, glanceData.AC, glanceData.IC, glanceData.TI, glanceData.TX, context.isPlayer);
	end

	TRP3_CompanionsPageInformationConsult_About_Empty:Show();
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetText("");
	if dataTab.TX and dataTab.TX:len() > 0 then
		TRP3_CompanionsPageInformationConsult_About_Empty:Hide();
		local text = Utils.str.toHTML(dataTab.TX);
		TRP3_CompanionsPageInformationConsult_About_ScrollText:SetText(text);
	end
	setBkg(TRP3_CompanionsPageInformationConsult_About, dataTab.BK);
end

local function onActionSelected(value)
	if value == 1 then
		local context = getCurrentContext();
		assert(context, "No context !");
		assert(context.profileID, "No profile ID in context");
		assert(context.profile, "No profile in context");
		showConfirmPopup(loc("REG_DELETE_WARNING"):format(context.profile.data.NA or UNKOWN), function()
			deleteProfile(context.profileID)
		end);
	elseif type(value) == "string" then
		openPageByUnitID(value);
	end
end

local function onActionClick(button)
	local context = getCurrentContext();
	assert(context, "No context !");
	assert(context.profile, "No profile in context");
	
	local values = {};
	tinsert(values,{loc("PR_DELETE_PROFILE"), 1});
	local masters = {};
	for companionFullId, _ in pairs(context.profile.links or EMPTY) do
		local ownerID, _ = companionIDToInfo(companionFullId);
		masters[ownerID] = true;
	end
	if tsize(masters) > 0 then
		local masterTab = {};
		for ownerID, _ in pairs(masters) do
			if isUnitIDKnown(ownerID) and hasProfile(ownerID) then
				local profile = getUnitIDProfile(ownerID);
				local name = getCompleteName(profile.characteristics or EMPTY, ownerID, true);
				tinsert(masterTab, {name, ownerID});
			end
		end
		tinsert(values, {loc("PR_CO_MASTERS"), masterTab});
	end
	displayDropDown(button, values, onActionSelected, 0, true);
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
	TRP3_CompanionsPageInformationConsult_NamePanel_ActionButton:Show();

	if context.isPlayer then
		TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:Show();
		TRP3_CompanionsPageInformationConsult_NamePanel_ActionButton:Hide();
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

local function onSave()
	saveInformation();
	showInformationTab();
end

local function toEditMode()
	draftData = nil;
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

local showIconBrowser = TRP3_API.popup.showIconBrowser;

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	PEEK_PRESETS = TRP3_Presets.peek;
	openPageByUnitID = TRP3_API.register.openPageByUnitID;

	registerPage({
		id = TRP3_API.navigation.page.id.COMPANIONS_PAGE,
		frame = TRP3_CompanionsPage,
		onPagePostShow = function(context)
			assert(context, "Missing context.");
			onPageShow(context);
		end,
	});

	TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:SetScript("OnClick", toEditMode);
	TRP3_CompanionsPageInformationEdit_NamePanel_CancelButton:SetScript("OnClick", showInformationTab);
	TRP3_CompanionsPageInformationEdit_NamePanel_SaveButton:SetScript("OnClick", onSave);
	TRP3_CompanionsPageInformationEdit_NamePanel_Icon:SetScript("OnClick", function() showIconBrowser(onPlayerIconSelected) end );
	TRP3_CompanionsPageInformationEdit_NamePanel_NameColor.onSelection = onNameColorSelected;

	setupFieldSet(TRP3_CompanionsPageInformationConsult_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	setupFieldSet(TRP3_CompanionsPageInformationConsult_Glance, loc("REG_PLAYER_GLANCE"), 150);
	setupFieldSet(TRP3_CompanionsPageInformationConsult_About, loc("REG_PLAYER_ABOUT"), 150);
	TRP3_CompanionsPageInformationConsult_About_Empty:SetText(loc("REG_PLAYER_ABOUT_EMPTY"));
	TRP3_CompanionsPageInformationConsult_NamePanel_EditButton:SetText(loc("CM_EDIT"));
	setupIconButton(TRP3_CompanionsPageInformationConsult_NamePanel_ActionButton, "icon_petfamily_mechanical");
	setTooltipForSameFrame(TRP3_CompanionsPageInformationConsult_NamePanel_ActionButton, "TOP", 0, 5, loc("CM_ACTIONS"));
	TRP3_CompanionsPageInformationConsult_NamePanel_ActionButton:SetScript("OnClick", onActionClick);
	
	setTooltipForSameFrame(TRP3_CompanionsPageInformationEdit_NamePanel_NameColor, "RIGHT", 0, 5, loc("REG_COMPANION_NAME_COLOR"), loc("REG_PLAYER_COLOR_TT"));
	setupFieldSet(TRP3_CompanionsPageInformationEdit_NamePanel, loc("REG_PLAYER_NAMESTITLES"), 150);
	setupFieldSet(TRP3_CompanionsPageInformationEdit_About, loc("REG_PLAYER_ABOUT"), 150);
	TRP3_CompanionsPageInformationEdit_NamePanel_NameFieldText:SetText(loc("REG_COMPANION_NAME"));
	TRP3_CompanionsPageInformationEdit_NamePanel_TitleFieldText:SetText(loc("REG_COMPANION_TITLE"));
	TRP3_CompanionsPageInformationEdit_NamePanel_CancelButton:SetText(loc("CM_CANCEL"));
	TRP3_CompanionsPageInformationEdit_NamePanel_SaveButton:SetText(loc("CM_SAVE"));
	local bkgTab = getTiledBackgroundList();
	setupListBox(TRP3_CompanionsPageInformationEdit_About_BckField, bkgTab, function(value) setBkg(TRP3_CompanionsPageInformationEdit_About, value) end, nil, 120, true);
	TRP3_API.ui.text.setupToolbar("TRP3_CompanionsPageInformationEdit_About_Toolbar", TRP3_CompanionsPageInformationEdit_About_TextScrollText);
	
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetFontObject("p", GameFontNormal);
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetFontObject("h1", GameFontNormalHuge3);
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetFontObject("h2", GameFontNormalHuge);
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetFontObject("h3", GameFontNormalLarge);
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetTextColor("h1", 1, 1, 1);
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetTextColor("h2", 1, 1, 1);
	TRP3_CompanionsPageInformationConsult_About_ScrollText:SetTextColor("h3", 1, 1, 1);
	
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
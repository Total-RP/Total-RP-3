--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3 Main structure
-- Handles the main page content and left menu
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Public accessor
TRP3_API.navigation = {
	menu = {},
	page = {}
};

-- imports
local Log = TRP3_API.utils.log;
local CreateFrame = CreateFrame;
local loc = TRP3_API.locale.getText;
local TRP3_TutorialFrame, TRP3_TutorialTooltip, TRP3_MainTutorialButton = TRP3_TutorialFrame, TRP3_TutorialTooltip, TRP3_MainTutorialButton;
local TRP3_MainFrameMenuContainer, TRP3_MainFramePageContainer, TRP3_MainFrame = TRP3_MainFrameMenuContainer, TRP3_MainFramePageContainer, TRP3_MainFrame;
local assert, pairs, tinsert, table, error, type, _G = assert, pairs, tinsert, table, error, type, _G;
local selectMenu, unregisterMenu;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Menu management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Placeholder for menu structures
local menuStructures = {}; 
-- The currently selected menuId
local selectedMenuId;
-- Placeholder for menu ui button
local uiMenuWidgets = {};
-- Determine the original top margin from where the first button is placed
local marginTop = -5;
-- Menu button height, determine the vertical gap between each button
local buttonHeight = 25;

local function onMenuClick(menu)
	assert(menu.id, "Menu button does not have a attached menu id.");
	selectMenu(menu.id);
end

local function onMenuClosed(menu)
	assert(menu:GetParent().id, "Menu button does not have a attached menu id.");
	unregisterMenu(menu:GetParent().id);
end

local function closeAll(parentMenu)
	assert(parentMenu, "No parent menu in close all button.");
	for id, menuStructure in pairs(menuStructures) do
		if menuStructure.isChildOf then
			unregisterMenu(id);
		end
	end
end

local function isCloseable(menuID)
	return menuStructures[menuID] and menuStructures[menuID].closeable;
end

local closeAllButton = CreateFrame("Button", "TRP3_MainFrameMenuButtonCloseAll", TRP3_MainFrameMenuContainer, "TRP3_CommonButton");

-- The menu is built by SORTED menu item key.
local function rebuildMenu()
	-- Hide all
	closeAllButton:Hide();
	for _, widget in pairs(uiMenuWidgets) do
		widget:Hide();
	end
	
	-- Sort menu by name
	-- Only take visible menu
	local ids = {};
	for id, menuStructure in pairs(menuStructures) do
		if not menuStructure.hidden then
			tinsert(ids, id);
		end
	end
	table.sort(ids);

	local index = 0;
	local y = marginTop;
	local latestID;
	for i, id in pairs(ids) do
		local menuStructure = menuStructures[id];
		-- if Top button || Selected parent || Selected sibling
		if not menuStructure.isChildOf or menuStructure.isChildOf == selectedMenuId or (selectedMenuId and menuStructures[selectedMenuId].isChildOf == menuStructure.isChildOf) then
			local uiButton = uiMenuWidgets[index+1];
			if uiButton == nil then -- Create the button
				uiButton = CreateFrame("Button", "TRP3_MainFrameMenuButton"..index, TRP3_MainFrameMenuContainer, "TRP3_CategoryButton");
				uiButton:SetScript("OnClick", onMenuClick);
				_G[uiButton:GetName().."Close"]:SetScript("OnClick", onMenuClosed);
				tinsert(uiMenuWidgets, uiButton);
			end
			uiButton:Enable();
			uiButton:UnlockHighlight();
			
			if id == selectedMenuId then
				uiButton:Disable();
				uiButton:LockHighlight();
			end
			uiButton:ClearAllPoints();
			
			local label = _G[uiButton:GetName().."Label"];
			local close = _G[uiButton:GetName().."Close"];
			close:Hide();
			if menuStructure.isChildOf then
				uiButton:SetPoint("LEFT", 30, y);
				uiButton:SetPoint("RIGHT", -15, y);
				label:SetTextColor(1, 1, 1);
				label:SetJustifyH(menuStructure.align or "RIGHT");
				if isCloseable(id) or isCloseable(menuStructure.isChildOf) then
					close:Show();
				end
			else
				uiButton:SetPoint("LEFT", 0, y);
				uiButton:SetPoint("RIGHT", -15, y);
				label:SetTextColor(1, 0.75, 0);
				label:SetJustifyH(menuStructure.align or "LEFT");
			end
			label:SetText(menuStructure.text);
			
			latestID = id;
			uiButton:Show();
			uiButton.id = id;
			index = index + 1;
			y = y - buttonHeight;
			
			if menuStructure.isChildOf and menuStructures[menuStructure.isChildOf].closeable and (not ids[i + 1] or not menuStructures[ids[i + 1]].isChildOf) then
				-- Place close all button
				closeAllButton:SetPoint("LEFT", 32, y);
				closeAllButton:SetPoint("RIGHT", -20, y);
				closeAllButton.parentMenu = menuStructure.isChildOf;
				closeAllButton:Show();
				y = y - buttonHeight;
			end
		end
	end
end
TRP3_API.navigation.menu.rebuildMenu = rebuildMenu;

-- Register a menu structure
-- Automatically refresh the menu display
local function registerMenu(menuStructure)
	assert(menuStructure and menuStructure.id, "menuStructure must have an id field.");
	assert(not menuStructures[menuStructure.id], "The menu with id "..(menuStructure.id).." has already been registered.");
	menuStructures[menuStructure.id] = menuStructure;
	rebuildMenu();
end
TRP3_API.navigation.menu.registerMenu = registerMenu;

-- Unregister a menu structure.
-- Automatically refresh the menu display
function unregisterMenu(menuId)
	if selectedMenuId == menuId then 
		if menuStructures[menuId].isChildOf then
			selectMenu(menuStructures[menuId].isChildOf);
		else
			error("Cannot unregister the current selected menu entry");
		end
	end
	menuStructures[menuId] = nil;
	rebuildMenu();
end
TRP3_API.navigation.menu.unregisterMenu = unregisterMenu;

-- Set a menu or submenu as selected
selectMenu = function(menuId)
	assert(menuStructures[menuId], "Unknown menuId "..menuId);
	selectedMenuId = menuId;
	rebuildMenu();
	if menuStructures[menuId].onSelected then
		menuStructures[menuId].onSelected();
	end
	TRP3_API.popup.hidePopups();
end
TRP3_API.navigation.menu.selectMenu = selectMenu;

-- Use to access and change menu properties.
-- Any properties can be changed but rebuildMenu must be called in order to apply these changes.
local function getMenuItem(menuId)
	assert(menuStructures[menuId], "Unknown menuId "..menuId);
	return menuStructures[menuId];
end
TRP3_API.navigation.menu.getMenuItem = getMenuItem;

TRP3_API.navigation.menu.isMenuRegistered = function(menuID)
	return menuStructures[menuID] ~= nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Main structure & page system
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Placeholder for page structure
local pageStructures = {};
-- Currently displayed page
local currentPageId;
local currentContext;

local function checkPageSelection()
	if currentPageId == nil then
		-- TODO: what to do ?
	end
end

local function registerPage(pageStructure)
	assert(pageStructure and pageStructure.id, "pageStructure must have an id field.");
	assert(pageStructure.frame or (pageStructure.templateName and pageStructure.frameName), "pageStructure must have a frame or a templateName and a frameName field.");
	assert(not pageStructures[pageStructure.id], "The page with id "..(pageStructure.id).." has already been registered.");
	pageStructures[pageStructure.id] = pageStructure;
end
TRP3_API.navigation.page.registerPage = registerPage;

local function setPage(pageId, context)
	Log.log("setPage: "..pageId);
	
	assert(pageStructures[pageId], "Unknown pageId "..pageId);
	assert(context == nil or type(context) == "table", "Context must be a table or nil.");
	
	if currentPageId then -- Hide current page
		if pageStructures[currentPageId].frame then
			pageStructures[currentPageId].frame:Hide();
		end
	end
	
	currentPageId = pageId;
	currentContext = context;
	local currentPage = pageStructures[currentPageId];
	if not currentPage.frame then
		if not _G[currentPage.frameName] then
			-- Create new frame
			CreateFrame("Frame", currentPage.frameName, TRP3_MainFramePageContainer, currentPage.templateName);
		end
		currentPage.frame = _G[currentPage.frameName];
	end
	
	-- Show
	if currentPage.onPagePreShow then
		currentPage.onPagePreShow(context);
	end
	
	currentPage.frame:ClearAllPoints();
	currentPage.frame:SetParent(TRP3_MainFramePageContainer);
	currentPage.frame:SetPoint("TOPRIGHT", 0, 0);
	currentPage.frame:SetPoint("BOTTOMLEFT", 0, 0);
	currentPage.frame:Show();
	
	-- Show
	if currentPage.onPagePostShow then
		currentPage.onPagePostShow(context);
	end
	
	TRP3_API.events.fireEvent(TRP3_API.events.NAVIGATION_TUTORIAL_REFRESH, pageId);
end
TRP3_API.navigation.page.setPage = setPage;

local function getCurrentContext()
	return currentContext;
end
TRP3_API.navigation.page.getCurrentContext = getCurrentContext;

local function getCurrentPageID()
	return currentPageId;
end
TRP3_API.navigation.page.getCurrentPageID = getCurrentPageID;

TRP3_API.navigation.openMainFrame = function()
	TRP3_MainFrame:Show();
end

local function switchMainFrame()
	if TRP3_MainFrame:IsVisible() then
		TRP3_MainFrame:Hide();
	else
		TRP3_MainFrame:Show();
	end
end
TRP3_API.navigation.switchMainFrame = switchMainFrame;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tutorial frame
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local BUTTONS = {};

local function buttonOnLeave(button)
	button.box:Show();
	button.boxHighlight:Hide();
	TRP3_TutorialTooltip:ClearAllPoints();
	TRP3_TutorialTooltip.ArrowRIGHT:Hide();
	TRP3_TutorialTooltip.ArrowGlowRIGHT:Hide();
	TRP3_TutorialTooltip.ArrowUP:Hide();
	TRP3_TutorialTooltip.ArrowGlowUP:Hide();
	TRP3_TutorialTooltip.ArrowDOWN:Hide();
	TRP3_TutorialTooltip.ArrowGlowDOWN:Hide();
	TRP3_TutorialTooltip.ArrowLEFT:Hide();
	TRP3_TutorialTooltip.ArrowGlowLEFT:Hide();
	TRP3_TutorialTooltip:Hide();
end

local function buttonOnEnter(button)
	button.box:Hide();
	button.boxHighlight:Show();
	
	if button.arrow == "RIGHT" then
		TRP3_TutorialTooltip:SetPoint("LEFT", button, "RIGHT", 10, 0);
		TRP3_TutorialTooltip.ArrowRIGHT:Show();
		TRP3_TutorialTooltip.ArrowGlowRIGHT:Show();
	elseif button.arrow == "LEFT" then
		TRP3_TutorialTooltip:SetPoint("RIGHT", button, "LEFT", -10, 0);
		TRP3_TutorialTooltip.ArrowLEFT:Show();
		TRP3_TutorialTooltip.ArrowGlowLEFT:Show();
	elseif button.arrow == "UP" then
		TRP3_TutorialTooltip:SetPoint("BOTTOM", button, "TOP", 0, 10);
		TRP3_TutorialTooltip.ArrowUP:Show();
		TRP3_TutorialTooltip.ArrowGlowUP:Show();
	else
		TRP3_TutorialTooltip:SetPoint("TOP", button, "BOTTOM", 0, -10);
		TRP3_TutorialTooltip.ArrowDOWN:Show();
		TRP3_TutorialTooltip.ArrowGlowDOWN:Show();
	end
	
	TRP3_TutorialTooltip:SetWidth(button.textWidth);
	TRP3_TutorialTooltip.Text:SetWidth(button.textWidth - 30);
	TRP3_TutorialTooltip.Text:SetText(button.text);
	TRP3_TutorialTooltip:Show();
end

local function configureButton(button)
	button:SetSize(46, 46);
	button:SetScript("OnEnter", buttonOnEnter);
	button:SetScript("OnLeave", buttonOnLeave);
end

local function showTutorial(tutorialStructure)
	-- Hide all
	for _, buttonWidget in pairs(BUTTONS) do
		buttonWidget:Hide();
		buttonWidget.box:Hide();
		buttonWidget.boxHighlight:Hide();
	end

	for frameIndex, frameInfo in pairs(tutorialStructure) do
		if not BUTTONS[frameIndex] then
			BUTTONS[frameIndex] = CreateFrame( "Button", nil, TRP3_TutorialFrame, "TRP3_TutorialButton" );
			BUTTONS[frameIndex].box = CreateFrame( "Frame", nil, TRP3_TutorialFrame, "HelpPlateBox" );
			BUTTONS[frameIndex].boxHighlight = CreateFrame( "Frame", nil, TRP3_TutorialFrame, "HelpPlateBoxHighlight" );
			configureButton(BUTTONS[frameIndex]);
		end
		local buttonWidget = BUTTONS[frameIndex];
		buttonWidget:ClearAllPoints();
		buttonWidget:SetPoint( frameInfo.button.anchor, buttonWidget.box, frameInfo.button.anchor, frameInfo.button.x, frameInfo.button.y );
		buttonWidget:Show();
		buttonWidget.arrow = frameInfo.button.arrow or "RIGHT";
		buttonWidget.text = frameInfo.button.text;
		buttonWidget.textWidth = frameInfo.button.textWidth or 220;
		
		local box = buttonWidget.box;
		box:ClearAllPoints();
		if frameInfo.box.allPoints then
			box:SetAllPoints(frameInfo.box.allPoints);
		else
			box:SetSize(frameInfo.box.width, frameInfo.box.height);
			box:SetPoint( frameInfo.box.anchor, TRP3_TutorialFrame, frameInfo.box.anchor, frameInfo.box.x, frameInfo.box.y );
		end
		
		box:Show();
		
		local highlight = buttonWidget.boxHighlight;
		highlight:ClearAllPoints();
		if frameInfo.box.allPoints then
			highlight:SetAllPoints(frameInfo.box.allPoints);
		else
			highlight:SetSize(frameInfo.box.width, frameInfo.box.height);
			highlight:SetPoint( frameInfo.box.anchor, TRP3_TutorialFrame, frameInfo.box.anchor, frameInfo.box.x, frameInfo.box.y );
		end
		highlight:Hide();
	end
	TRP3_TutorialFrame:Show();
end

local function onTutorialRefresh(pageID)
	if currentPageId == pageID then
		local currentPage = pageStructures[currentPageId];
		TRP3_TutorialFrame:Hide();
		if currentPage.tutorialProvider and currentPage.tutorialProvider() then
			TRP3_MainTutorialButton:Show();
			TRP3_MainTutorialButton.provider = currentPage.tutorialProvider;
		else
			TRP3_MainTutorialButton:Hide();
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.navigation.init = function()
	TRP3_MainFrame:SetScript("OnShow", function() checkPageSelection() end);
	TRP3_MainFrameClose:SetScript("OnClick", function() switchMainFrame() end);
	
	TRP3_MainTutorialButton:SetScript("OnClick", function(self)
		if TRP3_TutorialFrame:IsShown() then
			TRP3_TutorialFrame:Hide();
		elseif not TRP3_PopupsFrame:IsShown() and self.provider and self.provider() then
			showTutorial(self.provider());
		end
	end);
	TRP3_API.ui.tooltip.setTooltipAll(TRP3_MainTutorialButton, "TOP", 0, 0, loc("UI_TUTO_BUTTON"), loc("UI_TUTO_BUTTON_TT"));
	closeAllButton:SetText(loc("UI_CLOSE_ALL"));
	closeAllButton:SetScript("OnClick", function(self)
		closeAll(self.parentMenu);
	end);
	
	TRP3_API.events.listenToEvent(TRP3_API.events.NAVIGATION_TUTORIAL_REFRESH, onTutorialRefresh);
end
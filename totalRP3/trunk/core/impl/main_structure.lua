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

-- The menu is built by SORTED menu item key.
local function rebuildMenu()
	-- Hide all
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
				if menuStructure.closeable  then
					close:Show();
				end
			else
				uiButton:SetPoint("LEFT", 0, y);
				uiButton:SetPoint("RIGHT", -15, y);
				label:SetTextColor(1, 0.75, 0);
				label:SetJustifyH(menuStructure.align or "LEFT");
			end
			label:SetText(menuStructure.text);
			
			uiButton:Show();
			uiButton.id = id;
			index = index + 1;
			y = y - buttonHeight;
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
unregisterMenu = function(menuId)
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
	Log.log("setPage: "..pageId, Log.level.DEBUG);
	
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
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.navigation.init = function()
	TRP3_MainFrame:SetScript("OnShow", function() checkPageSelection() end);
	TRP3_MainFrameClose:SetScript("OnClick", function() switchMainFrame() end);
end
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");
local L = TRP3_API.loc;

-- Icon Browser Search Task
------------------------------------------------------------------------------

--- Table structure providing information about the progress of an
--- asynchronous search task against an icon model.
---
---@class TRP3.IconBrowserSearchProgress
---@field found integer
---@field searched integer
---@field total integer

---@alias TRP3.IconBrowserSearchPredicate fun(iconIndex: integer, iconInfo: TRP3.IconBrowserModelItem): boolean)

--- IconBrowserSearchTask is a single-shot object that performs an
--- asynchronous name-based search against a model to provide a filtered
--- list of icon indices.
---
---@class TRP3.IconBrowserSearchTask
---@field private callbacks TRP3.CallbackDispatcher
---@field private state "pending" | "running" | "finished"
---@field private ticker unknown
---@field private predicate TRP3.IconBrowserSearchPredicate
---@field private found integer
---@field private searched integer
---@field private iterator TRP3.IconModelItemIterator
---@field private total integer
---@field private step integer
---@field private results integer[]
local IconBrowserSearchTask = {};

---@param predicate TRP3.IconBrowserSearchPredicate
---@param model TRP3.AbstractIconBrowserModel
---@protected
function IconBrowserSearchTask:__init(predicate, model)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.state = "pending";
	self.ticker = nil;
	self.predicate = predicate;
	self.found = 0;
	self.searched = 0;
	self.iterator = model:EnumerateIcons({ reuseTable = {} });
	self.total = model:GetIconCount();

	-- On small data sets do only 5% of the set per tick to avoid UI flicker.
	self.step = math.min(500, math.ceil(model:GetIconCount() / 20));
	self.results = {};
end

function IconBrowserSearchTask:Start()
	assert(self.state == "pending", "attempted to restart an already started search task");
	self.ticker = C_Timer.NewTicker(0, function() self:OnUpdate(); end);
	self.state = "running";
	self.callbacks:Fire("OnStateChanged", self.state);
end

function IconBrowserSearchTask:Finish()
	if self.state == "finished" then
		return;
	end

	self.ticker:Cancel();
	self.ticker = nil;
	self.state = "finished";
	self.callbacks:Fire("OnStateChanged", self.state);
end

---@return TRP3.IconBrowserSearchProgress
function IconBrowserSearchTask:GetProgress()
	return { found = self.found, searched = self.searched, total = self.total };
end

function IconBrowserSearchTask:GetState()
	return self.state;
end

function IconBrowserSearchTask:GetResults()
	return self.results;
end

---@private
function IconBrowserSearchTask:OnUpdate()
	local predicate = self.predicate;
	local found = self.found;
	local results = self.results;

	local visited = self.searched;
	local limit = math.min(self.searched + self.step, self.total);

	for iconIndex, iconInfo in self.iterator do
		if predicate(iconIndex, iconInfo) then
			found = found + 1;
			results[found] = iconIndex;
		end

		visited = visited + 1;

		if visited > limit then
			break;
		end
	end

	if self.searched == 0 or self.found ~= found then
		self.found = found;
		self.callbacks:Fire("OnResultsChanged", self.results);
	end

	self.searched = limit;
	self.callbacks:Fire("OnProgressChanged", self:GetProgress());

	if self.searched >= self.total then
		self:Finish();
	end
end

---@param predicate TRP3.IconBrowserSearchPredicate
---@param model TRP3.AbstractIconBrowserModel
local function CreateIconBrowserSearchTask(predicate, model)
	return TRP3_API.CreateObject(IconBrowserSearchTask, predicate, model);
end

-- Icon Browser Data Models
------------------------------------------------------------------------------

--- Table structure providing data about a single icon sourced from a model.
---
---@class TRP3.IconBrowserModelItem
---@field index integer
---@field key integer
---@field name string
---@field type "atlas" | "file"
---@field file TRP3.FileID?
---@field atlas TRP3.AtlasElementID?
---@field selected boolean

---@alias TRP3.IconModelItemIterator fun(): integer?, TRP3.IconBrowserModelItem
---@alias TRP3.IconBrowserCategorySelections { [integer]: boolean }

--- IconBrowserModel is a basic model that sources icons from LibRPMedia.
---
---@class TRP3.IconBrowserModel : TRP3.AbstractIconBrowserModel
---@field private callbacks TRP3.CallbackDispatcher
local IconBrowserModel = {};

---@protected
function IconBrowserModel:__init()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
end

---@return integer count
function IconBrowserModel:GetIconCount()
	return LRPM12:GetNumIcons();
end

---@param index integer
---@return TRP3.IconBrowserModelItem? data
function IconBrowserModel:GetIconInfo(index)
	return LRPM12:GetIconInfoByIndex(index);
end

---@param options table?
---@return fun() iterator
function IconBrowserModel:EnumerateIcons(options)
	return LRPM12:EnumerateIcons(options);
end

---@param name string
---@return integer? index
function IconBrowserModel:GetIconIndex(name)
	if not name or name == "" then
		return nil;
	end

	return LRPM12:GetIconIndexByName(name);
end

local function CreateIconBrowserModel()
	return TRP3_API.CreateObject(IconBrowserModel);
end

--- IconBrowserFilterModel is a proxy model that implements asynchronous
--- filtering via name-based search queries.
---
---@class TRP3.IconBrowserFilterModel : TRP3.AbstractIconBrowserProxyModel
---@field private callbacks TRP3.CallbackDispatcher
---@field private source TRP3.AbstractIconBrowserModel
---@field private sourceIndices integer[]
---@field private searchQuery string
---@field private searchCategories { [integer]: true }
---@field private searchTask TRP3.IconBrowserSearchTask?
---@field private searchProgress TRP3.IconBrowserSearchProgress
local IconBrowserFilterModel = {};

---@param source TRP3.AbstractIconBrowserModel
---@protected
function IconBrowserFilterModel:__init(source)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.source = source;
	self.sourceIndices = {};
	self.searchQuery = "";
	self.searchCategories = {};
	self.searchTask = nil;

	self.source.RegisterCallback(self, "OnModelUpdated", "OnSourceModelUpdated");
end

function IconBrowserFilterModel:GetIconCount()
	local count;

	if self:IsApplyingAnyFilter() then
		count = #self.sourceIndices;
	else
		count = self.source:GetIconCount();
	end

	return count;
end

function IconBrowserFilterModel:GetIconIndex(name)
	local sourceIndex = self.source:GetIconIndex(name);
	local proxyIndex;

	if sourceIndex then
		proxyIndex = self:GetProxyIndex(sourceIndex);
	end

	return proxyIndex;
end

function IconBrowserFilterModel:GetIconInfo(proxyIndex)
	return self.source:GetIconInfo(self:GetSourceIndex(proxyIndex));
end

function IconBrowserFilterModel:EnumerateIcons(options)
	local iterator = self.source:EnumerateIcons(options);

	local function GetNextIcon()
		local sourceIndex, iconInfo = iterator();

		if sourceIndex then
			local proxyIndex = self:GetProxyIndex(sourceIndex);

			if proxyIndex then
				return proxyIndex, iconInfo;
			end
		end
	end

	return GetNextIcon;
end

function IconBrowserFilterModel:GetSourceModel()
	return self.source;
end

function IconBrowserFilterModel:GetSourceIndex(proxyIndex)
	local sourceIndex;

	if self:IsApplyingAnyFilter() then
		sourceIndex = self.sourceIndices[proxyIndex];
	else
		sourceIndex = proxyIndex;
	end

	return sourceIndex;
end

function IconBrowserFilterModel:GetProxyIndex(sourceIndex)
	local proxyIndex;

	if self:IsApplyingAnyFilter() then
		-- Inefficient but quick implementation; assuming this is never going
		-- to be called and just providing it to satisfy the interface.
		proxyIndex = tInvert(self.sourceIndices)[sourceIndex];
	else
		proxyIndex = sourceIndex;
	end

	return proxyIndex;
end

function IconBrowserFilterModel:IsApplyingAnyFilter()
	return self:HasSearchQuery() or self:IsFilteringAnyCategory();
end

function IconBrowserFilterModel:ClearAllFilters()
	self.searchQuery = "";
	self.searchCategories = {};
	self:RebuildModel();
end

function IconBrowserFilterModel:ClearSearchQuery()
	self:SetSearchQuery("");
end

function IconBrowserFilterModel:GetSearchQuery()
	return self.searchQuery;
end

function IconBrowserFilterModel:ClearCategoryFilters()
	if self:IsFilteringAnyCategory() then
		self.searchCategories = {};
		self:RebuildModel();
	end
end

function IconBrowserFilterModel:AddCategoryFilter(category)
	if self.searchCategories[category] == nil then
		self.searchCategories[category] = true;
		self:RebuildModel();
	end
end

function IconBrowserFilterModel:RemoveCategoryFilter(category)
	if self.searchCategories[category] ~= nil then
		self.searchCategories[category] = nil;
		self:RebuildModel();
	end
end

function IconBrowserFilterModel:IsFilteringCategory(category)
	return self.searchCategories[category] == true;
end

function IconBrowserFilterModel:IsFilteringAnyCategory()
	return next(self.searchCategories) ~= nil;
end

---@return TRP3.IconBrowserSearchProgress
function IconBrowserFilterModel:GetSearchProgress()
	local progress;

	if self.searchTask ~= nil then
		progress = self.searchTask:GetProgress();
	else
		local count = self.source:GetIconCount();
		progress = { found = count, searched = count, total = count };
	end

	return progress;
end

---@return "running" | "finished"
function IconBrowserFilterModel:GetSearchState()
	local state;

	if self.searchTask ~= nil then
		state = "running";
	else
		state = "finished";
	end

	return state;
end

function IconBrowserFilterModel:HasSearchQuery()
	return self.searchQuery ~= "";
end

---@param query string
function IconBrowserFilterModel:SetSearchQuery(query)
	query = TRP3_StringUtil.GenerateSearchableString(query);  ---@cast query string

	if self.searchQuery ~= query then
		self.searchQuery = query;
		self:RebuildModel();
	end
end

---@private
function IconBrowserFilterModel:OnSourceModelUpdated()
	self:RebuildModel();
end

---@private
function IconBrowserFilterModel:RebuildModel()
	if self.searchTask then
		self.searchTask:Finish();
		self.searchTask = nil;
	end

	if not self:IsApplyingAnyFilter() then
		self.callbacks:Fire("OnModelUpdated");
		return;
	end

	local function OnStateChanged(_, state)
		if state == "finished" then
			self.searchTask.UnregisterAllCallbacks(self);
			self.searchTask = nil;
		end

		self.callbacks:Fire("OnSearchStateChanged", state);
	end

	local function OnProgressChanged(_, progress)
		self.callbacks:Fire("OnSearchProgressChanged", progress);
	end

	local function OnResultsChanged(_, results)
		self.sourceIndices = results;
		self.callbacks:Fire("OnModelUpdated");
	end

	local query = self:GetSearchQuery();
	local categoryPredicate;

	if self:IsFilteringAnyCategory() then
		categoryPredicate = LRPM12:GenerateIconCategoryPredicate(GetKeysArray(self.searchCategories));
	end

	---@param _proxyIndex integer
	---@param iconInfo TRP3.IconBrowserModelItem
	local function DoesIconMatchFilters(_proxyIndex, iconInfo)
		local iconName = TRP3_StringUtil.GenerateSearchableString(iconInfo.name);
		local offset = 1;
		local plain = true;

		if not string.find(iconName, query, offset, plain) then
			return false;
		end

		-- The category predicate requires the raw index of the icon from the
		-- source-most model, not the proxy index that we're supplied.
		if categoryPredicate ~= nil and not categoryPredicate(iconInfo.index) then
			return false;
		end

		return true;
	end

	self.searchTask = CreateIconBrowserSearchTask(DoesIconMatchFilters, self.source);
	self.searchTask.RegisterCallback(self, "OnStateChanged", OnStateChanged);
	self.searchTask.RegisterCallback(self, "OnProgressChanged", OnProgressChanged);
	self.searchTask.RegisterCallback(self, "OnResultsChanged", OnResultsChanged);
	self.searchTask:Start();
end

---@param source TRP3.AbstractIconBrowserModel
local function CreateIconBrowserFilterModel(source)
	return TRP3_API.CreateObject(IconBrowserFilterModel, source);
end

--- IconBrowserSelectionModel is a proxy model that relocates the currently
--- selected icon to the start of the model.
---@class TRP3.IconBrowserSelectionModel : TRP3.AbstractIconBrowserProxyModel
---@field private callbacks TRP3.CallbackDispatcher
---@field private source TRP3.AbstractIconBrowserModel
---@field private selectedIconName string?
---@field private selectedIconSourceIndex integer?
local IconBrowserSelectionModel = {};

---@protected
function IconBrowserSelectionModel:__init(source)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.source = source;
	self.source.RegisterCallback(self, "OnModelUpdated", "OnSourceModelUpdated");
	self.selectedIconName = nil;
	self.selectedIconSourceIndex = nil;
end

function IconBrowserSelectionModel:GetIconCount()
	return self.source:GetIconCount();
end

function IconBrowserSelectionModel:GetIconIndex(name)
	local sourceIndex = self.source:GetIconIndex(name);
	local proxyIndex;

	if sourceIndex then
		proxyIndex = self:GetProxyIndex(sourceIndex);
	end

	return proxyIndex;
end

---@param index integer
---@return TRP3.IconBrowserModelItem? data
function IconBrowserSelectionModel:GetIconInfo(index)
	local sourceIndex = self:GetSourceIndex(index);
	local iconInfo = self.source:GetIconInfo(sourceIndex);

	if iconInfo then
		iconInfo.selected = (self.selectedIconSourceIndex == sourceIndex);
	end

	return iconInfo;
end

function IconBrowserSelectionModel:EnumerateIcons(options)
	-- Enumeration over the selection model requires some trickery due to
	-- our reordering of the icons. First call to the iterator should yield
	-- the selected icon (if any), and all subsequent calls should then
	-- invoke the source iterator and transform the index, skipping over the
	-- selection when we find it.

	local iterator = self.source:EnumerateIcons(options);
	local hasEnumeratedSelection = (self.selectedIconSourceIndex == nil);

	local function GetNextIcon()
		local sourceIndex;
		local proxyIndex;
		local iconInfo;

		if not hasEnumeratedSelection then
			proxyIndex = 1;
			iconInfo = self:GetIconInfo(proxyIndex);
			hasEnumeratedSelection = true;
		else
			sourceIndex, iconInfo = iterator();

			if sourceIndex == self.selectedIconSourceIndex then
				sourceIndex, iconInfo = iterator();
			end

			if sourceIndex ~= nil then
				proxyIndex = self:GetProxyIndex(sourceIndex);
			end
		end

		if proxyIndex ~= nil then
			return proxyIndex, iconInfo;
		end
	end

	return GetNextIcon;
end

function IconBrowserSelectionModel:GetSourceModel()
	return self.source;
end

function IconBrowserSelectionModel:GetSourceIndex(proxyIndex)
	local sourceIndex = proxyIndex;

	if self.selectedIconSourceIndex then
		if proxyIndex == 1 then
			sourceIndex = self.selectedIconSourceIndex;
		elseif proxyIndex <= self.selectedIconSourceIndex then
			sourceIndex = proxyIndex - 1;
		end
	end

	return sourceIndex;
end

function IconBrowserSelectionModel:GetProxyIndex(sourceIndex)
	local proxyIndex = sourceIndex;

	if self.selectedIconSourceIndex then
		if sourceIndex == self.selectedIconSourceIndex then
			proxyIndex = 1;
		elseif sourceIndex < self.selectedIconSourceIndex then
			proxyIndex = sourceIndex + 1;
		end
	end

	return proxyIndex;
end

function IconBrowserSelectionModel:GetSelectedIcon()
	return self.selectedIconName;
end

function IconBrowserSelectionModel:SetSelectedIcon(iconName)
	if self.selectedIconName ~= iconName then
		self.selectedIconName = iconName;
		self:RebuildModel();
	end
end

---@private
function IconBrowserSelectionModel:OnSourceModelUpdated()
	self:RebuildModel();
end

---@private
function IconBrowserSelectionModel:RebuildModel()
	self.selectedIconSourceIndex = self.source:GetIconIndex(self.selectedIconName);

	if not self.selectedIconSourceIndex then
		self.selectedIconName = nil;
	end

	self.callbacks:Fire("OnModelUpdated");
end

---@param source TRP3.AbstractIconBrowserModel
local function CreateIconBrowserSelectionModel(source)
	return TRP3_API.CreateObject(IconBrowserSelectionModel, source);
end

--- Creates a data provider that displays the contents of an icon data model
--- within a scrollbox list view.
---
---@param model TRP3.AbstractIconBrowserModel
---@return table provider
local function CreateIconDataProvider(model)
	local provider = CreateFromMixins(CallbackRegistryMixin);

	function provider:Enumerate(i, j)
		i = i and (i - 1) or 0;
		j = j or model:GetIconCount();

		local function Next(_, k)
			k = k + 1;

			if k <= j then
				return k, model:GetIconInfo(k);
			end
		end

		return Next, nil, i;
	end

	function provider:Find(i)
		return model:GetIconInfo(i);
	end

	function provider:GetSize()
		return model:GetIconCount();
	end

	function provider:IsVirtual()
		return true;
	end

	provider:GenerateCallbackEvents({ "OnSizeChanged" });
	provider:OnLoad();

	model.RegisterCallback(provider, "OnModelUpdated", function()
		provider:TriggerEvent("OnSizeChanged");
	end);

	return provider;
end

-- Icon Browser UI Mixins
------------------------------------------------------------------------------

TRP3_IconBrowserMixin = {};

function TRP3_IconBrowserMixin:OnLoad()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.baseModel = CreateIconBrowserModel();
	self.selectionModel = CreateIconBrowserSelectionModel(self.baseModel);
	self.filterModel = CreateIconBrowserFilterModel(self.selectionModel);

	local GRID_STRIDE = 7;
	local GRID_PADDING = 4;

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Content, "TOPLEFT", 6, -4),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.Content, "BOTTOMRIGHT", -10, 4),
	};

	local scrollBoxAnchorsWithoutBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Content, "TOPLEFT", 14, -4),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.Content, "BOTTOMRIGHT", -17, -4),
	};

	self.Content.ScrollView = CreateScrollBoxListGridView(GRID_STRIDE, GRID_PADDING, GRID_PADDING, GRID_PADDING, GRID_PADDING);
	self.Content.ScrollView:SetElementInitializer("TRP3_IconBrowserButtonTemplate", function(button, iconInfo) self:OnIconButtonInitialized(button, iconInfo); end);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.Content.ScrollBox, self.Content.ScrollBar, self.Content.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.Content.ScrollBox, self.Content.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
	self.Content.ScrollBox:SetDataProvider(CreateIconDataProvider(self.filterModel));
	self.Content.ProgressOverlay:SetModel(self.filterModel);
	self.Content.EmptyState:SetModel(self.filterModel);

	self.CloseButton:SetScript("OnClick", function() self:OnCloseButtonClicked(); end);
	self.SearchBox:HookScript("OnTextChanged", TRP3_FunctionUtil.Debounce(0.25, function() self:OnFilterTextChanged(); end));
	self.FilterDropdown:SetIsDefaultCallback(function() return not self.filterModel:IsFilteringAnyCategory(); end);
	self.FilterDropdown:SetDefaultCallback(function() self:OnFilterDropdownResetClicked(); end);
	self.FilterDropdown:SetupMenu(function(dropdown, rootDescription) self:SetupFilterDropdown(dropdown, rootDescription); end);
end

function TRP3_IconBrowserMixin:OnShow()
	self.SearchBox.Instructions:SetTextColor(0.6, 0.6, 0.6);
	self.SearchBox:SetFocus(true);
	PlaySound(TRP3_InterfaceSounds.BrowserOpen);
	self.callbacks:Fire("OnOpened");
end

function TRP3_IconBrowserMixin:OnHide()
	PlaySound(TRP3_InterfaceSounds.BrowserClose);
	self.callbacks:Fire("OnClosed");
end

function TRP3_IconBrowserMixin:OnCloseButtonClicked()
	self:Hide();
end

function TRP3_IconBrowserMixin:OnFilterTextChanged()
	self.filterModel:SetSearchQuery(self.SearchBox:GetText());
end

function TRP3_IconBrowserMixin:OnFilterDropdownResetClicked()
	self.filterModel:ClearCategoryFilters();
end

function TRP3_IconBrowserMixin:OnIconButtonInitialized(button, iconInfo)
	button:SetScript("OnClick", function() self:OnIconButtonClicked(button); end);
	button:Init(iconInfo);
end

function TRP3_IconBrowserMixin:OnIconButtonClicked(button)
	local iconInfo = button:GetElementData();
	self.callbacks:Fire("OnIconSelected", iconInfo);

	-- Selecting an icon should reset all filtering state. Canceling out of
	-- the window doesn't - this is to let people go and find an icon name
	-- from somewhere else if they want.

	self.filterModel:ClearAllFilters();
	self.SearchBox:SetText("");
	self.Content.ScrollBox:ScrollToBegin();
	PlaySound(TRP3_InterfaceSounds.PopupClose);
	self:Hide();
end

function TRP3_IconBrowserMixin:SetSelectedIcon(iconName)
	self.selectionModel:SetSelectedIcon(iconName);
end

function TRP3_IconBrowserMixin:SetupFilterDropdown(_dropdown, rootDescription)
	local function CreateCategoryCheckbox(parent, title, category)
		local function ToggleCategorySelection()
			if self.filterModel:IsFilteringCategory(category) then
				self.filterModel:RemoveCategoryFilter(category);
			else
				self.filterModel:AddCategoryFilter(category);
			end
		end

		local function IsCategorySelected()
			return self.filterModel:IsFilteringCategory(category);
		end

		if not assertsafe(category, "attempted to create checkbox for an unknown filter category") then
			return;
		end

		return parent:CreateCheckbox(title, IsCategorySelected, ToggleCategorySelection);
	end

	local function CreateClassMenu(parent)
		-- Ordered by the same nonsense Blizzard uses for all their class dropdowns (class IDs).
		local menu = parent:CreateButton(L.ICON_CATEGORY_CLASSES);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.WARRIOR:WrapTextInColorCode(L.CM_CLASS_WARRIOR), LRPM12.IconCategory.Warrior);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.PALADIN:WrapTextInColorCode(L.CM_CLASS_PALADIN), LRPM12.IconCategory.Paladin);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.HUNTER:WrapTextInColorCode(L.CM_CLASS_HUNTER), LRPM12.IconCategory.Hunter);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.ROGUE:WrapTextInColorCode(L.CM_CLASS_ROGUE), LRPM12.IconCategory.Rogue);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.PRIEST:WrapTextInColorCode(L.CM_CLASS_PRIEST), LRPM12.IconCategory.Priest);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.DEATHKNIGHT:WrapTextInColorCode(L.CM_CLASS_DEATHKNIGHT), LRPM12.IconCategory.DeathKnight);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.SHAMAN:WrapTextInColorCode(L.CM_CLASS_SHAMAN), LRPM12.IconCategory.Shaman);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.MAGE:WrapTextInColorCode(L.CM_CLASS_MAGE), LRPM12.IconCategory.Mage);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.WARLOCK:WrapTextInColorCode(L.CM_CLASS_WARLOCK), LRPM12.IconCategory.Warlock);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.MONK:WrapTextInColorCode(L.CM_CLASS_MONK), LRPM12.IconCategory.Monk);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.DRUID:WrapTextInColorCode(L.CM_CLASS_DRUID), LRPM12.IconCategory.Druid);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.DEMONHUNTER:WrapTextInColorCode(L.CM_CLASS_DEMONHUNTER), LRPM12.IconCategory.DemonHunter);
		CreateCategoryCheckbox(menu, TRP3_API.ClassColors.EVOKER:WrapTextInColorCode(L.CM_CLASS_EVOKER), LRPM12.IconCategory.Evoker);
		return menu;
	end

	local function CreateAllianceRaceMenu(parent)
		-- Ordered by appearance on character creation.
		parent:CreateTitle(L.ICON_CATEGORY_ALLIANCE);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_HUMAN, LRPM12.IconCategory.Human);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_DWARF, LRPM12.IconCategory.Dwarf);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_NIGHT_ELF, LRPM12.IconCategory.NightElf);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_GNOME, LRPM12.IconCategory.Gnome);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_DRAENEI, LRPM12.IconCategory.Draenei);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_WORGEN, LRPM12.IconCategory.Worgen);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_VOID_ELF, LRPM12.IconCategory.VoidElf);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_LIGHTFORGED_DRAENEI, LRPM12.IconCategory.LightforgedDraenei);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_DARK_IRON_DWARF, LRPM12.IconCategory.DarkIronDwarf);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_KUL_TIRAN, LRPM12.IconCategory.KulTiran);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_MECHAGNOME, LRPM12.IconCategory.Mechagnome);
	end

	local function CreateHordeRaceMenu(parent)
		-- Ordered by appearance on character creation.
		parent:CreateTitle(L.ICON_CATEGORY_HORDE);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_ORC, LRPM12.IconCategory.Orc);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_UNDEAD, LRPM12.IconCategory.Undead);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_TAUREN, LRPM12.IconCategory.Tauren);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_TROLL, LRPM12.IconCategory.Troll);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_BLOOD_ELF, LRPM12.IconCategory.BloodElf);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_GOBLIN, LRPM12.IconCategory.Goblin);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_NIGHTBORNE, LRPM12.IconCategory.Nightborne);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_HIGHMOUNTAIN_TAUREN, LRPM12.IconCategory.HighmountainTauren);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_MAGHAR_ORC, LRPM12.IconCategory.MagharOrc);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_ZANDALARI_TROLL, LRPM12.IconCategory.ZandalariTroll);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_VULPERA, LRPM12.IconCategory.Vulpera);
	end

	local function CreateNeutralRaceMenu(parent)
		-- Ordered by vibe.
		parent:CreateTitle(L.ICON_CATEGORY_NEUTRAL);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_PANDAREN, LRPM12.IconCategory.Pandaren);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_DRACTHYR, LRPM12.IconCategory.Dracthyr);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_EARTHEN, LRPM12.IconCategory.Earthen);
		CreateCategoryCheckbox(parent, L.ICON_CATEGORY_HARANIR, LRPM12.IconCategory.Haranir);
	end

	local function CreateRaceMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_RACES);
		local faction = UnitFactionGroup("player");

		if faction == "Alliance" then
			CreateAllianceRaceMenu(menu);
			CreateNeutralRaceMenu(menu);
			CreateHordeRaceMenu(menu);
		elseif faction == "Horde" then
			CreateHordeRaceMenu(menu);
			CreateNeutralRaceMenu(menu);
			CreateAllianceRaceMenu(menu);
		else
			CreateNeutralRaceMenu(menu);
			CreateAllianceRaceMenu(menu);
			CreateHordeRaceMenu(menu);
		end

		return menu;
	end

	local function CreateWeaponMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_WEAPONS);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALL_WEAPONS, LRPM12.IconCategory.Weapon);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_MELEE_WEAPONS, LRPM12.IconCategory.MeleeWeapon);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_RANGED_WEAPONS, LRPM12.IconCategory.RangedWeapon);
		menu:CreateDivider();
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_AMMO, LRPM12.IconCategory.Ammo);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_AXE, LRPM12.IconCategory.Axe);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_BOW, LRPM12.IconCategory.Bow);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_CROSSBOW, LRPM12.IconCategory.Crossbow);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_DAGGER, LRPM12.IconCategory.Dagger);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FIST_WEAPON, LRPM12.IconCategory.FistWeapon);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_GUN, LRPM12.IconCategory.Gun);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_MACE, LRPM12.IconCategory.Mace);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_POLEARM, LRPM12.IconCategory.Polearm);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_STAFF, LRPM12.IconCategory.Staff);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_SWORD, LRPM12.IconCategory.Sword);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_THROWN, LRPM12.IconCategory.Thrown);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_WAND, LRPM12.IconCategory.Wand);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_WARGLAIVE, LRPM12.IconCategory.Warglaive);
		return menu;
	end

	local function CreateArmorMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_ARMOR);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALL_ARMOR, LRPM12.IconCategory.Armor);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_CLOTH_ARMOR, LRPM12.IconCategory.ClothArmor);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_LEATHER_ARMOR, LRPM12.IconCategory.LeatherArmor);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_MAIL_ARMOR, LRPM12.IconCategory.MailArmor);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_PLATE_ARMOR, LRPM12.IconCategory.PlateArmor);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_JEWELRY, LRPM12.IconCategory.Jewelry);
		menu:CreateDivider();
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_BACK, LRPM12.IconCategory.Back);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_CHEST, LRPM12.IconCategory.Chest);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FEET, LRPM12.IconCategory.Feet);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_HANDS, LRPM12.IconCategory.Hands);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_HEAD, LRPM12.IconCategory.Head);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_LEGS, LRPM12.IconCategory.Legs);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_NECKLACE, LRPM12.IconCategory.Necklace);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_OFF_HAND, LRPM12.IconCategory.OffHand);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_RING, LRPM12.IconCategory.Ring);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_SHIELD, LRPM12.IconCategory.Shield);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_SHIRT, LRPM12.IconCategory.Shirt);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_SHOULDER, LRPM12.IconCategory.Shoulder);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_TABARD, LRPM12.IconCategory.Tabard);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_TRINKET, LRPM12.IconCategory.Trinket);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_WAIST, LRPM12.IconCategory.Waist);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_WRIST, LRPM12.IconCategory.Wrist);
		return menu;
	end

	local function CreateMagicMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_MAGIC_SCHOOLS);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ARCANE, LRPM12.IconCategory.Arcane);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FEL, LRPM12.IconCategory.Fel);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FIRE, LRPM12.IconCategory.Fire);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FROST, LRPM12.IconCategory.Frost);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_HOLY, LRPM12.IconCategory.Holy);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_NATURE, LRPM12.IconCategory.Nature);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_SHADOW, LRPM12.IconCategory.Shadow);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_VOID, LRPM12.IconCategory.Void);
		return menu;
	end

	local function CreateFactionMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_FACTIONS);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALL_FACTIONS, LRPM12.IconCategory.Faction);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALLIANCE, LRPM12.IconCategory.Alliance);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_HORDE, LRPM12.IconCategory.Horde);
		return menu;
	end

	local function CreateProfessionMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_PROFESSIONS);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALL_PROFESSIONS, LRPM12.IconCategory.Professions);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALCHEMY, LRPM12.IconCategory.Alchemy);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ARCHAEOLOGY, LRPM12.IconCategory.Archaeology);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_BLACKSMITHING, LRPM12.IconCategory.Blacksmithing);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_COOKING, LRPM12.IconCategory.Cooking);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ENCHANTING, LRPM12.IconCategory.Enchanting);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ENGINEERING, LRPM12.IconCategory.Engineering);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FIRST_AID, LRPM12.IconCategory.FirstAid);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FISHING, LRPM12.IconCategory.Fishing);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_HERBALISM, LRPM12.IconCategory.Herbalism);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_INSCRIPTION, LRPM12.IconCategory.Inscription);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_JEWELCRAFTING, LRPM12.IconCategory.Jewelcrafting);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_LEATHERWORKING, LRPM12.IconCategory.Leatherworking);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_MINING, LRPM12.IconCategory.Mining);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_SKINNING, LRPM12.IconCategory.Skinning);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_TAILORING, LRPM12.IconCategory.Tailoring);
		return menu;
	end

	local function CreateItemMenu(parent)
		local menu = parent:CreateButton(L.ICON_CATEGORY_ITEMS);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_ALL_ITEMS, LRPM12.IconCategory.Item);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_DRINK, LRPM12.IconCategory.Drink);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_FOOD, LRPM12.IconCategory.Food);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_MOUNT, LRPM12.IconCategory.Mount);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_PET, LRPM12.IconCategory.Pet);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_POTION, LRPM12.IconCategory.Potion);
		CreateCategoryCheckbox(menu, L.ICON_CATEGORY_TRADE_GOODS, LRPM12.IconCategory.TradeGoods);
		return menu;
	end

	CreateCategoryCheckbox(rootDescription, L.ICON_CATEGORY_SPELLS_AND_ABILITIES, LRPM12.IconCategory.Ability);
	CreateCategoryCheckbox(rootDescription, L.ICON_CATEGORY_ACHIEVEMENTS, LRPM12.IconCategory.Achievement);
	CreateCategoryCheckbox(rootDescription, L.ICON_CATEGORY_HOUSING, LRPM12.IconCategory.Housing);
	rootDescription:CreateDivider();

	CreateClassMenu(rootDescription);
	CreateRaceMenu(rootDescription);
	CreateWeaponMenu(rootDescription);
	CreateArmorMenu(rootDescription);
	CreateMagicMenu(rootDescription);
	CreateFactionMenu(rootDescription);
	CreateProfessionMenu(rootDescription);
	CreateItemMenu(rootDescription);
end

TRP3_IconBrowserButtonMixin = {};

function TRP3_IconBrowserButtonMixin:OnLoad()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TRP3_IconBrowserButtonMixin:OnEnter()
	local iconInfo = self:GetElementData();

	if not iconInfo then
		return;
	end

	local iconSizeSource = 64;
	local iconSizeScaled = 64;
	local titleLineIcon = CreateTextureMarkup(iconInfo.file, iconSizeSource, iconSizeSource, iconSizeScaled, iconSizeScaled, 0, 1, 0, 1);
	local titleLineText = string.join(" ", titleLineIcon, iconInfo.name);

	TRP3_MainTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_SetTitle(TRP3_MainTooltip, titleLineText, GREEN_FONT_COLOR, false);
	TRP3_MainTooltip:Show();
end

function TRP3_IconBrowserButtonMixin:OnLeave()
	TRP3_MainTooltip:Hide();
end

---@param iconInfo TRP3.IconBrowserModelItem
function TRP3_IconBrowserButtonMixin:Init(iconInfo)
	self.SelectedTexture:SetShown(iconInfo and iconInfo.selected);
	self.Icon:SetTexture(iconInfo and iconInfo.file or [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]]);
end

TRP3_IconBrowserEmptyStateMixin = {};

---@param model TRP3.IconBrowserFilterModel
function TRP3_IconBrowserEmptyStateMixin:SetModel(model)
	if self.model then
		self.model.UnregisterAllCallbacks(self);
		self.model = nil;
	end

	local function UpdateVisibility()
		local state = model:GetSearchState();
		local count = model:GetIconCount();

		if state == "finished" and count == 0 then
			self.AnimOut:Stop();

			if not self:IsShown() then
				self.AnimIn:Play();
				self:Show();
			end
		elseif self:IsShown() then
			self.AnimOut:Play();
		end
	end

	local function UpdateVisibilityDeferred()
		C_Timer.After(0, UpdateVisibility);
	end

	self.model = model;
	self.model.RegisterCallback(self, "OnSearchStateChanged", UpdateVisibilityDeferred);
	self.model.RegisterCallback(self, "OnModelUpdated", UpdateVisibilityDeferred);
end

TRP3_IconBrowserProgressOverlayMixin = {};

---@param model TRP3.IconBrowserFilterModel
function TRP3_IconBrowserProgressOverlayMixin:SetModel(model)
	if self.model then
		self.model.UnregisterAllCallbacks(self);
		self.model = nil;
	end

	local function UpdateVisibility()
		local state = model:GetSearchState();

		if state == "running" then
			self.AnimOut:Stop();

			if not self:IsShown() then
				local reverse = true;
				self.AnimIn:Play(reverse);
				self.ProgressBar:SetValue(0);
				self:Show();
			end
		elseif state == "finished" and self:IsShown() then
			self.AnimOut:Play();
		end
	end

	---@param progress TRP3.IconBrowserSearchProgress
	local function OnProgressChanged(_, progress)
		self.ProgressBar:SetSmoothedValue(progress.searched / progress.total);
	end

	local function UpdateVisibilityDeferred()
		C_Timer.After(0, UpdateVisibility);
	end

	self.model = model;
	self.model.RegisterCallback(self, "OnSearchProgressChanged", OnProgressChanged);
	self.model.RegisterCallback(self, "OnSearchStateChanged", UpdateVisibilityDeferred);
end

-- Icon Browser API
------------------------------------------------------------------------------

TRP3_IconBrowser = {};

---@class TRP3.IconBrowserOpenOptions
---@field onAcceptCallback fun(iconInfo: TRP3.IconBrowserModelItem)?
---@field onCancelCallback fun()?
---@field selectedIcon string?
---@field scale number?

function TRP3_IconBrowser.Close()
	TRP3_IconBrowserFrame:Hide();
end

---@param options TRP3.IconBrowserOpenOptions?
function TRP3_IconBrowser.Open(options)
	options = options or {};
	local owner = {};

	local function OnClosed()
		TRP3_IconBrowserFrame.UnregisterAllCallbacks(owner);

		if options.onCancelCallback then
			options.onCancelCallback();
		end
	end

	local function OnIconSelected(_, iconInfo)
		TRP3_IconBrowserFrame.UnregisterAllCallbacks(owner);

		if options.onAcceptCallback then
			options.onAcceptCallback(iconInfo);
		end
	end

	TRP3_IconBrowserFrame.RegisterCallback(owner, "OnClosed", OnClosed);
	TRP3_IconBrowserFrame.RegisterCallback(owner, "OnIconSelected", OnIconSelected);
	TRP3_IconBrowserFrame:SetScale(tonumber(options.scale) or 1);
	TRP3_IconBrowserFrame:SetSelectedIcon(options.selectedIcon);
	TRP3_IconBrowserFrame:Show();
end

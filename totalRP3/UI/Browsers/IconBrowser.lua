-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

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

---@alias TRP3.IconModelItemIterator fun(): (integer, TRP3.IconBrowserModelItem)?
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
	return self.source:EnumerateIcons(options);
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

	---@param iconIndex integer
	---@param iconInfo TRP3.IconBrowserModelItem
	local function DoesIconMatchFilters(iconIndex, iconInfo)
		local iconName = TRP3_StringUtil.GenerateSearchableString(iconInfo.name);
		local offset = 1;
		local plain = true;

		if not string.find(iconName, query, offset, plain) then
			return false;
		end

		if categoryPredicate ~= nil and not categoryPredicate(iconIndex) then
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
	return self.source:EnumerateIcons(options);
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

	local function ApplyCategoryFilter(category)
		if self.filterModel:IsFilteringCategory(category) then
			self.filterModel:RemoveCategoryFilter(category);
		else
			self.filterModel:AddCategoryFilter(category);
		end
	end

	local function IsCategoryFiltered(tag)
		return self.filterModel:IsFilteringCategory(tag);
	end

	self.FilterDropdown:SetIsDefaultCallback(function()
		return not self.filterModel:IsFilteringAnyCategory();
	end);

	self.FilterDropdown:SetDefaultCallback(function()
		self.filterModel:ClearCategoryFilters();
	end);

	self.FilterDropdown:SetupMenu(function(dropdown, rootDescription)
		local function CreateCategoryCheckbox(parent, title, category)
			return parent:CreateCheckbox(title, function() return IsCategoryFiltered(category); end, function() ApplyCategoryFilter(category); end);
		end

		local function AddCategoryRadio(parent, title, category)
			return parent:CreateRadio(title, function() return IsCategoryFiltered(category); end, function() ApplyCategoryFilter(category); end);
		end

		local classes = rootDescription:CreateButton("Classes");
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.WARRIOR:WrapTextInColorCode("Warrior"), LRPM12.IconCategory.Warrior);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.PALADIN:WrapTextInColorCode("Paladin"), LRPM12.IconCategory.Paladin);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.HUNTER:WrapTextInColorCode("Hunter"), LRPM12.IconCategory.Hunter);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.ROGUE:WrapTextInColorCode("Rogue"), LRPM12.IconCategory.Rogue);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.PRIEST:WrapTextInColorCode("Priest"), LRPM12.IconCategory.Priest);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.DEATHKNIGHT:WrapTextInColorCode("DeathKnight"), LRPM12.IconCategory.DeathKnight);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.SHAMAN:WrapTextInColorCode("Shaman"), LRPM12.IconCategory.Shaman);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.MAGE:WrapTextInColorCode("Mage"), LRPM12.IconCategory.Mage);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.WARLOCK:WrapTextInColorCode("Warlock"), LRPM12.IconCategory.Warlock);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.MONK:WrapTextInColorCode("Monk"), LRPM12.IconCategory.Monk);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.DRUID:WrapTextInColorCode("Druid"), LRPM12.IconCategory.Druid);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.DEMONHUNTER:WrapTextInColorCode("DemonHunter"), LRPM12.IconCategory.DemonHunter);
		CreateCategoryCheckbox(classes, TRP3_API.ClassColors.EVOKER:WrapTextInColorCode("Evoker"), LRPM12.IconCategory.Evoker);

		local races = rootDescription:CreateButton("Races");
		races:CreateTitle("Alliance");
		CreateCategoryCheckbox(races, "Human", LRPM12.IconCategory.Human);
		CreateCategoryCheckbox(races, "Dwarf", LRPM12.IconCategory.Dwarf);
		CreateCategoryCheckbox(races, "NightElf", LRPM12.IconCategory.NightElf);
		CreateCategoryCheckbox(races, "Gnome", LRPM12.IconCategory.Gnome);
		CreateCategoryCheckbox(races, "Draenei", LRPM12.IconCategory.Draenei);
		CreateCategoryCheckbox(races, "Worgen", LRPM12.IconCategory.Worgen);
		CreateCategoryCheckbox(races, "VoidElf", LRPM12.IconCategory.VoidElf);
		CreateCategoryCheckbox(races, "DarkIronDwarf", LRPM12.IconCategory.DarkIronDwarf);
		CreateCategoryCheckbox(races, "LightforgedDraenei", LRPM12.IconCategory.LightforgedDraenei);
		CreateCategoryCheckbox(races, "KulTiran", LRPM12.IconCategory.KulTiran);
		CreateCategoryCheckbox(races, "Mechagnome", LRPM12.IconCategory.Mechagnome);

		races:CreateTitle("Horde");
		CreateCategoryCheckbox(races, "Horde", LRPM12.IconCategory.Horde);
		CreateCategoryCheckbox(races, "Orc", LRPM12.IconCategory.Orc);
		CreateCategoryCheckbox(races, "Undead", LRPM12.IconCategory.Undead);
		CreateCategoryCheckbox(races, "Tauren", LRPM12.IconCategory.Tauren);
		CreateCategoryCheckbox(races, "Troll", LRPM12.IconCategory.Troll);
		CreateCategoryCheckbox(races, "BloodElf", LRPM12.IconCategory.BloodElf);
		CreateCategoryCheckbox(races, "Goblin", LRPM12.IconCategory.Goblin);
		CreateCategoryCheckbox(races, "MagharOrc", LRPM12.IconCategory.MagharOrc);
		CreateCategoryCheckbox(races, "Nightborne", LRPM12.IconCategory.Nightborne);
		CreateCategoryCheckbox(races, "HighmountainTauren", LRPM12.IconCategory.HighmountainTauren);
		CreateCategoryCheckbox(races, "ZandalariTroll", LRPM12.IconCategory.ZandalariTroll);
		CreateCategoryCheckbox(races, "Vulpera", LRPM12.IconCategory.Vulpera);

		races:CreateTitle("Neutral");
		CreateCategoryCheckbox(races, "Pandaren", LRPM12.IconCategory.Pandaren);
		CreateCategoryCheckbox(races, "Dracthyr", LRPM12.IconCategory.Dracthyr);
		CreateCategoryCheckbox(races, "Earthen", LRPM12.IconCategory.Earthen);
		CreateCategoryCheckbox(races, "Haranir", LRPM12.IconCategory.Haranir);

		local weapons = rootDescription:CreateButton("Weapons");
		CreateCategoryCheckbox(weapons, "All Weapons", LRPM12.IconCategory.Weapon);
		CreateCategoryCheckbox(weapons, "Melee Weapons", LRPM12.IconCategory.MeleeWeapon);
		CreateCategoryCheckbox(weapons, "Ranged Weapons", LRPM12.IconCategory.RangedWeapon);
		weapons:CreateDivider();
		CreateCategoryCheckbox(weapons, "Axe", LRPM12.IconCategory.Axe);
		CreateCategoryCheckbox(weapons, "Dagger", LRPM12.IconCategory.Dagger);
		CreateCategoryCheckbox(weapons, "Mace", LRPM12.IconCategory.Mace);
		CreateCategoryCheckbox(weapons, "Polearm", LRPM12.IconCategory.Polearm);
		CreateCategoryCheckbox(weapons, "Staff", LRPM12.IconCategory.Staff);
		CreateCategoryCheckbox(weapons, "Sword", LRPM12.IconCategory.Sword);
		CreateCategoryCheckbox(weapons, "FistWeapon", LRPM12.IconCategory.FistWeapon);
		CreateCategoryCheckbox(weapons, "Warglaive", LRPM12.IconCategory.Warglaive);
		CreateCategoryCheckbox(weapons, "Ammo", LRPM12.IconCategory.Ammo);
		CreateCategoryCheckbox(weapons, "Bow", LRPM12.IconCategory.Bow);
		CreateCategoryCheckbox(weapons, "Crossbow", LRPM12.IconCategory.Crossbow);
		CreateCategoryCheckbox(weapons, "Gun", LRPM12.IconCategory.Gun);
		CreateCategoryCheckbox(weapons, "Thrown", LRPM12.IconCategory.Thrown);
		CreateCategoryCheckbox(weapons, "Wand", LRPM12.IconCategory.Wand);
		CreateCategoryCheckbox(weapons, "OffHand", LRPM12.IconCategory.OffHand);
		CreateCategoryCheckbox(weapons, "Shield", LRPM12.IconCategory.Shield);

		local armor = rootDescription:CreateButton("Armor");
		CreateCategoryCheckbox(armor, "All Armor", LRPM12.IconCategory.Armor);
		CreateCategoryCheckbox(armor, "Cloth Armor", LRPM12.IconCategory.ClothArmor);
		CreateCategoryCheckbox(armor, "Leather Armor", LRPM12.IconCategory.LeatherArmor);
		CreateCategoryCheckbox(armor, "Mail Armor", LRPM12.IconCategory.MailArmor);
		CreateCategoryCheckbox(armor, "Plate Armor", LRPM12.IconCategory.PlateArmor);
		armor:CreateDivider();
		CreateCategoryCheckbox(armor, "Back", LRPM12.IconCategory.Back);
		CreateCategoryCheckbox(armor, "Chest", LRPM12.IconCategory.Chest);
		CreateCategoryCheckbox(armor, "Feet", LRPM12.IconCategory.Feet);
		CreateCategoryCheckbox(armor, "Hands", LRPM12.IconCategory.Hands);
		CreateCategoryCheckbox(armor, "Head", LRPM12.IconCategory.Head);
		CreateCategoryCheckbox(armor, "Legs", LRPM12.IconCategory.Legs);
		CreateCategoryCheckbox(armor, "Shirt", LRPM12.IconCategory.Shirt);
		CreateCategoryCheckbox(armor, "Shoulder", LRPM12.IconCategory.Shoulder);
		CreateCategoryCheckbox(armor, "Tabard", LRPM12.IconCategory.Tabard);
		CreateCategoryCheckbox(armor, "Waist", LRPM12.IconCategory.Waist);
		CreateCategoryCheckbox(armor, "Wrist", LRPM12.IconCategory.Wrist);
		CreateCategoryCheckbox(armor, "Jewelry", LRPM12.IconCategory.Jewelry);
		CreateCategoryCheckbox(armor, "Necklace", LRPM12.IconCategory.Necklace);
		CreateCategoryCheckbox(armor, "Ring", LRPM12.IconCategory.Ring);
		CreateCategoryCheckbox(armor, "Trinket", LRPM12.IconCategory.Trinket);

		local magic = rootDescription:CreateButton("Magic Schools");
		CreateCategoryCheckbox(magic, "Arcane", LRPM12.IconCategory.Arcane);
		CreateCategoryCheckbox(magic, "Fire", LRPM12.IconCategory.Fire);
		CreateCategoryCheckbox(magic, "Frost", LRPM12.IconCategory.Frost);
		CreateCategoryCheckbox(magic, "Holy", LRPM12.IconCategory.Holy);
		CreateCategoryCheckbox(magic, "Nature", LRPM12.IconCategory.Nature);
		CreateCategoryCheckbox(magic, "Shadow", LRPM12.IconCategory.Shadow);
		CreateCategoryCheckbox(magic, "Fel", LRPM12.IconCategory.Fel);
		CreateCategoryCheckbox(magic, "Void", LRPM12.IconCategory.Void);

		local factions = rootDescription:CreateButton("Factions");
		CreateCategoryCheckbox(factions, "All Factions", LRPM12.IconCategory.Faction);
		CreateCategoryCheckbox(factions, "Alliance", LRPM12.IconCategory.Alliance);
		CreateCategoryCheckbox(factions, "Horde", LRPM12.IconCategory.Horde);

		local professions = rootDescription:CreateButton("Professions");
		CreateCategoryCheckbox(professions, "All Professions", LRPM12.IconCategory.Professions);
		CreateCategoryCheckbox(professions, "Alchemy", LRPM12.IconCategory.Alchemy);
		CreateCategoryCheckbox(professions, "Archaeology", LRPM12.IconCategory.Archaeology);
		CreateCategoryCheckbox(professions, "Blacksmithing", LRPM12.IconCategory.Blacksmithing);
		CreateCategoryCheckbox(professions, "Cooking", LRPM12.IconCategory.Cooking);
		CreateCategoryCheckbox(professions, "Enchanting", LRPM12.IconCategory.Enchanting);
		CreateCategoryCheckbox(professions, "Engineering", LRPM12.IconCategory.Engineering);
		CreateCategoryCheckbox(professions, "FirstAid", LRPM12.IconCategory.FirstAid);
		CreateCategoryCheckbox(professions, "Herbalism", LRPM12.IconCategory.Herbalism);
		CreateCategoryCheckbox(professions, "Inscription", LRPM12.IconCategory.Inscription);
		CreateCategoryCheckbox(professions, "Jewelcrafting", LRPM12.IconCategory.Jewelcrafting);
		CreateCategoryCheckbox(professions, "Leatherworking", LRPM12.IconCategory.Leatherworking);
		CreateCategoryCheckbox(professions, "Mining", LRPM12.IconCategory.Mining);
		CreateCategoryCheckbox(professions, "Skinning", LRPM12.IconCategory.Skinning);
		CreateCategoryCheckbox(professions, "Tailoring", LRPM12.IconCategory.Tailoring);
		CreateCategoryCheckbox(professions, "Fishing", LRPM12.IconCategory.Fishing);

		local items = rootDescription:CreateButton("Items");
		CreateCategoryCheckbox(items, "All Items", LRPM12.IconCategory.Item);
		CreateCategoryCheckbox(items, "Mount", LRPM12.IconCategory.Mount);
		CreateCategoryCheckbox(items, "Pet", LRPM12.IconCategory.Pet);
		CreateCategoryCheckbox(items, "TradeGoods", LRPM12.IconCategory.TradeGoods);
		CreateCategoryCheckbox(items, "Potion", LRPM12.IconCategory.Potion);
		CreateCategoryCheckbox(items, "Food", LRPM12.IconCategory.Food);
		CreateCategoryCheckbox(items, "Drink", LRPM12.IconCategory.Drink);

		rootDescription:CreateDivider();
		CreateCategoryCheckbox(rootDescription, "Spells and Abilities", LRPM12.IconCategory.Ability);
		CreateCategoryCheckbox(rootDescription, "Achievements", LRPM12.IconCategory.Achievement);
		CreateCategoryCheckbox(rootDescription, "Housing", LRPM12.IconCategory.Housing);
	end);
end

function TRP3_IconBrowserMixin:OnShow()
	self.filterModel:ClearSearchQuery();
	self.SearchBox.Instructions:SetTextColor(0.6, 0.6, 0.6);
	self.SearchBox:SetText("");
	self.SearchBox:SetFocus(true);
	self.Content.ScrollBox:ScrollToBegin();
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

function TRP3_IconBrowserMixin:OnIconButtonInitialized(button, iconInfo)
	button:SetScript("OnClick", function() self:OnIconButtonClicked(button); end);
	button:Init(iconInfo);
end

function TRP3_IconBrowserMixin:OnIconButtonClicked(button)
	local iconInfo = button:GetElementData();
	self.callbacks:Fire("OnIconSelected", iconInfo);
	PlaySound(TRP3_InterfaceSounds.PopupClose);
	self:Hide();
end

function TRP3_IconBrowserMixin:SetSelectedIcon(iconName)
	self.selectionModel:SetSelectedIcon(iconName);
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

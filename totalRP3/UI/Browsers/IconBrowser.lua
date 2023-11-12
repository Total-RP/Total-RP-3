-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

local LibRPMedia = LibStub:GetLibrary("LibRPMedia-1.0");

local function GenerateSearchableString(str)
	return string.utf8lower(string.trim((string.gsub(str, "%p+", " "))));
end

--- Table structure providing data about a single icon sourced from a model.
---
---@class TRP3.IconBrowserModelItem
---@field index integer
---@field key integer
---@field name string
---@field type "atlas" | "file"
---@field file TRP3.FileID?
---@field atlas TRP3.AtlasElementID?
---@field selected boolean?

--- IconBrowserModel is a basic model that sources icons from LibRPMedia.
---
---@class TRP3.IconBrowserModel
---@field private callbacks TRP3.CallbackDispatcher
local IconBrowserModel = {};

---@protected
function IconBrowserModel:__init()
	self.callbacks = TRP3_API.InitCallbackRegistryWithEvents(self, { "OnModelUpdated" });
end

---@return integer count
function IconBrowserModel:GetIconCount()
	return LibRPMedia:GetNumIcons();
end

---@param index integer
---@return TRP3.IconBrowserModelItem? data
function IconBrowserModel:GetIconInfo(index)
	return LibRPMedia:GetIconDataByIndex(index);
end

---@param index integer
---@return string? name
function IconBrowserModel:GetIconName(index)
	return LibRPMedia:GetIconDataByIndex(index, "name");
end

local function CreateIconBrowserModel()
	return TRP3_API.CreateAndInitFromPrototype(IconBrowserModel);
end

--- Table structure providing information about the progress of an
--- asynchronous search task against an icon model.
---
---@class TRP3.IconBrowserSearchProgress
---@field found integer
---@field searched integer
---@field total integer

--- IconBrowserSearchTask is a single-shot object that performs an
--- asynchronous name-based search against a model to provide a filtered
--- list of icon indices.
---
---@class TRP3.IconBrowserFilterTask
---@field private callbacks TRP3.CallbackDispatcher
---@field private state "pending" | "running" | "finished"
---@field private ticker unknown
---@field private model TRP3.IconBrowserModel
---@field private query string
---@field private found integer
---@field private searched integer
---@field private total integer
---@field private step integer
---@field private results integer[]
local IconBrowserSearchTask = {};

---@param query string
---@param model TRP3.IconBrowserModel
---@protected
function IconBrowserSearchTask:__init(query, model)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.state = "pending";
	self.ticker = nil;
	self.model = model;
	self.query = query;
	self.found = 0;
	self.searched = 0;
	self.total = model:GetIconCount();
	self.step = 500;
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

function IconBrowserSearchTask:GetQuery()
	return self.query;
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
	local query = self.query;
	local model = self.model;
	local found = self.found;
	local results = self.results;

	local i = self.searched + 1;
	local j = math.min(self.searched + self.step, self.total);

	for iconIndex = i, j do
		local iconName = GenerateSearchableString(model:GetIconName(iconIndex));
		local offset = 1;
		local plain = true;

		if iconName and string.find(iconName, query, offset, plain) then
			found = found + 1;
			results[found] = iconIndex;
		end
	end

	if i == 1 or self.found ~= found then
		self.found = found;
		self.callbacks:Fire("OnResultsChanged", self.results);
	end

	self.searched = j;
	self.callbacks:Fire("OnProgressChanged", self:GetProgress());

	if self.searched >= self.total then
		self:Finish();
	end
end

---@param query string
---@param model TRP3.IconBrowserModel
local function CreateIconBrowserSearchTask(query, model)
	return TRP3_API.CreateAndInitFromPrototype(IconBrowserSearchTask, query, model);
end

--- IconBrowserFilterModel is a proxy model that implements asynchronous
--- filtering via name-based search queries.
---
---@class TRP3.IconBrowserFilterModel : TRP3.IconBrowserModel
---@field private callbacks TRP3.CallbackDispatcher
---@field private source TRP3.IconBrowserModel
---@field private sourceIndices integer[]
---@field private searchQuery string
---@field private searchTask TRP3.IconBrowserFilterTask?
---@field private searchProgress TRP3.IconBrowserSearchProgress
local IconBrowserFilterModel = {};

---@param source TRP3.IconBrowserModel
---@protected
function IconBrowserFilterModel:__init(source)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.source = source;
	self.sourceIndices = {};
	self.searchQuery = "";
	self.searchTask = nil;

	self.source.RegisterCallback(self, "OnModelUpdated", "OnSourceModelUpdated");
end

function IconBrowserFilterModel:GetIconCount()
	local count;

	if self:HasSearchQuery() then
		count = #self.sourceIndices;
	else
		count = self.source:GetIconCount();
	end

	return count;
end

function IconBrowserFilterModel:GetIconInfo(filterIndex)
	return self.source:GetIconInfo(self:GetSourceIndex(filterIndex));
end

function IconBrowserFilterModel:GetIconName(filterIndex)
	return self.source:GetIconName(self:GetSourceIndex(filterIndex));
end

function IconBrowserFilterModel:GetSourceModel()
	return self.source;
end

function IconBrowserFilterModel:GetSourceIndex(filterIndex)
	local sourceIndex;

	if self:HasSearchQuery() then
		sourceIndex = self.sourceIndices[filterIndex];
	else
		sourceIndex = filterIndex;
	end

	return sourceIndex;
end

function IconBrowserFilterModel:ClearSearchQuery()
	self:SetSearchQuery("");
end

function IconBrowserFilterModel:GetSearchQuery()
	return self.searchQuery;
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
	query = GenerateSearchableString(query);  ---@cast query string

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

	local query = self:GetSearchQuery();

	if query == "" then
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

	self.searchTask = CreateIconBrowserSearchTask(query, self.source);
	self.searchTask.RegisterCallback(self, "OnStateChanged", OnStateChanged);
	self.searchTask.RegisterCallback(self, "OnProgressChanged", OnProgressChanged);
	self.searchTask.RegisterCallback(self, "OnResultsChanged", OnResultsChanged);
	self.searchTask:Start();
end

---@param source TRP3.IconBrowserModel
local function CreateIconBrowserFilterModel(source)
	return TRP3_API.CreateAndInitFromPrototype(IconBrowserFilterModel, source);
end

--- IconBrowserSelectionModel is a proxy model that relocates the currently
--- selected icon to the start of the model.
---@class TRP3.IconBrowserSelectionModel : TRP3.IconBrowserModel
---@field private callbacks TRP3.CallbackDispatcher
---@field private source TRP3.IconBrowserModel
---@field private selectedIndex integer?
local IconBrowserSelectionModel = {};

---@protected
function IconBrowserSelectionModel:__init(source)
	self.callbacks = TRP3_API.InitCallbackRegistryWithEvents(self, { "OnModelUpdated" });
	self.source = source;
	self.selectedIndex = nil;
end

---@param index integer
---@return TRP3.IconBrowserModelItem? data
function IconBrowserSelectionModel:GetIconInfo(index)
	local iconInfo = self.source:GetIconInfo(self:GetSourceIndex(index));

	if iconInfo and self.selectedIndex then
		iconInfo.selected = (index == 1);
	end

	return iconInfo;
end

function IconBrowserSelectionModel:GetIconCount()
	return self.source:GetIconCount();
end

---@param index integer
---@return string? name
function IconBrowserSelectionModel:GetIconName(index)
	return self.source:GetIconName(self:GetSourceIndex(index));
end

function IconBrowserSelectionModel:GetSourceModel()
	return self.source;
end

function IconBrowserSelectionModel:GetSourceIndex(filterIndex)
	local sourceIndex = filterIndex;

	if self.selectedIndex then
		if filterIndex == 1 then
			sourceIndex = self.selectedIndex;
		elseif filterIndex <= self.selectedIndex then
			sourceIndex = filterIndex - 1;
		end
	end

	return sourceIndex;
end

function IconBrowserSelectionModel:GetSelectedIndex()
	return self.selectedIndex;
end

function IconBrowserSelectionModel:SetSelectedIndex(sourceIndex)
	if self.selectedIndex ~= sourceIndex then
		self.selectedIndex = sourceIndex;
		self.callbacks:Fire("OnModelUpdated");
	end
end

---@param source TRP3.IconBrowserModel
local function CreateIconBrowserSelectionModel(source)
	return TRP3_API.CreateAndInitFromPrototype(IconBrowserSelectionModel, source);
end

--- Creates a data provider that displays the contents of an icon data model
--- within a scrollbox list view.
---
---@param model TRP3.IconBrowserModel
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

	provider:GenerateCallbackEvents({ "OnSizeChanged" });
	provider:OnLoad();

	model.RegisterCallback(provider, "OnModelUpdated", function()
		provider:TriggerEvent("OnSizeChanged");
	end);

	return provider;
end

-- Browser mixin
------------------------------------------------------------------------------

TRP3_IconBrowserMixin = {};

function TRP3_IconBrowserMixin:OnLoad()
	self.callbacks = TRP3_API.InitCallbackRegistryWithEvents(self, { "OnOpened", "OnClosed", "OnIconSelected" });
	self.baseModel = CreateIconBrowserModel();
	self.selectionModel = CreateIconBrowserSelectionModel(self.baseModel);
	self.filterModel = CreateIconBrowserFilterModel(self.selectionModel);
	self.model = self.filterModel;   -- Alias for the outermost model.
	self.model.RegisterCallback(self, "OnModelUpdated");
	self.model.RegisterCallback(self, "OnSearchStateChanged");
	self.model.RegisterCallback(self, "OnSearchProgressChanged");

	local GRID_STRIDE = 9;
	local GRID_PADDING = 4;

	self.ScrollContent.ScrollView = CreateScrollBoxListGridView(GRID_STRIDE, GRID_PADDING, GRID_PADDING, GRID_PADDING, GRID_PADDING);
	self.ScrollContent.ScrollView:SetElementInitializer("TRP3_IconBrowserButton", function(button, iconInfo) self:OnIconButtonInitialized(button, iconInfo); end);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollContent.ScrollBox, self.ScrollContent.ScrollBar, self.ScrollContent.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollContent.ScrollBox, self.ScrollContent.ScrollBar);
	self.ScrollContent.ScrollBox:SetDataProvider(CreateIconDataProvider(self.model));

	self.CloseButton:SetScript("OnClick", function() self:OnCloseButtonClicked(); end);
	self.SearchBox:HookScript("OnTextChanged", TRP3_FunctionUtil.Debounce(0.25, function() self:OnFilterTextChanged(); end));

end

function TRP3_IconBrowserMixin:OnShow()
	self.filterModel:ClearSearchQuery();
	self.Title:SetText(L.UI_ICON_BROWSER);
	self.SearchBox.Instructions:SetTextColor(0.6, 0.6, 0.6);
	self.SearchBox:SetText("");
	self.SearchBox:SetFocus(true);
	self.ScrollContent.EmptyText.Title:SetText(L.UI_FILTER_NO_RESULTS_FOUND_TITLE);
	self.ScrollContent.EmptyText.Text:SetText(L.UI_FILTER_NO_RESULTS_FOUND_TEXT);
	self.ScrollContent.ScrollBox:ScrollToBegin();
	self:Refresh();
	self.callbacks:Fire("OnOpened");
end

function TRP3_IconBrowserMixin:OnHide()
	self.callbacks:Fire("OnClosed");
end

function TRP3_IconBrowserMixin:OnSearchStateChanged()
	self:Refresh();
end

function TRP3_IconBrowserMixin:OnSearchProgressChanged()
	self:Refresh();
end

function TRP3_IconBrowserMixin:OnModelUpdated()
	self:Refresh();
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
	self:Hide();
end

function TRP3_IconBrowserMixin:Refresh()
	local progress = self.filterModel:GetSearchProgress();
	local state = self.filterModel:GetSearchState();
	local count = self.model:GetIconCount();

	self.ScrollContent.ProgressBar.Text:SetFormattedText(L.UI_ICON_BROWSER_SEARCHING, progress.searched / progress.total * 100);

	-- FIXME: Hacky hack hack
	if self.x ~= state then
		local reverse = (state == "running");
		self.ScrollContent.ProgressBar.AnimInOut:Play(reverse);
		self.ScrollContent.Thing.AnimIn:Play(not reverse);
	end
	self.x=state

	self.ScrollContent.ProgressBar:SetValue(progress.searched / progress.total);
	self.ScrollContent.EmptyText:SetShown(state == "finished" and count == 0);
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
	local iconSizeScaled = 32;
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

-- Browser API
------------------------------------------------------------------------------

TRP3_IconBrowser = {};

function TRP3_IconBrowser.Close()
	TRP3_IconBrowserFrame:Hide();
end

function TRP3_IconBrowser.Open(options)
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

	--- FIXME: Hacky hack hack
	if type(options.selectedIcon) == "string" then
		TRP3_IconBrowserFrame.selectionModel:SetSelectedIndex(LibRPMedia:GetIconIndexByName(options.selectedIcon));
	else
		TRP3_IconBrowserFrame.selectionModel:SetSelectedIndex(nil);
	end

	TRP3_IconBrowserFrame.RegisterCallback(owner, "OnClosed", OnClosed);
	TRP3_IconBrowserFrame.RegisterCallback(owner, "OnIconSelected", OnIconSelected);
	TRP3_IconBrowserFrame:SetScale(tonumber(options.scale) or 1);
	TRP3_IconBrowserFrame:Show();
end

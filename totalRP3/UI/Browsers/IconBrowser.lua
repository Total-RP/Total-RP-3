-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local _, TRP3_API = ...;
local L = TRP3_API.loc;

local LibRPMedia = LibStub:GetLibrary("LibRPMedia-1.0");

-- Callback registry
------------------------------------------------------------------------------

local IconBrowserCallbacks = TRP3_API.CreateCallbackRegistryWithEvents({
	OnBrowserClosed = true,
	OnBrowserOpened = true,
	OnBrowserIconSelected = true,
	OnSearchUpdated = true,
});

-- Search controller
------------------------------------------------------------------------------

local IconSearchState = {
	Searching = "searching",
	Finished = "finished",
	Cancelled = "cancelled",
};

local IconSearchController = {};

function IconSearchController:OnLoad()
	self.query = "";
	self.results = {};
	self.ticker = nil;
	self.progress = LibRPMedia:GetNumIcons();
	self.total = self.progress;
	self.lastResumeTime = -math.huge;
end

function IconSearchController:BeginSearch(query)
	query = string.utf8lower(string.trim(query));

	if self.query == query then
		return;
	end

	-- Cancel any existing ticker.
	if self.ticker ~= nil then
		self.ticker:Cancel();
		self.ticker = nil;
	end

	if query == "" then
		self.query = "";
		self.results = {};
		self.ticker = nil;
		self.progress = LibRPMedia:GetNumIcons();
		self.total = self.progress;
		self.lastResumeTime = -math.huge;
	else
		self.query = query;
		self.results = {};
		self.ticker = C_Timer.NewTicker(0, function() self:OnUpdate(); end);
		self.progress = 0;
		self.total = LibRPMedia:GetNumIcons();
		self.lastResumeTime = -math.huge;
	end

	IconBrowserCallbacks:TriggerEvent("OnSearchUpdated");
end

function IconSearchController:ResumeSearch()
	if not self:HasSearchState(IconSearchState.Searching) then
		return;
	end

	local MAX_ICONS_PER_TICK = 500;
	local i = self.progress + 1;
	local j = math.min(self.progress + MAX_ICONS_PER_TICK, self.total);

	for iconIndex = i, j do
		local iconName = LibRPMedia:GetIconDataByIndex(iconIndex, "name");
		local pattern = self.query;
		local offset = 1;
		local plain = true;

		if iconName and string.find(iconName, pattern, offset, plain) then
			table.insert(self.results, iconIndex);
		end
	end

	-- Update search progress; if we've reached the total number of icons
	-- then cancel and release the ticker.

	self.progress = j;
	self.lastResumeTime = GetTime();

	if self.progress == self.total and self.ticker ~= nil then
		self.ticker:Cancel();
		self.ticker = nil;
	end

	IconBrowserCallbacks:TriggerEvent("OnSearchUpdated");
end


function IconSearchController:CancelSearch()
	if not self:HasSearchState(IconSearchState.Searching) then
		return;
	end

	self.ticker:Cancel();
	self.ticker = nil;
	IconBrowserCallbacks:TriggerEvent("OnSearchUpdated");
end

function IconSearchController:OnUpdate()
	local MAX_ELAPSED_TIME = 0.1;
	local MAX_SKIPPED_TIME = 0.5;

	local elapsedTime = GetTickTime();
	local skippedTime = GetTime() - self.lastResumeTime;

	-- If the last frame was too slow then we won't resume the search on this
	-- frame to allow the client to catch up a little bit.
	--
	-- We won't duck forever though - if for whatever reason the client is
	-- persistently slow we'll eventually force resumption of the search.

	if (elapsedTime < MAX_ELAPSED_TIME) or (skippedTime >= MAX_SKIPPED_TIME) then
		self:ResumeSearch();
	end
end

function IconSearchController:GetSearchState()
	if self.progress == self.total then
		return IconSearchState.Finished;
	elseif self.ticker ~= nil then
		return IconSearchState.Searching;
	else
		return IconSearchState.Cancelled;
	end
end

function IconSearchController:GetSearchInfo()
	return {
		query = self.query,
		progress = self.progress,
		total = self.total,
		state = self:GetSearchState(),
	};
end

function IconSearchController:GetNumSearchResults()
	if self.query == "" then
		return self.total;
	else
		return #self.results;
	end
end

function IconSearchController:GetSearchResultInfo(index)
	if self.query == "" then
		return LibRPMedia:GetIconDataByIndex(index);
	else
		return LibRPMedia:GetIconDataByIndex(self.results[index]);
	end
end

function IconSearchController:HasSearchState(state)
	return self:GetSearchState() == state;
end

IconSearchController:OnLoad();

-- Browser utilities
------------------------------------------------------------------------------

TRP3_IconBrowserUtil = {};

function TRP3_IconBrowserUtil.GetNumSearchResults()
	return IconSearchController:GetNumSearchResults();
end

function TRP3_IconBrowserUtil.GetSearchInfo()
	return IconSearchController:GetSearchInfo();
end

function TRP3_IconBrowserUtil.GetSearchResultInfo(index)
	return IconSearchController:GetSearchResultInfo(index);
end

function TRP3_IconBrowserUtil.BeginSearch(query)
	IconSearchController:BeginSearch(query);
end

function TRP3_IconBrowserUtil.RegisterCallback(owner, event, callback, ...)
	IconBrowserCallbacks.RegisterCallback(owner, event, callback, ...);
end

function TRP3_IconBrowserUtil.UnregisterCallback(owner, event)
	IconBrowserCallbacks.UnregisterCallback(owner, event);
end

function TRP3_IconBrowserUtil.UnregisterAllCallbacks(owner)
	IconBrowserCallbacks.UnregisterAllCallbacks(owner);
end

function TRP3_IconBrowserUtil.CloseBrowser()
	TRP3_IconBrowser:Hide();
end

function TRP3_IconBrowserUtil.OpenBrowser()
	TRP3_IconBrowser:Show();
end

-- Browser mixin
------------------------------------------------------------------------------

TRP3_IconBrowserMixin = {};

function TRP3_IconBrowserMixin:OnLoad()
	local GRID_STRIDE = 8;
	local GRID_PADDING = 8;
	local GRID_SPACING_X = 6;
	local GRID_SPACING_Y = 6;

	TRP3_IconBrowserUtil.RegisterCallback(self, "OnSearchUpdated");

	self.CloseButton:SetScript("OnClick", function(_, ...) self:OnCloseButtonClicked(...); end);
	self.SearchFilterEditBox = self.Filter.EditBox;
	self.SearchFilterEditBox:SetScript("OnTextChanged", function(_, ...) self:OnFilterTextChanged(...); end);
	self.SearchFilterEditBoxTitle = self.Filter.EditBox.title;
	self.SearchFilterTotalText = self.Filter.TotalText;

	self.ScrollView = CreateScrollBoxListGridView(GRID_STRIDE, GRID_PADDING, GRID_PADDING, GRID_PADDING, GRID_PADDING, GRID_SPACING_X, GRID_SPACING_Y);
	self.ScrollView:SetElementInitializer("TRP3_IconBrowserButton", function(button) button:Refresh(); end)
	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar);
	self.DataProvider = CreateIndexRangeDataProvider(0);
	self.ScrollBox:SetDataProvider(self.DataProvider);
end

function TRP3_IconBrowserMixin:OnShow()
	self.SearchFilterEditBox:SetText("");
	self.SearchFilterEditBox:SetFocus(true);
	self:Refresh();
	IconBrowserCallbacks:TriggerEvent("OnBrowserOpened");
end

function TRP3_IconBrowserMixin:OnHide()
	IconBrowserCallbacks:TriggerEvent("OnBrowserClosed");
end

function TRP3_IconBrowserMixin:OnCloseButtonClicked()
	TRP3_IconBrowserUtil.CloseBrowser();
end

function TRP3_IconBrowserMixin:OnFilterTextChanged()
	local query = self.SearchFilterEditBox:GetText();
	TRP3_IconBrowserUtil.BeginSearch(query);
end

function TRP3_IconBrowserMixin:OnSearchUpdated()
	self:Refresh();
end

function TRP3_IconBrowserMixin:Refresh()
	local searchInfo = TRP3_IconBrowserUtil.GetSearchInfo();
	local searchResultCount = TRP3_IconBrowserUtil.GetNumSearchResults();

	self.Title:SetText(L.UI_ICON_BROWSER);
	self.SearchFilterEditBoxTitle:SetText(L.UI_FILTER);
	self.SearchFilterTotalText:SetFormattedText(GENERIC_FRACTION_STRING, searchResultCount, searchInfo.total);
	self.DataProvider:SetSize(searchResultCount);
	self.ProgressBar:Refresh();
end

TRP3_IconBrowserButtonMixin = {};

function TRP3_IconBrowserButtonMixin:OnLoad()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TRP3_IconBrowserButtonMixin:OnEnter()
	TRP3_RefreshTooltipForFrame(self);
end

function TRP3_IconBrowserButtonMixin:OnLeave()
	TRP3_MainTooltip:Hide();
end

function TRP3_IconBrowserButtonMixin:OnClick()
	local resultIndex = self:GetElementData();
	local resultInfo = TRP3_IconBrowserUtil.GetSearchResultInfo(resultIndex);

	IconBrowserCallbacks:TriggerEvent("OnBrowserIconSelected", resultInfo);
	TRP3_IconBrowserUtil.CloseBrowser();
end

function TRP3_IconBrowserButtonMixin:Refresh()
	local resultIndex = self:GetElementData();
	local resultInfo = TRP3_IconBrowserUtil.GetSearchResultInfo(resultIndex);

	self:SetNormalTexture(resultInfo.file);
	self:SetPushedTexture(resultInfo.file);
	TRP3_API.ui.tooltip.setTooltipForFrame(self, self, "RIGHT", 0, -100, TRP3_API.utils.str.icon(resultInfo.name, 75), resultInfo.name);
end

TRP3_IconBrowserProgressBarMixin = {};

function TRP3_IconBrowserProgressBarMixin:OnShow()
	self:Refresh();
end

function TRP3_IconBrowserProgressBarMixin:Refresh()
	local searchInfo = TRP3_IconBrowserUtil.GetSearchInfo();

	self.Text:SetFormattedText(L.UI_ICON_BROWSER_SEARCHING, searchInfo.progress / searchInfo.total * 100)
	self:SetShown(searchInfo.progress < searchInfo.total);
	self:SetMinMaxValues(0, searchInfo.total);
	self:SetValue(searchInfo.progress);
end

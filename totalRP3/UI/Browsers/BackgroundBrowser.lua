-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

-- Background Browser Data Models
------------------------------------------------------------------------------

local BackgroundBrowserModel = {};

function BackgroundBrowserModel:__init()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.backgrounds = {};

	for _, data in ipairs(TRP3_API.ui.frame.getTiledBackgroundList()) do
		table.insert(self.backgrounds, { id = data[1], name = data[2], file = data[2] });
	end
end

function BackgroundBrowserModel:GetImageCount()
	return #self.backgrounds;
end

function BackgroundBrowserModel:GetImageInfo(index)
	return CopyTable(self.backgrounds[index]);
end

function BackgroundBrowserModel:GetImageName(index)
	local background = self.backgrounds[index];
	return background and background.name or nil;
end

function BackgroundBrowserModel:GetImageIndex(name)
	if not name or name == "" then
		return nil;
	end

	for index, background in ipairs(self.backgrounds) do
		if background.name == name then
			return index;
		end
	end

	return nil;
end

local function CreateBackgroundBrowserModel()
	return TRP3_API.CreateObject(BackgroundBrowserModel);
end

local BackgroundBrowserFilterModel = {};

function BackgroundBrowserFilterModel:__init(source)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.source = source;
	self.sourceIndices = {};
	self.searchQuery = "";

	self.source.RegisterCallback(self, "OnModelUpdated", "OnSourceModelUpdated");
end

function BackgroundBrowserFilterModel:GetImageCount()
	local count;

	if self:HasSearchQuery() then
		count = #self.sourceIndices;
	else
		count = self.source:GetImageCount();
	end

	return count;
end

function BackgroundBrowserFilterModel:GetImageInfo(proxyIndex)
	return self.source:GetImageInfo(self:GetSourceIndex(proxyIndex));
end

function BackgroundBrowserFilterModel:GetImageName(proxyIndex)
	return self.source:GetImageName(self:GetSourceIndex(proxyIndex));
end

function BackgroundBrowserFilterModel:GetSourceModel()
	return self.source;
end

function BackgroundBrowserFilterModel:GetSourceIndex(proxyIndex)
	local sourceIndex;

	if self:HasSearchQuery() then
		sourceIndex = self.sourceIndices[proxyIndex];
	else
		sourceIndex = proxyIndex;
	end

	return sourceIndex;
end

function BackgroundBrowserFilterModel:GetProxyIndex(sourceIndex)
	local proxyIndex;

	if self:HasSearchQuery() then
		-- Inefficient but quick implementation; assuming this is never going
		-- to be called and just providing it to satisfy the interface.
		proxyIndex = tInvert(self.sourceIndices)[sourceIndex];
	else
		proxyIndex = sourceIndex;
	end

	return proxyIndex;
end

function BackgroundBrowserFilterModel:ClearSearchQuery()
	self:SetSearchQuery("");
end

function BackgroundBrowserFilterModel:GetSearchQuery()
	return self.searchQuery;
end

function BackgroundBrowserFilterModel:HasSearchQuery()
	return self.searchQuery ~= "";
end

function BackgroundBrowserFilterModel:SetSearchQuery(query)
	query = TRP3_StringUtil.GenerateSearchableString(query);

	if self.searchQuery ~= query then
		self.searchQuery = query;
		self:RebuildModel();
	end
end

function BackgroundBrowserFilterModel:OnSourceModelUpdated()
	self:RebuildModel();
end

function BackgroundBrowserFilterModel:RebuildModel()
	local query = self:GetSearchQuery();

	if query == "" then
		self.callbacks:Fire("OnModelUpdated");
		return;
	end

	local found = 0;
	local results = {};

	for sourceIndex = 1, self.source:GetImageCount() do
		local backgroundName = TRP3_StringUtil.GenerateSearchableString(self.source:GetImageName(sourceIndex));
		local offset = 1;
		local plain = true;

		if backgroundName and string.find(backgroundName, query, offset, plain) then
			found = found + 1;
			results[found] = sourceIndex;
		end
	end

	self.sourceIndices = results;
	self.callbacks:Fire("OnModelUpdated");
end

local function CreateBackgroundBrowserFilterModel(source)
	return TRP3_API.CreateObject(BackgroundBrowserFilterModel, source);
end

local BackgroundBrowserSelectionModel = {};

function BackgroundBrowserSelectionModel:__init(source)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.source = source;
	self.source.RegisterCallback(self, "OnModelUpdated", "OnSourceModelUpdated");
	self.selectedImageID = nil;
	self.selectedImageSourceIndex = nil;
end

function BackgroundBrowserSelectionModel:GetImageCount()
	return self.source:GetImageCount();
end

function BackgroundBrowserSelectionModel:GetImageInfo(index)
	local sourceIndex = self:GetSourceIndex(index);
	local imageInfo = self.source:GetImageInfo(sourceIndex);

	if imageInfo then
		imageInfo.selected = (self.selectedImageSourceIndex == sourceIndex);
	end

	return imageInfo;
end

function BackgroundBrowserSelectionModel:GetImageName(index)
	return self.source:GetImageName(self:GetSourceIndex(index));
end

function BackgroundBrowserSelectionModel:GetSourceModel()
	return self.source;
end

function BackgroundBrowserSelectionModel:GetSourceIndex(proxyIndex)
	local sourceIndex = proxyIndex;

	if self.selectedImageSourceIndex then
		if proxyIndex == 1 then
			sourceIndex = self.selectedImageSourceIndex;
		elseif proxyIndex <= self.selectedImageSourceIndex then
			sourceIndex = proxyIndex - 1;
		end
	end

	return sourceIndex;
end

function BackgroundBrowserSelectionModel:GetProxyIndex(sourceIndex)
	local proxyIndex = sourceIndex;

	if self.selectedImageSourceIndex then
		if sourceIndex == self.selectedImageSourceIndex then
			proxyIndex = 1;
		elseif sourceIndex < self.selectedImageSourceIndex then
			proxyIndex = sourceIndex + 1;
		end
	end

	return proxyIndex;
end

function BackgroundBrowserSelectionModel:GetSelectedImage()
	return self.selectedImageID;
end

function BackgroundBrowserSelectionModel:SetSelectedImage(imageID)
	if self.selectedImageID ~= imageID then
		self.selectedImageID = imageID;
		self:RebuildModel();
	end
end

function BackgroundBrowserSelectionModel:OnSourceModelUpdated()
	self:RebuildModel();
end

function BackgroundBrowserSelectionModel:RebuildModel()
	local selectedImageSourceIndex = nil;

	for sourceIndex = 1, self.source:GetImageCount() do
		local imageInfo = self.source:GetImageInfo(sourceIndex);

		if imageInfo and imageInfo.id == self.selectedImageID then
			selectedImageSourceIndex = sourceIndex;
			break;
		end
	end

	self.selectedImageSourceIndex = selectedImageSourceIndex;

	if not self.selectedImageSourceIndex then
		self.selectedImageID = nil;
	end

	self.callbacks:Fire("OnModelUpdated");
end

local function CreateBackgroundBrowserSelectionModel(source)
	return TRP3_API.CreateObject(BackgroundBrowserSelectionModel, source);
end

local function CreateImageDataProvider(model)
	local provider = CreateFromMixins(CallbackRegistryMixin);

	function provider:Enumerate(i, j)
		i = i and (i - 1) or 0;
		j = j or model:GetImageCount();

		local function Next(_, k)
			k = k + 1;

			if k <= j then
				return k, model:GetImageInfo(k);
			end
		end

		return Next, nil, i;
	end

	function provider:Find(i)
		return model:GetImageInfo(i);
	end

	function provider:GetSize()
		return model:GetImageCount();
	end

	provider:GenerateCallbackEvents({ "OnSizeChanged" });
	provider:OnLoad();

	model.RegisterCallback(provider, "OnModelUpdated", function()
		provider:TriggerEvent("OnSizeChanged");
	end);

	return provider;
end

-- Background Browser UI Mixins
------------------------------------------------------------------------------

TRP3_BackgroundBrowserMixin = {};

function TRP3_BackgroundBrowserMixin:OnLoad()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.baseModel = CreateBackgroundBrowserModel();
	self.selectionModel = CreateBackgroundBrowserSelectionModel(self.baseModel);
	self.filterModel = CreateBackgroundBrowserFilterModel(self.selectionModel);

	local GRID_STRIDE = 3;
	local GRID_PADDING = 8;

	local scrollBoxAnchorsWithBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Content, "TOPLEFT", 14, -4),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.Content, "BOTTOMRIGHT", -10, 4),
	};

	local scrollBoxAnchorsWithoutBar = {
		AnchorUtil.CreateAnchor("TOPLEFT", self.Content, "TOPLEFT", 21, -4),
		AnchorUtil.CreateAnchor("BOTTOMRIGHT", self.Content, "BOTTOMRIGHT", -17, -4),
	};

	self.Content.ScrollView = CreateScrollBoxListGridView(GRID_STRIDE, GRID_PADDING, GRID_PADDING, GRID_PADDING, GRID_PADDING);
	self.Content.ScrollView:SetElementInitializer("TRP3_BackgroundBrowserButtonTemplate", function(button, imageInfo) self:OnImageButtonInitialized(button, imageInfo); end);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.Content.ScrollBox, self.Content.ScrollBar, self.Content.ScrollView);
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.Content.ScrollBox, self.Content.ScrollBar, scrollBoxAnchorsWithBar, scrollBoxAnchorsWithoutBar);
	self.Content.ScrollBox:SetDataProvider(CreateImageDataProvider(self.filterModel));
	self.Content.EmptyState:SetModel(self.filterModel);

	self.CloseButton:SetScript("OnClick", function() self:OnCloseButtonClicked(); end);
	self.SearchBox:HookScript("OnTextChanged", TRP3_FunctionUtil.Debounce(0.25, function() self:OnFilterTextChanged(); end));
end

function TRP3_BackgroundBrowserMixin:OnShow()
	self.filterModel:ClearSearchQuery();
	self.SearchBox.Instructions:SetTextColor(0.6, 0.6, 0.6);
	self.SearchBox:SetText("");
	self.SearchBox:SetFocus(true);
	self.Content.ScrollBox:ScrollToBegin();
	PlaySound(TRP3_InterfaceSounds.BrowserOpen);
	self.callbacks:Fire("OnOpened");
end

function TRP3_BackgroundBrowserMixin:OnHide()
	PlaySound(TRP3_InterfaceSounds.BrowserClose);
	self.callbacks:Fire("OnClosed");
end

function TRP3_BackgroundBrowserMixin:OnCloseButtonClicked()
	self:Hide();
end

function TRP3_BackgroundBrowserMixin:OnFilterTextChanged()
	self.filterModel:SetSearchQuery(self.SearchBox:GetText());
end

function TRP3_BackgroundBrowserMixin:OnImageButtonInitialized(button, imageInfo)
	button:SetScript("OnClick", function() self:OnImageButtonClicked(button); end);
	button:Init(imageInfo);
end

function TRP3_BackgroundBrowserMixin:OnImageButtonClicked(button)
	local imageInfo = button:GetElementData();
	self.callbacks:Fire("OnImageSelected", imageInfo);
	PlaySound(TRP3_InterfaceSounds.PopupClose);
	self:Hide();
end

function TRP3_BackgroundBrowserMixin:SetSelectedImage(imageID)
	self.selectionModel:SetSelectedImage(imageID);
end

TRP3_BackgroundBrowserButtonMixin = {};

function TRP3_BackgroundBrowserButtonMixin:OnLoad()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TRP3_BackgroundBrowserButtonMixin:OnEnter()
	local imageInfo = self:GetElementData();

	if not imageInfo then
		return;
	end

	local function OnTooltipShow(_, description)
		local color = nil;
		local wrap = false;
		description:AddLine(TRP3_MarkupUtil.GenerateFileMarkup(imageInfo.file, { size = 256 }), color, wrap);
		description:AddBlankLine();

		local nameLine = TRP3_TooltipTemplates.CreateDelimitedLine(L.CM_NAME, imageInfo.name, wrap);
		description:InsertLine(nameLine);
	end

	TRP3_TooltipUtil.ShowTooltip(self, OnTooltipShow);
end

function TRP3_BackgroundBrowserButtonMixin:OnLeave()
	TRP3_TooltipUtil.HideTooltip(self);
end

function TRP3_BackgroundBrowserButtonMixin:Init(imageInfo)
	self.SelectedTexture:SetShown(imageInfo and imageInfo.selected);
	self.Image:SetTexture(imageInfo and imageInfo.file or [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]]);
end

TRP3_BackgroundBrowserEmptyStateMixin = {};

function TRP3_BackgroundBrowserEmptyStateMixin:SetModel(model)
	if self.model then
		self.model.UnregisterAllCallbacks(self);
		self.model = nil;
	end

	local function UpdateVisibility()
		local count = model:GetImageCount();

		if count == 0 then
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
	self.model.RegisterCallback(self, "OnModelUpdated", UpdateVisibilityDeferred);
end

-- Background Browser API
------------------------------------------------------------------------------

TRP3_BackgroundBrowser = {};

function TRP3_BackgroundBrowser.Close()
	TRP3_BackgroundBrowserFrame:Hide();
end

function TRP3_BackgroundBrowser.Open(options)
	options = options or {};
	local owner = {};

	local function OnClosed()
		TRP3_BackgroundBrowserFrame.UnregisterAllCallbacks(owner);

		if options.onCancelCallback then
			options.onCancelCallback();
		end
	end

	local function OnImageSelected(_, imageInfo)
		TRP3_BackgroundBrowserFrame.UnregisterAllCallbacks(owner);

		if options.onAcceptCallback then
			options.onAcceptCallback(imageInfo);
		end
	end

	TRP3_BackgroundBrowserFrame.RegisterCallback(owner, "OnClosed", OnClosed);
	TRP3_BackgroundBrowserFrame.RegisterCallback(owner, "OnImageSelected", OnImageSelected);
	TRP3_BackgroundBrowserFrame:SetScale(tonumber(options.scale) or 1);
	TRP3_BackgroundBrowserFrame:SetSelectedImage(options.selectedImage);
	TRP3_BackgroundBrowserFrame:Show();
end

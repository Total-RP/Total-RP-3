-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_TabSystem = {};

local SharedTabProperties = {};

function SharedTabProperties:__init()
	self.selectionAccessor = nop;
	self.selectionCallbacks = {};
	self.responder = nop;
end

function SharedTabProperties:AddSelectionCallback(callback)
	table.insert(self.selectionCallbacks, callback);
end

function SharedTabProperties:ExecuteSelectionCallbacks(description)
	local function ExecuteCallback(_, callback)
		callback(description);
	end

	secureexecuterange(self.selectionCallbacks, ExecuteCallback);
end

function SharedTabProperties:GetSelectionAccessor()
	return self.selectionAccessor;
end

function SharedTabProperties:SetSelectionAccessor(accessor)
	self.selectionAccessor = accessor;
end

function SharedTabProperties:GetResponder()
	return self.responder;
end

function SharedTabProperties:SetResponder(responder)
	self.responder = responder;
end

function SharedTabProperties:GetClickSoundKit()
	return GetValueOrCallFunction(self, "clickSoundKit");
end

function SharedTabProperties:SetClickSoundKit(soundKit)
	self.clickSoundKit = soundKit;
end

function TRP3_TabSystem.CreateSharedTabProperties()
	return TRP3_API.CreateObject(SharedTabProperties);
end

local BaseTabDescription = {};

function BaseTabDescription:__init()
	self.sharedTabProperties = nil;
end

function BaseTabDescription:GetSelectionAccessor()
	return self:GetSharedTabProperties():GetSelectionAccessor();
end

function BaseTabDescription:GetResponder()
	return self:GetSharedTabProperties():GetResponder();
end

function BaseTabDescription:GetClickSoundKit()
	return self:GetSharedTabProperties():GetClickSoundKit();
end

function BaseTabDescription:GetSharedTabProperties()
	return self.sharedTabProperties;
end

function BaseTabDescription:SetSharedTabProperties(properties)
	self.sharedTabProperties = properties;
end

local TabButtonDescription = CreateFromMixins(BaseTabDescription);

function TabButtonDescription:__init(id, text)
	BaseTabDescription.__init(self);

	assert(id ~= nil, "attempted to create tab with nil id", id);
	assert(type(text) == "string", "attempted to create tab with invalid text", text);

	self.id = id;
	self.icon = nil;
	self.text = text;
	self.regions = {};
	self.isEnabled = nil;
	self.isShown = nil;
end

function TabButtonDescription:GetID()
	return self.id;
end

function TabButtonDescription:GetText()
	return self.text;
end

function TabButtonDescription:GetIcon()
	return GetValueOrCallFunction(self, "icon");
end

function TabButtonDescription:SetIcon(icon)
	self.icon = icon;
end

function TabButtonDescription:GetMinimumWidth()
	return self.minimumWidth;
end

function TabButtonDescription:GetMaximumWidth()
	return self.maximumWidth;
end

function TabButtonDescription:SetMinimumWidth(minimumWidth)
	self.minimumWidth = minimumWidth;
end

function TabButtonDescription:SetMaximumWidth(maximumWidth)
	self.maximumWidth = maximumWidth;
end

function TabButtonDescription:AddRegions(...)
	local function Insert(tbl, region, ...)
		if region ~= nil then
			table.insert(tbl, region);
			return Insert(tbl, ...);
		end
	end

	Insert(self.regions, ...);
end

function TabButtonDescription:EnumerateRegions()
	return ipairs(self.regions);
end

function TabButtonDescription:IsEnabled()
	if self.isEnabled == nil then
		return true;
	else
		return GetValueOrCallFunction(self, "isEnabled");
	end
end

function TabButtonDescription:SetEnabled(enabled)
	self.isEnabled = enabled;
end

function TabButtonDescription:IsShown()
	if self.isShown == nil then
		return true;
	else
		return GetValueOrCallFunction(self, "isShown");
	end
end

function TabButtonDescription:SetShown(shown)
	self.isShown = shown;
end

function TabButtonDescription:IsSelected()
	local accessor = self:GetSelectionAccessor();
	return accessor(self);
end

function TabButtonDescription:Select()
	local responder = self:GetResponder();
	securecallfunction(responder, self);
end

function TRP3_TabSystem.CreateTabButtonDescription(id, text)
	return TRP3_API.CreateObject(TabButtonDescription, id, text);
end

local TabBarDescription = CreateFromMixins(BaseTabDescription);

function TabBarDescription:__init()
	BaseTabDescription.__init(self);

	self.sharedTabProperties = TRP3_TabSystem.CreateSharedTabProperties();
	self.tabDescriptions = {};
	self.defaultTabSelection = nil;
	self.tabCounter = CreateCounter();
end

function TabBarDescription:CreateTab(text, ...)
	local id = self.tabCounter();
	return self:CreateTabWithID(id, text, ...);
end

function TabBarDescription:CreateTabWithID(id, text, ...)
	local description = TRP3_TabSystem.CreateTabButtonDescription(id, text);
	description:AddRegions(...);
	return self:Insert(description);
end

function TabBarDescription:Insert(description, index)
	description:SetSharedTabProperties(self:GetSharedTabProperties());

	if index == nil then
		table.insert(self.tabDescriptions, description);
	else
		table.insert(self.tabDescriptions, index, description);
	end

	return description;
end

function TabBarDescription:GetDefaultTab()
	return self.defaultTabSelection or self.tabDescriptions[1];
end

function TabBarDescription:SetDefaultTab(description)
	self.defaultTabSelection = description;
end

function TabBarDescription:SetClickSoundKit(soundKit)
	self:GetSharedTabProperties():SetClickSoundKit(soundKit);
end

function TabBarDescription:AddSelectionCallback(callback)
	self:GetSharedTabProperties():AddSelectionCallback(callback);
end

function TabBarDescription:ExecuteSelectionCallbacks(description)
	self:GetSharedTabProperties():ExecuteSelectionCallbacks(description);
end

function TabBarDescription:SetSelectionAccessor(accessor)
	self:GetSharedTabProperties():SetSelectionAccessor(accessor);
end

function TabBarDescription:SetResponder(responder)
	self:GetSharedTabProperties():SetResponder(responder);
end

function TabBarDescription:EnumerateTabDescriptions()
	return ipairs(self.tabDescriptions);
end

function TabBarDescription:FindTabDescription(id)
	for _, description in self:EnumerateTabDescriptions() do
		if id == description:GetID() then
			return description;
		end
	end

	return nil;
end

function TRP3_TabSystem.CreateTabBarDescription()
	return TRP3_API.CreateObject(TabBarDescription);
end

local TabLayoutDescription = {};

function TabLayoutDescription:CalculateButtonExtent(button)
	return self.buttonExtentCalculator(button);
end

function TabLayoutDescription:GetDirectionMultiplier()
	return self.directionMultiplier;
end

function TabLayoutDescription:SetDirectionMultiplier(multiplier)
	self.directionMultiplier = multiplier;
end

function TabLayoutDescription:GetButtonSpacing()
	return self.buttonSpacing;
end

function TabLayoutDescription:SetButtonSpacing(spacing)
	self.buttonSpacing = spacing;
end

function TabLayoutDescription:SetButtonExtentCalculator(calculator)
	self.buttonExtentCalculator = calculator;
end

function TRP3_TabSystem.CreateTabLayoutDescription()
	return TRP3_API.CreateObject(TabLayoutDescription);
end

TRP3_TabSystemMixin = CreateFromMixins(CallbackRegistryMixin);

function TRP3_TabSystemMixin:OnLoad()
	self.barDescription = nil;
	self.barGenerator = nil;
	self.selectedTab = nil;
end

function TRP3_TabSystemMixin:OnShow()
	self:GenerateTabs();
end

function TRP3_TabSystemMixin:OnTabSelected(tabDescription)  -- luacheck: no unused (description)
	self:UpdateTabRegionVisibility();
	self.barDescription:ExecuteSelectionCallbacks(tabDescription);
end

function TRP3_TabSystemMixin:OnTabsRegistered()
	self:UpdateTabRegionVisibility();
end

function TRP3_TabSystemMixin:GetSelectedTab()
	local selectedTabID;

	if self.selectedTab then
		selectedTabID = self.selectedTab:GetID();
	end

	return selectedTabID;
end

function TRP3_TabSystemMixin:SetSelectedTab(id)
	if not self.barDescription then
		return false;
	end

	local tabDescription = self.barDescription:FindTabDescription(id);

	if not tabDescription then
		return false;
	end

	self.selectedTab = tabDescription;
	securecallfunction(self.OnTabSelected, self, self.selectedTab);
	return true;
end

function TRP3_TabSystemMixin:GetBarDescription()
	return self.barDescription;
end

function TRP3_TabSystemMixin:EnumerateTabDescriptions()
	if self.barDescription then
		return self.barDescription:EnumerateTabDescriptions();
	else
		return nop;
	end
end

function TRP3_TabSystemMixin:UpdateTabRegionVisibility()
	for _, description in self:EnumerateTabDescriptions() do
		local selected = (self.selectedTab == description);

		for _, region in description:EnumerateRegions() do
			region:SetShown(selected);
		end
	end
end

function TRP3_TabSystemMixin:RegisterTabs(barDescription)
	self.barDescription = barDescription;

	-- Preserve selections across registrations so long as the previous
	-- selected tab ID remains somewhere in the new description.

	do
		local selectedTab = self.barDescription:FindTabDescription(self:GetSelectedTab());
		local defaultTab = self.barDescription:GetDefaultTab();

		self.selectedTab = selectedTab or defaultTab;
	end

	securecallfunction(self.OnTabsRegistered, self);
end

function TRP3_TabSystemMixin:GenerateTabs()
	if not self.barGenerator then
		return;
	end

	local barDescription = TRP3_TabSystem.CreateTabBarDescription();
	barDescription:SetClickSoundKit(TRP3_TabConstants.ClickSoundKit);
	barDescription:SetSelectionAccessor(function(tab) return self.selectedTab == tab; end);
	barDescription:SetResponder(function(tab) self:SetSelectedTab(tab:GetID()); end);

	securecallfunction(self.barGenerator, self, barDescription);
	self:RegisterTabs(barDescription);
end

function TRP3_TabSystemMixin:SetupTabs(barGenerator)
	self.barGenerator = barGenerator;

	if self:IsShown() then
		self:GenerateTabs();
	end
end

TRP3_TabSystemOwnerMixin = {};

function TRP3_TabSystemOwnerMixin:GetTabSystem()
	return self.TabSystem;
end

function TRP3_TabSystemOwnerMixin:GetSelectedTab()
	return self:GetTabSystem():GetSelectedTab();
end

function TRP3_TabSystemOwnerMixin:SetSelectedTab(id)
	return self:GetTabSystem():SetSelectedTab(id);
end

function TRP3_TabSystemOwnerMixin:GenerateTabs()
	self:GetTabSystem():GenerateTabs();
end

function TRP3_TabSystemOwnerMixin:SetupTabs(barGenerator)
	self:GetTabSystem():SetupTabs(barGenerator);
end

function TRP3_TabSystemOwnerMixin:SetTabSystem(tabSystem)
	self.TabSystem = tabSystem;
end

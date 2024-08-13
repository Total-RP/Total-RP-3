-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

local DashboardTabs = {
	Changelog = 1,
	Credits = 2,
	Modules = 3,
};

TRP3_DashboardTabFrameMixin = {};

function TRP3_DashboardTabFrameMixin:OnLoad()
	self:OnBackdropLoaded();
	TRP3_Addon.RegisterCallback(self, "WORKFLOW_ON_LOADED", "OnInitialize");
end

function TRP3_DashboardTabFrameMixin:OnInitialize()
	local tabs = {
		{ L.DB_NEW, DashboardTabs.Changelog, 150 },
		{ L.DB_ABOUT, DashboardTabs.Credits, 175 },
		{ L.DB_MORE, DashboardTabs.Modules, 150 },
	};

	local function OnTabSelected(_, tab)
		self:OnTabSelected(tab);
	end

	self.tabs = TRP3_API.ui.frame.createTabPanel(self.TabBar, tabs, OnTabSelected);
	self.tabs:SelectTab(1);
end

function TRP3_DashboardTabFrameMixin:OnTabSelected(tab)
	local text;

	if tab == DashboardTabs.Changelog then
		text = TRP3_DashboardUtil.GenerateChangelog();
	elseif tab == DashboardTabs.Credits then
		text = TRP3_DashboardUtil.GenerateCredits();
	elseif tab == DashboardTabs.Modules then
		text = "\n" .. L.MORE_MODULES_2;
	else
		text = "";
	end

	self.Content:SetRichText(text);
end

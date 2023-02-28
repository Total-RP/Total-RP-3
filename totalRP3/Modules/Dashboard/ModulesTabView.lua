-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local addonName, TRP3_API = ...;
local Ellyb = TRP3_API.Ellyb;

-- Ellyb imports
local Class = Ellyb.Class;

-- Total RP 3 imports
local Dashboard = TRP3_API.dashboard;
local loc = TRP3_API.loc;
local strhtml = TRP3_API.utils.str.toHTML;

--- Returns the fully formatted localized text for this view.
local function getLocalizedText()
	return strhtml(loc.MORE_MODULES_2);
end

--- Displays a list of additional cool modules that the user can download.
---  These are totally mindblowing, radical, and have an unconstrained amount
---  of tubular-ness.
local ModulesTabView = Class("TRP3_DashboardModulesTabView", Dashboard.TabView);
Dashboard.ModulesTabView = ModulesTabView;

function ModulesTabView.static.getTabTitle()
	return loc.DB_MORE;
end

function ModulesTabView:initialize(dashboard)
	self.class.super.initialize(self, dashboard);

	self.body = getLocalizedText();
end

function ModulesTabView:Show()
	self.class.super.Show(self);

	self.dashboard:SetHTML(self.body);
end

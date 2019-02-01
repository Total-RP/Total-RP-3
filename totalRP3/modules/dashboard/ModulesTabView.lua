----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard "More Modules" Tab
--- ------------------------------------------------------------------------------
--- Copyright 2018 Daniel "Meorawr" Yates <me@meorawr.io>
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local addonName, TRP3_API = ...;
local Ellyb = Ellyb(addonName);

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

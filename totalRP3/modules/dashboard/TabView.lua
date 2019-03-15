----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard Tab View Class
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

-- Lua imports
local assert = assert;

-- Ellyb imports
local Class = Ellyb.Class;

-- Total RP 3 imports
local Dashboard = TRP3_API.dashboard;

--- The TabView class represents a view that can be embedded into a TabFrame
-- - instance on the dashboard. All views must subclass this.
local TabView = Class("TRP3_TabView");
Dashboard.TabView = TabView;

--- Returns the localised title of the tab that should manage this view.
---  This function must be implemented by subclasses.
function TabView.static.getTabTitle()
	assert(false, "unimplemented function: TabView.getTabTitle()")
end

--- Returns the width of the tab that should manage this view.
function TabView.static.getTabWidth()
	return 150;
end

--- Initialises the content view for this tab. Subclasses should not implement
---  any display logic here; wait for OnShow() to be called first.
---
---  Subclasses that want to do complex stuff can use this constructor to
---  set up child frames on the dashboard itself and toggle them in the
---  OnShow/OnHide handlers.
---
---  @param dashboard The dashboard instance that owns this view.
function TabView:initialize(dashboard)
	self.dashboard = dashboard;
	self.isShown = false;
end

--- Returns true if this tab view is currently showing.
function TabView:IsShown()
	return self.isShown;
end

--- Hides this view. Called by the owning tab frame when the user changes
---  away from this tab.
function TabView:Hide()
	self.isShown = false;
end

--- Shows this view. Called by the owning tab frame when the user changes
---  to this tab.
function TabView:Show()
	self.isShown = true;
end

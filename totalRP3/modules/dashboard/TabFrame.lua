----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard Tab Frame
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
local ColorManager = Ellyb.ColorManager;

-- WoW imports
local GameFontNormal = GameFontNormal;
local GameFontNormalHuge3 = GameFontNormalHuge3;
local GameFontNormalHuge = GameFontNormalHuge;
local GameFontNormalLarge = GameFontNormalLarge;

-- Total RP 3 imports
local Events = TRP3_API.events;
local strhtml = TRP3_API.utils.str.toHTML;
local UIFrame = TRP3_API.ui.frame;

--- Creates an entry for a tab compatible for use with the ui.createTabFrame
---  function. This has an additional field (View) which is an instantiated
---  instance of the view class.
---
---  @param viewClass The class to wrap and instantiate.
---  @param index The index of the tab. This is stored as the "value" of the entry.
---  @vararg any Arguments to pass to the viewClass constructor.
local function createTabFromClass(index, viewClass, ...)
	-- Use explicit indices here to make it clear on the structure.
	return {
		View = viewClass(...),
		[1] = viewClass.getTabTitle(),
		[2] = index,
		[3] = viewClass.getTabWidth(),
	};
end

--- Mixin attached to the TRP3_DashboardTabFrame template. Generally speaking
---  you'll need to implement OnLoad yourself and set "self.TabClasses" to
---  a table of TabView classes to be displayed in this widget, then call into
---  the OnLoad method afterward.
TRP3_DashboardTabFrameMixin = {};

function TRP3_DashboardTabFrameMixin:OnLoad()
	-- Expect self.TabClasses to be a table. If it isn't, see above for what
	-- you've gotta do.
	Ellyb.Assertions.isType(self.TabClasses, "table", "self.TabClasses");

	-- Can't set parentKey on a scroll child and expect it to work, so
	-- assign it as a child here instead.
	self.HTMLContent = self.ScrollFrame:GetScrollChild().HTML;

	-- Wrap the tab view classes in a table to be passed to the tab controller.
	self.tabs = {};
	Events.listenToEvent(Events.WORKFLOW_ON_LOADED, function()
		for i = 1, #self.TabClasses do
			self.tabs[i] = createTabFromClass(i, self.TabClasses[i], self);
		end

		-- Feed in the tabs and, when clicked, forward the call to OnTabSelected.
		self.controller = UIFrame.createTabPanel(self.TabBar, self.tabs, function(_, ...)
			return self:OnTabSelected(...);
		end);

		-- Cycle to the first tab by default. This'll trigger OnTabSelected.
		self.controller:SelectTab(1);
	end)

	-- Listen for updates on our frame being resized.
	Events.listenToEvent(Events.NAVIGATION_RESIZED, function(width, height)
		return self:OnNavigationResized(width, height);
	end);
end

--- Called when the NAVIGATION_RESIZED event fires. Re-draws the content
---  frame to make it adjust to the new dimensions.
function TRP3_DashboardTabFrameMixin:OnNavigationResized(width)
	-- Resize the content frame and try to refresh it.
	local htmlFrame = self.HTMLContent;
	htmlFrame:SetSize(width - 54, 5);
	htmlFrame:SetText(htmlFrame:GetText());
end

--- Called when a tab in this frame has been selected. Updates the content
---  and notifies the view.
---
---  @param index The index of the newly selected tab.
function TRP3_DashboardTabFrameMixin:OnTabSelected(index)
	local entry = self.tabs[index];
	assert(entry, "invalid tab index");

	if self.view then
		self.view:Hide();
	end

	self:ResetHTMLStyles();
	self.view = entry.View;

	if self.view then
		self.view:Show();
	end

	if self.ScrollFrame then
		self.ScrollFrame:SetVerticalScroll(0);
	end
end

--- Resets the font objects and colors associated with the HTML content
---  frame on the widget.
function TRP3_DashboardTabFrameMixin:ResetHTMLStyles()
	local htmlFrame = self.HTMLContent;

	htmlFrame:SetFontObject("p", GameFontNormal);
	htmlFrame:SetFontObject("h1", GameFontNormalHuge3);
	htmlFrame:SetFontObject("h2", GameFontNormalHuge);
	htmlFrame:SetFontObject("h3", GameFontNormalLarge);

	htmlFrame:SetTextColor("h1", ColorManager.WHITE:GetRGB());
	htmlFrame:SetTextColor("h2", ColorManager.WHITE:GetRGB());
	htmlFrame:SetTextColor("h3", ColorManager.WHITE:GetRGB());
end

--- Convenience method that sets the text on the HTMLContent child widget
---  to that of the given text. The text is converted to HTML prior to display.
---
---  @param text The unformatted source text string to display in the widget.
---              This will be converted to html prior to display.
function TRP3_DashboardTabFrameMixin:SetHTMLFromText(text)
	return self:SetHTML(strhtml(text));
end

--- Convenience method that sets the text on the HTMLContent child widget
---  to that of the given text. The text is assumed to be valid HTML.
---
---  @param html The preformatted HTML string to display in the widget.
function TRP3_DashboardTabFrameMixin:SetHTML(html)
	return self.HTMLContent:SetText(html);
end

--- Convenience method that registers a hyperlink handler on the HTMLContent
---  child widget. See that mixin for argument documentation.
function TRP3_DashboardTabFrameMixin:RegisterHyperlink(...)
	return self.HTMLContent:RegisterHyperlink(...);
end

--- Convenience method that unregisters a hyperlink handler on the HTMLContent
---  child widget. See that mixin for argument documentation.
function TRP3_DashboardTabFrameMixin:UnregisterHyperlink(...)
	return self.HTMLContent:UnregisterHyperlink(...);
end

--- Convenience method that unregisters all hyperlink handlers on the
---  HTMLContent child widget. See that mixin for argument documentation.
function TRP3_DashboardTabFrameMixin:UnregisterAllHyperlinks(...)
	return self.HTMLContent:UnregisterAllHyperlinks(...);
end

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local TRP3_API = select(2, ...);
local Ellyb = TRP3_API.Ellyb;

-- Lua imports
local tconcat = table.concat;

-- Ellyb imports
local Class = Ellyb.Class;

-- Total RP 3 imports
local Configuration = TRP3_API.configuration;
local Dashboard = TRP3_API.dashboard;
local Navigation = TRP3_API.navigation;
local UITooltip = TRP3_API.ui.tooltip;
local loc = TRP3_API.loc;
local strhtml = TRP3_API.utils.str.toHTML;

--- List of "What's new" segments to concatenate and display together when
---  this view is activated.
local SEGMENTS = {
	loc.WHATS_NEW_28_0,
};

--- Returns the fully formatted localized text for this view.
local function getLocalizedText()
	return strhtml(tconcat(SEGMENTS, "\n"));
end

--- Toggles a setting and displays a UI toast.
---  @param setting The setting to be toggled.
local function toggleSetting(setting)
	if Configuration.getValue(setting) then
		Configuration.setValue(setting, false);
		UITooltip.toast(loc.OPTION_DISABLED_TOAST, 3);
	else
		Configuration.setValue(setting, true);
		UITooltip.toast(loc.OPTION_ENABLED_TOAST, 3);
	end
end

--- Mapping of URL handlers to register and unregister with this view.
local URL_HANDLERS = {
	right_click_profile = GenerateClosure(toggleSetting, "CONFIG_RIGHT_CLICK_OPEN_PROFILE"),
	companion_speeches = GenerateClosure(toggleSetting, "chat_npcspeech_replacement"),
	default_color_picker = GenerateClosure(toggleSetting, "default_color_picker"),
	disable_chat_ooc = GenerateClosure(toggleSetting, "chat_disable_ooc"),
	open_mature_filter_settings = function()
		Navigation.menu.selectMenu("main_91_config_main_config_register");
	end,
};

--- Tab view class that displays our changelog, and points out the awesome
---  new features that we've spent far too much time working on.
local WhatsNewTabView = Class("TRP3_DashboardWhatsNewTabView", Dashboard.TabView);
Dashboard.WhatsNewTabView = WhatsNewTabView;

function WhatsNewTabView.static.getTabTitle()
	return loc.DB_NEW;
end

function WhatsNewTabView:initialize(dashboard)
	self.class.super.initialize(self, dashboard);

	self.body = getLocalizedText();
end

function WhatsNewTabView:Hide()
	self.class.super.Hide(self);

	-- Unregister the hyperlink handlers.
	for url in pairs(URL_HANDLERS) do
		self.dashboard:UnregisterHyperlink(url);
	end
end

function WhatsNewTabView:Show()
	self.class.super.Show(self);

	self.dashboard:SetHTML(getLocalizedText());

	-- Register all the URL strings that allow people to toggle settings
	-- from the view directly. Whoever thought of this feature was a genius,
	-- by the way.
	for url, handler in pairs(URL_HANDLERS) do
		self.dashboard:RegisterHyperlink(url, handler);
	end
end

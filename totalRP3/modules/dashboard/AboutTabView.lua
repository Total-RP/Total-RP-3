----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard "About" Tab
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
local tconcat = table.concat;

-- Ellyb imports
local Class = Ellyb.Class;
local Strings = Ellyb.Strings;
local Tables = Ellyb.Tables;

-- Total RP 3 imports
local Dashboard = TRP3_API.dashboard;
local loc = TRP3_API.loc;
local strhtml = TRP3_API.utils.str.toHTML;

local Credit = Dashboard.Credit;
local CreditRoles = Dashboard.CreditRoles;

--- Mapping of replacement string keys to Credit instances that will be
--  displayed in the replaced segment.
local CREDITS = {
	AUTHORS = {
		Credit([[Renaud "{twitter*EllypseCelwe*Ellypse}" Parize]], CreditRoles.AUTHOR),
		Credit([[Sylvain "{twitter*Telkostrasz*Telkostrasz}" Cossement]], CreditRoles.AUTHOR),
	},

	CONTRIBUTORS = {
		ShowNamesWithRoles = true,

		Credit([[{twitter*Solanya_*Solanya}]], CreditRoles.CONTRIBUTOR, CreditRoles.COMMUNITY_MANAGER),
		Credit([[Connor "{twitter*Saelorable*Sælorable}" Macleod]], CreditRoles.CONTRIBUTOR),
		Credit([[Daniel "Meorawr" Yates]], CreditRoles.CONTRIBUTOR),
	},

	TESTERS = {
		Credit([[Erzan]], CreditRoles.TESTER),
		Credit([[Calian]], CreditRoles.TESTER),
		Credit([[Kharess]], CreditRoles.TESTER),
		Credit([[Alnih]], CreditRoles.TESTER),
		Credit([[611]], CreditRoles.TESTER),
	},

	GUILD_MEMBERS = {
		Credit([[Azane]], CreditRoles.GUILD_MEMBER),
		Credit([[Hellclaw]], CreditRoles.GUILD_MEMBER),
		Credit([[Leylou]], CreditRoles.GUILD_MEMBER),
	},
};

--- Returns a formatted string that contains all the names for people
--  in a given credits section.
--
--- The credits table may have a "ShowNamesWithRoles" flag that controls
--  if role information is appended to individual names.
local function getLocalizedCreditsSection(people)
	-- Use a temporary table and get all the localized names in the
	-- correct format.
	local names = Tables.getTempTable();
	for i = 1, #people do
		local person = people[i];

		if people.ShowNamesWithRoles then
			names[i] = person:GetLocalizedFullText();
		else
			names[i] = person:GetName();
		end
	end

	-- Build a newline separated list where each line has a preceeding
	-- list marker ("- ") using the names.
	local formatted = ("- %s"):format(tconcat(names, "\n- "));

	Tables.releaseTempTable(names);
	return formatted;
end

--- Returns the fully formatted localized text for this view.
local function getLocalizedText()
	local replacements = {
		[1] = TRP3_API.globals.version_display,
		[2] = TRP3_API.globals.version,
	};

	for section, people in pairs(CREDITS) do
		replacements[section] = getLocalizedCreditsSection(people);
	end

	return strhtml(Strings.interpolate(loc.THANK_YOU_1, replacements));
end

--- Displays the credits and some text about what addon this is, just in
--  case the users want to tweet at the developers to tell them how loved
--  they are.
local AboutTabView = Class("TRP3_DashboardAboutTabView", Dashboard.TabView);
Dashboard.AboutTabView = AboutTabView;

function AboutTabView.static.getTabTitle()
	return loc.DB_ABOUT;
end

function AboutTabView.static.getTabWidth()
	return 175;
end

function AboutTabView:initialize(dashboard)
	self.class.super.initialize(self, dashboard);

	self.body = getLocalizedText();
end

function AboutTabView:Show()
	self.class.super.Show(self);

	self.dashboard:SetHTML(self.body);
end

----------------------------------------------------------------------------------
--- Total RP 3
--- Dashboard Credit Class
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
local Tables = Ellyb.Tables;

-- WoW imports
local LIST_DELIMITER = LIST_DELIMITER;

-- Total RP 3 imports
local Dashboard = TRP3_API.dashboard;
local loc = TRP3_API.loc;

--- Enumeration of valid roles for use with the Credit class.
Dashboard.CreditRoles = {
	AUTHOR = "AUTHOR",
	CONTRIBUTOR = "CONTRIBUTOR",
	COMMUNITY_MANAGER = "COMMUNITY_MANAGER",
	TESTER = "TESTER",
	GUILD_MEMBER = "GUILD_MEMBER",
};

--- This class represents a single person to be displayed in the credits.
local Credit = Class("TRP3_Credit");
Dashboard.Credit = Credit;

--- Initialises the credit with the given person's name string and a list of
---  roles to assign them.
function Credit:initialize(person, ...)
	self.person = person;
	self.roles = { ... };
end

--- Returns the name of the person this credit belongs to.
function Credit:GetName()
	return self.person;
end

--- Returns the full text to display for this role, which consists of the
---  persons name and their role(s).
local ROLE_STRING_FORMAT = "%s (%s)";
function Credit:GetLocalizedFullText()
	return ROLE_STRING_FORMAT:format(self:GetName(), self:GetLocalizedRoleText());
end

--- Returns a localized string that describes the roles this person has.
function Credit:GetLocalizedRoleText()
	-- Zero or only one role? Simple lookup, nothing more.
	local roleCount = #self.roles;
	if roleCount == 0 then
		return "";
	elseif roleCount == 1 then
		return loc:GetText("THANK_YOU_ROLE_" .. self.roles[1]);
	end

	-- If this person is multi-talented and can perform not one, but MULTIPLE
	-- roles then we need to join them up with a list delimiter.
	local localisedRoles = Tables.getTempTable();
	for i = 1, roleCount do
		localisedRoles[i] = loc:GetText("THANK_YOU_ROLE_" .. self.roles[i]);
	end

	local localisedRoleString = tconcat(localisedRoles, LIST_DELIMITER);
	Tables.releaseTempTable(localisedRoles);
	return localisedRoleString;
end

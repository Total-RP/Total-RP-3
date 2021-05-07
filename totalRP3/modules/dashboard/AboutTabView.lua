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

-- Ellyb imports
local Class = Ellyb.Class;

-- Total RP 3 imports
local Dashboard = TRP3_API.dashboard;
local L = TRP3_API.loc;

local CreditRole =
{
	ProjectLead = 1,
	Author = 2,
	Developer = 3,
	CommunityManager = 4,
	Mascot = 5,
};
local CreditCategory =
{
	Authors = 1,
	Developers = 2,
	QA = 3,
	GuildMembers = 4,
	Supporters = 5,
	Discord = 6,
};
local CreditEntity =
{
	Individual = 1,
	Guild = 2,
};

local CreditsData =
{
	[CreditCategory.Authors] =
	{
		{
			name  = [[Morgane "{twitter*EllypseCelwe*Ellypse}" Parize]],
			roles = { CreditRole.Author },
		},
		{
			name  = [[Sylvain "{twitter*Telkostrasz*Telkostrasz}" Cossement]],
			roles = { CreditRole.Author },
		},
	},

	[CreditCategory.Developers] =
	{
		{
			name  = [[{twitter*Solanya_*Solanya}]],
			roles = { CreditRole.ProjectLead, CreditRole.CommunityManager },
		},
		{
			name  = [[Daniel "{twitter*Meorawr*Meorawr}" Yates]],
			roles = { CreditRole.Developer, CreditRole.Mascot },
		},
		{
			name  = [[Connor "{twitter*Saelorable*Sælorable}" Macleod]],
			roles = { CreditRole.Developer },
		},
	},

	[CreditCategory.QA] =
	{
		{
			name  = "Erzan",
		},
		{
			name  = "Calian",
		},
		{
			name  = "Kharess",
		},
		{
			name  = "Alnih",
		},
		{
			name  = "611",
		},
	},

	[CreditCategory.GuildMembers] =
	{
		{
			name  = "Azane",
		},
		{
			name  = "Hellclaw",
		},
		{
			name  = "Leylou",
		},
	},

	[CreditCategory.Supporters] =
	{
		{
			name  = "Eglise du Saint Gamon",
			type  = CreditEntity.Guild,
		},
		{
			name  = "Maison Celwë'Belore",
			type  = CreditEntity.Guild,
		},
		{
			name  = "Mercenaires Atal'ai",
			type  = CreditEntity.Guild,
		},
		{
			name  = "Kharess",
		},
		{
			name  = "Kathryl",
		},
		{
			name  = "Marud",
		},
		{
			name  = "Solona",
		},
		{
			name  = "Stretcher",
		},
		{
			name  = "Lisma",
		},
		{
			name  = "Erzan",
		},
		{
			name  = "Elenna",
		},
		{
			name  = "Caleb",
		},
		{
			name  = "Siana",
		},
		{
			name  = "Adaeria",
		},
	},

	[CreditCategory.Discord] =
	{
		{
			name = "Katorie",
		},
		{
			name = "Keyboardturner",
		},
		{
			name = "Lyra",
		},
		{
			name = "Naeraa",
		},
		{
			name = "Trinity",
		},
	}
};

local function GenerateRoleString(roles)
	local output = {};

	for _, role in ipairs(roles) do
		local localizedRole = L:GetText("CREDITS_THANK_YOU_ROLE_" .. role);
		table.insert(output, localizedRole);
	end

	return table.concat(output, LIST_DELIMITER);
end

local function GenerateCategoryString(category, options)
	local output = {};

	for _, credit in ipairs(category) do
		local text;

		if options and options.showRoleText and #credit.roles > 0 then
			local roleString = GenerateRoleString(credit.roles);
			text = string.format(L.CREDITS_NAME_WITH_ROLE, credit.name, roleString);
		elseif credit.type == CreditEntity.Guild then
			text = string.format(L.CREDITS_GUILD_NAME, credit.name);
		else
			text = credit.name;
		end

		table.insert(output, "- " .. text);
	end

	table.insert(output, "");  -- Empty line for padding.

	return table.concat(output, "|n");
end

local function GenerateCreditsString(credits)
	local output = {};

	do  -- Header
		local WEBSITE_LINK = string.format("{link*%1$s*%2$s}", "http://totalrp3.info", L.CREDITS_WEBSITE_LINK_TEXT);
		local TWITTER_LINK = string.format("{twitter*%1$s*@%1$s}", "TotalRP3");
		local DISCORD_LINK = string.format("{link*%1$s*%2$s}", "http://discord.totalrp3.info", L.CREDITS_DISCORD_LINK_TEXT);
		local VERSION_TEXT = string.format(L.CREDITS_VERSION_TEXT, TRP3_API.globals.version_display);

		local lines = {};

		table.insert(lines, string.format("{p:c}{col:6eff51}%1$s{/col}{/p}", VERSION_TEXT));
		table.insert(lines, string.format("{p:c}%1$s — %2$s{/p}", WEBSITE_LINK, TWITTER_LINK));
		table.insert(lines, string.format("{p:c}%1$s{/p}", DISCORD_LINK));

		table.insert(output, L.CREDITS_THANK_YOU_SECTION_1);
		table.insert(output, table.concat(lines, "|n"));
	end

	do  -- Authors
		local ICON_MARKUP = string.format("{icon:%1$s:20}", TRP3_InterfaceIcons.CreditsAuthors);

		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_2, ICON_MARKUP));
		table.insert(output, GenerateCategoryString(credits[CreditCategory.Authors]));
	end

	do  -- Developers
		local ICON_MARKUP = string.format("{icon:%1$s:20}", TRP3_InterfaceIcons.CreditsTeam);

		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_3, ICON_MARKUP));
		table.insert(output, GenerateCategoryString(credits[CreditCategory.Developers], { showRoleText = true }));
	end

	-- Acknowledgements

	do  -- Logo Author
		local LOGO_AUTHOR_LINK = string.format("{twitter*%1$s*@%1$s}", "Kelandiir");
		local ICON_MARKUP = string.format("{icon:%1$s:20}", TRP3_InterfaceIcons.CreditsOthers);

		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_4, ICON_MARKUP));
		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_5, LOGO_AUTHOR_LINK));
	end

	-- Discord members
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_10);
	table.insert(output, GenerateCategoryString(credits[CreditCategory.Discord]));

	-- Bor
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_11);

	-- QA/Testers
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_6);
	table.insert(output, GenerateCategoryString(credits[CreditCategory.QA]));

	-- Additional mentions
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_7);
	table.insert(output, GenerateCategoryString(credits[CreditCategory.Supporters]));

	-- Guild Members
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_8);
	table.insert(output, GenerateCategoryString(credits[CreditCategory.GuildMembers]));

	-- Magazine thing.
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_9);

	output = table.concat(output, "|n|n");
	output = TRP3_API.utils.str.toHTML(output);

	return output;
end

-- Displays the credits and some text about what addon this is, just in
-- case the users want to tweet at the developers to tell them how loved
-- they are.
local AboutTabView = Class("TRP3_DashboardAboutTabView", Dashboard.TabView);
Dashboard.AboutTabView = AboutTabView;

function AboutTabView.static.getTabTitle()
	return L.DB_ABOUT;
end

function AboutTabView.static.getTabWidth()
	return 175;
end

function AboutTabView:initialize(dashboard)
	self.class.super.initialize(self, dashboard);

	self.body = GenerateCreditsString(CreditsData);
end

function AboutTabView:Show()
	self.class.super.Show(self);

	self.dashboard:SetHTML(self.body);
end

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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
		{
			name  = [[{twitter*Raenore*Raenore}]],
			roles = { CreditRole.Developer },
		},
	},

	[CreditCategory.QA] =
	{
		{ name  = "Erzan", },
		{ name  = "Calian", },
		{ name  = "Kharess", },
		{ name  = "Alnih", },
		{ name  = "611", },
	},

	[CreditCategory.GuildMembers] =
	{
		{ name  = "Azane" },
		{ name  = "Hellclaw" },
		{ name  = "Leylou" },
	},

	[CreditCategory.Supporters] =
	{
		{ name = "Eglise du Saint Gamon", type = CreditEntity.Guild },
		{ name = "Maison Celwë'Belore", type = CreditEntity.Guild },
		{ name = "Mercenaires Atal'ai", type = CreditEntity.Guild },
		{ name = "Kharess" },
		{ name = "Kathryl" },
		{ name = "Marud" },
		{ name = "Solona" },
		{ name = "Stretcher" },
		{ name = "Lisma" },
		{ name = "Erzan" },
		{ name = "Elenna" },
		{ name = "Caleb" },
		{ name = "Siana" },
		{ name = "Adaeria" },
	},

	[CreditCategory.Discord] =
	{
		{ name = "Ghost" },
		{ name = "Katorie" },
		{ name = "Keyboardturner" },
		{ name = "Lyra" },
		{ name = "Naeraa" },
		{ name = "Trinity" },
	}
};

local function GenerateCreditsRole(roles)
	local output = {};

	for _, role in ipairs(roles) do
		local localizedRole = L:GetText("CREDITS_THANK_YOU_ROLE_" .. role);
		table.insert(output, localizedRole);
	end

	return table.concat(output, LIST_DELIMITER);
end

local function GenerateCreditsCategory(category, options)
	local output = {};

	for _, credit in ipairs(category) do
		local text;

		if options and options.showRoleText and #credit.roles > 0 then
			local roleString = GenerateCreditsRole(credit.roles);
			text = string.format(L.CREDITS_NAME_WITH_ROLE, credit.name, roleString);
		elseif credit.type == CreditEntity.Guild then
			text = string.format(L.CREDITS_GUILD_NAME, credit.name);
		else
			text = credit.name;
		end

		table.insert(output, "- " .. text);
	end

	table.insert(output, "\n");  -- Empty line for padding.

	return table.concat(output, "\n");
end

function TRP3_DashboardUtil.GenerateCredits()
	local credits = CreditsData;
	local output = {};

	do  -- Header
		local WEBSITE_LINK = string.format("{link*%1$s*%2$s}", "http://totalrp3.info", L.CREDITS_WEBSITE_LINK_TEXT);
		local DISCORD_LINK = string.format("{link*%1$s*%2$s}", "http://discord.totalrp3.info", L.CREDITS_DISCORD_LINK_TEXT);
		local VERSION_TEXT = string.format(L.CREDITS_VERSION_TEXT, TRP3_API.utils.str.sanitizeVersion(TRP3_API.globals.version_display));

		local lines = {};

		table.insert(lines, string.format("{p:c}{col:6eff51}%1$s{/col}{/p}", VERSION_TEXT));
		table.insert(lines, string.format("{p:c}{col:f2bf1a}%1$s{/col} — {col:f2bf1a}%2$s{/col}{/p}", WEBSITE_LINK, DISCORD_LINK));

		table.insert(output, L.CREDITS_THANK_YOU_SECTION_1);
		table.insert(output, table.concat(lines, ""));
	end

	do  -- Authors
		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_2, ""));
		table.insert(output, "\n");
		table.insert(output, GenerateCreditsCategory(credits[CreditCategory.Authors]));
	end

	do  -- Developers
		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_3, ""));
		table.insert(output, "\n");
		table.insert(output, GenerateCreditsCategory(credits[CreditCategory.Developers], { showRoleText = true }));
	end

	-- Acknowledgements

	do  -- Logo Author
		local LOGO_AUTHOR_LINK = string.format("{twitter*%1$s*%1$s}", "Kelandiir");
		local SIDEBAR_DICE_AUTHOR_LINK = string.format("{twitter*%1$s*%2$s}", "keyboardturn", "keyboardturner");

		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_4, ""));
		table.insert(output, "\n");
		table.insert(output, string.format(L.CREDITS_THANK_YOU_SECTION_5, LOGO_AUTHOR_LINK, SIDEBAR_DICE_AUTHOR_LINK));
		table.insert(output, "\n\n");
	end

	-- Discord members
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_10);
	table.insert(output, "\n");
	table.insert(output, GenerateCreditsCategory(credits[CreditCategory.Discord]));

	-- Bor
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_11);
	table.insert(output, "\n\n");

	-- QA/Testers
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_6);
	table.insert(output, "\n");
	table.insert(output, GenerateCreditsCategory(credits[CreditCategory.QA]));

	-- Additional mentions
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_7);
	table.insert(output, "\n");
	table.insert(output, GenerateCreditsCategory(credits[CreditCategory.Supporters]));

	-- Guild Members
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_8);
	table.insert(output, "\n");
	table.insert(output, GenerateCreditsCategory(credits[CreditCategory.GuildMembers]));

	-- Magazine thing.
	table.insert(output, L.CREDITS_THANK_YOU_SECTION_9);

	output = table.concat(output, "");
	output = "\n" .. output;
	output = TRP3_DashboardUtil.GenerateListMarkup(output);

	return output;
end

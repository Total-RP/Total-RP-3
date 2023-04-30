-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Statistics factories

local function CountPairs(t)
	local n = 0;

	for _ in pairs(t) do
		n = n + 1;
	end

	return n;
end

local function SafeGet(t, k, ...)
	if t == nil then
		return nil;
	end

	local v = t[k];

	if ... ~= nil then
		return SafeGet(v, ...);
	else
		return v;
	end
end

local function CreateTablePairsCounter(tableName, ...)
	local tableKeys = { ... };

	local function Evaluate()
		local t = SafeGet(_G, tableName, unpack(tableKeys));
		return t and CountPairs(t) or 0;
	end

	return Evaluate;
end

-- Statistics registration
--
-- Note: Statistic names and descriptions aren't localized currently. This
--       will change if there's actual value in the feature - no point adding
--       10+ localization strings if we get barely any data.

TRP3_Analytics:RegisterStatistic({
	id = "player.characters",
	name = "Player character count",
	description = "Number of characters that you've used the addon on.",
	type = "counter",
	evaluate = CreateTablePairsCounter("TRP3_Characters"),
});

TRP3_Analytics:RegisterStatistic({
	id = "player.profiles",
	name = "Player profile count",
	description = "Number of player profiles that you've created.",
	type = "counter",
	evaluate = CreateTablePairsCounter("TRP3_Profiles"),
});

TRP3_Analytics:RegisterStatistic({
	id = "companion.profiles",
	name = "Companion profile count",
	description = "Number of companion profiles that you've created.",
	type = "counter",
	evaluate = CreateTablePairsCounter("TRP3_Companions", "player"),
});

TRP3_Analytics:RegisterStatistic({
	id = "register.characters",
	name = "Directory character count",
	description = "Number of other player characters that you've seen using a roleplay addon.",
	type = "counter",
	evaluate = CreateTablePairsCounter("TRP3_Register", "character"),
});

TRP3_Analytics:RegisterStatistic({
	id = "register.profiles",
	name = "Directory profile count",
	description = "Number of player profiles you've received from other players.",
	type = "counter",
	evaluate = CreateTablePairsCounter("TRP3_Register", "profiles"),
});

TRP3_Analytics:RegisterStatistic({
	id = "register.companions",
	name = "Directory companion count",
	description = "Number of companion profiles you've received from other players.",
	type = "counter",
	evaluate = CreateTablePairsCounter("TRP3_Register", "companion"),
});

TRP3_Analytics:RegisterStatistic({
	id = "configuration.has_customized_locale",
	name = "Has changed locale",
	description = "Whether or not you've reconfigured the addon locale setting to be different than that of the game client.",
	type = "boolean",
	evaluate = function()
		return TRP3_API.utils.GetDefaultLocale() ~= TRP3_API.utils.GetPreferredLocale();
	end,
});

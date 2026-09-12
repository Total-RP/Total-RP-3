-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:rpstatus",
	tokens = { "rpstatus" },

	Evaluate = function(context)
		local player = AddOn_TotalRP3.Player.GetCurrentUser();
		local ok, status = TRP3_AutomationUtil.ParseRoleplayStatusString(context.option);

		if not ok then
			local reason = TRP3_AutomationUtil.FormatOptionError(context.option, TRP3_AutomationUtil.ROLEPLAY_STATUS_OPTIONS);
			context:Errorf(L.AUTOMATION_CONDITION_ROLEPLAY_STATUS_ERROR, reason);
		end

		return player:GetRoleplayStatus() == status;
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:ic",
	tokens = { "ic" },

	Evaluate = function()
		local player = AddOn_TotalRP3.Player.GetCurrentUser();
		return player:GetRoleplayStatus() == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:ooc",
	tokens = { "ooc" },

	Evaluate = function()
		local player = AddOn_TotalRP3.Player.GetCurrentUser();
		return player:GetRoleplayStatus() == AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:profile",
	tokens = { "profile" },

	Evaluate = function(context)
		local player = AddOn_TotalRP3.Player.GetCurrentUser();
		local currentProfileName = player:GetProfileName();
		local desiredProfileName = context.option;

		return TRP3_StringUtil.IsExactOrSubstringMatch(desiredProfileName, currentProfileName);
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:location",
	tokens = { "location" },

	Evaluate = function(context)
		local currentLocationName = GetMinimapZoneText();
		local desiredLocationName = context.option;

		return TRP3_StringUtil.IsExactOrSubstringMatch(desiredLocationName, currentLocationName);
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:instance",
	tokens = { "instance" },

	Evaluate = function(context)
		local isInInstance, instanceType = IsInInstance();

		if context.option ~= "" then
			return instanceType == context.option;
		else
			return isInInstance;
		end
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:afk",
	tokens = { "afk" },

	Evaluate = function()
		return IsChatAFK();
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:dnd",
	tokens = { "dnd" },

	Evaluate = function()
		return IsChatDND();
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:pvp",
	tokens = { "pvp" },

	Evaluate = function()
		return UnitIsPVP("player");
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:warmode",
	tokens = { "warmode" },

	Evaluate = function()
		-- On Classic clients this will always evaluate to false.
		return C_PvP.IsWarModeActive and C_PvP.IsWarModeActive() or false;
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:character",
	tokens = { "character" },

	Evaluate = function(context)
		local currentCharacterName = UnitNameUnmodified("player");
		local desiredCharacterName = context.option;

		return TRP3_StringUtil.IsExactOrSubstringMatch(desiredCharacterName, currentCharacterName);
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:realm",
	tokens = { "realm" },

	Evaluate = function(context)
		local currentRealmName = GetNormalizedRealmName();
		local desiredRealmName = context.option;

		return TRP3_StringUtil.IsExactOrSubstringMatch(desiredRealmName, currentRealmName);
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:altform",
	tokens = { "altform" },

	Evaluate = function()
		local inAlternateForm = false;

		if C_PlayerInfo.GetAlternateFormInfo then
			inAlternateForm = select(2, C_PlayerInfo.GetAlternateFormInfo());
		end

		return inAlternateForm;
	end,
});

local function GetActivePlayerLocation()
	return PlayerLocation:CreateFromUnit("player");
end

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:race",
	tokens = { "race" },

	Evaluate = function(context)
		local currentRaceID = C_PlayerInfo.GetRace(GetActivePlayerLocation());
		local desiredRaceID = tonumber(context.option);

		if desiredRaceID then
			return currentRaceID == desiredRaceID;
		end

		local currentRaceInfo = C_CreatureInfo.GetRaceInfo(currentRaceID);
		local desiredRaceName = context.option;

		if currentRaceInfo then
			return TRP3_StringUtil.IsExactOrSubstringMatch(currentRaceInfo.raceName, desiredRaceName)
				or TRP3_StringUtil.IsExactOrSubstringMatch(currentRaceInfo.clientFileString, desiredRaceName);
		end

		return false;
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:class",
	tokens = { "class" },

	Evaluate = function(context)
		local currentClassName, currentClassFile, currentClassID = C_PlayerInfo.GetClass(GetActivePlayerLocation());
		local desiredClassID = tonumber(context.option);

		if desiredClassID then
			return currentClassID == desiredClassID;
		end

		local desiredClassName = context.option;

		return TRP3_StringUtil.IsExactOrSubstringMatch(currentClassName, desiredClassName)
			or TRP3_StringUtil.IsExactOrSubstringMatch(currentClassFile, desiredClassName);
	end,
});

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:faction",
	tokens = { "faction" },

	Evaluate = function(context)
		local currentFactionInfo = C_CreatureInfo.GetFactionInfo(C_PlayerInfo.GetRace(GetActivePlayerLocation()));
		local desiredFactionName = context.option;

		if currentFactionInfo then
			return TRP3_StringUtil.IsExactOrSubstringMatch(currentFactionInfo.name, desiredFactionName)
				or TRP3_StringUtil.IsExactOrSubstringMatch(currentFactionInfo.groupTag, desiredFactionName);
		end

		return false;
	end,
});

local GetLocaleInvariantSex = EnumUtil.GenerateNameTranslation(Enum.UnitSex);

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:sex",
	tokens = { "bodytype", "gender", "sex" },

	Evaluate = function(context)
		local currentSexID = C_PlayerInfo.GetSex(GetActivePlayerLocation());
		local desiredSexID = tonumber(context.option);

		if desiredSexID then
			return currentSexID == desiredSexID;
		end

		local currentSexName = GetLocaleInvariantSex(currentSexID);
		local desiredSexName = context.option;

		return TRP3_StringUtil.IsExactOrSubstringMatch(currentSexName, desiredSexName);
	end,
});

local TimeRanges = {
	-- Ranges are [min, max).
	Day = { startHour = 6, endHour = 18 },
	Night = { startHour = 18, endHour = 6 },
	Morning = { startHour = 6, endHour = 12 },
	Afternoon = { startHour = 12, endHour = 18 },
	Evening = { startHour = 18, endHour = 22 },
};

local TimeRangesByToken = {
	day = TimeRanges.Day,
	night = TimeRanges.Night,
	morning = TimeRanges.Morning,
	afternoon = TimeRanges.Afternoon,
	evening = TimeRanges.Evening,
	[C_Intl.FoldCase(L.AUTOMATION_TIME_DAY)] = TimeRanges.Day,
	[C_Intl.FoldCase(L.AUTOMATION_TIME_NIGHT)] = TimeRanges.Night,
	[C_Intl.FoldCase(L.AUTOMATION_TIME_MORNING)] = TimeRanges.Morning,
	[C_Intl.FoldCase(L.AUTOMATION_TIME_AFTERNOON)] = TimeRanges.Afternoon,
	[C_Intl.FoldCase(L.AUTOMATION_TIME_EVENING)] = TimeRanges.Evening,
};

local function WrapHour(hour)
	return math.wrap(hour, 0, 24);
end

local function ParseTimeRange(option)
	local namedRange = TimeRangesByToken[option];

	if namedRange then
		return namedRange.startHour, namedRange.endHour;
	end

	local rangeStart, rangeEnd = string.match(option, "^(%d%d?)%-(%d%d?)$");
	local hour = tonumber(option);

	if hour then
		rangeStart, rangeEnd = hour, hour;
	else
		rangeStart, rangeEnd = tonumber(rangeStart), tonumber(rangeEnd);
	end

	if rangeStart and rangeEnd then
		return WrapHour(rangeStart), WrapHour(rangeEnd);
	end
end

local function IsHourInRange(hour, rangeStart, rangeEnd)
	if rangeStart < rangeEnd then
		return hour >= rangeStart and hour < rangeEnd;
	elseif rangeStart > rangeEnd then
		-- Required for matching overnight ranges (eg. '21-3').
		return hour >= rangeStart or hour < rangeEnd;
	else
		-- Inputs of "6" or "6-6" are treated implicitly as referencing a
		-- span of a single hour.
		return hour == rangeStart;
	end
end

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:time",
	tokens = { "time" },

	Evaluate = function(context)
		local currentHour = GetGameTime();

		for option in string.gmatch(C_Intl.FoldCase(context.option), "[^/]+") do
			local normalizedOption = string.trim(C_Intl.FoldCase(option));
			local rangeStart, rangeEnd = ParseTimeRange(normalizedOption);

			if not rangeStart then
				context:Errorf(L.AUTOMATION_CONDITION_TIME_ERROR, context.option);
				return false;
			end

			if IsHourInRange(currentHour, rangeStart, rangeEnd) then
				return true;
			end
		end

		return false;
	end,
});

local WeatherTypes = {
	Clear = { type = Enum.WeatherType.Clear, threshold = 0 },
	Rain = { type = Enum.WeatherType.Rain, threshold = 0.25 },
	Snow = { type = Enum.WeatherType.Snow, threshold = 0.25 },
	Sandstorm = { type = Enum.WeatherType.Sandstorm, threshold = 0.25 },
};

local WeatherTypesByToken = {
	clear = WeatherTypes.Clear,
	rain = WeatherTypes.Rain,
	snow = WeatherTypes.Snow,
	sandstorm = WeatherTypes.Sandstorm,
	[C_Intl.FoldCase(L.AUTOMATION_WEATHER_CLEAR)] = WeatherTypes.Clear,
	[C_Intl.FoldCase(L.AUTOMATION_WEATHER_RAIN)] = WeatherTypes.Rain,
	[C_Intl.FoldCase(L.AUTOMATION_WEATHER_SNOW)] = WeatherTypes.Snow,
	[C_Intl.FoldCase(L.AUTOMATION_WEATHER_SANDSTORM)] = WeatherTypes.Sandstorm,
};

TRP3_AutomationUtil.RegisterCondition({
	id = "trp3:weather",
	tokens = { "weather" },

	Evaluate = function(context)
		local weather = C_Weather.GetCurrentWeather();

		for option in string.gmatch(context.option, "[^/]+") do
			local normalizedOption = string.trim(C_Intl.FoldCase(option));
			local weatherType = WeatherTypesByToken[normalizedOption];

			if not weatherType then
				context:Errorf(L.AUTOMATION_CONDITION_WEATHER_ERROR, context.option);
				return false;
			end

			if weather.type == weatherType.type and weather.intensity >= weatherType.threshold then
				return true;
			end
		end

		return false;
	end,
});

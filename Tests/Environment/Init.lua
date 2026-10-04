-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

require("Environment.Constants");
require("Environment.GameAPI");
require("Environment.GlobalColors");
require("Environment.GlobalStrings");
require("Environment.LuaFunctions");
require("Environment.Libraries");

local SOURCE = string.sub(debug.getinfo(1, "S").source, 2);
local TESTS_DIRECTORY = string.match(SOURCE, "^(.*[/\\])") or "./";
local ROOT_DIRECTORY = string.gsub(TESTS_DIRECTORY, "Tests[/\\]Environment[/\\]$", "");

local GAME_TYPE_FAMILIES = {
	Vanilla = "Classic",
	TBC = "Classic",
	Mists = "Classic",
	Standard = "Mainline",
	Forever = "Mainline",
};

local GAME_TYPE_DIRECTORIES = {
	Vanilla = "Vanilla",
	TBC = "TBC",
	Mists = "Mists",
	Standard = "Standard",
	Forever = "Camelot",
};

local GAME_TYPE_CLIENT_SETTINGS = {
	Vanilla = {
		projectID = WOW_PROJECT_CLASSIC,
		expansionLevel = Enum.ExpansionLevel.None,
	},

	TBC = {
		projectID = WOW_PROJECT_BURNING_CRUSADE_CLASSIC,
		expansionLevel = Enum.ExpansionLevel.BurningCrusade,
	},

	Mists = {
		projectID = WOW_PROJECT_MISTS_CLASSIC,
		expansionLevel = Enum.ExpansionLevel.MistsOfPandaria,
	},

	Standard = {
		projectID = WOW_PROJECT_MAINLINE,
		expansionLevel = Enum.ExpansionLevel.Midnight,
	},

	Forever = {
		projectID = WOW_PROJECT_FOREVER,
		expansionLevel = Enum.ExpansionLevel.None,
	},
};

local ADDON_FILES = {
	"totalRP3/Init.lua",
	"totalRP3/Libs/Ellyb/Ellyb.lua",
	"totalRP3/Libs/Ellyb/Libraries/middleclass.lua",
	"totalRP3/Libs/Ellyb/Internals/Class.lua",
	"totalRP3/Libs/Ellyb/Tools/Assertions.lua",
	"totalRP3/Libs/Ellyb/Tools/Locale.lua",
	"totalRP3/Libs/Ellyb/Tools/Localization.lua",
	"totalRP3/Locales/enUS.lua",
	"totalRP3/Locales/deDE.lua",
	"totalRP3/Locales/esES.lua",
	"totalRP3/Locales/esMX.lua",
	"totalRP3/Locales/frFR.lua",
	"totalRP3/Locales/itIT.lua",
	"totalRP3/Locales/koKR.lua",
	"totalRP3/Locales/ptBR.lua",
	"totalRP3/Locales/ruRU.lua",
	"totalRP3/Locales/zhCN.lua",
	"totalRP3/Locales/zhTW.lua",
	"totalRP3/Locales/Locale.lua",
	{ file = "totalRP3/Resources/[Family]/ImageList.lua" },
	{ file = "totalRP3/Resources/[Family]/RaceIconAtlases.lua", allowLoad = { Classic = true } },
	{ file = "totalRP3/Resources/[Game]/RaceIconAtlases.lua", excludeLoad = { Classic = true } },
	"totalRP3/Resources/InterfaceIcons.lua",
	"totalRP3/Resources/InterfaceAtlases.lua",
	"totalRP3/Resources/InterfaceSounds.lua",
	{ file = "totalRP3/Resources/[Family]/CompanionData.lua", allowLoad = { Vanilla = true, TBC = true } },
	"totalRP3/Core/Enums.lua",
	"totalRP3/Core/NameUtil.lua",
	"totalRP3/Core/Player.lua",
	"totalRP3/Core/Globals.lua",
	"totalRP3/Core/Logging.lua",
	"totalRP3/Core/Prototype.lua",
	"totalRP3/Core/Objects/Callback.lua",
	"totalRP3/Core/Objects/CallbackGroup.lua",
	"totalRP3/Core/Objects/CallbackGroupCollection.lua",
	"totalRP3/Core/Objects/CallbackRegistry.lua",
	"totalRP3/Core/Events.lua",
	"totalRP3/Core/Color.lua",
	"totalRP3/Core/ColorData.lua",
	"totalRP3/Core/CVarUtil.lua",
	"totalRP3/Core/SoundUtil.lua",
	"totalRP3/Core/FunctionUtil.lua",
	"totalRP3/Core/SortUtil.lua",
	"totalRP3/Core/StringUtil.lua",
	"totalRP3/Core/EncodingUtil.lua",
	"totalRP3/Core/BindingUtil.lua",
	"totalRP3/Core/RegionUtil.lua",
	"totalRP3/Core/IconUtil.lua",
	"totalRP3/Core/MarkupUtil.lua",
	"totalRP3/Core/CompanionUtil.lua",
	{ file = "totalRP3/Core/CompanionProviderJournal.lua", allowLoad = { Standard = true, Mists = true } },
	{ file = "totalRP3/Core/CompanionProviderStatic.lua", allowLoad = { Vanilla = true, TBC = true } },
	"totalRP3/Core/Utils.lua",
	"totalRP3/Core/ProfileUtil.lua",
};

local function ShouldLoadFile(entry, gameType, family)
	local function Matches(loadTypes)
		for loadType in pairs(loadTypes) do
			if loadType == gameType or loadType == family then
				return true;
			end
		end
		return false;
	end

	if type(entry) == "table" then
		if entry.allowLoad and not Matches(entry.allowLoad) then
			return false;
		end

		if entry.excludeLoad and Matches(entry.excludeLoad) then
			return false;
		end
	end

	return true;
end

local function ResolvePath(entry, family, gameDirectory)
	local path = type(entry) == "string" and entry or entry.file;
	path = string.gsub(path, "%[Family%]", family);
	path = string.gsub(path, "%[Game%]", gameDirectory);
	return path;
end


local function LoadFile(path, ...)
	local chunk = assert(loadfile(ROOT_DIRECTORY .. path));
	return chunk(...);
end

local Environment = {};

function Environment.LoadAddOn(gameType)
	gameType = gameType or "Standard";

	local family = GAME_TYPE_FAMILIES[gameType];
	local gameDirectory = GAME_TYPE_DIRECTORIES[gameType];
	local clientSettings = GAME_TYPE_CLIENT_SETTINGS[gameType];

	WOW_PROJECT_ID = clientSettings.projectID;
	LE_EXPANSION_LEVEL_CURRENT = clientSettings.expansionLevel;

	local addonTable = {};

	for _, entry in ipairs(ADDON_FILES) do
		if ShouldLoadFile(entry, gameType, family) then
			local path = ResolvePath(entry, family, gameDirectory);
			LoadFile(path, "totalRP3", addonTable);
		end
	end

	return addonTable;
end

return Environment;

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- Analytics module
--
-- The analytics module collects anonymized usage statistics from the addon
-- and submits them to a data collection sink on logout or UI reload.
--
-- This module is enabled by default, but requires that the user have installed
-- a statistics collection addon - we assume that the presence of such an addon
-- implies that the user is happy to provide analytics.
--
-- Currently the only supported data collection sink is Wago Analytics. To
-- enable it, you'll need to tick the "Help addon developers" setting in the
-- Wago Addons app under "Settings" > "Data preferences". This setting is
-- disabled by default. Users will additionally need to keep installed and
-- enabled the "WagoAnalytics" addon in their game directory.
--
-- For transparency, all collected statistics can be dumped to the chat frame
-- through a "/trp3 statistics" command.
--

local SinkPrototype = {};

function SinkPrototype:WriteBoolean(id, state)  -- luacheck: no unused
	-- Override in a custom sink implementation.
end

function SinkPrototype:WriteCounter(id, count)  -- luacheck: no unused
	-- Override in a custom sink implementation.
end

function SinkPrototype:Flush()
	-- Override in a custom sink implementation.
end

-- Chat frame sink

local ChatFrameSink = CreateFromMixins(SinkPrototype);

function ChatFrameSink:__init()
	self.results = {};
end

function ChatFrameSink:WriteBoolean(id, state)
	self.results[id] = state;
end

function ChatFrameSink:WriteCounter(id, count)
	self.results[id] = count;
end

function ChatFrameSink:Flush()
	local statistics = TRP3_Analytics:GetRegisteredStatistics();
	local keys = GetKeysArray(self.results);

	local function CompareStatisticNames(a, b)
		a = statistics[a].name;
		b = statistics[b].name;

		return strcmputf8i(a, b) < 0;
	end

	table.sort(keys, CompareStatisticNames);

	TRP3_Addon:Print(L.ANALYTICS_OUTPUT_HEADER);

	for _, key in ipairs(keys) do
		local statistic = TRP3_Analytics:GetStatisticInfo(key);
		local value = self.results[key];

		if type(value) == "boolean" then
			value = value and YES or NO;
		else
			value = tostring(value);
		end

		TRP3_Addon:Printf(" %s: |cffffcc00%s|r", statistic.name, value);
	end
end

local function CreateChatFrameSink()
	return TRP3_API.CreateAndInitFromPrototype(ChatFrameSink);
end

-- Wago analytics sink

local WagoAnalyticsSink = CreateFromMixins(SinkPrototype);

function WagoAnalyticsSink:__init(wagoAddonID)
	self.handle = WagoAnalytics:Register(wagoAddonID);
end

function WagoAnalyticsSink:WriteBoolean(id, state)
	self.handle:Switch(id, state);
end

function WagoAnalyticsSink:WriteCounter(id, count)
	self.handle:SetCounter(id, count);
end

function WagoAnalyticsSink:Flush()
	self.handle:Save();
end

local function CreateWagoAnalyticsSink(wagoAddonID)
	return TRP3_API.CreateAndInitFromPrototype(WagoAnalyticsSink, wagoAddonID);
end

-- Analytics module

TRP3_Analytics = TRP3_Addon:NewModule("Analytics", { statistics = {} });

function TRP3_Analytics:OnInitialize()
	TRP3_API.configuration.registerConfigKey("analytics_enabled", true);
end

function TRP3_Analytics:OnEnable()
	TRP3_API.RegisterCallback(TRP3_API.GameEvents, "ADDONS_UNLOADING", self.OnAddonsUnloading, self);

	TRP3_API.slash.registerCommand({
		id = "statistics",
		helpLine = " " .. L.ANALYTICS_COMMAND_HELP,
		handler = GenerateClosure(self.OnSlashCommand, self);
	});

	-- The below should really go in OnInitialize but unfortunately we've
	-- got a bit of an awkward situation where the config page doesn't exist
	-- until OnEnable.
	--
	-- We also only support one type of data collection sink, so rather than
	-- overengineer things we'll do some hardcoding here...

	local SINK_NAME = "Wago Analytics";

	if WagoAnalytics then
		table.insert(TRP3_API.configuration.CONFIG_STRUCTURE_GENERAL.elements, {
			inherit = "TRP3_ConfigCheck",
			title = string.format(L.ANALYTICS_CONFIG_ENABLE, SINK_NAME),
			configKey = "analytics_enabled",
			help = string.join("|n|n", string.format(L.ANALYTICS_CONFIG_ENABLE_HELP, SINK_NAME), L.ANALYTICS_CONFIG_ENABLE_HELP_WAGO),
		});

		TRP3_API.configuration.refreshPage("main_config_aaa_general");
	end
end

function TRP3_Analytics:OnAddonsUnloading()
	local wagoAddonID = GetAddOnMetadata("totalRP3", "X-Wago-ID");

	if WagoAnalytics and wagoAddonID and self:IsDataCollectionEnabled() then
		local sink = CreateWagoAnalyticsSink(wagoAddonID);
		self:Collect(sink);
	end
end

function TRP3_Analytics:OnSlashCommand()
	local sink = CreateChatFrameSink();
	self:Collect(sink);
end

function TRP3_Analytics:IsDataCollectionEnabled()
	return TRP3_API.configuration.getValue("analytics_enabled");
end

function TRP3_Analytics:RegisterStatistic(statistic)
	if self.statistics[statistic.id] then
		securecall(error, "attempted to register a duplicate statistic id");
		return;
	end

	local shallow = false;
	self.statistics[statistic.id] = CopyTable(statistic, shallow);
end

function TRP3_Analytics:GetRegisteredStatistics()
	local shallow = false;
	return CopyTable(self.statistics, shallow);
end

function TRP3_Analytics:GetStatisticInfo(id)
	local statistic = self.statistics[id];

	if not statistic then
		return;
	end

	local shallow = false;
	return CopyTable(statistic, shallow);
end

local function CollectStatistic(_, statistic, sink)
	local writer;
	local value;

	if statistic.type == "boolean" then
		writer = sink.WriteBoolean;
		value = statistic.evaluate();
	elseif statistic.type == "counter" then
		writer = sink.WriteCounter;
		value = statistic.evaluate();
	end

	writer(sink, statistic.id, value);
end

function TRP3_Analytics:Collect(sink)
	-- Use of secureexecuterange here gives us isolation between statistics
	-- in the event they encounter an error. An error in one statistic won't
	-- prevent all the others being collected.

	secureexecuterange(self.statistics, CollectStatistic, sink);
	sink:Flush();
end

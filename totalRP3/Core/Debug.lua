-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_DebugUtil = {};

local ObjectDebugNames = setmetatable({}, { __mode = "kv" });

function TRP3_DebugUtil.GetDebugName(object)
	local name = ObjectDebugNames[object];

	if not name and object.GetDebugName then
		name = object:GetDebugName();
	end

	if not name then
		return tostring(object);
	end

	return name;
end

function TRP3_DebugUtil.SetDebugName(object, name)
	ObjectDebugNames[object] = name;
end

local EventTracingRegistries = setmetatable({}, { __mode = "kv" });

local function OnCallbackEventFired(registry, event, ...)
	if not EventTracingRegistries[registry] then
		return;
	elseif not EventTrace or not EventTrace.LogLine then
		return;
	end

	if TRP3_API.IsEventValid(TRP3_API.GameEvents, event) then
		return;
	end

	local qualifiedEventName = "TRP3_" .. event;

	if not EventTrace:CanLogEvent(qualifiedEventName) or not EventTrace:IsLoggingCREvents() then
		return;
	end

	local registryName = TRP3_DebugUtil.GetDebugName(registry);
	local registryText = LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(string.format("(TRP3: %s)", registryName));

	local elementData = {
		event = qualifiedEventName,
		args = SafePack(...),
		displayEvent = string.join(" ", event, LIGHTBLUE_FONT_COLOR:WrapTextInColorCode("(TRP3)")),
		displayMessage = string.join(" ", event, registryText),
	};

	EventTrace:LogLine(elementData);
end

function TRP3_DebugUtil.AddToEventTraceWindow(registry)
	if not TRP3_API.globals.DEBUG_MODE then
		return;
	end

	if EventTracingRegistries[registry] == nil then
		hooksecurefunc(registry, "Fire", OnCallbackEventFired);
	end

	EventTracingRegistries[registry] = true;
end

function TRP3_DebugUtil.RemoveFromEventTraceWindow(registry)
	if EventTracingRegistries[registry] ~= nil then
		EventTracingRegistries[registry] = false;
	end
end

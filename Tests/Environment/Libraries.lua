-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- luacheck: ignore

local libraries = {};

LibStub = {};

function LibStub:GetLibrary(name, silent)
	local library = libraries[name];

	if not library and not silent then
		error(string.format("Cannot find a library instance of %q.", tostring(name)), 2);
	end

	return library;
end

setmetatable(LibStub, { __call = LibStub.GetLibrary });

local AceAddon = {}
libraries["AceAddon-3.0"] = AceAddon;

function AceAddon:NewAddon(name)
	return { name = name };
end

local AceSerializer = {}
libraries["AceSerializer-3.0"] = AceSerializer;

function AceSerializer:Deserialize(data)
	return true, data;
end

function AceSerializer:Serialize(data)
	return data;
end

local CallbackHandler = {}
libraries["CallbackHandler-1.0"] = CallbackHandler;

function CallbackHandler:New(registry)
	local callbacks = {};

	function registry.RegisterCallback(_owner, _event, _callback) end
	function registry.UnregisterCallback(_owner, _event) end
	function registry.UnregisterAllCallbacks(_owner) end

	function callbacks:Fire(_event, ...) end

	return callbacks;
end

local LibRPMedia = {}
libraries["LibRPMedia-1.2"] = LibRPMedia;

function LibRPMedia:ResolveIconID(icon)
	return icon and 1;
end

function LibRPMedia:GetIconNameByID(_iconID)
	return "test-icon";
end

function LibRPMedia:GetIconInfoByID(_iconID)
	return { file = "test-icon" };
end

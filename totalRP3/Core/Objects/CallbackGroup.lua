-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Callback groups provide a mechanism for toggling a collection of registrables
-- on-demand. The concept of a "registrable" is anything that provides a pair
-- of parameterless "Register" and "Unregister" methods.

local CallbackGroup = {};

function CallbackGroup:__init()
	self.registrables = {};
end

function CallbackGroup:AddCallback(registry, event, callback, owner, ...)
	local registrable = TRP3_API.CreateCallback(registry, event, callback, owner, ...);
	table.insert(self.registrables, registrable);
end

function CallbackGroup:RegisterCallback(registry, event, callback, owner, ...)
	local registrable = TRP3_API.RegisterCallback(registry, event, callback, owner, ...);
	table.insert(self.registrables, registrable);
end

function CallbackGroup:AddRegistrable(registrable)
	table.insert(self.registrables, registrable);
end

function CallbackGroup:Clear()
	self.registrables = {};
end

function CallbackGroup:EnumerateIndexedRegistrables()
	return ipairs(self.registrables);
end

function CallbackGroup:Register()
	for _, registrable in ipairs(self.registrables) do
		registrable:Register();
	end
end

function CallbackGroup:Unregister()
	for _, registrable in ipairs(self.registrables) do
		registrable:Unregister();
	end
end

function TRP3_API.CreateCallbackGroup()
	return TRP3_API.CreateObject(CallbackGroup);
end

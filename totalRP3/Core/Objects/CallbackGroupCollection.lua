-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Callback group collections are a convenience wrapper for managing a keyed
-- set of callback groups. Callbacks can be added to a child group with a
-- user-defined group "key", and the groups later mass-toggled or individually
-- manipulated as needed.

local CallbackGroupCollection = {};

function CallbackGroupCollection:__init()
	self.groups = {};
end

function CallbackGroupCollection:AddCallback(key, registry, event, callback, owner, ...)
	local group = self:GetOrCreateGroup(key);
	group:AddCallback(registry, event, callback, owner, ...);
end

function CallbackGroupCollection:RegisterCallback(key, registry, event, callback, owner, ...)
	local group = self:GetOrCreateGroup(key);
	group:RegisterCallback(registry, event, callback, owner, ...);
end

function CallbackGroupCollection:AddRegistrable(key, registrable)
	local group = self:GetOrCreateGroup(key);
	group:AddRegistrable(registrable);
end

function CallbackGroupCollection:AddGroup(key, group)
	assert(not self.groups[key], "attempted to add a duplicate callback group");
	self.groups[key] = group;
end

function CallbackGroupCollection:CreateGroup(key)
	assert(not self.groups[key], "attempted to create a duplicate callback group");

	local group = TRP3_API.CreateCallbackGroup();
	self.groups[key] = group;
	return group;
end

function CallbackGroupCollection:EnumerateKeyedGroups()
	return pairs(self.groups);
end

function CallbackGroupCollection:GetGroup(key)
	return self.groups[key];
end

function CallbackGroupCollection:GetOrCreateGroup(key)
	return self.groups[key] or self:CreateGroup(key);
end

function CallbackGroupCollection:Clear()
	self.groups = {};
end

function CallbackGroupCollection:ClearGroup(key)
	local group = assert(self.groups[key], "attempted to clear a non-existent callback group");
	group:clear();
end

function CallbackGroupCollection:Register()
	for _, group in pairs(self.groups) do
		group:Register();
	end
end

function CallbackGroupCollection:RegisterGroup(key)
	local group = assert(self.groups[key], "attempted to register a non-existent callback group");
	group:Register();
end

function CallbackGroupCollection:Unregister()
	for _, group in pairs(self.groups) do
		group:Unregister();
	end
end

function CallbackGroupCollection:UnregisterGroup(key)
	local group = assert(self.groups[key], "attempted to unregister a non-existent callback group");
	group:Unregister();
end

function TRP3_API.CreateCallbackGroupCollection()
	return TRP3_API.CreateAndInitFromPrototype(CallbackGroupCollection);
end

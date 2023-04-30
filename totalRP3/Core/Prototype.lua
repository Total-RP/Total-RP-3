-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);

-- Prototype factory
--
-- This implements a basic wrapper around Lua's prototypical metatable system
-- by providing a slightly more convenient way of defining metatables for
-- object-like tables.
--
-- A "prototype" is a table that has arbitrary key/value pairs. When a prototype
-- is fed to the CreateFromPrototype function those key/value pairs will be
-- shallow-copied to a metatable. For standard key/value pairs they will be
-- placed in an '__index' table for lookups, and for magic '__foo' style keys
-- they will be placed at the root of the metatable.
--
-- The metatables created from prototypes are cached - so creation from a
-- single prototype should yield the same metatable on all instantiated objects.

local PrototypeMetatableFactory = { cache = setmetatable({}, { __mode = "kv" }) };

function PrototypeMetatableFactory:Create(prototype)
	local metatable = { __index = {} };
	local index = metatable.__index;

	for k, v in pairs(prototype) do
		if type(k) == "string" and string.find(k, "^__") then
			metatable[k] = v;
		else
			index[k] = v;
		end
	end

	-- If the prototype comes with its own '__index' then it will be used
	-- for all lookups that don't hit the 'index' table that we just created.

	if metatable.__index ~= index and next(index) ~= nil then
		metatable.__index = setmetatable(index, { __index = metatable.__index });
	end

	return metatable;
end

function PrototypeMetatableFactory:GetOrCreate(prototype)
	local metatable = self.cache[prototype];

	if not metatable then
		metatable = self:Create(prototype);
		self.cache[prototype] = metatable;
	end

	return metatable;
end

function TRP3_API.CreateFromPrototype(prototype)
	local metatable = PrototypeMetatableFactory:GetOrCreate(prototype);
	return setmetatable({}, metatable);
end

function TRP3_API.CreateAndInitFromPrototype(prototype, ...)
	local object = TRP3_API.CreateFromPrototype(prototype);

	if prototype.__init then
		prototype.__init(object, ...);
	end

	return object;
end

function TRP3_API.ApplyPrototypeToObject(object, prototype)
	local metatable = PrototypeMetatableFactory:GetOrCreate(prototype);
	return setmetatable(object, metatable);
end

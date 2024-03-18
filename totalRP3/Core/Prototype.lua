-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@class TRP3_API
local TRP3_API = select(2, ...);

--[[
	This file defines a few convenience functions for instantiating objects
	with metatable-based inheritance from prototypes.

	Calling the CreateObject function will create a new object that inherits
	from an optional prototype. Any accesses for fields that don't exist
	on the object will instead consult the prototype, as if via '__index'.

		local Person = {};

		function Person:__init(name) self.name = name; end
		function Person:Greet() print("Hello", self.name); end

		local Bob = TRP3_API.CreateObject(Person);
		Bob:Greet();  -- prints "Hello Bob"

	This system does not enforce a strict model of inheritance, but either
	catenative or chained models are supported. The below example uses
	chained inheritance to say that cats are pets, and catenative inheritance
	to make cats feedable.

		local Pet = {};
		function Pet:__init(name) self.name = name; end
		function Pet:GetName() return self.name; end

		local Feedable = {};
		function Feedable:Feed(food) print("You feed", self:GetName(), food, "."); end;

		local Cat = TRP3_API.CreateObject(Pet);
		Mixin(Cat, Feedable);

		local Mittens = TRP3_API.CreateObject(Cat, "Mittens");
		Mittens:Feed("bananas");  -- prints "You feed Mittens bananas."

	Creation and initialization of objects can be customized by defining two
	the '__allocate' and '__init' methods on a prototype respectively. These
	methods are both optional, and will not cause errors if omitted.

	Prototypes may define fields that match the names of a restricted subset
	of metamethods. These metamethods will be made available to all objects
	that derive from the prototype.
]]--

local ProxyMethods = {};

function ProxyMethods.__add(lhs, rhs) return lhs:__add(rhs); end
function ProxyMethods.__call(lhs, rhs) return lhs:__call(rhs); end
function ProxyMethods.__concat(lhs, rhs) return lhs:__concat(rhs); end
function ProxyMethods.__div(lhs, rhs) return lhs:__div(rhs); end
function ProxyMethods.__eq(lhs, rhs) return lhs:__eq(rhs); end
function ProxyMethods.__lt(lhs, rhs) return lhs:__lt(rhs); end
function ProxyMethods.__mod(lhs, rhs) return lhs:__mod(rhs); end
function ProxyMethods.__mul(lhs, rhs) return lhs:__mul(rhs); end
function ProxyMethods.__pow(lhs, rhs) return lhs:__pow(rhs); end
function ProxyMethods.__sub(lhs, rhs) return lhs:__sub(rhs); end
function ProxyMethods.__tostring(op) return op:__tostring(); end
function ProxyMethods.__unm(op) return op:__unm(); end

local function MixinProxyMethods(metatable, prototype)
	for k, v in pairs(ProxyMethods) do
		if prototype[k] then
			metatable[k] = v;
		end
	end
end

local MetatableCache = setmetatable({}, { __mode = "kv" });

local function GetPrototypeMetatable(prototype)
	local metatable = MetatableCache[prototype];

	if prototype and not metatable then
		metatable = { __index = prototype, __prototype = prototype };
		MixinProxyMethods(metatable, prototype);
		MetatableCache[prototype] = metatable;
	end

	return metatable;
end

local function AllocateObject(prototype)
	local object;

	if prototype and prototype.__allocate then
		object = prototype:__allocate();
	else
		object = {};
	end

	return object;
end

local function ConstructObject(object, ...)
	if object.__init then
		object:__init(...);
	end
end

--- Allocates and initializes a new object that optionally inherits all fields
--- from a supplied prototype.
---
---@generic T
---@param prototype T?
---@param ... any
---@return T object
function TRP3_API.CreateObject(prototype, ...)
	local metatable = GetPrototypeMetatable(prototype);
	local object = AllocateObject(prototype);
	setmetatable(object, metatable);
	ConstructObject(object, ...);
	return object;
end

--- Allocates a new object and optionally associates it with a supplied
--- prototype, but does not initialize the object.
---
--- If the prototype defines an '__allocate' method, it will be invoked and
--- the resulting object will be returned by this function with a metatable
--- assigned that links the object to the prototype. Otherwise, if no such
--- method exists then an empty table is created instead.
---
---@generic T
---@param prototype T?
---@return T object
function TRP3_API.AllocateObject(prototype)
	local metatable = GetPrototypeMetatable(prototype);
	local object = AllocateObject(prototype);
	return setmetatable(object, metatable);
end

--- Initializes a previously allocated object, invoking the '__init' method
--- on the object with the supplied parameters if such a method is defined.
---
---@generic T
---@param object T
---@return table object
function TRP3_API.ConstructObject(object, ...)
	ConstructObject(object, ...);
	return object;
end

--- Returns the prototype assigned to an object.
---
---@param object table
---@return table? prototype
function TRP3_API.GetObjectPrototype(object)
	local metatable = getmetatable(object);
	return metatable and metatable.__prototype or nil;
end

--- Changes the prototype assigned to an object.
---
--- This function does not call the '__init' method on the object.
---
---@generic T
---@param object table
---@param prototype T
---@return T object
function TRP3_API.SetObjectPrototype(object, prototype)
	local metatable = GetPrototypeMetatable(prototype);
	return setmetatable(object, metatable);
end

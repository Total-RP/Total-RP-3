---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.PooledObjectMixin then
	return
end

-- Unique and private symbol that is used as the index on a class' static table to reference the original allocator.
local ALLOCATOR_KEY = newproxy(false);

-- Table mapping class references to a sub-table containing the pooled instances of that class.
local instances = setmetatable({}, { __mode = "k" });

--- Allocates a given class, returning either a previously-allocated instance present in the pool
--- or a newly-allocated one using the allocator function it had at the time of mixin inclusion.
local function pooledAllocator(class)
	-- Grab the appropriate pool for this class in the instances table or create one.
	-- This means each class (and subclass!) gets its own pool.
	local pool = instances[class];
	if not pool then
		pool = setmetatable({}, { __mode = "k" });
		instances[class] = pool;
	end

	-- Grab the next free instance from the pool or call the original allocator to make one.
	local instance = next(pool);
	if not instance then
		instance = class[ALLOCATOR_KEY](class);
	end

	pool[instance] = nil;
	return instance;
end

--- @class PooledObjectMixin
--- Mixin that, when applied to a class, allows it to allocate instances from a reusable pool.
--- Instances can be returned to the pool via an attached method.
---
--- The pool for each class is distinct, even if you inherit a class that includes this mixin.
--- When an instance is retrieved from the pool it is subject to normal class initialization procedures,
--- including the call of the initialize() method.
local PooledObjectMixin = {};

--- Releases the instance back into the pool. The instance should not be used after this call.
function PooledObjectMixin:ReleasePooledObject()
	-- This should be safe; even though the instances table is weakly-keyed
	-- the instance itself has a reference to the class.
	instances[self.class][self] = true;
end

--- Hook invoked whenever a class includes this mixin.
--- Records the original allocator on a class and replaces it with our pooled allocator.
---@param class MiddleClass_Class
function PooledObjectMixin:included(class)
	-- Get the original allocator for the class and hide it on the class.
	local allocator = class.static.allocate;
	class.static[ALLOCATOR_KEY] = allocator;

	class.static.allocate = pooledAllocator;
end

Ellyb.PooledObjectMixin = PooledObjectMixin;

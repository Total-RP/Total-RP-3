---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Class then
	return
end

--- Private storage table, used to store private properties by indexing the table per instance of a class.
--- The table has weak indexes which means it will not prevent the objects from being garbage collected.
--- Example:
--- > `local privateStore = Ellyb.getPrivateStorage()`
--- > `local myClassInstance = MyClass()`
--- > `privateStore[myClassInstance].privateProperty = someValue`
---@type table
local privateStorage = setmetatable({},{
	__index = function(store, instance) -- Remove need to initialize the private table for each instance, we lazy instantiate it
		store[instance] = {}
		return store[instance]
	end,
	__mode = "k", -- Weak table keys: allow stored instances to be garbage collected
	__metatable = "You are not allowed to access the metatable of this private storage",
})

---@return table privateStorage
function Ellyb.getPrivateStorage()
	return privateStorage
end

--- Create a new class
---@param name string The name of the class
---@param super string The name of a class to extend
---@overload fun(name:string):MiddleClass_Class, table
---@return MiddleClass_Class, table Returns the class newly created and a private table with a weak metatable
function Ellyb.Class(name, super)
	return Ellyb.middleclass.class(name, super), privateStorage;
end

---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Tables then
	return
end

-- WoW imports
local tinsert = table.insert;
local tremove = table.remove;

local Tables = {};
Ellyb.Tables = Tables;

---Make use of WoW's shiny new table inspector window to inspect a table programatically
---@param table table @ The table we want to inspect in WoW's table inspector
function Tables.inspect(table)
	_G.UIParentLoadAddOn("Blizzard_DebugTools");
	_G.DisplayTableInspectorWindow(table);
end

--- Recursively copy all content from a table to another one.
--- Argument "destination" must be a non nil table reference.
---@param destination table The table that will receive the new content
---@param source table The table that contains the thing we want to put in the destination
---@overload fun(source:table)
function Tables.copy(destination, source)
	Ellyb.Assertions.isType(destination, "table", "destination");

	-- If we are only given one table, the that table is the source a new table is the destination
	if not source then
		source = destination;
		destination = {};
	else
		Ellyb.Assertions.isType(source, "table", "source");
	end

	for k, v in pairs(source) do
		if (type(v) == "table") then
			destination[k] = {};
			Tables.copy(destination[k], v);
		else
			destination[k] = v;
		end
	end

	return destination;
end

--- Return the table size.
--- Less effective than #table but works for hash table as well (#hashtable don't).
---@param table table
---@return number The size of the table
function Tables.size(table)
	Ellyb.Assertions.isType(table, "table", "table");
	-- We try to use #table first
	local tableSize = #table;
	if tableSize == 0 then
		-- And iterate over it if it didn't work
		for _, _ in pairs(table) do
			tableSize = tableSize + 1;
		end
	end
	return tableSize;
end

--- Remove an object from table
--- Object is search with == operator.
---@param table table The table in which we should remove the object
---@param object any The object that should be removed
---@return boolean Return true if the object is found
function Tables.remove(table, object)
	Ellyb.Assertions.isType(table, "table", "table");
	Ellyb.Assertions.isNotNil(object, "object");

	for index, value in pairs(table) do
		if value == object then
			tremove(table, index);
			return true;
		end
	end
	return false;
end

---Returns a new table that contains the keys of the given table
---@param table table
---@return table A new table that contains the keys of the given table
function Tables.keys(table)
	Ellyb.Assertions.isType(table, "table", "table");
	local keys = {};
	for key, _ in pairs(table) do
		tinsert(keys, key);
	end
	return keys;
end

---Check if a table is empty
---@param table table @ A table to check
---@return boolean isEmpty @ Returns true if the table is empty
function Tables.isEmpty(table)
	Ellyb.Assertions.isType(table, "table", "table");
	return not next(table);
end

-- Create a weak tables pool.
local TABLE_POOL = setmetatable( {}, { __mode = "k" } );

--- Return an already created table, or a new one if the pool is empty
--- It is super important to release the table once you are finished using it!
---@return table
function Tables.getTempTable()
	local t = next(TABLE_POOL);
	if t then
		TABLE_POOL[t] = nil;
		return wipe(t);
	end
	return {};
end

--- Release a temp table.
---@param table
function Tables.releaseTempTable(table)
	Ellyb.Assertions.isType(table, "table", "table");
	TABLE_POOL[table] = true;
end

-- The %q format will automatically quote and escape some special characters (thanks Itarater for the tip)
local VALUE_TO_STRING = "[%q]=%q,"
-- We do not escape the string representation of a table (it was already escaped before!)
local TABLE_VALUE_TO_STRING = "[%q]=%s,"

--- Return a string representation of the table in Lua syntax, suitable for a loadstring()
---@param table table @ A valid table
---@return string stringTable @ A string representation of the table in Lua syntax
function Tables.toString(table)
	Ellyb.Assertions.isType(table, "table", "table");

	local t = "{";
	for key, value in pairs(table) do
		if type(value) == "table" then
			t = t .. format(TABLE_VALUE_TO_STRING, key, Tables.toString(value));
		else
			t = t .. format(VALUE_TO_STRING, key, value);
		end
	end
	t = t .. "}";

	return t;
end

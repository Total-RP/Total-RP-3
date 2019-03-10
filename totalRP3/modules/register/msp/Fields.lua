----------------------------------------------------------------------------------
--- Total RP 3
--- Mary Sue Protocol Field Serializers/Deserializers
--- ---------------------------------------------------------------------------
--- Copyright 2019 Daniel "Meorawr" Yates <me@meorawr.io>
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

local Ellyb = Ellyb(...);

local module = AddOn_TotalRP3.MSP or {};
module.log = module.log or Ellyb.Logger("MSP");

local serializers = {};
local deserializers = {};

function module.SerializeField(field, ...)
	Ellyb.Assertions.isNotNil(field, "field");

	local serializer = serializers[field];
	if not serializer then
		return nil;
	end

	local ok, result = pcall(serializer, ...);
	if not ok then
		local err = result or "<nil error>";
		module.log:Severe(("Error serializing field %q: %s"):format(field, err));
		return nil;
	end

	return result;
end

function module.DeserializeField(field, value)
	Ellyb.Assertions.isNotNil(field, "field");

	local deserializer = deserializers[field];
	if not deserializer then
		return nil;
	end

	local ok, result = pcall(deserializer, value);
	if not ok then
		local err = result or "<nil error>";
		module.log:Severe(("Error deserializing field %q: %s"):format(field, err));
		return nil;
	end

	return result;
end

function module.RegisterField(field, spec)
	Ellyb.Assertions.isNotNil(field, "field");
	Ellyb.Assertions.isType(spec, "table", "spec");

	-- Check the required fields in the spec table and assert their existence.
	Ellyb.Assertions.isNotNil(spec.Serialize, "spec.Serialize");
	Ellyb.Assertions.isNotNil(spec.Deserialize, "spec.Deserialize");

	-- Verify the field doesn't already exist.
	if serializers[field] or deserializers[field] then
		error(("Field %q has already been registered"):format(field), 2);
	end

	serializers[field] = spec.Serialize;
	deserializers[field] = spec.Deserialize;
end

function module.TryRegisterField(...)
	if not pcall(module.RegisterField, ...) then
		return false;
	end

	return true
end

AddOn_TotalRP3.MSP = module;

---
--- Serializer/Deserializer Implementations
---

-- The PS field is serialized to the form:
--    attr  := ident "=" quoted-value
--    trait := "[trait" { " " attr } "]"
--
-- Where `ident` is just an ASCII string identifier like "name" or "icon"
-- with support for limited special characters (-, _), and `quoted-value` is
-- a value wrapped in double quotes.
--
-- For now, there's no support for escaping " characters in quoted-values`.
--
-- Example:
--    [trait id="3" value="0.75"]
--    [trait value="0.4" left-name="My Left Trait" right-name="My Right Trait"]
--
-- A newline may be present between individual trait pairs but isn't required.
--
-- In terms of attributes, the following are supported:
--    id:    Numeric identifier for a standard trait.
--    value: [0-1] floating point number representing the strength of this trait.
--    (left|right)-name:  Name of a custom trait.
--    (left|right)-icon:  Name of a custom icon for this trait.
--    (left|right)-color: Hexadecimal color code for this trait.

module.TryRegisterField("PS", {
	Serialize = function(traits)
		local out = Ellyb.Tables.getTempTable();
		for traitIndex = 1, #traits do
			-- Start writing out this trait.
			local trait = traits[traitIndex];
			table.insert(out, "[trait");

			-- Support both old and new range values.
			if trait.V2 then
				table.insert(out, ([[ value="%f"]]):format(trait.V2 / 20));
			elseif trait.VA then
				table.insert(out, ([[ value="%f"]]):format(trait.VA / 6));
			else
				-- Placeholder value so nothing breaks in odd circumstances.
				table.insert(out, [[ value="0.5"]]);
			end

			-- If there's an ID it's a built-in trait, otherwise it's custom
			-- and thus needs the name/icon/color stuff.
			if trait.ID then
				table.insert(out, ([[ id="%d"]]):format(trait.ID));
			else
				-- We'll strip " from the name for simplicity if present.
				local leftName = (trait.LT or ""):gsub([["]], "");
				local leftIcon = trait.LI or "";

				table.insert(out, ([[ left-name=%q]]):format(leftName));
				table.insert(out, ([[ left-icon=%q]]):format(leftIcon));
				table.insert(out, ([[ left-color="%02x%02x%02x"]]):format(
					(trait.LC.r or 1) * 255,
					(trait.LC.g or 1) * 255,
					(trait.LC.b or 1) * 255
				));

				local rightName = (trait.RT or ""):gsub([["]], "");
				local rightIcon = trait.RI or "";

				table.insert(out, ([[ right-name=%q]]):format(rightName));
				table.insert(out, ([[ right-icon=%q]]):format(rightIcon));
				table.insert(out, ([[ right-color="%02x%02x%02x"]]):format(
					(trait.RC.r or 1) * 255,
					(trait.RC.g or 1) * 255,
					(trait.RC.b or 1) * 255
				));
			end

			-- Close off the trait line and concat the contents.
			table.insert(out, "]");
			out[traitIndex] = table.concat(out, "", traitIndex);

			-- Remove the pieces from the table in reverse order. The idea
			-- is that out[traitIndex] is our full trait string and everything
			-- afterwards is nil.
			for i = #out, traitIndex + 1, -1 do
				out[i] = nil;
			end
		end

		-- Join all the resulting traits into a single string.
		local traitString = table.concat(out, "");
		Ellyb.Tables.releaseTempTable(out);

		module.DeserializeField("PS", traitString);
		return traitString;
	end,

	Deserialize = function(value)
		-- Shortcut cases where a profile hasn't given us a thing.
		if not value or type(value) ~= "string" then
			return nil;
		end

		-- We'll store the resulting trait structures here.
		local traits = {};

		-- Parse each [trait {attr...}] block.
		for trait in value:gmatch("%[trait [^%]]-%]") do
			local struct = {};

			-- And then each attr="value" pair.
			for key, value in trait:gmatch("([%w_-]+)=\"([^\"]*)\"") do
				if key == "id" then
					struct.ID = tonumber(value);
				elseif key == "value" then
					struct.V2 = math.floor(tonumber(value) * 20);
				elseif key == "left-name" then
					struct.LT = value;
				elseif key == "left-icon" then
					struct.LI = value;
				elseif key == "left-color" then
					local r, g, b = Ellyb.ColorManager.hexaToNumber(value);
					struct.LC = { r = r, g = g, b = b };
				elseif key == "right-name" then
					struct.RT = value;
				elseif key == "right-icon" then
					struct.RI = value;
				elseif key == "right-color" then
					local r, g, b = Ellyb.ColorManager.hexaToNumber(value);
					struct.RC = { r = r, g = g, b = b };
				end
			end

			-- If we get a trait that doesn't have either an ID or both
			-- name fields, or is missing a value, we'll ignore it.
			if (struct.ID or (struct.LT and struct.RT)) and struct.V2 then
				table.insert(traits, struct);
			end
		end

		return traits;
	end,
});

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

--
-- Public API Functions
--

function AddOn_TotalRP3.RegisterMacroConditional(name, conditional)
	if type(name) ~= "string" then
		error("bad argument #1 to 'RegisterMacroConditional': expected string", 2);
	elseif type(conditional) ~= "table" or type(conditional.Evaluate) ~= "function" then
		-- 'conditional' must extend TRP3_MacroConditionalMixin.
		error("bad argument #2 to 'RegisterMacroConditional': expected macro conditional object", 2);
	end

	local ok, err = TRP3_Automation:RegisterMacroConditional(name, conditional);

	if not ok then
		-- Raise a soft error but don't die. The use of securecall here is to
		-- permit debuglocals to work within the invoked error handler, which
		-- should assist debugging conditional conflicts.

		securecallfunction(error, err);
	end

	return ok, err;
end

function AddOn_TotalRP3.GetMacroConditionals()
	return TRP3_Automation:GetMacroConditionals();
end

function AddOn_TotalRP3.GetMacroConditionalByName(name)
	if type(name) ~= "string" then
		error("bad argument #1 to 'GetMacroConditionalByName': expected string", 2);
	end

	return TRP3_Automation:GetMacroConditionalByName(name);
end

function AddOn_TotalRP3.ParseMacroOption(options)
	if type(options) ~= "string" then
		error("bad argument #1 to 'ParseMacroOption': expected string", 2);
	end

	return TRP3_Automation:ParseMacroOption(options);
end

--
-- TRP3_MacroConditionalMixin provides the base method implementations for
-- macro conditionals.
--
-- New conditionals should extend this mixin and at-least provide their own
-- implementation of the 'Evaluate' method.
--
-- This mixin forms part of the public API; objects that derive this mixin
-- can be passed to AddOn_TotalRP3.RegisterMacroConditional.
--

TRP3_MacroConditionalMixin = {};

function TRP3_MacroConditionalMixin:Evaluate(name, data)  -- luacheck: no unused (abstract signature)
	-- Implement in a derived mixin to return true if conditions are met.
	--
	-- The 'name' parameter will be the name of the executed conditional
	-- alias, and 'data' will be the string segment after an optional colon
	-- that follows the conditional name.
	--
	-- For example, the conditional string "[rpstatus:foo]" would have the
	-- 'name' set to "rpstatus" and 'data' set to "foo".
	--
	-- For conditional strings with no data - like "[ooc]" - the 'data' value
	-- will be an empty string.

	return false;
end

--
-- Private Implementation
--
-- Do not call these functions from code external to the addon; this may
-- change without notice.
--
-- The module is exported as a global for convenient debug access.
--

TRP3_Automation = TRP3_Addon:NewModule("Automation", {
	conditionalsByName = {},
});

function TRP3_Automation:RegisterMacroConditional(name, conditional)
	if string.find(name, "^no") then
		return false, string.format("macro conditional name has a reserved prefix (no): %s", name);
	elseif self.conditionalsByName[name] then
		return false, string.format("macro conditional already exists: %s", name);
	end

	self.conditionalsByName[name] = conditional;

	return true;
end

function TRP3_Automation:GetMacroConditionals()
	local shallow = true;
	return CopyTable(self.conditionalsByName, shallow);
end

function TRP3_Automation:GetMacroConditionalByName(name)
	return self.conditionalsByName[name];
end

-- Options parsing is handled by SecureCmdOptionParse to avoid re-implementing
-- parsing logic.
--
-- For custom conditionals our work is limited to scanning a given options
-- string to find conditions, evaluating them, and then replacing their
-- tokens in the option string with Blizzard-provided states that are known
-- ahead-of-time to evaluate to true or false as necessary.
--
-- Evaluation of a conditional occurs once per unique combination of a
-- conditional name and associated data string, eg. "[ooc][ooc]" would only
-- evaluate the "ooc" condition a single time and will cache the result.

local function EvaluateMacroConditions(conditionals, options)
	local TRUE_STATE = SecureCmdOptionParse("[combat]combat;nocombat");
	local FALSE_STATE = SecureCmdOptionParse("[nocombat]combat;nocombat");

	local function EvaluateSingleCondition(text)
		local name, data = string.split(":", text, 2);
		local invert = false;

		name = string.trim(name or "");
		data = string.trim(data or "");

		if string.find(name, "^no") then
			name = string.trim(string.sub(name, 3));
			invert = true;
		end

		local condition = conditionals[name];

		if not condition then
			return;  -- Leave unmodified; SecureCmdOptionParse will tell the user.
		end

		-- Errors in evaluation are soft ones; if one occurs we'll treat the
		-- condition as if it were in a false state.

		local ok, state = xpcall(condition.Evaluate, CallErrorHandler, condition, name, data);

		if not ok then
			state = false;
		end

		if invert then
			state = not state;
		end

		return state and TRUE_STATE or FALSE_STATE;
	end

	local cache = setmetatable({}, {
		__index = function(self, text)
			self[text] = EvaluateSingleCondition(text);
			return rawget(self, text);
		end,
	});

	local function EvaluateConditionBlock(text)
		text = string.sub(text, 2, -2);
		return "[" .. string.gsub(text, "[^,%]]+", cache) .. "]";
	end

	return string.gsub(options, "%b[]", EvaluateConditionBlock);
end

function TRP3_Automation:ParseMacroOption(options)
	options = EvaluateMacroConditions(self.conditionalsByName, options);
	return SecureCmdOptionParse(options);
end

--
-- Built-in conditionals
--
-- These can serve as a reference case for any custom conditionals anyone
-- else wants to provide.
--

local RoleplayStatusConditional = CreateFromMixins(TRP3_MacroConditionalMixin);

function RoleplayStatusConditional:Evaluate(name, data)
	local player = AddOn_TotalRP3.Player.GetCurrentUser();
	local requiredStatus;

	if name ~= "rpstatus" then
		data = name;
	end

	if data == "ooc" then
		requiredStatus = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.OUT_OF_CHARACTER;
	elseif data == "ic" then
		requiredStatus = AddOn_TotalRP3.Enums.ROLEPLAY_STATUS.IN_CHARACTER;
	else
		SendSystemMessage(string.format(L.MACRO_RPSTATUS_INVALID, data));
		return false;
	end

	return player:GetRoleplayStatus() == requiredStatus;
end

AddOn_TotalRP3.RegisterMacroConditional("ooc", RoleplayStatusConditional);
AddOn_TotalRP3.RegisterMacroConditional("ic", RoleplayStatusConditional);
AddOn_TotalRP3.RegisterMacroConditional("rpstatus", RoleplayStatusConditional);

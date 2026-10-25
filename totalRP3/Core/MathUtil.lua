-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_MathUtil = {};

--- Replaces signed numeric zero with positive zero, leaving other values unchanged.
--- @param value number
function TRP3_MathUtil.NormalizeZero(value)
	-- Lua interns equal numeric constants within a function, keeping the
	-- first parsed zero's sign. Do not compare against -0; the assignment
	-- would then reuse -0 despite being written as 0.

	if value == 0 then
		value = 0;
	end

	return value;
end

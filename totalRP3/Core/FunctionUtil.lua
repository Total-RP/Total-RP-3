-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_FunctionUtil = {};

--- Returns a closure that when first invoked will start a timer of duration
--- `timeout`. When this timer has elapsed, the supplied callback will be
--- invoked.
---
--- Repeated calls to the closure will reset the timeout back to zero, in
--- effect delaying execution of the callback.
---
--- @param timeout number
--- @param callback function
function TRP3_FunctionUtil.Debounce(timeout, callback)
	local calls = 0;

	local function Decrement()
		calls = calls - 1;

		if calls == 0 then
			callback();
		end
	end

	return function()
		C_Timer.After(timeout, Decrement);
		calls = calls + 1;
	end
end

--- Returns a closure that when first invoked will immediately execute the
--- supplied callback, and starts a timer of duration `timeout`. Until the
--- timer has elapsed, future invocations will do nothing.
---
--- @param timeout number
--- @param callback function
function TRP3_FunctionUtil.Throttle(timeout, callback)
	local callable = true;

	local function Reset()
		callable = true;
	end

	return function()
		if callable then
			C_Timer.After(timeout, Reset);
			callable = false;
			callback();
		end
	end
end

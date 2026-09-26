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

--- Returns a closure that lazily invokes the supplied callback once and returns
--- the same result for every subsequent invocation.
---
--- @param callback function
function TRP3_FunctionUtil.GetOrCreate(callback)
	local value;

	return function()
		if value == nil then
			value = callback();
		end

		return value;
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

--- Returns a closure that reports when an adaptive time budget has elapsed.
--- The budget grows with the time since the previous check, up to a
--- configured maximum.
---
--- The returned closure should be called from the operation being budgeted;
--- `true` indicates that the caller should yield or otherwise pause its work.
---
---@class TRP3.AdaptiveTimeBudgetOptions
---@field minimumBudgetSeconds number Minimum slice budget.
---@field maximumBudgetSeconds number Maximum slice budget.
---@field catchUpRatio number Fraction of the idle interval to reclaim.
---@field checkInterval integer Clock-check interval.
---
---@param options TRP3.AdaptiveTimeBudgetOptions?
---@return fun(): boolean
function TRP3_FunctionUtil.CreateAdaptiveTimeBudgetChecker(options)
	options = options or {};

	local minimumBudgetSeconds = options.minimumBudgetSeconds or 0.008;
	local maximumBudgetSeconds = options.maximumBudgetSeconds or 0.1;
	local catchUpRatio = options.catchUpRatio or 0.25;
	local checkInterval = options.checkInterval or 64;
	local operationCount = 0;
	local sliceStartTime;
	local lastYieldTime = GetTimePreciseSec();
	local sliceBudgetSeconds;

	return function()
		local currentTime = GetTimePreciseSec();
		if not sliceStartTime then
			sliceStartTime = currentTime;
			sliceBudgetSeconds = math.min(maximumBudgetSeconds, math.max(minimumBudgetSeconds, (currentTime - lastYieldTime) * catchUpRatio));
		end

		operationCount = operationCount + 1;
		if operationCount < checkInterval then
			return false;
		end

		operationCount = 0;
		if currentTime - sliceStartTime < sliceBudgetSeconds then
			return false;
		end

		lastYieldTime = currentTime;
		sliceStartTime = nil;
		return true;
	end;
end

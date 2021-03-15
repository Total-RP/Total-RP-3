---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Threads then
	return
end

local Threads = {};
Ellyb.Threads = Threads;

local DEFAULT_TICKER = 0.025;
---@type Thread[]
local threads = {};
local ThreadsFrame = CreateFrame("FRAME");

---Execute the given function in a separate thread using coroutines.
---The function will receive a Thread and should call Thread:Yield() to pause its execution.
---The thread will automatically resume 0.025 seconds after being paused.
---@param func function
function Threads.run(func)
	local thread = Ellyb.Thread();
	table.insert(threads, thread);
	ThreadsFrame:RegisterOnUpdate();
	thread:Execute(function()
		func(thread);
	end)
end

--- Check if the time interval has reached a new tick
---@return boolean True if a new interval was reached
function ThreadsFrame:CheckInterval()
	self.elapsed = (self.elapsed or 0) + GetTimePreciseSec();
	if self.elapsed > DEFAULT_TICKER then
		self.elapsed = 0;
		return true;
	end
	return false;
end

--- OnUpdate script to resume all threads when a new tick interval has been reached
function ThreadsFrame:OnUpdate()
	-- Check if we have reached a new interval tick
	if self:CheckInterval() then
		-- Go through all current thread
		for index, thread in pairs(threads) do

			if thread:HasFinished() then
				-- If this thread has finished, remove it from the list
				threads[index] = nil;
			elseif thread:IsSuspended() then
				-- If the thread was suspended we resume it
				thread:Resume();
			end
		end
		-- Unregister the OnUpdate script if we have no active thread
		self:UnregisterOnUpdateIfNoMoreThreads();
	end
end

--- Check if there are no more threads left and unregister the OnUpdate script then, to preserve performances
function ThreadsFrame:UnregisterOnUpdateIfNoMoreThreads()
	if #threads < 1 then
		self:SetScript("OnUpdate", nil);
	end
end

--- Register the OnUpdate script, if it wasn't already registered before
function ThreadsFrame:RegisterOnUpdate()
	if not self:GetScript("OnUpdate") then
		self:SetScript("OnUpdate", self.OnUpdate);
	end
end

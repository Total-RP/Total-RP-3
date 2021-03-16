---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Thread then
	return
end

---@class Thread : MiddleClass_Class
local Thread = Ellyb.Class("Thread");
Ellyb.Thread = Thread;

---@type {thread: thread}[]
local private = Ellyb.getPrivateStorage();

--- Execute the given function inside the thread.
--- The given function should use `Thread:Yield()` to pause its execution
---@param func function
function Thread:Execute(func)
	private[self].thread = coroutine.create(func);
end

function Thread:GetStatus()
	return coroutine.status(private[self].thread);
end

function Thread:IsRunning()
	return self:GetStatus() == "running";
end

function Thread:IsSuspended()
	return self:GetStatus() == "suspended";
end

function Thread:HasFinished()
	return self:GetStatus() == "dead";
end

--- Pause the current thread execution
function Thread:Yield()
	coroutine.yield();
end

--- Resume the thread execution
function Thread:Resume()
	coroutine.resume(private[self].thread);
end

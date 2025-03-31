-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local Timer = {};

function Timer:__init()
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.listener = GenerateClosure(self.OnElapsed, self);
	self.handle = nil;
end

function Timer:OnElapsed()
	self.callbacks:Fire("OnElapsed", self);
end

function Timer:Start(interval, iterations)
	self:Cancel();

	if not iterations or iterations == 1 then
		self.handle = C_Timer.NewTimer(interval, self.listener);
	else
		self.handle = C_Timer.NewTicker(interval, self.listener, iterations);
	end
end

function Timer:Cancel()
	if not self.handle then
		return;
	end

	self.handle:Cancel();
	self.handle = nil;
end

function TRP3_API.CreateTimer()
	local timer = TRP3_API.AllocateObject(Timer);
	timer:__init();
	return timer;
end

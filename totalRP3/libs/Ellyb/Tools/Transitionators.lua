---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Transitionator then
	return
end

-- Lua imports
local pairs = pairs;
local insert = table.insert;

-- WoW Imports
local GetTime = GetTime;

---@class Transitionator : Object
local Transitionator, _p = Ellyb.Class("Transitionator");

---@type Transitionator[]
local transitionators = {};

local TransitionatorsFrame = CreateFrame("FRAME");
TransitionatorsFrame:Show();

TransitionatorsFrame:SetScript("OnUpdate", function()
	for _, transitionator in pairs(transitionators) do
		if transitionator:ShouldBeUpdated() then
			transitionator:Tick();
		end
	end
end)

function Transitionator:initialize()
	_p[self] = {};

	_p[self].value = 0;
	_p[self].shouldBeUpdated = false;

	insert(transitionators, self);
end

function Transitionator:ShouldBeUpdated()
	return _p[self].shouldBeUpdated;
end

function Transitionator:Tick()
	local elapsed = GetTime() - _p[self].timeStarted;
	local currentValue = _p[self].customEasing(elapsed, _p[self].startValue, _p[self].change, _p[self].overTime, unpack(_p[self].customEasingArgs));
	if elapsed >= _p[self].overTime then
		_p[self].shouldBeUpdated = false;
		_p[self].callback(_p[self].endValue);
	else
		_p[self].callback(currentValue);
	end
end

function Transitionator:RunValue(startValue, endValue, overTime, callback, customEasing, ...)
	if not endValue or endValue == startValue then
		return callback(startValue);
	end

	if not customEasing then
		customEasing = Ellyb.Easings.outQuad;
	end

	_p[self].startValue = startValue;
	_p[self].endValue = endValue;
	_p[self].change = endValue - startValue;
	_p[self].overTime = overTime;
	_p[self].callback = callback;
	_p[self].customEasing = customEasing;
	_p[self].customEasingArgs = {...};

	_p[self].value = startValue;
	_p[self].timeStarted = GetTime();
	_p[self].shouldBeUpdated = true;
end

Ellyb.Transitionator = Transitionator;
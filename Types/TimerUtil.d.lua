---@meta

---@class TRP3.TimedSignalMap
local TimedSignalMap = {};

---@param callback fun()
---@return integer key
function TimedSignalMap:RegisterCallback(callback) end

---@param key integer
---@param secondsFromNow number
function TimedSignalMap:SignalAfter(key, secondsFromNow) end

---@param key integer
---@param time number
function TimedSignalMap:SignalAt(key, time) end

---@param key integer
function TimedSignalMap:CancelSignal(key) end

---@class TimerUtil
TimerUtil = {};

---@return TRP3.TimedSignalMap
function TimerUtil.CreateTimedSignalCallbackMap() end

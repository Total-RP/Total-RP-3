---@meta

---@class TRP3.RegisterListRefreshProgress
---@field found integer
---@field searched integer
---@field total integer

---@class TRP3.RegisterListRefreshTask
local RegisterListRefreshTask = {};

---@param owner TRP3.CallbackOwner
---@param event "OnStateChanged"
---@param callback fun(event: "OnStateChanged", state: TRP3.RegisterListRefreshTaskState)|string?
function RegisterListRefreshTask.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnProgressChanged"
---@param callback fun(event: "OnProgressChanged", progress: TRP3.RegisterListRefreshProgress)|string?
function RegisterListRefreshTask.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnStateChanged" | "OnProgressChanged"
function RegisterListRefreshTask.UnregisterCallback(owner, event) end

---@param owner TRP3.CallbackOwner
function RegisterListRefreshTask.UnregisterAllCallbacks(owner) end

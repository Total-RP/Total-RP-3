---@meta

---@class TRP3.IconBrowserModel
local IconBrowserModel = {};

---@param owner TRP3.CallbackOwner
---@param event "OnModelUpdated"
---@param callback fun(event: "OnModelUpdated")|string?
function IconBrowserModel.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnModelUpdated"
function IconBrowserModel.UnregisterCallback(owner, event) end

---@param owner TRP3.CallbackOwner
function IconBrowserModel.UnregisterAllCallbacks(owner) end

---@class TRP3.IconBrowserFilterModel : TRP3.IconBrowserModel
local IconBrowserFilterModel = {};

---@param owner TRP3.CallbackOwner
---@param event "OnModelUpdated"
---@param callback fun(event: "OnModelUpdated")|string?
function IconBrowserFilterModel.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnSearchProgressChanged"
---@param callback fun(event: "OnSearchProgressChanged", progress: TRP3.IconBrowserSearchProgress)|string?
function IconBrowserFilterModel.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnSearchStateChanged"
---@param callback fun(event: "OnSearchStateChanged", state: "running" | "finished")|string?
function IconBrowserFilterModel.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnSearchProgressChanged"
function IconBrowserFilterModel.UnregisterCallback(owner, event) end

---@class TRP3.IconBrowserFilterTask
local IconBrowserSearchTask = {};

---@param owner TRP3.CallbackOwner
---@param event "OnProgressChanged"
---@param callback fun(event: "OnProgressChanged", progress: TRP3.IconBrowserSearchProgress)|string?
function IconBrowserSearchTask.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnResultsChanged"
---@param callback fun(event: "OnResultsChanged", results: integer[])|string?
function IconBrowserSearchTask.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnStateChanged"
---@param callback fun(event: "OnStateChanged", state: "running" | "finished")|string?
function IconBrowserSearchTask.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnStateChanged" | "OnProgressChanged" | "OnResultsChanged"
function IconBrowserSearchTask.UnregisterCallback(owner, event) end

---@param owner TRP3.CallbackOwner
function IconBrowserSearchTask.UnregisterAllCallbacks(owner) end

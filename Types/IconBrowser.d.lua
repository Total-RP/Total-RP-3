---@meta

---@class TRP3.AbstractIconBrowserModel
local AbstractIconBrowserModel = {};

---@return integer count
function AbstractIconBrowserModel:GetIconCount() end

---@param name string
---@return integer? index
function AbstractIconBrowserModel:GetIconIndex(name) end

---@param index integer
---@return TRP3.IconBrowserModelItem? data
function AbstractIconBrowserModel:GetIconInfo(index) end

---@param index integer
---@return string? name
function AbstractIconBrowserModel:GetIconName(index) end

---@param owner TRP3.CallbackOwner
---@param event "OnModelUpdated"
---@param callback fun(event: "OnModelUpdated")|string?
function AbstractIconBrowserModel.RegisterCallback(owner, event, callback) end

---@param owner TRP3.CallbackOwner
---@param event "OnModelUpdated"
function AbstractIconBrowserModel.UnregisterCallback(owner, event) end

---@param owner TRP3.CallbackOwner
function AbstractIconBrowserModel.UnregisterAllCallbacks(owner) end

---@class TRP3.AbstractIconBrowserProxyModel : TRP3.AbstractIconBrowserModel
local AbstractIconBrowserProxyModel = {};

---@return TRP3.AbstractIconBrowserModel
function AbstractIconBrowserProxyModel:GetSourceModel() end

---@param proxyIndex integer
---@return integer? sourceIndex
function AbstractIconBrowserProxyModel:GetSourceIndex(proxyIndex) end

---@param sourceIndex integer
---@return integer? proxyIndex
function AbstractIconBrowserProxyModel:GetProxyIndex(sourceIndex) end

---@class TRP3.IconBrowserFilterModel
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

---@class TRP3.IconBrowserSearchTask
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

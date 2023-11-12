---@meta

--- An object that acts as the owning handle of a callback registration.
---@alias TRP3.CallbackOwner string|table|thread

--- Interface for objects that allow untyped callback event registrations,
--- mirroring the interface exposed by CallbackHandler-1.0.
---
---@class TRP3.CallbackRegistry
local CallbackRegistry = {};

---@generic T: string
---@param owner TRP3.CallbackOwner
---@param event T
---@param callback fun(event: T, ...)|string?
function CallbackRegistry.RegisterCallback(owner, event, callback) end

---@generic T: string, V
---@param owner TRP3.CallbackOwner
---@param event T
---@param callback fun(arg1: V, event: T, ...)|string?
---@param arg1 V
function CallbackRegistry.RegisterCallback(owner, event, callback, arg1) end

---@param owner TRP3.CallbackOwner
---@param event string
function CallbackRegistry.UnregisterCallback(owner, event) end

---@param owner TRP3.CallbackOwner
function CallbackRegistry.UnregisterAllCallbacks(owner) end

--- Interface for objects that allow dispatching of untyped callback events,
--- mirroring the interface exposed by CallbackHandler-1.0.
---@class TRP3.CallbackDispatcher
local CallbackDispatcher = {};

---@param event string
---@param ... any
function CallbackDispatcher:Fire(event, ...) end

---@param object table
---@return TRP3.CallbackDispatcher callbacks
function TRP3_API.InitCallbackRegistry(object) end

---@param object table
---@param events string[] | { [string]: string }
---@return TRP3.CallbackDispatcher callbacks
function TRP3_API.InitCallbackRegistryWithEvents(object, events) end

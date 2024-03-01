-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

--
-- Implementation notes
--
-- Queries are individual data items that are transferred as part of a profile
-- exchange, such as the characteristics, about page, etc. A query has
-- two states - "pending" for when the query has been sent and is awaiting
-- a response, and "completed" when the data for that query is fully received.
--
-- Requests model a set of queries all sent to a single target player. A
-- request has two states - "active" if there's any queries in the set that
-- are pending, and "inactive" if there's either no queries in the set or
-- if all queries in the set are "completed".
--
-- The request tracker never holds requests in the "inactive" state; if
-- completion of a query would transition a request to the inactive state
-- then it is fed to the garbage collector - thus, the absence of a request
-- implicitly infers the "inactive" state.
--
-- Requests are grouped into timeout buckets based upon comms activity; when
-- a query is issued the request will be placed in the newest timeout bucket.
--
-- When any comms message is received from a player, any active requests for
-- that player will refresh the timeout, moving it into the newest timeout
-- bucket.
--
-- Periodically, timeout buckets are rotated. Any requests in the oldest
-- bucket are considered to be timed out, and will transition to the
-- "inactive" state and are immediately discarded.
--
-- Timeout buckets are implemented as intrusively linked lists, with each
-- request in the bucket being a list node.
--
-- Timeout buckets are themselves stored in a ring buffer of a fixed capacity,
-- with the newest bucket being stored at the tail index, and the oldest
-- bucket one place after the tail.
--

---@class (exact) TRP3_Register.RequestTrackerListNode
---@field package next TRP3_Register.RequestTrackerListNode
---@field package prev TRP3_Register.RequestTrackerListNode
local RequestTrackerListNode = {};

---@protected
function RequestTrackerListNode:__init()
	self.next = self;
	self.prev = self;
end

function RequestTrackerListNode:Unlink()
	self.prev.next = self.next;
	self.next.prev = self.prev;
	self.next = self;
	self.prev = self;
end

function RequestTrackerListNode:LinkBefore(next)
	self.prev.next = self.next;
	self.next.prev = self.prev;
	self.next = next;
	self.prev = next.prev;
	self.prev.next = self;
	self.next.prev = self;
end

---@class (exact) TRP3_Register.RequestTrackerList
---@field private head TRP3_Register.RequestTrackerListNode
local RequestTrackerList = {};

---@private
function RequestTrackerList:__init()
	self.head = TRP3_API.CreateObject(RequestTrackerListNode);
end

function RequestTrackerList:PopFront()
	local node = self:GetNext(self.head);

	if node then
		node:Unlink();
	end

	return node;
end

---@param node TRP3_Register.RequestTrackerListNode
function RequestTrackerList:PushBack(node)
	node:LinkBefore(self.head);
end

---@param node TRP3_Register.RequestTrackerListNode?
function RequestTrackerList:GetNext(node)
	node = (node or self.head).next;

	if node == self.head then
		node = nil;
	end

	return node;
end

local function CreateRequestTrackerList()
	return TRP3_API.CreateObject(RequestTrackerList);
end

---@class (exact) TRP3_Register.RequestTrackerEntry : TRP3_Register.RequestTrackerListNode
---@field package key string
---@field private queries { [string]: true }
local RequestTrackerEntry = CreateFromMixins(RequestTrackerListNode);

function RequestTrackerEntry:__init(key)
	RequestTrackerListNode.__init(self);
	self.key = key;
	self.queries = {}
end

function RequestTrackerEntry:IsActive()
	return next(self.queries) ~= nil;
end

function RequestTrackerEntry:AddQuery(query)
	self.queries[query] = true;
end

function RequestTrackerEntry:RemoveQuery(query)
	self.queries[query] = nil;
end

function RequestTrackerEntry:ContainsQuery(query)
	return self.queries[query] == true;
end

---@param key string
local function CreateRequestTrackerEntry(key)
	return TRP3_API.CreateObject(RequestTrackerEntry, key);
end

---@class (exact) TRP3_Register.RequestTracker
---@field private requests { [string]: TRP3_Register.RequestTrackerEntry }
---@field private timeouts TRP3_Register.RequestTrackerList[]
---@field private tail integer Timeout bucket index for new/updated requests.
local RequestTracker = {};

---@package
function RequestTracker:__init()
	self.requests = {};
	self.timeouts = {};
	self.tail = 5;

	for i = 1, self.tail do
		self.timeouts[i] = CreateRequestTrackerList();
	end
end

---@param key string
function RequestTracker:IsActive(key)
	-- Invariant; inactive requests are removed upon completion and timeout.
	return self.requests[key] ~= nil;
end

---@param key string
function RequestTracker:IsPending(key, query)
	local request = self.requests[key];
	return request and request:ContainsQuery(query);
end

---@param key string
---@param query string
function RequestTracker:MarkPending(key, query)
	local request = self.requests[key] or CreateRequestTrackerEntry(key);
	local timeout = self.timeouts[self.tail];

	request:AddQuery(query);
	timeout:PushBack(request);
	self.requests[key] = request;
end

---@param key string
function RequestTracker:MarkActive(key)
	local request = self.requests[key];
	local timeout = self.timeouts[self.tail];

	if request then
		timeout:PushBack(request);
	end
end

---@param key string
---@param query string
function RequestTracker:MarkCompleted(key, query)
	local request = self.requests[key];

	if request then
		request:RemoveQuery(query);
	end

	if request and not request:IsActive() then
		request:Unlink();
		self.requests[key] = nil;
	end
end

function RequestTracker:PruneInactive()
	local head = Wrap(self.tail + 1, #self.timeouts);
	local timeout = self.timeouts[head];
	local request = timeout:PopFront();
	local count = 0;

	---@cast request TRP3_Register.RequestTrackerEntry?

	while request do
		self.requests[request.key] = nil;
		request:Unlink();
		request = timeout:PopFront();
		count = count + 1;
	end

	self.tail = head;
	return count;
end

function TRP3_API.register.HasActiveRequest(target)
	return RequestTracker:IsActive(target);
end

function TRP3_API.register.HasActiveRequestForData(target, type)
	return RequestTracker:IsPending(target, type);
end

---@param target string
local function NotifyRequestStateChanged(target)
	TRP3_Addon:TriggerEvent("REGISTER_REQUEST_STATE_CHANGED", target);
end

local function NotifyRequestsPruned()
	TRP3_Addon:TriggerEvent("REGISTER_REQUEST_STATE_CHANGED", nil);
end

local function OnCommMessageReceived(_, sender)
	RequestTracker:MarkActive(sender);
end

local function OnRegisterDataRequested(_, target, type)
	RequestTracker:MarkPending(target, type);
	NotifyRequestStateChanged(target);
end

local function OnRegisterDataReceived(_, target, type)
	RequestTracker:MarkCompleted(target, type);
	NotifyRequestStateChanged(target);
end

local function OnTickerElapsed()
	if RequestTracker:PruneInactive() > 0 then
		NotifyRequestsPruned();
	end
end

RequestTracker:__init();
TRP3_Addon.RegisterCallback(RequestTracker, "COMM_MESSAGE_RECEIVED", OnCommMessageReceived);
TRP3_Addon.RegisterCallback(RequestTracker, "REGISTER_DATA_REQUESTED", OnRegisterDataRequested);
TRP3_Addon.RegisterCallback(RequestTracker, "REGISTER_DATA_RECEIVED", OnRegisterDataReceived);
C_Timer.NewTicker(15, OnTickerElapsed);

-- Exported for any runtime debug inspection; do not touch otherwise.
TRP3_RequestTracker = RequestTracker;

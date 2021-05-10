--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

-- Enumeration of priorities attributable to any single request. Anything
-- aside from the "Normal" priority is considered a "priority request" and
-- will gain queue perks.
--
-- Note that the values assigned to the keys in this enumeration are used
-- for sorting; lower values have a higher priority.
local RequestPriority =
{
	Friend = 1,  -- Priority used for friended units.
	Group = 2,   -- Priority used for grouped units.
	Guild = 3,   -- Priority used for guild members.
	Nearby = 4,  -- Priority used for nearby units.
	Normal = 5,  -- Default priority for other units.
};

local function GetOrCreateTable(t, key)
	if t[key] ~= nil then
		return t[key];
	end

	t[key] = {};
	return t[key];
end

local function GetRequestPriority(requestInfo)
	if requestInfo.isFriend then
		return RequestPriority.Friend;
	elseif UnitInParty(requestInfo.unit) or UnitInRaid(requestInfo.unit) then
		return RequestPriority.Group;
	elseif requestInfo.isGuildMember then
		return RequestPriority.Guild;
	elseif requestInfo.isNearby then
		return RequestPriority.Nearby;
	else
		return RequestPriority.Normal;
	end
end

local function IsRequestEligibleToSend(requestInfo)
	return GetTime() >= requestInfo.eligibleAt;
end

local function RequestSortPredicate(requestInfoA, requestInfoB)
	do  -- Priority check
		local requestPriorityA = requestInfoA.priority;
		local requestPriorityB = requestInfoB.priority;

		if requestPriorityA < requestPriorityB then
			return true;
		elseif requestPriorityB < requestPriorityA then
			return false;
		end
	end

	do  -- Eligibility check
		local requestEligibilityA = requestInfoA.eligibleAt;
		local requestEligibilityB = requestInfoB.eligibleAt;

		if requestEligibilityA < requestEligibilityB then
			return true;
		elseif requestEligibilityB < requestEligibilityA then
			return false;
		end
	end

	-- Everything is identical so go on insertion order.
	return requestInfoA.order < requestInfoB.order;
end

TRP3_NamePlatesRequestQueue = {};

-- Period in fractional seconds at which the request queue and slot cooldowns
-- are processed.
--
-- Lower values will be more responsive but may slightly increase CPU usage.
TRP3_NamePlatesRequestQueue.ProcessRate = 0.5;

-- Time in fractional seconds that a unit must be enqueued for before the
-- request for its nameplate will be dispatched.
--
-- Lower values will cause more requests to be sent on average; higher values
-- reduce "one hit wonders" for people you might quickly see on-screen for
-- a moment and then never again.
TRP3_NamePlatesRequestQueue.PreSubmitCooldown = 3;

-- Time in fractional seconds that must pass before a request for a character
-- that was already previously requested can be re-issued.
--
-- Higher values mean that if we see the nameplate for the same character
-- repeatedly within a session, we won't re-download any associated data
-- for a while. Lower values will cause such cases to be more responsive
-- but could significantly increase bandwidth consumption.
TRP3_NamePlatesRequestQueue.PostSubmitCooldown = 300;

-- Number of request "slots" that the system has. Each request in the queue
-- consumes a slot when sent, and slots are regained based on a recharge
-- period that must elapse.
--
-- A higher slot count means that we can burst-request more nameplates in a
-- single go, and a lower slot count will reduce the number of requests that
-- can be issued within a close time period.
TRP3_NamePlatesRequestQueue.SlotLimit = 5;

-- Period in fractional sections that request slots will be regained at.
--
-- Lower values will allow requests to be sent quicker if the slot limit is
-- reached, and higher values will potentially reduce the number of requests
-- that may be outstanding.
TRP3_NamePlatesRequestQueue.SlotRechargePeriod = 2.25;

function TRP3_NamePlatesRequestQueue:Init()
	self.requestsInfo = {};
	self.requestsQueue = CreateFromMixins(DoublyLinkedListMixin);
	self.requestsOrdered = {};
	self.requestsCount = 0;

	self.slotsAvailable = TRP3_NamePlatesRequestQueue.SlotLimit;
	self.slotsCooldown = math.huge;

	self.postSubmitCooldowns = {};

	do
		local function TickerCallback()
			return self:OnQueueProcessTimerTicked();
		end;

		self.processTicker = C_Timer.NewTicker(TRP3_NamePlatesRequestQueue.ProcessRate, TickerCallback);
	end
end

function TRP3_NamePlatesRequestQueue:GetQueueSize()
	return self.requestsQueue.nodeCount;
end

function TRP3_NamePlatesRequestQueue:EnqueueUnitQuery(unitToken)
	local requestInfo = self:GetUnitRequestInfo(unitToken);

	-- If a node already exists for this unit then we'll dequeue it
	-- implicitly, since there isn't much else we can do that's sane.

	if requestInfo then
		self:DequeueUnitQuery(unitToken);
	end

	-- For sanity, don't permit non-existent or unknown units to be queued.

	local registerID = TRP3_NamePlatesUtil.GetUnitRegisterID(unitToken);

	if not registerID then
		return;
	end

	if not requestInfo then
		requestInfo = {};
	end

	local guid = UnitGUID(unitToken);
	local currentTime = GetTime();

	requestInfo.unit = unitToken;
	requestInfo.guid = guid;
	requestInfo.registerID = registerID;
	requestInfo.enqueuedAt = currentTime;
	requestInfo.order = self.requestsCount;

	-- Eligibility of a request will typically incur a small delay unless
	-- the character associated with this nameplate has previously been
	-- requested; if so then the delay is much larger.

	if self.postSubmitCooldowns[registerID] and self.postSubmitCooldowns[registerID] > GetTime() then
		local remainingCooldown = self.postSubmitCooldowns[registerID] - currentTime;
		requestInfo.eligibleAt = currentTime + remainingCooldown;
	else
		requestInfo.eligibleAt = currentTime + TRP3_NamePlatesRequestQueue.PreSubmitCooldown;
	end

	-- Some attributes about the unit we're requesting from are cached ahead
	-- of time; these are things that are unlikely to change while this
	-- request is queued or are otherwise possibly expensive to query
	-- periodically.

	if C_FriendList.IsFriend(guid) then
		requestInfo.isFriend = true;
	elseif C_BattleNet then
		requestInfo.isFriend = (C_BattleNet.GetAccountInfoByGUID(guid) ~= nil);
	else
		requestInfo.isFriend = (BNGetGameAccountInfoByGUID(guid) ~= nil);
	end

	requestInfo.isGuildMember = IsGuildMember(guid);

	-- The fields below are considered dynamic and may be modified while the
	-- request is enqueued; see UpdateDynamicRequestData for details.

	requestInfo.isNearby = false;
	requestInfo.priority = RequestPriority.Normal;

	self.requestsInfo[unitToken] = requestInfo;
	self.requestsCount = self.requestsCount + 1;
	self.requestsQueue:PushBack(requestInfo);
end

function TRP3_NamePlatesRequestQueue:DequeueUnitQuery(unitToken)
	local requestInfo = self:GetUnitRequestInfo(unitToken);

	if requestInfo then
		self.requestsQueue:Remove(requestInfo);
		self.requestsInfo[unitToken] = nil;
	end
end

function TRP3_NamePlatesRequestQueue:DequeueAllQueries()
	table.wipe(self.requestsOrdered);
	table.wipe(self.requestsQueue);
	table.wipe(self.requestsInfo);
end

-- private
function TRP3_NamePlatesRequestQueue:GetUnitRequestInfo(unitToken)
	return self.requestsInfo[unitToken];
end

-- private
function TRP3_NamePlatesRequestQueue:GetOrCreateUnitRequestInfo(unitToken)
	return GetOrCreateTable(self.requestsInfo, unitToken);
end

-- private
function TRP3_NamePlatesRequestQueue:UpdateDynamicRequestData(requestInfo)
	local RANGE_CHECK_ITEM_ID = 21519;  -- Mistletoe @ 23 yards.

	requestInfo.isNearby = IsItemInRange(RANGE_CHECK_ITEM_ID, requestInfo.unit);
	requestInfo.priority = GetRequestPriority(requestInfo);
end

-- private
function TRP3_NamePlatesRequestQueue:SubmitRequest(requestInfo)
	local registerID = requestInfo.registerID;
	local unitToken = requestInfo.unit;

	self:DequeueUnitQuery(unitToken);

	TRP3_API.r.sendQuery(registerID);
	TRP3_API.r.sendMSPQuery(registerID);

	self.postSubmitCooldowns[registerID] = GetTime() + TRP3_NamePlatesRequestQueue.PostSubmitCooldown;
end

-- private
function TRP3_NamePlatesRequestQueue:AcquireRequestSlot()
	if self.slotsAvailable == 0 then
		return false;  -- No request slots available.
	end

	-- On acquisition of the first request slot we need to start the cooldown
	-- recharge it.

	if self.slotsAvailable == TRP3_NamePlatesRequestQueue.SlotLimit then
		self.slotsCooldown = TRP3_NamePlatesRequestQueue.SlotRechargePeriod;
	end

	self.slotsAvailable = self.slotsAvailable - 1;
	return true;
end

-- private
function TRP3_NamePlatesRequestQueue:ReleaseRequestSlot()
	if self.slotsAvailable >= TRP3_NamePlatesRequestQueue.SlotLimit then
		-- Already at the request slot limit. Setting the cooldown to infinity
		-- here is just for safety; we _shouldn't_ need it but let's be safe.

		self.slotsCooldown = math.huge;

		return false;
	end

	self.slotsAvailable = self.slotsAvailable + 1;

	-- If we've regained all our request slots we'll disable the cooldown
	-- by setting it to infinity; otherwise it needs to be reset to that
	-- of the recharge rate.

	if self.slotsAvailable == TRP3_NamePlatesRequestQueue.SlotLimit then
		self.slotsCooldown = math.huge;
	else
		self.slotsCooldown = self.slotsCooldown + TRP3_NamePlatesRequestQueue.SlotRechargePeriod;
	end

	return true;
end

-- private
function TRP3_NamePlatesRequestQueue:ProcessRequestSlotCooldown(dt)
	self.slotsCooldown = self.slotsCooldown - dt;

	while self.slotsCooldown <= 0 do
		self:ReleaseRequestSlot();
	end
end

-- private
function TRP3_NamePlatesRequestQueue:ProcessRequestQueue()
	-- The ordered request table is reused on each process operation;
	-- we copy the nodes present in the queue to the table to the first
	-- n indices (where n is the queue length) and nil out anything left
	-- over in the ordered queue.
	--
	-- The resulting list is then sorted via our predicate.

	for index, requestInfo in self.requestsQueue:EnumerateNodes() do
		self:UpdateDynamicRequestData(requestInfo);
		self.requestsOrdered[index] = requestInfo;
	end

	for index = #self.requestsOrdered, self:GetQueueSize() + 1, -1 do
		self.requestsOrdered[index] = nil;
	end

	table.sort(self.requestsOrdered, RequestSortPredicate);

	-- With everything ordered we can now actually process the queue. Note
	-- that entries aren't removed from this table during iteration; if
	-- something is dequeued it will remain and instead be cleared when
	-- next processed.
	--
	-- The ordering should be such that eligible requests are always at
	-- the front of the queue - so if we find something that's not eligible
	-- we use that as a signal to stop processing early.

	for _, requestInfo in ipairs(self.requestsOrdered) do
		if not IsRequestEligibleToSend(requestInfo) then
			break;  -- Request isn't eligible.
		elseif not self:AcquireRequestSlot() then
			break;  -- No request slots available yet.
		end

		self:SubmitRequest(requestInfo);
	end
end

-- private
function TRP3_NamePlatesRequestQueue:OnQueueProcessTimerTicked()
	-- Don't allow errors in processing to kill the ticker; if an error occurs
	-- we'll just flush the whole queue and hope the user doesn't re-encounter
	-- the problem.

	xpcall(self.ProcessRequestSlotCooldown, CallErrorHandler, self, TRP3_NamePlatesRequestQueue.ProcessRate);

	if not xpcall(self.ProcessRequestQueue, CallErrorHandler, self) then
		self:DequeueAllQueries();
	end
end

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Enumeration of comparison results with same semantics as strcmp style
-- functions.
local CompareResult =
{
	Lesser = -1,
	Equal = 0,
	Greater = 1,
};

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
	Normal = 4,  -- Default priority for other units.
};

--
-- NamePlateRequestMixin
--

local lastRequestID = 0;

local function GenerateRequestID()
	lastRequestID = lastRequestID + 1;
	return lastRequestID;
end

local function GetUnitDistance(unit)
	-- Note that this logic is helpfully borrowed from DBM which tests and
	-- bases ranges off comparisons to UnitDistanceSquared.

	local distance = 60;  -- Max nameplate range (60 yards).

	if not InCombatLockdown() then
		if CheckInteractDistance(unit, 2) then
			distance = 11;  -- Trade (11 yards)
		elseif C_Item.IsItemInRange(21519, unit) then
			distance = 23;  -- Mistletoe (23 yards)
		elseif C_Item.IsItemInRange(1180, unit) then
			distance = 33;  -- Scroll of Stamina (33 yards)
		end
	end

	return distance;
end

local function IsFriendsWithPlayer(guid)
	if C_FriendList.IsFriend(guid) then
		return true;
	elseif C_BattleNet then
		return (C_BattleNet.GetAccountInfoByGUID(guid) ~= nil);
	else
		return (BNGetGameAccountInfoByGUID(guid) ~= nil);
	end
end

TRP3_NamePlatesRequestMixin = {};

-- Initial cooldown applied for all nameplates that have an elevated priority.
--
-- Lower values mean these units will be requested sooner when they appear
-- on screen, higher values reduce bandwidth.
TRP3_NamePlatesRequestMixin.PresubmitCooldown = 3;

-- Yards to which nameplate distance is rounded down to be a multiple of.
TRP3_NamePlatesRequestMixin.DistanceRounding = 5;

-- Initial cooldown applied for nameplates at a rate of 1 yard per the below
-- value rounded to the DistanceRounding value.
--
-- Lower values mean nameplates that are requested for possibly unrelated
-- units will be requested sooner, whereas higher values will increase the
-- amount of time such a unit has to be on-screen for.
TRP3_NamePlatesRequestMixin.DistanceCooldownScaling = 0.4;

-- Distance at which nameplates can be requested if not otherwise prioritized.
TRP3_NamePlatesRequestMixin.DistanceLimit = 35;

function TRP3_NamePlatesRequestMixin:Init(unit)
	self:SetUnit(unit);
end

function TRP3_NamePlatesRequestMixin:IsValid()
	return UnitExists(self.unit);
end

function TRP3_NamePlatesRequestMixin:GetUnit()
	return self.unit;
end

function TRP3_NamePlatesRequestMixin:GetCharacterID()
	return self.characterID;
end

function TRP3_NamePlatesRequestMixin:SetUnit(unit)
	self:Clear();

	local characterID = TRP3_NamePlatesUtil.GetUnitCharacterID(unit or "none");

	if not characterID then
		return;
	end

	-- The below fields are fixed for the entirety of this request and won't
	-- be modified by calls to Update. Anything not listed here nor handled
	-- in Update will be left at the default value set during the initial
	-- Clear call.

	self.id = GenerateRequestID();
	self.unit = unit;
	self.guid = UnitGUID(self.unit);
	self.characterID = characterID;

	self.enqueuedAt = GetTime();

	self.isFriend = IsFriendsWithPlayer(self.guid);
	self.isGuildMember = IsGuildMember(self.guid);

	self:Update();
end

function TRP3_NamePlatesRequestMixin:SetExtraCooldown(cooldown)
	self.extraCooldown = tonumber(cooldown) or 0;
end

function TRP3_NamePlatesRequestMixin:Clear()
	self.id = 0;
	self.unit = "none";
	self.guid = UnitGUID("none");
	self.characterID = UNKNOWNOBJECT;

	self.enqueuedAt = math.huge;
	self.eligibleAt = math.huge;
	self.priority = RequestPriority.Normal;
	self.extraCooldown = 0;

	self.distance = math.huge;
	self.isFriend = false;
	self.isGrouped = false;
	self.isGuildMember = false;
end

function TRP3_NamePlatesRequestMixin:Update()
	-- These things are more likely to change while a request is enqueued
	-- so are recalculated on each update.

	self.distance = GetUnitDistance(self.unit);
	self.isGrouped = UnitInParty(self.unit) or UnitInRaid(self.unit);

	-- Priority is dynamic based on these attributes.

	if self.isFriend then
		self.priority = RequestPriority.Friend;
	elseif self.isGrouped then
		self.priority = RequestPriority.Group;
	elseif self.isGuildMember then
		self.priority = RequestPriority.Guild;
	else
		self.priority = RequestPriority.Normal;
	end

	-- And then eligiblity time is also dynamic.
	self.eligibleAt = self.enqueuedAt + self:CalculatePresubmitCooldown();
end

function TRP3_NamePlatesRequestMixin:CalculatePresubmitCooldown()
	local rounding = self.DistanceRounding;
	local distance = math.floor(self.distance / rounding) * rounding;

	local priorityCooldown;

	if self.priority ~= RequestPriority.Normal then
		priorityCooldown = self.PresubmitCooldown;
	elseif distance >= self.DistanceLimit then
		priorityCooldown = math.huge;  -- Out of range.
	else
		local scaling = self.DistanceCooldownScaling;
		priorityCooldown = distance * scaling;
	end

	return priorityCooldown + self.extraCooldown;
end

function TRP3_NamePlatesRequestMixin:CanSubmit()
	return self:IsValid() and GetTime() >= self.eligibleAt;
end

function TRP3_NamePlatesRequestMixin:SubmitNow()
	if not self:IsValid() then
		return;
	end

	TRP3_API.r.sendQuery(self.characterID);
	TRP3_API.r.sendMSPQuery(self.characterID);

	-- Once submitted we clear the request as a sanity measure.
	self:Clear();
end

function TRP3_NamePlatesRequestMixin:Compare(other)
	-- Comparison favours priority, then eligibility time, then finally the
	-- unique request ID as a fallback mechanism.

	if self.priority < other.priority then
		return CompareResult.Lesser;
	elseif self.priority > other.priority then
		return CompareResult.Greater;
	end

	if self.eligibleAt < other.eligibleAt then
		return CompareResult.Lesser;
	elseif self.eligibleAt > other.eligibleAt then
		return CompareResult.Greater;
	end

	if self.id < other.id then
		return CompareResult.Lesser;
	elseif self.id > other.id then
		return CompareResult.Greater;
	else
		return CompareResult.Equal;
	end
end

--
-- NamePlatesRequestQueueMixin
--

local function RequestSortPredicate(requestA, requestB)
	return requestA:Compare(requestB) == CompareResult.Lesser;
end

TRP3_NamePlatesRequestQueueMixin = {};

function TRP3_NamePlatesRequestQueueMixin:Init()
	self.enqueued = {};
	self.ordered = {};
end

function TRP3_NamePlatesRequestQueueMixin:Clear()
	table.wipe(self.enqueued);
	table.wipe(self.ordered);
end

function TRP3_NamePlatesRequestQueueMixin:Contains(request)
	return self.enqueued[request] ~= nil;
end

function TRP3_NamePlatesRequestQueueMixin:Enqueue(request)
	if self:Contains(request) then
		return;
	end

	self.enqueued[request] = true;
end

function TRP3_NamePlatesRequestQueueMixin:Dequeue(request)
	if not self:Contains(request) then
		return;
	end

	self.enqueued[request] = nil;
end

function TRP3_NamePlatesRequestQueueMixin:EnumerateOrdered()
	return ipairs(self.ordered);
end

function TRP3_NamePlatesRequestQueueMixin:UpdateEnqueued()
	local count = 0;

	-- Populate the ordered array with all currently enqueued requests,
	-- updating them as we go for sorting purposes later.

	for request in pairs(self.enqueued) do
		request:Update();
		count = count + 1;
		self.ordered[count] = request;
	end

	-- If the number of enqueued requests shrank since the last update we
	-- need to clear the remaining slots in the ordered array.

	for index = #self.ordered, count + 1, -1 do
		self.ordered[index] = nil;
	end

	table.sort(self.ordered, RequestSortPredicate);
end

--
-- NamePlateRequestSlotPoolMixin
--

TRP3_NamePlatesRequestSlotPoolMixin = {};

-- Base cooldown in fractional seconds for each slot to recharge.
--
-- Lower values will reduce the time between requests when the pool is
-- exhausted, higher values will increase it.
TRP3_NamePlatesRequestSlotPoolMixin.RechargeBaseRate = 3.0;

-- Additional cooldown in fractional seconds applied for each missing slot
-- beyond the first.
--
-- Increasing this value will further increase the amount of time between
-- slots being recharged if the pool has been exhausted of multiple request
-- slots.
TRP3_NamePlatesRequestSlotPoolMixin.RechargeLinearRate = 0.5;

function TRP3_NamePlatesRequestSlotPoolMixin:Init(capacity)
	self.capacity = capacity;
	self.available = 0;
	self.cooldown = math.huge;
	self.accumulator = 0;

	-- The availability is initialized to zero so that UI reloads and
	-- initial logins don't result in a burst of requests. As a result,
	-- the cooldown needs to be calculated now.

	self:RecalculateCooldown();
end

function TRP3_NamePlatesRequestSlotPoolMixin:IsEmpty()
	return self.available == 0;
end

function TRP3_NamePlatesRequestSlotPoolMixin:IsFull()
	return self.available == self.capacity;
end

function TRP3_NamePlatesRequestSlotPoolMixin:Acquire()
	if self.available == 0 then
		return false;
	end

	self.available = self.available - 1;
	self:RecalculateCooldown();

	return true;
end

function TRP3_NamePlatesRequestSlotPoolMixin:Release()
	self.available = math.min(self.available + 1, self.capacity);
	self:RecalculateCooldown();
end

function TRP3_NamePlatesRequestSlotPoolMixin:ProcessCooldown(dt)
	if self:IsFull() then
		return;
	end

	-- At this point we know that the cooldown isn't infinity, so all
	-- operations below should be safe and never get things stuck.

	self.accumulator = self.accumulator + dt;

	while self.accumulator >= self.cooldown do
		self.accumulator = self.accumulator - self.cooldown;
		self:Release();
	end
end

-- private
function TRP3_NamePlatesRequestSlotPoolMixin:RecalculateCooldown()
	local missing = self.capacity - self.available;

	if missing == 0 then
		self.cooldown = math.huge;
		self.accumulator = 0;
	else
		local baseCooldown = self.RechargeBaseRate;
		local extraCooldown = self.RechargeLinearRate;

		self.cooldown = baseCooldown + ((missing - 1) * extraCooldown);
	end
end

--
-- NamePlatesRequestManagerMixin
--

TRP3_NamePlatesRequestManagerMixin = {};

-- Rate at which the internal queue and slot cooldowns are processed.
-- Lower values increase CPU usage, higher values make things snappier.
TRP3_NamePlatesRequestManagerMixin.TickPeriod = 0.5;

-- Time in fractional seconds that must pass before a request for a character
-- that was already previously requested can be re-issued.
--
-- Higher values mean that if we see the nameplate for the same character
-- repeatedly within a session, we won't re-download any associated data
-- for a while. Lower values will cause such cases to be more responsive
-- but could significantly increase bandwidth consumption.
TRP3_NamePlatesRequestManagerMixin.PostSubmitCooldown = 300;

-- Number of request "slots" that the system has. Each request in the queue
-- consumes a slot when sent, and slots are regained based on a recharge
-- period that must elapse.
--
-- A higher slot count means that we can burst-request more nameplates in a
-- single go, and a lower slot count will reduce the number of requests that
-- can be issued within a close time period.
TRP3_NamePlatesRequestManagerMixin.SlotLimit = 5;

function TRP3_NamePlatesRequestManagerMixin:Init()
	self.queue = CreateAndInitFromMixin(TRP3_NamePlatesRequestQueueMixin);
	self.slots = CreateAndInitFromMixin(TRP3_NamePlatesRequestSlotPoolMixin, self.SlotLimit);
	self.requests = {};
	self.requestCooldowns = {};
	self.ticker = C_Timer.NewTicker(self.TickPeriod, GenerateClosure(self.OnProcessTimerTicked, self));
end

function TRP3_NamePlatesRequestManagerMixin:EnqueueUnitQuery(unit)
	local request = self:GetOrCreateUnitRequest(unit);
	request:SetUnit(unit);

	-- Note that these operations below are idempotent if called in succession
	-- for an already enqueued/dequeued unit.

	if request:IsValid() then
		-- For a character who had a recently submitted request an extra
		-- cooldown is applied to further requests to further deprioritize.

		local characterID = request:GetCharacterID();
		local characterCD = self.requestCooldowns[characterID];

		if characterCD and characterCD > GetTime() then
			local remainingCD = characterCD - GetTime();
			request:SetExtraCooldown(remainingCD);
		end

		self.queue:Enqueue(request);
	else
		self.queue:Dequeue(request);
	end
end

function TRP3_NamePlatesRequestManagerMixin:DequeueUnitQuery(unit)
	local request = self:GetUnitRequest(unit);

	if request then
		request:Clear();
		self.queue:Dequeue(request);
	end
end

-- private
function TRP3_NamePlatesRequestManagerMixin:GetUnitRequest(unit)
	return self.requests[unit];
end

-- private
function TRP3_NamePlatesRequestManagerMixin:GetOrCreateUnitRequest(unit)
	local request = self.requests[unit];

	if not request then
		request = CreateAndInitFromMixin(TRP3_NamePlatesRequestMixin, unit);
		self.requests[unit] = request;
	end

	return request;
end

-- private
function TRP3_NamePlatesRequestManagerMixin:SubmitRequest(request)
	local characterID = request:GetCharacterID();

	request:SubmitNow();
	request:Clear();

	self.queue:Dequeue(request);
	self.requestCooldowns[characterID] = GetTime() + self.PostSubmitCooldown;
end

-- private
function TRP3_NamePlatesRequestManagerMixin:OnProcessTimerTicked()
	self.slots:ProcessCooldown(self.TickPeriod);
	self.queue:UpdateEnqueued();

	-- The ordering should be such that eligible requests are always at
	-- the front of the queue. Based on this, if we find something that isn't
	-- eligible then we can stop processing early.

	for _, request in self.queue:EnumerateOrdered() do
		if not request:CanSubmit() then
			break;  -- Request isn't eligible.
		elseif not self.slots:Acquire() then
			break;  -- No request slots available yet.
		end

		self:SubmitRequest(request);
	end
end

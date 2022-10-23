---@type Ellyb
local Ellyb = Ellyb(...);

---@class Promise : MiddleClass_Class
local Promise= Ellyb.Class("Promise");
Promise:include(Ellyb.PooledObjectMixin);

---@type {status: number, onSuccessCallbacks: function[], onFailCallbacks: function[], onAlwaysCallbacks: function[], resolutionArgs: any[] }[]
local private = Ellyb.getPrivateStorage();

function Promise:initialize()
	private[self].status = Ellyb.Promises.STATUS.PENDING;

	private[self].onSuccessCallbacks = {};
	private[self].onFailCallbacks = {};
	private[self].onAlwaysCallbacks = {};
end

---@return number One of Ellyb.Promises.STATUS
function Promise:GetStatus()
	return private[self].status;
end

---@return boolean True if the Promise has ben fulfilled
function Promise:HasBeenFulfilled()
	return self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED;
end

function Promise:Then(onSuccess, onFail, always)
	table.insert(private[self].onSuccessCallbacks, onSuccess);
	table.insert(private[self].onFailCallbacks, onFail);
	table.insert(private[self].onAlwaysCallbacks, always);

	if self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		onSuccess(unpack(private[self].resolutionArgs));
	end

	if onFail and self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		onFail(unpack(private[self].resolutionArgs));
	end

	if always and (self:GetStatus() == Ellyb.Promises.STATUS.REJECTED or self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED) then
		always(unpack(private[self].resolutionArgs));
	end

	return self;
end

function Promise:Success(callback)
	table.insert(private[self].onSuccessCallbacks, callback);

	if self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		callback(unpack(private[self].resolutionArgs));
	end

	return self;
end

function Promise:Fail(callback)
	table.insert(private[self].onFailCallbacks, callback);

	if self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		callback(unpack(private[self].resolutionArgs));
	end

	return self;
end

function Promise:Always(callback)
	table.insert(private[self].onAlwaysCallbacks, callback);

	if self:GetStatus() == Ellyb.Promises.STATUS.REJECTED or self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		callback(unpack(private[self].resolutionArgs));
	end

	return self;
end

function Promise:Resolve(...)
	private[self].status = Ellyb.Promises.STATUS.FULFILLED;
	private[self].resolutionArgs = { ...};

	for _, callback in ipairs(private[self].onSuccessCallbacks) do
		callback(...);
	end

	for _, callback in ipairs(private[self].onAlwaysCallbacks) do
		callback(...);
	end

	return self;
end

function Promise:Reject(...)
	if self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		return error("Trying to resolve a Promise that has already been rejected.");
	elseif self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		return error("Trying to reject a Promise that has already been resolved.");
	end

	private[self].status = Ellyb.Promises.STATUS.REJECTED;

	for _, callback in ipairs(private[self].onFailCallbacks) do
		callback(...);
	end

	for _, callback in ipairs(private[self].onAlwaysCallbacks) do
		callback(...);
	end

	return self;
end

Ellyb.Promise = Promise;

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditorField = {};

function TRP3_ProfileEditorField:__init(accessor)
	self.callbacks = TRP3_API.InitCallbackRegistry(self);
	self.accessor = accessor;
	self.autoCommitEnabled = true;
	self.pendingValue = nil;
	self.hasPendingValue = false;
end

function TRP3_ProfileEditorField:IsAutoCommitEnabled()
	return self.autoCommitEnabled;
end

function TRP3_ProfileEditorField:SetAutoCommitEnabled(autoCommitEnabled)
	self.autoCommitEnabled = autoCommitEnabled;
end

function TRP3_ProfileEditorField:HasPendingValue()
	return self.hasPendingValue;
end

function TRP3_ProfileEditorField:GetValue()
	if self.hasPendingValue then
		return self.pendingValue;
	else
		return self.accessor:GetValue();
	end
end

function TRP3_ProfileEditorField:SetValue(value)
	self.pendingValue = value;
	self.hasPendingValue = true;

	if self:IsAutoCommitEnabled() then
		self:CommitValue();
	else
		self:NotifyValueChanged();
	end
end

function TRP3_ProfileEditorField:SetValueWithCommit(value)
	self:SetValue(value);
	self:CommitValue();
end

function TRP3_ProfileEditorField:RevertValue()
	if not self.hasPendingValue then
		return;
	end

	self.pendingValue = nil;
	self.hasPendingValue = false;
	self:NotifyValueChanged();
end

function TRP3_ProfileEditorField:CommitValue()
	if not self.hasPendingValue then
		return;
	end

	local pendingValue = self.pendingValue;
	self.pendingValue = nil;
	self.hasPendingValue = false;

	self.accessor:SetValue(pendingValue);
	self:NotifyValueChanged();
end

function TRP3_ProfileEditorField:NotifyValueChanged()
	local value = self:GetValue();
	self.callbacks:Fire("OnValueChanged", self, value);
end

function TRP3_ProfileEditor.CreateField(accessor)
	local field = TRP3_API.AllocateObject(TRP3_ProfileEditorField);
	field:__init(accessor);
	return field;
end

function TRP3_ProfileEditor.CreateTableAccessor(table, key)
	local accessor = {};

	function accessor:GetValue()
		local value = table[key];
		return value;
	end

	function accessor:SetValue(value)
		table[key] = value;
	end

	return accessor;
end

function TRP3_ProfileEditor.CreateMethodAccessor(object, getValue, setValue)
	local accessor = {};

	function accessor:GetValue()
		return getValue(object);
	end

	function accessor:SetValue(value)
		setValue(object, value);
	end

	return accessor;
end

function TRP3_ProfileEditor.AddDeferredCommitBehavior(field, delay)
	local behavior = {};
	local timer = TRP3_API.CreateTimer();

	function behavior:OnTimerElapsed()
		field:CommitValue();
	end

	function behavior:OnValueChanged()
		timer:Start(delay);
	end

	timer.RegisterCallback(behavior, "OnElapsed", "OnTimerElapsed");
	field.RegisterCallback(behavior, "OnValueChanged");

	return behavior;
end

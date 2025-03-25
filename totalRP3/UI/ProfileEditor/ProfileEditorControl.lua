-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditorControlInitializer = {};

function TRP3_ProfileEditorControlInitializer:__init(accessor, label, tooltip)
	self.accessor = accessor;
	self.label = label;
	self.tooltip = (tooltip ~= "") and tooltip or nil;
end

function TRP3_ProfileEditorControlInitializer:GetAccessor()
	return self.accessor;
end

function TRP3_ProfileEditorControlInitializer:GetLabel()
	return self.label;
end

function TRP3_ProfileEditorControlInitializer:GetTooltip()
	return self.tooltip;
end

TRP3_ProfileEditorControlMixin = {};

function TRP3_ProfileEditorControlMixin:OnLoad()
end

function TRP3_ProfileEditorControlMixin:Init(initializer)
	self.accessor = initializer:GetAccessor();
end

function TRP3_ProfileEditorControlMixin:Release()
	self.accessor = nil;
end

function TRP3_ProfileEditorControlMixin:GetAccessor()
	return self.accessor;
end

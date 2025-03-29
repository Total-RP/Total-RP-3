-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditorControlInitializer = {};

function TRP3_ProfileEditorControlInitializer:__init(field)
	self.field = field;
end

function TRP3_ProfileEditorControlInitializer:GetField()
	return self.field;
end

TRP3_ProfileEditorControlMixin = {};

function TRP3_ProfileEditorControlMixin:Init(initializer)
	self.field = initializer:GetField();
end

function TRP3_ProfileEditorControlMixin:Release()
	self.field = nil;
end

function TRP3_ProfileEditorControlMixin:GetField()
	return self.field;
end

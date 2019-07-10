-- Total RP 3 Nameplate Module
-- Copyright 2019 Total RP 3 Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- AddOn_TotalRP3 imports.
local NamePlates = AddOn_TotalRP3.NamePlates;

-- Mixin for pooling custom widgets that can be attached to nameplates.
local CustomWidgetHostMixin = {};

-- Initializes the mixin.
function CustomWidgetHostMixin:Init()
	-- Mapping of owner frame names to a table of custom widgets.
	self.customWidgets = {};

	-- Pools from which custom widgets are sourced.
	self.fontStringPool = CreateFontStringPool(UIParent, "ARTWORK", 0, "SystemFont_NamePlate");
	self.texturePool = CreateTexturePool(UIParent, "ARTWORK", 0);
end

-- Returns a named custom widget for the given owning frame.
function CustomWidgetHostMixin:GetCustomWidget(frame, name)
	local widgets = self.customWidgets[frame:GetName()];
	if not widgets then
		return nil;
	end

	return widgets[name];
end

-- Acquires a named custom widget for a owner frame, sourcing it from the given
-- pool and returning it.
--
-- This function will return nil if the given frame is forbidden, and
-- no widget will be acquired.
--
-- The widget returned may or may not be sourced from the reusable pool. It
-- is the responsibility of the caller to ensure that the widget is reset
-- prior to modifications.
function CustomWidgetHostMixin:AcquireCustomWidget(frame, name, pool)
	-- Don't add widgets to locked down frames.
	if not CanAccessObject(frame) then
		return nil;
	end

	-- Ensure a widget registry exists for this named frame.
	local widgets = self.customWidgets[frame:GetName()] or {};
	self.customWidgets[frame:GetName()] = widgets;

	-- Reuse the existing widget if it wasn't recycled, otherwise acquire.
	local widget = widgets[name] or pool:Acquire();
	widgets[name] = widget;

	return widget;
end

-- Acquires a custom font string widget and assigns it to the given frame.
function CustomWidgetHostMixin:AcquireCustomFontString(frame, name)
	return self:AcquireCustomWidget(frame, name, self.fontStringPool);
end

-- Acquires a custom texture widget and assigns it to the given frame.
function CustomWidgetHostMixin:AcquireCustomTexture(frame, name)
	return self:AcquireCustomWidget(frame, name, self.texturePool);
end

-- Releases a named custom widget from an owner frame, placing it back into
-- the given pool.
--
-- If the frame is inaccessible, this will not release the widget, however
-- the future acquisitions of the widget with the same name will return the
-- same widget.
function CustomWidgetHostMixin:ReleaseCustomWidget(frame, name, pool)
	-- Don't release widgets from locked down frames.
	if not CanAccessObject(frame) then
		return nil;
	end

	-- If no widget registry exists, there's nothing to release.
	local widgets = self.customWidgets[frame:GetName()];
	if not widgets then
		return;
	end

	-- If no widget itself exists, same deal.
	local widget = widgets[name];
	if not widget then
		return;
	end

	-- Otherwise release it back to the pool.
	pool:Release(widget);
	widgets[name] = nil;
end

-- Releases a named custom font string widget from a owner frame.
function CustomWidgetHostMixin:ReleaseCustomFontString(frame, name)
	return self:ReleaseCustomWidget(frame, name, self.fontStringPool);
end

-- Releases a named custom texture widget from a owner frame.
function CustomWidgetHostMixin:ReleaseCustomTexture(frame, name)
	return self:ReleaseCustomWidget(frame, name, self.texturePool);
end

-- Module exports.
NamePlates.CustomWidgetHostMixin = CustomWidgetHostMixin;

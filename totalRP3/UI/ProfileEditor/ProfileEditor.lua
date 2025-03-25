-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditor = {};

function TRP3_ProfileEditor.CreateTableFieldAccessor(table, key)
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

-- TODO: Reconsider 'tooltip' name as it's a func|string but one might think it's a gametooltip object or tooltip description. Verbiage borrowed from Settings.
function TRP3_ProfileEditor.CreateControlTooltip(description, label, tooltip)
	description:AddTitleLine(label);
	description:QueueBlankLine();

	if type(tooltip) == "function" then
		tooltip(description);
	elseif tooltip ~= nil and tooltip ~= "" then
		description:AddNormalLine(tooltip);
	end

	description:ClearQueuedLines();
end

--[[
-- Example usage of all this crap:

do
	-- Create an accessor that can read/write to the profile field.
	--
	-- This is a simplified one that does a direct table write, but the
	-- interface is generic - an accessor just needs to be an object that
	-- has GetValue() and SetValue(value) functions.
	--
	-- TODO: Consider if GetDefaultValue() and GetInitialValue() also makes
	--       sense to ease reverting individual fields in the editor.

	local accessor = TRP3_ProfileEditor.CreateTableFieldAccessor(dataTab, "CU");

	-- Create an initializer for your control. These *should* uniformly
	-- take the accessor as the first parameter, followed by a text label
	-- and tooltip body for the control. Additional parameters thereafter
	-- are control-specific.
	--
	-- The tooltip body can be `nil` (or an empty string) if no tooltip is
	-- desired, or a function if the contents are complex. This is hooked into
	-- the 'new' tooltip system and receives a tooltip description object as
	-- described in UI\Tooltip\Tooltip.lua.

	local initializer = TRP3_ProfileEditor.CreateTextLineInitializer(accessor, "Currently", "Long description of the Currently field");

	-- Currently the entire profile view and editor UIs aren't (yet?) converted
	-- to any form of dynamic frame management (eg. scrollbox), so at this
	-- point the supported method for hooking everything up is to just
	-- pass your initializer to the `:Init()` method on the frame.

	MyFrame.CurrentlyEditor:Init(initializer);

	-- The `:Release()` method disconnects the control from the field and
	-- puts it back into an inert state.

	MyFrame.CurrentlyEditor:Release();
end
]]

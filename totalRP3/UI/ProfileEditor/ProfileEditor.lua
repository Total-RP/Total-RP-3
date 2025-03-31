-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_ProfileEditor = {};

--[[
-- Example usage of all this crap:

do
	-- Create a field object. In most cases at present this will just be
	-- one that's based off a table + key pair.
	--
	-- Field objects abstract their Get/Set operations via an Accessor
	-- interface with a GetValue and SetValue method pair. By default
	-- fields don't commit changes without a manual ':CommitValue()' call
	-- *except* in the case of CreateFieldFromTable which assumes immediate
	-- commit is preferred.

	local field = TRP3_ProfileEditor.CreateFieldFromTable(dataTab, "CU");

	-- Create an initializer for your control. These *should* uniformly
	-- take the field as the first parameter, followed by a text label
	-- and tooltip body for the control. Additional parameters thereafter
	-- are control-specific.
	--
	-- The tooltip body can be `nil` (or an empty string) if no tooltip is
	-- desired, or a function if the contents are complex. This is hooked into
	-- the 'new' tooltip system and receives a tooltip description object as
	-- described in UI\Tooltip\Tooltip.lua.

	local initializer = TRP3_ProfileEditor.CreateTextLineInitializer(field, "Currently", "Long description of the Currently field");

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

function InitializeMe()
	local accessor = TRP3_ProfileEditor.CreateTableAccessor(_G, "foo");
	local field = TRP3_ProfileEditor.CreateField(accessor);
	local initializer = TRP3_ProfileEditor.CreateTextAreaInitializer(field, "Control label", "Control tooltip", 20);
	TotallyNormalTestFrame:Init(initializer);
end

function ReleaseMe()
	TotallyNormalTestFrame:Release();
end

RunNextFrame(InitializeMe);

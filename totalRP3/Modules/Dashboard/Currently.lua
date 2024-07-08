-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOADED, function()
	local loc = TRP3_API.loc;
	local setupMovableFrame = TRP3_API.ui.frame.setupMove;

	local frame = TRP3_CurrentlyFrame;

	-- Called whenever the OnTextChanged event fires for the currentlyText scrollbox,
	-- which checks if it was triggered by userInput before changing the "Currently" text.
	local function onCurrentlyChanged(editBox, userInput)
		if not userInput then
			return;
		end

		AddOn_TotalRP3.Player.GetCurrentUser():SetCurrentlyText(editBox:GetText());
	end

	-- Prepares to show frame, gets player's "currently" and writes it to the scrollbox.
	local function toggleCurrentlyFrame()
		if frame:IsShown() then
			frame:Hide();
			return;
		end

		frame.CurrentlyText.scroll.text:SetText(AddOn_TotalRP3.Player.GetCurrentUser():GetCurrentlyText());

		frame:Show();
	end
	TRP3_API.r.toggleCurrentlyFrame = toggleCurrentlyFrame;

	frame.Title:SetText(loc.CURRENTLY_TITLE);
	frame.CurrentlyText.scroll.text:HookScript("OnTextChanged", onCurrentlyChanged);

	setupMovableFrame(frame);

	if TRP3_API.toolbar then
		-- Create a toolbar button to show/hide the Currently frame.
		TRP3_API.toolbar.toolbarAddButton({
			id = "bb_trp3_currently",
			icon = TRP3_InterfaceIcons.ToolbarCurrently,
			configText = loc.CURRENTLY_TITLE,
			tooltip = loc.CURRENTLY_TITLE,
			tooltipSub = TRP3_API.FormatShortcutWithInstruction("CLICK", loc.CURRENTLY_BUTTON_TT),
			onClick = function()
				toggleCurrentlyFrame();
			end,
		});
	end

	-- Register a slash command, so if people disable the toolbar button
	-- or toolbar module the frame can still be called.
	TRP3_API.slash.registerCommand({
		id = "currently",
		helpLine = " " .. loc.CURRENTLY_COMMAND_HELP,
		handler = toggleCurrentlyFrame
	});
end);

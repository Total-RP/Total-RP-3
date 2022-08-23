-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

--region Total RP 3 imports
local Events = TRP3_API.Events;
local playAnimation = TRP3_API.ui.misc.playAnimation;
--endregion

---@type Frame|ScriptObject
local TRP3_ScanLoaderFrame = TRP3_ScanLoaderFrame;

Events.registerCallback(Events.MAP_SCAN_STARTED, function(scanDuration)
	assert(scanDuration, "Did somebody forgot to set a duration to a scan? Silly you!")
	TRP3_ScanLoaderFrame.time = scanDuration;
	TRP3_ScanLoaderFrame:Show();

	TRP3_ScanLoaderFrame.content.flash1Rotation:SetDuration(scanDuration);
	TRP3_ScanLoaderFrame.content.flash2Rotation:SetDuration(scanDuration);
	TRP3_ScanLoaderFrame.content.hourGlassRotation:SetDuration(scanDuration);

	playAnimation(TRP3_ScanLoaderFrame.fadeIn);
	playAnimation(TRP3_ScanLoaderFrame.content);
end);

Events.registerCallback(Events.MAP_SCAN_ENDED, function()
	playAnimation(TRP3_ScanLoaderFrame.fadeOut, function()
		TRP3_ScanLoaderFrame:Hide();
	end)
end);

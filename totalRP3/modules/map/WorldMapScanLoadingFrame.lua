----------------------------------------------------------------------------------
--- Total RP 3
--- ---------------------------------------------------------------------------
--- Copyright 2014-2019 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

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

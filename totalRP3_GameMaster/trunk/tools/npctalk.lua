----------------------------------------------------------------------------------
-- Total RP 3
-- NPC talks tools
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

-- imports
local loc = TRP3_API.locale.getText;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local lastAnchor;

local function refreshPosition()
	local x, y = GetCursorPosition();
	local scale = UIParent:GetEffectiveScale();
	y = y / scale;
	TRP3_API.ui.frame.configureHoverFrame(TRP3_NPCTalkFrame, lastAnchor, y <= 200 and "BOTTOM" or "TOP");
end

local function onButtonClicked(Uibutton, buttonStructure, button)
	if TRP3_NPCTalkFrame:IsVisible() then
		TRP3_NPCTalkFrame:Hide();
	else
		lastAnchor = Uibutton;
		refreshPosition();
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	if not TRP3_API.toolbar then return end;

	local button = {
		id = "vv_trp3_npctalk",
		icon = "spell_holy_silence",
		configText = loc("TB_NPC_TALK"),
		onClick = onButtonClicked
	};
	TRP3_API.toolbar.toolbarAddButton(button);

	TRP3_NPCTalkFrameResize.onResizeStop = refreshPosition;
end);
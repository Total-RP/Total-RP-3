----------------------------------------------------------------------------------
-- Total RP 3
-- Storyline module
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

assert(TRP3_API ~= nil, "Can't find Total RP 3 API.");
assert(TipTac ~= nil, "Can't find TipTac API.");

local TipTacConfig = TipTac_Config;

local lastUpdate;

local TT_MirrorAnchorsSmart = {
	TOPLEFT = "BOTTOMRIGHT",
	TOPRIGHT = "BOTTOMLEFT",
	BOTTOMLEFT = "TOPRIGHT",
	BOTTOMRIGHT = "TOPLEFT",
};

local TT_MirrorAnchors = {
	TOP = "BOTTOM",
	TOPLEFT = "TOPRIGHT",
	TOPRIGHT = "TOPLEFT",
	BOTTOM = "TOP",
	BOTTOMLEFT = "BOTTOMRIGHT",
	BOTTOMRIGHT = "BOTTOMLEFT",
	LEFT = "RIGHT",
	RIGHT = "LEFT",
	CENTER = "CENTER",
};

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function anchorTooltip(frame, anchorType, anchorPoint)

	if (anchorType == "mouse") then
		TipTac:AnchorFrameToMouse(frame);
	elseif (anchorType == "parent") then
		frame:SetPoint(anchorPoint,UIParent);
	else
		frame:SetPoint(anchorPoint,TipTac);
	end
end

local function hideTooltip(frame, elapsed)

	local preFadeTime = TipTacConfig["preFadeTime"];
	local fadeTime = TipTacConfig["fadeTime"];

	if frame.fading then
		lastUpdate = lastUpdate + elapsed;
		if (lastUpdate > fadeTime + preFadeTime) then
			frame.fading = false;
			frame:Hide();
		elseif (lastUpdate > fadeTime) then
			frame:SetAlpha(1 - (lastUpdate - preFadeTime) / fadeTime);
		end
	else
		frame.fading = true;
		lastUpdate = 0;
	end
end

local function onUnitTooltipUpdate(self, elapsed)

	local anchorType = TipTacConfig["anchorWorldUnitType"];
	local anchorPoint = TipTacConfig["anchorWorldUnitPoint"];

	anchorTooltip(self, anchorType, anchorPoint);
	if self.target and self.targetType and not self.isFading then
		if self.target ~= TRP3_API.register.getUnitID(self.targetType) then
			hideTooltip(self, elapsed);
		end
	end

end

local function init()

	TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_FINISH, function()

		if TRP3_MainTooltip then
			TipTac:AddModifiedTip(TRP3_MainTooltip);
			--TRP3_MainTooltip:SetScript("OnUpdate", onFrameTooltipUpdate);
		end
		if TRP3_CharacterTooltip then
			TipTac:AddModifiedTip(TRP3_CharacterTooltip);
			TRP3_CharacterTooltip:SetScript("OnUpdate", onUnitTooltipUpdate);
		end
		if TRP3_CompanionTooltip then
			TipTac:AddModifiedTip(TRP3_CompanionTooltip);
			TRP3_CompanionTooltip:SetScript("OnUpdate", onUnitTooltipUpdate);
		end

	end);
end

local MODULE_STRUCTURE = {
	["name"] = "TipTac",
	["description"] = "Improves Total RP 3 compatibility with TipTac",
	["version"] = 1.000,
	["id"] = "tiptac",
	["onStart"] = init,
	["minVersion"] = 9,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
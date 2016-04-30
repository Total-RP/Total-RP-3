----------------------------------------------------------------------------------
-- Total RP 3
-- TipTac plugin
--	---------------------------------------------------------------------------
--	Copyright 2016 Renaud Parize (Ellypse) (ellypse@totalrp3.info)
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


local lastUpdate;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function anchorTooltip(frame, anchorType, anchorPoint)

	if anchorType == "mouse" then
        -- ¯\_(ツ)_/¯
		pcall(function()
            TipTac:AnchorFrameToMouse(frame);
        end);
	elseif anchorType == "parent" then
		frame:SetPoint(anchorPoint, UIParent);
	else
		frame:SetPoint(anchorPoint, TipTac);
	end
end

local function hideTooltip(frame, elapsed)

    if not TipTac_Config then return end;

	local preFadeTime = TipTac_Config["preFadeTime"];
	local fadeTime = TipTac_Config["fadeTime"];

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

local function onTooltipUpdate(self, elapsed, tooltipType)
    if not TipTac_Config or not tooltipType then return end;

    local anchorType = TipTac_Config["anchor" .. tooltipType .. "Type"];
    local anchorPoint = TipTac_Config["anchor" .. tooltipType .. "Point"];

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
			TRP3_MainTooltip:HookScript("OnUpdate", function(self, elapsed)
                onTooltipUpdate(self, elapsed, "FrameTip");
            end);
		end
		if TRP3_CharacterTooltip then
			TipTac:AddModifiedTip(TRP3_CharacterTooltip);
			TRP3_CharacterTooltip:HookScript("OnUpdate", function(self, elapsed)
                onTooltipUpdate(self, elapsed, "WorldUnit");
            end);
		end
		if TRP3_CompanionTooltip then
			TipTac:AddModifiedTip(TRP3_CompanionTooltip);
			TRP3_CompanionTooltip:HookScript("OnUpdate", function(self, elapsed)
                onTooltipUpdate(self, elapsed, "WorldUnit");
            end);
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
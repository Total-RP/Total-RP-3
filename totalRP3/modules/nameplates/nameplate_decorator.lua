----------------------------------------------------------------------------------
---    Total RP 3
---    Nameplates decorator
---    ---------------------------------------------------------------------------
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@class TRP3_NameplatesDecorator
local NameplatesDecorator = {};
TRP3_API.nameplates.decorator = NameplatesDecorator;


function NameplatesDecorator.init()
	
	local tostring = tostring;
	local UnitSelectionColor = UnitSelectionColor;
	local CompactUnitFrame_UpdateName = CompactUnitFrame_UpdateName;
	
	---@type TRP3_NameplatesConfig
	local NameplatesConfig = TRP3_API.nameplates.config;
	local getConfigValue = TRP3_API.configuration.getValue;
	local setupIconButton = TRP3_API.ui.frame.setupIconButton;
	local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
	local strIcon = TRP3_API.utils.str.icon;
	local applyRoundTexture = TRP3_API.utils.texture.applyRoundTexture;
	local crop = TRP3_API.utils.str.crop;
	
	local FIELDS_TO_CROP = {
		TITLE = 40,
		NAME = 40,
		AT_FIRST_GLANCE = 300,
	}
	
	---@type  FramePoolMixin ObjectPoolMixin
	local titlesFontStringPool = CreateFramePool("Frame", UIParent, "TRP3_CustomNameplate", function(self, nameplateDecorations)
		nameplateDecorations:ClearAllPoints();
		nameplateDecorations.title:Hide();
		nameplateDecorations.icon:Hide();
		for i =1, 5 do
			nameplateDecorations.glances["slot" .. i]:Hide();
		end
		nameplateDecorations:Hide();
	end)
	
	local function getNameplateDecorator(nameplate)
		if not nameplate.decorators then
			nameplate.decorators = titlesFontStringPool:Acquire();
			nameplate.decorators:Show();
			nameplate.decorators:SetParent(nameplate.UnitFrame);
			nameplate.decorators:SetPoint("BOTTOM", nameplate.UnitFrame, "BOTTOM", 0, getConfigValue(NameplatesConfig.configKeys.HIDE_HEALTH_BARS) and 10 or 0);
			nameplate.decorators.icon:SetPoint("RIGHT", nameplate.decorators.name, "LEFT", -10, 0);
			nameplate.decorators.name:SetPoint("BOTTOM", nameplate.UnitFrame.healthBar, "TOP", 0, 5);
			nameplate.decorators.glances:SetPoint("BOTTOM", nameplate.decorators.name, "TOP", 0, 3);
			nameplate.decorators.title:SetPoint("TOP", getConfigValue(NameplatesConfig.configKeys.HIDE_HEALTH_BARS) and nameplate.decorators.name or nameplate.UnitFrame.healthBar, "BOTTOM", 0, -5);
		end
		nameplate.decorators:SetWidth(nameplate.UnitFrame:GetWidth());
		return nameplate.decorators;
	end
	
	function NameplatesDecorator.decorate(nameplate, unitHasRPProfile, name, color, title, icon, glances)
		if not unitHasRPProfile then
			if getConfigValue(NameplatesConfig.configKeys.HIDE_NON_ROLEPLAY) then
				NameplatesDecorator.hideNameplate(nameplate);
			else
				NameplatesDecorator.restore(nameplate)
			end
			return;
		end
		
		if getConfigValue(NameplatesConfig.configKeys.HIDE_HEALTH_BARS) then
			nameplate.UnitFrame.healthBar:Hide();
		else
			nameplate.UnitFrame.healthBar:Show();
		end
		
		local decorator = getNameplateDecorator(nameplate);
		nameplate.UnitFrame.name:Hide();
		nameplate.UnitFrame.optionTable.displayName = false;
		
		decorator.name:SetText(crop(name, FIELDS_TO_CROP.NAME));
		nameplate.decorators:SetWidth(decorator.name:GetWidth());
		
		
		if getConfigValue(NameplatesConfig.configKeys.USE_CUSTOM_COLOR) then
			if color then
				if getConfigValue(NameplatesConfig.configKeys.INCREASE_COLOR_CONTRAST) then
					color:LightenColorUntilItIsReadable();
				end
				decorator.name:SetVertexColor(color:GetRGBA());
				nameplate.UnitFrame.healthBar:SetStatusBarColor(color:GetRGBA());
			end
		else
			decorator.name.name:SetVertexColor(UnitSelectionColor(nameplate.UnitFrame.unit, nameplate.UnitFrame.optionTable.colorNameWithExtendedColors));
		end
		
		if title then
			decorator.title:SetText("< " .. crop(title, FIELDS_TO_CROP.TITLE) .. ">");
			decorator.title:Show();
		end
		
		if icon then
			setupIconButton(decorator.icon, icon);
			decorator.icon:Show();
		end
		
		if glances then
			local enabledSlots = 0;
			for i =1, 5 do
				local glance = glances[tostring(i)];
				local slot = decorator.glances["slot" .. i];
				if glance and glance.AC then
					local TTText = "|cffff9900" .. (crop(glance.TX or "...", FIELDS_TO_CROP.AT_FIRST_GLANCE));
					setTooltipForSameFrame(slot,  getConfigValue("CONFIG_GLANCE_TT_ANCHOR"), 0, 0, strIcon(glance.IC, 30) .. " " .. (glance.TI or "..."), TTText);
					applyRoundTexture(slot.icon, "Interface\\ICONS\\" .. glance.IC);
					slot:Show();
					enabledSlots = enabledSlots + 1;
				else
					slot:Hide();
				end
			end
			decorator.glances:SetWidth(enabledSlots * 25);
		end
	end
	
	function NameplatesDecorator.hideNameplate(nameplate)
		nameplate.UnitFrame.healthBar:Hide();
		nameplate.UnitFrame.name:Hide();
	end
	
	function NameplatesDecorator.restore(nameplate)
		nameplate.UnitFrame.optionTable.displayName = true;
		if nameplate.unit then
			CompactUnitFrame_UpdateName(nameplate.UnitFrame);
		end
		nameplate.UnitFrame.name:Show();
		nameplate.UnitFrame.healthBar:Show();
	end
	
	function NameplatesDecorator.removeDecorations(nameplate)
		if nameplate.decorators then
			titlesFontStringPool:Release(nameplate.decorators);
			nameplate.decorators = nil;
		end
	end
end
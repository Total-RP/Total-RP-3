----------------------------------------------------------------------------------
--- Total RP 3
--- Workarounds
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type AddOn
local _, AddOn = ...;

---@class TRP3_Workarounds
local Workarounds = {};
AddOn.Workarounds = Workarounds ;

local workaroundsToApply = {};

function Workarounds.applyWorkarounds()
	for _, workaround in pairs(workaroundsToApply) do
		workaround();
	end
end

--- 7.3 EditBox workarounds
tinsert(workaroundsToApply, function()
	
	-- imports
	local getmetatable = getmetatable;
	
	if not TRP3_EditBoxMixin then
		---@type EditBox
		TRP3_EditBoxMixin = {};
	end
	
	function TRP3_EditBoxMixin:SetWidth(width)
		local effectiveScale = self:GetParent():GetEffectiveScale();
		getmetatable(self).__index.SetWidth(self, width * effectiveScale);
	end
	
	function TRP3_EditBoxMixin:SetSize(width, height)
		local effectiveScale = self:GetParent():GetEffectiveScale();
		getmetatable(self).__index.SetSize(self, width * effectiveScale, height);
	end
	
	function TRP3_EditBoxMixin:RefreshAutomaticWidth()
		local effectiveScale = self:GetParent():GetEffectiveScale();
		self:SetWidth(self:GetParent():GetParent():GetWidth() - (50 * effectiveScale));
	end
	
	function TRP3_EditBoxMixin:OnShow()
		local effectiveScale = self:GetParent():GetEffectiveScale();
		if not self.workaroundHasBeenApplied then
			self:SetIgnoreParentScale(true);
			local fontPath, fontSize, fontFlag = self:GetFont();
			self:SetFont(fontPath, 12 * effectiveScale, fontFlag);
			self.workaroundHasBeenApplied = true;
		end
		self:RefreshAutomaticWidth();
	end
	
end);


Workarounds.applyWorkarounds();
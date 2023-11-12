-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

function TRP3_LocalizeTextOnAddOnLoaded(object)
	local function SetLocalizedText()
		local textKey;

		if object.textKey == "string" then
			textKey = object.textKey;
		else
			textKey = string.match(object:GetText(), "^L.(.+)$");
		end

		if textKey then
			object:SetText(L[textKey]);
		end
	end

	EventUtil.ContinueOnAddOnLoaded("totalRP3", SetLocalizedText);
end

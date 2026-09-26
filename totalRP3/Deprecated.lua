-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

-- Anything in this file is deprecated and will be removed in future versions
-- of TRP, potentially without warning.

TRP3_InterfaceIcons = TRP3_InterfaceIconNames;

function TRP3_API.utils.getIconTexture(icon)
	if type(icon) == "table" and icon.isInstanceOf and icon:isInstanceOf(TRP3_API.Ellyb.Icon) then
		return icon:GetFileID();
	elseif type(icon) == "number" then
		return icon;
	else
		return "Interface\\ICONS\\" .. tostring(icon);
	end
end

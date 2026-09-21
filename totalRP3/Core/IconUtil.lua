-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

---@alias TRP3.IconIdentifier string|integer
---An icon name, atlas name, or LibRPMedia icon ID.

TRP3_IconUtil = {};

---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.IsValidIcon(icon)
	return (icon ~= nil and LRPM12:ResolveIconID(icon) ~= nil);
end

---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.GetIconID(icon)
	return LRPM12:ResolveIconID(icon);
end

---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.GetIconInfo(icon)
	local iconID = LRPM12:ResolveIconID(icon);

	if iconID then
		return LRPM12:GetIconInfoByID(iconID);
	end
end

---@param texture Texture
---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.SetTextureToIcon(texture, icon)
	local iconInfo = TRP3_IconUtil.GetIconInfo(icon);

	if iconInfo == nil then
		iconInfo = TRP3_IconUtil.GetIconInfo("inv_misc_questionmark");
	end

	if iconInfo.file then
		texture:SetTexture(iconInfo.file);
	elseif iconInfo.atlas then
		texture:SetAtlas(iconInfo.atlas);
	end
end

return TRP3_IconUtil;

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

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
function TRP3_IconUtil.GetIconName(icon)
	local iconID = LRPM12:ResolveIconID(icon);

	if iconID then
		return LRPM12:GetIconNameByID(iconID);
	end
end

---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.GetIconInfo(icon)
	local iconID = LRPM12:ResolveIconID(icon);

	if iconID then
		return LRPM12:GetIconInfoByID(iconID);
	end
end

---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.SerializeIcon(icon)
	if icon ~= nil then
		-- Serialization of an icon attempts where possible to promote any
		-- incoming icon references to stringified IDs. If we can't resolve
		-- an icon however, do not default or nil it. Serialization is not
		-- a validation layer, and we should retain invalid/unknown inputs
		-- and handle those at display and communication boundaries only.

		local iconID = LRPM12:ResolveIconID(icon);

		if iconID then
			icon = iconID;
		end

		icon = tostring(icon);
	end

	return icon;
end

---@param texture Texture
---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.SetTextureToIcon(texture, icon)
	local iconInfo = TRP3_IconUtil.GetIconInfo(icon);

	if iconInfo == nil then
		iconInfo = TRP3_IconUtil.GetIconInfo(TRP3_InterfaceIconIDs.Default);
	end

	if iconInfo.file then
		texture:SetTexture(iconInfo.file);
	elseif iconInfo.atlas then
		texture:SetAtlas(iconInfo.atlas);
	end
end

---@param icon TRP3.IconIdentifier?
function TRP3_IconUtil.SetCursor(icon)
	local iconInfo = TRP3_IconUtil.GetIconInfo(icon);

	if iconInfo == nil then
		iconInfo = TRP3_IconUtil.GetIconInfo(TRP3_InterfaceIconIDs.Default);
	end

	if iconInfo.file then
		SetCursor(iconInfo.file);
	else
		-- Atlases can't be used as cursor assets. Use a software cursor
		-- with a texture region instead. This will noticably lag behind
		-- the hardware cursor when moved. The ItemCursor mode puts a small
		-- arrow at the top-left of the icon to make it look more like a
		-- regular cursor.
		local offsetX = 1;
		local offsetY = -1;
		SetCursorByMode(Enum.Cursormode.ItemCursor);
		TRP3_API.Ellyb.Cursor:SetIcon(iconInfo.atlas, offsetX, offsetY);
	end
end

function TRP3_IconUtil.ClearCursor()
	ResetCursor();
	TRP3_API.Ellyb.Cursor:ClearIcon();
end

return TRP3_IconUtil;

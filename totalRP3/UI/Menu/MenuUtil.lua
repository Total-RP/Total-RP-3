-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_MenuUtil = {};

function TRP3_MenuUtil.SetElementTooltip(elementDescription, tooltipText)
	local function OnTooltipShow(tooltip)
		local tooltipTitle = MenuUtil.GetElementText(elementDescription);

		GameTooltip_SetTitle(tooltip, tooltipTitle);
		GameTooltip_AddNormalLine(tooltip, tooltipText, true);
	end

	elementDescription:SetTooltip(OnTooltipShow);
end

function TRP3_MenuUtil.AttachTexture(elementDescription, texture)
	local function Initializer(button)
		local textureObject = button:AttachTexture();
		textureObject:SetPoint("RIGHT");
		textureObject:SetSize(16, 16);

		if C_Texture.GetAtlasInfo(texture) then
			local useAtlasSize = false;
			textureObject:SetAtlas(texture, useAtlasSize);
		else
			textureObject:SetTexture(texture);
		end
	end

	elementDescription:AddInitializer(Initializer);
end

function TRP3_MenuUtil.AttachIconTexture(elementDescription, icon)
	local function Initializer(button)
		local textureObject = button:AttachTexture();
		textureObject:SetPoint("RIGHT");
		textureObject:SetSize(16, 16);
		TRP3_IconUtil.SetTextureToIcon(textureObject, icon);
	end

	elementDescription:AddInitializer(Initializer);
end

function TRP3_MenuUtil.CreateContextMenu(ownerRegion, menuGenerator)
	local function WrappedMenuGenerator(ownerRegion, rootDescription)  -- luacheck: no redefined (ownerRegion)
		TRP3_MenuUtil.PrepareRootMenuDescription(rootDescription);
		return menuGenerator(ownerRegion, rootDescription);
	end

	return MenuUtil.CreateContextMenu(ownerRegion, WrappedMenuGenerator);
end

function TRP3_MenuUtil.PrepareRootMenuDescription(rootDescription)
	-- Resolving taint issues with dropdowns - if no minimum width is defined
	-- then if tainted code is the first thing to open a custom menu the
	-- 'minimumWidth' field on menu frames is assigned a tainted nil value.
	--
	-- This then taints menus open by secure code later on if they themselves
	-- don't set a minimum width due to metatable bullshit in the compositor.
	--
	-- Can remove when WowUIBugs#783 is fixed.

	rootDescription:SetMinimumWidth(1);
end

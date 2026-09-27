-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_MenuTemplates = {};

function TRP3_MenuTemplates.CreateColorSelectionButton(text, color, callback, data)
	local elementDescription = MenuUtil.CreateButton(text, callback, data);

	local function ColorSwatchInitializer(frame)
		frame.colorSwatch = frame:AttachTemplate("TRP3_ColorSwatchTemplate");
		frame.colorSwatch:SetPoint("LEFT");
		frame.colorSwatch:SetSize(16, 16);
		frame.colorSwatch:SetColor(color);

		frame.fontString:SetPoint("LEFT", frame.colorSwatch, "RIGHT", 5, 0);
	end

	elementDescription:AddInitializer(ColorSwatchInitializer);
	return elementDescription;
end

---@alias TRP3.IconContextMenuPasteCallback fun(icon: TRP3.IconIdentifier)

---@class TRP3.IconContextMenuHandler
---@field private pasteCallback TRP3.IconContextMenuPasteCallback
local IconContextMenuHandler = {};

function IconContextMenuHandler:GetPasteCallback()
	return self.pasteCallback;
end

---@param callback TRP3.IconContextMenuPasteCallback
function IconContextMenuHandler:SetPasteCallback(callback)
	self.pasteCallback = callback;
end

function TRP3_MenuTemplates.CreateIconContextMenuHandler()
	local handler = TRP3_API.AllocateObject(IconContextMenuHandler);
	return handler;
end

---@param ownerRegion Frame
---@param handler TRP3.IconContextMenuHandler
---@param icon TRP3.IconIdentifier
function TRP3_MenuTemplates.CreateIconContextMenu(ownerRegion, handler, icon)
	local function GenerateMenu(_owner, description)
		TRP3_MenuTemplates.AppendIconContextMenuElements(description, handler, icon);
	end

	return TRP3_MenuUtil.CreateContextMenu(ownerRegion, GenerateMenu);
end

---@param description table
---@param handler TRP3.IconContextMenuHandler
---@param icon TRP3.IconIdentifier
function TRP3_MenuTemplates.AppendIconContextMenuElements(description, handler, icon)
	do
		local function OnClick()
			TRP3_API.SetLastCopiedIcon(icon);
		end

		description:CreateButton(L.UI_ICON_COPY, OnClick);
	end

	do
		local function OnClick()
			local iconName = TRP3_IconUtil.GetIconName(icon);
			TRP3_API.popup.showCopyDropdownPopup({ iconName });
		end

		description:CreateButton(L.UI_ICON_COPYNAME, OnClick);
	end

	if handler:GetPasteCallback() then
		local function OnClick()
			local lastCopiedIcon = TRP3_API.GetLastCopiedIcon();
			local callback = handler:GetPasteCallback();

			if callback then
				callback(lastCopiedIcon);
			end
		end

		local function OnTooltipShow(tooltip)
			local lastCopiedIcon = TRP3_API.GetLastCopiedIcon();

			if lastCopiedIcon then
				GameTooltip_SetTitle(tooltip, TRP3_MarkupUtil.GenerateIconMarkup(lastCopiedIcon, { size = 48 }));
			end
		end

		local function HasCopiedIcon()
			return TRP3_API.GetLastCopiedIcon() ~= nil;
		end

		local button = description:CreateButton(L.UI_ICON_PASTE, OnClick);
		button:SetEnabled(HasCopiedIcon);
		button:SetTooltip(OnTooltipShow);
	end
end

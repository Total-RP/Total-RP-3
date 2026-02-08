---@class TRP3
local TRP3 = select(2, ...);
local Ellyb = TRP3.Ellyb;

if Ellyb.Popups then
	return
end

local Popups = {};
Ellyb.Popups = Popups;

-- luacheck: globals Ellyb_StaticPopOpenUrl
---@type Frame
local URLPopup = Ellyb_StaticPopOpenUrl;
URLPopup.Button.Text:SetText(OKAY);
Ellyb.EditBoxes.makeReadOnly(URLPopup.Url);
Ellyb.EditBoxes.selectAllTextOnFocus(URLPopup.Url);
Ellyb.EditBoxes.looseFocusOnEscape(URLPopup.Url);
-- Clear global variable
_G["Ellyb_StaticPopOpenUrl"] = nil;

local function dismissPopup()
	URLPopup:Hide();
end
URLPopup.Url:HookScript("OnEnterPressed", dismissPopup);
URLPopup.Url:HookScript("OnEscapePressed", dismissPopup);
URLPopup.Url:HookScript("OnKeyDown", function(_, key)
	if key == "C" and IsControlKeyDown() then
		local systemInfo = ChatTypeInfo["SYSTEM"];
		UIErrorsFrame:AddMessage(URLPopup.alertMessage, systemInfo.r, systemInfo.g, systemInfo.b);
		PlaySound(TRP3_InterfaceSounds.PopupClose);
		dismissPopup();
	end
end);

--- Open a popup with an autofocused text field to let the user copy the URL
---@param url string The URL we want to let the user copy
---@param customText string A custom text to display, instead of the default hint to copy the URL
---@param customShortcutInstructions string A custom text for the copy and paste shortcut instructions.
---@overload fun(url: string)
---@overload fun(url: string, customText: string)
function Popups:OpenURL(url, customText, customShortcutInstructions, customAlertOnClose)
	local popupText = customText and (customText .. "\n\n") or "";
	if not customShortcutInstructions then
		customShortcutInstructions = TRP3.loc.COPY_URL_POPUP_TEXT;
	end

	local copyShortcut = TRP3.FormatShortcut("CTRL-C", TRP3.ShortcutType.System);
	local pasteShortcut = TRP3.FormatShortcut("CTRL-V", TRP3.ShortcutType.System);

	popupText = popupText .. customShortcutInstructions:format(TRP3.Colors.Green(copyShortcut), TRP3.Colors.Green(pasteShortcut));
	URLPopup.Text:SetText(popupText);
	URLPopup.Url:SetText(url);
	if not customAlertOnClose then
		customAlertOnClose = TRP3.loc.COPY_SYSTEM_MESSAGE;
	end
	URLPopup.alertMessage = customAlertOnClose;
	URLPopup:SetHeight(120 + URLPopup.Text:GetHeight());
	URLPopup:Show();
end

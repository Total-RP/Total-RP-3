-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local function CallUnhookedMethod(widget, methodName, ...)
	getmetatable(widget).__index[methodName](widget, ...);
end

TRP3_HTMLFrameMixin = CreateFromMixins(CallbackRegistryMixin);
TRP3_HTMLFrameMixin:GenerateCallbackEvents({ "OnSizeChanged" });

function TRP3_HTMLFrameMixin:OnLoad()
	CallbackRegistryMixin.OnLoad(self);
	TRP3_LinkHandlerMixin.OnLoad(self);

	if self.registerStandardLinkHandlers then
		TRP3_LinkUtil.RegisterStandardLinkHandlers(self);
	end

	self:ClearText();
end

function TRP3_HTMLFrameMixin:OnShow()
	self:Layout();
end

function TRP3_HTMLFrameMixin:OnUpdate()
	self:Layout();
end

function TRP3_HTMLFrameMixin:OnSizeChanged(width, height)
	self:TriggerEvent("OnSizeChanged", width, height);
end

function TRP3_HTMLFrameMixin:ClearText()
	self:SetPlainText("");
end

function TRP3_HTMLFrameMixin:SetHTML(html)
	local ignoreMarkup = false;
	self:SetText(html, ignoreMarkup);
end

function TRP3_HTMLFrameMixin:SetPlainText(text)
	local ignoreMarkup = true;
	self:SetText(text, ignoreMarkup);
end

function TRP3_HTMLFrameMixin:SetRichText(text, options)
	local noColor = options and not options.enableLinkBrackets or false;
	local noBrackets = options and not options.enableLinkColoring or false;
	local defaultLinkType = options and options.defaultLinkType or "external";

	local html = TRP3_API.utils.str.toHTML(text, noColor, noBrackets, defaultLinkType);
	self:SetHTML(html);
end

function TRP3_HTMLFrameMixin:SetText(text, ignoreMarkup)
	-- We replace the normal SetText method on these frames to capture the
	-- original parameters so that text can later be refreshed if the layout
	-- of the frame needs to be updated in response to resizing.

	local function UpdateText(frame)
		CallUnhookedMethod(frame, "SetText", text, ignoreMarkup);
	end

	self.updateText = UpdateText;
	self:MarkDirty();
end

function TRP3_HTMLFrameMixin:UpdateText()
	if self.updateText then
		securecallfunction(self.updateText, self);
	end
end

function TRP3_HTMLFrameMixin:MarkDirty()
	self:SetScript("OnUpdate", self.OnUpdate);
end

function TRP3_HTMLFrameMixin:MarkClean()
	self:SetScript("OnUpdate", nil);
end

function TRP3_HTMLFrameMixin:Layout()
	self:MarkClean();

	-- Querying the content height requires a refresh of the text to process
	-- any changes to the width of this frame.

	self:UpdateText();
	self:SetHeight(self:GetContentHeight());
end

-- Following methods make it possible to integrate HTMLFrames into layout
-- templates with automatic `HTMLFrame:Layout()` calls being made whenever
-- the parent requires it.

function TRP3_HTMLFrameMixin:IsLayoutFrame()
	return true;
end

function TRP3_HTMLFrameMixin:IgnoreLayoutIndex()
	return true;
end

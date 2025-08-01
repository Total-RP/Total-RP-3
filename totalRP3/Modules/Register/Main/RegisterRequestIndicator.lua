-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

TRP3_RegisterRequestIndicatorMixin = {};

local CallbackGroup = {
	Dynamic = "dynamic",
	Static = "static",
};

function TRP3_RegisterRequestIndicatorMixin:OnLoad()
	self.callbacks = TRP3_API.CreateCallbackGroupCollection();
	self.callbacks:AddCallback(CallbackGroup.Dynamic, TRP3_Addon, "REGISTER_REQUEST_STATE_CHANGED", "OnRegisterRequestStateChanged", self);
	self.callbacks:AddCallback(CallbackGroup.Static, TRP3_Addon, "PAGE_OPENED", "OnPageOpened", self);
	self.callbacks:RegisterGroup(CallbackGroup.Static);

	-- Frame edge gradients have no XML integration.
	-- Note that even if no fading is requested on an edge, both gradient
	-- indices must be populated or we'll end up with a mostly invisible
	-- frame. Also, this requires render layer flattening to be enabled or no
	-- fade will occur.

	local edgeFadeTop = 15;
	local edgeFadeLeft = 15;
	local edgeFadeRight = 0;
	local edgeFadeBottom = 0;

	self.Background:SetAlphaGradient(0, CreateVector2D(edgeFadeLeft, edgeFadeTop));
	self.Background:SetAlphaGradient(1, CreateVector2D(edgeFadeRight, edgeFadeBottom));
end

function TRP3_RegisterRequestIndicatorMixin:OnEnabled()
	self.callbacks:Register();
end

function TRP3_RegisterRequestIndicatorMixin:OnDisabled()
	self.callbacks:Unregister();
end

function TRP3_RegisterRequestIndicatorMixin:OnRegisterRequestStateChanged()
	self:UpdateShownState();
end

function TRP3_RegisterRequestIndicatorMixin:OnPageOpened()
	self:UpdateDynamicCallbacks();
	self:UpdateShownState();
end

function TRP3_RegisterRequestIndicatorMixin:BeginShow()
	local progress = self.FadeAnimation:GetProgress();
	local isFading = self.FadeAnimation:IsPlaying();
	local isShown = self:IsShown();

	self.FadeAnimation:SetScript("OnPlay", function() self:Show(); end);
	self.FadeAnimation:SetScript("OnFinished", nil);

	local reverse = false;
	local offset = isFading and (1 - progress) or (isShown and 1 or 0);
	self.FadeAnimation:Restart(reverse, offset);
end

function TRP3_RegisterRequestIndicatorMixin:BeginHide()
	local progress = self.FadeAnimation:GetProgress();
	local isFading = self.FadeAnimation:IsPlaying();
	local isShown = self:IsShown();

	self.FadeAnimation:SetScript("OnPlay", nil);
	self.FadeAnimation:SetScript("OnFinished", function() self:Hide(); end);

	local reverse = true;
	local offset = isFading and (1 - progress) or (isShown and 0 or 1);
	self.FadeAnimation:Restart(reverse, offset);
end

function TRP3_RegisterRequestIndicatorMixin:ApplyShownState(shouldShow)
	local isShown = self:IsShown();

	if shouldShow and not isShown then
		self:BeginShow();
	elseif not shouldShow and isShown then
		self:BeginHide();
	end
end

function TRP3_RegisterRequestIndicatorMixin:IsEnabledFromNavigationContext(pageID, context)
	return pageID == "player_main" and context ~= nil and context.source == "directory" and context.unitID ~= nil;
end

function TRP3_RegisterRequestIndicatorMixin:UpdateShownState()
	local pageID = TRP3_API.navigation.page.getCurrentPageID();
	local context = TRP3_API.navigation.page.getCurrentContext();

	if self:IsEnabledFromNavigationContext(pageID, context) then
		local shouldShow = TRP3_API.register.HasActiveRequest(context.unitID);
		self:ApplyShownState(shouldShow);
	else
		self:Hide();
	end
end

function TRP3_RegisterRequestIndicatorMixin:UpdateDynamicCallbacks()
	local pageID = TRP3_API.navigation.page.getCurrentPageID();
	local context = TRP3_API.navigation.page.getCurrentContext();

	if self:IsEnabledFromNavigationContext(pageID, context) then
		self.callbacks:RegisterGroup(CallbackGroup.Dynamic);
	else
		self.callbacks:UnregisterGroup(CallbackGroup.Dynamic);
	end
end

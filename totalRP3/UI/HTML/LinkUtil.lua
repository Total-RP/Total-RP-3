-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local L = TRP3_API.loc;

TRP3_LinkUtil = {};

function TRP3_LinkUtil.OpenLinkCopyDialog(link)
	TRP3_LinkCopyDialog:Open(link);
end

function TRP3_LinkUtil.CreateLinkCopyTooltip(description, text, link)
	description:AddTitleLine(text);
	description:AddNormalLine(link);
	description:AddBlankLine();
	description:AddInstructionLine("CLICK", L.CM_COPY_URL);
end

function TRP3_LinkUtil.CreateLinkString(linkType, linkData)
	return string.join(":", linkType, linkData);
end

function TRP3_LinkUtil.UnpackLinkString(link)
	return string.split(":", link, 2);
end

function TRP3_LinkUtil.CreateLinkAnchor(point, linkInfo, relativePoint, offsetX, offsetY)
	-- Note that the "bottom" coordinate in the link info is seemingly a lie
	-- and should actually be "top", but Blizzard call it "bottom" so we're
	-- sticking with their nonsense.

	relativePoint = relativePoint or point;
	offsetX = (offsetX or 0) + linkInfo.left;
	offsetY = (offsetY or 0) + linkInfo.bottom;

	if relativePoint == "TOP" or relativePoint == "CENTER" or relativePoint == "BOTTOM" then
		offsetX = offsetX + (linkInfo.width / 2);
	elseif relativePoint == "TOPRIGHT" or relativePoint == "RIGHT" or relativePoint == "BOTTOMRIGHT" then
		offsetX = offsetX + linkInfo.width;
	end

	if relativePoint == "LEFT" or relativePoint == "CENTER" or relativePoint == "RIGHT" then
		offsetY = offsetY - (linkInfo.height / 2);
	elseif relativePoint == "BOTTOMLEFT" or relativePoint == "BOTTOM" or relativePoint == "BOTTOMRIGHT" then
		offsetY = offsetY - linkInfo.height;
	end

	return AnchorUtil.CreateAnchor(point, linkInfo.region, "TOPLEFT", offsetX, offsetY);
end

function TRP3_LinkUtil.CreateLinkInfo(frame, link, text, region, left, bottom, width, height)
	local linkType, linkData = TRP3_LinkUtil.UnpackLinkString(link);

	return  {
		frame = frame,
		type = linkType,
		data = linkData,
		link = link,
		text = text,
		region = region,
		bottom = bottom,
		left = left,
		width = width,
		height = height,
	};
end

local LinkHandler = {};

function LinkHandler:SetClickCallback(callback)
	self.clickCallback = callback;
end

function LinkHandler:HandleClick(linkInfo, mouseButtonName)
	if self.clickCallback then
		securecallfunction(self.clickCallback, linkInfo, mouseButtonName);
		return true;
	end
end

function LinkHandler:SetEnterCallback(callback)
	self.enterCallback = callback;
end

function LinkHandler:HandleEnter(linkInfo)
	if self.enterCallback then
		securecallfunction(self.enterCallback, linkInfo);
		return true;
	end
end

function LinkHandler:SetLeaveCallback(callback)
	self.leaveCallback = callback;
end

function LinkHandler:HandleLeave(linkInfo)
	if self.leaveCallback then
		securecallfunction(self.leaveCallback, linkInfo);
		return true;
	end
end

function LinkHandler:SetTooltipCallback(callback)
	self:SetEnterCallback(nil);
	self:SetLeaveCallback(nil);

	if not callback then
		return;
	end

	local function OnTooltipShow(owner, description, linkInfo)
		local anchor = TRP3_LinkUtil.CreateLinkAnchor("BOTTOM", linkInfo, "TOP", 0, 5);
		description:SetAnchor(anchor);
		securecallfunction(callback, owner, description, linkInfo);
	end

	local function OnEnter(linkInfo)
		TRP3_TooltipUtil.ShowTooltip(linkInfo.region, OnTooltipShow, linkInfo);
	end

	local function OnLeave(linkInfo)
		TRP3_TooltipUtil.HideTooltip(linkInfo.region);
	end

	self:SetEnterCallback(OnEnter);
	self:SetLeaveCallback(OnLeave);
end

local function CreateLinkHandler()
	return TRP3_API.CreateObject(LinkHandler);
end

function TRP3_LinkUtil.CreateLinkHandler(clickCallback, tooltipCallback)
	local handler = CreateLinkHandler();
	handler:SetClickCallback(clickCallback);
	handler:SetTooltipCallback(tooltipCallback);
	return handler;
end

local LinkHandlerCollection = {};

function LinkHandlerCollection:__init()
	self.handlers = {};
end

function LinkHandlerCollection:CreateLinkHandler(linkType, clickCallback, tooltipCallback)
	local handler = TRP3_LinkUtil.CreateLinkHandler(clickCallback, tooltipCallback);
	return self:RegisterLinkHandler(linkType, handler);
end

function LinkHandlerCollection:RegisterLinkHandler(linkType, handler)
	self.handlers[linkType] = handler;
	return handler;
end

function LinkHandlerCollection:UnregisterLinkHandler(linkType)
	self.handlers[linkType] = nil;
end

function LinkHandlerCollection:UnregisterAllLinkHandlers()
	self.handlers = {};
end

function LinkHandlerCollection:HandleClick(linkInfo, mouseButtonName)
	local handler = self.handlers[linkInfo.type];

	if handler then
		handler:HandleClick(linkInfo, mouseButtonName);
	end
end

function LinkHandlerCollection:HandleLeave(linkInfo)
	local handler = self.handlers[linkInfo.type];

	if handler then
		handler:HandleLeave(linkInfo);
	end
end

function LinkHandlerCollection:HandleEnter(linkInfo)
	local handler = self.handlers[linkInfo.type];

	if handler then
		handler:HandleEnter(linkInfo);
	end
end

function TRP3_LinkUtil.CreateLinkHandlerCollection()
	return TRP3_API.CreateObject(LinkHandlerCollection);
end

function TRP3_LinkUtil.AddLinkHandlerBehavior(frame)
	local handlers = TRP3_LinkUtil.CreateLinkHandlerCollection();

	local function OnHyperlinkClick(self, link, text, mouseButtonName, region, left, bottom, width, height)
		local linkInfo = TRP3_LinkUtil.CreateLinkInfo(self, link, text, region, left, bottom, width, height);
		handlers:HandleClick(linkInfo, mouseButtonName);
	end

	local function OnHyperlinkEnter(self, link, text, region, left, bottom, width, height)
		local linkInfo = TRP3_LinkUtil.CreateLinkInfo(self, link, text, region, left, bottom, width, height);

		-- The enter and leave scripts are asymmetrical with respect to their
		-- parameters, so we capture the link and region data in the enter
		-- and replace the leave script with a single-shot closure to supply
		-- handlers full information in both callbacks.

		local function OnHyperlinkLeave(self)  -- luacheck: no redefined (self)
			self:SetScript("OnHyperlinkLeave", nil);
			handlers:HandleLeave(linkInfo);
		end

		self:SetScript("OnHyperlinkLeave", OnHyperlinkLeave);
		handlers:HandleEnter(linkInfo);
	end

	frame:SetScript("OnHyperlinkClick", OnHyperlinkClick);
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter);
	frame:SetScript("OnHyperlinkLeave", nil);  -- See OnHyperlinkEnter.

	return handlers;
end

TRP3_LinkHandlerMixin = {};

function TRP3_LinkHandlerMixin:OnLoad()
	self.hyperlinks = TRP3_LinkUtil.AddLinkHandlerBehavior(self);
end

function TRP3_LinkHandlerMixin:CreateLinkHandler(linkType, clickCallback, tooltipCallback)
	return self.hyperlinks:CreateLinkHandler(linkType, clickCallback, tooltipCallback);
end

function TRP3_LinkHandlerMixin:RegisterLinkHandler(linkType, handler)
	return self.hyperlinks:RegisterLinkHandler(linkType, handler);
end

function TRP3_LinkHandlerMixin:UnregisterLinkHandler(linkType)
	self.hyperlinks:UnregisterLinkHandler(linkType);
end

function TRP3_LinkHandlerMixin:UnregisterAllLinkHandlers()
	self.hyperlinks:UnregisterAllLinkHandlers();
end

function TRP3_LinkUtil.CreateExternalLinkHandler(owner)
	local function OnTooltipShow(_, description, linkInfo)
		local text = linkInfo.text;
		local link = linkInfo.data;

		text = TRP3_API.utils.str.sanitize(text);
		text = string.gsub(text, "^%[", "");
		text = string.gsub(text, "%]$", "");

		TRP3_LinkUtil.CreateLinkCopyTooltip(description, text, link);
	end

	local function OnClick(linkInfo)
		TRP3_LinkUtil.OpenLinkCopyDialog(linkInfo.data);
	end

	return owner:CreateLinkHandler("external", OnClick, OnTooltipShow);
end

function TRP3_LinkUtil.CreateTwitterLinkHandler(owner)
	local function GenerateURL(linkInfo)
		return "https://twitter.com/" .. linkInfo.data;
	end

	local function OnTooltipShow(_, description, linkInfo)
		local text = linkInfo.text;
		local link = GenerateURL(linkInfo);

		text = TRP3_API.utils.str.sanitize(text);

		TRP3_LinkUtil.CreateLinkCopyTooltip(description, text, link);
	end

	local function OnClick(linkInfo)
		TRP3_LinkUtil.OpenLinkCopyDialog(GenerateURL(linkInfo));
	end

	return owner:CreateLinkHandler("twitter", OnClick, OnTooltipShow);
end

function TRP3_LinkUtil.RegisterStandardLinkHandlers(ownerRegion)
	TRP3_LinkUtil.CreateTwitterLinkHandler(ownerRegion);
	TRP3_LinkUtil.CreateExternalLinkHandler(ownerRegion);
end

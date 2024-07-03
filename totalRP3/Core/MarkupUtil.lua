-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

TRP3_MarkupUtil = {};

local function UnpackMarkupSize(description)
	local width = description.size or description.width or 0;
	local height = description.size or description.height or 0;
	return width, height;
end

local function UnpackMarkupOffset(description)
	local offsetX = description.offsetX or 0;
	local offsetY = description.offsetY or 0;
	return offsetX, offsetY;
end

function TRP3_MarkupUtil.GenerateAtlasMarkup(atlas, description)
	local width, height = UnpackMarkupSize(description);
	local offsetX, offsetY = UnpackMarkupOffset(description);
	return string.format("|A:%s:%d:%d:%d:%d|a", atlas, height, width, offsetX, offsetY);
end

function TRP3_MarkupUtil.GenerateIconMarkup(icon, description)
	local width, height = UnpackMarkupSize(description);
	local offsetX, offsetY = UnpackMarkupOffset(description);
	return LRPM12:GenerateIconMarkup(icon, width, height, offsetX, offsetY);
end

function TRP3_MarkupUtil.GenerateFileMarkup(file, description)
	local fileID = tonumber(file) or GetFileIDFromPath(file);
	local width, height = UnpackMarkupSize(description);
	local offsetX, offsetY = UnpackMarkupOffset(description);
	return string.format("|T%s:%d:%d:%d:%d|t", fileID or "", height, width, offsetX, offsetY);
end

function TRP3_MarkupUtil.GenerateSpacerMarkup(description)
	local file = "interface/addons/totalrp3/resources/ui/transparent";
	return TRP3_MarkupUtil.GenerateFileMarkup(file, description);
end

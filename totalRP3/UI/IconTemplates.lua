-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local LRPM12 = LibStub:GetLibrary("LibRPMedia-1.2");

TRP3_IconMixin = {};

function TRP3_IconMixin:SetIconTexture(icon)
	LRPM12:SetTextureToIcon(self, icon);
end

TRP3_BorderedIconMixin = {};

function TRP3_BorderedIconMixin:SetIconTexture(icon)
	self.Icon:SetIconTexture(icon);
end

function TRP3_BorderedIconMixin:SetIconTextureToFile(texture)
	self.Icon:SetTexture(texture);
end

function TRP3_BorderedIconMixin:SetIconTextureToAtlas(atlas)
	self.Icon:SetAtlas(atlas);
end

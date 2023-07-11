-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local StyledButtonSetup = {
	{ pieceName = "NormalTexture" },
	{ pieceName = "PushedTexture" },
	{ pieceName = "DisabledTexture" },
	{ pieceName = "HighlightTexture" },
};

local function UnpackTexCoords(tbl)
	local left = tbl.leftTexCoord or 0;
	local right = tbl.rightTexCoord or 1;
	local top = tbl.topTexCoord or 0;
	local bottom = tbl.bottomTexCoord or 1;

	return left, right, top, bottom;
end

local function GetPieceTexture(container, pieceName)
	local piece;

	if container.GetStyledButtonPiece then
		piece = container:GetStyledButtonPiece(pieceName);
	end

	if not piece then
		piece = container[pieceName];
	end

	if not piece then
		piece = container["Get" .. pieceName](container);
	end

	return piece;
end

local function SetupPieceTextureCoordinates(piece, pieceLayout)
	local left, right, top, bottom = UnpackTexCoords(pieceLayout);

	if pieceLayout.mirrorHorizontal then
		left, right = right, left;
	end

	if pieceLayout.mirrorVertical then
		top, bottom = bottom, top;
	end

	piece:SetTexCoord(left, right, top, bottom);
end

local function SetupStyledButtonPiece(piece, setupInfo, pieceLayout)  -- luacheck: no unused (setupInfo)
	SetupPieceTextureCoordinates(piece, pieceLayout);

	if pieceLayout.atlas then
		piece:SetAtlas(pieceLayout.atlas);
	elseif pieceLayout.file then
		piece:SetTexture(pieceLayout.file);
	end

	piece:SetBlendMode(pieceLayout.blendMode or "BLEND");
end

TRP3_StyledButtonKits = {};
TRP3_StyledButtonUtil = {};

function TRP3_StyledButtonUtil.ApplyStyle(container, styleInfo)
	for _, setupInfo in ipairs(StyledButtonSetup) do
		local pieceName = setupInfo.pieceName;
		local pieceLayout = styleInfo[pieceName];
		local piece = GetPieceTexture(container, pieceName);

		if pieceLayout then
			SetupStyledButtonPiece(piece, setupInfo, pieceLayout);
		end
	end
end

function TRP3_StyledButtonUtil.ApplyStyleByName(container, styleName)
	local styleInfo = TRP3_StyledButtonUtil.GetStyle(styleName);
	assert(styleInfo, "unknown button style");
	TRP3_StyledButtonUtil.ApplyStyle(container, styleInfo);
end

function TRP3_StyledButtonUtil.GetStyle(styleName)
	return TRP3_StyledButtonKits[styleName];
end

function TRP3_StyledButtonUtil.RegisterStyle(styleName, styleInfo)
	-- Duplicate registrations permitted to allow replacing styles.
	TRP3_StyledButtonKits[styleName] = CopyTable(styleInfo);
end

TRP3_StyledButtonMixin = {};

function TRP3_StyledButtonMixin:OnLoad()
	local styleName = self.styleName;
	local styleInfo = TRP3_StyledButtonUtil.GetStyle(styleName);

	if styleInfo then
		TRP3_StyledButtonUtil.ApplyStyle(self, styleInfo);
	end
end

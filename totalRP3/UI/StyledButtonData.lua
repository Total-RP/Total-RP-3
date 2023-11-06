-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local function ApplyHorizontalMirroring(styleInfo)
	for _, pieceLayout in pairs(styleInfo) do
		pieceLayout.mirrorHorizontal = true;
	end

	return styleInfo;
end

local function ApplyTextureCoordinates(styleInfo, left, right, top, bottom)
	for _, pieceLayout in pairs(styleInfo) do
		pieceLayout.leftTexCoord = left;
		pieceLayout.rightTexCoord = right;
		pieceLayout.topTexCoord = top;
		pieceLayout.bottomTexCoord = bottom;
	end

	return styleInfo;
end

local function GenerateWindowButtonStyle(textureKit)
	local normalAtlas = string.format("RedButton-%s", textureKit);
	local pushedAtlas = string.format("RedButton-%s-Pressed", textureKit);
	local disabledAtlas = string.format("RedButton-%s-Disabled", textureKit);
	local highlightAtlas = "RedButton-Highlight";
	local styleInfo;

	if C_Texture.GetAtlasInfo(normalAtlas) then
		styleInfo = {
			NormalTexture = { atlas = normalAtlas },
			PushedTexture = { atlas = pushedAtlas },
			DisabledTexture = { atlas = disabledAtlas },
			HighlightTexture = { atlas = highlightAtlas, blendMode = "ADD" },
		};
	end

	return styleInfo;
end

local function GenerateUIPanelButtonStyle(textureKit)
	local normalTexture = string.format([[Interface\Buttons\UI-Panel-%s-Up]], textureKit);
	local pushedTexture = string.format([[Interface\Buttons\UI-Panel-%s-Down]], textureKit);
	local disabledTexture = string.format([[Interface\Buttons\UI-Panel-%s-Disabled]], textureKit);
	local highlightTexture = [[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]];

	local styleInfo = {
		NormalTexture = { file = normalTexture },
		PushedTexture = { file = pushedTexture },
		DisabledTexture = { file = disabledTexture },
		HighlightTexture = { file = highlightTexture, blendMode = "ADD" },
	};

	ApplyTextureCoordinates(styleInfo, 0.125, 0.875, 0.125, 0.875);
	return styleInfo;
end

do
	local styleInfo = GenerateWindowButtonStyle("Exit") or GenerateUIPanelButtonStyle("MinimizeButton");
	TRP3_StyledButtonUtil.RegisterStyle("CloseButton", styleInfo);
end

do
	local styleInfo = GenerateWindowButtonStyle("Expand") or GenerateUIPanelButtonStyle("BiggerButton");
	TRP3_StyledButtonUtil.RegisterStyle("MaximizeButton", styleInfo);
end

do
	local styleInfo = GenerateWindowButtonStyle("Condense") or GenerateUIPanelButtonStyle("SmallerButton");
	TRP3_StyledButtonUtil.RegisterStyle("MinimizeButton", styleInfo);
end

do
	local styleInfo = GenerateWindowButtonStyle("Condense") or GenerateUIPanelButtonStyle("SmallerButton");
	ApplyHorizontalMirroring(styleInfo);
	TRP3_StyledButtonUtil.RegisterStyle("ResizeButton", styleInfo);
end

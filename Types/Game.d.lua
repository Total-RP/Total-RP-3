---@meta

---@alias TRP3.FileID integer
---@alias TRP3.AtlasElementID integer

---@param str string
---@return integer length
function strlenutf8(str) end

---@class TooltipTextureInfo
---@field width number? can be 0 to use actual texture width
---@field height number? can be 0 to use actual texture width
---@field anchor Enum.TooltipTextureAnchor?
---@field region Enum.TooltipTextureRelativeRegion?
---@field verticalOffset number?
---@field margin { left: number?, right: number?, top: number?, bottom: number? }?
---@field texCoords { left: number?, right: number?, top: number?, bottom: number? }?
---@field vertexColor ColorMixin

---@enum Enum.CollationStrength
Enum.CollationStrength = {
	Primary = 0,
	Secondary = 1,
	Tertiary = 2,
	Quaternary = 3,
	Identical = 4,
};

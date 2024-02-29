---@meta

---@alias TRP3.ClassToken "DEATHKNIGHT" | "DEMONHUNTER" | "DRUID" | "EVOKER" | "HUNTER" | "MAGE" | "MONK" | "PALADIN" | "PRIEST" | "ROGUE" | "SHAMAN" | "WARLOCK" | "WARRIOR"
---@alias TRP3.FileID integer
---@alias TRP3.AtlasElementID integer

---@param a string
---@param b string
---@return integer order
function strcmputf8i(a, b) end

---@param str string
---@return integer length
function strlenutf8(str) end

---@param ... string
---@return string str
function string.concat(...) end

---@param delimiter string
---@param ... string
---@return string
function string.join(delimiter, ...) end

---@param delimiter string
---@param str string
---@param pieces integer?
---@return ... string
function string.split(delimiter, str, pieces) end

---@param delimiter string
---@param str string
---@param pieces integer?
---@return string[] chunks
function string.splittable(delimiter, str, pieces) end

---@param str string
---@return string str
function string.trim(str) end

---@class TooltipTextureInfo
---@field width number? can be 0 to use actual texture width
---@field height number? can be 0 to use actual texture width
---@field anchor Enum.TooltipTextureAnchor?
---@field region Enum.TooltipTextureRelativeRegion?
---@field verticalOffset number?
---@field margin { left: number?, right: number?, top: number?, bottom: number? }?
---@field texCoords { left: number?, right: number?, top: number?, bottom: number? }?
---@field vertexColor ColorMixin

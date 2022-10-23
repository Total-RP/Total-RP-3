---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Icon then
	return
end

---@class Icon : EllybTexture
local Icon = Ellyb.Class("Icon", Ellyb.Texture);

---@type Icon|fun(icon: number|string, size: number|nil):Icon
Ellyb.Icon = Icon;

local ICONS_FILE_PATH = [[Interface\ICONS\]]

---@param icon string|number
---@param size number|nil
function Icon:initialize(icon, size)
	if type(icon) == "string" then
		if not icon:lower():find("interface") then
			icon = ICONS_FILE_PATH .. icon;
		end
	end
	Ellyb.Texture.initialize(self, icon, size, size);
end

function Icon:SetTextureByIconName(iconName)
	if not iconName:lower():find(ICONS_FILE_PATH:lower()) then
		iconName = ICONS_FILE_PATH .. iconName;
	end
	self:SetTextureByID(iconName)
end
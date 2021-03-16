---@type Ellyb
local Ellyb = Ellyb(...)

if Ellyb.Texture then
	return
end

--{{{ Class declaration

--- @class EllybTexture : Object
local Texture = Ellyb.Class("Texture")
--- This class in an abstraction to help handle World of Warcraft textures, especially when dealing with both texture IDs and file path.
---@param textureSource string|number @ Texture ID, file path or atlas
---@type EllybTexture|fun(source:string|number, width:number|nil, height:number|nil):EllybTexture
Ellyb.Texture = Texture;

---@type {fileID:number, filePath:string|nil, width:number|nil, height:number|nil}[]
local private = Ellyb.getPrivateStorage();

--}}}

---@private
---@param source string|number
---@param width number|nil
---@param height number|nil
function Texture:initialize(source, width, height)
	local typeOfSource = type(source);

	if typeOfSource == "number" then
		self:SetTextureByID(source);
	elseif typeOfSource == "string" then
		self:SetTextureFromFilePath(source);
	end

	-- If width and height were given we set them now
	if width ~= nil then
		self:SetWidth(width);
	end
	if height ~= nil then
		self:SetHeight(height);
	end
end

--{{{ File resource

---@param fileID number @ The file ID you want to use for this texture.
function Texture:SetTextureByID(fileID)
	private[self].fileID = fileID;
end

---@return number fileID @ A file ID that can be used to access this texture.
function Texture:GetFileID()
	return private[self].fileID;
end

--- Set the texture using a file path. A file ID will be automatically resolved and used later.
---@param filePath string @ The file path you want to use for this texture
function Texture:SetTextureFromFilePath(filePath)
	private[self].filePath = filePath;
	if GetFileIDFromPath then
		self:SetTextureByID(GetFileIDFromPath(filePath));
	end
end

--- Get the file path that was used to create this texture.
--- Since there is no way to get a path from a file ID
---@return string|nil filePath @ The file path if the texture was created with one, otherwise nil if we don't have the information
function Texture:GetFilePath()
	return private[self].filePath;
end

function Texture:GetFileName()
	return self:GetFilePath() and self:GetFilePath():match("^.+\\(.+)$")
end

--- Check if this texture is using custom assets.
--- Custom assets provided by add-ons will have a negative file ID. It is temporary and will change for every session.
---@return boolean isUsingCustomAssets @ True if the texture is custom asset, false if it comes from the game's default files.
function Texture:IsUsingCustomAssets()
	return self:GetFileID() < 0;
end

function Texture:GetResource()
	return self:GetFileID() or self:GetFilePath();
end

--}}}

--{{{ UI Widget usage

--- Apply the texture to a Texture UI widget
---@param texture Texture
function Texture:Apply(texture)
	texture:SetTexture(self:GetResource());

	if self:GetWidth() then
		texture:SetWidth(self:GetWidth());
	end

	if self:GetHeight() then
		texture:SetHeight(self:GetHeight());
	end
end

--}}}

--{{{ Size manipulation

function Texture:SetWidth(width)
	private[self].width = width;
end

---@return number
function Texture:GetWidth()
	return private[self].width;
end

function Texture:SetHeight(height)
	private[self].height = height;
end

---@return number
function Texture:GetHeight()
	return private[self].height;
end

--}}}

--{{{ String representation

---@return string texture @ Generate a string version of the texture using the width and height defined or 50px as a default value
function Texture:__tostring()
	return self:GenerateString(self:GetWidth(), self:GetHeight());
end

local TEXTURE_STRING_ESCAPE_SEQUENCE = [[|T%s:%s:%s|t]];
local TEXTURE_WITH_COORDINATES_STRING_ESCAPE_SEQUENCE = [[|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t]];
local DEFAULT_TEXTURE_SIZE = 25;

--- Generate a UI escape sequence string used to display the icon inside a text.
---@param width number|nil @ The width of the icon, by default will be 50px.
---@param height number|nil @ The height of the icon. If no height is provided but a width was defined the width will be used, otherwise the default value will be 50px
---@return string texture
function Texture:GenerateString(width, height)
	width = width or self:GetWidth() or DEFAULT_TEXTURE_SIZE;
	height = height or width;
	if self.coordinates then

		-- This is directly borrowed from Blizzard's code. Dark voodoo maths
		local atlasWidth = width / (self.coordinates.txRight - self.coordinates.txLeft);
		local atlasHeight = height / (self.coordinates.txBottom - self.coordinates.txTop);

		local pxLeft = atlasWidth * self.coordinates.txLeft;
		local pxRight = atlasWidth * self.coordinates.txRight;
		local pxTop = atlasHeight * self.coordinates.txTop;
		local pxBottom = atlasHeight * self.coordinates.txBottom;

		return TEXTURE_WITH_COORDINATES_STRING_ESCAPE_SEQUENCE:format(self:GetResource(), width, height, atlasWidth, atlasHeight, pxLeft, pxRight, pxTop, pxBottom);
	else
		return TEXTURE_STRING_ESCAPE_SEQUENCE:format(self:GetResource(), width, height);
	end
end

function Texture.CreateFromAtlas(atlasName)
	local filename, width, height, txLeft, txRight, txTop, txBottom;
	if C_Texture then
		local atlasInfo = C_Texture.GetAtlasInfo(atlasName);
		if atlasInfo then
			filename, width, height, txLeft, txRight, txTop, txBottom = atlasInfo.filename or atlasInfo.file, atlasInfo.width, atlasInfo.height, atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord;
		end
	else
		filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(atlasName);
	end

	local texture = Texture(filename);
	texture:SetCoordinates(width, height, txLeft, txRight, txTop, txBottom)
	return texture;
end

--}}}

function Texture:SetCoordinates(width, height, txLeft, txRight, txTop, txBottom)
	self.coordinates = {
		width = width,
		height = height,
		txLeft = txLeft,
		txRight = txRight,
		txTop = txTop,
		txBottom = txBottom
	}
end
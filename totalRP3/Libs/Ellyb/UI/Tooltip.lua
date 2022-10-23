---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Tooltip then
	return
end

local GameTooltip = GameTooltip;

---@class Tooltip : MiddleClass_Class
local Tooltip = Ellyb.Class("TooltipContent");
Ellyb.Tooltip = Tooltip;

---@type {parent: Frame, title: string, customTitleColor: Ellyb_Color}[]
local private = Ellyb.getPrivateStorage();

---@param parent Frame
function Tooltip:initialize(parent)
	private[self].content = {};
	private[self].tempContent = {};
	private[self].parent = parent;
	private[self].onShowCallbacks = {};
end

---@param text string
---@param customColor Ellyb_Color
function Tooltip:SetTitle(text, customColor)
	private[self].title = text;
	private[self].customTitleColor = customColor;
	return self;
end

function Tooltip:GetTitle()
	return private[self].title;
end

function Tooltip:SetTitleColor(customColor)
	private[self].customTitleColor = customColor;
	return self;
end

function Tooltip:GetTitleColor()
	if private[self].customTitleColor then
		return private[self].customTitleColor:GetRGBA();
	else
		return 1, 1, 1, 1;
	end
end

---@param anchor string
function Tooltip:SetAnchor(anchor)
	private[self].anchor = anchor;
	return self;
end

---@return string
function Tooltip:GetAnchor()
	return "ANCHOR_" .. (private[self].anchor or "RIGHT");
end

---@param parent Frame
function Tooltip:SetParent(parent)
	private[self].customParent = parent;
	return self;
end

---@return Frame
function Tooltip:GetParent()
	return private[self].customParent or private[self].parent;
end

function Tooltip:SetOffset(x, y)
	private[self].x = x;
	private[self].y = y;
	return self;
end

---@return number, number
function Tooltip:GetOffset()
	return private[self].x or 0, private[self].y or 0;
end

---@param customColor Ellyb_Color
function Tooltip:AddLine(text, customColor)
	table.insert(private[self].content, {
		text = text,
		customColor = customColor,
	});
	return self;
end

function Tooltip:AddEmptyLine()
	table.insert(private[self].content, {
		text = " ",
	});
	return self;
end

function Tooltip:AddTempLine(text, customColor)
	table.insert(private[self].tempContent, {
		text = text,
		customColor = customColor,
	});
	return self;
end

function Tooltip:GetLines()
	return private[self].content;
end

function Tooltip:GetTempLines()
	return private[self].tempContent;
end

function Tooltip:ClearLines()
	private[self].content = {};
	return self;
end

function Tooltip:ClearTempLines()
	private[self].tempContent = {};
	return self;
end

function Tooltip:SetLines(lines)
	self:ClearLines();
	for _, line in pairs(lines) do
		self:AddLine(line.text, line.customColor)
	end
	return self;
end

---SetLine
---@param text string
---@param customColor Ellyb_Color
function Tooltip:SetLine(text, customColor)
	self:ClearLines();
	self:AddLine(text, customColor);
	return self;
end

---@param tooltipFrame GameTooltip
function Tooltip:SetCustomTooltipFrame(tooltipFrame)
	private[self].tooltip = tooltipFrame;
	return self;
end

---@return GameTooltip
function Tooltip:GetTooltipFrame()
	return private[self].tooltip or GameTooltip;
end

function Tooltip:OnShow(callback)
	table.insert(private[self].onShowCallbacks, callback);
end

function Tooltip:Show()

	-- Call all the callbacks that have been registered of the OnShow event
	for _, callback in pairs(private[self].onShowCallbacks) do
		-- If one of the callback returns false, it means the tooltip should not be shown, we stop right here
		if callback(self) == false then
			return
		end
	end

	-- Do not show the tooltip if no title was defined yet
	if not self:GetTitle() then
		return
	end

	local tooltip = self:GetTooltipFrame();
	tooltip:ClearLines();
	tooltip:SetOwner(self:GetParent(), self:GetAnchor(), self:GetOffset());
	tooltip:SetText(self:GetTitle(), self:GetTitleColor());

	-- Insert all the lines inside the tooltip
	for _, line in pairs(self:GetLines()) do
		local r, g, b;
		if line.customColor then
			r, g, b = line.customColor:GetRGBAAsBytes();
		end
		tooltip:AddLine(line.text, r, g, b, true);
	end

	-- Insert all the lines inside the tooltip
	for _, line in pairs(self:GetTempLines()) do
		local r, g, b;
		if line.customColor then
			r, g, b = line.customColor:GetRGBAAsBytes();
		end
		tooltip:AddLine(line.text, r, g, b, true);
	end

	tooltip:Show();
end

function Tooltip:Hide()
	self:GetTooltipFrame():Hide();
	self:ClearTempLines();
end

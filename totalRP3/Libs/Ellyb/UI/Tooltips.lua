---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Tooltips then
	return
end

local Tooltips = {};
Ellyb.Tooltips = Tooltips;

Tooltips.ANCHORS = {
	--- Align the top right of the tooltip with the bottom left of the owner
	BOTTOMLEFT= "BOTTOMLEFT",
	--- Align the top left of the tooltip with the bottom right of the owner
	BOTTOMRIGHT= "BOTTOMRIGHT",
	--- Toolip follows the mouse cursor
	CURSOR= "CURSOR",
	--- Align the bottom right of the tooltip with the top left of the owner
	LEFT= "LEFT",
	--- Tooltip appears in the default position
	NONE= "NONE",
	--- Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
	PRESERVE= "PRESERVE",
	--- Align the bottom left of the tooltip with the top right of the owner
	RIGHT= "RIGHT",
	--- Align the top of the tooltip with the bottom of the owner
	BOTTOM = "BOTTOM",
	--- Align to bottom of the tooltip with the top of the owner
	TOP = "TOP",
	--- Align the bottom left of the tooltip with the top left of the owner
	TOPLEFT= "TOPLEFT",
	--- Align the bottom right of the tooltip with the top right of the owner
	TOPRIGHT= "TOPRIGHT",
}

local function showFrameTooltip(self)
	self.Tooltip:Show();
end
local function hideFrameTooltip(self)
	self.Tooltip:Hide();
end

---GetTooltip
---@param frame Frame|ScriptObject
---@return Tooltip
function Tooltips.getTooltip(frame)
	if not frame.Tooltip then
		frame.Tooltip = Ellyb.Tooltip:new(frame);
		frame:HookScript("OnEnter", showFrameTooltip)
		frame:HookScript("OnLeave", hideFrameTooltip)
	end

	return frame.Tooltip;
end

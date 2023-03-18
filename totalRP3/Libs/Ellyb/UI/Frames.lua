local TRP3_API = select(2, ...);
local Ellyb = TRP3_API.Ellyb;

if Ellyb.Frames then
	return
end

local Frames = {};
Ellyb.Frames = Frames;

---Make a frame movable. The frame's position is not saved.
---@param frame Frame|ScriptObject
---@param validatePositionOnDragStop boolean
function Frames.makeMovable(frame, validatePositionOnDragStop)
	Ellyb.Assertions.isType(frame, "Frame", "frame");
	frame:RegisterForDrag("LeftButton");
	frame:EnableMouse(true);
	frame:SetMovable(true);

	frame:HookScript("OnDragStart", frame.StartMoving);
	frame:HookScript("OnDragStop", frame.StopMovingOrSizing);

	if validatePositionOnDragStop then
		frame:HookScript("OnDragStop", function()
			ValidateFramePosition(frame);
		end)
	end
end

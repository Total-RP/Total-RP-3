---@type Ellyb
local Ellyb = Ellyb(...);

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

--{{{ Mousewheel scroll on frame set slider value
---@type table<Frame, Slider>
local slidingFrames = {};

---@param self Frame
---@param delta number
local function setSliderValueOnMouseScroll(self, delta)
	local slider = slidingFrames[self];
	if not slidingFrames[self] then
		return
	end
	if slider:IsEnabled() then
		local mini, maxi = slider:GetMinMaxValues();
		if delta == 1 and slider:GetValue() > mini then
			slider:SetValue(slider:GetValue() - 1);
		elseif delta == -1 and slider:GetValue() < maxi then
			slider:SetValue(slider:GetValue() + 1);
		end
	end
end

---Make scrolling with the mouse wheel on the given frame change the given slider value
---@param frame Frame @ The frame that will receive the scroll wheel event
---@param slider Slider @ The slider that should see its value changed
function Frames.handleMouseWheelScroll(frame, slider)
	Ellyb.Assertions.isType(frame, "Frame", frame);
	Ellyb.Assertions.isType(slider, "Slider", slider);

	slidingFrames[frame] = slider
	frame:SetScript("OnMouseWheel", setSliderValueOnMouseScroll);
	frame:EnableMouseWheel(1);
end
--}}}

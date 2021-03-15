---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.EditBoxes then
	return
end

local EditBoxes = {};
Ellyb.EditBoxes = EditBoxes;

--{{{ Read only EditBoxes
local readOnlyEditBoxes = {};

---@param editBox EditBox|ScriptObject
local function saveEditBoxOriginalText(editBox)
	if readOnlyEditBoxes[editBox] then
		editBox.originalText = editBox:GetText();
	end
end

---@param editBox EditBox|ScriptObject
local function restoreOriginalText(editBox, userInput)
	if userInput and readOnlyEditBoxes[editBox] then
		editBox:SetText(editBox.originalText);
	end
end

---@param editBox EditBox|ScriptObject
function EditBoxes.makeReadOnly(editBox)
	readOnlyEditBoxes[editBox] = true;

	editBox:HookScript("OnShow", saveEditBoxOriginalText);
	editBox:HookScript("OnTextChanged", restoreOriginalText);
end
--}}}

---@param editBox EditBox|ScriptObject
function EditBoxes.selectAllTextOnFocus(editBox)
	editBox:HookScript("OnEditFocusGained", editBox.HighlightText);
end

---@param editBox EditBox|ScriptObject
function EditBoxes.looseFocusOnEscape(editBox)
	editBox:HookScript("OnEscapePressed", editBox.ClearFocus);
end

--- Mixin for edit boxes that will handle serialized data.
--- This mixin takes care of escaping and un-escaping the text that is set and get.
---@type EditBox|ScriptObject
EditBoxes.SerializedDataEditBoxMixin = {};

---@type EditBox
local EditBox = CreateFrame("EditBox");
EditBox:Hide();

function EditBoxes.SerializedDataEditBoxMixin:GetText()
	return EditBox.GetText(self):gsub("||", "|");
end

function EditBoxes.SerializedDataEditBoxMixin:SetText(text)
	return EditBox.SetText(self, text:gsub("|", "||"));
end

---Setup keyboard navigation using the tab key inside a list of EditBoxes.
---Pressing tab will jump to the next EditBox in the list, and shift-tab will go back to the previous one.
---@vararg EditBox A list of EditBoxes
function EditBoxes.setupTabKeyNavigation(...)
	local editBoxes = { ... };
	for index, editbox in ipairs(editBoxes) do
		editbox:HookScript("OnTabPressed", function()
			local nextEditBoxIndex = index + (IsShiftKeyDown() and -1 or 1)
			Ellyb.Maths.wrap(nextEditBoxIndex, #editBoxes)
			editBoxes[nextEditBoxIndex]:SetFocus();
		end)
	end
end

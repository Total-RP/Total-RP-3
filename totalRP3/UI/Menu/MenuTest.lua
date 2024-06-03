-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local SHOW_TEST_MENU = false;

if SHOW_TEST_MENU then
	local TestDropdown = CreateFrame("Frame", "TestDropdown", UIParent, "TRP3_DropdownButtonTemplate");
	TestDropdown:SetPoint("CENTER");
	TestDropdown:SetDefaultText("Default Text");

	local checks = {};
	local radio = nil;

	TestDropdown:SetupMenu(function(_, rootDescription)
		rootDescription:CreateTitle("Buttons");

		local button1 = rootDescription:CreateButton("Button 1", print, "foo");
		button1:SetTooltip();

		local button2 = rootDescription:CreateButton("Button 2", print, "foo");
		button2:SetTooltip(function(tt) tt:AddLine("foo"); end);

		local button3 = rootDescription:CreateButton("Button 3", print, "foo");
		TRP3_MenuUtil.AddIconToElement(button3, [[Interface\Scenarios\ScenarioIcon-Interact]]);

		rootDescription:CreateDivider();
		rootDescription:CreateTitle("Checkboxes");
		local function IsCheckSelected(key) return checks[key]; end
		local function SetCheckSelected(key) checks[key] = not checks[key]; end
		rootDescription:CreateCheckbox("Option 1", IsCheckSelected, SetCheckSelected, 1);
		rootDescription:CreateCheckbox("Option 2", IsCheckSelected, SetCheckSelected, 2);
		rootDescription:CreateCheckbox("Option 3", IsCheckSelected, SetCheckSelected, 3);

		rootDescription:CreateDivider();
		rootDescription:CreateTitle("Radios");
		local function IsRadioSelected(key) return radio == key; end
		local function SetRadioSelected(key) radio = key end
		rootDescription:CreateRadio("Option 1", IsRadioSelected, SetRadioSelected, 1);
		rootDescription:CreateRadio("Option 2", IsRadioSelected, SetRadioSelected, 2);
		rootDescription:CreateRadio("Option 3", IsRadioSelected, SetRadioSelected, 3);

		rootDescription:CreateDivider();
		rootDescription:CreateTitle("Submenu");
		local top = rootDescription:CreateButton("Submenu");
		for i = 1, 3 do
			local child = top:CreateButton("Option " .. i);
			child:SetMinimumWidth(200);

			for j = 1, 3 do
				local subchild = child:CreateButton("Option " .. i .. "." .. j);
				subchild:SetResponder(print);
				subchild:SetData(i .. "." .. j);
				subchild:SetResponse(TRP3_MenuResponse.Refresh);
			end
		end
	end);
end

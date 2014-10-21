----------------------------------------------------------------------------------
-- Total RP 3
-- TRP2 / MRP / XRP profiles importer
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
-- Copyright 2014 Renaud Parize (Ellypse) (renaud@parize.me)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

-- Public access
TRP3_API.importer = {};

-- imports
local Globals, loc = TRP3_API.globals, TRP3_API.locale.getText;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local playUISound = TRP3_API.ui.misc.playUISound;
local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
local isProfileNameAvailable = TRP3_API.profile.isProfileNameAvailable;
local assert, pairs = assert, pairs;
local tsize, tcopy = TRP3_API.utils.table.size, TRP3_API.utils.table.copy;
local playAnimation = TRP3_API.ui.misc.playAnimation;
local duplicateProfile = TRP3_API.profile.duplicateProfile;

local profiles = {};

local addOns = {};

TRP3_API.importer.addAddOn = function(addOnName, API)
	addOns[addOnName] = API;
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOGIC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


	local function importProfile(addOn, profileID)
		local newProfile = addOns[addOn].getFormatedProfile(profileID);

		assert(newProfile, "Nil profile");

		local profileName = profileID;

		local i = 0;
		local nameForNewProfile = profileName;
		while not isProfileNameAvailable(nameForNewProfile) and i < 500 do
			i = i + 1;
			nameForNewProfile = profileName .. " " .. i;
		end
		if i == 500 then
			return;
		end

		duplicateProfile(newProfile, nameForNewProfile);
	end

	local function importAll()
		for profileID, addOn in pairs(profiles) do
			importProfile(addOn, profileID);
		end
		for i = 1, 5 do
			local widget = _G["TRP3_CharacterImporterListLine" .. i];
			C_Timer.After((0.1 * (i - 1)), function()
				playAnimation(_G[widget:GetName() .. "Animate"]);
				playAnimation(_G[widget:GetName() .. "HighlightAnimate"]);

			end
			);
		end
		playUISound("Sound\\Interface\\Ui_Pet_Levelup_01.wav", true);
	end

	local function initProfiles()
		profiles = {};
		for _, addOn in pairs(addOns) do
			tcopy(profiles, addOn.listAvailableProfiles());
		end
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- UI
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function uiInitProfileList()
		initList(TRP3_CharacterImporterList, profiles, TRP3_CharacterImporterListSlider);
		TRP3_CharacterImporterAll:SetText(loc("PR_IMPORT_IMPORT_ALL") .. " (" .. (tsize(profiles)) .. ")");
		if tsize(profiles) == 0 then
			TRP3_CharacterImporterAll:Disable();
			TRP3_CharacterImporterListEmpty:Show();
		else
			TRP3_CharacterImporterAll:Enable();
			TRP3_CharacterImporterListEmpty:Hide();
		end
	end

	local function onImportButtonClicked(button)
		importProfile(button:GetParent().addOn, button:GetParent().profileID);
		playAnimation(_G[button:GetParent():GetName() .. "Animate"]);
		playAnimation(_G[button:GetParent():GetName() .. "HighlightAnimate"]);
		playUISound("Sound\\Interface\\Ui_Pet_Levelup_01.wav", true);
	end

	local function decorateProfileList(widget, id)
		assert(addOns[profiles[id]], "The addon associated to this profile is not registered in the improter");
		local profile = addOns[profiles[id]].getProfile(id);
		local importableData = addOns[profiles[id]].getImportableData();
		widget.profileID = id;
		widget.addOn = profiles[id];
		_G[widget:GetName() .. "Count"]:SetText(profiles[id]);
		_G[widget:GetName() .. "Name"]:SetText(profile.name);
		setupIconButton(_G[widget:GetName() .. "Icon"], profile.info.icon or Globals.icons.profile_default);

		local tooltip = "";
		for k, v in pairs(importableData) do
			if profile.info[k] then
				tooltip = tooltip .. "|cff00ff00" .. v .. "|r\n";
			else
				tooltip = tooltip .. "|cffcccccc" .. v .. "|r\n";
			end
		end

		setTooltipForSameFrame(_G[widget:GetName() .. "Info"], "RIGHT", 0, 0,
			"Will be imported :", -- TODO locale
			tooltip);
	end

	local function refreshDisplay()
		initProfiles();
		uiInitProfileList();
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- INIT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_CharacterImporter:SetScript("OnShow", refreshDisplay);

	handleMouseWheel(TRP3_CharacterImporterList, TRP3_CharacterImporterListSlider);
	TRP3_CharacterImporterListSlider:SetValue(0);
	local widgetTab = {};
	for i = 1, 5 do
		local widget = _G["TRP3_CharacterImporterListLine" .. i];
		_G[widget:GetName() .. "Select"]:SetScript("OnClick", onImportButtonClicked);
		_G[widget:GetName() .. "Select"]:SetText("Import");
		_G[widget:GetName() .. "Action"]:Hide();
		table.insert(widgetTab, widget);
	end
	TRP3_CharacterImporterList.widgetTab = widgetTab;
	TRP3_CharacterImporterList.decorate = decorateProfileList;
	TRP3_CharacterImporterAll:SetScript("OnClick", importAll);
	TRP3_CharacterImporterListEmpty:SetText(loc("PR_IMPORT_EMPTY"));
end);
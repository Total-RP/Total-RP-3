-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

---@type TRP3_API
local _, TRP3_API = ...;

-- Public access
TRP3_API.importer = {};

-- imports
local loc = TRP3_API.loc;
local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
local initList = TRP3_API.ui.list.initList;
local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local isProfileNameAvailable = TRP3_API.profile.isProfileNameAvailable;
local tsize, tcopy = TRP3_API.utils.table.size, TRP3_API.utils.table.copy;
local duplicateProfile = TRP3_API.profile.duplicateProfile;

local profiles = {};

local addOns = {};

TRP3_API.importer.addAddOn = function(addOnName, API)
	if
	type(API.isAvailable) == "function" and
	type(API.addOnVersion) == "function" and
	type(API.getProfile) == "function" and
	type(API.getFormatedProfile) == "function" and
	type(API.listAvailableProfiles) == "function" and
	type(API.getImportableData) == "function" then
		TRP3_API.Log("Importer: API registered "..addOnName);
		addOns[addOnName] = API;
	else
		print("An API for the addon " .. addOnName .. " tried to register itself in the importer module, but misses some of the required functions.");
	end
end

TRP3_API.importer.charactersProfilesAvailable = function()
	return tsize(addOns) > 0;
end

TRP3_API.RegisterCallback(TRP3_Addon, TRP3_Addon.Events.WORKFLOW_ON_LOAD, function()

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOGIC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


	local function importProfile(addOn, profileID)
		assert(addOns[addOn], "Error accessing the addon for this profile");
		local profile = addOns[addOn].getProfile(profileID);

		local newProfile = addOns[addOn].getFormatedProfile(profileID);

		assert(newProfile, "Nil profile");

		local profileName = profile.name;

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
		PlaySoundFile(642841);  -- sound/interface/ui_pet_levelup_01.ogg
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
		TRP3_CharacterImporterAll:SetText(loc.PR_IMPORT_IMPORT_ALL .. " (" .. (tsize(profiles)) .. ")");
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
		PlaySoundFile(642841);  -- sound/interface/ui_pet_levelup_01.ogg
	end

	local function decorateProfileList(widget, id)
		assert(addOns[profiles[id]], "The addon associated to this profile is not registered in the importer");
		local profile = addOns[profiles[id]].getProfile(id);
		local importableData = addOns[profiles[id]].getImportableData();
		widget.profileID = id;
		widget.addOn = profiles[id];
		widget:SetCountText(profiles[id]);
		widget:SetNameText(profile.name);
		widget:SetIcon(profile.info.icon);

		local tooltip = "";

		-- If the given profile has a value for the index of the importable data,
		-- it will be displayed as "will be imported". If not, it will be greyed out.
		for key, value in pairs(importableData) do
			if profile.info[key] then
				tooltip = tooltip .. TRP3_API.Colors.Green(value) .. "\n";
			else
				tooltip = tooltip .. TRP3_API.Colors.Grey(value) .. "\n";
			end
		end

		setTooltipForSameFrame(widget.HelpButton, "RIGHT", 0, 5, loc.PR_IMPORT_WILL_BE_IMPORTED, tooltip);
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
		widget.BindButton:Show();
		widget.BindButton:SetScript("OnClick", onImportButtonClicked);
		widget.BindButton:SetText("Import");
		widget.MenuButton:Hide();
		tinsert(widgetTab, widget);
	end
	TRP3_CharacterImporterList.widgetTab = widgetTab;
	TRP3_CharacterImporterList.decorate = decorateProfileList;
	TRP3_CharacterImporterAll:SetScript("OnClick", importAll);
	TRP3_CharacterImporterListEmpty:SetText(loc.PR_IMPORT_EMPTY);
end);

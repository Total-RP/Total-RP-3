----------------------------------------------------------------------------------
-- Total RP 3
-- TRP2 / MRP / XRP profiles importer
-- ---------------------------------------------------------------------------
-- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
-- Copyright 2014 Renaud Parize (renaudparize@gmail.com)
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

-- Public access
	TRP3_API.importer = {};

	-- imports
	local Globals, loc = TRP3_API.globals, TRP3_API.locale.getText;
	local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
	local initList = TRP3_API.ui.list.initList;
	local setupIconButton = TRP3_API.ui.frame.setupIconButton;
	local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;

	-- DEV imports
	-- TODO Remove :P
	local dump = TRP3_API.utils.table.dump;

	local totalRP2Profiles = {};
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOGIC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*



	local function importProfile(profileId)
		assert(totalRP2Profiles[profileId], "Nil profile");
		local importedProfile = totalRP2Profiles[profileId];
		local profileName = importedProfile["name"];

		while not TRP3_API.profile.isProfileNameAvailable(profileName) do
			profileName = profileName .. "_1";
		end

		-- TODO Create new profile from info
	end

	local function importAll()
	end

	local importableData = {
		firstName = "First name",
		lastName = "Last name",
		shortTitle = "Short title",
		fullTitle = "Full title",
		race = "Race",
		class = "Class",
		age = "Age",
		class = "Class",
		residence = "Residence",
		birthplace = "Birthplace",
		eyesColor = "Eyes color",
		height = "Height",
		bodyShape = "Body shape",
		history = "History",
		physicalDescription = "Physical description",
		icon = "Icon",
		currently = "Currently",
		currentlyOOC = "Other information (OOC)",
		rpStatus = "Roleplay status",
		experienceStatus = "Experience status"
	}

	local function initTotalRP2Profiles()
		if TRP2_Module_PlayerInfo then
			for realm, characters in pairs(TRP2_Module_PlayerInfo) do
				for name, info in pairs(characters) do
					if (info["Registre"]) then
						totalRP2Profiles[name .. " - " .. realm] = {
							name = name .. " " .. realm,
							addonVersion = TRP2_addonname .. " " .. TRP2_version,
							info = {
								firstName = info["Registre"]["Preom"],
								lastName = info["Registre"]["Nom"],
								shortTitle = info["Registre"]["Titre"],
								fullTitle = info["Registre"]["TitreComplet"],
								race = info["Registre"]["RacePerso"],
								class = info["Registre"]["ClassePerso"],
								age = info["Registre"]["Age"],
								residence = info["Registre"]["Habitation"],
								birthplace = info["Registre"]["Origine"],
								eyesColor = info["Registre"]["YeuxVisage"],
								height = TRP2_LOC_TAILLE_TEXTE[info["Registre"]["Taille"]],
								bodyShape = TRP2_LOC_SILHOUETTE_TEXTE[info["Registre"]["Silhouette"]],
							}
						};
						if info["Histoire"] then
							totalRP2Profiles[name .. " - " .. realm]["info"]["history"] = info["Histoire"]["HistoireTexte"];
						end
						if info["Physique"] then
							totalRP2Profiles[name .. " - " .. realm]["info"]["physicalDescription"] = info["Physique"]["PhysiqueTexte"];
						end
						if info["Actu"] then
							totalRP2Profiles[name .. " - " .. realm]["info"]["icon"] = info["Actu"]["PlayerIcon"];
							totalRP2Profiles[name .. " - " .. realm]["info"]["currently"] = info["Actu"]["ActuTexte"];
							totalRP2Profiles[name .. " - " .. realm]["info"]["currentlyOOC"] = info["Actu"]["ActuTexteHRP"];
							totalRP2Profiles[name .. " - " .. realm]["info"]["rpStatus"] = info["Actu"]["StatutRP"];
							totalRP2Profiles[name .. " - " .. realm]["info"]["experienceStatus"] = info["Actu"]["StatutXP"];
						end
					end
				end
			end
		end
	end

	local function getTotalRP2ProfilesList()
		initTotalRP2Profiles();
		local list = {};
		for k, v in pairs(totalRP2Profiles) do
			list[k] = k;
		end
		return list;
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- UI
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function uiInitProfileList()
		initList(TRP3_CharacterImporterList, getTotalRP2ProfilesList(), TRP3_CharacterImporterListSlider);
	end

	local function onImportButtonClicked(button)
		importProfile(button:GetParent().profileID);
	end

	local function decorateProfileList(widget, id)

		widget.profileID = id;

		local profile = totalRP2Profiles[id];

		_G[widget:GetName() .. "Count"]:SetText(profile["addonVersion"]);
		_G[widget:GetName() .. "Name"]:SetText(profile["name"]);
		setupIconButton(_G[widget:GetName() .. "Icon"], profile["info"]["icon"] or Globals.icons.profile_default);

		local tooltip = "";
		for k, v in pairs(importableData) do
			if profile["info"][k] then
				tooltip = tooltip .. "|cff00ff00" .. v .. "|r\n";
			else
				tooltip = tooltip .. "|cffcccccc" .. v .. "|r\n";
			end
		end

		setTooltipForSameFrame(_G[widget:GetName() .. "Info"], "RIGHT", 0, 0,
			"Will be imported :",
			tooltip);
	end

	local function refreshDisplay()
		uiInitProfileList();
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- INIT
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	TRP3_CharacterImporter:SetScript("OnShow", refreshDisplay);

	handleMouseWheel(TRP3_CharacterImporterList, TRP3_CharacterImporterListSlider);
	TRP3_CharacterImporterAll:SetText("Import all");
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
end);
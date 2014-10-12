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
	local playUISound = TRP3_API.ui.misc.playUISound;
	local getDefaultProfile = TRP3_API.profile.getDefaultProfile;
	local isProfileNameAvailable = TRP3_API.profile.isProfileNameAvailable;
	local assert, pairs = assert, pairs;
	local tsize = TRP3_API.utils.table.size;
	local playAnimation = TRP3_API.ui.misc.playAnimation;

	local totalRP2Profiles = {};
	local importableData = {};
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOGIC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function TRP2TagsToTRP3Tags(text)

		if not text then
			return;
		end
		local predefinedTRP2Color = {
			r = "ff0000",
			v = "00ff00",
			b = "0000ff";
			j = "ffff00";
			p = "ff00ff";
			c = "00ffff";
			w = "ffffff";
			n = "000000";
			o = "ffaa00";
		}
		local result = text:gsub("%{.-%}", function(tag) -- Not : The tag is received with the {}
			-- Pre-defined color
			if predefinedTRP2Color[tag:sub(2, -2)] then
				return "{col:" .. predefinedTRP2Color[tag:sub(2, -2)] .. "}";
			end

			-- Custom color
			if tag:match("%x%x%x%x%x%x") then
				return "{col:" .. tag:sub(2, -2) .. "}";
			end

			-- Icon tag
			if tag:sub(2, 6) == "icone" then
				return tag:gsub("icone", "icon");
			end

			-- Random text
			if tag:sub(2, 9) == "randtext" then
				local texts = tag:sub(11, -2);
				texts = {strsplit("+", texts)};
				return texts[math.random(1,#texts)];
			end

			-- Link
			if tag:sub(2, 5) == "link" then
				local _, url, text = strsplit(":", tag:sub(2, -2));
				return "(" .. text .. " : " .. url .. ")";
			end

			return ""; -- If we don't know the tag, return empty string to clear the tag.
		end)
		return result;
	end

	local function stripTRP2Tags(text)
		return text and text:gsub("%{.-%}","") or "";
	end


	local function importProfile(profileId)
		assert(totalRP2Profiles[profileId], "Nil profile");
		local importedProfile = totalRP2Profiles[profileId];
		local profileName = importedProfile.name;

		local i = 0;
		local nameForNewProfile = profileName;
		while not isProfileNameAvailable(nameForNewProfile) and i < 500 do
			i = i + 1;
			nameForNewProfile = profileName .. " " .. i;
		end
		if i == 500 then
			return;
		end

		local profile = getDefaultProfile();

		profile["player"]["characteristics"]["TI"] = stripTRP2Tags(importedProfile.info.shortTitle);
		profile["player"]["characteristics"]["FN"] = stripTRP2Tags(importedProfile.info.firstName);
		profile["player"]["characteristics"]["LN"] = stripTRP2Tags(importedProfile.info.lastName);
		profile["player"]["characteristics"]["FT"] = stripTRP2Tags(importedProfile.info.fullTitle);
		profile["player"]["characteristics"]["RA"] = stripTRP2Tags(importedProfile.info.race);
		profile["player"]["characteristics"]["CL"] = stripTRP2Tags(importedProfile.info.class);
		profile["player"]["characteristics"]["AG"] = stripTRP2Tags(importedProfile.info.age);
		profile["player"]["characteristics"]["RE"] = stripTRP2Tags(importedProfile.info.residence);
		profile["player"]["characteristics"]["BP"] = stripTRP2Tags(importedProfile.info.birthplace);
		profile["player"]["characteristics"]["EC"] = stripTRP2Tags(importedProfile.info.eyesColor);
		profile["player"]["characteristics"]["HE"] = stripTRP2Tags(importedProfile.info.height);
		profile["player"]["characteristics"]["WE"] = stripTRP2Tags(importedProfile.info.bodyShape);
		profile["player"]["characteristics"]["IC"] = stripTRP2Tags(importedProfile.info.icon);
		if importedProfile.info.piercing then
			tinsert(profile["player"]["characteristics"]["MI"], {
				["IC"] = "INV_Jewelry_ring_07",
				["NA"] = importableData.piercing,
				["VA"] = stripTRP2Tags(importedProfile.info.piercing),
			});
		end
		if importedProfile.info.face then
			tinsert(profile["player"]["characteristics"]["MI"], {
				["IC"] = "Spell_Shadow_MindSteal",
				["NA"] = importableData.face,
				["VA"] = stripTRP2Tags(importedProfile.info.face),
			});
		end
		profile["player"]["character"]["CO"] = stripTRP2Tags(importedProfile.info.currentlyOOC);
		profile["player"]["character"]["CU"] = stripTRP2Tags(importedProfile.info.currently);
		profile["player"]["character"]["RP"] = stripTRP2Tags(importedProfile.info.rpStatus);
		profile["player"]["character"]["XP"] = stripTRP2Tags(importedProfile.info.experienceStatus);
		profile["player"]["about"]["T3"]["PH"]["TX"] = TRP2TagsToTRP3Tags(importedProfile.info.physicalDescription);
		profile["player"]["about"]["T3"]["HI"]["TX"] = TRP2TagsToTRP3Tags(importedProfile.info.history);
		profile["player"]["about"]["TE"] = 3;

		TRP3_API.profile.duplicateProfile(profile, nameForNewProfile);
	end

	local function importAll()
		for k, v in pairs(totalRP2Profiles) do
			importProfile(k);
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

	local function initTotalRP2Profiles()
		importableData = {
			firstName = TRP2_LOC_PRENOM,
			lastName = TRP2_LOC_NOM,
			shortTitle = TRP2_LOC_TITRE,
			fullTitle = TRP2_LOC_SOUSTITRE,
			race = TRP2_LOC_RACE,
			age = TRP2_LOC_AGE,
			class = CLASS,
			residence = TRP2_LOC_HABITAT,
			birthplace = TRP2_LOC_ORIGINE,
			eyesColor = TRP2_LOC_VISAGEYEUX,
			height = TRP2_LOC_TAILLE,
			bodyShape = TRP2_LOC_SILHOUETTE,
			history = TRP2_LOC_Histoire,
			physicalDescription = TRP2_LOC_Description,
			icon = TRP2_LOC_PlayerIcon,
			currently = TRP2_LOC_Actu3,
			currentlyOOC = TRP2_LOC_HRPINFO,
			rpStatus = TRP2_LOC_StatutRP,
			experienceStatus = TRP2_LOC_StatutHRP,
			piercing = TRP2_LOC_VISAGEPIERCING,
			face = TRP2_LOC_VISAGETRAIT
		}
		if TRP2_Module_PlayerInfo then
			for realm, characters in pairs(TRP2_Module_PlayerInfo) do
				for name, info in pairs(characters) do
					if (info["Registre"]) then
						totalRP2Profiles[name .. " - " .. realm] = {
							name = name .. " - " .. realm,
							addonVersion = TRP2_addonname .. " " .. TRP2_version,
							info = {
								firstName = info["Registre"]["Prenom"] or name,
								lastName = info["Registre"]["Nom"],
								shortTitle = info["Registre"]["Titre"],
								fullTitle = info["Registre"]["TitreComplet"],
								race = info["Registre"]["RacePerso"],
								class = info["Registre"]["ClassePerso"],
								age = info["Registre"]["Age"],
								residence = info["Registre"]["Habitation"],
								birthplace = info["Registre"]["Origine"],
								eyesColor = info["Registre"]["YeuxVisage"],
								face = info["Registre"]["TraitVisage"],
								piercing = info["Registre"]["Piercing"],
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
							totalRP2Profiles[name .. " - " .. realm]["info"]["rpStatus"] = info["Actu"]["StatutRP"] == 1 and 2 or 1;
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
		TRP3_CharacterImporterAll:SetText(loc("PR_IMPORT_IMPORT_ALL") .. " (" .. (tsize(getTotalRP2ProfilesList())) .. ")");
	end

	local function onImportButtonClicked(button)
		importProfile(button:GetParent().profileID);
		playAnimation(_G[button:GetParent():GetName() .. "Animate"]);
		playAnimation(_G[button:GetParent():GetName() .. "HighlightAnimate"]);
		playUISound("Sound\\Interface\\Ui_Pet_Levelup_01.wav", true);
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
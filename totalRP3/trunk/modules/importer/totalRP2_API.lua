----------------------------------------------------------------------------------
-- Total RP 3
-- Total RP 2 API for profile importing
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

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	if not TRP2_Module_PlayerInfo then
		return;
	end

	local TRP2 = {};
	local tcopy = TRP3_API.utils.table.copy;
	local getDefaultProfile = TRP3_API.profile.getDefaultProfile;

	local loc = {
		height = TRP2_LOC_TAILLE_TEXTE,
		weight = TRP2_LOC_SILHOUETTE_TEXTE
	};

	local importableData = {
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

	local profilesList;

	local function initProfilesList()
		if TRP2.isAvailable() then
			profilesList = {};
			for realm, characters in pairs(TRP2_Module_PlayerInfo) do
				for name, info in pairs(characters) do
					if info.Registre or info.Histoire or info.Actu then

						local profileName = name .. " - " .. realm
						local infoTemp = {};

						profilesList[profileName] = { name = profileName };

						if info.Registre then
							infoTemp.firstName = info.Registre.Prenom or name;
							infoTemp.lastName = info.Registre.Nom;
							infoTemp.shortTitle = info.Registre.Titre;
							infoTemp.fullTitle = info.Registre.TitreComplet;
							infoTemp.race = info.Registre.RacePerso;
							infoTemp.class = info.Registre.ClassePerso;
							infoTemp.age = info.Registre.Age;
							infoTemp.residence = info.Registre.Habitation;
							infoTemp.birthplace = info.Registre.Origine;
							infoTemp.eyesColor = info.Registre.YeuxVisage;
							infoTemp.face = info.Registre.TraitVisage;
							infoTemp.piercing = info.Registre.Piercing;
							infoTemp.height = loc.height[info.Registre.Taille];
							infoTemp.bodyShape = loc.weight[info.Registre.Silhouette];
						end
						if info.Histoire then
							infoTemp.history = info.Histoire.HistoireTexte;
						end
						if info.Physique then
							infoTemp.physicalDescription = info.Physique.PhysiqueTexte;
						end
						if info.Actu then
							infoTemp.icon = info.Actu.PlayerIcon;
							infoTemp.currently = info.Actu.ActuTexte;
							infoTemp.currentlyOOC = info.Actu.ActuTexteHRP;
							infoTemp.rpStatus = info.Actu.StatutRP == 1 and 2 or 1;
							infoTemp.experienceStatus = info.Actu.StatutXP;
						end

						profilesList[profileName].info = infoTemp;
					end
				end
			end
		end
	end

	local function stripTRP2Tags(text)
		if type(text) ~= "string" then
			return "";
		else
			return text:gsub("%{.-%}", "");
		end
	end

	local function TRP2TagsToTRP3Tags(text)

		if not text then
			return;
		end
		local predefinedTRP2Color = {
			r = "ff0000",
			v = "00ff00",
			b = "0000ff",
			j = "ffff00",
			p = "ff00ff",
			c = "00ffff",
			w = "ffffff",
			n = "000000",
			o = "ffaa00"
		}
		local result = text:gsub("%{.-%}", function(tag) -- Note : The tag is received with the {}
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
				texts = { strsplit("+", texts) };
				return texts[math.random(1, #texts)];
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

	TRP2.isAvailable = function()
		return TRP2_Module_PlayerInfo ~= nil;
	end

	TRP2.addOnVersion = function()
		if TRP2.isAvailable then
			return TRP2_addonname .. " " .. TRP2_version;
		else
			return "";
		end
	end


	TRP2.getProfile = function(profileID)
		return profilesList[profileID];
	end

	TRP2.getFormatedProfile = function(profileID)
		assert(profilesList[profileID], "Given profileID does not exist.");

		local profile = {};
		local importedProfile = profilesList[profileID];

		tcopy(profile, getDefaultProfile());

		profile.player.characteristics.TI = stripTRP2Tags(importedProfile.info.shortTitle);
		profile.player.characteristics.FN = stripTRP2Tags(importedProfile.info.firstName);
		profile.player.characteristics.LN = stripTRP2Tags(importedProfile.info.lastName);
		profile.player.characteristics.FT = stripTRP2Tags(importedProfile.info.fullTitle);
		profile.player.characteristics.RA = stripTRP2Tags(importedProfile.info.race);
		profile.player.characteristics.CL = stripTRP2Tags(importedProfile.info.class);
		profile.player.characteristics.AG = stripTRP2Tags(importedProfile.info.age);
		profile.player.characteristics.RE = stripTRP2Tags(importedProfile.info.residence);
		profile.player.characteristics.BP = stripTRP2Tags(importedProfile.info.birthplace);
		profile.player.characteristics.EC = stripTRP2Tags(importedProfile.info.eyesColor);
		profile.player.characteristics.HE = stripTRP2Tags(importedProfile.info.height);
		profile.player.characteristics.WE = stripTRP2Tags(importedProfile.info.bodyShape);
		profile.player.characteristics.IC = importedProfile.info.icon;
		if importedProfile.info.piercing then
			tinsert(profile.player.characteristics.MI, {
				IC = "INV_Jewelry_ring_07",
				NA = importableData.piercing,
				VA = stripTRP2Tags(importedProfile.info.piercing),
			});
		end
		if importedProfile.info.face then
			tinsert(profile.player.characteristics.MI, {
				IC = "Spell_Shadow_MindSteal",
				NA = importableData.face,
				VA = stripTRP2Tags(importedProfile.info.face),
			});
		end
		profile.player.character.CO = stripTRP2Tags(importedProfile.info.currentlyOOC);
		profile.player.character.CU = stripTRP2Tags(importedProfile.info.currently);
		profile.player.character.RP = importedProfile.info.rpStatus;
		profile.player.character.XP = importedProfile.info.experienceStatus;
		profile.player.about.T3.PH.TX = TRP2TagsToTRP3Tags(importedProfile.info.physicalDescription);
		profile.player.about.T3.HI.TX = TRP2TagsToTRP3Tags(importedProfile.info.history);
		profile.player.about.TE = 3;

		return profile;
	end

	TRP2.listAvailableProfiles = function()
		initProfilesList()
		local list = {};
		for key, _ in pairs(profilesList) do
			list[key] = TRP2.addOnVersion();
		end
		return list;
	end

	TRP2.getImportableData = function()
		return importableData;
	end

	TRP3_API.importer.addAddOn(TRP2.addOnVersion(), TRP2);
end);
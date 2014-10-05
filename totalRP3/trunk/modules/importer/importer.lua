----------------------------------------------------------------------------------
-- Total RP 3
-- TRP2 / MRP / XRP profiles importer
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--	Copyright 2014 Renaud Parize (renaudparize@gmail.com)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()

	-- Public access
	TRP3_API.importer = {};

	-- imports
	local Globals, loc = TRP3_API.globals, TRP3_API.locale.getText;
	local handleMouseWheel = TRP3_API.ui.list.handleMouseWheel;
	local initList = TRP3_API.ui.list.initList;
	local registerPage = TRP3_API.navigation.page.registerPage;
	local dump = TRP3_API.utils.table.dump;
	local setupIconButton = TRP3_API.ui.frame.setupIconButton;
	local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- LOGIC
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local function importProfile()

	end

	local function importAll()

	end

	local totalRP2Profiles = {};
	local function initTotalRP2Profiles()
		if TRP2_Module_PlayerInfo then
			for realm, characters in pairs(TRP2_Module_PlayerInfo) do
				for name, info in pairs(characters) do
					if(info["Registre"]) then
						dump(info);
						totalRP2Profiles[name .." - ".. realm] = info;
						totalRP2Profiles[name .." - ".. realm] = {
							name = name .. " " .. (info["Registre"]["Nom"] or ""),
							icon = info["Actu"]["PlayerIcon"] or Globals.icons.profile_default,
							addonVersion = TRP2_addonname .. " " .. TRP2_version,
							info = {
								firstName = name,
								lastName = info["Registre"]["Nom"],
								shortTitle = info["Registre"]["Titre"],
								fullTitle = info["Registre"]["TitreComplet"],
								race = info["Registre"]["RacePerso"],
								class = info["Registre"]["ClassePerso"],
								age = info["Registre"]["Age"],
								residence = info["Registre"]["Habitation"],
								birthplace = info["Registre"]["Origine"],
								eyesColor = info["Registre"]["YeuxVisage"],
								height = "",
								bodyShape = ""
							}

						};
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

	local function decorateProfileList(widget, id)
		local list = {};

		local profile = totalRP2Profiles[id];

		_G[widget:GetName().."Count"]:SetText(profile["addonVersion"]);
		_G[widget:GetName().."Name"]:SetText(profile["name"]);
		dump(profile);
		setupIconButton(_G[widget:GetName().."Icon"], profile["icon"]);

		local tooltip = "";
		for k, v in pairs(profile["info"]) do
			if v then
				tooltip = tooltip .. k .. "\n";
			end
		end

		setTooltipForSameFrame(
			_G[widget:GetName().."Info"], "RIGHT", 0, 0,
			"Will be imported :",
			tooltip
		)
		--_G[widget:GetName().."Name"]:SetText(id);

		--[[widget.profileID = id;
		local profile = profiles[id];
		local dataTab = getData("player/characteristics", profile);
		local mainText = profile.profileName;

		if id == currentProfileId then

			widget:SetBackdropBorderColor(0, 1, 0);
			_G[widget:GetName().."Current"]:Show();
			_G[widget:GetName().."Select"]:Disable();
		else
			widget:SetBackdropBorderColor(1, 1, 1);
			_G[widget:GetName().."Current"]:Hide();
			_G[widget:GetName().."Select"]:Enable();
		end

		setupIconButton(_G[widget:GetName().."Icon"], dataTab.IC or Globals.icons.profile_default);
		_G[widget:GetName().."Name"]:SetText(mainText);

		local listText = "";
		local i = 0;
		for characterID, characterInfo in pairs(characters) do
			if characterInfo.profileID == id then
				local charactName, charactRealm = unitIDToInfo(characterID);
				listText = listText.."- |cff00ff00"..charactName.." ( "..charactRealm.." )|r\n";
				i = i + 1;
			end
		end
		_G[widget:GetName().."Count"]:SetText(loc("PR_PROFILEMANAGER_COUNT"):format(i));

		local text = "";
		if i > 0 then
			text = text..loc("PR_PROFILE_DETAIL")..":\n"..listText;
		else
			text = text..loc("PR_UNUSED_PROFILE");
		end
		setTooltipForSameFrame(
			_G[widget:GetName().."Info"], "RIGHT", 0, 0,
			loc("PR_PROFILE"),
			"Test"
		)
		]]
	end
	
	local function refreshDisplay()
		print("refreshDisplay !");
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
	for i=1,5 do
		local widget = _G["TRP3_CharacterImporterListLine"..i];
		widget:SetScript("OnMouseUp",function (self)
			print("Line clicked");
		-- onProfileSelected(_G[self:GetName().."Select"]);
		-- playUISound("gsCharacterSelection");
		end);
		_G[widget:GetName().."Select"]:SetScript("OnClick", importProfile);
		_G[widget:GetName().."Select"]:SetText("Import");
		_G[widget:GetName().."Action"]:Hide();
		table.insert(widgetTab, widget);

	end
	TRP3_CharacterImporterList.widgetTab = widgetTab;
	TRP3_CharacterImporterList.decorate = decorateProfileList;
	TRP3_CharacterImporterAll:SetScript("OnClick", importAll);

end);
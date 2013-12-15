UI_yearsTable = {};
TRP3tl_htmlFrame = {}
wl_navButtons = {"wl_nav1","wl_nav2","wl_nav3"}
TRP3tl_areas_for_navigation = {"timeline","personas","races","wars","places"}
TRP3tl_actual_navigation_area = "timeline";
wl_navTables = {}

local round = function (num) return math.floor(num + .5); end

function TRP3tl_main_loading() 
  TRP3tl_init();
end

function TRP3tl_ScrollChildFrame_OnLoad(self)
	self:GetParent().scrollChild = self;
end
function TRP3tl_YearsScrollBar_OnLoad(self)
	self:GetParent().scrollBar = self;
end
function TRP3tl_YearsScrollBar_OnValueChanged( self )
	self:GetParent():SetVerticalScroll( self:GetValue()/(self:GetParent().buttonHeight*(#self:GetParent().buttons-1))*self:GetParent():GetVerticalScrollRange());
end

function YearLog_OnLoad(self)
	self.range = 0;
	self:EnableMouse(true);
	print("loading timeline table");
	print(self:GetName());
	TRP3tl_resetMainTimeline(TRP3tl_timeline_bp_years)
	--print(type(trp3tl_FrameYearsScrollFrame.buttons))
	--print(trp3tl_FrameYearsScrollFrame.buttons);
	--print("QuestLogScrollframe.numbers: "..#QuestLogScrollFrame.buttons);
	--HybridScrollFrame_CreateButtons(self, "TRP3tl_template_yearbutton");
	--print("QuestLogScrollframe.numbers: "..#QuestLogScrollFrame.buttons);
	YearLogMenu_CreateButtons(self);
	
end

function YearLogMenu_CreateButtons(self)
	local scrollChild = self.scrollChild;
	local buttonHeight;
	local numButtons = #TRP3tl_timeline_bp_years;
	self.buttons = {};
	for i=1,numButtons do
		local button = CreateFrame("BUTTON", self:GetName().."Button" .. i, scrollChild, "TRP3tl_template_yearbutton");
		self.buttons[i] = button;
		if i==1 then
			button:SetPoint("TOPLEFT",0,0);
		else
			button:SetPoint("TOPLEFT",self.buttons[i-1],"BOTTOMLEFT",0,0);
		end
		button.yearIndex = TRP3tl_timeline_bp_years[i];
		button:SetText(button.yearIndex);
		
	    
	end
	
	buttonHeight = self.buttons[1]:GetHeight();
	--print("creating button "..i);
	self.buttonHeight = round(buttonHeight);
	
	scrollChild:SetWidth(self:GetWidth())
	print(numButtons * buttonHeight);
    scrollChild:SetHeight(numButtons * buttonHeight);
    self:SetVerticalScroll(0);
    self:UpdateScrollChildRect();
	
	local scrollBar = self.scrollBar;
    scrollBar:SetMinMaxValues(0, numButtons * buttonHeight);
    scrollBar:SetValueStep(.005);
    scrollBar:SetValue(0);
    
	local numButtonsDisplayed = math.ceil(self:GetHeight() / buttonHeight) + 1;
	print(numButtonsDisplayed);
end

function TRP3tl_init()
	TRP3tl_htmlFrame = getglobal("TRP3tl_contentframe");
	SetPortraitToTexture(TRP3tl_clock,"Interface\\Icons\\Spell_Holy_BorrowedTime")
	--TRP3tl_resetMainTimeline(TRP3tl_timeline_bp_years)
	TRP3tl_htmlFrame:SetText(TRP3tl_toHTML("{title1:center}Hello Lore Lovers{/title1}Welcome to the TotalRP3 WoW Timeline.\nMany of you may agree or not with the dates given in this 'pocket timeline'. It's been a hard work to put it in together and also, a harder task to determine the actual date (The Draenor date), as that could be displeasant for many of you. This is just an approach: many years studying and enjoying lore brought us to do this addon, though we admit it's just a 'fan timeline': the date remains unofficial and this dates just serve as a 'start-point' for roleplayers using TRP3, thought to serve as a valid timeline, if not 100% accurate, maybe enough to allow you to know better the wow lore. Enjoy!."));
end

function TRP3tl_resetMainTimeline(timetable)
	print(#TRP3tl_timeline_bp_years)
	
	for i=1,#TRP3tl_timeline_bp_years,1 do
		local currentyear = TRP3tl_timeline_bp_years[i];
		local tablaYear = TRP3TL_TIMELINE_BP[currentyear];
		--print("yearButton"..i)
		local btn = getglobal("TRP3tl_yearButton"..i);
		--print(btn)
		--btn["indice"] = currentyear;
		
		--btn:SetText(currentyear);
	end
end

function TRP3tl_yearClicked(e)
	TRP3tl_actual_navigation_area = TRP3tl_areas_for_navigation[1];
	TRP3tl_hideNavButtons();
	local _year = e:GetText();
	local fauxYear = e.yearIndex;
	local tabla1 = TRP3TL_TIMELINE_BP[fauxYear];
	print("Recovering data for year ".._year);
	local orderedFacts = "";
	for j=1,#tabla1,1 do
		print("wl_debug: j="..j);
		if tabla1[j]["icon"] then
			print("wl_debug: hay iconos");
			orderedFacts = orderedFacts.."{icon:"..tabla1[j]["icon"].."}";
		end
		orderedFacts = orderedFacts.."{title1:center}"..tabla1[j]["facttitle"].."{/title1}\n";
		
		if tabla1[j]["picture"] then
			orderedFacts = orderedFacts.."{picture:"..tabla1[j]["picture"].."}\n";
		end
		orderedFacts = orderedFacts..tabla1[j]["fact"].."\n\n";
		
	end
	--print(orderedFacts);
	--TRP3tl_htmlFrame:SetFontObject(GameFontNormalSmall);
	TRP3tl_htmlFrame:SetFontObject("h1", GameFontNormalHuge);
	TRP3tl_htmlFrame:SetText(TRP3tl_toHTML(orderedFacts));
	
	yearTitle = getglobal("TRP3tl_yearLabel");
	yearTitle:SetText("Year: "..fauxYear);
end

function TRP3tl_setProtagonistTimeline(e,timeTable)
	TRP3tl_actual_navigation_area = TRP3tl_areas_for_navigation[2]
	TRP3tl_hideNavButtons();
	local prota = e.value;
	local _year = e:GetText();
	--local fauxYear = e.;
	local tabla1 = timetable;
	print("Recuperando datos para el personaje "..prota);
	local orderedFacts = "";
	for j=1,#timetable,1 do
		print("wl_debug: j="..j);
		if timetable[j]["icon"] then
			print("wl_debug: hay iconos");
			orderedFacts = orderedFacts.."{icon:"..timetable[j]["icon"].."}";
		end
		orderedFacts = orderedFacts.."{title1:center}"..tabla1[j]["facttitle"].."{/title1}\n";
		
		if tabla1[j]["picture"] then
		
			print("wl_debug: hay iconos");
			orderedFacts = orderedFacts.."{picture:"..tabla1[j]["picture"].."}\n";
		end
		orderedFacts = orderedFacts..tabla1[j]["fact"].."\n\n";
		
	end
	--print(orderedFacts);
	--TRP3tl_htmlFrame:SetFontObject(GameFontNormalSmall);
	--TRP3tl_htmlFrame:SetFontObject("h1", GameFontNormalHuge);
	TRP3tl_htmlFrame:SetText(toHTML(orderedFacts));
	
	yearTitle = getglobal("wl_yearLabel");
	yearTitle:SetText("Año: "..fauxYear);
end

function TRP3tl_toHTML(text)
	local tab = {};
	local i=1;
	text = string.gsub(text,"&","&amp;");
	text = string.gsub(text,"<","&lt;");
	text = string.gsub(text,">","&gt;");
	text = string.gsub(text,"\"","&quot;");
	text = string.gsub(text,"{title1}","<h1>");
	text = string.gsub(text,"{title1:center}","<h1 align=\"center\">");
	text = string.gsub(text,"{title1:right}","<h1 align=\"right\">");
	text = string.gsub(text,"{/title1}","</h1>");
	text = string.gsub(text,"{title2}","<h2>");
	text = string.gsub(text,"{title2:center}","<h2 align=\"center\">");
	text = string.gsub(text,"{title2:right}","<h2 align=\"right\">");
	text = string.gsub(text,"{/title2}","</h2>");
	text = string.gsub(text,"{title3}","<h3>");
	text = string.gsub(text,"{title3:center}","<h3 align=\"center\">");
	text = string.gsub(text,"{title3:right}","<h3 align=\"right\">");
	text = string.gsub(text,"{/title3}","</h3>");
	text = string.gsub(text,"{center}","<P align=\"center\">");
	text = string.gsub(text,"{/center}","</P>");
	text = string.gsub(text,"{right}","<P align=\"right\">");
	text = string.gsub(text,"{/right}","</P>");
	
	while string.find(text,"<") and i<50 do
		--TRP2_debug("text trait√© : "..text)
		local avant,tag,apres;
		avant = string.sub(text,1,string.find(text,"<")-1);
		local taille = 0;
		if string.match(text,"</(.-)>") then
			taille = string.len(string.match(text,"</(.-)>"));
		end
		--TRP2_debug("taille : "..tostring(taille));
		if string.find(text,"</") then
			tag = string.sub(text,string.find(text,"<"),string.find(text,"</")+taille+2);
		end
		apres = string.sub(text,string.len(avant)+string.len(tag)+1);

		tab[#tab+1] = avant;
		tab[#tab+1] = tag;
		text = apres;
		
		i = i+1;
	end
	tab[#tab+1] = text;
	text = "";
	table.foreach(tab,function(i)
		if not string.find(tab[i],"<") then
			tab[i] = "<P>"..tab[i].."</P>";
		end
		tab[i] = string.gsub(tab[i],"\n","<br/>");
		
		tab[i] = string.gsub(tab[i],"{icon%:(.-)}",function(arg1)
			return "</P><img src=\"Interface/Icons/"..arg1.."\" align=\"center\" width=\"40\" height=\"40\"/><P>";
		end);
		
		tab[i] = string.gsub(tab[i],"{picture%:(.-)}",function(arg1)
			print(arg1);
			return "</P><img src=\""..arg1.."\" align=\"center\" width=\"128\" height=\"128\"/><P>";
		end);

		
		--TRP2_debug(i.." : "..tab[i]);
		text = text..tab[i];
	end)
	text = "<HTML><BODY>"..text.."</BODY></HTML>";
	
	return text;
end
function trp3tl_setIcons()
end
function trp3tl_wl_textFormat(text,bNocolor)
	if not text then return "" end;
	if bNocolor then
		text = string.gsub(text,"{[rvbjpcwno]}","");
		text = string.gsub(text,"{%x%x%x%x%x%x}","");
		text = string.gsub(text,"{li}","");
		text = string.gsub(text,"{col}","");
	end
	
	text = string.gsub(text,"%{([^{]-)%}",wl_controlBaliza);
	
	local i=0;
	
	return text;
end

WL_DIRECTINSERT = {
	["r"] = "|cffff0000";
	["g"] = "|cff00ff00";
	["b"] = "|cff0000ff";
	["y"] = "|cffffff00";
	["p"] = "|cffff00ff";
	["z"] = "|cff00ffff";
	["w"] = "|cffffffff";
	["x"] = "|cff000000";
	["o"] = "|cffffaa00";
	["li"] = "\n";
	["pv"] = ";";
	["sh"] = "#";
	["do"] = "$";
	["ao"] = "{";
	["af"] = "}";
	["pi"] = "||";
	["col"] = "|r";
}

function trp3tl_wl_controlBaliza(baliza)
	if WL_DIRECTINSERT[baliza] then
		
	elseif string.find(baliza,"%x%x%x%x%x%x") then
		return "|cff"..baliza;
	elseif string.find(baliza,"icon%:[%w%s%_%-%d]+%:%d+") then
		return "|TInterface\\ICONS\\"..tostring(string.match(balise,"icone%:([%w%s%_%-%d]+)%:%d+"))..":"
			..tostring(string.match(baliza,"icone%:[%w%s%_%-%d]+%:(%d+)"))..":"
			..tostring(string.match(baliza,"icone%:[%w%s%_%-%d]+%:(%d+)")).."|t";
	elseif baliza == "de" then
		return "|2";
	end
	
	return "{"..baliza.."}";
end

function trp3tl_wl_reemplazarTexto(message,remp1,remp2,remp3,remp4,remp5,remp6,remp7,remp8)
	if not message then return ""; end
	message = string.gsub(message,"%%1",tostring(remp1));
	message = string.gsub(message,"%%2",tostring(remp2));
	message = string.gsub(message,"%%3",tostring(remp3));
	message = string.gsub(message,"%%4",tostring(remp4));
	message = string.gsub(message,"%%5",tostring(remp5));
	message = string.gsub(message,"%%6",tostring(remp6));
	message = string.gsub(message,"%%7",tostring(remp7));
	message = string.gsub(message,"%%8",tostring(remp8));
	return message;
end









 --- Añadidos DropDownMenu Xinhuan
local TRP3tl_CategoriesDropMenu = CreateFrame("Frame", "TRP3tl_CategoriesDropMenu"); -- wowleaks_mimenu = Omen_TitleDropDownMenu
TRP3tl_CategoriesDropMenu.displayMode = "MENU";
TRP3tl_CategoriesDropMenu.initialize = function(self, level) end

local firstLevelMenu = ""

local info = {}
TRP3tl_CategoriesDropMenu.initialize = function(self, level)
    if not level then return end
    wipe(info)
    if level == 1 then
        
        info.disabled     = nil;
        info.isTitle      = nil;
        info.notCheckable = 1;

        info.keepShownOnClick = 1;
        info.disabled = nil;
        info.isTitle = nil;
        info.notCheckable = 1
        info.func = self.UncheckHack
        info.hasArrow = 1
        
        info.text = TRP3tl_trans_ui["personas"]
        info.value = "personsMenu"
        UIDropDownMenu_AddButton(info, level)
        
        info.text = TRP3tl_trans_ui["races"]
        info.value = "racesMenu"
        UIDropDownMenu_AddButton(info, level)
        
        info.text = TRP3tl_trans_ui["wars"]
        info.value = "warsMenu"
        UIDropDownMenu_AddButton(info, level)
        
        info.text = TRP3tl_trans_ui["places"]
        info.value = "placesMenu"
        UIDropDownMenu_AddButton(info, level)
        
		
		
        info.text = TRP3tl_trans_ui["categories"]
        info.value = "categoriesMenu"
        UIDropDownMenu_AddButton(info, level)
		
		info.value = nil
		info.notCheckable = 1
		info.hasArrow = nil
		
        info.text = "Test mode"
        info.checked = testMode
        UIDropDownMenu_AddButton(info, level)

        info.text = TRP3tl_trans_ui["settings"];
        UIDropDownMenu_AddButton(info, level)

      

        -- Close menu item
        info.text = TRP3tl_trans_ui["close"];	
        info.func = function() CloseDropDownMenus() end
        info.checked = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
     elseif level == 2 then
        --info = {}
        if UIDROPDOWNMENU_MENU_VALUE == "personsMenu" then
        	
        	info.notCheckable = 1
        	info.isTitle = 1
            info.text = "Personas menu"
            UIDropDownMenu_AddButton(info, level)
            
            info.disabled     = nil
            info.hasArrow = 1
            info.isTitle = nil
            info.keepShownOnClick = 1
            info.func = self.UncheckHack
            for i=1,#TRP3tl_racesTypesNPCs,1 do
            	
            	info.value = TRP3tl_racesTypesNPCs[i];
            	info.text = TRP3tl_trans_names[TRP3tl_racesTypesNPCs[i]];
            	UIDropDownMenu_AddButton(info, level)
            end
		elseif UIDROPDOWNMENU_MENU_VALUE == "racesMenu" then
        	
            info.notCheckable = 1
        	info.isTitle = 1
            info.text = "Races menu"
            UIDropDownMenu_AddButton(info, level)
            
            info.disabled     = nil
            info.hasArrow = 1
            info.isTitle = nil
            info.keepShownOnClick = 1
            info.func = self.UncheckHack
            for i=1,#TRP3tl_races_kinds,1 do
            	--print(i);
            	--print("nombre es "..nombre)
            	
            	info.value = TRP3tl_races_kinds[i];
            	info.text = TRP3tl_races_kinds_trans[TRP3tl_races_kinds[i]];
            	UIDropDownMenu_AddButton(info, level)
            end
        elseif UIDROPDOWNMENU_MENU_VALUE == "warsMenu" then
        	
            info.notCheckable = 1
        	info.isTitle = 1
            info.text = "Wars menu"
            UIDropDownMenu_AddButton(info, level)
            
            info.disabled = nil
            info.hasArrow = nil
            info.isTitle = nil
            info.keepShownOnClick = nil
            info.func = self.UncheckHack
            for i=1,#TRP3tl_wars,1 do
            	--print(i);
            	--print("nombre es "..nombre)
            	
            	info.func = TRP3tl_getWarFacts
            	info.value = TRP3tl_wars[i];
            	info.text = TRP3tl_trans_wars[TRP3tl_wars[i]];
            	UIDropDownMenu_AddButton(info, level)
            end
        end
    elseif level == 3 then
     	if TRP3tl_protagonists[UIDROPDOWNMENU_MENU_VALUE] then
     		--print("menu de personajes")
     		local raceChars = TRP3tl_protagonists[UIDROPDOWNMENU_MENU_VALUE]
     		for i=1,#raceChars,1 do
            	--print(i);
            	--print("nombre es "..nombre)
            	info.func = TRP3tl_getCharFacts
            	info.value = raceChars[i];
            	info.text = TRP3tl_trans_names[raceChars[i]];
            	UIDropDownMenu_AddButton(info, level)
            end
		elseif (TRP3tl_races_kinds_all[UIDROPDOWNMENU_MENU_VALUE]) then
			--print("hola?")
			local _tempRaceKinds = TRP3tl_races_kinds_all[UIDROPDOWNMENU_MENU_VALUE]
     		for i=1,#_tempRaceKinds,1 do
            	--print(i);
            	--print("nombre es "..nombre)
            	info.func = getRaceFacts
            	info.value = _tempRaceKinds[i];
            	info.text = TRP3tl_trans_races[_tempRaceKinds[i]];
            	UIDropDownMenu_AddButton(info, level)
            end
     	end
    end
end
function TRP3tl_getCharFacts(self)
	--print("ok")
	print(self.value)
	
	local charYearsTable = {}
	local count = 1;
	for s=1,#TRP3tl_timeline_bp_years,1 do
		local tempTable = TRP3tl_checkPersonaAtYear(self.value,TRP3tl_timeline_bp_years[s]);
		if tempTable then
			charYearsTable[count] = tempTable;
			count = count + 1;
		end 
	end
	print("años contabilizados: "..#charYearsTable)
	TRP3tl_setProtagonistTimeline(self,charYearsTable)
end

function TRP3tl_checkPersonaAtYear(persona,year)
	local charYearfacts = {}
	local _yearTable = TRP3TL_TIMELINE_BP[year]
	local timesCatched = 0;
	charYearfacts[0] = year
	for j=1,#_yearTable,1 do
		if _yearTable[j]["personas"] then
			local _personaArray = _yearTable[j]["personas"]
			
			--print("Longitud del array: " ..#_personaArray)
			for k=1,#_personaArray,1 do
				if(_personaArray[k] == persona) then
					timesCatched = timesCatched + 1
					print("Registered "..TRP3tl_trans_names[persona])
					charYearfacts[timesCatched] = _yearTable[j]
				end
			end
		end
	end
	--print(charYearfacts)
	--print("len: "..#charYearfacts)
	--if #charYearfacts>0 then print("Y el año es: "..charYearfacts[0]) end
	--print("Hallado "..timesCatched.." veces")
	if #charYearfacts > 0 then return charYearfacts else return nil end
	--return charYearfacts
	
	
end


local wowleaks_yearTooltip = {};
function TRP3tl_getYearToolTip(this)
	local _year = this:GetText();
	local tablatt = WL_TIMELINE_BP[_year];
	--print(this)
	wowleaks_yearTooltip = CreateFrame("Frame", "wowleaks_yearTooltip"); -- wowleaks_mimenu = Omen_TitleDropDownMenu
	wowleaks_yearTooltip.displayMode = "MENU";
	wowleaks_yearTooltip.initialize = function(self, level) end

	local fact = {}
	wowleaks_yearTooltip.initialize = function(self, level)
		if not level then return end
	    wipe(fact)
	    if level == 1 then
	        -- Create the title of the menu
	        fact.isTitle = 1
		    fact.text = "Año ".._year
		    fact.notCheckable = 1
			UIDropDownMenu_AddButton(fact, level)
	        
	        for j=1,#tablatt,1 do
				--print("wl_debug: fact titles j="..j);
				--print(tablatt[j]["facttitle"])
				
				fact.isTitle = nil
		        fact.text = tablatt[j]["facttitle"]
		        UIDropDownMenu_AddButton(fact, level)
			end
	    end
	end
	ToggleDropDownMenu(1, nil, wowleaks_yearTooltip, this:GetName(), 80, 30)
end

function trp3tl_setProtagonistTimeline(prota,timeTable)
	wl_actual_navigation_area = wl_areas_for_navigation[3]
	hideNavButtons();
	local _char = prota;
	--local fauxYear = e["indice"];
	--local tabla1 = WL_TIMELINE_BP[fauxYear];
	print("Recuperando datos para el personaje "..trans_names[prota]);
	wl_yearLabel:SetText(trans_names[prota]);
	local orderedFacts = "";
	for j=1,#timeTable,1 do
		--print("wl_debug: j="..j);
		orderedFacts = orderedFacts.."{title1:center} Año "..timeTable[j][0].."{/title1}\n";
		local factTable = timeTable[j];
		for k=1,#factTable,1 do
			if timeTable[j][k]["icon"] then
				--print("wl_debug: hay iconos");
				orderedFacts = orderedFacts.."{icon:"..timeTable[j][k]["icon"].."}";
			end
			orderedFacts = orderedFacts.."{title2:center}"..timeTable[j][k]["facttitle"].."{/title2}\n";
			orderedFacts = orderedFacts..timeTable[j][k]["fact"].."\n\n";
			if timeTable[j][k]["picture"] then
				--print("wl_debug: hay imagen");
				orderedFacts = orderedFacts.."{icon:"..timeTable[j][k]["picture"].."}";
			end
			
		end
	end
	TRP3tl_htmlFrame:SetText(toHTML(orderedFacts));
end

function TRP3tl_getRaceFacts(self)
	--print("ok")
	--print(self.value)
	
	local strrace = string.gsub(self.value, "race%-","")
    --print("Recuperando datos para los "..self.value)
    --print(strrace)
	local raceYearsTable = {}
	local count = 1;
	for s=1,#TRP3tl_timeline_bp_years,1 do
		local tempTable = TRP3tl_checkRaceAtYear(strrace,TRP3tl_timeline_bp_years[s])
		if tempTable then
			raceYearsTable[count] = tempTable
			count = count + 1
		end 
	end
	print("años contabilizados: "..#raceYearsTable)
	TRP3tl_setRaceTimeline(strrace,raceYearsTable,true)
end

lastSelectedRace = "";

function TRP3tl_checkRaceAtYear(race,year)
	lastSelectedRace = race;
	local raceYearfacts = {}
	local _yearTable = 	TRP3TL_TIMELINE_BP[year]
	--print(_yearTable)
	--print("yearTable len: "..#_yearTable)
	--print("race @ checkRaceAtYear: "..race)
	
	local timesCatched = 0
	raceYearfacts[0] = year
	for j=1,#_yearTable,1 do
		if _yearTable[j]["races"] then
			local _raceArray = _yearTable[j]["races"]
			--print("y: "..year..", race facts num: "..#_raceArray)
			--print("Longitud del array: " ..#_raceArray..", año: "..year )
			for k=1,#_raceArray,1 do
				if(_raceArray[k] == race) then
					timesCatched = timesCatched + 1
					--print("y: "..year.."Registrando a los "..wl_trans_races["race-"..race])
					raceYearfacts[timesCatched] = _yearTable[j]
				end
			end
		end
	end
	--print(raceYearfacts)
	
	--if #charYearfacts>0 then print("Y el año es: "..charYearfacts[0]) end
	--print("Hallado "..timesCatched.." veces")
	if #raceYearfacts > 0 then return raceYearfacts else return nil end
	--return charYearfacts
end

lastSelectedWar = "";

function TRP3tl_checkWarAtYear(war,year)
	lastSelectedWar = war;
	local warYearfacts = {}
	local _yearTable = TRP3TL_TIMELINE_BP[year]
	--print(_yearTable)
	--print("yearTable len: "..#_yearTable)
	print("@checkWarAtYear--- "..year)
	print(" war: "..war)
	
	local timesCatched = 0
	warYearfacts[0] = year
	for j=1,#_yearTable,1 do
		if _yearTable[j]["war"] then
			local _warArray = _yearTable[j]["war"]
			--print("y: "..year..", war facts num: "..#_warArray)
			--print("Longitud del array: " ..#_raceArray..", año: "..year )
			for k=1,#_warArray,1 do
				if(_warArray[k] == war) then
					timesCatched = timesCatched + 1
					print("Año "..year..", "..TRP3tl_trans_wars["war-"..war])
					warYearfacts[timesCatched] = _yearTable[j]
				end
			end
		end
	end
	--print(raceYearfacts)
	
	--if #charYearfacts>0 then print("Y el año es: "..charYearfacts[0]) end
	--print("Hallado "..timesCatched.." veces")
	if #warYearfacts > 0 then return warYearfacts else return nil end
	--return charYearfacts
end
--checkRaceAtYear("tauren","-64000")
function trp3tl_setRaceTimeline(race,timeTable,checkLength)
	TRP3tl_actual_navigation_area = TRP3tl_areas_for_navigation[4]
	if(checkLength) then
		TRP3tl_hideNavButtons();
	end
	print("--@start setRaceTimeline("..race..")")
	--local _race = race;
	--local fauxYear = e["indice"];
	--local tabla1 = WL_TIMELINE_BP[fauxYear];
	--print("Pintando datos para la raza "..wl_trans_races["race-"..race]);
	
	TRP3tl_yearLabel:SetText("Raza: "..wl_trans_races["race-"..race]);
	local orderedFacts = "";
	local factsnum = 0;
	for j=1,#timeTable,1 do
		local pre_factTable = timeTable[j];
		for k=1,#pre_factTable,1 do
			factsnum = factsnum +1;
		end
	end
	print("---factsnum = "..factsnum)
	if (factsnum>30 and checkLength) then
		print("---inicio de separaci√≥n de p√°ginas")
		TRP3tl_hideNavButtons();
		timeTable = TRP3tl_createMultipageFacts(timeTable,factsnum)
	end
	for j=1,#timeTable,1 do
		
		orderedFacts = orderedFacts.."{title1:center} Año "..timeTable[j][0].."{/title1}\n";
		local factTable = timeTable[j];
		for k=1,#factTable,1 do
			if timeTable[j][k]["icon"] then
				--print("wl_debug: hay iconos");
				orderedFacts = orderedFacts.."{icon:"..timeTable[j][k]["icon"].."}";
			end
			orderedFacts = orderedFacts.."{title3:center}"..timeTable[j][k]["facttitle"].."{/title3}\n";
			--print(timeTable[j][k]["fact"])
			orderedFacts = orderedFacts..timeTable[j][k]["fact"].."\n\n";
			if timeTable[j][k]["picture"] then
				--print("wl_debug: hay imagen");
				orderedFacts = orderedFacts.."{icon:"..timeTable[j][k]["picture"].."}";
			end
			
		end
		
	end
	TRP3tl_htmlFrame:SetText(TRP3tl_toHTML(orderedFacts));
	print("--@end setRaceTimeline------")
end




function TRP3tl_createMultipageFacts(timeTable,factsnum)
	print("----@start createMultipageFacts()")
	print("-----timetable length: "..#timeTable)
	TRP3tl_navTables = {}
	--print(#timeTable)
	--print(factsnum / 30)
	numPages = math.ceil(factsnum/30)
	TRP3tl_showNavButtons(numPages)
	--print("numPages: "..numPages)
	local limit = 0
	local _lastIndexedYear
	local _timetable30 = {}
	local _timetable60 = {}
	local _timetable100 = {}

	for i=1,#timeTable,1 do
		_lastIndexedYear = i;
		local pre_factTable = timeTable[i];
		if limit<30 then
			table.insert(_timetable30,pre_factTable)
			for k=1,#pre_factTable,1 do
				limit = limit + 1
			end
		elseif (limit >= 30 and limit < 60) then 
			--print("realizando iteraciones en _60")
			--print(#_timetable60)
			table.insert(_timetable60,pre_factTable)
			for k=1,#pre_factTable,1 do
				limit = limit + 1
			end
		elseif (limit >= 60 and limit < 100) then 
			table.insert(_timetable100,pre_factTable)
			--_timetable100[i-_lastIndexedYear] = pre_factTable
			for k=1,#pre_factTable,1 do
				limit = limit + 1
			end
		end
		--print("i es "..i)
		--print("---------")
	end
	print("-----primer año registrado: ".._timetable30[1][0])
	table.insert(TRP3tl_navTables, _timetable30)
	table.insert(TRP3tl_navTables, _timetable60)
	table.insert(TRP3tl_navTables, _timetable100)
	print("----@end createMultipageFacts()")
	return TRP3tl_navTables[1]
end


function trp3tl_showNavButtons(num)
	for i=1,num,1 do
		local s = getglobal(wl_navButtons[i])
		s:Show()
	end
end
function TRP3tl_hideNavButtons()
	for i=1,#wl_navButtons,1 do
		local s = getglobal(wl_navButtons[i])
		s:Hide()
	end
end
function trp3tl_setNavigationNumTimeline(index)
	--print("y lo que se mostrar√° es: "..index)
	index = tonumber(index)
	--print(wl_navTables)
	--print(#wl_navTables)
	--print(wl_navTables[index][1][0])
	print("wl_actual_navigation_area: "..wl_actual_navigation_area)
	if(wl_actual_navigation_area == "race") then
		setRaceTimeline(lastSelectedRace,wl_navTables[index],false)
	elseif(wl_actual_navigation_area == "wars") then
		setWarTimeline(lastSelectedRace,wl_navTables[index],false)
	end
end
function trp3tl_getWarFacts(self)
	
	local strwar = string.gsub(self.value, "war%-","")
    print("Recuperando datos para "..wl_trans_wars[self.value])
    --print(strrace)
	local warYearsTable = {}
	local count = 1;
	for s=1,#wl_timeline_bp_years,1 do
		local tempTable = checkWarAtYear(strwar,wl_timeline_bp_years[s])
		if tempTable then
			warYearsTable[count] = tempTable
			count = count + 1
		end 
	end
	--print("años contabilizados: "..#raceYearsTable)
	setWarTimeline(strwar,warYearsTable,true)
end
function trp3tl_setWarTimeline(war,timeTable,checkLength)
	TRP3tl_actual_navigation_area = wl_areas_for_navigation[4]
	if(checkLength) then
	TRP3tl_hideNavButtons();
	end
	--print("--@start setRaceTimeline("..race..")")
	--local _race = race;
	--local fauxYear = e["indice"];
	--local tabla1 = WL_TIMELINE_BP[fauxYear];
	--print("Pintando datos para la raza "..wl_trans_races["race-"..race]);
	
	TRP3tl_yearLabel:SetText(wl_trans_wars["war-"..war]);
	local orderedFacts = "";
	local factsnum = 0;
	for j=1,#timeTable,1 do
		local pre_factTable = timeTable[j];
		for k=1,#pre_factTable,1 do
			factsnum = factsnum +1;
		end
	end
	print("---factsnum = "..factsnum)
	if (factsnum>30 and checkLength) then
		print("---inicio de separaci√≥n de p√°ginas")
		TRP3tl_hideNavButtons();
		timeTable = createMultipageFacts(timeTable,factsnum)
	end
	for j=1,#timeTable,1 do
		
		orderedFacts = orderedFacts.."{title1:center} Año "..timeTable[j][0].."{/title1}\n";
		local factTable = timeTable[j];
		for k=1,#factTable,1 do
			if timeTable[j][k]["icon"] then
				--print("wl_debug: hay iconos");
				orderedFacts = orderedFacts.."{icon:"..timeTable[j][k]["icon"].."}";
			end
			orderedFacts = orderedFacts.."{title3:center}"..timeTable[j][k]["facttitle"].."{/title3}\n";
			--print(timeTable[j][k]["fact"])
			orderedFacts = orderedFacts..timeTable[j][k]["fact"].."\n\n";
			if timeTable[j][k]["picture"] then
				--print("wl_debug: hay imagen");
				orderedFacts = orderedFacts.."{icon:"..timeTable[j][k]["picture"].."}";
			end
			
		end
		
	end
	TRP3tl_htmlFrame:SetText(TRP3tl_toHTML(orderedFacts));
	print("--@end setRaceTimeline------")
end


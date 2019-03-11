-------------------------------------------------------------------------------
--- Total RP 3
--- Scoring module
--- ---------------------------------------------------------------------------
--- Copyright 2019 Solanya <solanya@totalrp3.info> @Solanya_
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;
local Ellyb = Ellyb(...);

local loc = TRP3_API.loc;
local Globals = TRP3_API.globals;
local isUnitIDKnown = TRP3_API.register.isUnitIDKnown;
local hasProfile = TRP3_API.register.hasProfile;
local openMainFrame = TRP3_API.navigation.openMainFrame;
local openPageByUnitID = TRP3_API.register.openPageByUnitID;
local getCurrentContext = TRP3_API.navigation.page.getCurrentContext;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local getPlayerCurrentProfileID = TRP3_API.profile.getPlayerCurrentProfileID;

local RPIO_LOC_EN = {
    RP_IO_QUALITY = "Quality",
    RP_IO_VOCABULARY = "Vocabulary",
    RP_IO_ORIGINALITY = "Originality",
    RP_IO_STYLE = "Style",
    RP_IO_TITANFORGED = "Titanforged",
    RP_IO_SCORE_TOTAL = "Total Score",
    RP_IO_SCORE_TT = "RP.IO Score",
    REG_SCORE_PROFILE = "Roleplayer.io",
    REG_SCORE_PROFILE_TT = "Evaluates your target's RP profile with state-of-the-art algorithms.",
}
loc:GetDefaultLocale():AddTexts(RPIO_LOC_EN);
loc:GetLocale("enUS"):AddTexts(RPIO_LOC_EN);

local RPIO_LOC_FR = {
    RP_IO_QUALITY = "Qualité",
    RP_IO_VOCABULARY = "Vocabulaire",
    RP_IO_ORIGINALITY = "Originalité",
    RP_IO_STYLE = "Style",
    RP_IO_TITANFORGED = "Forgé par les titans",
    RP_IO_SCORE_TOTAL = "Score Total",
    RP_IO_SCORE_TT = "Score RP.IO",
    REG_SCORE_PROFILE = "Roleplayer.io",
    REG_SCORE_PROFILE_TT = "Evalue le profil RP de votre cible avec des algorithmes de pointe.",
}
loc:GetLocale("frFR"):AddTexts(RPIO_LOC_FR);

local RPIO_LOC_DE = {
    RP_IO_QUALITY = "Qualität",
    RP_IO_VOCABULARY = "Vokabular",
    RP_IO_ORIGINALITY = "Originalität",
    RP_IO_STYLE = "Stil",
    RP_IO_TITANFORGED = "Titangeschmiedet",
    RP_IO_SCORE_TOTAL = "Gesamtpunktzahl",
    RP_IO_SCORE_TT = "RP.IO Punktzahl",
    REG_SCORE_PROFILE = "Roleplayer.io",
    REG_SCORE_PROFILE_TT = "Bewerten Sie das RP Profil Ihres Ziels mit erweiterten Algorithmen.",
}
loc:GetLocale("deDE"):AddTexts(RPIO_LOC_DE);

local RPIO_LOC_ES = {
    RP_IO_QUALITY = "Calidad",
    RP_IO_VOCABULARY = "Vocabulario",
    RP_IO_ORIGINALITY = "Originalidad",
    RP_IO_STYLE = "Estilo",
    RP_IO_TITANFORGED = "Forja de titán",
    RP_IO_SCORE_TOTAL = "Puntaje Total",
    RP_IO_SCORE_TT = "Puntaje RP.IO",
    REG_SCORE_PROFILE = "Roleplayer.io",
    REG_SCORE_PROFILE_TT = "Evalúa el perfil RP de tu objetivo con algoritmos avanzados.",
}
loc:GetLocale("esES"):AddTexts(RPIO_LOC_ES);

local SCORE_NAMES;

local SCORE_ICON = Ellyb.Icon("Achievement_ashran_tourofduty");

local SCORE_ICONS = {
    "INV_Archaeology_70_CrownJewelsOfSuramar",
    "INV_Misc_Book_17",
    "INV_Horse3Saddle001_Brown",
    "Achievement_DoubleRainbow",
    "INV_Misc_Dice_01",
}

local RANDOM_VALUES = {  -- making my own random with blackjack and hookers
    546083155843,
    814358034161,
    964715235016,
    143618661823,
    419613748567 }

local function updateScores(profileID, updateText)
    local stringSeed = string.lower((profileID or ""):gsub('%W',''));
    if stringSeed == "" then
        stringSeed = "random";  -- Safeguard in case we stumble upon a Russian or Chinese player using MRP/XRP. You never know.
    end

    local splitAmount = math.ceil(stringSeed:len() / 6)

    local pseudoRandomSeed = 0;
    for index = 1,splitAmount do
        local splitString = stringSeed:sub((index - 1) * 6 + 1, index * 6);
        
        pseudoRandomSeed = pseudoRandomSeed + tonumber(splitString, 36);
    end

    local totalScore = 0;
    for index = 1,5 do
        local score = math.fmod(RANDOM_VALUES[index] * pseudoRandomSeed, 583);
        if updateText then
            _G["TRP3_RegisterScoreIconText_"..index]:SetText(Ellyb.ColorManager.ORANGE(SCORE_NAMES[index].." : ")..Ellyb.ColorManager.WHITE(score));
        end
        totalScore = totalScore + math.floor(score * 17 * index * index / 55);  -- It really do be like that sometimes.
    end

    if updateText then
        TRP3_RegisterScoreTotal:SetText(Ellyb.ColorManager.GREEN(loc.RP_IO_SCORE_TOTAL .. " : ")..Ellyb.ColorManager.WHITE(totalScore));
    end

    return totalScore;
end

TRP3_API.register.updateScores = updateScores;

local function showScoreTab()
    local context = getCurrentContext();
    assert(context, "No context for page player_main !");
    updateScores(context.profileID or getPlayerCurrentProfileID(), true);
    TRP3_ProfileReportButton:Hide();
    TRP3_RegisterScore:Show();
end
TRP3_API.register.ui.showScoreTab = showScoreTab;

function TRP3_API.register.inits.scoreInit()
    SCORE_NAMES = {
        loc.RP_IO_QUALITY,
        loc.RP_IO_VOCABULARY,
        loc.RP_IO_ORIGINALITY,
        loc.RP_IO_STYLE,
        loc.RP_IO_TITANFORGED,
    };

    for index = 1, 5 do
        local CategoryIcon = CreateFrame("Frame", "TRP3_RegisterScoreIcon_"..index, TRP3_RegisterScore, "TRP3_SimpleIcon");
        CategoryIcon:SetSize(20,20);
        CategoryIcon:SetPoint("TOPLEFT", TRP3_RegisterScore, "TOPLEFT", 20, - 50 - 55 * index);
        setupIconButton(CategoryIcon, SCORE_ICONS[index]);

        local categoryScore = CategoryIcon:CreateFontString("TRP3_RegisterScoreIconText_"..index, "OVERLAY", "GameFontNormalLarge");
        categoryScore:SetPoint("LEFT", CategoryIcon, "RIGHT", 10, 0);
        categoryScore:SetHeight(20);
        categoryScore:SetJustifyV("MIDDLE");
        categoryScore:SetText(Ellyb.ColorManager.ORANGE(SCORE_NAMES[index].." : ")..Ellyb.ColorManager.WHITE("0"));
    end

    local totalScore = TRP3_RegisterScore:CreateFontString("TRP3_RegisterScoreTotal", "OVERLAY", "GameFontNormalWTF2");
    totalScore:SetPoint("BOTTOM", TRP3_RegisterScore, "BOTTOM", 0, 25);
    totalScore:SetJustifyH("CENTER");
    totalScore:SetText(Ellyb.ColorManager.GREEN(loc.RP_IO_SCORE_TOTAL .. " : ")..Ellyb.ColorManager.WHITE("0"));

    local randomImage = TRP3_RegisterScore:CreateTexture();
    randomImage:SetSize(250,250);
    randomImage:SetPoint("RIGHT", TRP3_RegisterScore, "RIGHT", -30, 0);
    randomImage:SetTexture("Interface\\Pictures\\artifactbook-mage-cover");
    randomImage:SetDesaturated(true);
    randomImage:SetAlpha(0.5);

    TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()
        local openScoreTab = TRP3_TabBar_Tab_5:GetScript("OnClick");
        TRP3_API.target.registerButton({
            id = "za_score",
            configText = loc.REG_SCORE_PROFILE,
            onlyForType = TRP3_API.ui.misc.TYPE_CHARACTER,
            condition = function(_, unitID)
                return unitID == Globals.player_id or (isUnitIDKnown(unitID) and hasProfile(unitID));
            end,
            onClick = function(unitID)
                openMainFrame();
                openPageByUnitID(unitID);
                openScoreTab();
            end,
            tooltip = loc.REG_SCORE_PROFILE,
            tooltipSub = loc.REG_SCORE_PROFILE_TT,
            icon = SCORE_ICON
        });
    end)
end
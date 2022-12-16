-- back from the grave
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;

-- I'm aware this is horrendous. Will definitely need to figure out a better way to handle this string
local importString = "1QXAZjQs2)l(LRwvcLA8vYUz3Y1K449MOPeDN7wtg0wOjHkeGIgYmE3z93(EonVrabJjzgds3NtFE1NxDl1sAHKyljXfMoe95pEXU1tjVrT0jouMKOZwlQK4lMMVkjEHK48h9gMTBTQP9U1pItZojiTLM2(IE9g0vsSR00w963SzRoDh0xsSJK49M20nu65pyAASB9yxITIKyFyAsI9KM2PFtjXlrc6gQMHMJgrx7VioAMgsIQUgY4t7wx)ntLfKn60g7(9DR9(vtD36fa1VA6WhU9X7hU4wXvdV5Mzt3T25fQr0ed(nNjF9U1gA6rtNAOS73HpKedzXDRhQOqvsqrmQU6z7w7c08ef)hUZgG4mefVZPw4Xmi8GxD1slfa5HRs9qu0WNaMCQei7(LpxMJO5qGwZtRxlp4d(1M64AdKNkrNr3FACrBMFj6PiEmuoHIH6nYMQnmD2TEcd0pZmU3KaAP61cSRR14usV7tQPvOcCr4WhNWnQwn(B1cErTVFaOI2nLew89Czp7GOi2Cx6GQ6SXdowH46EoK7Xtc6MYLryK)USqJOQisX9e3OXazZ2jgQMCe9F)Fvcfp7QPRGcGrM6OhSm5oxqSWeKXz495itf6D6MehyBPfr(1WDCWWgQApNcTnACik4b6BBO2Fc0qmeNfvuaDP6QRVqZr)elzsI2cLmUm6Dfqe(iC)zvfU0Msu2YXRJTl9O2qlC77udhgGQN1yGn8iIU(gK1RnA207MmE58HlMmB6QrFz40X3EtTZI8JvxqqOrKNMqNAZmgXzoxBUZ9rVqmEgCEHZ(VX98a)50sQZVD8eXf3oF1ndxmC1YhH)uwsDUpYUH4q8IAD8uQFyVH66ro9YY7EazKuPv(OgJPolt68GhGDH5RuJcwU8888TqG)(XqnIfqnGkqj69nkV3W40eAFhdlhdnwu(i5g7nCs7wJ7Ed)Qar2X0EbKmzqoeQ2AaTOVfjrEUe48tIdbVqeZmeLTPuJsg((yJBhYdPDvu8Qcbcjq4vmB1eERYnpL4RNhuCbc3W(aR1H40c54skg85hUo3xtE9E6eVbYd2q7qoOrysWiiVJLHZipCOKkkFo5hv1915UEZF0hftdy5eLbucZMeumxpg6fPIzo(XCpS)Bo)CaHCAcivo75y6)veT)gdzF)HYK)ITGc(iOq709fM5LibZbsJW20QE6L4SIZNv4HH)jpVsmi7CXmed0mZHpFk03qc)EcHnVyGgFCVkPwXJYa58ZNyWO2b6suPXCioUm)1HktzmI92dRfTn1XDqBf9bVu(4SSPQuBBQIOZw9S0Rj1r4EZhdaz2Srtmu0Kjqyao4hY1yru71xZRbFMXQGI7eU1W9nMW8z3JvA8FwjUy4ILIcZwUy1S742idhbj7uwhSibSh3IrTMaz4vRSyPSBhszAdIQv46SBTGqAGp4AwSz)HPSA)swf(Pj8tnpcO238FiQMqHrpScOs)X)(VGi31ooQnt7(tquSu7uWAq82V4GvnC49hHfTSBnbwX98WlWEX0vx5lAk0sU5jggRQ)WqqlJtXftwCF(EfJZVfv2v5mW338j1B42hpzK2akDLM4GXKpCO(vMTgOsw5vG8stdFsgLdTSW5UMxPErrCJL0ex)6vDiA19JvCGxvM4WPWKxQ2Jd6urCt7ecMRu1muQx7V7R2kcdCj4)4WTwRSue6K1lRFKVto2h1PB5Sn3V7m8jwEHrHgUNk30vGxI1RRpfo5ZZfoeI33)TMmwA6p0uEgtKLx5e6p2KYm(n4b6p1yoNLCaSj88ky5V6Go89wHOneXKoON2jPg(4cfOyEy5zq9KWc(vF(nrruxnckl1HUG(ti1rADOkfGtRnC(IVoB(FuRrj2cgI5RgPtj2d11F0uZWHvVAad1uWHRET5tg)LfyRJIj0g5cPozeMsTOJTMXZiLE)T3XN75DGpA2a1ZGflzlM(kvXR0eBQfbHE36neg(su4)cLO78YgI9)SsKjQxkdND4zKPjX1juvvCJa4eOa7WpftWmqAfmdYcAWoiWymVSAardo1GPLMFBu9vuu7VsVCPYfkEXhiuCioIv6uyJxT1eIXxVr(wlzAwuDLEE7lkT35L(ExnIox031yAB001CkrfOL3KnS3t5tZfgnnc(CfTLLNJ6JISxevt1S7RcwQHLTPQME4ClPeHhQE6r1KL4iJVMx9vBIfURBIXOGZQPEc4oncJyMa(YfuqihwkrGZB0FE1eeFXhUIff(zmceuyNb5qxp(XWVV0bCrmF8)I7cjtpdLusCipcbEipOKpQjRjAuAoj9veDuj4R6rcCWZQHFZqwDwc7cnapAwenBw9rrUQrvqKFBujuyosX6VCuRPdxeHO3xyfrPpOIY0kUQCznoM75aMeKZlAmyxJNjK(2y53cYeiW)wyc84lBCH39kLAbF1lHxxd(z8pbaNGxGb8GeXJGX1pBzpuJ)3YKb(O1PrN3srk8SpRV4Th17qcpWjc5FyaHNWdAvoH5vGx821FCDfno5ScFX1ERqYw52i3w)hZkfGmM1PqCRZ7mTrKwic5mDe2k2PvU2szyq34KD7zk4GMp(dPn8ss5ijoaV9woeDWggEcEXZ2MUwEpkRtymVhFJyTstX)ly)D9EY6DR4WAtK9hGOQQ9tVhPgYMGbp1ocbmlQm)j45LtUrsS5p7DXGlADz7UT7sBjFrlcquMYVtTz4DNAAlSbNTb0QOGxLkVaisIMwOqbr6u(1IdpWsPPD9U8xaRGviZJSWKe)3eDx4DJ9ALJNtw)6Sh5YCmFl8IA9h0TjG9EYgQUKiMggERUGvwf4ZN4D0M9KhT8K2BKNPSN8OOv6EGCdLjljoA29ZMdS602r0yRaACF6jGu5m1DdADzN(d62FWL9A2)Yl6lPEE3UiQGbNEH0DD7Fz7b9629YoOemC8o44oX5LW(kunor2deFojvwuX7lgVOpJO7vOdsE5YVEDSjtoUxVon71ey7oDHFA3e5OoihF3GMTg0QFNMDB2StRbD7HJCbUmOSyFoowxH(48SAyUrjzAquOs11n)r4aVXxwUaOtggLjBMAKHjMcQFdvlWSmf0FuttKi7MHwknXKud1TD7(9BoOzB4F9gmOvOnzM6US1qjzKtJnPxFX8p0awwwK9I41ob86sgnqwhk65A7qHqa3VXN23Rb8vJ83yAgQaU1GWJUJjG7YO5xocKrgexNOeB3N)awAYVICnzJ57uUpvhjP))d"

local Plater

local TRP3_PlaterNamePlates = {}
local PlaterMod

function TRP3_PlaterNamePlates:OnModuleInitialize()
    if GetAddOnEnableState(nil, "Plater") ~= 2 then
        return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
    elseif TRP3_NAMEPLATES_ADDON ~= nil then
        return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
    end

    if self.PlaterMod then
        Plater.RecompileScript(self.PlaterMod)
    end

end

function TRP3_PlaterNamePlates:OnModuleEnable()
    if not IsAddOnLoaded("Plater") then
        return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
    end

    Plater = _G.Plater

    -- Setting the global TRP3_NAMEPLATES_ADDON is done via the mod and should not be set here.
    local success, scriptAdded, wasEnabled = Plater.ImportScriptString(importString, true)

    if success ~= true then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end
    if not scriptAdded then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end

    scriptAdded.Enabled = true
    Plater.RecompileScript(scriptAdded)

    TRP3_NAMEPLATES_ADDON = "Plater"

    self.PlaterMod = scriptAdded
end

function TRP3_PlaterNamePlates:OnModuleDisable()
    self.PlaterMod.Enabled = false

    if not TRP3_PlaterNamePlates.PlaterMod.Enabled then
        TRP3_NAMEPLATES_ADDON = nil
    end
end

--
-- Module Registration
--

TRP3_API.module.registerModule({
    id = "trp3_plater_nameplates",
    name = L.PLATER_NAMEPLATES_MODULE_NAME,
    description = L.PLATER_NAMEPLATES_MODULE_DESCRIPTION,
    version = 1,
    minVersion = 92,
    requiredDeps = { { "trp3_nameplates", 1 } },
    hotReload = true,
    onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
    onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
    onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});

TRP3_PlaterNamePlates.PlaterMod = PlaterMod

_G.TRP3_PlaterNamePlates = TRP3_PlaterNamePlates

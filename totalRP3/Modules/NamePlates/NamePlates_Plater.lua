-- back from the grave
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...)
local L = TRP3_API.loc
local Plater

-- The import string for our Plater mod
local importString = "1Q1EZjoos8Vl8pluvIlGWRK7M7kosGWUjqkmCZE1KyqylN4AewuwMmd7nhF2p1YVn(jHeMIryRU1VUvRwD3sknuMRi3qrEo1grM90vhwnbTbVLGSXmfz79BXkYVrPFxr(kf5zp58A2Hv6uRdREc6MvusAQmP5vD60RTICBLjn60TzNonUUdFiAPiFpNFwmQPH6LpsPMJ2HS0uK7Y7NIChLjTB0rr(Aar3InmnSnqeJ)czBqnvK13zQcToSQ6gQ2C0AcU2HF)WkNpg6hwnNd)Lt6)4Dp9q)53jVS)T3oDYHv2VHnd6O3Nu68xoSY0Ge0DSP2HFN)LISVmEyvFnnSweeXWe9loSAhhZJ1CBm0ItXfalExGwEZeaU3JUzXwnoZ9hLQ(SOMlagFUuih(LRuMIQjpsR4mTxjn69(yHT3zXHNoIWWh3nHQnXFe0kqg91tGAOATKrTj1(WQXm(8ZuZhOi(Su1kEg2vQDoX7Xqn(eQKqf2)PXcJQLJ(wfVhu5LCOky5uuAHNl09SCzrO(UWgMQtMpW7YKxpiO8izsIqvlIYi9vz(grLrLcRjU1GX1n7hBQtfm6)()YGaFNiyTu7CgK)6odIgOTgqjG)Uevf746qMKk0dNVhq1WdjuKnFn8wK639xEYFTPUXRXyBTA5HGhXBwJT(eWqigNekYax67iK5g2KZSMjkBZuZSJHhMbiCz4X9QmsPfgPTxWxBRD4tA1V0DVJnTzCw9QbJBWpariRbrVYGPtgoE0Iz9NpE6KLdUV)Kr3DBLlcC6vvssQwGBjFpGtnhieUDwIDcg8gY8vUNoO3)nHBk()DEH6S7gnwE(DZwEB)59xU4j()vuOoZLz3ISroBXD6i1DpY(esGhYK2kWdgrN0k(wmJW2lI6PrSB8C63XMzmCP5M6B(e)YPGg5mqdFkql451kURZWycSVdXLtuJnHATXXtlGwycktLgFdeeXjqPjoXjbnNHrKncaviMKruaH4g4AimZHDFYn4LOOjI8jESaB1o5Oe8Sz8K)dRKK4W6Ykoncg9tyYiRijZuFj6uG(s8tjKQn1AopUDVO)0Tm4yHShSxerbc9pkpKC2CFQPSQfgBwWaVovDPVme3VD2JQRfieIqKTosncZWJNdvcfIWltoJvEsAMsCbvdUYJyo3DM8lhnN48ISwnkwRjinGtsMErmUWVhPXdTyXNLsKTL1jBQJ3SNCzXeproscCfy)Vqbj(Tc7r7fFTBkQJmStJOIego((dkzsgFSnho(jxEjNHcmXHQqFAtD)jW2FJb6B3xLO8fAaLCzqMlmaACTeIQGVWnpSAUoSFGAHxJXUUBkejbfBOsrxFESXuAr1oLO9kvZqFF14ICgEoWjMy5PdcMnpWAl62JWWfzNoO0J9)trAzqyNZKRvwhszkghd)CMT(W(9JnIN0kQlVCSjdB5z8dw5mBK9oM74GvXmgYAF(M9wuc4JBVSl5fAxOTwyDSLfwt2EpjPj9OtGG7PN8iz60bJn1mur8nQfKN3MxzHwyLJO(jl9kCI0DM72WKMn9bil()Zs559NVqwA6I5lNouya1Fap3GIUedaWrslSCDmpHOcVqTORvIz3ZvvlHXXjkROeN7ywSvVPJSk)svN)xD(FUH5v5BUncQ3I0GhxYrP77F5xCNDvon0MOD)zioJyRuGu2DwVydjzN)6d)C8pScXhXJ2suI9gDhr7EdnCbx8eIJL1zPpPfXJ58XZFiFxMG8Mvvko1DII9eH9XZMXnGIxyg4LH0pcQ(vILD7dUhvQWlog(Kmk7VDl03vIcBLvikHcRvm)6umfWQ7hlfeVSObUeItojdnYRWEHnTJOyUr3WuRAL)U70wwCqOb)h5x26IIiWjRtEzGCh9DFuNUfZ284Izk6yXvgzA4EUCtxczjuPH)uKKppx48T4D9FBOcfp4hgAVcr(lYTf8htXmZFJ3a)tdM9frFbuSgrngepkxh(oJqWcIqAhWt74yV(02kqJMV(0lJF(a(vx5nsAU3mWcZBph)tEOJ4Q88i5sAL(ZM)1PZ(Jk1kWsqFoFZacgz1NqEIAyAZQwoI5jHjORALzJhD)COsRHuAd2XdDY0pKAzBldZxbK(WDdf99Yw8VQxdMN5wSO9q4RWbGa5YzH3IaQpSAnIbpeu(VHre73wJS(NLcMW8srKS87rIMeFjYuv5trjd7WpftWeyAjmdsIAUDGNXyAr1Wvnqx96wC5Tw5hrzJ)k(WflwOWjFaujO4egPZHnE5gt(E8jw0wxRLenlk)KEARlkS35fUExndUZbVBWmwBqmSlqgOf3K1V6GPJ5m3nnG(uvTfvMdk8KQZoQu9KlefKQXwlQUbXVVfuJi2QUib8CCqbHzMymV5RwOTWQUXMd8oAZQrO78Omczc4QxafHQFQeEoVb)5LtrCVlDzRkCJyKdi)A3kOUA4R4YXAhUlIzJ(xcxij6zOGAI88i45HmxnFqzWJuk7uc6llCuk6l7H2K7rBkU2vlViIDHbNpgBrgwSQdcCvlQGTVFBysiZyKcDcabhEG)Gif88mZik(rjvKsXvMlc1z6oeL8Xsh6SifhND2hw2hOwJrQqq4tFWJVVuWcFeYiGpBfAYxk8K)qQfyRwn7HmNkAeAOeXjfOc(YxY9GGdSJo(GKQbJqXY)mvtKeStR9rYCQmwsPExmo97XG)Lo0wrUhCBiTreURpEl(dE1IUBRttvcIXCAUbTDPHM7pGA660A77BdtlBlw1Pfsx34NonXMQ0DM81cHyas1Hb82lgFRIC9F25QEx146MTB2g3q9QgioOOQVJTyWDrCsdOOMn5SvtdUAIoBAOit3ckfGPte3Zu4yKvM025YuYffiRyXUjmf5)nISJ)SroLVXX0Yn36b7y20n(x8X)aVpcTpGwJjkYqOxWTKKpY6C8)SOk2SNDWYZgBqVIzp7GOLehsUfZuvKhm9HPZ4I6KMbySHhgpgpEqviud7146wD71UBVR7uV71x1vr)Y2TbwXF5KRug2U71n71PD7RBbAq)33cEVDyzXVwcLtsuDiXvsIf5u4AHjs0Zm4I6AdWlv51PknjkXD60QEN6CXUvB(FnRdsulqIh2REJEn62QE761B1Ox7oWBUcggqxCSehQsqFCzw3pEOOcnxvOJje6p8FXgXWkuaTsWOmAbudmmHWoDlIAgMLXO(JAAcGSDcZsXbt0zO2nB2TB9E1BY)xNE9A4BtM4CxYZqrfKZJnPtTWCpOawswKDcK1wEY6cg2tx7R6fZ2(kbpPFTl2pQO7Ld(RPu)jG7mbh2obDVJHJMHI6BugS9pAn9DrCy8ikqAHw)DCQkcFQ2kk))p"

local TRP3_PlaterNamePlates = {} -- magic public table

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if GetAddOnEnableState(nil, "Plater") ~= 2 then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL
	end

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod)
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not IsAddOnLoaded("Plater") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY
	end

	Plater = _G.Plater

	-- Setting the global TRP3_NAMEPLATES_ADDON is done via the mod and should not be set here.
	local success, scriptAdded, _ = Plater.ImportScriptString(importString, false)

	-- If the mod was not installed (is already up to date) then find the installed mod object so we can still control it
	if not success and not scriptAdded then
		local scriptType = "hook"

		local scriptDB = Plater.GetScriptDB(scriptType)
		local newScriptTable = Plater.DecompressData(importString, "print")
		local newScript = Plater.BuildScriptObjectFromIndexTable(newScriptTable, scriptType)

		for i = 1, #scriptDB do
			local scriptObject = scriptDB[i]
			if scriptObject.Name == newScript.Name then
				scriptAdded = scriptObject
			end
		end
	end

	if not scriptAdded then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end

	scriptAdded.Enabled = true

	Plater.RecompileScript(scriptAdded)

	TRP3_NAMEPLATES_ADDON = "Plater"

	Plater.ForceTickOnAllNameplates()

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
	minVersion = 0,
	requiredDeps = { { "trp3_nameplates", 1 }, { "Plater", "external" } }, -- by replacing the version with "external", we can specify other addons as a dependency for our module
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});

_G.TRP3_PlaterNamePlates = TRP3_PlaterNamePlates

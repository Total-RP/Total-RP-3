-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

-- The import string for our Plater mod
local importString = "1QXAZjooY)l8LfQkXfVFK7M7kosGWUjqkmCZE1KyqylN4AmwuwMmd7nh)2p1YVFBtiHujcl1VB1Q7wwQH0sjXgsIljwi9fp160MzOD496ilmvs064ESK4BeY3LeBjjU4j7PPN2OsmpT5jyzMHbPP0SMT62TFhjXosZA0Tx3bngmOnd62sI3ZWNjLyOjF9JeIXKditfjXES1jj2vAwNwS)pa4OBXAgAwAiDT)czPrmKevpyidJoTP6oIYs0wDCTt)(Pn2F0upTzjJ9xpB4J390ddxEN46H3E78zN2y9g2WFHUFszXF50gdnD)LJnuo97S)ij6jJN2murbReIJOyD1RoT5aJNNQ4mySjdIRau8oNBzdtGXDF0nR2RWqUhvQ6HIAomW0lLc50VCKYuun5bAfBZEL0G39Jj26GjJ9ur6uC8LXvTj(f)r(YONEcudvRLmxBqSoTzkLzFMB8abXSsvR46yxP2LKFJZQrnOcCv4WNMYDQwp5BvCFqLxYbk)TtHHfEox3tZffbw7klWuNmEG5YexpWHmMmjOtKlIYi9DzEorLrLc7jUvJY0nhNAOs4i6)()YaaVGiyLuxCgG)6bnDfqBnIOdX7suvCGPdPcYWkS)7iIcESobzX2dVhj)DVTNSPnu1EncARvlpo4r8UTyZpbEiaItIlYGVupORVuZs)cRzcJ2m1mhO4XzWeoim(QkJuAIrkh541Y8a(S29lC37ydlkdvVQrzo8Jq66BbrVYO5ZgpDYQfdxoD(S1JUF4Sj3DBLR8d6vvqqOMFyjViGZngXfUdM8tcg9gY4vwKoy1)nEyk2)USS6I7MmvC5DlwF7WLdxV6j2)kkRUWbz3ISq2hXD(CQZzKd119JqM0rbUSryJwXpIzc2Av4in8tJxs(o2idYLwyQV5b8lNd3iMb3Wmbk(pVwXdDgKNa)7ay5m1yZiM7SJ0cClyGYuPXoabPBNO0m78KGHlWi9DCgQqijJSacGni0qqKdN(KBYlH5MqYh)XCER2zNLGRpJR8FAJGaJTUUI9aFQFggJSYKmt9fFr(6l(xfqYweZLS82DZ(t1uJXl6hb)fEwGW6dJdb7d3NBikBIXgfmXRZvx6jdrJBNnvD8aHuecD0rQzygKE2qXvi8Om5qR8K0mL4cQgCKhUn3Xs(Ly2e7jYA3iFVghuFmjy4MX4kVvKgouIKFwkz2w2GSPsVfp5GIzUICOc4kW5Fbss8BfoI2lEA3uuhz4NgsfXDC8IhuYIm(yhoe)jxFndHCEIXQC9PfX5RaA)nkOVDMkr5labfCqqMBmayC8ecRGVYPoSAobSFGyI3IXoHBkei(nBOsr3Fg3zkTSANRR8krrt9y1OICgroWjwy55ZeulwI1MK9X4HRYUCqHhh(N8YYG0oxiwRSbKYumIZ(5yT(WX9JqXZAh11xp1GInDD(bVCQfY6a1HoyzmLImpMVBVjrhIXDu0b8cDk0EtSk20eRiADupjJEydieE6jxqMpF0udfnze7GAo45D4vwClSZH3)K1Unor4oJd7OclM)auf))zT4YHlxjkmF1Y1ZhZDGgoIvBqr3IbmqmPf2UoLvquH3Ow09kr87zQQ1aDSZYkmW5sZIT7nDoRYVKvz)uN9JtAEv(MZa)(Tim6X1mU0z(x(flyxLZJBt0V)cKNrKDkqj727xSGISZF)Hxn(N2Gyum2rIc03ih0vUxtbxWnpbWyzdw6bArIyUC6YhYpKjiVz1LIZ9KOipH7F8SruhOOnMbMmG(Hd1VsSTBFWZOsL9IYdFsoLd3Vhw7gEJTYkfLaP1YTV2ntb86(XAoWRlAIlbWKDXqtCBSxqx7qkMBu1muQw5V7y2YcdCn4)i)2wxuoccYAxxgi3HN7Jg0Ty(MXBMjFHfxzKPJ7LkmDjKLaTg(trs(8cHZoI3j(TMm08GFOP8kK5pV2wiEmbtn(n2a8p1OwxfEcOzn8EmWFuUb8TPG)gIaAhis70itFEhfOqYxF6wXpJGF1rEdvM7nJmXSXlX)KL6iUkRosMKwz4ILFD(I)OsTcSf0dZ3mshJmhQR)erZWIwTCaZkcJdx1klMo5(LqNwdO0gDGL6KHxk1IwMAgVcC6d3nMV2RBZ(t9AGDM5XIocPVcxaculNjEpcG(0MTik8qq5)ggPB92wK5)SuSjyxkIKL)ks0L4lHmvLVeLm8d)uCbtaPLWnijOz(bUoJPLvdt1al1DzrL3ALNIIA)vuYfjxOGfFaqXH4mO0LWhVC0KDgFInT1XBjr3IYB0tBFrHJoVYj6QH)7CW7AuTTA6AwfOc0I7Y61DW055mpn1h(uvTfvM9B8KS9jQe1KBefuQXEtIQMU3AlOgHFuDrs4jEsbbrgNM38vt0Eyx3uJrUxTz1qWDzugbCbC0lGIq2Ruc3G3q88YPiU3bUSvfozmYyiVE3YHUAWxXL4AhwiIft(x8qijgzOGAI8Ii4gHmxnVFBWd1k7us6ll(OuWx2lTj3R2K)AxT(Qq(fAm8OThPzsRoYpunVd2EXTbJqM5if4ga8V8apIi4)8mRik6vjvKwXvMxeQl07quYxlDG7IKFD2zFzzFGEngQdbbV9bx8(sbB8raNaM1kGXxiOXFmXe8vRMnjZPJgbifppjFvWx(sUxeSVFu8lsQgqHIv)zQUij4Nw7Ju5uz8Ks9DX48Fpg8EPdTKe7dVnKwiDwOp2i2dE1KCyV9qzDeLApChA)AnfNVa901E0(33hewtKSZeivvTFApeBitoyW2l4Ja6ESmFeB8QP3kjw)NDB1VvJbn70SdUHCRgigtrKFhBsH3fXznGMA2HHwff4vt0(qdjrYEqPaiDg)9mfUgzPzS19h4JmjbkkMFyc9b0wSUK4)gPFaljoXUfo2Uxo1xp6a1ISZ7LFeMlegKeHuVG3ssgLvzY5Z8UytF2MxEwBh6vm9zBoATUn9UftLLehn)H5lyI6SM(8yJG8Oxz(UCixEg3VXG2963Px)bDR3BqREsQx3PdGf2KZAjnUtVbn73TtNbTbLN38TH5TCfH4YA5KezBqCKKizofSxy8c9m8FrDTaEmz5nqlAclXD72UE36mXUDh2pnRdsuBqIh3VEJ(n61UEN61B3OFNUWmTaka6IeLyBICXKzvV8Hcl0mvHkwxN8dVj2Xjmxb0oUtz4(NgXXes90PrQz5wgbhFaxtGj7e3kfMaHTrDA2SxV69R3K9B3(9B45vMO1lfBuub9Y4tA3lmNlkGMKhzxFzTTJSgRd6UI7wxMDff7Ai8SlC3bpPOCS)wcXZaCNbeW2oP7duC4kuKFJqHJ)rBjVZZdJLrbsjW(V4LQWJPAjj9))"

TRP3_PlaterNamePlates = {} -- magic public table

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if GetAddOnEnableState(nil, "Plater") ~= 2 then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	elseif TRP3_NAMEPLATES_ADDON ~= nil then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_EXTERNAL;
	end

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod);
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not IsAddOnLoaded("Plater") then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	Plater = _G.Plater;

	-- Setting the global TRP3_NAMEPLATES_ADDON is done via the mod and should not be set here.
	local success, scriptAdded, _ = Plater.ImportScriptString(importString, false);

	-- If the mod was not installed (is already up to date) then find the installed mod object so we can still control it
	if not success and not scriptAdded then
		local scriptType = "hook";

		local scriptDB = Plater.GetScriptDB(scriptType);
		local newScriptTable = Plater.DecompressData(importString, "print");
		local newScript = Plater.BuildScriptObjectFromIndexTable(newScriptTable, scriptType);

		for i = 1, #scriptDB do
			local scriptObject = scriptDB[i];
			if scriptObject.Name == newScript.Name then
				scriptAdded = scriptObject;
			end
		end
	end

	if not scriptAdded then return false, L.PLATER_NAMEPLATES_WARN_MOD_IMPORT_ERROR end

	scriptAdded.Enabled = true;

	Plater.RecompileScript(scriptAdded);

	TRP3_NAMEPLATES_ADDON = "Plater";

	Plater.ForceTickOnAllNameplates();

	self.PlaterMod = scriptAdded;
end

function TRP3_PlaterNamePlates:OnModuleDisable()
	self.PlaterMod.Enabled = false;

	if TRP3_NAMEPLATES_ADDON == "Plater" then
		TRP3_NAMEPLATES_ADDON = nil;
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

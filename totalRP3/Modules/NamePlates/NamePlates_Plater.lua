-- RP names for Plater Nameplates
-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

local TRP3_API = select(2, ...);
local L = TRP3_API.loc;
local Plater;

local PlaterAddonName = "Plater";

-- The import string for our Plater mod
local importString = "1QrAZPTsY)l8LhuLTkUb7D9UfbBCyFoyxiyZhEocgKgavrOHshoHDZYV9T7z0j6ajStC98twZ0390xJuAOmtrUHI8mMdXy6lToUCczhDVbXHARi7CypvrElJ9Df5wkYtFrSS9XLRzwhx(cUnR4G0uzsZwD72VJIChLjn627Mw173(M6kYTbQ4ATIT3D3(R)cJz(OlXstrUhSnf5Ukt62RRI8nidDpv3u3rNyO)Fio6mtf51UMQ4thxwDhtBgzLbT2X)1XLIF8FL0mqec5gP5Mw0n62atoKyySIO(9aOV64YkpBI7Llf3tCiZ3RbpPvbqm1udWo8JICa6oUCGMgvlgVytnwdyYf42XAEpmYcGaEMA(MpLsHL1xFCPjZjCTJlD2sbCArDCTmrW1skG3k4XaEQAabfmTI84sP4cxnGcicQgzljy4X2GE4zZNyeqBuTIVNdO2esqci9)XxYwtmSPj3wmbo4NS5JfpYn3lg8Y4C1DzJQyUnc8CxC8MpiHEAXamWPY(CKmCNZD0nYaj8LYgrpXblHOizWulLoa9KUx3gKNdJnxZ4y9)()YbGGJOuTm3CHvGstVSdQLGGBC1n0q8mKzGrVsvR5ckBBjvChIFpKPrhzWioWrT9r5lyzZ16BobT1QDoo4l0DRaX8JNhIG4ALtZS21WyMUJXhSMjoAZvZ4AthLdt4HWK7QmsPfLODGJxhlx6ffFq6H3OMo2sjYQuz4Ztgn(X5thmB8Ztwm8ZdM84d3x5QWiSvLKKQfgHkiC7ZMd5cNRfpG9WTeZnqyvC3)nEGSAFWC60hECS8ShMU4(bZgSy(lW)ROCQ)z0iNbllJY5prDdHr4KcZbgXQxg52lV4adJWqkPLeZxOI7bepDrEjhFK6mpECsEg4zSVtnZHCzfK9Vca(Bxc3iNd3aguTW3xR4b(JYtO5icwUqn2eM1orEcKBrduUkniXfXquk1erLu4JtPeJDCgQqijN6gIGnmotuKdyVsLZvgtCUjM8XFnN3QDX1347Z4l)hxkjbS11vepes9lWyKx1J5QV4BkuFX)tjIQdZAg0IaS9FHQU1w6aVyCa9xOwve7pooKeN9F2uw1IILSvOsgF31kEAsG8PQNhiwGtSiszwBCu6jGIRq4rzodToNKMRexq1GN8WT5EwY7sytelK3Pr(znoOHysY0pk(8GDKfo0oP6YmkfSSbzZKEtFXdft8fzZ0QKUyL4(xfoI23c0UzOoYXpnMk6D1tZ7l5qY3C91ac58eWQC9PdZ7pr0(h2O(2BPuLVieuYdb5EWiP1lbgsEEi1glZgJEEAXnGx51HAT3FyNtO4fzq9CMvDTSGk6EHhALZ88UWx43(TKyfjqKgk26CBQv1cABhBcB238I2rBhIJRTNOqvP22eRdN3WAXmWtXhK9aVSM48Apw6fl6EqPnngnMXMr)Pt1yO6Q8yQl3SEIAcBVrOSCWgsoVYjOFOJljaftCIxYElZ1q7Z6A0cMHkcgVllALBYQ8AaRy5TsAdp5n8QxE10R8Lm75exmI4WH6xqnezNqm3Z6xa7Dkp8Bjv81xpyp6eFCjVN98cygjjl)qGOpr0j5hl4aVisyuaXbXimo45H(MUT(kdDh4V1HdJmtCLnyBBhxUYFt(dX1M64OBUbNwP(MTGN5kyXFWSC2cig7kfweRUjW7hIIXPoZDZ2Z6PQ6A7W29O)Sss4VUjCf0BiISlkMmeYZrjX(hgsp)olJfbfZI)fDB1r6udTpDaRITAqVZ4cixHVvkGY1kpP9lwkvgIhdi9fLEJy46Pke2hVW7fxnydBkKhsQ(tJXY54uUrrsG9WWBXoTD7ADtTQv(7EXcsag)S4)48dsokTJiNfdO3BGRKdXJVXZiu5gkRCH0(qeGiZb9JJ9n1(Tf0utZlUJUk2r7p012GLJYB4cZIYO2M)b8a9N62oxfFbCcc8gF5V6SPPfui0fosSimcX4tw(YsGRXoV(0VnuGGF1tEJ171TdHUzDOy9pqO4QqZn4SYhmD2xFE6FwPwbo)eG5BhAqjwdmmEHPB6yxTCadDgWHRALPJF8ZZWHjgrP5xoQxH2YowI0mvE6Hr89EDB4x1RjYHTJCaR4etrHnyaL8rqOH0reB8LOYFlLy4SDfX6Fwk2eTlfrYo)os1L4UyMQsEqao5NJF4VfxWuqAjCdsdAWpW3zmR7paun4w932PYBTYtrzOn8Q523aKQhADynfCd1qO4qCbu6JWhVC0ek1l1jj65TKQBr5n6zDUOWrNN7fD1m8QY5LEQZR98SbClUlBWiRYMNZnfAi8zQAlQmhonevrAu260Noc2G4El2ADJG9wqncp)8K39Os4082VAr2JN6gBo0)Y7I308hJYiIlGNEbveQbDu6h8gJNxofXN9GlFvHx1Yadfmqro0vJ(LzKu7aHiM(4N4HqsnYqb1eNlIGFeYZQ5dNnBS5RMrLE5XhLc(YEtcN9(24FMqlUkMFb2cP(EIULD1HHHQ5JvniUnAeYTgPiJLoCI2berk89524YP3Vrrgqxz(ICY1nQ4k70V51ixqg)gBZ)gCEhtGm2GIIosCF8(TcoUQiobG1kIXxkQXFeZc9vRMpjpZTWeHu86Kcvb3D3zVDYq)OK3UrnKcfRtZmDrsXpT27PZPY4jL5xBWLF56LH8P9D8Cc55Od)w2CuK7JFnGoedisk8e8Inwm39Ihvni22Ih3r2VqxZ7pSiQuXt7FBFuyT3tvfprwVw)NIhPMQmxt4OveeWmeiaEE(47vKR)ZUT63QXnn70SdTHARgeGPyQVrTSXVXUjnQd)RdGwnn8tUtKdsrMThfFePt4FML44KuMa77pPhajb7XMNBY(jYkQHI8)gh6JIS30meERE9OlgstWh1hUwmmOiJvYHF9FaLxdkGx53oG9RcE5v9DKnu7xfC0cdb9UNARQip85NEEkiQtAgYJnIYJbJkWNd5YZO(nUPDV(D61)MU17DtREkRVUthelWItAPmQtVBA2VBNo30gvEbR3gx3XxeskRLtsufG4jjNuiw0jSY7B0m87u1b5X0L3iZ2jUe3TB76DRdID7oW)AwhLO2OepQF9g9B0RD9o1R3Ur)oDXvAHua1fPkXcI8HjZRdkVkUqdQI1udd2pcwyhNWCfq7KoLXNk)joMyLSEJNpp3YtWX7W1ezYojTsXjWjELn72PDR6T7d)UDRU99SeGnQh4U2P5nT60Uzd4)AhyJGvA0Sz9E1R3TvD4bFyIB3ov4)y8t37DDE8BqYonV0UHYFBp5pXD14Rc(KpZo3M6BCcSvCxKaPOCS)kglWO8GP3xRmuxVRnnEtqQBz2yfgKvS34L6bfTq0ICMmz3q84Sokk))";

TRP3_PlaterNamePlates = {}; -- magic public table

function TRP3_PlaterNamePlates:OnModuleInitialize()
	if GetAddOnEnableState(nil, PlaterAddonName) ~= 2 then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	if self.PlaterMod then
		Plater.RecompileScript(self.PlaterMod);
	end
end

function TRP3_PlaterNamePlates:OnModuleEnable()
	if not IsAddOnLoaded(PlaterAddonName) then
		return false, L.NAMEPLATES_MODULE_DISABLED_BY_DEPENDENCY;
	end

	Plater = _G.Plater;

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
	Plater.ForceTickOnAllNameplates();

	self.PlaterMod = scriptAdded;
end

function TRP3_PlaterNamePlates:OnModuleDisable()
	if self.modTable then
		-- unregister the callback so other addons can take over without a UI reload - we have to do it here because disabling the mod in this way doesn't properly deinitialize it
		TRP3_NamePlates.UnregisterCallback(self.modTable, "OnNamePlateDataUpdated");
	end
	self.PlaterMod.Enabled = false;
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
	requiredDeps = { { PlaterAddonName, "external" } },
	hotReload = true,
	onInit = function() return TRP3_PlaterNamePlates:OnModuleInitialize(); end,
	onStart = function() return TRP3_PlaterNamePlates:OnModuleEnable(); end,
	onDisable = function() return TRP3_PlaterNamePlates:OnModuleDisable(); end,
});

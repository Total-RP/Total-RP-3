--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Unit testing, module testing
-- This is Telkostrasz's test file, don't touch it ! ;)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local globals = TRP3_GLOBALS;
assert(globals, "Unable to find TRP3.");

local Utils = TRP3_UTILS;
local Log = Utils.log;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- DEBUG
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function TRP3_TEST()
	print(string.format('%x %x %x', 255, 125, 12));
end

function TRP3_DEBUG_CLEAR()
	TRP3_Profiles = nil;
	TRP3_ProfileLinks = nil;
	TRP3_Flyway = nil;
	TRP3_Register = nil;
	ReloadUI();
end

local function onInit()
	Log.log("onInit test module");
end

local function onLoaded()
	Log.log("onLoaded test module");
	
--	Utils.event.registerHandler("UPDATE_MOUSEOVER_UNIT", function()
--		if UnitIsPlayer("mouseover") then
--			TRP3_RegisterAddCharacter(UnitName("mouseover"))
--		end
--	end);

-- TRP2 fix coloredname
--	local old = ChatFrame_OnEvent;
--	local chat_onEvent = function( self, event, ... )
--		-- arg2 = personnage
--		-- arg3 = langue
--		local texte, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16 = ...;
--		local Affiche=1;
--		
--		if event=="CHAT_MSG_SAY" or event=="CHAT_MSG_PARTY" or event=="CHAT_MSG_RAID" or event=="CHAT_MSG_GUILD" or event=="CHAT_MSG_YELL"
--		or event=="CHAT_MSG_PARTY_LEADER" or event=="CHAT_MSG_RAID_LEADER" or event=="CHAT_MSG_OFFICER" or event=="CHAT_MSG_EMOTE"
--		or event=="CHAT_MSG_TEXT_EMOTE" or event=="CHAT_MSG_WHISPER" or event=="CHAT_MSG_WHISPER_INFORM" then
--			print(Ambiguate(arg2, "none"));
--			print(Ambiguate(arg2, "mail"));
--			print(Ambiguate(arg2, "guild"));
--			print(Ambiguate(arg2, "all"));
--		end
--		
--		old(self, event, ...);
--	end
--	ChatFrame_OnEvent = chat_onEvent;

end

local MODULE_STRUCTURE = {
	["module_name"] = "Unit testing",
	["module_version"] = 1.000,
	["module_id"] = "unit_testing",
	["onInit"] = onInit,
	["onLoaded"] = onLoaded,
	["min_version"] = 0.1,
	["requiredDeps"] = {
		{"dyn_locale", 1},
--		{"test", 0.57}
	}
};

TRP3_RegisterModule(MODULE_STRUCTURE);


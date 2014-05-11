--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3
-- Effects list
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local assert, type, tostring, error, tonumber, pairs, unpack, wipe = assert, type, tostring, error, tonumber, pairs, unpack, wipe;

local EFFECTS = {
	["text"] = {
		codeReplacement= "print(\"%s\");",
		args = 1,
		env = {
			print = "print",
		}
	},
}

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

TRP3_SCRIPTS.registerEffect = function(effect)
	assert(type(effect) == "table" and effect.id, "Effect must have an id.");
	assert(not EFFECTS[effect.id], "Already registered effect id: " .. effect.id);
	EFFECTS[effect.id] = effect;
end

TRP3_SCRIPTS.getEffect = function(effectID)
	return EFFECTS[effectID];
end
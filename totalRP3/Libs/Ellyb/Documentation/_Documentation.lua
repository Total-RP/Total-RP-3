---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Documentation then
	return
end

local Documentation = {};

local documentedAPIs = {};

function Documentation:AddDocumentationTable(APIName, documentedAPI)

	-- Ignore documentation that already exists
	if documentedAPIs[APIName] then
		return false
	end

	-- Since I always forget to add the other type of fields, we make them optional in our API declarations
	-- and automatically add them here :P
	if not documentedAPI.Events then
		documentedAPI.Events = {};
	end
	if not documentedAPI.Tables then
		documentedAPI.Tables = {};
	end
	if not documentedAPI.Functions then
		documentedAPI.Functions = {};
	end

	documentedAPIs[APIName] = documentedAPI;

	if IsAddOnLoaded("Blizzard_APIDocumentation") then
		APIDocumentation:AddDocumentationTable(documentedAPI);
	end
end

function Documentation:APIDocumentationExists(APIName)
	return documentedAPIs[APIName] ~= nil;
end

Ellyb.GameEvents.registerCallback("ADDON_LOADED", function(addOnName)
	if addOnName == "Blizzard_APIDocumentation" then
		for _, documentedAPI in pairs(documentedAPIs) do
			APIDocumentation:AddDocumentationTable(documentedAPI);
		end
	end
end)

Ellyb.Documentation = Documentation;

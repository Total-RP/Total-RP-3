-- This should be converted to an [AllowLoadGameType ...] directive when supported
-- on all clients.
--
-- While the collections journal wasn't introduced until Mists, it was added
-- into Cataclysm and then Wrath (CN) as part of Classic.

if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_WRATH_OF_THE_LICH_KING then
	return;
end

local cachedSummonedMountID = nil;
local staticCompanionPetsByID = {};
local staticCompanionPetsByCreatureID = {};
local staticCompanionPetsBySpellID = {};
local staticMountsByID = {};

function TRP3_CompanionUtil.CanRenameCompanionPets()
	return false;
end

function TRP3_CompanionUtil.GetCompanionPetIDs()
	return GetKeysArray(staticCompanionPetsByID);
end

function TRP3_CompanionUtil.GetCompanionPetInfo(petID)
	local staticPetInfo = staticCompanionPetsByID[petID];

	if not staticPetInfo then
		return;
	end

	return {
		id = staticPetInfo.petID,
		name = staticPetInfo.name,
		customName = nil,
		icon = staticPetInfo.icon,
		description = "",
		speciesName = staticPetInfo.name,
		isCollected = nil,  -- Indeterminate; would require a bag and bank scan.
	};
end

function TRP3_CompanionUtil.IsCompanionPetUnit(unitToken)
	if UnitPlayerControlled(unitToken) then
		local unitGUID = UnitGUID(unitToken);
		local guidType, _, _, _, _, creatureID = string.split("-", unitGUID or "", 7);
		local staticPetInfo = staticCompanionPetsByCreatureID[creatureID];

		return guidType == "Creature" and staticPetInfo ~= nil;
	else
		return false;
	end
end

function TRP3_CompanionUtil.GetCompanionPetUnitName(unitToken)
	-- In Classic flavors using static data rather than the pet journal, we
	-- can't localize the summoned name of creatures ahead of time.
	--
	-- Instead, query the creature ID of the unit and map that back to a name.

	local unitGUID = UnitGUID(unitToken);
	local creatureID = tonumber((select(6, string.split("-", unitGUID or "", 7))));
	local staticPetInfo = staticCompanionPetsByCreatureID[creatureID];

	if staticPetInfo then
		return staticPetInfo.name;
	end
end


function TRP3_CompanionUtil.GetSummonedCompanionPetID()
	if TRP3_Companions then
		return TRP3_Companions.summonedPetID;
	end
end

function TRP3_CompanionUtil.GetMountIDs()
	return GetKeysArray(staticMountsByID);
end

function TRP3_CompanionUtil.GetMountInfo(mountID)
	local staticMountInfo = staticMountsByID[mountID];

	if not staticMountInfo then
		return;
	end

	return {
		id = staticMountInfo.mountID,
		name = staticMountInfo.name,
		icon = staticMountInfo.icon,
		description = "",
		isCollected = nil,  -- Indeterminate; would require a bag and bank scan.
		spellID = staticMountInfo.spellID,
	};
end

function TRP3_CompanionUtil.GetMountSpellID(mountID)
	local staticMountInfo = staticMountsByID[mountID];

	if staticMountInfo then
		return staticMountInfo.spellID;
	end
end

local function GetUnitAuraSpells(unitToken, filter)
	-- Inner 'select' here is to skip the leading 'continuationToken' return.
	local auraSlots = { select(2, C_UnitAuras.GetAuraSlots(unitToken, filter)) };
	local appliedAuras = {};

	for slotIndex = 1, #auraSlots do
		local auraInfo = C_UnitAuras.GetAuraDataBySlot(unitToken, auraSlots[slotIndex]);

		if auraInfo then
			appliedAuras[auraInfo.spellId] = true;
		end
	end

	return appliedAuras;
end

function TRP3_CompanionUtil.GetSummonedMountID()
	if not IsMounted() then
		return nil;
	end

	-- Is the last mount that we tested still the current summon?
	if cachedSummonedMountID ~= nil then
		local spellID = TRP3_CompanionUtil.GetMountSpellID(cachedSummonedMountID);

		if not C_UnitAuras.GetPlayerAuraBySpellID(spellID) then
			cachedSummonedMountID = nil;
		end
	end

	-- Has our cache been invalidated? If so, detect from applied auras.
	if cachedSummonedMountID == nil then
		local appliedAuras = GetUnitAuraSpells("player", "HELPFUL|PLAYER|CANCELABLE");

		for _, mountID in ipairs(TRP3_CompanionUtil.GetMountIDs()) do
			local spellID = TRP3_CompanionUtil.GetMountSpellID(mountID);

			if appliedAuras[spellID] then
				cachedSummonedMountID = mountID;
				break;
			end
		end
	end

	return cachedSummonedMountID;
end

-- On clients that don't have a pet or mount journal, we statically embed
-- a database with just enough data to allow us to build our own fake version
-- of the journals in-game.
--
-- This static data doesn't include localized strings, and needs to be
-- filtered based on what's actually available in the client. To do this we
-- need to do some sparse loads for item and spell data prior to registering
-- the companion.

local CompanionDataLoaderMixin = {};

function CompanionDataLoaderMixin:OnLoad()
	self.pendingSpells = {};
	self.pendingItems = {};

	self:RegisterEvent("ITEM_DATA_LOAD_RESULT");
	self:RegisterEvent("SPELL_DATA_LOAD_RESULT");
end

function CompanionDataLoaderMixin:AddLoadCallback(callbackTable, recordID, callbackFunction)
	local callbacks = callbackTable[recordID];

	if not callbacks then
		callbacks = {};
		callbackTable[recordID] = callbacks;
	end

	table.insert(callbacks, callbackFunction);
end

function CompanionDataLoaderMixin:InvokeLoadCallbacks(callbackTable, recordID, ...)
	local callbacks = callbackTable[recordID];
	callbackTable[recordID] = nil;

	for _, callbackFunction in ipairs(callbacks) do
		securecallfunction(callbackFunction, recordID, ...);
	end
end

function CompanionDataLoaderMixin:RequestLoadItemData(itemID, callbackFunction)
	self:AddLoadCallback(self.pendingItems, itemID, callbackFunction);
	C_Item.RequestLoadItemDataByID(itemID);
end

function CompanionDataLoaderMixin:RequestLoadSpellData(spellID, callbackFunction)
	self:AddLoadCallback(self.pendingSpells, spellID, callbackFunction);
	C_Spell.RequestLoadSpellData(spellID);
end

function CompanionDataLoaderMixin:OnEvent(event, ...)
	if event == "ITEM_DATA_LOAD_RESULT" then
		local itemID, success = ...;
		self:InvokeLoadCallbacks(self.pendingItems, itemID, success);
	elseif event == "SPELL_DATA_LOAD_RESULT" then
		local spellID, success = ...;
		self:InvokeLoadCallbacks(self.pendingSpells, spellID, success);
	end
end

local CompanionDataLoader = CreateFrame("Frame")
FrameUtil.SpecializeFrameWithMixins(CompanionDataLoader, CompanionDataLoaderMixin);

local function RegisterCompanionPet(petInfo)
	staticCompanionPetsByID[petInfo.id] = petInfo;
	staticCompanionPetsByCreatureID[petInfo.creatureID] = petInfo;
	staticCompanionPetsBySpellID[petInfo.spellID] = petInfo;
end

local function RegisterCompanionMount(mountInfo)
	staticMountsByID[mountInfo.mountID] = mountInfo;
end

do
	for _, petInfo in ipairs(TRP3_CompanionPetData) do
		local function OnPetItemLoaded(itemID, success)
			if not success then
				return;
			end

			petInfo = CreateFromMixins(petInfo);
			petInfo.id = tostring(petInfo.speciesID);
			petInfo.name = C_Item.GetItemNameByID(itemID);
			petInfo.icon = C_Item.GetItemIconByID(itemID);

			RegisterCompanionPet(petInfo);
		end

		CompanionDataLoader:RequestLoadItemData(petInfo.itemID, OnPetItemLoaded);
	end

	local playerFaction = UnitFactionGroup("player");

	for _, mountInfo in ipairs(TRP3_CompanionMountData) do
		local function OnMountSpellLoaded(spellID, success)
			if not success then
				return;
			end

			mountInfo = CreateFromMixins(mountInfo);
			mountInfo.name = C_Spell.GetSpellName(spellID);
			mountInfo.icon = C_Spell.GetSpellTexture(spellID);

			RegisterCompanionMount(mountInfo);
		end

		-- Only load mounts relevant for the player faction.
		if mountInfo.factionGroup == nil or mountInfo.factionGroup == playerFaction then
			CompanionDataLoader:RequestLoadSpellData(mountInfo.spellID, OnMountSpellLoaded);
		end
	end
end

-- On client flavors without a pet journal we need to be creative with how we
-- determine what companion pet is actually summoned.
--
-- Our approach is to monitor for successful spellcasts whose spell IDs
-- are associated with that of a known companion pet. We assume that the
-- last successful cast will represent the current battle pet.
--
-- Note that we can't tell when a companion pet is dismissed, so our query
-- data will always contain the data for the last-successful cast even if
-- that cast dismissed the pet. Realistically this should be fine since
-- if it's dismissed other players can't see the unit to request the data
-- anyway.
--
-- For persistence across UI reloads we store the summoned pet data in our
-- saved variables, and reset it upon initial login of a new character.

local CompanionPetSummonListenerMixin = {};

function CompanionPetSummonListenerMixin:OnLoad()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function CompanionPetSummonListenerMixin:OnEvent(event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		self:OnUnitSpellcastSucceeded();
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:OnPlayerEnteringWorld(...);
	end
end

function CompanionPetSummonListenerMixin:OnUnitSpellcastSucceeded(_, castGUID)
	local spellID = tonumber((select(6, string.split("-", castGUID, 7))));
	local staticPetInfo = staticCompanionPetsBySpellID[spellID];

	if staticPetInfo then
		self:SetSummonedPetID(staticPetInfo.id);
	end
end

function CompanionPetSummonListenerMixin:OnPlayerEnteringWorld(isInitialLogin)
	-- Pets don't remain summoned across logins, so clear any old state.

	if isInitialLogin then
		self:SetSummonedPetID(nil);
	end
end

function CompanionPetSummonListenerMixin:SetSummonedPetID(petID)
	-- The summoned pet ID is stored in saved variables to allow it to persist
	-- across UI reloads.

	if TRP3_Companions then
		TRP3_Companions.summonedPetID = petID;
	end
end

FrameUtil.SpecializeFrameWithMixins(CreateFrame("Frame"), CompanionPetSummonListenerMixin);

-- Copyright The Total RP 3 Authors
-- SPDX-License-Identifier: Apache-2.0

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

local function RegisterCompanionPet(petInfo)
	staticCompanionPetsByID[petInfo.petID] = petInfo;
	staticCompanionPetsByCreatureID[petInfo.creatureID] = petInfo;
	staticCompanionPetsBySpellID[petInfo.spellID] = petInfo;
end

local function RegisterCompanionMount(mountInfo)
	staticMountsByID[mountInfo.mountID] = mountInfo;
end

local function SetSummonedCompanionPetID(petID)
	-- The summoned pet ID is stored in saved variables to allow it to persist
	-- across UI reloads.

	if not TRP3_Companions then
		TRP3_Companions = {};
	end

	TRP3_Companions.summonedPetID = petID;
end

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

local CompanionStateDriverMixin = {};

function CompanionStateDriverMixin:OnLoad()
	self.pendingSpells = {};
	self.pendingItems = {};

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
end

function CompanionStateDriverMixin:OnEvent(event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		self:OnUnitSpellcastSucceeded(...);
	elseif event == "ITEM_DATA_LOAD_RESULT" then
		self:OnItemDataLoadResult(...);
	elseif event == "SPELL_DATA_LOAD_RESULT" then
		self:OnSpellDataLoadResult(...);
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:OnPlayerEnteringWorld(...);
	end
end

function CompanionStateDriverMixin:OnPlayerEnteringWorld(isInitialLogin)
	-- Pets don't remain summoned across logins, so clear any old state.
	if isInitialLogin then
		SetSummonedCompanionPetID(nil);
	end
end

function CompanionStateDriverMixin:OnItemDataLoadResult(itemID, success)
	self:InvokeDataLoadCallbacks(self.pendingItems, itemID, success);
end

function CompanionStateDriverMixin:OnSpellDataLoadResult(spellID, success)
	self:InvokeDataLoadCallbacks(self.pendingSpells, spellID, success);
end

function CompanionStateDriverMixin:OnUnitSpellcastSucceeded(_, castGUID)
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

	local spellID = tonumber((select(6, string.split("-", castGUID, 7))));
	local staticPetInfo = staticCompanionPetsBySpellID[spellID];

	if staticPetInfo then
		SetSummonedCompanionPetID(staticPetInfo.petID);
	end
end

function CompanionStateDriverMixin:AddDataLoadCallback(registry, recordID, callbackFunction)
	local callbacks = registry[recordID];

	if not callbacks then
		callbacks = {};
		registry[recordID] = callbacks;
	end

	table.insert(callbacks, callbackFunction);
end

function CompanionStateDriverMixin:InvokeDataLoadCallbacks(registry, recordID, ...)
	local callbacks = registry[recordID];
	registry[recordID] = nil;

	if callbacks then
		for _, callbackFunction in ipairs(callbacks) do
			securecallfunction(callbackFunction, recordID, ...);
		end
	end
end

function CompanionStateDriverMixin:HasPendingDataLoadCallbacks(registry)
	return (next(registry) ~= nil);
end

function CompanionStateDriverMixin:RequestLoadItemData(itemID, callbackFunction)
	self:AddDataLoadCallback(self.pendingItems, itemID, callbackFunction);
	self:UpdateEventRegistrations();

	-- This call can synchronously fire the event, so we need to sequence it
	-- after updating event registrations.
	C_Item.RequestLoadItemDataByID(itemID);
end

function CompanionStateDriverMixin:RequestLoadSpellData(spellID, callbackFunction)
	self:AddDataLoadCallback(self.pendingSpells, spellID, callbackFunction);
	self:UpdateEventRegistrations();

	-- This call can synchronously fire the event, so we need to sequence it
	-- after updating event registrations.
	C_Spell.RequestLoadSpellData(spellID);
end

function CompanionStateDriverMixin:SetEventRegistered(eventName, registered)
	if registered then
		self:RegisterEvent(eventName);
	else
		self:UnregisterEvent(eventName);
	end
end

function CompanionStateDriverMixin:UpdateEventRegistrations()
	self:SetEventRegistered("ITEM_DATA_LOAD_RESULT", self:HasPendingDataLoadCallbacks(self.pendingItems));
	self:SetEventRegistered("SPELL_DATA_LOAD_RESULT", self:HasPendingDataLoadCallbacks(self.pendingSpells));
end

local CompanionStateDriver = CreateFrame("Frame");
FrameUtil.SpecializeFrameWithMixins(CompanionStateDriver, CompanionStateDriverMixin);

do
	for _, petInfo in ipairs(TRP3_CompanionPetData) do
		local function OnPetItemLoaded(itemID, success)
			if not success then
				return;
			end

			petInfo = CreateFromMixins(petInfo);
			petInfo.petID = tostring(petInfo.speciesID);
			petInfo.name = C_Item.GetItemNameByID(itemID);
			petInfo.icon = C_Item.GetItemIconByID(itemID);

			RegisterCompanionPet(petInfo);
		end

		CompanionStateDriver:RequestLoadItemData(petInfo.itemID, OnPetItemLoaded);
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
			CompanionStateDriver:RequestLoadSpellData(mountInfo.spellID, OnMountSpellLoaded);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onLoaded()

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Imports
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- API
	local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
	local tostring, _G, pairs, type, tinsert = tostring, _G, pairs, type, tinsert;
	local tsize, loc = Utils.table.size, TRP3_API.locale.getText;
	local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
	local setTooltipForSameFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
	local originalGetTargetType, getCompanionFullID = TRP3_API.ui.misc.getTargetType, TRP3_API.ui.misc.getCompanionFullID;
	local getUnitID, unitIDToInfo, companionIDToInfo = Utils.str.getUnitID, Utils.str.unitIDToInfo, Utils.str.companionIDToInfo;
	local get, getDataDefault = TRP3_API.profile.getData, TRP3_API.profile.getDataDefault;
	local hasProfile, isUnitIDKnown, getUnitIDCurrentProfile = TRP3_API.register.hasProfile, TRP3_API.register.isUnitIDKnown, TRP3_API.register.getUnitIDCurrentProfile;
	local getCompanionProfile, getCompanionRegisterProfile = TRP3_API.companions.player.getCompanionProfile, TRP3_API.companions.register.getCompanionProfile;
	local companionHasProfile, setCompanionGlanceSlotPreset = TRP3_API.companions.register.companionHasProfile, TRP3_API.companions.player.setGlanceSlotPreset;
	local getMiscPresetDropListData, setGlanceSlotPreset = TRP3_API.register.ui.getMiscPresetDropListData, TRP3_API.register.player.setGlanceSlotPreset;
	local getConfigValue, registerConfigKey, registerConfigHandler, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.registerHandler, TRP3_API.configuration.setValue;

	-- CONSTANTS
	local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
	local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
	local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
	local EMPTY = Globals.empty;

	-- UI
	local ui_GlanceBar = TRP3_GlanceBar;

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Logic
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local currentTargetID, currentTargetType, isCurrentMine = nil, nil, nil;

	local function getCharacterInfo()
		if currentTargetID == Globals.player_id then
			return get("player") or EMPTY;
		elseif isUnitIDKnown(currentTargetID) and hasProfile(currentTargetID) then
			return getUnitIDCurrentProfile(currentTargetID) or EMPTY;
		end
		return EMPTY;
	end

	local function getCompanionInfo(owner, companionID, currentTargetID)
		local profile;
		if owner == Globals.player_id then
			profile = getCompanionProfile(companionID) or EMPTY;
		else
			profile = getCompanionRegisterProfile(currentTargetID);
		end
		return profile;
	end

	local function atLeastOneactivePeek(tab)
		for i, info in pairs(tab) do
			if type(info) == "table" and info.AC then
				return true;
			end
		end
		return false;
	end

	local function getTargetType()
		return originalGetTargetType("target");
	end

	local function onPeekSelection(value, button)
		if value then
			if currentTargetType == TYPE_CHARACTER then
				setGlanceSlotPreset(button.slot, value);
			else
				setCompanionGlanceSlotPreset(button.slot, value, currentTargetID);
			end
		end
	end

	local function onPeekClickMine(button)
		displayDropDown(button, getMiscPresetDropListData(), function(value) onPeekSelection(value, button) end, 0, true);
	end

	local function displayPeekSlots()
		ui_GlanceBar:Hide();
		local peekTab = nil;

		if currentTargetType == TYPE_CHARACTER then
			peekTab = getDataDefault("misc/PE", EMPTY, getCharacterInfo());
		elseif currentTargetType == TYPE_BATTLE_PET or currentTargetType == TYPE_PET then
			local owner, companionID = companionIDToInfo(currentTargetID);
			peekTab = getCompanionInfo(owner, companionID, currentTargetID).PE;
		end

		if (isCurrentMine and peekTab ~= nil) or (not isCurrentMine and peekTab ~= nil and atLeastOneactivePeek(peekTab)) then
			ui_GlanceBar:Show();
			for i=1,5,1 do
				local slot = _G["TRP3_GlanceBarSlot"..i];
				local peek = peekTab[tostring(i)];

				local icon = Globals.icons.default;

				if peek and peek.AC then
					slot:SetAlpha(1);
					if peek.IC and peek.IC:len() > 0 then
						icon = peek.IC;
					end
					setTooltipForSameFrame(slot, "LEFT", 0, 0, Utils.str.icon(icon, 30) .. " " .. (peek.TI or "..."), peek.TX);
				else
					slot:SetAlpha(0.25);
					setTooltipForSameFrame(slot);
				end

				Utils.texture.applyRoundTexture("TRP3_GlanceBarSlot"..i.."Image", "Interface\\ICONS\\" .. icon);

				if isCurrentMine then
					slot:SetScript("OnClick", onPeekClickMine);
				else
					slot:SetScript("OnClick", nil);
				end
			end
		end
	end

	local function onTargetChanged()
		currentTargetType, isCurrentMine = getTargetType();
		if currentTargetType == TYPE_CHARACTER then
			currentTargetID = getUnitID("target");
		else
			currentTargetID = getCompanionFullID("target", currentTargetType);
		end
		displayPeekSlots();
	end

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Config - Position
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	local UIParent, GetCursorPosition, TargetFrame = UIParent, GetCursorPosition, TargetFrame;

	local CONFIG_GLANCE_PARENT = "CONFIG_GLANCE_PARENT";
	local CONFIG_GLANCE_LOCK = "CONFIG_GLANCE_LOCK";
	local CONFIG_GLANCE_ANCHOR_X = "CONFIG_GLANCE_ANCHOR_X";
	local CONFIG_GLANCE_ANCHOR_Y = "CONFIG_GLANCE_ANCHOR_Y";

	local function getParentFrame()
		return _G[getConfigValue(CONFIG_GLANCE_PARENT)] or TargetFrame;
	end

	local function replaceBar()
		local parentFrame = getParentFrame();
		local parentScale = UIParent:GetEffectiveScale();
		ui_GlanceBar:SetParent(parentFrame);
		ui_GlanceBar:ClearAllPoints();
		ui_GlanceBar:SetPoint("BOTTOMLEFT", parentFrame, "BOTTOMLEFT", getConfigValue(CONFIG_GLANCE_ANCHOR_X) / parentScale, getConfigValue(CONFIG_GLANCE_ANCHOR_Y) / parentScale);
	end

	local function resetPosition()
		setConfigValue(CONFIG_GLANCE_ANCHOR_X, 0);
		setConfigValue(CONFIG_GLANCE_ANCHOR_Y, 0);
		replaceBar();
	end

	-- Function called when the minimap icon is dragged
	local function glanceBar_DraggingFrame_OnUpdate(self)
		if not getConfigValue(CONFIG_GLANCE_LOCK) and self.isDraging then
			local parentFrame = getParentFrame();
			local scaleFactor = UIParent:GetEffectiveScale();
			local xpos, ypos = GetCursorPosition();
			local xmin, ymin = parentFrame:GetLeft(), parentFrame:GetBottom();

			xpos = xpos - xmin * scaleFactor;
			ypos = ypos - ymin * scaleFactor;

			-- Setting the minimap coordinates
			setConfigValue(CONFIG_GLANCE_ANCHOR_X, xpos);
			setConfigValue(CONFIG_GLANCE_ANCHOR_Y, ypos);

			replaceBar();
		end
	end

	registerConfigKey(CONFIG_GLANCE_PARENT, "TRP3_TargetFrame");
	registerConfigKey(CONFIG_GLANCE_ANCHOR_X, 24);
	registerConfigKey(CONFIG_GLANCE_ANCHOR_Y, -14);
	registerConfigKey(CONFIG_GLANCE_LOCK, true);
	registerConfigHandler({CONFIG_GLANCE_PARENT}, replaceBar);
	replaceBar();
	ui_GlanceBar:SetScript("OnUpdate", glanceBar_DraggingFrame_OnUpdate);

	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc("CO_GLANCE_MAIN"),
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigEditBox",
		title = loc("CO_MINIMAP_BUTTON_FRAME"),
		configKey = CONFIG_GLANCE_PARENT,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigCheck",
		title = loc("CO_GLANCE_LOCK"),
		help = loc("CO_GLANCE_LOCK_TT"),
		configKey = CONFIG_GLANCE_LOCK,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigButton",
		title = loc("CO_MINIMAP_BUTTON_RESET"),
		help = loc("CO_GLANCE_RESET_TT"),
		text = loc("CO_MINIMAP_BUTTON_RESET_BUTTON"),
		callback = resetPosition,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigButton",
		title = loc("CO_GLANCE_PRESET_TRP2"),
		text = loc("CO_GLANCE_PRESET_TRP2_BUTTON"),
		help = loc("CO_GLANCE_PRESET_TRP2_HELP"),
		callback = function()
			setConfigValue(CONFIG_GLANCE_PARENT, "TargetFrame");
			setConfigValue(CONFIG_GLANCE_ANCHOR_X, 161);
			setConfigValue(CONFIG_GLANCE_ANCHOR_Y, 31);
			replaceBar();
		end,
	});
	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigButton",
		title = loc("CO_GLANCE_PRESET_TRP3"),
		text = loc("CO_GLANCE_PRESET_TRP2_BUTTON"),
		help = loc("CO_GLANCE_PRESET_TRP3_HELP"),
		callback = function()
			setConfigValue(CONFIG_GLANCE_PARENT, "TRP3_TargetFrame");
			setConfigValue(CONFIG_GLANCE_ANCHOR_X, 24);
			setConfigValue(CONFIG_GLANCE_ANCHOR_Y, -14);
			replaceBar();
		end,
	});

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Init
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	Utils.event.registerHandler("PLAYER_TARGET_CHANGED", onTargetChanged);
	Events.listenToEvents({Events.TARGET_SHOULD_REFRESH, Events.REGISTER_MISC_SAVED, Events.REGISTER_DATA_CHANGED}, onTargetChanged);

	for i=1,5,1 do
		local slot = _G["TRP3_GlanceBarSlot"..i];
		slot.slot = tostring(i);
	end
end

local MODULE_STRUCTURE = {
	["name"] = "\"At first glance\" bar",
	["description"] = "Add a bar showing the content of the target's \"At first glance\".",
	["version"] = 1.000,
	["id"] = "trp3_glance_bar",
	["onLoaded"] = onLoaded,
	["minVersion"] = 3,
};

TRP3_API.module.registerModule(MODULE_STRUCTURE);
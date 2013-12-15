--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Total RP 3, by Telkostrasz (Kirin Tor - Eu/Fr)
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Messaging
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MESSAGE_PREFIX = "[|cffffaa00TRP3|r] ";

local function getChatFrame()
	return DEFAULT_CHAT_FRAME;
end

-- MessageType 1 : ChatFrame (given by chatFrameIndex or default if nil)
-- MessageType 2 : Alert popup
-- MessageType 3 : On screen alert (Raid notice frame)
function TRP3_DisplayMessage(message, chatFrameIndex, noPrefix, messageType)
	if not messageType or messageType == 1 then
		chatFrame = _G["ChatFrame"..tostring(chatFrameIndex)] or getChatFrame();
		if noPrefix then
			chatFrame:AddMessage(message,1,1,1);
		else
			chatFrame:AddMessage(MESSAGE_PREFIX..message,1,1,1);
		end
	elseif messageType == 2 then
		TRP3_ShowAlertPopup(message);
	elseif messageType == 3 then
		RaidNotice_AddMessage(RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"]);
	end
end
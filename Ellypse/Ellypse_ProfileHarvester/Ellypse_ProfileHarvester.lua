local stop = false;
local speed = 10;
SLASH_EPH1 = '/eph';

local print = print;
local after = C_Timer.After;
local UnitFullName = UnitFullName;
local tinsert, pairs = tinsert, pairs;
local GetChannelDisplayInfo = GetChannelDisplayInfo;
local GetChannelRosterInfo = GetChannelRosterInfo;

local function handler(msg)

	if not msg or msg == "" then
		print("Parameter required for EPH :\n/eph harvest for havesting\n/eph stop to stop harvesting.");
	end

	if msg == "harvest" then
		stop = false;
		local people = {};
		local numberOfPeopleOnChan;
		local chanelID;
		for id =0, 15 do
			local name, something, somethingElse, anotherThing, numberOfPeople = GetChannelDisplayInfo(id);
			if name == "xtensionxtooltip2" then
				print("Harvesting "..numberOfPeople.." people");
				numberOfPeopleOnChan = numberOfPeople;
				chanelID = id;
			end
		end
		if not numberOfPeopleOnChan then
			print("Channel not loaded, please open channel frame.")
		end
		local name, realm = UnitFullName("player");
		for i=1, numberOfPeopleOnChan do
			local name, something, somethingElse, anotherThing, oneMoreThing, oneLastThing = GetChannelRosterInfo(chanelID, i);
			if not name:find('-') then
				name = name.."-"..realm;
			end
			tinsert(people, name);
		end
		local i = 0;
		for k, name in pairs(people) do
			local index = i + 1;
			after(i/speed, function()
				if stop then
					return
				end
				print("Sending request to "..name.." ("..index.."/"..numberOfPeopleOnChan..")");
				TRP3_API.r.sendMSPQuery(name);
				TRP3_API.r.sendQuery(name);
			end);
			i = i + 1;
		end
	elseif msg == "stop" then
		print("Harvesting stoped");
		stop = true;
	end
end
SlashCmdList["EPH"] = handler;
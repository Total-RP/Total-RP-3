--[[
	Copyright 2021 Total RP 3 Development Team

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
]]--

local AddOn_TotalRP3 = AddOn_TotalRP3;

AddOn_TotalRP3.MSP = AddOn_TotalRP3.MSP or {};

AddOn_TotalRP3.MSP.RequestType = TRP3_MSPRequestType;

function AddOn_TotalRP3.MSP.IsMSPAddOn()
	return msp_RPAddOn == TRP3_MSPAddOnID;
end

function AddOn_TotalRP3.MSP.RequestCharacterProfile(characterName, requestType, options)
	if type(characterName) ~= "string" then
		error("RequestCharacterProfile: 'characterName' must be a string");
	elseif type(requestType) ~= "number" then
		error("RequestCharacterProfile: 'requestType' must be a number");
	elseif options ~= nil and type(options) ~= "table" then
		error("RequestCharacterProfile: 'options' must be a table or nil");
	elseif options ~= nil and options.skipProbe and type(options.skipProbe) ~= "boolean" then
		error("RequestCharacterProfile: 'options.skipProbe' must be a boolean or nil");
	end

	return TRP3_MSP:SendRequest(characterName, requestType, options);
end

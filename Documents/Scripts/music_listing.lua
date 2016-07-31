local globalMusicVariables = {
	"BEST_MUSIC",
	"LEGION_MUSIC",
	"DRAENOR_MUSIC",
	"OTHER_MUSIC"
}

function GenerateMusics()

	local ourMusics = {};
	local addedMusics = {};

	for _, musicName in pairs(musicList) do
		ourMusics[musicName] = true;
	end

	local generatedMusics = {}
	for _, variableName in pairs(globalMusicVariables) do
		for _, musicObject in pairs(_G[variableName]) do
			local musicName = musicObject["Name"];
			musicName = musicName:gsub("Sound\\music\\", "")
			musicName = musicName:gsub("Sound\\Music\\", "")
			musicName = musicName:gsub("sound\\music\\", "")
			musicName = musicName:gsub("sound\\Music\\", "")
			musicName = musicName:gsub(".mp3", "")

			if not ourMusics[musicName] then
				ourMusics[musicName] = true;
				tinsert(addedMusics, musicName);
			end
		end
	end

	local rebuiltMusics = {};

	for musicName, _ in pairs(ourMusics) do
		tinsert(rebuiltMusics, musicName)
	end

	table.sort(rebuiltMusics);

	TRP3_StashedData = rebuiltMusics;
	TRP3_Flyway = addedMusics;
end
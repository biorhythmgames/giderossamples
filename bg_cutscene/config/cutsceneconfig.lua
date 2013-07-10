-- Module: Cutscenes Config
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Cutscene configuration & helper functions
--

local cutscenes = {
	require('config.cutscenes.first_cutscene'),
	require('config.cutscenes.second_cutscene'),
}

local T = {}

T._NAME = "cutsceneconfig"

T.getCutscene = function(index)	
		return cutscenes[index]
	end

T.getNextCutsceneId = function(currentIndex)
		local nextIndex = currentIndex + 1

		if nextIndex > #cutscenes then
			nextIndex = 1
		end
		
		return nextIndex
	end

return T
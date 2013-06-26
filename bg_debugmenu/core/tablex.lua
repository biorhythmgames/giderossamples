-- Module: TableX - (Lite version)
-- Date: 26/06/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Info: Table extension library
--

-- optimisation
local _pairs = pairs

local T = {}

T._NAME = 'tablex'

T.clear = function(table)
	for k, v in _pairs(table) do
		table[k] = nil	
	end
	return table
end

T.count = function(t)
	local count = 0
	for _,v in _pairs(t) do
		count = count + 1
	end
	return count
end

return T
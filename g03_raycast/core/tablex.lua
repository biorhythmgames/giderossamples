-- Module: TableX
-- Date: 01/04/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Info: Table extension library
--

-- optimisation
local _pairs = pairs
local _ipairs = ipairs


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

T.icount = function(t)
	local i = 0
	for _, v in _ipairs(t) do
		i = i + 1
	end
	return i
end	

return T
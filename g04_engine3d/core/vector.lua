-- Module: Common vector functions
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
--

local sqrt = math.sqrt

local Vector = {}

Vector._NAME = 'vector'

Vector.add3 = function(v1, v2)
	return {
		x = v1.x + v2.x,
		y = v1.y + v2.y,
		z = v1.z + v2.z,
	}
end

Vector.subtract3 = function(v1, v2)
	return {
		x = v2.x - v1.x,
		y = v2.y - v1.y,
		z = v2.z - v1.z,
	}
end

Vector.cross3 = function(v1, v2)
	return {
		x = (v1.y * v2.z) - (v1.z * v2.y),
		y = (v1.z * v2.x) - (v1.x * v2.z),
		z = (v1.x * v2.y) - (v1.y * v2.x),
	}
end

Vector.normalise3 = function(v)
	local length = sqrt((v.x * v.x) + (v.y * v.y) + (v.z * v.z))
	return {
		x = v.x / length,
		y = v.y / length,
		z = v.z / length,
	}
end

Vector.faceZNormal3 = function(poly)
	local a = (poly[1].y - poly[3].y)
	local b = (poly[2].x - poly[1].x)
	local c = (poly[1].x - poly[3].x)
	local d = (poly[2].y - poly[1].y)
	
	return (a * b) - (c * d)
end

return Vector
-- Class: Shape3D
-- SDK: Gideros - 2012.09.1
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: A single 3D object that can be rotated and translated in 3d space

local vector = require('core.vector')

-- optimisation
local _tinsert = table.insert


Shape3d = Core.class()

function Shape3d:init(params)
	self.rotatedVertList = {}
	self.rotatedFaceNormals = {}
	self.sortedPolys = {}
	self.rotationAngles = {
		x = 0,
		y = 0, 
		z = 0,
	}
	self.axisOffsets = {
		x = 0,
		y = 0,
		z = 0,
	}


	local polyList = params.polyList
	local vertList = params.vertList

	-- face normals
	local faceNormals = {}
	for i, polyInfo in ipairs(polyList) do
		local polyVerts = polyInfo.verts
		local vert1 = vertList[polyVerts[1]]
		local vert2 = vertList[polyVerts[2]]
		local vert3 = vertList[polyVerts[3]]
		local vert4 = vertList[polyVerts[4]]
		
		local vect1 = vector.subtract3(vert2, vert1)
		local vect2 = vector.subtract3(vert3, vert1)
		local vect3 = vector.cross3(vect1, vect2)

		local normal = vector.normalise3(vect3)

		_tinsert(faceNormals, normal)
	end	
	
	local rotationAngles = self.rotationAngles
	rotationAngles.x = params.xang or 0
	rotationAngles.y = params.yang or 0
	rotationAngles.z = params.zang or 0
	
	local axisOffsets = self.axisOffsets	
	axisOffsets.x = params.xoffset or 0
	axisOffsets.y = params.yoffset or 0
	axisOffsets.z = params.zoffset or 0
	
	self.vertList = vertList
	self.polyList = polyList	
	self.faceNormals = faceNormals
end

function Shape3d:getRotationAngle(axis)
	local rotationAngles = self.rotationAngles
	return rotationAngles[axis]
end

function Shape3d:updateRotationAngle(axis, step)
	local rotationAngles = self.rotationAngles
	local old = rotationAngles[axis]
	local new = old + step
	if new > 360 then 
		new = new - 360
	end
	
	rotationAngles[axis] = new
end

function Shape3d:resetRotation()
	local rotationAngles = self.rotationAngles
	for k,v in pairs(rotationAngles) do
		rotationAngles[k] = 0
	end
end

function Shape3d:getRotation()
	return self.rotationAngles
end

function Shape3d:getVertList()
	return self.vertList
end

function Shape3d:getFaceNormals()
	return self.faceNormals
end

function Shape3d:getPolyList()
	return self.polyList
end

function Shape3d:setRotatedVertList(verts)
	self.rotatedVerts = verts
end

function Shape3d:setRotatedFaceNormals(normals)
	self.rotatedFaceNormals = normals
end

function Shape3d:setSortedPolyList(polys)
	self.sortedPolys = polys
end

function Shape3d:getSortedPolyList()
	return self.sortedPolys
end

function Shape3d:getRotatedVertList()
	return self.rotatedVerts
end

function Shape3d:getRotatedFaceNormals()
	return self.rotatedFaceNormals
end

function Shape3d:getAxisOffset(axis)
	return self.axisOffsets[axis]
end

-- Class: (3D) Engine
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: 3D Engine handles rotation and sorting of points and polys

local tablex = require('core.tablex')

local cos = math.cos
local sin = math.sin
local rad = math.rad
local floor = math.floor
local _pairs = pairs
local _ipairs = ipairs
local tablesort = table.sort


Engine = Core.class()

function Engine:init(params)
	local sinTable = {}
	local cosTable = {}
	for i = 0, 360 do 
		sinTable[i] = sin(rad(i))
		cosTable[i] = cos(rad(i))
	end

	self.sinTable = sinTable
	self.cosTable = cosTable
	self.objectList = {}
end

function Engine:registerObject(params)
	local id = params.id
	local object = params.object
	local rotationSequence = params.rotationSequence
	
	self.objectList[id] = {
					object = object,
					rotationSequence = rotationSequence,
				}
end

function Engine:getObject(id)
	local objectList = self.objectList
	local info = objectList[id]

	return info and info.object
end

function Engine:update(dt, time)
	local objectList = self.objectList

	for _, objectInfo in _pairs(objectList) do
		local object = objectInfo.object
		local rotationSequence = objectInfo.rotationSequence

		-- rotate points
		local vertList = object:getVertList()
		local rotation = object:getRotation()
		local rotatedVertList = self:rotateVertList(vertList, rotation, rotationSequence)
		
		-- rotate face normals
		local faceNormals = object:getFaceNormals()
		local rotatedNormals = self:rotateVertList(faceNormals, rotation, rotationSequence)
		
		-- sort polys
		local polyList = object:getPolyList()
		local sortedPolys = self:sortPolys(polyList, rotatedVertList, rotatedNormals)

		-- update object
		object:setRotatedVertList(rotatedVertList)
		object:setRotatedFaceNormals(rotatedNormals)
		object:setSortedPolyList(sortedPolys)
		
		-- update axis rotation of the object
		for _, rotInfo in _pairs(rotationSequence) do
			local axis = rotInfo.axis
			local angleStep = rotInfo.angleStep
			
			object:updateRotationAngle(axis, angleStep)
		end
	end
end

function Engine:rotateVertList(vertList, rotation, rotationSequence)
	local sinTable = self.sinTable
	local cosTable = self.cosTable
	
	local output = {}
	
	for i, vertSource in _ipairs(vertList) do
		local vert = {
			x = vertSource.x,
			y = vertSource.y,
			z = vertSource.z,
		}

		for _, rotInfo in _ipairs(rotationSequence) do
			local axis = rotInfo.axis
			local angle = floor(rotation[axis])
			
			if axis == 'x' then
				local yt = cosTable[angle] * vert.y - sinTable[angle] * vert.z 
				local zt = sinTable[angle] * vert.y + cosTable[angle] * vert.z
				vert.y = yt
				vert.z = zt
			end
		
			if axis == 'y' then
				local xt = cosTable[angle] * vert.x - sinTable[angle] * vert.z
				local zt = sinTable[angle] * vert.x + cosTable[angle] * vert.z
				vert.x = xt
				vert.z = zt
			end
			
			if axis == 'z' then
				local xt = cosTable[angle] * vert.x - sinTable[angle] * vert.y
				local yt = sinTable[angle] * vert.x + cosTable[angle] * vert.y
				vert.x = xt
				vert.y = yt
			end
		end
		
		output[i] = vert
	end

	return output
end

function Engine:sortPolys(polyList, vertList, normalList)
	local output = {}
	
	for i, polyInfo in _ipairs(polyList) do
		local polyVerts = polyInfo.verts
		local faceZ = 0
		for _, vindex in _ipairs(polyVerts) do
			faceZ = faceZ + vertList[vindex].z
		end
		
		output[i] = {
				id = polyInfo.id,
				verts = polyVerts,
				normal = normalList[i],
				z = faceZ,
			}
	end
	
	tablesort(output, function(a, b) return a.z < b.z end)
	
	return output
end	

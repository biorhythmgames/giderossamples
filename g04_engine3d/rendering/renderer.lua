-- Class: 3D Object Renderer
-- SDK: Gideros - 2012.09.1
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: Renders a 3D object to screen using various methods

local vector = require('core.vector')

local _floor = math.floor
local _ipairs = ipairs
local _faceZNormal3 = vector.faceZNormal3

local MaxPolys = 6
local MaxVerts = 8
local MaxLines = 12

local faceColours = {
	0xff0000,
	0x00ff00,
	0x0000ff,
	0xff00ff,
	0xffff00,
	0x00ffff,
}


Renderer = Core.class(Sprite)

function Renderer:init(params)
	-- used for vertex only rendering
	local vertGroup = Sprite.new()
	local vertObjects = {}

	for i = 1, MaxVerts do
		local vert = BoxShape.new {
			left = 0, 
			top = 0, 
			width = 4, 
			height = 4,
			strokeWidth = 0,
			strokeColour = 0x000000, 
			fillColour = 0xeeeeee,
			parent = vertGroup,
		}

		vertObjects[i] =  vert
	end

	stage:addChild(vertGroup)
	vertGroup:setVisible(false)

	-- used for various poly render modes
	local polyGroup = Sprite.new()		
	local polys = {}

	for i = 1, MaxPolys do
		local poly = Shape.new()
		polys[i] = poly
		polyGroup:addChild(poly)
	end

	stage:addChild(polyGroup)
	polyGroup:setVisible(false)

	-- used for wireframe render mode
	local wireGroup = Sprite.new()
	local wireLines = {}

	for i = 1, MaxLines do
		local line = Shape.new()
		wireLines[i] = line
		wireGroup:addChild(line)
	end

	stage:addChild(wireGroup)
	wireGroup:setVisible(false)

	self.polys = polys
	self.polyGroup = polyGroup
	self.wireGroup = wireGroup
	self.wireLines = wireLines
	self.vertObjects = vertObjects
	self.vertGroup = vertGroup
end

function Renderer:setRenderMode(mode)
	self.renderMode = mode
	
	local polyFillModes = {
		['flat'] = true,
		['glenz'] = true,
		['light'] = true,
	}

	-- reset poly lines
	local polyGroup = self.polyGroup
	polyGroup:setVisible(polyFillModes[mode])
	
	-- reset vert objects
	local vertGroup = self.vertGroup
	vertGroup:setVisible(mode == 'vert')

	-- reset wire objects
	local wireGroup = self.wireGroup
	wireGroup:setVisible(mode == 'wire')
end

function Renderer:renderObject(params)
	local mode = self.renderMode

	if mode == 'wire' then	
		self:renderObjectWireframe(params)
	elseif mode == 'vert' then
		self:renderObjectVerts(params)
	else
		self:renderObjectPolys(params)
	end
end

function Renderer:renderObjectPolys(params)
	local polys = self.polys

	local object = params.object
	local useLightMap = params.lightMap
	local lightVector = params.lightVector
	local alpha = params.polyAlpha

	for _, p in _ipairs(polys) do
		p:setVisible(false)
		p:setColorTransform(1, 1, 1)
	end


	local renderPolys = self:buildRenderPolys(params)

	for faceIndex, facePoly in _ipairs(renderPolys) do
		local vertList = facePoly.vertList
		local vertCount = #vertList

		local poly = polys[faceIndex]
		poly:setVisible(true)
		poly:clear()
		poly:setLineStyle(0, 0xffffff)
		poly:setFillStyle(Shape.SOLID, faceColours[facePoly.colourIndex])
		poly:beginPath()
		poly:moveTo(vertList[1].x, vertList[1].y)
		poly:setAlpha(alpha)

		for i = 2, vertCount do
			poly:lineTo(vertList[i].x, vertList[i].y)
		end

		if useLightMap then
			local normal = facePoly.normal
			local nx = normal.x * lightVector.x
			local ny = normal.y * lightVector.y
			local nz = normal.z * lightVector.z
			local lightFactor = nx + ny + nz

			poly:setColorTransform(lightFactor, lightFactor, lightFactor)
		end

		poly:endPath()
	end
end

function Renderer:buildRenderPolys(params)
	local object = params.object
	local faceColours = params.faceColours
	local removeHiddenSurface = params.removeHiddenSurface

	local polyList = object:getSortedPolyList()
	local vertList = object:getRotatedVertList()
	local faceNormals = object:getRotatedFaceNormals()

	local xoffset = object:getAxisOffset('x')
	local yoffset = object:getAxisOffset('y')
	local zoffset = object:getAxisOffset('z')
	
	local renderPolys = {}
	for _, poly in _ipairs(polyList) do
		local transformedVerts = {}
		local polyVerts = poly.verts

		for i, vertIndex in _ipairs(polyVerts) do
			local vert = vertList[vertIndex]
			local z = vert.z + zoffset
			local x = _floor((256 * vert.x / z) + xoffset)
			local y = _floor((256 * vert.y / z) + yoffset)
			
			transformedVerts[i] = {
								x = x,
								y = y,
								z = z,
							}
		end

		local isVisible = true		
		if removeHiddenSurface then
			local faceNormal = _faceZNormal3(transformedVerts)
	    	isVisible = faceNormal > 0
	    end

	    if isVisible then
	    	renderPolys[#renderPolys + 1] = { 
	    			vertList = transformedVerts, 
	    			colourIndex = poly.id, 
	    			normal = poly.normal,
	    		}
	  	end
	end
	
	return renderPolys
end

function Renderer:renderObjectWireframe(params)
	local displayGroup = self.displayGroup
	local wireLines = self.wireLines

	local renderPolys = self:buildRenderPolys(params)

	for _, l in _ipairs(wireLines) do
		l:setVisible(false)
	end

	for i, v in _ipairs(renderPolys) do
		local vertList = v.vertList
		local vertCount = #vertList

		local line = wireLines[i]
		line:clear()
		line:setVisible(true)
		line:setLineStyle(1, 0xffffff)
		line:setFillStyle(Shape.NONE)
		line:beginPath()
		line:moveTo(vertList[1].x, vertList[1].y)

		for j = 2, vertCount do
			line:lineTo(vertList[j].x, vertList[j].y)	
		end

		line:closePath()
		line:endPath()
	end
end

function Renderer:renderObjectVerts(params)
	local vertObjects = self.vertObjects

	local object = params.object

	local xoffset = object:getAxisOffset('x')
	local yoffset = object:getAxisOffset('y')
	local zoffset = object:getAxisOffset('z')

	local rotatedVerts = object:getRotatedVertList()
	
	for i, vert in _ipairs(rotatedVerts) do
		local z = vert.z + zoffset
		local zClipped = z >= 0
		local renderObject = vertObjects[i]
		renderObject:setAlpha(zClipped and 0 or 1)
		
		if not zClipped then
			local x = _floor(256 * vert.x / z) + xoffset
			local y = _floor(256 * vert.y / z) + yoffset
			renderObject:setPosition(x, y)
		end
	end	
end

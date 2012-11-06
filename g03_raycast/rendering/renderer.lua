-- Class: Renderer
-- SDK: Gideros 2012.09.1
-- Date: 22/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: Render a single frame from the raycasting engine
--

-- optimisation
local min = math.min
local floor = math.floor

-- constants
local ShadeDistanceMax = 600
local ShadeConst = 1 / ShadeDistanceMax
local CellSize = 64


Renderer = Core.class()

function Renderer:init(params)	
	local displayGroup = params.displayGroup
	
	local displayWidth = params.displayWidth
	local columnWidth = params.columnWidth
	local horizon = params.horizon

	local texture = Texture.new('assets/textures.png', false)

	-- create a texture region for each slice
	local textureRegions = {}
	local renderSlices = {}
	for i = 0, 255 do
		textureRegions[i + 1] = TextureRegion.new(texture, i, 0, 1, CellSize)
	end

	-- create a display slices per vertical screen slice
	for i = 1, displayWidth do 
		renderSlices[i] = Bitmap.new(textureRegions[1])
		renderSlices[i]:setPosition(i - 1, horizon)

		displayGroup:addChild(renderSlices[i])
	end

	self.textureRegions = textureRegions
	self.renderSlices = renderSlices	
end

function Renderer:renderScene(params)
	self:renderTexture(params)
end

function Renderer:renderTexture(params)
	local displayGroup = params.displayGroup
	local horizon = params.horizon
	local sceneInfo = params.sceneInfo

	local renderSlices = self.renderSlices
	local textureRegions = self.textureRegions

	local sliceCount = sceneInfo.sliceCount
	local wallInfoList = sceneInfo.wallInfoList

	for i = 1, sliceCount do
		local sliceInfo = wallInfoList[i]
		local sliceHeight = sliceInfo.sliceHeight
		local halfSliceHeight = floor(sliceHeight * 0.5)

		local wallId = sliceInfo.wallId
		local tr = textureRegions[((wallId - 1) * CellSize) + sliceInfo.offset]
		local slice = renderSlices[i]
		slice:setTextureRegion(tr)
		slice:set('y', horizon - halfSliceHeight)
		slice:setScaleY(sliceHeight / CellSize)

		local distance = sliceInfo.distance
		local shadeFactor = 1 - (min(distance, ShadeDistanceMax) * ShadeConst)
		slice:setColorTransform(shadeFactor, shadeFactor, shadeFactor)
	end	
end

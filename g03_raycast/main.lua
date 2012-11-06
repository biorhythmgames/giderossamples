-- Project: Raycasting Engine Demo
-- SDK: Gideros 2012.09.1
-- Author: Andrew Burch
-- Date: 22/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: Ported from my Corona Raycast engine

local map = require('config.map')

-- setup orientation
application:setOrientation(Application.LANDSCAPE_LEFT)

-- setup background
application:setBackgroundColor(0x1414c8)

-- setup floor
local contentTop = 0
local contentWidth = application:getContentWidth()
local contentHeight = application:getContentHeight()
local horizon = contentTop + math.floor(contentHeight * 0.5)

local floor = BoxShape.new {
	left = 0, 
	top = horizon, 
	width = contentWidth, 
	height = contentHeight,
	strokeWidth = 0,
	strokeColour = 0x000000, 
	fillColour = 0x646464,
	parent = stage,
}

--initialise camera
local mapCellSize = 64
local halfCellSize = mapCellSize * 0.5
local startingColumn = 2
local startingRow = 2
local startX = (startingColumn * mapCellSize) + halfCellSize
local startY = (startingRow * mapCellSize) + halfCellSize

local cameraInfo = {
	eyeLevel = halfCellSize,
	viewAngle = 0,
	xpos = startX,
	ypos = startY,
	mapX = startingColumn,
	mapY = startingRow,	
}

-- initialise the engine
local maxRayDepth = 2

local engine = RaycastEngine.new {
			visibleWidth = contentWidth,
			visibleHeight = contentHeight,
			mapRowCount = map.rowCount,
			mapColumnCount = map.columnCount,
			mapCellSize = mapCellSize,
			fov = 60,
			maxRayDepth = maxRayDepth,
			commonAngleList = {
				0, 30, 45, 90, 
				180, 270, 330, 360,
			},
		}

-- initialise rendering system
local renderingSystem = Renderer.new {
			displayGroup = stage,
			displayWidth = contentWidth,
			displayHeight = contentHeight,
			horizon = horizon,
			columnWidth = 1,
		}
					
-- initialise input system
local inputSystem = InputSystem.new {
			buttonWidth = 48,
			buttonHeight = 48,
			displayWidth = contentWidth,
			sideBorder = 20,
			turnAcceleration = 1.8,
			movementAcceleration = 0.9,
		}
		
inputSystem:registerWithParent(stage)



-- movement variables
local maxTurnSpeed = 22.5
local maxMovementSpeed = 5.5
local turnDeccelerateFactor = 0.72
local moveDeccelerateFactor = 0.78


-- register main update listener
stage:addEventListener(Event.ENTER_FRAME, function(event)
									local dt = event.deltaTime
									local time = event.time

									inputSystem:update(dt, time, {
														maxTurnSpeed = maxTurnSpeed,
														maxMovementSpeed = maxMovementSpeed,
														turnDeccelerateFactor = turnDeccelerateFactor,	
														moveDeccelerateFactor = moveDeccelerateFactor,	
													})
									
									local movementSpeed = inputSystem:getMovementSpeed()
									local turnSpeed = inputSystem:getTurnSpeed()
									
									engine:updateCameraPosition { 
														cameraInfo = cameraInfo,
														movementSpeed = movementSpeed,
														turnSpeed = turnSpeed,
														worldMap = map.mapData,
													}
													
									local sceneInfo = engine:processFrame(dt, time, {
														xpos = cameraInfo.xpos,
														ypos = cameraInfo.ypos,
														viewAngle = cameraInfo.viewAngle,
														worldMap = map.mapData,
														wallDefList = map.wallDefList,
														visibleWidth = contentWidth,
														maxRayDepth = maxRayDepth,
													})
									
									renderingSystem:renderScene { 
														displayGroup = stage,
														sceneInfo = sceneInfo,
														horizon = horizon,
													}
								end)

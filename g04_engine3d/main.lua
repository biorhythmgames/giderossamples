-- Project: 3D Object Demo
-- SDK: Gideros - 2012.09.1
-- Author: Andrew Burch
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: 3D Object Rendering Demo ported from my corona demo

local tablex = require('core.tablex')
local cubedata = require('data.cubedata')
local buttonconfig = require('config.buttonconfig')

-- setup background
application:setBackgroundColor(0x000000)

-- setup orientation
application:setOrientation(Application.LANDSCAPE_LEFT)

-- determine display size
local contentWidth = application:getContentWidth()
local contentHeight = application:getContentHeight()
local halfContentWidth = math.floor(contentWidth * 0.5)
local halfContentHeight = math.floor(contentHeight * 0.5)

-- initialise render system
local renderSystem = Renderer.new()

-- initialise 3d engine
local engine3d = Engine.new()

-- initiaise an object
local cubeId = 'cube'
local rotationSequence = cubedata.rotationSequence

local cube = Shape3d.new {
			vertList = cubedata.vertList,
			polyList = cubedata.polyList,
			xoffset = halfContentWidth,
			yoffset = halfContentHeight,
			zoffset = -64,
			zang = 0,
		}

engine3d:registerObject {
			id = cubeId, 
			object = cube, 
			rotationSequence = rotationSequence,
		}

renderSystem:setRenderMode('glenz')

local removeHiddenSurface = false
local lightMap = false
local polyAlpha = 0.5
local lightVector = {x = 0, y = 0, z = -1}


-- setup demo buttons
local demoButtons = buttonconfig.demoButtons
local buttonTop = buttonconfig.buttonTop
local buttonLeft = buttonconfig.buttonLeft
local buttonSpacing = buttonconfig.buttonSpacing

for i, v in ipairs(demoButtons) do
	local top = buttonTop + ((i - 1) * buttonSpacing)
	local button = Button.new {
				top = top,
				left = buttonLeft,
				width = buttonconfig.buttonWidth,
				height = buttonconfig.buttonHeight,
				strokeWidth = buttonconfig.strokeWidth,
				fontResource = buttonconfig.fontResource,
				fillColour = buttonconfig.fillColour,
				strokeColour = buttonconfig.strokeColour,
				textColour = buttonconfig.textColour,
				alpha = buttonconfig.buttonAlpha,
				parent = stage,
				text = v.text,
			}

	button:addEventListener(Event.MOUSE_DOWN, function(eventData, event)
				local consume = button:hitTestPoint(event.x, event.y)
				if not consume then
					return
				end

				local params = eventData.params
				local selectedMode = params.mode
				if renderMode == selectedMode then
					return
				end

				removeHiddenSurface = params.removeHiddenSurface
				lightMap = params.lightMap
				polyAlpha = params.polyAlpha
				
				renderSystem:setRenderMode(selectedMode)
			
				event:stopPropagation()
			end, v)
end


-- register main update listener
stage:addEventListener(Event.ENTER_FRAME, function(event)
									local dt = event.deltaTime
									local time = event.time

									engine3d:update(dt, time)
									
									renderSystem:renderObject {
													object = engine3d:getObject(cubeId),
													renderMode = renderMode,
													lightMap = lightMap,
													polyAlpha = polyAlpha,
													lightVector = lightVector,
													removeHiddenSurface = removeHiddenSurface,
													displayWidth = contentWidth,
													displayHeight = contentHeight,
												}
								end)

-- Class: Input Handler
-- SDK: Gideros - 2012.09.1
-- Date: 22/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: Process touch events to handle input for the camera
--

-- optimisation
local abs = math.abs
local max = math.max
local min = math.min
local _pairs = pairs
local _ipairs = ipairs


InputSystem = Core.class()

function InputSystem:init(params)
	local displayWidth = params.displayWidth
	local buttonWidth = params.buttonWidth
	local buttonHeight = params.buttonHeight
	local sideBorder = params.sideBorder
	local turnAcceleration = params.turnAcceleration
	local movementAcceleration = params.movementAcceleration

	local rightButtonSetX = displayWidth - sideBorder - buttonWidth
	
	local buttonConfig = {
		{
			x = sideBorder,
			y = 240,
			modifierName = 'turnAcceleration',
			modiferValue = -turnAcceleration,
			stateName = 'isTurning',
		},
		{
			x = 80,
			y = 240,
			modifierName = 'turnAcceleration',
			modiferValue = turnAcceleration,
			stateName = 'isTurning',
		},
		{
			x = rightButtonSetX,
			y = 200,
			modifierName = 'movementAcceleration',
			modiferValue = movementAcceleration,
			stateName = 'isMoving',
		},
		{
			x = rightButtonSetX,
			y = 260,
			modifierName = 'movementAcceleration',
			modiferValue = -movementAcceleration,
			stateName = 'isMoving',
		},
	}		
	
	local displayGroup = Sprite.new()

	for _, v in _ipairs(buttonConfig) do
		local button = Button.new {
					top = v.y,
					left = v.x,
					width = buttonWidth,
					height = buttonHeight,
					strokeWidth = 2,
					strokeColour = 0xb4b4b4,
					fillcolour = 0x8c8c8c,
					alpha = 0.4,
					parent = displayGroup,
				}

		local startInputFn = function(data, event)
							local touch = event.touch
							local consume = button:hitTestPoint(touch.x, touch.y)
							if not consume then
								return
							end

							local modifierName = data.modifierName
							local modiferValue = data.modiferValue
							local stateName = data.stateName
							
							button:setFocus(true)
							button:setTouchId(touch.id)

							self[modifierName] = modiferValue
							self[stateName] = true

							event:stopPropagation()
						end
		local cancelInputFn = function(data, event)
							if not button:getHasFocus() then
								return
							end
							
							local touch = event.touch
							if touch.id ~= button:getTouchId() then
								return
							end

							local modifierName = data.modifierName
							local modiferValue = data.modiferValue
							local stateName = data.stateName

							button:setFocus(nil)
							button:setTouchId(nil)
							
							self[modifierName] = nil
							self[stateName] = nil

							event:stopPropagation()
						end

		button:addEventListener(Event.TOUCHES_BEGIN, startInputFn, v)
		button:addEventListener(Event.TOUCHES_END, cancelInputFn, v)
		button:addEventListener(Event.TOUCHES_CANCEL, cancelInputFn, v)
	end
	
	self.displayGroup = displayGroup
	self.movementSpeed = 0
	self.turnSpeed = 0		
end

function InputSystem:update(dt, time, params)
	local isMoving = self.isMoving
	local movementSpeed = self.movementSpeed
	if isMoving then
		local movementAcceleration = self.movementAcceleration
		local maxMovementSpeed = params.maxMovementSpeed
		local newSpeed = movementSpeed + movementAcceleration
		newSpeed = max(min(newSpeed, maxMovementSpeed), -maxMovementSpeed)
		self.movementSpeed = newSpeed
	end
	
	if not isMoving and movementSpeed ~= 0 then
		local moveDeccelerateFactor = params.moveDeccelerateFactor
		local newSpeed = movementSpeed * moveDeccelerateFactor
		if abs(newSpeed) < 0.1 then
			newSpeed = 0
		end
		
		self.movementSpeed = newSpeed
	end

	local isTurning = self.isTurning
	local turnSpeed = self.turnSpeed
	if isTurning then
		local turnAcceleration = self.turnAcceleration
		local maxTurnSpeed = params.maxTurnSpeed
		local newSpeed = turnSpeed + turnAcceleration
		newSpeed = max(min(newSpeed, maxTurnSpeed), -maxTurnSpeed)
		self.turnSpeed = newSpeed
	end
	
	if not isTurning and turnSpeed ~= 0 then
		local turnDeccelerateFactor = params.turnDeccelerateFactor
		local newSpeed = turnSpeed * turnDeccelerateFactor
		if abs(newSpeed) < 0.1 then
			newSpeed = 0
		end
		self.turnSpeed = newSpeed
	end	
end

function InputSystem:registerWithParent(parent)
	parent:addChild(self.displayGroup)
end

function InputSystem:getTurnSpeed()
	return self.turnSpeed
end

function InputSystem:getMovementSpeed()
	return self.movementSpeed
end

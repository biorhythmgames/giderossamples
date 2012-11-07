-- Class: Button
-- SDK: Gideros - 2012.09.1
-- Date: 18/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Notes: Generic button with event support
--

-- optimisation
local _floor = math.floor
local _sformat = string.format


Button = Core.class(Sprite)

function Button:init(params)
	local width = params.width
	local height = params.height
	local top = params.top
	local left = params.left

	-- button background
	local background = Shape.new()
	background:setLineStyle(params.strokeWidth, params.strokeColour)
	background:setFillStyle(Shape.SOLID, params.fillColour)
	background:beginPath()
	background:moveTo(0, 0)
	background:lineTo(width, 0)
	background:lineTo(width, height)
	background:lineTo(0, height)
	background:closePath()
	background:endPath()

	self:addChild(background)

	-- button label
	if params.text then
		local fontText = _sformat('resources/%s.txt', params.fontResource)
		local fontImage = _sformat('resources/%s.png', params.fontResource)
		local font = Font.new(fontText, fontImage, true)
		local textField = TextField.new(font, params.text)
		local textX = _floor((width - textField:getWidth()) * 0.5)
		local textY = _floor(10 - 2 + ((height - textField:getHeight()) * 0.5))
		textField:setPosition(textX, textY)
		textField:setTextColor(params.textColour)

		self:addChild(textField)
	end

	self:setAlpha(params.alpha)
	self:setPosition(left, top)

	params.parent:addChild(self)
end

function Button:registerWithEventSystem(eventSystem, eventData)
	self:addEventListener(Event.MOUSE_DOWN, function(...) self:onMouseDown(eventSystem, ...) end, eventData)
end

function Button:onMouseDown(eventSystem, eventData, event)
	local consume = self:hitTestPoint(event.x, event.y)
	if not consume then
		return
	end

	eventSystem:addEvent(eventData)

	event:stopPropagation()
end

function Button:setFocus(state)
	self.hasFocus = state
end

function Button:getHasFocus()
	return self.hasFocus
end

function Button:setTouchId(id)
	self.touchId = id
end

function Button:getTouchId()
	return self.touchId
end
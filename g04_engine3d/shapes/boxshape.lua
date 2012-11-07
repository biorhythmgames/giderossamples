-- Class: BoxShape
-- SDK: Gideros - 2012.09.1
-- Date: 18/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Notes: Generic box shape
--

BoxShape = Core.class(Sprite)

function BoxShape:init(params)
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

	self:setPosition(left, top)

	params.parent:addChild(self)
end

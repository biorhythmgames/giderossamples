-- Class: LineShape
-- SDK: Gideros - 2012.09.1
-- Date: 29/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Notes: Generic line shape
--

LineShape = Core.class(Sprite)

function LineShape:init(params)
	local line = Shape.new()
	line:setLineStyle(params.strokeWidth, params.strokeColour)
	line:setFillStyle(Shape.NONE)
	line:beginPath()
	line:moveTo(0, 0)
	line:lineTo(params.x2, params.y2)
	line:closePath()
	line:endPath()

	self:addChild(line)

	self:setPosition(params.x, params.y)

	params.parent:addChild(self)
end

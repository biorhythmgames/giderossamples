-- Class: Line
-- Date: 10/07/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Generic line class

Line = Core.class(Sprite)

function Line:init(x1, y1, x2, y2, strokeWidth, strokeColour, alpha)
	local shape = Shape.new()
	shape:setLineStyle(strokeWidth, strokeColour)
	shape:setFillStyle(Shape.NONE)
	shape:beginPath()
	shape:moveTo(x1, y1)
	shape:lineTo(x2, y2)
	shape:closePath()
	shape:endPath()
	shape:setAlpha(alpha or 1)
	self:addChild(shape)
end

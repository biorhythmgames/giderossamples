-- Project: 3D Object Demo
-- Date: 29/10/2012
-- Site: http://www.biorythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: 3D object data

local Cube = {}

Cube._NAME = 'cubeData'

-- raw verts
Cube.vertList = {
	{x = -10, y = -10, z = 10},
	{x = 10, y = -10, z = 10},
	{x = 10, y = 10, z = 10},
	{x = -10, y = 10, z = 10},
	{x = -10, y = -10, z = -10},
	{x = 10, y = -10, z = -10},
	{x = 10, y = 10, z = -10},
	{x = -10, y = 10, z = -10},
}

-- object polygons (4 points)
Cube.polyList = {
	{
		id = 1, 		--front
		verts = {4, 3, 2, 1},
	},
	{
		id = 2, 		--back
		verts = {7, 8, 5, 6},
	},
	{
		id = 3, 		--top
		verts = {8, 7, 3, 4},
	},
	{
		id = 4, 		--base
		verts = {1, 2, 6, 5},
	},
	{
		id = 5,			--right
		verts = {8, 4, 1, 5},
	},
	{
		id = 6, 		--left
		verts = {2, 3, 7, 6},
	},
}

-- rotation sequence for the object
Cube.rotationSequence = {
	{
		axis = 'z',
		angleStep = 1.0,
	},
	{
		axis = 'x',
		angleStep = 2.5
	},
}

return Cube
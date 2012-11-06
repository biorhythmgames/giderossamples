-- Module: MapData
-- Project: Raycasting Engine Demo
-- Date: 22/10/2012
-- Site: http://www.biorhythmgames.com
-- Contact: andrew@biorhythmgames.com
-- Note: Map data and variables
--

local MapData = {}

MapData._NAME = 'mapData'
MapData.rowCount = 10
MapData.columnCount = 10

MapData.mapData = {
	{2,2,2,2,4,4,3,2,2,2},
	{2,0,0,2,0,0,0,0,0,2},
	{3,0,0,2,2,0,0,0,3,3},
	{3,0,0,4,0,0,0,0,0,2},
	{2,0,0,4,2,3,1,0,0,4},
	{2,0,0,0,2,0,0,0,0,3},
	{2,0,0,0,3,0,0,0,1,1},
	{2,4,0,0,0,0,0,0,0,3},
	{2,0,0,0,1,0,0,3,0,3},
	{2,2,2,1,1,1,2,2,2,2},
}

MapData.wallDefList = {
	{
		textureId = 'wall1',
		isSolid = true,
	},
	{
		textureId = 'wall2',
		isSolid = true,
	},
	{
		textureId = 'wall3',
		isSolid = true,
	},
	{
		textureId = 'wall4',
		isSolid = true,
	},
	{
		textureId = 'wall5',
		isSolid = true,
	},
}

return MapData
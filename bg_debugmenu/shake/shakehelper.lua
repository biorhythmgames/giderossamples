-- Module: Shake Helper
-- Date: 26/06/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Device shake support functions
--

local random = math.random

local T = {}

T._NAME = 'shakehelper'

T.updateShake = function(dt, params)
	local gamestate = params.gamestate
	local shakeInfo = gamestate.shakeInfo

	local shake = shakeInfo.shake

	if shake <= 0 then
		return
	end

	local shakeIntensity = shakeInfo.shakeIntensity
	local si = shakeIntensity
	local si2 = shakeIntensity * 0.5

	local shakeSi = shake * si
	local shakeSi2 = shake * si2
	
	local x = (random() * shakeSi) - shakeSi2
	local y = (random() * shakeSi) - shakeSi2
	
	params.scene:setPosition(x,y)

	shakeInfo.shake = shake - dt
end

return T
-- Class: Debug Menu
-- Date: 26/06/2013
-- Author: BiorhythmGames
-- Site: www.biorhythmgames.com
-- Notes: Allows real time debug interaction with game
--

local tablex = require('core.tablex')
local debugconfig = require('config.debugconfig')

-- optimsations
local tableinsert = table.insert
local tableclear = tablex.clear
local floor = math.floor

-- constants
local CommandTypes = debugconfig.CommandTypes
local CommandFuncs = debugconfig.CommandFunctions
local CommandList = debugconfig.CommandList
local CommandStateFuncs = debugconfig.CommandStateFuncs

local ButtonTypes = debugconfig.ButtonTypes

local BackColour = 0x111111
local BackgroundVerts = {
	0, 0, 
	780, 0, 
	780, 410, 
	0, 410,
}
local BackgroundPolys = {
	1, 2, 3, 
	3, 4, 1,
}
local BackgroundColours = {
	BackColour, 0.8, 
	BackColour, 0.8, 
	BackColour, 0.8, 
	BackColour, 0.8,	
}

local WindowVOffset = 45
local WindowHOffset = 20
local WindowWidth = 780 * 0.5
local LineHeight = 38
local ButtonWidth = 80
local ButtonHeight = 26
local ButtonYAdjust = 18

local SwitchTransforms = {
	[true] = {r = 0.4, g = 1, b = 0.4},
	[false] = {r = 1, g = 0.4, b = 0.4},
}
local ColourTransforms = {
	clicked = {r = 0.8, g = 0.8, b = 1},
	normal = {r = 1, g = 1, b = 1},
	disabled = {r = 0.4, g = 0.4, b = 0.4}
}

local States = {
	Hidden = 1,
	Visible = 2,
}


DebugMenu = Core.class(Sprite)

function DebugMenu:init(params)
	local font = params.font

	self.state = States.Visible
	self.pendingCommands = {}
	self.debugOptions = {}

	-- menu container
	local menuWindow = Sprite.new()
	menuWindow:addEventListener(Event.MOUSE_DOWN, function(event)
			if self.state == States.Hidden then
				return
			end

			-- consume touch within debug menu
			if menuWindow:hitTestPoint(event.x, event.y) then
				event:stopPropagation()
			end
		end)
	self:addChild(menuWindow)
	self.menuWindow = menuWindow

	-- background for active menu
	local contentWindow = Mesh.new()
	contentWindow:setVertexArray(BackgroundVerts)
	contentWindow:setIndexArray(BackgroundPolys)
	contentWindow:setColorArray(BackgroundColours)
	contentWindow:setPosition(10, 60)
	menuWindow:addChild(contentWindow)

	-- menu title
	local menuTitle = TextField.new(font, '-- DEBUG MENU --')
	local xpos = (contentWindow:getWidth() - menuTitle:getWidth()) * 0.5
	local ypos = 15
	menuTitle:setPosition(xpos, ypos)
	menuTitle:setTextColor(0xeeeeee)
	contentWindow:addChild(menuTitle)

	-- toggle button
	self:createActivateButton(font, params.showMenuToggle)

	-- register command buttons
	for _, command in ipairs(CommandList) do
		self:registerCommand(command, font, params, contentWindow)
	end

	-- hide until activated
	self:hide()
end

function DebugMenu:createActivateButton(font, showMenuToggle)
	local contentWidth = application:getContentWidth()

	local colour = showMenuToggle and 0x444444 or 0x000000
	local alpha = showMenuToggle and 0.7 or 0

	-- create menu toggle button
	local button = Mesh.new()
	button:setVertexArray(0, 0, 90, 0, 90, 50, 0, 50)
	button:setIndexArray(1, 2, 3, 3, 4, 1)
	button:setColorArray(colour, alpha, colour, alpha, colour, alpha, colour, alpha)
	button:setPosition(contentWidth * 0.5 - 45, 0)
	button:addEventListener(Event.MOUSE_DOWN, function(event)
			if button:hitTestPoint(event.x, event.y) then
				self:toggleState()
				event:stopPropagation()
			end
		end)

	-- create text label for toggle button
	if showMenuToggle then
		local text = TextField.new(font, "Debug Menu")
		local tx = (button:getWidth() * 0.5) - (text:getWidth() * 0.5)
		local ty = 14 + (button:getHeight() * 0.5) - (text:getHeight() * 0.5)
		text:setPosition(tx, ty)
		text:setTextColor(0xeeeeee)
		button:addChild(text)
	end

	self:addChild(button)	
end

function DebugMenu:hide()
	self.menuWindow:setVisible(false)
	self.state = States.Hidden
end

function DebugMenu:show()
	self.menuWindow:setVisible(true)
	self.state = States.Visible
end

function DebugMenu:toggleState()
	local state = self.state
	local newState = state == States.Hidden and States.Visible or States.Hidden
	self.switchState = newState
end

function DebugMenu:registerCommand(command, font, params, parent)
	local debugOptions = self.debugOptions
	local optionCount = #debugOptions

	local commandType = command.commandType

	-- determine sub window and line position
	local windowIndex = optionCount % 2
	local lineIndex = floor(optionCount / 2)

	-- option container
	local newOption = Sprite.new()

	-- create description text
	local text = TextField.new(font, command.description)
	local xpos = WindowHOffset + (WindowWidth * windowIndex)
	local ypos = WindowVOffset + (lineIndex * LineHeight)
	text:setPosition(xpos, ypos)
	text:setTextColor(0xdddddd)
	newOption:addChild(text)

	-- determine button position
	local windowBorder = WindowWidth * (windowIndex + 1)
	local buttonX = windowBorder - ButtonWidth - WindowHOffset
	local buttonY = ypos - ButtonYAdjust

	-- button text
	local buttonLabel = command.buttonText or ''
	local buttonText = TextField.new(font, buttonLabel)
	buttonText:setPosition(buttonX + 8, ypos)
	buttonText:setTextColor(0xeeeeee)

	-- create button
	local button = Shape.new()
	button:setLineStyle(1, 0xeeeeee)
	button:setFillStyle(Shape.SOLID, 0x666666)
	button:beginPath()
	button:moveTo(0, 0)
	button:lineTo(ButtonWidth, 0)
	button:lineTo(ButtonWidth, ButtonHeight)
	button:lineTo(0, ButtonHeight)
	button:closePath()
	button:endPath()
	button:setPosition(buttonX, buttonY)
	button:setAlpha(0.8)
	button.buttonType = command.buttonType

	button:addEventListener(Event.MOUSE_DOWN, function(event)
			-- ignore condition
			if self.state == States.Hidden or
					not button.state or
					not button:hitTestPoint(event.x, event.y) then
				return
			end

			local rgb = ColourTransforms.clicked

			-- show button pressed
			button:setColorTransform(rgb.r, rgb.g, rgb.b, 1)

			-- add the command to execute
			tableinsert(self.pendingCommands, {
					commandType = commandType,
					commandParams = command.params,
				})

			event:stopPropagation()			
		end)

	button:addEventListener(Event.MOUSE_UP, function(event)
			-- ignore conditions
			if self.state == States.Hidden or
					not button.state or 
					button.buttonType == ButtonTypes.Toggle or
					not button:hitTestPoint(event.x, event.y) then
				return
			end
			local rgb = button.state and ColourTransforms.normal or ColourTransforms.disabled
			button:setColorTransform(rgb.r, rgb.g, rgb.b, 1)
			event:stopPropagation()			
		end)

	button:addEventListener(Event.MOUSE_MOVE, function(event)
			-- ignore conditions
			if self.state == States.Hidden or
					(button.buttonType == ButtonTypes.Push and not button.state) or 
					button.buttonType == ButtonTypes.Toggle or
					not button:hitTestPoint(event.x, event.y) then
				return
			end
			local rgb = button.state and ColourTransforms.normal or ColourTransforms.disabled
			button:setColorTransform(rgb.r, rgb.g, rgb.b, 1)
			event:stopPropagation()			
		end)

	newOption:addChild(button)
	newOption:addChild(buttonText)

	parent:addChild(newOption)

	tableinsert(debugOptions, {
			button = button,
			buttonText = buttonText,
			command = command,
		})
end

function DebugMenu:updateButtonState(params)
	for _, option in ipairs(self.debugOptions) do
		local command = option.command
		local id = command.commandType
		local buttonState = CommandStateFuncs[id](params)

		local button = option.button

		local toggleButton = command.buttonType == ButtonTypes.Toggle

		-- refresh toggle state button colour & text
		if toggleButton then
			local toggleState = command.getToggleState(params)

			if button.toggleState ~= toggleState then
				option.buttonText:setText(toggleState and 'Enabled' or 'Disabled')

				button.toggleState = toggleState
			end
		end

		-- refresh colour
		local rgb = (toggleButton and buttonState) and SwitchTransforms[button.toggleState] or 
						buttonState and ColourTransforms.normal or 
						ColourTransforms.disabled

		button:setColorTransform(rgb.r, rgb.g, rgb.b, 1)

		button.state = buttonState
	end
end

function DebugMenu:update(dt, time, params)
	local switchState = self.switchState

	-- update display state
	if switchState then
		local activate = switchState == States.Visible

		if activate then
			self:show()
		else
			self:hide()
		end

		self.switchState = nil
	end

	-- bail out if not visible
	if self.state == States.Hidden then
		return
	end

	-- update button state
	self:updateButtonState(params)

	-- ignore an empty queue
	local pendingCommands = self.pendingCommands
	if #pendingCommands == 0 then
		return
	end

	-- execute queued debug commands
	for _, command in ipairs(pendingCommands) do
		CommandFuncs[command.commandType](dt, time, params, command.commandParams)
	end

	-- clear command table for next update
	tableclear(pendingCommands)
end
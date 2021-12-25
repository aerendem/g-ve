--debugger initializer
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

local game = require("logic/game")
require("logic/board")
local urutora = require("dependencies/urutora")
local draw = require('UI')
local stone = require("logic/stone")

function love.load()
	local startingGameState = 1 -- 1: start; 2: play; 3: gameover

	local field_size = 50
	field_lines = 9



	urutora = urutora:new()
	UI = draw.new(9,55)


	--input = input.New()

	board = board.New(3)

	game = game.New(startingGameState)
	
	

	--game:EndGame()

	love.window.setMode(field_size*10, field_size*10, resizable)

	local clickMe = urutora.button({
		text = 'Click to start!',
		x = 300, y = 300,
		w = 200,
	})

	clickMe:action(function(e)
		print("AAAAAAAAAAAAAA")
		game:StartGame()
		clickMe:deactivate()
	end)

	urutora:add(clickMe)

	function love.mousepressed(x, y, button) urutora:pressed(x, y) end
	function love.mousemoved(x, y, dx, dy) urutora:moved(x, y, dx, dy) end
	function love.mousereleased(x, y, button) urutora:released(x, y) end
	function love.textinput(text) urutora:textinput(text) end
	function love.wheelmoved(x, y) urutora:wheelmoved(x, y) end
end

function love.draw()
	urutora:draw()
	board:DrawBoard()
end

function love.update(dt)
	urutora:update(dt)
end

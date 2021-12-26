--debugger initializer
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

game = require("logic/game")
require("logic/board")
local urutora = require("dependencies/urutora")
local draw = require('UI')
local stone = require("logic/stone")
local input = require("input")

function love.load()
	local startingGameState = 1 -- 1: start; 2: play; 3: gameover

	local field_size = 50
	field_lines = 9

	urutora = urutora:new()
	UI = draw.new(9,55)

	input = input.New()
	input:BindInitialEvents(urutora)

	board = board.GetInstance(3)

	game = game.GetInstance(startingGameState)
	
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
end

function love.draw()
	urutora:draw()
	board:DrawBoard()
	game:ShowScores()
end

function love.update(dt)
	urutora:update(dt)

end

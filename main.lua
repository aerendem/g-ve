-------------------------
--Debugger Initializer
-------------------------
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

-------------------------
--Dependencies
-------------------------
game = require("logic/game")
require("logic/board")
urutora = require("dependencies/urutora")
local UI = require('UI')
local stone = require("logic/stone")
local input = require("input")

---Engine method, this function is called exactly once at the beginning of the game.
function love.load()
	local startingGameState = 1 -- 1: start; 2: play; 3: gameover

	--Sets board line, sizes
	local field_size = 50
	field_lines = 9

	--Initializes GUI Lib urutora
	urutora = urutora:new()

	--Initializes UI class
	UI = UI.new(9,55)

	--Initializes Input class and binds initial events to detect mouse inputs
	input = input.New()
	input:BindInitialEvents(urutora)

	--Gets board singleton
	board = board.GetInstance()

	--Gets game singleton
	game = game.GetInstance(startingGameState)
	
	--Sets window mode & size
	love.window.setMode(field_size*10, field_size*10, resizable)

	--Adds game starter button
	local clickMe = urutora.button({
		text = 'Click to start!',
		x = 150, y = 250,
		w = 200,
	})

	clickMe:action(function(e)
		game:StartGame()	
		clickMe:deactivate()
	end)

	urutora:add(clickMe)
end

---Engine method, callback function used to draw on the screen every frame
function love.draw()
	urutora:draw()
	board:DrawBoard()
	game:ShowScores()
	UI:Draw()
end

---Engine method, callback function used to update the state of the game every frame.
function love.update(dt)
	urutora:update(dt)
end

--debugger initializer
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

local game = require("logic/game")
local board = require("logic/board")
local urutora = require("dependencies/urutora")
local draw = require('UI')

function love.load()
  game_state = 1 -- 1: start; 2: play; 3: gameover

  field_size = 50
  field_lines = 9
  piece_rad = 25

  board = board.new(field_lines)
  board:drawBoard()

  game = game.new(game_state)
  game:startGame()

  love.window.setMode(field_size*10, field_size*10, resizable)

  love.graphics.setNewFont("fonts/BagnardSans.otf", 16)

  u = urutora:new()
     myDraw = draw.new(9,55)

	function love.mousepressed(x, y, button) u:pressed(x, y) end
	function love.mousemoved(x, y, dx, dy) u:moved(x, y, dx, dy) end
	function love.mousereleased(x, y, button) u:released(x, y) end
	function love.textinput(text) u:textinput(text) end
	function love.wheelmoved(x, y) u:wheelmoved(x, y) end

	function love.keypressed(k, scancode, isrepeat)
		u:keypressed(k, scancode, isrepeat)

		if k == 'escape' then
			love.event.quit()
		end
	end

	canvas = love.graphics.newCanvas(w, h)
	canvas:setFilter('nearest', 'nearest')
	local font1 = love.graphics.newFont('fonts/BagnardSans.otf', 16)
	local font2 = love.graphics.newFont('fonts/BagnardSans.otf', 16)

	u.setDefaultFont(font1)
	u.setResolution(canvas:getWidth(), canvas:getHeight())

	local clickMe = urutora.button({
		text = 'Click to start!',
		x = 300, y = 300,
		w = 200,
	})

	local num = 0
	clickMe:action(function(e)
		 num = num + 1
        myDraw:UpdateScores(num,num+1)
        readyToStart = true
	end)

	u:add(clickMe)
end

function love.draw()
	u:draw()

   if readyToStart == true then
    myDraw:DrawBoard()
    myDraw:Scores()
    myDraw:DrawPiece()
   end

end

function love.update(dt)
  u:update(dt)
end

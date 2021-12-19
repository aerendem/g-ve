--debugger initializer
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

local game = require("logic/game")
local board = require("logic/board")

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
end

function love.draw()
   
end

function love.update(dt)

end
 
function love.mousepressed(x, y, button, istouch)
   
end
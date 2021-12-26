input = {}
input.__index = input

require("love")
require("UI")
require("dependencies/urutora")
require("logic/game")
local stone = require("logic/stone")

function input.New()
   local self = setmetatable({}, input)

   self.__index = self
   
   return self
end

local function inCircle(cx, cy, radius, x, y)
    local dx = cx - x
    local dy = cy - y
    return dx * dx + dy * dy <= radius * radius
end

function input:BindInitialEvents(urutora)
    function love.keypressed(k, scancode, isrepeat)
        urutora:keypressed(k, scancode, isrepeat)
    
        if k == 'escape' then
            love.event.quit()
        end
    end
    
    function love.mousepressed(x, y, button) 
        urutora:pressed(x, y) 
        if game.state == 2 then
            for col = 1, 9 do 
                for row = 1, 9 do
                    if (x - 15 <=  (55 + ((col-1) * 53)) and  x + 15 >=  (55 + ((col-1) * 53)))  then
                        if (y - 15 <=  (55 + ((row-1) * 53)) and  y + 15 >=  (55 + ((row-1) * 53)))  then
                            print(row,col)
                            local newStone = stone.New(game.currentTurnOwner,row,col)
                            local game = game.GetInstance()
                            local board = board.GetInstance()
                            board:AddStoneToBoard(newStone)
                            game:PassTurn()
                         end
                     end
                end
            end
        end
    end

    function love.mousemoved(x, y, dx, dy) urutora:moved(x, y, dx, dy) end
    function love.mousereleased(x, y, button) urutora:released(x, y) end
    function love.textinput(text) urutora:textinput(text) end
    function love.wheelmoved(x, y) urutora:wheelmoved(x, y) end
end



return input
-------------------------
--Declaration
-------------------------
input = {}
input.__index = input

-------------------------
--Dependencies
-------------------------
require("love")
require("UI")
require("dependencies/urutora")
require("logic/game")
local stone = require("logic/stone")

-------------------------
--Constructor
-------------------------
function input.New()
   local self = setmetatable({}, input)
   self.__index = self
   
   return self
end

---Used to bind mouse pressed event for placing stone according to coordinates of mouse when it is pressed
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
                            local game = game.GetInstance()
                            local board = board.GetInstance()
                            local newStone = stone.New(game.currentTurnOwner,row,col)
                            local addedStone = board:AddStoneToBoard(newStone)

                            if addedStone == true then
                                game:PassTurn()
                            else
                                newStone:Destroy()
                            end
                            
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
player = {}
player.__index = player

require("love")

function player.New(name, color)
   local self = setmetatable({}, player)

   self.__index = self
   self.color = color
   self.score = 0
   self.name = name

    return self
end

function player:PrintColor() 
   love.graphics.print(self.color, 0, 0, 0, 5, 5) 
end

return player

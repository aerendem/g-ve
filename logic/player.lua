local player = {}
player.__index = player

require("love")

function player.new(color,name)
   local self = setmetatable({}, player)

   self.__index = self
   self.color = color
   self.name = name

   return self
end

function player:printColor()
   love.graphics.print(self.color,0,0,0,5,5)
end

return player
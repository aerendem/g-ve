player = {}
player.__index = player

require("love")

function player.New(name, color)
   local self = setmetatable({}, player)

   self.__index = self
   self.color = color
   self.score = 0
   self.name = name

   self.lastStonePlacedCoordinates = nil
   self.lastStoneGotEatenCoordinates = nil

   return self
end

return player

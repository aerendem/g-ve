-------------------------
--Declaration
-------------------------
player = {}
player.__index = player

-------------------------
--Dependencies
-------------------------
require("love")

-------------------------
--Constructor
-------------------------
function player.New(name, color)
   local self = setmetatable({}, player)
   self.__index = self

   --Color of stones
   self.color = color
   self.score = 0
   self.name = name

   --The coordinates that player has put their stone in last move
   self.lastStonePlacedCoordinates = nil

   --Coordinates of their last stone got eaten by other player
   self.lastStoneGotEatenCoordinates = nil

   return self
end

return player

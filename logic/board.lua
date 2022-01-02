-------------------------
--Declaration
-------------------------
board = {}
board.__index = board

-------------------------
--Dependencies
-------------------------
require("love")
require("UI")
require("dependencies/table")

--Singleton Instance
local instance

-------------------------
--Constructor
-------------------------
function board.New()
   local self = setmetatable({}, board)
   self.__index = self

   --A visibility property
   self.showBoard = false

   --Table to store all stones
   self.stones = {}

   return self
end

---Singleton Instance Getter
function board.GetInstance()
   if instance == nil then
      instance =  board.New()
   end

   return instance
end

---Used to get all the stones placed on the board
function board:GetStones()
   return self.stones
end

---To check if the desired position of new stone is suitable to fill
function board:CheckPositionForNewStone(newStoneCoordination)
   for _,v in ipairs(self.stones) do
      if v.coordinates:Compare(newStoneCoordination) == false then
         return false
      end
   end

   return true
end

---Used to check if new stone is alright to place
function board:AddStoneToBoard(stone)
   --Checking if any other stone in that exact position
   if self:CheckPositionForNewStone(stone.coordinates) == false then
      stone:Destroy()
      return false
   end

   --Checking if it's a suicidal act or recursiv
   if #stone.stoneGroup:FindLiberties() == 0 and 
   (stone.coordinates:Compare(stone.owner.lastStonePlacedCoordinates) == false or stone.coordinates:Compare(stone.owner.lastStoneGotEatenCoordinates) == false) then
      stone:Destroy()
      return false
   end


   --If stone does not exists, add it
   if table.find(self.stones, stone) == nil then
      stone.owner.lastStonePlacedCoordinates = stone.coordinates
      table.insert(self.stones, stone)

      return true
   end

   return false
end

---Remove stone from data table and visibility by that
function board:RemoveStoneFromBoard(stone)
   stone.owner.lastStoneGotEatenCoordinates = stone.coordinates
   table.remove(self.stones, table.find(self.stones, stone))
end

---To get if there is a stone in given coordinates
function board:GetSameCoordinateStone(coordinates)
   for _,v in ipairs(self.stones) do
      if coordinates:Compare(v.coordinates) == false then
         return v
     end
   end

   return false
end

---To run in every love.update() frame to draw the board
function board:DrawBoard()
   if self.showBoard == true then
      UI:DrawBoard()

      for i,v in ipairs(self.stones) do
         UI:DrawPiece(v.coordinates.row, v.coordinates.col, v.owner.color)
      end
   end
end

---Used at every end of turn before starting new turn to calculate surrounds and removals of stones
function board:UpdateBoard()
   local checkedGroups = {}
   local removedStoneCount = 0

   for _,v in ipairs(self.stones) do
      if table.find(checkedGroups, v.stoneGroup.id) == nil then
         local removed, latestRemovalCount = v.stoneGroup:CheckForCapture()

         table.insert(checkedGroups, v.stoneGroup.id)

         if removed == true then
            removedStoneCount = removedStoneCount + latestRemovalCount
         end
      end
   end

   checkedGroups = nil

   return removedStoneCount
end

--Cleans up board, using at the end of the game
function board:CleanBoard()
   table.clear(self.stones)
end

return board
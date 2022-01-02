-------------------------
--Declaration
-------------------------
board = {}
board.__index = board

-------------------------
--DEPENDENCIES
-------------------------
require("love")
require("UI")
require("dependencies/table")

local instance

function board.New(boardLines)
   local self = setmetatable({}, board)

   self.__index = self
   self.showBoard = false
   self.boardLines = boardLines
   self.stones = {}

   return self
end

function board.GetInstance(boardLines)
   if instance == nil then
      instance =  board.New(boardLines)
   end

   return instance
end

function board:GetStones()
   return self.stones
end

function board:CheckPositionForNewStone(newStoneCoordination)
   for _,v in ipairs(self.stones) do
      if v.coordinates:Compare(newStoneCoordination) == false then
         return false
      end
   end

   return true
end

function board:AddStoneToBoard(stone)
   --Checking if any other stone in that exact position
   if self:CheckPositionForNewStone(stone.coordinates) == false then
      stone:Destroy()
      return false
   end

   --Checking if it's a suicidal act
   if #stone.stoneGroup:FindLiberties() == 0 and 
   (stone.coordinates:Compare(stone.owner.lastStonePlacedCoordinates) == false or stone.coordinates:Compare(stone.owner.lastStoneGotEatenCoordinates) == false) then
      stone:Destroy()
      return false
   end


   if table.find(self.stones, stone) == nil then
      stone.owner.lastStonePlacedCoordinates = stone.coordinates

      table.insert(self.stones, stone)
      return true
   end

   return false
end

function board:RemoveStoneFromBoard(stone)
   stone.owner.lastStoneGotEatenCoordinates = stone.coordinates
   table.remove(self.stones, table.find(self.stones, stone))
end

function board:GetSameCoordinateStone(coordinates)
   for _,v in ipairs(self.stones) do
      if coordinates:Compare(v.coordinates) == false then
         return v
     end
   end

   return false
end

function board:DrawBoard()
   if self.showBoard == true then
      UI:DrawBoard()

      for i,v in ipairs(self.stones) do
         UI:DrawPiece(v.coordinates.row, v.coordinates.col, v.owner.color)
      end
   end
end

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

function board:CleanBoard()
   table.clear(self.stones)
end

return board
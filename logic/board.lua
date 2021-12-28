board = {}
board.__index = board

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
   if self:CheckPositionForNewStone(stone.coordinates) == false then
      stone:Destroy()
      return false
   end

   if table.find(self.stones, stone) == nil then
      table.insert(self.stones, stone)
      return true
   end

   return false
end

function board:RemoveStoneFromBoard(stone)
   print("SELF STONES")
   print(#self.stones)
   --table.find(self.stones, stone)
   table.remove(self.stones, table.find(self.stones, stone))
   --self.stones[table.find()] = nil
   print(#self.stones)
end

function board:DrawBoard()
   if self.showBoard == true then
      UI:DrawBoard()

      for i,v in ipairs(self.stones) do
         UI:DrawPiece(v.coordinates.row, v.coordinates.col, v.owner.color)
      end
   end
end

function board:Capture()
   --[[ foreach (Coord coord in capturedGroup.GetStones())
   {
       // Update the board and add the capture
       _gridStones[coord.Column, coord.Row] = State.None;
       _gridGroups[coord.Column, coord.Row] = 0;
       switch (color)
       {
           case State.Black:
               _capBlack++;
               break;
           case State.White:
               _capWhite++;
               break;
           case State.None:
               break;
           default:
               throw new ArgumentOutOfRangeException(nameof(color), color, null);
       }
       // Update all groups liberties/adjacent data
       foreach (Group g in _groups.Values)
       {
           g.RemoveStone(coord);
       }
   }
   // Remove the group from the board
   DeleteGroup(capturedGroup); ]]
end

function board:UpdateBoard()
   local checkedGroups = {}
   for _,v in ipairs(self.stones) do
      if table.find(checkedGroups, v.stoneGroup.id) == nil then
         v.stoneGroup:CheckForCapture()
         table.insert(checkedGroups, v.stoneGroup.id)
      end
   end

   checkedGroups = nil
end

function board:CleanBoard()
   table.clear(self.stones)
end

return board
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
      return gameboard.New(boardLines)
   else
      return instance
   end
end

function board:AddStoneToBoard(stone)
   table.insert(self.stones, stone)
end

function board:RemoveStoneFromBoard(stone)
   self.stones[table.find(self.stones, stone)] = nil
end

function board:DrawBoard()
   if self.showBoard == true then
      UI:DrawBoard()

      for i,v in ipairs(self.stones) do
         UI:DrawPiece(v.row, v.column, v.owner.color)
      end
   end

end

function board:CleanBoard()
   table.clear(self.stones)
end

return board
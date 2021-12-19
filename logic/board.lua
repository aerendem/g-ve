local board = {}
board.__index = board

require("love")

function board.new(boardLines)
   local self = setmetatable({}, board)

   self.__index = self
   self.boardLines = boardLines
   self.pieceMatrix = {}
   return self
end

function board:drawBoard()

end

function board:printBoardLines()
   love.graphics.print(self.boardLines,0,0,0,5,5)
end

return board
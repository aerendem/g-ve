local game = {}
game.__index = game

require("love")
require("logic/board")
require("logic/player")
local stone = require("logic/stone")
local colors = require("dependencies/colors")

function game.New(gameState, player1, player2)
   local self = setmetatable({}, game)

   self.__index = self
   self.state = gameState -- 1: start; 2: play; 3: gameover
   self.player1 = player1
   self.player2 = player2

   self.currentTurnOwner = nil --Player object

   self.winner = nil

   return self
end

function game:StartGame()
   if self.state ~= 2 then
      self.player1 = player.New("Ali", colors.red)
      self.player2 = player.New("Atakan", colors.lime)

      --TEMP
      local stone = stone.New(self.player2, 2, 5)
      board:AddStoneToBoard(stone)

      board.showBoard = true
   
      self:PassTurn()

      self.state = 2
   end
end

function game:GetGameState()
   return self.state
end

function game:EndGame()
   if self.state == 2 then
      
      --Set board and stones unvisible, clean after setting it invisible
      board.showBoard = false
      board:CleanBoard()

      self.state = 3
   end
end

function game:RestartGame()
   if self.state == 2 then
      

      self.state = 3
   end
end

function game:PassTurn()
   if self.currentTurnOwner == self.player1 then
      self.currentTurnOwner = self.player2
   else
      self.currentTurnOwner = self.player1
   end
end

return game
local game = {}
game.__index = game

require("love")
require("logic/board")
require("logic/player")
local stone = require("logic/stone")
local colors = require("dependencies/colors")

local instance

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

function game.GetInstance(gameState, player1, player2)
   if instance == nil then
      instance =  game.New(gameState, player1, player2)
   end

   return instance
end

function game:StartGame()
   if self.state ~= 2 then
      self.player1 = player.New("Ali", colors.red)
      self.player2 = player.New("Atakan", colors.lime)

      board.showBoard = true
   
      self:PassTurn()

      self.state = 2
   end
end

function game:GetGameState()
   return self.state
end

function game:SetWinner()
   if self.player1.score > self.player2.score then
      self.winner = self.player1
   elseif self.player1.score < self.player2.score then
      self.winner = self.player2
   else
      self.winner = self.player1
   end
end

function game:EndGame()
  if self.state == 2 then
      game:SetWinner()

      --Set board and stones unvisible, clean after setting it invisible
      board.showBoard = false
      board:CleanBoard()

      UI:DrawWinnerLabel(self.winner)
      
      self.state = 3

      local clickMe = urutora.button({
         text = 'Click to start!',
         x = 300, y = 300,
         w = 200,
      })
   
      clickMe:action(function(e)
         print("AAAAAAAAAAAAAA")
         game:StartGame()	
         clickMe:deactivate()
      end)
   
      urutora:add(clickMe)
   end
end

function game:ShowScores()
   if self.state == 2 then
      UI:DrawScores(self.player1, self.player2)
   end
end

function game:PassTurn()   
   board:UpdateBoard()

   if self.currentTurnOwner == self.player1 then
      self.currentTurnOwner = self.player2
   else
      self.currentTurnOwner = self.player1
   end
end

return game
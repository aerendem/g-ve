local game = {}
game.__index = game

require("love")
require("logic/board")
require("logic/player")
local stone = require("logic/stone")
local colors = require("dependencies/colors")
require('dependencies/urutora')

local instance

function game.New(gameState, player1, player2)
   local self = setmetatable({}, game)

   self.__index = self
   self.state = gameState -- 1: start; 2: play; 3: gameover
   self.player1 = player1
   self.player2 = player2

   self.scoreGoal = 5

   self.currentTurnOwner = player1 --Player object

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
      self.winner = nil
      self.currentTurnOwner = player1

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

function game:EndGame()
  if self.state == 2 then
      --Set board and stones unvisible, clean after setting it invisible
      board.showBoard = false
      board:CleanBoard()
      
      self.state = 3

      --Add button to re-initiate game
      local clickMe = urutora.button({
         text = 'Click to start!',
         x = 150, y = 250,
         w = 200,
      })
   
      clickMe:action(function(e)
         self:StartGame()	
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
   local totalRemovedStoneCount = board:UpdateBoard()

   --Increase score
   if self.currentTurnOwner ~= nil then
      self.currentTurnOwner.score = self.currentTurnOwner.score + totalRemovedStoneCount
   end

   if self.currentTurnOwner ~= nil and self.currentTurnOwner.score >= self.scoreGoal then
      self.winner = self.currentTurnOwner
      self:EndGame()
      return
   end

   --Pass the current turn ownership
   if self.currentTurnOwner == self.player1 then
      self.currentTurnOwner = self.player2
   else
      self.currentTurnOwner = self.player1
   end
end

return game
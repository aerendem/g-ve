-------------------------
--Declaration
-------------------------
game = {}
game.__index = game

-------------------------
--Dependencies
-------------------------
require("love")
require("logic/board")
require("logic/player")
require('dependencies/urutora')
local stone = require("logic/stone")
local colors = require("dependencies/colors")

---Singleton Instance
local instance

-------------------------
--Constructor
-------------------------
function game.New(gameState, player1, player2)
   local self = setmetatable({}, game)
   self.__index = self

   -- 1: Start; 2: Play; 3: Gameover
   self.state = gameState 

   self.player1 = player1
   self.player2 = player2

   --Score to win the game
   self.scoreGoal = 5

   --Current turn owner player
   self.currentTurnOwner = player1 --Player object

   --Winner player attribute
   self.winner = nil

   return self
end

---Singleton Instance Getter
function game.GetInstance(gameState, player1, player2)
   if instance == nil then
      instance =  game.New(gameState, player1, player2)
   end

   return instance
end

---Starts the game, initializes new players and showing board
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

---Returns game state
function game:GetGameState()
   return self.state
end

---Ends game, cleans board and creates a button to restart the game
function game:EndGame()
  if self.state == 2 then
      --Set board and stones unvisible, clean after setting it invisible
      board.showBoard = false
      board:CleanBoard()
      
      --Setting the game state to gameover
      self.state = 3

      --Add button to re-initiate game
      local clickMe = urutora.button({
         text = 'Restart game!',
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

---Show scores, runs every love.draw() frame
function game:ShowScores()
   if self.state == 2 then
      UI:DrawScores(self.player1, self.player2)
   end
end

---Passes turn to other player, checks score of current turn owner to determine if game is over
function game:PassTurn()   
   local totalRemovedStoneCount = board:UpdateBoard()

   --Increase score
   if self.currentTurnOwner ~= nil then
      self.currentTurnOwner.score = self.currentTurnOwner.score + totalRemovedStoneCount
   end

   --Check score to end the game
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
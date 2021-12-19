local game = {}
game.__index = game

require("love")

function game.new(gameState, player1,player2)
   local self = setmetatable({}, game)

   self.__index = self
   self.state = gameState
   self.player1 = player1
   self.player2 = player2
   self.winner = nil

   return self
end

function game:startGame()
  
end

function game:endGame()
  
end

return game
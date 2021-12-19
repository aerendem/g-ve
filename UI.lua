local UI = {}
UI.__index = UI

require("love")
local urutora = require('dependencies/urutora')


function UI.new(field_lines,field_size)
   local self = setmetatable({}, UI)

   self.__index = self
   self.field_lines = field_lines or 0
   self.field_size = field_size or 0
   self.score_a = 0
   self.score_b = 0
   self.completion_num = 20
   return self
end

function UI:UpdateScores(scoreA,scoreB)
    self.score_a = scoreA
   self.score_b = scoreB
end

function UI:DrawBoard()
    love.graphics.setColor(255, 255, 255, 128)
    for i = 1, self.field_lines do
        love.graphics.line(self.field_size, self.field_size*i, self.field_size*self.field_lines, self.field_size*i)
        love.graphics.line(self.field_size*i, self.field_size, self.field_size*i, self.field_size*self.field_lines)
    end
end

function UI:Scores()
         love.graphics.print("Red: "..self.score_a, self.field_size, self.field_size/4)
         love.graphics.print("Blue: "..self.score_b, 3*self.field_size, self.field_size/4)
         love.graphics.print("Completion: "..self.completion_num % (self.field_lines*self.field_lines), 6*self.field_size, self.field_size/4)
end

function UI:DrawPiece()
   -- for i = 0, 20 do
       -- love.graphics.setColor(200, math.min(10*i, 200), math.min(10*i, 200), 255)
       love.graphics.setColor(255,0,0)
        love.graphics.circle("fill", 2*self.field_size, 3*self.field_size, 20)
        
   -- end
    
end



return UI
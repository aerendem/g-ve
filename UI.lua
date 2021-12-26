local UI = {}
UI.__index = UI

require("love")

local urutora = require('dependencies/urutora')
local colors = require("dependencies/colors")

function UI.new(field_lines, field_size)
    local self = setmetatable({}, UI)

    self.__index = self
    self.field_lines = field_lines or 0
    self.field_size = field_size or 0
    self.score_a = 0
    self.score_b = 0
    self.completion_num = 20

    canvas = love.graphics.newCanvas(w, h)
    canvas:setFilter('nearest', 'nearest')

    love.graphics.setNewFont("fonts/BagnardSans.otf", 16)
    local font1 = love.graphics.newFont('fonts/BagnardSans.otf', 16)
    urutora.setDefaultFont(font1)
    urutora.setResolution(canvas:getWidth(), canvas:getHeight())

    return self
end

function UI:UpdateScores(scoreA, scoreB)
    self.score_a = scoreA
    self.score_b = scoreB
end

function UI:DrawBoard()
    love.graphics.setColor(255, 255, 255, 128)
    for i = 1, self.field_lines do
        love.graphics.line(self.field_size, self.field_size * i,
                           self.field_size * self.field_lines,
                           self.field_size * i)
        love.graphics.line(self.field_size * i, self.field_size,
                           self.field_size * i,
                           self.field_size * self.field_lines)
    end
end

function UI:DrawScores(player1, player2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(player1.name..": " .. player1.score, self.field_size,
                        self.field_size / 4)
    love.graphics.print(player2.name..": " .. player2.score, 3 * self.field_size,
                        self.field_size / 4)
    love.graphics.print("Completion: " .. self.completion_num %
                            (self.field_lines * self.field_lines),
                        6 * self.field_size, self.field_size / 4)
end

function UI:DrawPiece(row, column, color)
    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.circle("fill", row * self.field_size,
                         column * self.field_size, 20)
                
end

function UI:DrawWinnerLabel(winnerPlayer)
    local label = urutora.text({ winnerPlayer.name .. "has won with "..winnerPlayer.score.." score", 250, 250, self.field_size,
    self.field_size})
    label:draw()
    love.graphics.print(winnerPlayer.name .. "has won with "..winnerPlayer.score.." score", 250, 250)
end

return UI
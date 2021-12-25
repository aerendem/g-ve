function love.mousepressed(x, y, btn, touch)
    if game.state == 2 then
        for c = 1, field_lines do
            for r = 1, field_lines do
                if math.sqrt((x - (c*field_size))^2 + (y - (r*field_size))^2) <= piece_rad then
                    place_piece(1, 2, c, r)
                end
            end
        end
    else
       -- start_game()
       -- game_state = 2
    end
end

function love.keypressed(k, scancode, isrepeat)
    urutora:keypressed(k, scancode, isrepeat)

    if k == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button) urutora:pressed(x, y) end
function love.mousemoved(x, y, dx, dy) urutora:moved(x, y, dx, dy) end
function love.mousereleased(x, y, button) urutora:released(x, y) end
function love.textinput(text) urutora:textinput(text) end
function love.wheelmoved(x, y) urutora:wheelmoved(x, y) end
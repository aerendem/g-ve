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
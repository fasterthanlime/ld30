
function love.draw()
  w = 512
  p = 256

  love.graphics.print("2048", p, p)
  love.graphics.print("Snake", p + w, p)
  love.graphics.print("Tetris", p + w, p + w)
  love.graphics.print("Runner", p, p + w)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end


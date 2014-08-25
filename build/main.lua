LD = { }
require('./utils')
require('./config')
require('./world')
require('./input')
require('./loader')
local config = LD.config
local world = LD.world
local input = LD.input
local square_dist
square_dist = function(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  return dx * dx + dy * dy
end
LD.controlpressed = function(control)
  local _exp_0 = control
  if 'left' == _exp_0 then
    return world:move_player(-1, 0)
  elseif 'right' == _exp_0 then
    return world:move_player(1, 0)
  elseif 'up' == _exp_0 then
    return world:move_player(0, -1)
  elseif 'down' == _exp_0 then
    return world:move_player(0, 1)
  end
end
love.draw = function()
  love.graphics.setColor(100, 140, 255, 255)
  world.level.map:draw()
  love.graphics.setColor(200, 200, 70, 255)
  do
    local _with_0 = world.player
    love.graphics.draw(config.img.tileset, world.player.quad, _with_0.x, _with_0.y)
    return _with_0
  end
end
love.update = function(dt)
  return world:update(dt)
end

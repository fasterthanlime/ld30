LD = { }
require('./utils')
require('./config')
require('./world')
require('./input')
require('./loader')
local config = LD.config
local world = LD.world
local input = LD.input
local can_move_to
can_move_to = function(col, row)
  local side = world.level.side
  if col > side then
    return false
  end
  if row > side then
    return false
  end
  if col < 1 then
    return false
  end
  if row < 1 then
    return false
  end
  local _exp_0 = world.level.blocks[col][row]
  if 17 == _exp_0 then
    return false
  else
    return true
  end
end
local has_moved_to
has_moved_to = function(col, row)
  local _exp_0 = world.level.blocks[col][row]
  if 34 == _exp_0 then
    print("You win!")
    return love.event.quit()
  end
end
local move_player
move_player = function(dcol, drow)
  local col = world.player.col + dcol
  local row = world.player.row + drow
  if can_move_to(col, row) then
    world.player.col = col
    world.player.row = row
    return has_moved_to(col, row)
  end
end
LD.controlpressed = function(control)
  local _exp_0 = control
  if 'left' == _exp_0 then
    return move_player(-1, 0)
  elseif 'right' == _exp_0 then
    return move_player(1, 0)
  elseif 'up' == _exp_0 then
    return move_player(0, -1)
  elseif 'down' == _exp_0 then
    return move_player(0, 1)
  end
end
love.update = function(dt)
  local speed = config.gameplay.player_speed
end
local set_opacity
set_opacity = function(opacity)
  return love.graphics.setColor(255, 255, 255, opacity)
end
love.draw = function()
  local side = 48
  world.level.map:draw()
  do
    local _with_0 = world.player
    local x, y = (_with_0.col - 1) * side, (_with_0.row - 1) * side
    love.graphics.draw(config.img.circle, x, y)
    return _with_0
  end
end

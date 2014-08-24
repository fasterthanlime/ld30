LD = { }
require('./config')
require('./world')
require('./input')
local config = LD.config
local world = LD.world
local input = LD.input
love.load = function()
  config.font = love.graphics.newFont("fonts/Asgalt-Regular.ttf", 80)
  config.img = { }
  config.img.square = love.graphics.newImage("img/square.png")
  local joystick_count = love.joystick.getJoystickCount()
  if joystick_count > 0 then
    print(tostring(joystick_count) .. " joysticks found, using first.")
    config.joystick = love.joystick.getJoysticks()[1]
  else
    return print("No joysticks found!")
  end
end
love.update = function(dt)
  local speed = config.gameplay.player_speed
  do
    local _with_0 = world.pressed
    if _with_0.left then
      world.player.x = world.player.x - speed
    end
    if _with_0.right then
      world.player.x = world.player.x + speed
    end
    if _with_0.up then
      world.player.y = world.player.y - speed
    end
    if _with_0.down then
      world.player.y = world.player.y + speed
    end
  end
  local joystick = config.joystick
  if joystick then
    local x, y, z, w = joystick:getAxes()
    world.player.x = world.player.x + (speed * x)
    world.player.y = world.player.y + (speed * y)
  end
end
love.draw = function()
  love.graphics.setFont(config.font)
  local side = 128
  local nc = 6
  for row = 0, nc - 1 do
    for col = 0, nc - 1 do
      love.graphics.draw(config.img.square, row * side, col * side)
    end
  end
  do
    local _with_0 = world.player
    love.graphics.draw(config.img.square, _with_0.x, _with_0.y)
    love.graphics.print("player", _with_0.x, _with_0.y)
    return _with_0
  end
end

local config = LD.config
local world = LD.world
local load_fonts
load_fonts = function()
  config.font = love.graphics.newFont("fonts/Asgalt-Regular.ttf", 58)
end
local load_imgs
load_imgs = function()
  config.img = { }
  do
    local _with_0 = config.img
    _with_0.square = love.graphics.newImage("img/square.png")
    return _with_0
  end
end
local load_level
load_level = function()
  local file = love.filesystem.newFile("levels/level1.txt")
  local row = 0
  for line in file:lines() do
    row = row + 1
    local col = 0
    for c, i in line:gmatch(".") do
      col = col + 1
      world.level.map[col][row] = c
    end
  end
  local _
  do
    local _base_0 = file
    local _fn_0 = _base_0.close
    _ = function(...)
      return _fn_0(_base_0, ...)
    end
  end
  return LD.print_map()
end
local load_joystick
load_joystick = function()
  local joystick_count = love.joystick.getJoystickCount()
  if joystick_count > 0 then
    print(tostring(joystick_count) .. " joysticks found, using first.")
    config.joystick = love.joystick.getJoysticks()[1]
  else
    return print("No joysticks found!")
  end
end
love.load = function()
  load_fonts()
  load_imgs()
  load_joystick()
  return load_level()
end

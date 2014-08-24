local atl = require('./libs/atl/Loader')
atl.path = 'maps/'
local config = LD.config
local world = LD.world
local load_fonts
load_fonts = function()
  config.font = love.graphics.newFont("fonts/Asgalt-Regular.ttf", 40)
end
local load_imgs
load_imgs = function()
  config.img = { }
  local imgs = {
    'square',
    'circle',
    'xblock'
  }
  for i, img in pairs(imgs) do
    config.img[img] = love.graphics.newImage("img/" .. tostring(img) .. ".png")
  end
end
local load_map
load_map = function(map_name)
  print("Loading map " .. tostring(map_name))
  local map = atl.load(map_name)
  local first_layer = "error"
  for k, v in pairs(map.layers) do
    first_layer = k
    break
  end
  print("First layer = '" .. tostring(first_layer) .. "'")
  world.level.blocks = { }
  for col = 1, 16 do
    world.level.blocks[col] = { }
  end
  for col0, row0, tile in map(first_layer):iterate() do
    local col, row = col0 + 1, row0 + 1
    world.level.blocks[col][row] = tile.id
    local _exp_0 = tile.id
    if 33 == _exp_0 then
      world.player.col = col
      world.player.row = row
    end
  end
  world.level.map = map
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
  return load_map("tuto1.tmx")
end

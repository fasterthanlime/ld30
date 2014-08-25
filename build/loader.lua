local atl = require('./libs/atl/Loader')
atl.path = 'maps/'
local config = LD.config
local world = LD.world
local Loader
do
  local _base_0 = {
    load = function(self)
      self:load_fonts()
      self:load_imgs()
      self:load_joystick()
      return self:load_map()
    end,
    load_fonts = function(self)
      config.font = love.graphics.newFont("fonts/Asgalt-Regular.ttf", 40)
    end,
    load_imgs = function(self)
      config.img = { }
      local imgs = {
        'square',
        'circle',
        'xblock',
        'tileset'
      }
      for i, img in pairs(imgs) do
        config.img[img] = love.graphics.newImage("img/" .. tostring(img) .. ".png")
      end
    end,
    load_map = function(self)
      if config.current_map > #config.maps then
        return false
      end
      local map_name = config.maps[config.current_map]
      print("Loading map " .. tostring(map_name))
      local map = atl.load(tostring(map_name) .. ".tmx")
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
          world:warp_player(col, row)
        end
      end
      world.level.map = map
      return true
    end,
    load_joystick = function(self)
      local joystick_count = love.joystick.getJoystickCount()
      if joystick_count > 0 then
        print(tostring(joystick_count) .. " joysticks found, using first.")
        config.joystick = love.joystick.getJoysticks()[1]
      else
        return print("No joysticks found!")
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      config.maps = {
        "tuto1",
        "tuto2"
      }
      config.current_map = 1
    end,
    __base = _base_0,
    __name = "Loader"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Loader = _class_0
end
local loader = Loader()
love.load = function()
  return loader:load()
end
LD.loader = loader

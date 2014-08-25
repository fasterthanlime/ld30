
atl = require './libs/atl/Loader'
atl.path = 'maps/'

config = LD.config
world = LD.world

class Loader
  new: =>
    config.maps = {
      "tuto1"
      "tuto2"
    }
    config.current_map = 1

  -----------------------------------------------------------------
  -- global load
  -----------------------------------------------------------------

  load: =>
    @load_fonts!
    @load_imgs!
    @load_joystick!
    @load_map!

  -----------------------------------------------------------------
  -- love likes truetype it seems
  -----------------------------------------------------------------

  load_fonts: =>
    config.font = love.graphics.newFont "fonts/Asgalt-Regular.ttf", 40


  -----------------------------------------------------------------
  -- PNG is the name of the game
  -----------------------------------------------------------------

  load_imgs: =>
    config.img = {}

    imgs = {
      'square'
      'circle'
      'xblock'
      'tileset'
    }

    for i, img in pairs imgs
      config.img[img] = love.graphics.newImage "img/#{img}.png"

  -----------------------------------------------------------------
  -- simple map text format, . = empty space, x = stuff
  -----------------------------------------------------------------

  load_map: =>
    if config.current_map > #config.maps
      return false -- reached end of maps

    map_name = config.maps[config.current_map]
    print "Loading map #{map_name}"
    map = atl.load "#{map_name}.tmx"

    first_layer = "error"
    for k, v in pairs map.layers
      first_layer = k
      break
    print "First layer = '#{first_layer}'"

    world.level.blocks = {}
    for col = 1, 16
      world.level.blocks[col] = {}

    for col0, row0, tile in map(first_layer)\iterate!
      col, row = col0 + 1, row0 + 1
      world.level.blocks[col][row] = tile.id

      switch tile.id
        when 33 -- depart
          world\warp_player col, row

    world.level.map = map
    true

  -----------------------------------------------------------------
  -- joystick loading - no hotplugging, just use the first at startup
  -----------------------------------------------------------------

  load_joystick: =>
    joystick_count = love.joystick.getJoystickCount()
    if joystick_count > 0
      print "#{joystick_count} joysticks found, using first."
      config.joystick = love.joystick.getJoysticks()[1]
    else
      print "No joysticks found!"

loader = Loader!

love.load = ->
  loader\load!

LD.loader = loader



config = LD.config
world = LD.world

-----------------------------------------------------------------
-- love likes truetype it seems
-----------------------------------------------------------------

load_fonts = ->
  config.font = love.graphics.newFont "fonts/Asgalt-Regular.ttf", 58


-----------------------------------------------------------------
-- PNG is the name of the game
-----------------------------------------------------------------

load_imgs = ->
  config.img = {}

  with config.img
    .square = love.graphics.newImage "img/square.png"

-----------------------------------------------------------------
-- simple level text format, . = empty space, x = stuff
-----------------------------------------------------------------

load_level = ->
  file = love.filesystem.newFile "levels/level1.txt"

  row = 0
  for line in file\lines!
    row += 1
    col = 0

    for c, i in line\gmatch "."
      col += 1
      world.level.map[col][row] = c

  file\close

  LD.print_map!

-----------------------------------------------------------------
-- joystick loading - no hotplugging, just use the first at startup
-----------------------------------------------------------------

load_joystick = ->
  joystick_count = love.joystick.getJoystickCount()
  if joystick_count > 0
    print "#{joystick_count} joysticks found, using first."
    config.joystick = love.joystick.getJoysticks()[1]
  else
    print "No joysticks found!"

-----------------------------------------------------------------
-- global load
-----------------------------------------------------------------

love.load = ->
  load_fonts()
  load_imgs()
  load_joystick()
  load_level()


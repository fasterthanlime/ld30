
export LD = {}

require './utils'
require './config'
require './world'
require './input'
require './loader'

-- imports (kinda)
config = LD.config
world = LD.world
input = LD.input

-- update tick
love.update = (dt) ->
  speed = config.gameplay.player_speed

  with world.pressed
    if .left
      world.player.x -= speed
    if .right
      world.player.x += speed
    if .up
      world.player.y -= speed
    if .down
      world.player.y += speed

  joystick = config.joystick
  if joystick
    x, y, z, w = joystick\getAxes()
    world.player.x += speed * x
    world.player.y += speed * y

-- draw (I love these comments things.)
love.draw = ->
  love.graphics.setFont config.font

  side = 96
  nc = 8

  for row = 0, nc - 1
    for col = 0, nc - 1
      love.graphics.draw config.img.square, row * side, col * side

  with world.player
    love.graphics.draw config.img.square, .x, .y
    love.graphics.print "player", .x, .y


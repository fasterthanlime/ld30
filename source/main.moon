
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

square_dist = (x1, y1, x2, y2) ->
  dx = x2 - x1
  dy = y2 - y1
  dx * dx + dy * dy

-- return true if the player is in movement

LD.controlpressed = (control) ->
  switch control
    when 'left'
      world\move_player -1, 0
    when 'right'
      world\move_player 1, 0
    when 'up'
      world\move_player 0, -1
    when 'down'
      world\move_player 0, 1

-- draw (I love these comments things.)
love.draw = ->
  love.graphics.setColor 100, 140, 255, 255
  world.level.map\draw!

  love.graphics.setColor 200, 200, 70, 255
  with world.player
    love.graphics.draw config.img.tileset, world.player.quad, .x, .y

-- update tick
love.update = (dt) ->
  world\update(dt)



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

set_opacity = (opacity) ->
  love.graphics.setColor 255, 255, 255, opacity

-- draw (I love these comments things.)
love.draw = ->
  world.level.map\draw!

  with world.player
    love.graphics.draw config.img.circle, .x, .y

-- update tick
love.update = (dt) ->
  world\update(dt)



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

can_move_to = (col, row) ->
  side = world.level.side

  return false if col > side
  return false if row > side
  return false if col < 1
  return false if row < 1

  return switch world.level.blocks[col][row]
    when 17
      false
    else
      true

has_moved_to = (col, row) ->
  switch world.level.blocks[col][row]
    when 34
      print "You win!"
      love.event.quit()

move_player = (dcol, drow) ->
  col = world.player.col + dcol
  row = world.player.row + drow

  if can_move_to(col, row)
    world.player.col = col
    world.player.row = row
    has_moved_to(col, row)

LD.controlpressed = (control) ->
  switch control
    when 'left'
      move_player(-1, 0)
    when 'right'
      move_player(1, 0)
    when 'up'
      move_player(0, -1)
    when 'down'
      move_player(0, 1)

-- update tick
love.update = (dt) ->
  speed = config.gameplay.player_speed

set_opacity = (opacity) ->
  love.graphics.setColor 255, 255, 255, opacity

-- draw (I love these comments things.)
love.draw = ->
  side = 48

  world.level.map\draw!

  with world.player
    x, y = (.col - 1) * side, (.row - 1) * side
    love.graphics.draw config.img.circle, x, y


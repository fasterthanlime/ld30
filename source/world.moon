
tween = require './libs/tween/tween'

config = LD.config
loader = LD.loader

class World

  pressed: {
    left: false
    right: false
    up: false
    down: false
  }

  player: {
    col: 1
    row: 1
    x: 0
    y: 0
  }

  side: 16
  width: 48

  level: {
    blocks: {}
    map: {}
  }

  new: =>
    for col = 1, @side
      @level.map[col] = {}

    @player.quad = love.graphics.newQuad 0, 0, @width, @width, @side * @width, @side * @width

  to_pixels: (col, row) =>
    width = @width
    return (col - 1) * width, (row - 1) * width

  warp_player: (col, row) =>
    with @player
      .col, .row = col, row
      .x, .y = @to_pixels col, row

  is_player_moving: =>
    @player.tween != nil

  move_player: (dcol, drow) =>
    if @is_player_moving!
      @next_move = { dcol, drow }
      return

    col = @player.col + dcol
    row = @player.row + drow

    while @can_move_to(col, row)
      @player.col = col
      @player.row = row

      col = @player.col + dcol
      row = @player.row + drow

    x, y = @to_pixels(@player.col, @player.row)

    with config.gameplay.tween
      @player.tween = tween.new .duration, @player, { x: x, y: y }, .easing

  update: (dt) =>
    if @is_player_moving!
      done = @player.tween\update(dt)
      if done
        @player.tween = nil
        if @next_move
          move = @next_move
          @next_move = nil
          @move_player move[1], move[2]
    else
      with @player
        @check_win .col, .row

  can_move_to: (col, row) =>
    return false if col > @side
    return false if row > @side
    return false if col < 1
    return false if row < 1

    return switch @level.blocks[col][row]
      when 17
        false
      else
        true

  check_win: (col, row) =>
    switch @level.blocks[col][row]
      when 34
        config.current_map += 1
        unless LD.loader\load_map!
          print "You win!"
          love.event.quit()

LD.world = World!


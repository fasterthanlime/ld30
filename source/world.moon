
tween = require './libs/tween/tween'

config = LD.config
loader = LD.loader

class Player

  new: (@world, col, row) =>
    @val = 1
    @warp col, row

  warp: (@col, @row) =>
    @x, @y = @world\to_pixels @col, @row

  move: (dcol, drow) =>
    col = @col + dcol
    row = @row + drow

    while @world\can_move_to(col, row, @val)
      @col = col
      @row = row

      col = @col + dcol
      row = @row + drow

    x, y = @world\to_pixels(@col, @row)

    with config.gameplay.tween
      @tween = tween.new .duration, @, { x: x, y: y }, .easing

class World

  pressed: {
    left: false
    right: false
    up: false
    down: false
  }

  players: {}

  player: {}

  side: 16
  width: 48

  level: {
    blocks: {}
    map: {}
  }

  new: =>
    for col = 1, @side
      @level.map[col] = {}

    @player_quads = {}

    for i = 1, 16
      @player_quads[i] = love.graphics.newQuad (i - 1) * @width, 0, @width, @width, @side * @width, @side * @width

  reset: =>
    @players = {}
    @level.blocks = {}
    @level.map = {}

  to_pixels: (col, row) =>
    width = @width
    return (col - 1) * width, (row - 1) * width

  new_player: (col, row) =>
    @players[#@players + 1] = Player(@, col, row)

  is_player_moving: =>
    for num, player in ipairs @players
      return true if player.tween != nil
    false

  move_player: (dcol, drow) =>
    if @is_player_moving!
      return

    for num, player in ipairs @players
      player\move(dcol, drow)

  update: (dt) =>
    if @is_player_moving!
      for num, player in ipairs @players
        done = player.tween\update(dt)
        if done
          player.tween = nil
    else
      for num, player in ipairs @players
        @check_win player.col, player.row

      @check_merge!

  check_merge: =>
    for a, player1 in ipairs @players
      for b, player2 in ipairs @players
        continue if a == b
        break if b > a
        if player1.col == player2.col and player1.row == player2.row
          print "collision o/"
          @merge_players a, b
          return

  merge_players: (a, b) =>
    new_players = {}
    i = 1

    @players[a].val += @players[b].val

    for num, player in ipairs @players
      continue if num == b
      new_players[i] = player
      i += 1

    @players = new_players

  can_move_to: (col, row, val) =>
    return false if col > @side
    return false if row > @side
    return false if col < 1
    return false if row < 1

    tile_id = @level.blocks[col][row]
    return switch tile_id
      when 17
        false
      else
        if tile_id > 48 and tile_id <= 64
          tile_val = tile_id - 48
          val >= tile_val
        else
          true

  check_win: (col, row) =>
    switch @level.blocks[col][row]
      when 34
        @skip!
        -- config.current_map += 1
        -- unless LD.loader\load_map!
        --   print "You win!"
        --   love.event.quit()

  reload: =>
    LD.loader\load_map!

  skip: =>
    config.current_map += 1
    if config.current_map > #config.maps
      config.current_map = 1
    LD.loader\load_map!

LD.world = World!


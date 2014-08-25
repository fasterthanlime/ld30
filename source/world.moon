
Tween = require './libs/tween/tween'

config = LD.config
loader = LD.loader

class Player

  new: (@world, col, row) =>
    @val = 1
    @warp col, row
    @moves = {}
    @dead = false

  warp: (@col, @row) =>
    @x, @y = @world\to_pixels @col, @row

  move: (dcol, drow) =>
    @dcol = dcol
    @drow = drow

    while true
      col = @col + dcol
      row = @row + drow

      can, bounce, mult, die = @world\move_info(col, row, @val)

      if die
        @queue_move { col: col, row: row }
        @queue_move { col: col, row: row, die: true }
        return

      break unless can

      if bounce
        @queue_move { col: @col, row: @row, bounce: true }
        return

      @val += mult

      @col = col
      @row = row
      
    @queue_move { col: @col, row: @row }

  queue_move: (move) =>
    @moves[#@moves + 1] = move

  is_moving: =>
    #@moves > 0 or @tween != nil

  update: (dt) =>
    if #@moves > 0 and @tween == nil
      move = @pop_move!

      if move.die
        @dead = true
        return false

      x, y = @world\to_pixels(move.col, move.row)
      with config.gameplay.tween
        dx = @x - x
        dy = @y - y
        dist = math.sqrt(dx * dx + dy * dy)

        easing = .easing
        if move.bounce
          easing = 'inCubic'

        duration = .duration
        duration *= (dist / 256)

        if duration > 0
          @tween = Tween.new duration, @, { x: x, y: y }, easing

        if move.bounce
          @move -@dcol, -@drow

    if @tween != nil
      done = @tween\update(dt)
      if done
        @tween = nil

  pop_move: =>
    move = @moves[1]
    new_moves = {}
    j = 1

    for i = 2, #@moves
      new_moves[j] = @moves[i]
      j += 1

    @moves = new_moves
    move

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
      return true if player\is_moving!
    false

  move_player: (dcol, drow) =>
    for num, player in ipairs @players
      unless player\is_moving!
        player\move(dcol, drow)

  update: (dt) =>
    if @is_player_moving!
      for num, player in ipairs @players
        player\update(dt)

    for num, player in ipairs @players
      unless player\is_moving!
        @check_win player.col, player.row

    @check_dead!
    @check_merge!

  check_dead: =>
    for num, player in ipairs @players
      if player.dead
        @remove_player num
        return

  check_merge: =>
    for a, player1 in ipairs @players
      for b, player2 in ipairs @players
        continue if a == b
        continue if player1\is_moving! or player2\is_moving!
        break if b > a
        if player1.col == player2.col and player1.row == player2.row
          @merge_players a, b
          return

  remove_player: (num) =>
    new_players = {}
    i = 1

    for j, player in ipairs @players
      continue if num == j
      new_players[i] = player
      i += 1

    @players = new_players

  merge_players: (a, b) =>
    new_players = {}
    i = 1

    @players[a].val += @players[b].val

    for num, player in ipairs @players
      continue if num == b
      new_players[i] = player
      i += 1

    @players = new_players

  move_info: (col, row, val) =>
    can = true
    bounce = false
    mult = 0
    die = false

    if col > @side or row > @side or col < 1 or row < 1
      can = false
      return can, bounce, mult, die

    tile_id = @level.blocks[col][row]
    if tile_id != 0
      can = false

    return switch tile_id
      when 34
        can = true
      when 35
        die = true
      else
        if tile_id >= 36 and tile_id <= 39
          can = true
          bounce = true
        if tile_id > 48 and tile_id <= 64
          tile_val = tile_id - 48
          can = val >= tile_val
        if tile_id > 64 and tile_id <= 80
          tile_val = tile_id - 64
          can = val <= tile_val

    return can, bounce, mult, die

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


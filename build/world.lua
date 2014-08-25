local Tween = require('./libs/tween/tween')
local config = LD.config
local loader = LD.loader
local Player
do
  local _base_0 = {
    warp = function(self, col, row)
      self.col, self.row = col, row
      self.x, self.y = self.world:to_pixels(self.col, self.row)
    end,
    move = function(self, dcol, drow)
      self.dcol = dcol
      self.drow = drow
      while true do
        local col = self.col + dcol
        local row = self.row + drow
        local can, bounce, mult, die = self.world:move_info(col, row, self.val)
        if die then
          self:queue_move({
            col = col,
            row = row
          })
          self:queue_move({
            col = col,
            row = row,
            die = true
          })
          return 
        end
        if not (can) then
          break
        end
        if bounce then
          self:queue_move({
            col = self.col,
            row = self.row,
            bounce = true
          })
          return 
        end
        self.val = self.val + mult
        self.col = col
        self.row = row
      end
      return self:queue_move({
        col = self.col,
        row = self.row
      })
    end,
    queue_move = function(self, move)
      self.moves[#self.moves + 1] = move
    end,
    is_moving = function(self)
      return #self.moves > 0 or self.tween ~= nil
    end,
    update = function(self, dt)
      if #self.moves > 0 and self.tween == nil then
        local move = self:pop_move()
        if move.die then
          self.dead = true
          return false
        end
        local x, y = self.world:to_pixels(move.col, move.row)
        do
          local _with_0 = config.gameplay.tween
          local dx = self.x - x
          local dy = self.y - y
          local dist = math.sqrt(dx * dx + dy * dy)
          local easing = _with_0.easing
          if move.bounce then
            easing = 'inCubic'
          end
          local duration = _with_0.duration
          duration = duration * (dist / 256)
          if duration > 0 then
            self.tween = Tween.new(duration, self, {
              x = x,
              y = y
            }, easing)
          end
          if move.bounce then
            self:move(-self.dcol, -self.drow)
          end
        end
      end
      if self.tween ~= nil then
        local done = self.tween:update(dt)
        if done then
          self.tween = nil
        end
      end
    end,
    pop_move = function(self)
      local move = self.moves[1]
      local new_moves = { }
      local j = 1
      for i = 2, #self.moves do
        new_moves[j] = self.moves[i]
        j = j + 1
      end
      self.moves = new_moves
      return move
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world, col, row)
      self.world = world
      self.val = 1
      self:warp(col, row)
      self.moves = { }
      self.dead = false
    end,
    __base = _base_0,
    __name = "Player"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Player = _class_0
end
local World
do
  local _base_0 = {
    pressed = {
      left = false,
      right = false,
      up = false,
      down = false
    },
    players = { },
    player = { },
    side = 16,
    width = 48,
    level = {
      blocks = { },
      map = { }
    },
    reset = function(self)
      self.players = { }
      self.level.blocks = { }
      self.level.map = { }
    end,
    to_pixels = function(self, col, row)
      local width = self.width
      return (col - 1) * width, (row - 1) * width
    end,
    new_player = function(self, col, row)
      self.players[#self.players + 1] = Player(self, col, row)
    end,
    is_player_moving = function(self)
      for num, player in ipairs(self.players) do
        if player:is_moving() then
          return true
        end
      end
      return false
    end,
    move_player = function(self, dcol, drow)
      for num, player in ipairs(self.players) do
        if not (player:is_moving()) then
          player:move(dcol, drow)
        end
      end
    end,
    update = function(self, dt)
      if self:is_player_moving() then
        for num, player in ipairs(self.players) do
          player:update(dt)
        end
      end
      for num, player in ipairs(self.players) do
        if not (player:is_moving()) then
          self:check_win(player.col, player.row)
        end
      end
      self:check_dead()
      return self:check_merge()
    end,
    check_dead = function(self)
      for num, player in ipairs(self.players) do
        if player.dead then
          self:remove_player(num)
          return 
        end
      end
    end,
    check_merge = function(self)
      for a, player1 in ipairs(self.players) do
        for b, player2 in ipairs(self.players) do
          local _continue_0 = false
          repeat
            if a == b then
              _continue_0 = true
              break
            end
            if player1:is_moving() or player2:is_moving() then
              _continue_0 = true
              break
            end
            if b > a then
              break
            end
            if player1.col == player2.col and player1.row == player2.row then
              self:merge_players(a, b)
              return 
            end
            _continue_0 = true
          until true
          if not _continue_0 then
            break
          end
        end
      end
    end,
    remove_player = function(self, num)
      local new_players = { }
      local i = 1
      for j, player in ipairs(self.players) do
        local _continue_0 = false
        repeat
          if num == j then
            _continue_0 = true
            break
          end
          new_players[i] = player
          i = i + 1
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self.players = new_players
    end,
    merge_players = function(self, a, b)
      local new_players = { }
      local i = 1
      self.players[a].val = self.players[a].val + self.players[b].val
      for num, player in ipairs(self.players) do
        local _continue_0 = false
        repeat
          if num == b then
            _continue_0 = true
            break
          end
          new_players[i] = player
          i = i + 1
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self.players = new_players
    end,
    move_info = function(self, col, row, val)
      local can = true
      local bounce = false
      local mult = 0
      local die = false
      if col > self.side or row > self.side or col < 1 or row < 1 then
        can = false
        return can, bounce, mult, die
      end
      local tile_id = self.level.blocks[col][row]
      if tile_id ~= 0 then
        can = false
      end
      local _exp_0 = tile_id
      if 34 == _exp_0 then
        can = true
      elseif 35 == _exp_0 then
        die = true
      else
        if tile_id >= 36 and tile_id <= 39 then
          can = true
          bounce = true
        end
        if tile_id > 48 and tile_id <= 64 then
          local tile_val = tile_id - 48
          can = val >= tile_val
        end
        if tile_id > 64 and tile_id <= 80 then
          local tile_val = tile_id - 64
          can = val <= tile_val
        end
      end
      return can, bounce, mult, die
    end,
    check_win = function(self, col, row)
      local _exp_0 = self.level.blocks[col][row]
      if 34 == _exp_0 then
        return self:skip()
      end
    end,
    reload = function(self)
      return LD.loader:load_map()
    end,
    skip = function(self)
      config.current_map = config.current_map + 1
      if config.current_map > #config.maps then
        config.current_map = 1
      end
      return LD.loader:load_map()
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      for col = 1, self.side do
        self.level.map[col] = { }
      end
      self.player_quads = { }
      for i = 1, 16 do
        self.player_quads[i] = love.graphics.newQuad((i - 1) * self.width, 0, self.width, self.width, self.side * self.width, self.side * self.width)
      end
    end,
    __base = _base_0,
    __name = "World"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  World = _class_0
end
LD.world = World()

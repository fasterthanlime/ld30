local tween = require('./libs/tween/tween')
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
      local col = self.col + dcol
      local row = self.row + drow
      while self.world:can_move_to(col, row, self.val) do
        self.col = col
        self.row = row
        col = self.col + dcol
        row = self.row + drow
      end
      local x, y = self.world:to_pixels(self.col, self.row)
      do
        local _with_0 = config.gameplay.tween
        self.tween = tween.new(_with_0.duration, self, {
          x = x,
          y = y
        }, _with_0.easing)
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, world, col, row)
      self.world = world
      self.val = 1
      return self:warp(col, row)
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
        if player.tween ~= nil then
          return true
        end
      end
      return false
    end,
    move_player = function(self, dcol, drow)
      if self:is_player_moving() then
        return 
      end
      for num, player in ipairs(self.players) do
        player:move(dcol, drow)
      end
    end,
    update = function(self, dt)
      if self:is_player_moving() then
        for num, player in ipairs(self.players) do
          local done = player.tween:update(dt)
          if done then
            player.tween = nil
          end
        end
      else
        for num, player in ipairs(self.players) do
          self:check_win(player.col, player.row)
        end
        return self:check_merge()
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
            if b > a then
              break
            end
            if player1.col == player2.col and player1.row == player2.row then
              print("collision o/")
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
    can_move_to = function(self, col, row, val)
      if col > self.side then
        return false
      end
      if row > self.side then
        return false
      end
      if col < 1 then
        return false
      end
      if row < 1 then
        return false
      end
      local tile_id = self.level.blocks[col][row]
      local _exp_0 = tile_id
      if 17 == _exp_0 then
        return false
      else
        if tile_id > 48 and tile_id <= 64 then
          local tile_val = tile_id - 48
          return val >= tile_val
        else
          return true
        end
      end
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

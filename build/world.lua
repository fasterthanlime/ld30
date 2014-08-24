local tween = require('./libs/tween/tween')
local config = LD.config
local World
do
  local _base_0 = {
    pressed = {
      left = false,
      right = false,
      up = false,
      down = false
    },
    player = {
      col = 1,
      row = 1,
      x = 0,
      y = 0
    },
    side = 16,
    width = 48,
    level = {
      blocks = { },
      map = { }
    },
    to_pixels = function(self, col, row)
      local width = self.width
      return (col - 1) * width, (row - 1) * width
    end,
    warp_player = function(self, col, row)
      do
        local _with_0 = self.player
        _with_0.col, _with_0.row = col, row
        _with_0.x, _with_0.y = self:to_pixels(col, row)
        return _with_0
      end
    end,
    is_player_moving = function(self)
      return self.player.tween ~= nil
    end,
    move_player = function(self, dcol, drow)
      if self:is_player_moving() then
        self.next_move = {
          dcol,
          drow
        }
        return 
      end
      local col = self.player.col + dcol
      local row = self.player.row + drow
      while self:can_move_to(col, row) do
        self.player.col = col
        self.player.row = row
        col = self.player.col + dcol
        row = self.player.row + drow
      end
      local x, y = self:to_pixels(self.player.col, self.player.row)
      do
        local _with_0 = config.gameplay.tween
        self.player.tween = tween.new(_with_0.duration, self.player, {
          x = x,
          y = y
        }, _with_0.easing)
        return _with_0
      end
    end,
    update = function(self, dt)
      if self:is_player_moving() then
        local done = self.player.tween:update(dt)
        if done then
          self.player.tween = nil
          if self.next_move then
            local move = self.next_move
            self.next_move = nil
            return self:move_player(move[1], move[2])
          end
        end
      else
        do
          local _with_0 = self.player
          self:check_win(_with_0.col, _with_0.row)
          return _with_0
        end
      end
    end,
    can_move_to = function(self, col, row)
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
      local _exp_0 = self.level.blocks[col][row]
      if 17 == _exp_0 then
        return false
      else
        return true
      end
    end,
    check_win = function(self, col, row)
      local _exp_0 = self.level.blocks[col][row]
      if 34 == _exp_0 then
        print("You win!")
        return love.event.quit()
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      for col = 1, self.side do
        self.level.map[col] = { }
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

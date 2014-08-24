love.conf = function(t)
  t.version = "0.9.1"
  local side = 16 * 48
  do
    local _with_0 = t.window
    _with_0.width = side
    _with_0.height = side
    _with_0.title = "Ludum Dare 30 - fasterthanlime"
    _with_0.borderless = true
    return _with_0
  end
end

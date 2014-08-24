
love.conf = (t) ->
  t.version = "0.9.1"

  side = 16 * 48
  with t.window
    .width = side
    .height = side
    .title = "Ludum Dare 30 - fasterthanlime"
    .borderless = true

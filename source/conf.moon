
love.conf = (t) ->
  t.version = "0.9.1"

  side = 8 * 96
  with t.window
    .width = side
    .height = side
    .title = "Ludum Dare 30 - fasterthanlime"


LD.print_map = ->
  map = LD.world.level.map

  print "World map: "

  for col = 1, 8
    for row = 1, 8
      io.write map[col][row]
    print ""


LD.print_map = function()
  local map = LD.world.level.map
  print("World map: ")
  for col = 1, 8 do
    for row = 1, 8 do
      io.write(map[col][row])
    end
    print("")
  end
end

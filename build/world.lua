local world = {
  pressed = {
    left = false,
    right = false,
    up = false,
    down = false
  },
  player = {
    x = 30,
    y = 30
  },
  level = {
    map = { }
  }
}
for col = 1, 8 do
  world.level.map[col] = { }
end
LD.world = world

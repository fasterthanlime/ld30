local world = {
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
  level = {
    side = 16,
    blocks = { },
    map = { }
  }
}
for col = 1, world.level.side do
  world.level.map[col] = { }
end
LD.world = world

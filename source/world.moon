
world = {
  pressed: {
    left: false
    right: false
    up: false
    down: false
  }

  player: {
    x: 30
    y: 30
  }

  level: {
    map: {}
  }
}

for col = 1, 8
  world.level.map[col] = {}

LD.world = world


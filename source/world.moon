
world = {
  pressed: {
    left: false
    right: false
    up: false
    down: false
  }

  player: {
    col: 1
    row: 1
    x: 0
    y: 0
  }

  level: {
    side: 16
    blocks: {}
    map: {}
  }
}

for col = 1, world.level.side
  world.level.map[col] = {}

LD.world = world



-- imports
world = LD.world
config = LD.config

----------------------------------------------

love.keypressed = (key) ->
  input = config.input.mapping[key]
  if input
    world.pressed[input] = true
    LD.controlpressed(input)
  else
    switch key
      when 'escape'
        love.event.quit()

----------------------------------------------

love.keyreleased = (key) ->
  input = config.input.mapping[key]
  if input
    world.pressed[input] = false

----------------------------------------------



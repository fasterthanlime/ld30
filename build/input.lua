local world = LD.world
local config = LD.config
love.keypressed = function(key)
  local input = config.input.mapping[key]
  if input then
    world.pressed[input] = true
    return LD.controlpressed(input)
  else
    local _exp_0 = key
    if 'escape' == _exp_0 then
      return love.event.quit()
    end
  end
end
love.keyreleased = function(key)
  local input = config.input.mapping[key]
  if input then
    world.pressed[input] = false
  end
end

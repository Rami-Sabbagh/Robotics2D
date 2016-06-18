local Robot = {}

function Robot.forward(tiles)
  local tiles = tiles or 1
  for i=1,tiles do
    coroutine.yield("forward")
  end
end

function Robot.turn_left()
  coroutine.yield("turn_left")
end

function Robot.turn_right()
  coroutine.yield("turn_right")
end

return Robot
local TS = {}

function TS:init()

end

function TS:enter(prev)
  print("Tools Enter")
  love.graphics.setBackgroundColor(25,25,25,0)
end

function TS:leave()

end

function TS:draw()
  print("TS Draw")
end

function TS:update(dt)

end

return TS

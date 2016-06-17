--[[
  Tiled Compiler is an Engine tool for robotics2d to compile Tiled maps to the games map form, 
  It's going to be used temp just soon as the Level Editor get programmed.
]]
local TC = {}

function TC:compileTiled(path)
  local TMap = love.filesystem.load(path)
  
end

return TC
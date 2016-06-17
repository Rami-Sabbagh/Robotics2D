--[[
  Tiled Compiler is an Engine tool for robotics2d to compile Tiled maps to the games map form, 
  It's going to be used temp just soon as the Level Editor get programmed.
]]
local TC = {}

function TC:compileTiled(path)
  local tm = love.filesystem.load(path)()
  local rm, tilesets = {}, {}
  rm.w, rm.h = tm.width, tm.height
  for k,v in ipairs(tm.tilesets) do
    table.insert(tilesets,{name=v.name,firstgid=v.firstgid})
  end
end

return TC
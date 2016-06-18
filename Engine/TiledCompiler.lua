--[[
  Tiled Compiler is an Engine tool for robotics2d to compile Tiled maps to the games map form, 
  It's going to be used temp just soon as the Level Editor get programmed.
  
  Rotation bits:
  1:flipX
  2:flipY
  4:rotate 90
  8:rotate -90
]]

local LuaTable = require("Engine.LuaTable")

local TC = {}

function TC:compileTiled(path,targetpath,dump)
  local tm = love.filesystem.load(path)()
  local rm, tilesets, tiles = {}, {}, {}
  rm.w, rm.h, rm.t, rm.d = tm.width, tm.height, {}, {}
  
  rm.ts = tm.tilewidth
  
  for k,v in ipairs(tm.tilesets) do
    table.insert(tilesets,{name=v.name,firstgid=v.firstgid -1})
  end
  
  local function getTileset(gid)
    for k,v in ipairs(tilesets) do
      if gid <= v.firstgid then
        return v.name, gid-v.firstgid
      end
    end
    return tilesets[#tilesets].name, gid - tilesets[#tilesets].firstgid
  end
  
  for k,layer in ipairs(tm.layers) do
    if layer.type == "tilelayer" and layer.visible then
      local rotData = {}
      for k,gid in ipairs(layer.data) do
        if gid == 0 then
          table.insert(rm.d,0)
          table.insert(rotData,0)
        else
          local rgid, rd, tsname = self:getGID(gid)
          local tsname, ngid = getTileset(rgid)
          local tname = _Tileset[tsname].GIDs[ngid]
          if not tiles[tname] then
            table.insert(rm.t,tname)
            tiles[tname] = #rm.t
          end
          table.insert(rm.d,tiles[tname])
          table.insert(rotData,rd)
        end
      end
      for k, rd in ipairs(rotData) do
        table.insert(rm.d,rd)
      end
    end
  end
  
  if targetpath then
    local code = LuaTable.encode(rm)
    if dump then code = string.dump(code) end
    love.filesystem.write(targetpath,code)
  end
  
  return rm
end

function TC:getGID(gid) --Taken from STI.map.setFlippedGID
  local bit31   = 2147483648
  local bit30   = 1073741824
  local bit29   = 536870912
  local flipX   = false
  local flipY   = false
  local flipD   = false
  local realgid = gid
  
  if realgid >= bit31 then
    realgid = realgid - bit31
    flipX   = not flipX
  end

  if realgid >= bit30 then
    realgid = realgid - bit30
    flipY   = not flipY
  end

  if realgid >= bit29 then
    realgid = realgid - bit29
    flipD   = not flipD
  end
  
  local rot = 0
  
  if flipX then rot = rot + 1 end
  if flipY then rot = rot + 2 end
  
  if flipX then
    if flipY and flipD then
      rot = rot + 4
    elseif flipD then
      rot = rot + 3
    end
  elseif flipY then
    if flipD then
      rot = rot + 4
    end
  elseif flipD then
    rot = rot + 3
  end
  
  return realgid, rot
end

return TC
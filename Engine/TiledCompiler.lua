--[[
  Tiled Compiler is an Engine tool for robotics2d to compile Tiled maps to the game map form,
  It's going to be used temp just soon as the Level Editor get programmed.

  The format of robotics2d map: [shortcut: rm]
  rm.w = The width of the map in tiles.
  rm.h = The height of the map in tiles.
  rm.t = The set of tiles used (Key is id, Value is tile name).
  rm.d = The map data.

  The format of rm data:
  The map size = rm.w*rm.h
  * Every layer take the double size of the map size (Because it's constructed of data & rotation data)
  The layer size = The map size * 2
  The number of the layers in the map: #rm.d/The layer size
  * The layer is constructed of data & rotation data
  The first index of data = LayerID*The LayerSize
  The first index of rotation data = The first index of data + The map size
  * The data contains tileids
  tilename = rm.t[data value]
  * The rotation data holds (filpX,flipY,rotate 90,rotate -90) 4 options, so I stored them in a nibble (half byte)
  if bit.band(rotData,1)==1 then FlipX is true end
  if bit.band(rotData,2)==2 then FlipY is true  end
  if bit.band(rotData,4)==4 then rotate 90 is true end
  if bit.band(rotData,8)==8 then rotate -90 is true end

  Rotation bits:
  1:flipX
  2:flipY
  4:rotate 90
  8:rotate -90
]]

local LuaTable = require("Engine.LuaTable")

local TC = {}

function TC:compileTiled(path,targetpath,dump)
  local tm = love.filesystem.load(path)() --TiledMap
  local rm, tilesets, tiles = {}, {}, {} --RM: Robotics2DMap.
  rm.w, rm.h, rm.t, rm.d = tm.width, tm.height, {}, {} --W: Width, H: Height, T: Tiles (Used Tiles), D: Data

  rm.ts = tm.tilewidth --TS: tilesize

  for k,v in ipairs(tm.tilesets) do
    table.insert(tilesets,{name=v.name,firstgid=v.firstgid -1}) --Copy the tileset, tilesets have name, firstgid.
  end

  --Returns the tileset for the the given id + The id of the tile within the tileset.
  local function getTileset(gid)
    for k,v in ipairs(tilesets) do
      if gid <= v.firstgid then
        return v.name, gid-v.firstgid
      end
    end
    return tilesets[#tilesets].name, gid - tilesets[#tilesets].firstgid
  end

  for k,layer in ipairs(tm.layers) do --Loop throw the layers of the tiled map.
    if layer.type == "tilelayer" and layer.visible then --Filter to accept only visible tile layers.
      local rotData = {} --Rotation Data
      for k,gid in ipairs(layer.data) do --Loop throw the gids of the tiles in the layar data.
        if gid == 0 then --0 means no tile.
          table.insert(rm.d,0) --Store the tiles data in seperate tables, gid, rotdata.
          table.insert(rotData,0)
        else
          local rgid, rd, tsname = self:getGID(gid) --rgid: Real gid, rd: Rotation Data, tsname: TilesetName
          local tsname, ngid = getTileset(rgid) --ngid: New gid.
          local tname = _Tileset[tsname].GIDs[ngid] --Get the tile name from the gid.
          if not tiles[tname] then --If the tile is not added before
            table.insert(rm.t,tname) --Add it to the map.
            tiles[tname] = #rm.t --And add it to a local table for making writing maps easier.
          end
          table.insert(rm.d,tiles[tname]) --Add the tile id to the data array.
          table.insert(rotData,rd) --Add the rotation data of the tile to the rotation data array.
        end
      end
      for k, rd in ipairs(rotData) do
        table.insert(rm.d,rd) --Now merge the rotation data with the data array.
      end
    end
  end

  --If saving path specified, encode the map using LuaTable
  if targetpath then
    local code = LuaTable.encode(rm)
    if dump then code = string.dump(code) end
    love.filesystem.write(targetpath,code)
  end

  return rm --Also return the loaded map array.
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

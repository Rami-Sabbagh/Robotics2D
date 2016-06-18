require("love.image")
require("love.filesystem")

local JSON = require("Helpers.json")

local TCH = love.thread.getChannel("TargetTSJ")

while true do
  local tsName = TCH:pop() if not tsName then break end
  local tSize = TCH:demand()
  
  local TiCH = love.thread.getChannel("TilesTSJ_"..tsName)
  local TinCH = love.thread.getChannel("TilesNamesTSJ_"..tsName)
  
  local tiles = {}
  local tNames = {}
  while true do
    local tile = TiCH:demand()
    if not tile then break end
    table.insert(tiles,tile)
    table.insert(tNames,TinCH:demand())
  end
  
  local tNum = #tiles
  
  local tsWidth = math.floor(math.sqrt(tNum))
  local tsHeight = tNum % tsWidth > 0 and math.floor(tNum/tsWidth)+1 or tNum/tsWidth
  
  local tsData = {TileSize = tSize,TilesetWidth=tsWidth,TilesetHeight=tsHeight,Tiles={},GIDs={}}
  local ts = love.image.newImageData(tsWidth*tSize,tsHeight*tSize)
  
  for k, tile in ipairs(tiles) do
    local tn = k-1
    local tx = (tn % tsWidth)*tSize
    local ty = math.floor(tn/tsWidth)*tSize
    for x=0, tile:getWidth()-1 do
      for y=0, tile:getHeight()-1 do
        ts:setPixel(tx+x,ty+y,tile:getPixel(x,y))
      end
    end
    tsData.Tiles[tsName.."_"..tNames[k]] = {x=tx,y=ty,tx=tx/tSize +1,ty=ty/tSize +1}
  end
  
  for k,v in ipairs(tNames) do
    tsData.GIDs[k] = tsName.."_"..v
  end
  
  love.filesystem.write("/TSB/"..tsName..".tsb",JSON:encode_pretty(tsData))
  ts:encode("png","/TSB/"..tsName..".png")
end
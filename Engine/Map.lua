local Class = require("Helpers.middleclass")
local Map = Class("map.base")

local TilesSystem = require("Engine.TilesSystem")

local bit = require("bit")

function Map:initialize(data)
  print("Loading Map")
  self.Tiles = data.t
  self.Width, self.Height, self.Tilesize = data.w, data.h, data.ts
  self.Layers = {}
  
  local CL = {}
  local CLR = {}
  local LSize = self.Width*self.Height
  
  --Extract the data to Layers and Rotation Data Layers
  for i=0, (#data.d/(LSize*2))-1 do
    CL[i+1] = {}
    CLR[i+1] = {}
    for n=1,LSize do
      CL[i+1][n] = data.d[i*LSize*2 + n]
      CLR[i+1][n] = data.d[i*LSize*2 + n + LSize]
    end
  end
  
  --Translate Tiles Ids to Tiles Names
  for k, layer in ipairs(CL) do
    self.Layers[k] = {}
    for y=1, self.Height do
      for x=1, self.Width do
        if layer[((y-1)*self.Width)+x] > 0 then
          local tname = self.Tiles[layer[((y-1)*self.Width)+x]]
          local rotData = CLR[k][((y-1)*self.Width)+x]
          local rot, inX, inY = 0
          if bit.band(rotData,1)==1 then inX = true end
          if bit.band(rotData,2)==2 then inY = true end
          if bit.band(rotData,4)==4 then rot = math.rad(90) end
          if bit.band(rotData,8)==8 then rot = math.rad(-90) end
          if TilesSystem.Tiles[tname] then
            table.insert(self.Layers[k],TilesSystem:newTile(tname,x-1,y-1,self.Tilesize,rot,inX,inY))
          end
        end
      end
    end
  end
end

function Map:draw()
  for k,layer in ipairs(self.Layers) do
    for n,tile in ipairs(layer) do
      if tile and tile.draw then tile:draw() end
    end
  end
end

function Map:update(dt)
  for k,layer in ipairs(self.Layers) do
    for n,tile in ipairs(layer) do
      if tile and tile.update then tile:update(dt) end
    end
  end
end

return Map
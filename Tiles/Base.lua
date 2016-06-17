local Class = require("Helpers.middleclass")
local TBase = Class("tile.base")

function TBase:initialize(tx,ty,tsize)
  self.tx, self.ty, self.ts = x or 0, y or 0, tsize or 32
  self.x, self.y = self.tx * self.ts, self.ty * self.ts
end

function TBase:draw()
  
end

function TBase:update(dt)
  
end

function TBase:buildSpritebatch()
  
end

return TBase
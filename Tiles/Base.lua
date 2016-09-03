local Class = require("Helpers.middleclass")
local TBase = Class("tile.base")

function TBase:initialize(tx,ty,tsize,rot,invertX,invertY,params)
  self.tx, self.ty, self.ts = tx or 0, ty or 0, tsize or 32
  self.x, self.y = self.tx * self.ts, self.ty * self.ts
  self.rot, self.inX, self.inY = rot or 0, invertX, invertY
  self.tileset = params.tileset
  self.tileimage = _Images[params.tileimage or "Null"]
  self.sx, self.sy = self.ts/self.tileimage:getWidth(), self.ts/self.tileimage:getHeight()
  self.sx, self.sy = self.inX and -self.sx or self.sx, self.inY and -self.sy or self.sy
end

function TBase:draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.tileimage,self.x+self.ts/2,self.y+self.ts/2,self.rot,invertX and -self.sx or self.sx,invertY and -self.sy or self.sy,self.tileimage:getWidth()/2, self.tileimage:getHeight()/2)
end

function TBase:update(dt)

end

function TBase:buildSpritebatch()

end

return TBase

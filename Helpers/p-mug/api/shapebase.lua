local Path = string.sub(..., 1, -string.len(".api.shapebase"))
local Class = require(Path..".third-party.middleclass")

local SBase = Class("shape.base") SBase.PMUGS = true --P-Mug Shape Class

function SBase:initialize()
  self.hovered = false
  self.down = false
  self.drawingArgs = {}
end

function SBase:isDown(isDown,dx,dy)
  if type(isDown) == "boolean" then
    self.down, self.dx, self.dy = isDown, dx, dy
    return self
  end
  return self.down, self.dx, self.dy
end

function SBase:isHovered(isHovered,hx,hy)
  if type(isHovered) == "boolean" then
    self.hovered, self.hx, self.hy = isHovered, hx, hy
    return self
  end
  return self.hovered, self.hx, self.hy
end

function SBase:setProperties()
  
end

function SBase:getProperties()
  return nil
end

function SBase:setDrawingArgs(...)
  self.drawingArgs = {...}
  return self
end

function SBase:getDrawingArgs()
  return unpack(self.drawingArgs)
end

--Return the shape type.
function SBase:getType()
  return "base"
end

--Return the drawtype of the shape. Refer to the drawer you are using.
function SBase:getDType(...)
  return "none"
end

--Can be used for making affects.
function SBase:update(dt)
  
end

--Returns the points of the bounding box for the transformed shape.
function SBase:computeAABB()
  return 0,0,0,0
end

--Checks whether a point lies inside the shape.
function SBase:testShape(x,y)
  return false
end

return SBase
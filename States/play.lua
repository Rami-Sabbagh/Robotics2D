
local STI = require("Helpers.STI")
local bump = require("Helpers.bump")
local tween = require("Helpers.tween")

require 'Helpers.middleclass'
local gamera     = require 'Helpers.gamera'
local shakycam   = require 'Helpers.shakycam'
local media      = require 'Engine.Media'
local Map        = require 'Engine.Map'

local Play = {}

function Play:init()
  media.load()

  
end

function Play:enter()
  self.lightworld = love.light.newWorld()
  self.lightworld.setAmbientColor(5,5,5)
  --self.lightworld.setAmbientColor(15, 15, 31)
  self.lightworld.setRefractionStrength(32.0)
  
  local width, height = _Width, _Height
  local gamera_cam = gamera.new(0,0, width, height)
  self.camera = shakycam.new(gamera_cam)
  self.world  = Map:new(width, height, self.camera,self.lightworld)
  
  self.map = STI.new("/Maps/Main.lua",{ "bump", "light" })
  
  self.map:light_init(self.lightworld)
  self.map:bump_init(self.world.world)
end

function Play:draw()
  self.lightworld.update()
  
  love.postshader.setBuffer("render")
  
  self.map:draw()
  
  if not _DebugKey then
    self.camera:draw(function(l,t,w,h)
      self.world:draw(_DebugKey, l,t,w,h)
    end)
  end
  
  self.lightworld.drawShadow()
  
  
  --Draw Players
  
  self.lightworld.drawShine()
  self.lightworld.drawPixelShadow()
  self.lightworld.drawGlow()
  self.lightworld.drawRefraction()
  self.lightworld.drawReflection()
  
  love.postshader.draw()
  
  if _DebugKey then
    self.camera:draw(function(l,t,w,h)
      self.world:draw(_DebugKey, l,t,w,h)
    end)
  end
end

function Play:update(dt)
  media.cleanup()
  self.map:update(dt)
  
  self.world:update(dt)
  self.camera:update(dt)
end

function Play:leave()
  self.world, self.map, self.lightworld = nil, nil, nil
end

function Play:debugBump()
  local function getCellRect(world, cx,cy)
    local cellSize = world.cellSize
    local l,t = world:toWorld(cx,cy)
    return l,t,cellSize,cellSize
  end
  
  for cy, row in pairs(self.world.rows) do
   for cx, cell in pairs(row) do
     local l,t,w,h = getCellRect(self.world, cx,cy)
     local intensity = cell.itemCount * 16 + 16
     love.graphics.setColor(255,255,255,intensity)
     love.graphics.rectangle('fill', l,t,w,h)
     love.graphics.setColor(255,255,255,10)
     love.graphics.rectangle('line', l,t,w,h)
    end
  end
end

return Play
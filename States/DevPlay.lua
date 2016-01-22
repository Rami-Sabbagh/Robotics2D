local BumpDebug = require("Helpers.bump_debug")
local Gamera = require("Helpers.gamera")
local Tweens = require("Helpers.tween")
local Bump = require("Helpers.bump")

local DevPlay = {}

function DevPlay:init()
  self.fadingTime = 0.5
  self.showTime = 1
end

function DevPlay:enter()
  love.graphics.setBackgroundColor(75,75,75,255)
  
  local Map = _Maps["Level1"] Map.bump = Bump.newWorld(16) Map:robotics_init(Map.bump)
  self.camera = Gamera.new(0,0,Map.width*Map.tilewidth,Map.height*Map.tileheight)
  self.camera:setPosition((Map.width*Map.tilewidth)/2, (Map.height*Map.tileheight)/2)
  self.camera:setScale(4.0)
  
  self.alpha = {255}
  self.tween = Tweens.new(self.fadingTime,self.alpha,{0})
end

function DevPlay:draw()
  --love.graphics.push() love.graphics.translate((_Width-(Map.width*Map.tilewidth))/4,(_Height-(Map.height*Map.tileheight))/4) love.graphics.scale(4,4)
  self.camera:draw(function()
    _Maps["Level1"]:draw()
    BumpDebug.draw(_Maps["Level1"].bump)
    self:debugBump(_Maps["Level1"].bump)
  end)
  --love.graphics.pop()
  love.graphics.setColor(0,0,0,self.alpha[1])
  love.graphics.rectangle("fill",0,0,_Width,_Height)
end

function DevPlay:debugBump(world)
  for k, rect in pairs(world.rects) do--.rects[item] = {x=x,y=y,w=w,h=h})
    love.graphics.setColor(255,0,0,50)
    love.graphics.rectangle("fill",rect.x,rect.y,rect.w,rect.h)
    love.graphics.setColor(255,0,0,75)
    love.graphics.setLineStyle("rough") love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",rect.x,rect.y,rect.w,rect.h)
  end
end

function DevPlay:update(dt)
  self.tween:update(dt)
end

function DevPlay:leave()
  
end

return DevPlay
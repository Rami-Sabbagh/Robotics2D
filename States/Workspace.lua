local DTools = require("Engine.DebugTools")

local LuaTable = require("Engine.LuaTable")
local BumpDebug = require("Helpers.bump_debug")
local Gamestate = require("Helpers.hump.gamestate")
local Gamera = require("Helpers.gamera")
local Tweens = require("Helpers.tween")
local Bump = require("Helpers.bump")

local Map = require("Engine.Map")

local Material = require("Helpers.p-mug.third-party.material-love")

local WS = {}

function WS:loadMap(path)
  local MapCodeString = love.filesystem.read(path)
  self.MapData = LuaTable.decode(MapCodeString,true)
  self.Map = Map(self.MapData)
  self.Camera = Gamera.new(0,0,self.Map.Width*self.Map.Tilesize,self.Map.Height*self.Map.Tilesize)
  self.Camera:setPosition((self.Map.Width*self.Map.Tilesize)/2, (self.Map.Height*self.Map.Tilesize)/2)
  self.Camera:setScale(2.0)
end

function WS:reloadMap()
  if self.MapData then
    self.Map = Map(self.MapData)
    self.Camera = Gamera.new(0,0,self.Map.Width*self.Map.Tilesize,self.Map.Height*self.Map.Tilesize)
    self.Camera:setPosition((self.Map.Width*self.Map.Tilesize)/2, (self.Map.Height*self.Map.Tilesize)/2)
    self.Camera:setScale(2.0)
  end
end

function WS:unloadMap()
  self.MapData, self.Map, self.Camera = nil, nil, nil
end

function WS:isMapLoaded()
  if self.Map then return true else return false end
end

function WS:getMap()
  return self.Map
end

function WS:init()
  self.fadingTime = 0.5
  self.showTime = 10
end

function WS:enter()
  love.graphics.setBackgroundColor(Material.colors.background("dark"))

  self.alpha = {0}
  self.tween = Tweens.new(skiptween and 0.001 or self.fadingTime,self.alpha,{0})
  self.active = true
end

function WS:leave()
  self.active = false
end

function WS:draw()
  love.graphics.setColor(0,0,0,self.alpha[1])
  love.graphics.rectangle("fill",0,0,_Width,_Height)

  if self.Map and self.Camera then
    self.Camera:draw(function()
      self.Map:draw()
    end)
  end

  love.graphics.setColor(255,255,255,255)

  if not _DebugTools then return end

  -- Menu
  if imgui.BeginMainMenuBar() then
    DTools:createMenus()

    imgui.EndMainMenuBar()
  end

  DTools:createWindows()

  imgui.Render();
end

function WS:update(dt)
  if self.Map then self.Map:update(dt) end
  self.tween:update(dt)
end

function WS:debugBump(world)
  for k, rect in pairs(world.rects) do--.rects[item] = {x=x,y=y,w=w,h=h})
    love.graphics.setColor(255,0,0,50)
    love.graphics.rectangle("fill",rect.x,rect.y,rect.w,rect.h)
    love.graphics.setColor(255,0,0,75)
    love.graphics.setLineStyle("rough") love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",rect.x,rect.y,rect.w,rect.h)
  end
end

return WS

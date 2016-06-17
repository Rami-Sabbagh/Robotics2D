--This file is part of Robotics2D--
local Loading = {} --(LibLoader) Shortcut--

--Requirements--
local Gamestate = require("Helpers.hump.gamestate")
local Timer = require("Helpers.hump.timer")
local Tweens = require("Helpers.tween")
local loader = require("Helpers.love-loader")

local TSSystem = require("Engine.TilesetSystem")

local Material = require("Helpers.p-mug.third-party.material-love")

local DevPlay = require("States.DevPlay")

function Loading:init()
  self.fadingTime = 0.5
  self.text = "[text]"
  
  self:indexDirectory("/Libs/")
  
  loader.start(function()
    _Loading = false
    self.text = "Building Tilesets..."
    TSSystem:buildTilesets("/Libs/",function()
      self.text = "Press any key to continue"
      _Loaded = true
    end)
  end)
end

function Loading:getType(e)
  if e == "png" or e == "jpg" then
    return "image"
  end
end

function Loading:indexDirectory(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,filename in ipairs(files) do
    if love.filesystem.isDirectory(dir..filename) then
      self:indexDirectory(dir..filename.."/")
    else
      local p, n, e = self:splitFilePath(dir..filename)
      local type = self:getType(e)
      if type == "image" then
        loader.newImage(_Images, n, dir..filename)
        _Loading = true
      end
    end
  end
end

function Loading:splitFilePath(path)
  local p, n, e = path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
  return p, n:sub(1, -e:len()-2), e
end

function Loading:enter()
  self.alpha = {255}
  self.tween = Tweens.new(self.fadingTime,self.alpha,{0})
  
  love.graphics.setBackgroundColor(Material.colors.background("dark"))
end

function Loading:update(dt)
  if _Loading then
    self.text = "Loading "..math.floor((loader.loadedCount / loader.resourceCount)*100).."%"
  elseif not _Loaded then
    TSSystem:update()
  end
  
  self.tween:update(dt)
  Timer.update(dt)
  if not _Loaded then loader.update() end
end

function Loading:draw()
  local TextPadding = 25
  love.graphics.setColor(Material.colors.mono("white","title"))
  love.graphics.setFont(Material.roboto.title)
  local TextWidth, TextHeight = Material.roboto.title:getWidth(self.text), Material.roboto.title:getHeight(self.text)
  love.graphics.print(self.text,_Width-(TextWidth+TextPadding),_Height-(TextHeight+TextPadding))
  
  --Fade--
  love.graphics.setColor(0,0,0,self.alpha[1])
  love.graphics.rectangle("fill",0,0,_Width,_Height)
end

function Loading:leave()
  print("Loading Leaved") --DEBUG
end

function Loading:LibFolder(dir)
  Loader:LoadFolder(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,file in pairs(files) do
    if love.filesystem.isDirectory(dir..file) then
      self:LibFolder(dir..file.."/")
    end
  end
end

function Loading:keypressed()
  if not _Loaded or self.exiting then return end
  self.tween = Tweens.new(self.fadingTime,self.alpha,{255})
  Timer.add(self.fadingTime,function() Gamestate.switch(DevPlay) end)
  self.exiting = true
end

return Loading
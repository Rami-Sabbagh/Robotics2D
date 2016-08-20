--This file is part of Robotics2D--
local Splash = {} --(LibLoader) Shortcut--

--Requirements--
local DTools = require("Engine.DebugTools")

local Gamestate = require("Helpers.hump.gamestate")
local Timer = require("Helpers.hump.timer")
local Tweens = require("Helpers.tween")
local loader = require("Helpers.love-loader")

local JSON = require("Helpers.json")

local TilesSystem = require("Engine.TilesSystem")
local TSSystem = require("Engine.TilesetSystem")

local Material = require("Helpers.p-mug.third-party.material-love")

local NextState = require("States.Workspace")

function Splash:init()
  self.LOGO = love.graphics.newImage("Libs/Misc/RL4G_LOGO.png")

  self.fadingTime = 0.5
  self.showTime = 1
  Timer.add(self.fadingTime+self.showTime,function()
    if _Loaded then
      self.tween = Tweens.new(self.fadingTime,self.alpha,{0,0})
      Timer.add(self.fadingTime,function() Gamestate.switch(NextState) end)
      self.exiting = true
    else
      self.allowExit = true
    end
  end)

  self.text = "(1/3) Loading ..."

  self.showPrecentage = "(1/3) Loading "

  self:indexDirectory("/Libs/")

  loader.start(function()
    self.showPrecentage = false
    self.text = "(2/3) Building Tilesets ..."
    TSSystem:buildTilesets("/Libs/",function()
      self.text = "(3/3) Loading Tilesets ..."
      self.showPrecentage = "(3/3) Loading Tilesets "
      self:indexDirectory("/TSB/")
      TilesSystem:loadLuaTiles("Tiles/")
      TilesSystem:loadTiles("Libs/")
      loader.start(function()
        self.showPrecentage = false
        self.text = ""
        _Loaded = true
      end)
    end)
  end)
end

function Splash:getType(e)
  if e == "png" or e == "jpg" then
    return "image"
  elseif e == "tsb" then
    return "TilesetBuild"
  end
end

function Splash:indexDirectory(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,filename in ipairs(files) do
    if love.filesystem.isDirectory(dir..filename) then
      self:indexDirectory(dir..filename.."/")
    else
      local p, n, e = self:splitFilePath(dir..filename)
      local type = self:getType(e)
      if type == "image" then
        loader.newImage(_Images, n, dir..filename)
      elseif type == "TilesetBuild" then
        _Tileset[n] = JSON:decode(love.filesystem.read(dir..filename))
      end
    end
  end
end

function Splash:splitFilePath(path)
  local p, n, e = path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
  return p, n:sub(1, -e:len()-2), e
end

function Splash:enter()
  self.alpha = {255,255}
  self.tween = Tweens.new(self.fadingTime,self.alpha,{0,255})

  love.graphics.setBackgroundColor(Material.colors.background("dark"))
end

function Splash:update(dt)
  if self.showPrecentage then
    self.text = self.showPrecentage..math.floor((loader.loadedCount / loader.resourceCount)*100).."%"
  end

  if not _Loaded then TSSystem:update() loader.update() elseif self.allowExit and not self.exiting then
    self.tween = Tweens.new(self.fadingTime,self.alpha,{255})
    Timer.add(self.fadingTime,function() Gamestate.switch(DevPlay) end)
  end

  self.tween:update(dt)
  Timer.update(dt)
end

function Splash:draw()
  love.graphics.setColor(255,255,255,self.alpha[2])
  love.graphics.draw(self.LOGO,_Width/2,_Height/2,0,1,1,self.LOGO:getWidth()/2,self.LOGO:getHeight()/2)

  local XPadding, YPadding = 20,15
  --love.graphics.setColor(Material.colors.mono("white","button"))
  love.graphics.setColor(Material.colors.main("blue-grey"))
  love.graphics.setFont(Material.roboto.button)
  local TextWidth, TextHeight = Material.roboto.button:getWidth(self.text), Material.roboto.button:getHeight(self.text)
  love.graphics.print(self.text,_Width-(TextWidth+XPadding),_Height-(TextHeight+YPadding))

  --Fade--
  love.graphics.setColor(0,0,0,self.alpha[1])
  love.graphics.rectangle("fill",0,0,_Width,_Height)

  love.graphics.setColor(255,255,255,255)

  if not _DebugTools then return end

  -- Menu
  if imgui.BeginMainMenuBar() then
    DTools:createMenus()
    imgui.EndMainMenuBar()
  end

  DTools:createToolsWindows()

  imgui.Render();
end

function Splash:leave()
  print("Loading Leaved") --DEBUG
end

function Splash:LibFolder(dir)
  Loader:LoadFolder(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,file in pairs(files) do
    if love.filesystem.isDirectory(dir..file) then
      self:LibFolder(dir..file.."/")
    end
  end
end

return Splash

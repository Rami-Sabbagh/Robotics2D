--This file is part of PixelizerBox--
--[[
  * Copyright 2015 RamiLego4Game
  * 
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  * 
  *     http://www.apache.org/licenses/LICENSE-2.0
  * 
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
--]]

local Loading = {} --(LibLoader) Shortcut--

--Requirements--
local Gamestate = require("Helpers.hump.gamestate")
local Timer = require("Helpers.hump.timer")
local Tweens = require("Helpers.tween")
local loader = require("Helpers.love-loader")

local DevPlay = require("States.DevPlay")

function Loading:init()
  --Loader:init({_Images,_Sounds,_Fonts,_ImageDatas,_rawJData,_rawINIData,_Maps})
  self.fadingTime = 0.5
  
  self:indexDirectory("/Libs/")
  
  loader.start(function() _Loaded = true end)
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
      end
    end
  end
end

function Loading:splitFilePath(path)
  local p, n, e = path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
  return p, n:sub(1, -e:len()), e
end

function Loading:enter()
  print("Loading Entered") --DEBUG
  self.alpha = {255}
  self.tween = Tweens.new(self.fadingTime,self.alpha,{0})
  
  self.robot = love.graphics.newImage("/Libs/Misc/Robot.png")
  self.robotout = love.graphics.newImage("/Libs/Misc/RobotOutline.png")
  
  love.graphics.setBackgroundColor(255,255,255,255)
end

function Loading:update(dt)
  self.tween:update(dt)
  Timer.update(dt)
  if not _Loaded then loader.update() end
end

function Loading:draw()
  local LE = (_Width/3)/self.robot:getWidth()
  love.graphics.setColor(255,255,255,255)
  --self.sheet:draw("RobotOutline",_Width/4,_Height/2,0,25,25,11,11)
  love.graphics.draw(self.robotout,_Width/4,_Height/2,0,(_Width/3)/self.robotout:getWidth(),(_Width/3)/self.robotout:getHeight(),self.robotout:getWidth()/2,self.robotout:getHeight()/2)
  
  local height = math.floor((loader.loadedCount / loader.resourceCount)*self.robot:getHeight()*LE)
  
  love.graphics.stencil(function() love.graphics.rectangle("fill",0,_Height/2+(self.robot:getHeight()*0.5*LE),_Width/2,-height) end)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.draw(self.robot,_Width/4,_Height/2,0,LE,LE,self.robot:getWidth()/2,self.robot:getHeight()/2)
  --self.sheet:draw("Robot_Normal",_Width/4,_Height/2,0,25,25,10,10)
  love.graphics.setStencilTest()
  
  love.graphics.setFont(_PixelFont[18])
  love.graphics.setColor(75,75,75,255)
  
  local text = "Robotics2D V".._Version.."\n".._State.."\n"
  for i=0,text:len()-14 do text = text.."-" end
  if not _Loaded then
    text = text.."\n Loading "..math.floor((loader.loadedCount / loader.resourceCount)*100).."%"
  else
    text = text.."\n\nPress any key to continue"
  end
  
  love.graphics.printf(text,_Width/2,_Height/4-75,_Width/2,"center")
  
  love.graphics.setColor(200,0,0,255)
  
  love.graphics.printf("Important ! This game development have been stopped because of schools start,The development will restart at the end of them.\n\nThe game is licensed under apache license v2.0 so do what you want with it. ",_Width/2,_Height/2-50,_Width/2,"center")
  
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
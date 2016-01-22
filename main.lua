io.stdout:setvbuf("no") _Version = "0.0.1 B0" _State = "WIP"

local LoveGlass = require("Helpers.loveglass")
local GameSetup = require("Engine.SetupGame")
local Gamestate = require("Helpers.hump.gamestate")
local Splash = require("States.Splash")

function love.load(args)
  GameSetup:init()
  
  love.graphics.setBackgroundColor(250,250,250)
  LoveGlass.GlassUtil:LoadViewsDir("/views/")
  --LoveGlass.GlassUtil:setActiveView("Main")
  LoveGlass.event("Main","Exit","Clicked",function() love.event.quit() end)
  
  Gamestate.registerEvents()
  Gamestate.switch(Splash)
end

function love.update(dt)
  LoveGlass.update(dt)
end

function love.draw()
  LoveGlass.draw()
end

function love.mousepressed(x,y,button,istouch)
  LoveGlass.mousepressed(x,y,button,istouch)
end

function love.mousereleased(x,y,button,istouch)
  LoveGlass.mousereleased(x,y,button,istouch)
end

function love.keypressed(key,isrepeat)
  LoveGlass.keypressed(key,isrepeat)
end

function love.keyreleased(key)
  LoveGlass.keyreleased(key)
end

function love.textinput(text)
  LoveGlass.textinput(text)
end
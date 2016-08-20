io.stdout:setvbuf("no")
require("imgui")

--love.filesystem.write("DumpTest.lua",string.dump(love.filesystem.load("/Libs/Levels/Dev.lua")))

local GameSetup = require("Engine.SetupGame")
local Gamestate = require("Helpers.hump.gamestate")
local Splash = require("States.Splash")

function love.load(args)
  GameSetup:init()

  love.graphics.setBackgroundColor(250,250,250)

  Gamestate.registerEvents()
  Gamestate.switch(Splash)
end

function love.update(dt)
  imgui.NewFrame()
end

function love.draw()
  print("MainDraw")
  love.graphics.setColor(255,255,255,255)

  -- Menu
  if imgui.BeginMainMenuBar() then
      if imgui.BeginMenu("File") then
          imgui.MenuItem("Test")
          imgui.EndMenu()
      end
      imgui.EndMainMenuBar()
  end

  imgui.Render();
end

function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keypressed(key)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.threaderror(thread, errorstr)
  error("Thread error!\n"..errorstr)
  -- thread:getError() will return the same error string now.
end

function love.quit()
  imgui.ShutDown()
end

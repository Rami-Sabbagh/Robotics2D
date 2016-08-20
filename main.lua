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

  if not _DebugTools then return end
  imgui.NewFrame()
end

function love.draw()

end

function love.textinput(t)
  if not _DebugTools then return end

  imgui.TextInput(t)
  if not imgui.GetWantCaptureKeyboard() then
      -- Pass event to the game
  end
end

function love.keypressed(key)
  if not _DebugTools then return end

  imgui.KeyPressed(key)
  if not imgui.GetWantCaptureKeyboard() then
    -- Pass event to the game
  end
end

function love.keyreleased(key)
  if not _DebugTools then return end

  imgui.KeyReleased(key)
  if not imgui.GetWantCaptureKeyboard() then
      -- Pass event to the game
  end
end

function love.mousemoved(x, y)
  if not _DebugTools then return end

  imgui.MouseMoved(x, y)
  if not imgui.GetWantCaptureMouse() then
      -- Pass event to the game
  end
end

function love.mousepressed(x, y, button)
  if not _DebugTools then return end

  imgui.MousePressed(button)
  if not imgui.GetWantCaptureMouse() then
      -- Pass event to the game
  end
end

function love.mousereleased(x, y, button)
  if not _DebugTools then return end

  imgui.MouseReleased(button)
  if not imgui.GetWantCaptureMouse() then
      -- Pass event to the game
  end
end

function love.wheelmoved(x, y)
  if not _DebugTools then return end
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
  if not _DebugTools then return end
  imgui.ShutDown()
end

local DT = {}

local FPSMax = 500
local FPSSize = 1000
local FPS = {}
for i=1, FPSSize do FPS[i] = 0 end

local ShowTCWindow = false

local ShowLogsWindow = false
local ShowFPSOverlay = false
local ShowImguiDemoWindow = false

function DT:updateFPS(fps)
  for k, v in ipairs(FPS) do
    if k == FPSSize then
      FPS[k] = fps--math.random(1,255)
    else
      FPS[k] = FPS[k+1]
    end
  end
end

function DT:createMenus()
  if _Loaded then self:createGameMenu() end
  self:createToolsMenu()
  self:createDebugMenu()
end

function DT:createGameMenu()
  if imgui.BeginMenu("Game") then
      self:insertMenuGames()
      imgui.EndMenu()
  end
end

function DT:createToolsMenu()
  if imgui.BeginMenu("Tools") then
      self:insertMenuTools()
      imgui.EndMenu()
  end
end

function DT:createDebugMenu()
  if imgui.BeginMenu("Debug") then
      self:insertMenuDebugs()
      imgui.EndMenu()
  end
end

function DT:insertMenuGames()
  imgui.MenuItem("Load")
end

function DT:insertMenuTools()
  if _Loaded then
    if imgui.MenuItem("Tiled Compiler",false,ShowTCWindow) then ShowTCWindow = not ShowTCWindow end
  end
end

function DT:insertMenuDebugs()
  if imgui.MenuItem("Logs",false,ShowLogsWindow) then ShowLogsWindow = not ShowLogsWindow end
  if imgui.MenuItem("FPS",false,ShowFPSOverlay) then ShowFPSOverlay = not ShowFPSOverlay end
  if imgui.MenuItem("Imgui Demo",false,ShowImguiDemoWindow) then ShowImguiDemoWindow = not ShowImguiDemoWindow end
end

function DT:createWindows()
  self:createToolsWindows()
  self:createDebugWindows()
end

function DT:createToolsWindows()
  if ShowTCWindow then
    imgui.Begin("Tiled Compiler")

    imgui.End()
  end
end

function DT:createDebugWindows()
  if ShowImguiDemoWindow then
    ShowImguiDemoWindow = imgui.ShowTestWindow(true)
  end

  if ShowFPSOverlay then
    local PX, PY, W, H, IPX, IPY = 15,15, 180, 50, 15, 30
    imgui.SetNextWindowPos(PX, _Height-(PY+H), "FirstUseEver")
    imgui.SetNextWindowSize(W,H, "FirstUseEver")
    imgui.Begin("FPS", false, {"NoTitleBar","NoResize","NoMove","NoSavedSettings"})
    imgui.Text("FPS: "..love.timer.getFPS())
    self:updateFPS(love.timer.getFPS())
    imgui.PlotLines("",FPS,FPSSize,0,"",0,FPSMax,W-IPX,H-IPY)
    imgui.End()
  end
end

return DT

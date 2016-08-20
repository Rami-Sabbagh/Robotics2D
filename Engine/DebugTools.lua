local DT = {}

local ShowLogsWindow = false
local ShowFPSOverlay = false
local ShowImguiDemoWindow = false

function DT:createMenus()
  self:createToolsMenu()
  self:createDebugMenu()
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

function DT:insertMenuTools()
  if _Loaded then
    imgui.MenuItem("Tiled Compiler")
  end
end

function DT:insertMenuDebugs()
  if imgui.MenuItem("Logs",false,ShowLogsWindow) then ShowLogsWindow = not ShowLogsWindow end
  if imgui.MenuItem("FPS",false,ShowFPSOverlay) then ShowFPSOverlay = not ShowFPSOverlay end
  if imgui.MenuItem("Imgui Demo",false,ShowImguiDemoWindow) then ShowImguiDemoWindow = not ShowImguiDemoWindow end
end

function DT:createToolsWindows()
  if ShowImguiDemoWindow then
    ShowImguiDemoWindow = imgui.ShowTestWindow(true)
  end

  if ShowFPSOverlay then
    local PX, PY, W, H = 15,15, 200, 30
    imgui.SetNextWindowPos(PX, _Height-(PY+H), "FirstUseEver")
    imgui.SetNextWindowSize(W,H, "FirstUseEver")
    imgui.Begin("FPS", false, {"NoTitleBar","NoResize","NoMove","NoSavedSettings"})
    imgui.Text("FPS: "..love.timer.getFPS())
    imgui.End()
  end
end

return DT

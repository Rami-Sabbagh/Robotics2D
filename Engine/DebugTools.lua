local DT = {}

local ShowLogsWindow = false
local ShowImguiTestWindow = false

function DT:createToolsMenu()
  if imgui.BeginMenu("Tools") then
      self:insertMenuTools()
      imgui.EndMenu()
  end
end

function DT:insertMenuTools()
  if imgui.MenuItem("Logs",false,ShowLogsWindow) then ShowLogsWindow = not ShowLogsWindow end
  if _Loaded then
    imgui.MenuItem("Tiled Compiler")
  end
  if imgui.MenuItem("Imgui Test",false,ShowImguiTestWindow) then ShowImguiTestWindow = not ShowImguiTestWindow end
end

function DT:createToolsWindows()
  if ShowImguiTestWindow then
    imgui.ShowTestWindow()
  end
end

return DT

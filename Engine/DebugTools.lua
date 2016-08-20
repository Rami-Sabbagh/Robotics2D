local DT = {}

local ShowLogsWindow = false

function DT:createToolsMenu()
  if imgui.BeginMenu("Tools") then
      self:insertMenuTools()
      imgui.EndMenu()
  end
end

function DT:insertMenuTools()
  if imgui.MenuItem("Logs") then ShowLogsWindow = not ShowLogsWindow end
  if _Loaded then
    imgui.MenuItem("Tiled Compiler")
  end
end

return DT

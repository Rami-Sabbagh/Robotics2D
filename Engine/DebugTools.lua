local DT = {}

local FPSMax = 500
local FPSSize = 1000
local FPS = {}
for i=1, FPSSize do FPS[i] = 0 end

local TiledPath = "/Maps/Tiled/"
local MapsPath = "/TiledBuilds/"

--[[local ShowLSWindow = false
local SelectedLSFile = 0
local LSFiles = {}

local ShowTCWindow = false
local TCompiler = require("Engine.TiledCompiler")
local CurrentTCState = "Select A map to\nshow info"
local SelectedTCFile = 0
local TCFiles = {}]]

local ShowLSWindow = false
local CurrentLSState = "Select A map to\nshow info"

local SelectedLevelID = 0
local LevelsList = {}
local LevelsFileNames = {}
local TiledFileNames = {}
local CompiledFileNames = {}


local ShowLogsWindow = false
local ShowFPSOverlay = true
local ShowImguiDemoWindow = false

local TCompiler = require("Engine.TiledCompiler")

function DT:updateFPS(fps)
  for k, v in ipairs(FPS) do
    if k == FPSSize then
      FPS[k] = fps--math.random(1,255)
    else
      FPS[k] = FPS[k+1]
    end
  end
end

function DT:splitFilePath(path)
  return path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
end

--[[function DT:updateTCFilesList()
  SelectedTCFile = 0 TCFiles = {}
  local files = love.filesystem.getDirectoryItems("/Maps/Tiled/")
  for k,filename in ipairs(files) do
    local p, n, e = DT:splitFilePath("/Maps/Tiled/"..filename)
    --n = n:sub(0,-5)
    if e == "lua" then
      --PMug.Shape[n] = require(string.gsub(path..n,"/","%."))
      table.insert(TCFiles,n)
    end
  end
end

function DT:updateLSFilesList()
  SelectedLSFile = 0 LSFiles = {}
  local files = love.filesystem.getDirectoryItems("/TiledBuilds/")
  for k,filename in ipairs(files) do
    local p, n, e = DT:splitFilePath("/TiledBuilds/"..filename)
    if e == "lua" then
      table.insert(LSFiles,n)
    end
  end
end]]

function DT:refreshLevelsList()
  SelectedLevelID, LevelsList, LevelsFileNames, TiledFileNames, CompiledFileNames = 0, {}, {}, {}, {} --Reset the lists

  --Index tiled exported maps
  local files = love.filesystem.getDirectoryItems(TiledPath)
  for k,filename in ipairs(files) do
    local p, n, e = DT:splitFilePath(TiledPath..filename)
    if e == "lua" then
      TiledFileNames[n] = TiledPath..n
    end
  end

  --Index tiled compiled maps
  local files = love.filesystem.getDirectoryItems(MapsPath)
  for k,filename in ipairs(files) do
    local p, n, e = DT:splitFilePath(MapsPath..filename)
    if e == "lua" then
      CompiledFileNames[n] = MapsPath..n
    end
  end

  --Add the tiled levels to the list
  for filename, path in pairs(TiledFileNames) do
    if CompiledFileNames[filename] then
      table.insert(LevelsFileNames,filename)
      table.insert(LevelsList,filename:sub(0,-5).." [Built]")
    else
      table.insert(LevelsFileNames,filename)
      table.insert(LevelsList,filename:sub(0,-5).." [Tiled]")
    end
  end

  --Add the compiled only levels to the list
  for filename, path in pairs(CompiledFileNames) do
    if not TiledFileNames[filename] then
      table.insert(LevelsFileNames,filename)
      table.insert(LevelsList,filename:sub(0,-5).." [Smart]")
    end
  end
end

function DT:gatherTMapInfo(path)
  local code = love.filesystem.load(path)
  setfenv(code,{}) --Sandbox the code
  local mapData = code()
  local info = "-Version: "..mapData.version.."\n-LuaVersion: "..mapData.luaversion.."\n-Orientation:\n "..mapData.orientation..
  "\n-W: "..mapData.width.." H: "..mapData.height.."\n-TW: "..mapData.tilewidth.." TH: "..mapData.tileheight..
  "\n-Total Layers: "..#mapData.layers.."\n-Tilesets: "
  for k,v in ipairs(mapData.tilesets) do
    info = info.."\n "..v.name
  end
  return info
end

function DT:createMenus()
  if _Loaded then self:createGameMenu() end
  --self:createToolsMenu()
  self:createDebugMenu()
end

function DT:createGameMenu()
  if imgui.BeginMenu("Game") then
      self:insertMenuGames()
      imgui.EndMenu()
  end
end

--[[function DT:createToolsMenu()
  if imgui.BeginMenu("Tools") then
      self:insertMenuTools()
      imgui.EndMenu()
  end
end]]

function DT:createDebugMenu()
  if imgui.BeginMenu("Debug") then
      self:insertMenuDebugs()
      imgui.EndMenu()
  end
end

function DT:insertMenuGames()
  if imgui.MenuItem("Load",false,ShowLSWindow) then ShowLSWindow = not ShowLSWindow; CurrentLSState = "Select A map to\nshow info" end
  if imgui.IsItemHovered() then imgui.SetTooltip("Loads a compiled level") end
  if imgui.MenuItem("Exit") then love.event.quit() end
  if imgui.IsItemHovered() then imgui.SetTooltip("Closes the game") end
end

--[[function DT:insertMenuTools()
  if _Loaded then
    if imgui.MenuItem("Tiled Compiler",false,ShowTCWindow) then ShowTCWindow = not ShowTCWindow end
    if imgui.IsItemHovered() then imgui.SetTooltip("Compiles Tiled Maps To Game's Format") end
  end
end]]

function DT:insertMenuDebugs()
  if imgui.MenuItem("Logs",false,ShowLogsWindow) then ShowLogsWindow = not ShowLogsWindow end
  if imgui.IsItemHovered() then imgui.SetTooltip("The game engine logs.") end
  if imgui.MenuItem("FPS",false,ShowFPSOverlay) then ShowFPSOverlay = not ShowFPSOverlay end
  if imgui.IsItemHovered() then imgui.SetTooltip("Shows A FPS Graph") end
  if imgui.MenuItem("Imgui Demo",false,ShowImguiDemoWindow) then ShowImguiDemoWindow = not ShowImguiDemoWindow end
  if imgui.IsItemHovered() then imgui.SetTooltip("The demo window of ImGUI") end
end

function DT:createWindows()
  --self:createToolsWindows()
  self:createGameWindows()
  self:createDebugWindows()
end

function DT:createToolsWindows()
  --[[if ShowTCWindow then
    imgui.SetNextWindowPos(25,45, "FirstUseEver")
    imgui.SetNextWindowSize(430, 240, "FirstUseEver")
    imgui.Begin("Tiled Compiler",_,{"NoResize","NoSavedSettings"})
    local LBChanged
    LBChanged, SelectedTCFile = imgui.ListBox(CurrentTCState.."###TCFilesList",SelectedTCFile,TCFiles,#TCFiles,10)
    if LBChanged then
      CurrentTCState = DT:gatherTMapInfo("/Maps/Tiled/"..TCFiles[SelectedTCFile])
    end

    imgui.Separator()
    if imgui.Button("Refresh") then
      self:updateTCFilesList()
      CurrentTCState = "Refeshed Maps List"
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Refreshes the list of the maps") end

    imgui.SameLine()
    if imgui.Button("Compile") then
      if SelectedTCFile == 0 then CurrentTCState = "Please select a map\nfirst to compile" return end
      TCompiler:compileTiled("/Maps/Tiled/"..TCFiles[SelectedTCFile],"/TiledBuilds/"..TCFiles[SelectedTCFile])
      CurrentTCState = "Compiled Map:\n "..TCFiles[SelectedTCFile].."\n To: /TiledBuilds/"
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Compiles the selected map") end

    imgui.End()
  end

  if ShowLSWindow then
    imgui.SetNextWindowPos(25,45, "FirstUseEver")
    imgui.SetNextWindowSize(430, 240, "FirstUseEver")
    imgui.Begin("Load Level",_,{"NoResize","NoSavedSettings"})
    local LBChanged
    LBChanged, SelectedLS = imgui.ListBox("###LSFilesList",SelectedLSFile,LSFiles,#LSFiles,10)
    if LBChanged then

    end

    imgui.Separator()
    if imgui.Button("Refresh") then
      self:updateLSFilesList()
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Refreshes the list of the levels") end

    imgui.SameLine()
    if imgui.Button("Load") then
      if SelectedLSFile == 0 then return end
      local WS = require("States.Workspace")
      WS:loadMap("/TiledBuilds/"..LSFiles[SelectedLSFile])
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Loads the selected level") end

    imgui.SameLine()
    if imgui.Button("Delete") then
      if SelectedLSFile == 0 then return end
      love.filesystem.remove("/TiledBuilds/"..LSFiles[SelectedLSFile])
      self:updateLSFilesList()
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Deletes the selected level") end

    imgui.End()
  end]]
end

function DT:createGameWindows()
  if ShowLSWindow then
    --imgui.SetNextWindowPos(25,45, "FirstUseEver")
    imgui.SetNextWindowSize(430, 240, "FirstUseEver")
    imgui.Begin("Load Level")--,_,{"NoResize","NoSavedSettings"})
    local LBChanged
    LBChanged, SelectedLevelID = imgui.ListBox(CurrentLSState.."###LSFilesList",SelectedLevelID,LevelsList,#LevelsList,10)
    if LBChanged then
      if TiledFileNames[LevelsFileNames[SelectedLevelID]] then
        CurrentLSState = DT:gatherTMapInfo(TiledFileNames[LevelsFileNames[SelectedLevelID]])
      else
        CurrentLSState = "This level has\nno tiled map\nsource file."
      end
    end

    imgui.Separator()
    if imgui.Button("Refresh") then
      CurrentLSState = "Refreshed MapsList\n\nSelect A map to\nshow info"
      self:refreshLevelsList()
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Refreshes the list of the levels") end

    imgui.SameLine()
    if imgui.Button("Load") then
      if SelectedLevelID == 0 then CurrentLSState = "Please select a\nlevel first." return end
      if not CompiledFileNames[LevelsFileNames[SelectedLevelID]] then --Automatically compiles the level
        TCompiler:compileTiled(TiledFileNames[LevelsFileNames[SelectedLevelID]],MapsPath..LevelsFileNames[SelectedLevelID])
        CompiledFileNames[LevelsFileNames[SelectedLevelID]] = MapsPath..LevelsFileNames[SelectedLevelID]
        LevelsList[SelectedLevelID] = LevelsFileNames[SelectedLevelID]:sub(0,-5).." [Auto Built]"
      end
      local WS = require("States.Workspace")
      WS:loadMap(CompiledFileNames[LevelsFileNames[SelectedLevelID]])
      CurrentLSState = "Level loaded\nsuccessfully"
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Loads the selected level") end

    imgui.SameLine()
    if imgui.Button("Build Map") then
      if SelectedLSFile == 0 then CurrentLSState = "Please select a\nlevel first." return end
      if not TiledFileNames[LevelsFileNames[SelectedLevelID]] then CurrentLSState = "This isn't a\n tiled map tobuild" return end
      TCompiler:compileTiled(TiledFileNames[LevelsFileNames[SelectedLevelID]],MapsPath..LevelsFileNames[SelectedLevelID])
      CompiledFileNames[LevelsFileNames[SelectedLevelID]] = MapsPath..LevelsFileNames[SelectedLevelID]
      LevelsList[SelectedLevelID] = LevelsFileNames[SelectedLevelID]:sub(0,-5).." [New Build]"
      CurrentLSState = "Map built\nsuccessfully\n\nSelect A map to\nshow info"
    end

    imgui.SameLine()
    if imgui.Button("Delete Build")  then
      if SelectedLSFile == 0 then CurrentLSState = "Please select a\nlevel first." return end
      if not TiledFileNames[LevelsFileNames[SelectedLevelID]] then CurrentLSState = "This isn't a\n tiled map build" return end
      love.filesystem.remove(CompiledFileNames[LevelsFileNames[SelectedLevelID]])
      self:refreshLevelsList() CurrentLSState = "Map Build Deleted\n\nSelect A map to\nshow info"
    end
    if imgui.IsItemHovered() then imgui.SetTooltip("Deletes the selected level build") end

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

--DT:updateTCFilesList()
--DT:updateLSFilesList()
DT:refreshLevelsList()

return DT

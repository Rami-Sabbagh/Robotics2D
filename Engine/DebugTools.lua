local DT = {}

local FPSMax = 500
local FPSSize = 1000
local FPS = {}
for i=1, FPSSize do FPS[i] = 0 end

local TiledPath = "/Maps/Tiled/"
local MapsPath = "/TiledBuilds/"
local RCPath = "/RobotPrograms/"

local ShowLSWindow = false
local CurrentLSState = "Select A map to\nshow info"

local SelectedLevelID = 0
local LevelsList = {}
local LevelsFileNames = {}
local TiledFileNames = {}
local CompiledFileNames = {}

local ShowCEWindow = false
local RCFiles = {} --Robot Code Files
local RCFilename = "RobotProgram"
local RCCode = "--Type Code Here"
local RCSState = "Select a program to load, or create a new program."

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

  function DT:refreshRCList()
    SelectedRCID, RCFiles = 0, {}

    local files = love.filesystem.getDirectoryItems(RCPath)
    for k,filename in ipairs(files) do
      local p, n, e = DT:splitFilePath(RCPath..filename)
      if e == "lua" then
        table.insert(RCFiles,filename)
      end
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

function DT:createDebugMenu()
  if imgui.BeginMenu("Debug") then
      self:insertMenuDebugs()
      imgui.EndMenu()
  end
end

function DT:insertMenuGames()
  if imgui.MenuItem("Load",false,ShowLSWindow) then ShowLSWindow = not ShowLSWindow; CurrentLSState = "Select A map to\nshow info" end
  if imgui.IsItemHovered() then imgui.SetTooltip("Loads a compiled level") end
  if imgui.MenuItem("Code Editor",false,ShowCEWindow) then ShowCEWindow = not ShowCEWindow end
  if imgui.IsItemHovered() then imgui.SetTooltip("Robot code editor") end
  if imgui.MenuItem("Exit") then love.event.quit() end
  if imgui.IsItemHovered() then imgui.SetTooltip("Closes the game") end
end

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

function DT:createGameWindows()
  if ShowLSWindow then
    --imgui.SetNextWindowPos(25,45, "FirstUseEver")
    imgui.SetNextWindowSize(430, 240, "FirstUseEver")
    imgui.Begin("Load Level")--,_,{"NoResize","NoSavedSettings"})
    local LBChanged
    LBChanged, SelectedLevelID = imgui.ListBox(CurrentLSState.."##LSFilesList",SelectedLevelID,LevelsList,#LevelsList,10)
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

  if ShowCEWindow then
    imgui.SetNextWindowSize(430, 240, "FirstUseEver")
    imgui.Begin("Robot Code Editor - "..RCFilename..".lua##RCE",_,{"MenuBar"})

    if imgui.BeginMenuBar() then
      if imgui.BeginMenu("File") then
        if imgui.MenuItem("New","Ctrl+N") then

        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Create a new program") end

        if imgui.MenuItem("Load","Ctrl+L") then

        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Load a program") end

        if imgui.MenuItem("Save","Ctrl+S") then

        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Save the current program") end

        if imgui.MenuItem("Save As","Ctrl+Shift+S") then

        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Save the current program, but with a different filename") end

        if imgui.MenuItem("Delete","Ctrl+D") then

        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Delete a program") end
        imgui.EndMenu()
      end
      if imgui.IsItemHovered() then imgui.SetTooltip("Save/Load Files") end

      if imgui.BeginMenu("Program") then
        if imgui.MenuItem("Run","Ctrl+R") then
          local WS = require("States.Workspace")
          local Map = WS:getMap()
          local Robots = Map:getTilesByType("Offical_Robot")
          local Robot = Robots[1]
          Robot:loadCode(loadstring(RCCode))
        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Runs the current program") end

        if imgui.MenuItem("Terminate","Ctrl+T") then
          local WS = require("States.Workspace")
          local Map = WS:getMap()
          local Robots = Map:getTilesByType("Offical_Robot")
          local Robot = Robots[1]
          Robot:loadCode(function()end,true)
        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Terminate the robot program") end

        if imgui.MenuItem("Reset","Ctrl+E") then
          local WS = require("States.Workspace")
          local Map = WS:getMap()
          local Robots = Map:getTilesByType("Offical_Robot")
          local Robot = Robots[1]
          Robot:loadCode(function()end)
        end
        if imgui.IsItemHovered() then imgui.SetTooltip("Resets the robot and stop the program") end
        imgui.EndMenu()
      end
      if imgui.IsItemHovered() then imgui.SetTooltip("Run/Stop Files") end

      imgui.EndMenuBar()
    end


    --[[local LBChanged, SelectedRCID = imgui.ListBox("Saved Programs##RCFilesList",0,RCFiles,#RCFiles,5)
    if LBChanged then
      RCFilename = RCFiles[SelectedRCID]:sub(0,-5)
    end
    imgui.Text(RCSState)]]

    local status
    status, RCCode = imgui.InputTextMultiline("##CodeEditor", RCCode, 10000, 415, 185)


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

DT:refreshLevelsList()
DT:refreshRCList()

return DT

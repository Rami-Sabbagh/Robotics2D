local TCH = love.thread.getChannel("TargetTSJ")

local JSON  = require("Helpers.json")

local TSS = {}

local function splitFilePath(path)
  local p, n, e = path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
  return p, n:sub(1, -e:len()-2), e
end

TSS.thread = love.thread.newThread("/Engine/TilesetJob.lua")

function TSS:buildTilesets(dir,onBuild)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,filename in ipairs(files) do
    if love.filesystem.isDirectory(dir..filename) then
      self:buildTilesets(dir..filename.."/")
    else
      local p, n, e = splitFilePath(dir..filename)
      if e == "tileset" then
        self:buildTileset(dir..filename,n)
      end
    end
  end
  self.onBuild = onBuild
end

function TSS:buildTileset(path,name)
  print("Building Tileset: "..name)
  local TiCH = love.thread.getChannel("TilesTSJ_"..name)
  local TinCH = love.thread.getChannel("TilesNamesTSJ_"..name)
  local tsList = JSON:decode(love.filesystem.read(path))
  for k, tn in ipairs(tsList.Tiles) do
    TiCH:push(_Images[name.."_"..tn]:getData())
    TinCH:push(tn)
  end
  TiCH:push(false)
  TCH:push(name)
  TCH:push(tsList.TileSize)
  if not self.thread:isRunning() then self.thread:start() end
end

function TSS:update()
  if not self.thread:isRunning() and self.onBuild then self.onBuild() self.onBuild = nil end
end

return TSS
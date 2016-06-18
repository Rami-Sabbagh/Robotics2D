local JSON = reqiure("Helpers.json")

local TS = {LuaTiles={},Tiles={}}

function TS:loadLuaTiles(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,filename in ipairs(files) do
    if love.filesystem.isDirectory(dir..filename) then
      self:loadLuaTiles(dir..filename.."/")
    else
      local p, n, e = self:splitFilePath(dir..filename)
      if e == "lua" then
        self.LuaTiles[n] = require(string.gsub(dir..filename,"/","%."))
      end
    end
  end
end

function TS:loadTiles(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,filename in ipairs(files) do
    if love.filesystem.isDirectory(dir..filename) then
      self:loadTiles(dir..filename.."/")
    else
      local p, n, e = self:splitFilePath(dir..filename)
      if e == "tiles" then
        local TList = JSON:decode(love.filesystem.read(dir..filename))
        for tilename, params in pairs(TList) do
          self.Tiles[tilename] = params
        end
      end
    end
  end
end

function TS:loadTilesList(path)
  local TList = JSON:decode(love.filesystem.read(path))
  for tilename, params in pairs(TList) do
    
  end
end

function TS:splitFilePath(path)
  local p, n, e = path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
  return p, n:sub(1, -e:len()-2), e
end

return TS
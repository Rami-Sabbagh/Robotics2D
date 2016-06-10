local Loader = {}

local TargetChannel = love.thread.newChannel()
local ResultChannel = love.thread.newChannel()

local LoaderThread = love.thread.newThread("/Engine/LoaderThread.lua")

function Loader:addHandler(func,extentions,rname)
  
end

function Loader:splitFilePath(path)
  local p, n, e = path:match("(.-)([^\\/]-%.?([^%.\\/]*))$")
  return p, n:sub(1, -e:len()), e
end

function Loader:indexDirectory(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for k,filename in ipairs(files) do
    if love.filesystem.isDirectory(dir..filename) then
      self:indexDirectory(dir..filename.."/")
    else
      local p, n, e = self:splitFilePath(dir..filename)
      
    end
  end
end

return Loader
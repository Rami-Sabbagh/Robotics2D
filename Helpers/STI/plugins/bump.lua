---
-- Bump plugin for STI
-- @module bump

local block = require("Entities.Block")
local platform = require("Entities.Platform")

return {
  --- Initialize Bump World.
  -- @param world The bump.lua world to add objects to.
  -- @return table List of collision objects.
  bump_init = function(map, world)
    for k,object in pairs(map.objects) do
      if object.properties and object.properties.Bump then
        if object.properties.Bump == "Body" then
          object.bump = block(world,object.x,object.y,object.width,object.height)
        elseif object.properties.Bump == "PlatformUP" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"up")
        elseif object.properties.Bump == "PlatformDown" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"down")
        --[[elseif object.properties.Bump == "PlatformLeft" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"left")
        elseif object.properties.Bump == "PlatformRight" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"right")]]
        end
      end
    end
  end
}
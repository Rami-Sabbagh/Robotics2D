---
-- LightVsShadow plugin for STI
-- @module light

local lightPower = 100

return {
  --- Initialize Light World.
  -- @param world The LightVsShadow world to add objects to.
  -- @return table List of light objects.
  light_init = function(map, world)
    for k,object in pairs(map.objects) do
      if object.properties and object.properties.Light then
        if object.properties.Light == "Body" then
          object.light = world.newRectangle(object.x+object.width/2,object.y+object.height/2,object.width,object.height)
        elseif object.properties.Light == "Orange" then
          object.light = world.newLight(object.x+object.width/2, object.y+object.height/2, 223, 145, 49, lightPower)
          object.light.setGlowStrength(0.3)
        elseif object.properties.Light == "Green" then
          object.light = world.newLight(object.x+object.width/2, object.y+object.height/2, 94, 183, 128, lightPower)
          object.light.setGlowStrength(0.3)
        elseif object.properties.Light == "Blue" then
          object.light = world.newLight(object.x+object.width/2, object.y+object.height/2, 57, 176, 170, lightPower)
          object.light.setGlowStrength(0.3)
        end
      end
    end
  end
}
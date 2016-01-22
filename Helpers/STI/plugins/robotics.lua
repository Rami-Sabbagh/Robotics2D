return {
  --- Initialize Bump World.
  -- @param world The bump.lua world to add objects to.
  -- @return table List of collision objects.
  robotics_init = function(map, bumpworld)
    for k,object in pairs(map.objects) do
      if object.type then
        if object.type == "Wall" then
          local Wall = {Type="Wall"}
          bumpworld:add(Wall, object.x,object.y,object.width,object.height)
          object.bump = Wall
        end
      end
      --[[if object.properties and object.properties.Bump then
        if object.properties.Bump == "Body" then
          object.bump = block(world,object.x,object.y,object.width,object.height)
        elseif object.properties.Bump == "PlatformUP" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"up")
        elseif object.properties.Bump == "PlatformDown" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"down")
        elseif object.properties.Bump == "PlatformLeft" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"left")
        elseif object.properties.Bump == "PlatformRight" then
          object.bump = platform(world,object.x,object.y,object.width,object.height,"right")
        end
      end]]
    end
  end
}
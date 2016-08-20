local DTools = require("Engine.DebugTools")

local Tweens = require("Helpers.tween")

local Material = require("Helpers.p-mug.third-party.material-love")

local TS = {}

function TS:init()
  self.fadingTime = 0.5
  self.showTime = 10
end

function TS:enter()
  love.graphics.setBackgroundColor(Material.colors.background("dark"))

  self.alpha = {255}
  self.tween = Tweens.new(skiptween and 0.001 or self.fadingTime,self.alpha,{0})
end

function TS:leave()

end

function TS:draw()
  love.graphics.setColor(0,0,0,self.alpha[1])
  love.graphics.rectangle("fill",0,0,_Width,_Height)

  love.graphics.setColor(255,255,255,255)

  if not _DebugTools then return end

  -- Menu
  if imgui.BeginMainMenuBar() then
    if imgui.BeginMenu("Tools") then
        DTools:insertMenuTools()
        imgui.EndMenu()
    end

    imgui.EndMainMenuBar()
  end

  DTools:createToolsWindows()

  imgui.Render();
end

function TS:update(dt)
  self.tween:update(dt)
end

return TS

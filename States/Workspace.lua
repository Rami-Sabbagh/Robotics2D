local DTools = require("Engine.DebugTools")

local Tweens = require("Helpers.tween")

local Material = require("Helpers.p-mug.third-party.material-love")

local WS = {}

function WS:init()
  self.fadingTime = 0.5
  self.showTime = 10
end

function WS:enter()
  love.graphics.setBackgroundColor(Material.colors.background("dark"))

  self.alpha = {0}
  self.tween = Tweens.new(skiptween and 0.001 or self.fadingTime,self.alpha,{0})
end

function WS:leave()

end

function WS:draw()
  love.graphics.setColor(0,0,0,self.alpha[1])
  love.graphics.rectangle("fill",0,0,_Width,_Height)

  love.graphics.setColor(255,255,255,255)

  if not _DebugTools then return end

  -- Menu
  if imgui.BeginMainMenuBar() then
    DTools:createMenus()

    imgui.EndMainMenuBar()
  end

  DTools:createToolsWindows()

  imgui.Render();
end

function WS:update(dt)
  self.tween:update(dt)
end

return WS

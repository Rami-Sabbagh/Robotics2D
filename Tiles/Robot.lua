local Class = require("Helpers.middleclass")
local TBase = require("Tiles.Base")

local Tweens = require("Helpers.tween")

local RobotAPI = require("Engine.RobotAPI")

local RobotTile = Class("tile.robot",TBase)

function RobotTile:initialize(tx,ty,tsize,rot,invertX,invertY,params)
  TBase.initialize(self,tx,ty,tsize,rot,invertX,invertY,params)
  self.startTX, self.startTY, self.startRot = tx, ty, rot
  self.command = ""
  --self:loadCode(love.filesystem.load("/robotprogram.lua"))
  self.tickTimer = 0
  self.tickTime = 0.25
  self.rot = math.deg(self.rot)
  self.tween = Tweens.new(self.tickTime,self,{})
end

function RobotTile:draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.tileimage,
    self.x+self.ts/2,
    self.y+self.ts/2,
    math.rad(self.rot)
    ,self.sx,self.sy,self.tileimage:getWidth()/2, self.tileimage:getHeight()/2)
end

function RobotTile:update(dt)
  --[[self.x, self.y, self.rot = self.x, self.y, math.rad(self.rot)
  if math.deg(self.rot) >= 360 then self.rot = math.rad(math.deg(self.rot)-360) end
  if math.deg(self.rot) <= -90 then self.rot = math.rad(360 + math.deg(self.rot)) end]]
  if self.tween:update(dt) then
    if self.rot >= 360 then self.rot = self.rot-360 end
    if self.rot < 0 then self.rot = 360 + self.rot end
    if self.rot % 90 ~= 0 then self.rot = self.rot-(self.rot % 90) end
    self:tick(dt)
  end

  --[[self.tickTimer = self.tickTimer + dt
  if self.tickTimer > self.tickTime then
    self.tickTimer = 0
    self:tick(dt)
  end]]
end

function RobotTile:tick(dt)
  if self.command == "" then
    self:resume()
  elseif self.command == "forward" then
    if self.rot == 0 then
      self.x, self.y = self.tx*self.ts, self.ty*self.ts
      self.ty = self.ty - 1
      self.tween = Tweens.new(self.tickTime,self,{x=self.tx*self.ts,y=self.ty*self.ts})
    elseif self.rot == 90 then
      self.x, self.y = self.tx*self.ts, self.ty*self.ts
      self.tx = self.tx + 1
      self.tween = Tweens.new(self.tickTime,self,{x=self.tx*self.ts,y=self.ty*self.ts})
    elseif self.rot == 180 then
      self.x, self.y = self.tx*self.ts, self.ty*self.ts
      self.ty = self.ty + 1
      self.tween = Tweens.new(self.tickTime,self,{x=self.tx*self.ts,y=self.ty*self.ts})
    elseif self.rot == 270 then
      self.x, self.y = self.tx*self.ts, self.ty*self.ts
      self.tx = self.tx - 1
      self.tween = Tweens.new(self.tickTime,self,{x=self.tx*self.ts,y=self.ty*self.ts})
    end
    self:resume()
  elseif self.command == "turn_left" then
    local rot = self.rot - 90
    self.tween = Tweens.new(self.tickTime,self,{rot=rot})
    self:resume()
  elseif self.command == "turn_right" then
    local rot = self.rot + 90
    self.tween = Tweens.new(self.tickTime,self,{rot=rot})
    self:resume()
  end
end

function RobotTile:resume()
  if not self.co then return end
  self.comamnd = ""
  local ok, command = coroutine.resume(self.co)
  if not ok then error(command) end
  self.command = command or "stop"
end

function RobotTile:loadCode(code,dontReset)
  self.tx, self.ty, self.command, self.tween = self.startTX, self.startTY, "", Tweens.new(self.tickTime,self,{})
  if not dontReset then self.x, self.y, self.rot = self.tx*self.ts, self.ty*self.ts, math.deg(self.startRot) end
  local fenvG = {loadstring=loadstring,assert=assert,tostring=tostring,tonumber=tonumber,xpcall=xpcall,ipairs=ipairs,print=printS,pcall=pcall,pairs=pairs,bit=bit,error=error,unpack=unpack,_VERSION=_VERSION,next=next,math=math,select=select,select=select,type=type,coroutine=coroutine,table=table,string=string,robot=RobotAPI}
  setfenv(code,fenvG)
  self.co = coroutine.create(code)
end

return RobotTile

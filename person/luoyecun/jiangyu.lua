-- 江渔
Jiangyu = MyActor:new(jiangyuActorId, '江渔')

function Jiangyu:new ()
  local o = jiangfeng:new()
  o.objid = 4313483879
  o.actorid = self.actorid
  o.actorname = self.actorname
  o.initPosition = { x = 10, y = 8, z = -14 }
  o.bedTailPosition = { x = 12, y = 9, z = -13 } -- 床尾位置
  o.bedTailPointPosition = { x = 12, y = 9, z = -11 } -- 床尾指向位置
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Jiangyu:defaultWant ()
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 在几点想做什么
function Jiangyu:wantAtHour (hour)
  if (hour == 7) then
    self:goHome()
  elseif (hour == 9) then
    self:goToBed()
  elseif (hour == 18) then
    self:goHome()
  elseif (hour == 19) then
    self:toPatrol()
  end
end

-- 初始化
function Jiangyu:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 9) then
    self:goHome()
  elseif (hour >= 9 and hour < 18) then
    self:goToBed()
  elseif (hour >= 18 and hour < 19) then
    self:goHome()
  else
    self:toPatrol()
  end
end

-- 去巡逻
function Jiangyu:toPatrol ()
  self:wantPatrol(self.patrolPositions)
end

-- 回家
function Jiangyu:goHome ()
  self:wantMove(self.atHomePositions)
  self:wantFreeInArea({ self.homeAreaPositions })
end

function Jiangyu:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
end
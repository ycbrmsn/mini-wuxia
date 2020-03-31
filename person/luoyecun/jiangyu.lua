-- 江渔
Jiangyu = MyActor:new(jiangyuActorId, '江渔')

function Jiangyu:new ()
  local o = jiangfeng:new()
  o.actorid = jiangyuActorId
  o.actorname = '江渔'
  o.initPosition = { x = 10, y = 8, z = -14 }
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
  elseif (hour == 19) then
    self:toPatrol()
  end
end

-- 初始化
function Jiangyu:init (hour)
  -- self:newActor(self.initPosition.x, self.initPosition.y, self.initPosition.z, true)
  if (hour >= 7 and hour < 19) then
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
end
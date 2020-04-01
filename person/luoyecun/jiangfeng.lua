-- 江枫
Jiangfeng = MyActor:new(jiangfengActorId, '江枫')

function Jiangfeng:new ()
  local o = {
    objid = 4313483881,
    initPosition = { x = 8, y = 8, z = -18 },
    bedTailPosition = { x = 6, y = 9, z = -13 }, -- 床尾位置
    bedTailPointPosition = { x = 6, y = 9, z = -11 }, -- 床尾指向位置
    patrolPositions = {
      { x = 10, y = 11, z = 12 }, -- 落叶松旁的城上
      { x = -10, y = 11, z = 12 } -- 庄稼地旁的城上
    },
    atHomePositions = {
      { x = 9, y = 8, z = -13 } -- 屋里中央
    },
    homeAreaPositions = {
      { x = 7, y = 9, z = -19 }, -- 屋门口边上
      { x = 11, y = 9, z = -11 } -- 屋内小柜子旁
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Jiangfeng:defaultWant ()
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 在几点想做什么
function Jiangfeng:wantAtHour (hour)
  if (hour == 6) then
    self:goHome()
  elseif (hour == 7) then
    self:toPatrol()
  elseif (hour == 19) then
    self:goHome()
  elseif (hour == 21) then
    self:goToBed()
  end
end

-- 初始化
function Jiangfeng:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 6 and hour < 7) then
    self:goHome()
  elseif (hour >= 7 and hour < 19) then
    self:toPatrol()
  elseif (hour >= 19 and hour < 21) then
    self:goHome()
  else
    self:goToBed()
  end
end

-- 去巡逻
function Jiangfeng:toPatrol ()
  self:wantPatrol(self.patrolPositions)
end

-- 回家
function Jiangfeng:goHome ()
  self:wantMove(self.atHomePositions)
  self:wantFreeInArea({ self.homeAreaPositions })
end

function Jiangfeng:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
end
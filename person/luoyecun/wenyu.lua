-- 文羽
Wenyu = MyActor:new(wenyuActorId)

function Wenyu:new ()
  local o = {
    objid = 4315385572,
    initPosition = { x = 24, y = 8, z = -10 }, -- 屋内
    bedTailPosition1 = { x = 20, y = 9, z = -9 }, -- 床尾位置1
    bedTailPointPosition1 = { x = 24, y = 9, z = -9 }, -- 床尾指向位置1
    bedTailPosition2 = { x = 20, y = 9, z = -12 }, -- 床尾位置2
    bedTailPointPosition2 = { x = 24, y = 9, z = -12 }, -- 床尾指向位置2
    lastBedHeadPosition = nil, -- 上一次睡的床尾位置
    currentBedHeadPosition = nil, -- 当前睡的床尾位置
    homeAreaPositions1 = {
      { x = 28, y = 8, z = -23 }, -- 壁炉旁
      { x = 25, y = 8, z = -13 } -- 转角处
    },
    homeAreaPositions2 = {
      { x = 28, y = 9, z = -12 }, -- 未转角凳子旁
      { x = 21, y = 9, z = -9 } -- 床旁边
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Wenyu:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Wenyu:wantAtHour (hour)
  if (hour == 7) then
    self.lastBedHeadPosition = self.currentBedHeadPosition
    self:wantFreeTime()
  elseif (hour == 19) then
    self:wantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 22) then
    self:goToBed()
  end
end

-- 初始化
function Wenyu:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 19) then
    self:wantFreeTime()
  elseif (hour >= 19 and hour < 22) then
    self:wantFreeInArea({ self.homeAreaPositions })
  else
   self:goToBed() 
  end
end

-- 回家
function Wenyu:goHome ()
  self:wantMove({ self.initPosition }) -- 屋里
end

-- 睡觉
function Wenyu:goToBed ()
  if (self.lastBedHeadPosition and self.lastBedHeadPosition == self.bedTailPosition1) then
    -- 睡二号床
    self:wantGoToSleep(self.bedTailPosition2, self.bedTailPointPosition2)
    self.currentBedHeadPosition = self.bedTailPosition2
  else
    -- 睡一号床
    self:wantGoToSleep(self.bedTailPosition1, self.bedTailPointPosition1)
    self.currentBedHeadPosition = self.bedTailPosition1
  end
end


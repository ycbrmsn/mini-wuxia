-- 叶小龙
Yexiaolong = MyActor:new(yexiaolongActorId, '叶小龙')

function Yexiaolong:new ()
  local o = {
    objid = 4315385631,
    initPosition = { x = 27, y = 9, z = -35 }, -- 客栈客房内
    bedTailPosition = { x = 28, y = 10, z = -35 }, -- 床尾位置
    bedTailPointPosition = { x = 28, y = 10, z = -37 }, -- 床尾指向位置
    homeAreaPositions = {
      { x = 27, y = 10, z = -38 }, -- 衣柜旁
      { x = 25, y = 10, z = -34 } -- 柜子上
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Yexiaolong:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Yexiaolong:wantAtHour (hour)
  if (hour == 7) then
    self:wantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 22) then
    self:goToBed()
  end
end

-- 初始化
function Yexiaolong:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 22) then
    self:wantFreeInArea({ self.homeAreaPositions })
  else
    self:goToBed()
  end
end

function Yexiaolong:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
end
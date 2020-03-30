-- 叶小龙
Yexiaolong = MyActor:new(yexiaolongActorId, '叶小龙')

function Yexiaolong:new ()
  local o = {
    initPosition = { x = 26, y = 9, z = -36 }, -- 客栈客房内
    homeAreaPositions = {
      { x = 25, y = 9, z = -37 }, -- 椅子
      { x = 28, y = 9, z = -34 } -- 床
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
  -- do nothing
end

-- 初始化
function Yexiaolong:init (hour)
  self:newActor(self.initPosition.x, self.initPosition.y, self.initPosition.z, true)
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 杨万里
Yangwanli = MyActor:new(yangwanliActorId)

function Yangwanli:new ()
  local o = {
    objid = 4315385574,
    initPosition = { x = -12, y = 8, z = -11 }, -- 屋内
    bedTailPosition = { x = -7, y = 9, z = -11 }, -- 床尾位置
    bedTailPointPosition = { x = -10, y = 9, z = -11 }, -- 床尾指向位置
    homeAreaPositions = {
      { x = -18, y = 9, z = -19 }, -- 屋门口边上
      { x = -7, y = 9, z = -11 } -- 床
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Yangwanli:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Yangwanli:wantAtHour (hour)
  if (hour == 7) then
    self:wantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 22) then
    self:goToBed()
  end
end

-- 初始化
function Yangwanli:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 22) then
    self:wantFreeInArea({ self.homeAreaPositions })
  else
    self:goToBed()
  end
end

-- 回家
function Yangwanli:goHome ()
  self:wantMove({ self.initPosition }) -- 屋里
end

-- 睡觉
function Yangwanli:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
end
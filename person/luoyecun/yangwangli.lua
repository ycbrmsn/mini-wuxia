-- 杨万里
Yangwanli = MyActor:new(yangwanliActorId, '杨万里')

function Yangwanli:new ()
  local o = {
    initPosition = { x = -9, y = 8, z = -12 } -- 屋内
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
    
  elseif (hour == 19) then
    self:goHome()
  end
end

-- 初始化
function Yangwanli:init (hour)
  self:newActor(self.initPosition.x, self.initPosition.y, self.initPosition.z, true)
  if (hour >= 7 and hour < 19) then
    
  else
    self:goHome()
  end
end

-- 回家
function Yangwanli:goHome ()
  self:wantMove({ self.initPosition }) -- 屋里
end
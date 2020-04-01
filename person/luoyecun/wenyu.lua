-- 文羽
Wenyu = MyActor:new(wenyuActorId, '文羽')

function Wenyu:new ()
  local o = {
    objid = 4315385572,
    initPosition = { x = 22, y = 8, z = -10 } -- 屋内
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
    
  elseif (hour == 19) then
    self:goHome()
  end
end

-- 初始化
function Wenyu:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 19) then
    
  else
    self:goHome()
  end
end

-- 回家
function Wenyu:goHome ()
  self:wantMove({ self.initPosition }) -- 屋里
end
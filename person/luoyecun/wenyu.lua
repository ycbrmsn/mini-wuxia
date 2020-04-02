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
    },
    doorPosition = { x = 23, y = 8, z = -19 } -- 门外位置
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
    self:goHome()
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
    self:goHome()
  else
   self:goToBed() 
  end
end

-- 回家
function Wenyu:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门口
  self:nextWantFreeInArea({ self.homeAreaPositions1, self.homeAreaPositions2 })
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

function Wenyu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(nickname .. '，不要撞我嘛。', playerid)
  elseif (self.think == 'free') then
    self.action:speak(nickname .. '，要不要来玩丫？', playerid)
  elseif (self.think == 'notice') then
    self.action:speak(nickname .. '，有好消息告诉你哦。', playerid)
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(nickname .. '，我要回家了。不要站在路前面，好嘛。', playerid)
    else
      self.action:speak(nickname .. '，我要回家了。明天再玩吧。', playerid)
    end
  elseif (self.think == 'sleep') then
    self.action:speak(nickname .. '，我要睡觉了，明天再玩吧。', playerid)
  end
end
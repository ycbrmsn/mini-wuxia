-- 江渔
Jiangyu = MyActor:new(MyConstant.JIANGYU_ACTOR_ID)

function Jiangyu:new ()
  local o = jiangfeng:new()
  o.objid = 4313483879
  o.actorid = self.actorid
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
function Jiangyu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    local hour = MyTimeHelper:getHour()
    if (hour >= 7 and hour < 9) then
      self:defaultWant()
    elseif (hour >= 9 and hour < 18) then
      self:goToBed()
    elseif (hour >= 18 and hour < 19) then
      self:goHome()
    else
      self:toPatrol()
    end
  end
  return initSuc
end

-- 去巡逻
function Jiangyu:toPatrol ()
  self:wantMove('toPatrol', { self.patrolPositions[1] })
  self:nextWantPatrol('patrol', self.patrolPositions)
end

-- 回家
function Jiangyu:goHome ()
  self:wantMove('goHome', self.doorPositions)
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Jiangyu:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
end

function Jiangyu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你撞我好玩吗？')
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，找我有什么事吗？')
  elseif (self.think == 'toPatrol') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要去巡逻了，让开哟。')
    else
      self.action:speak(playerid, nickname, '，我要去巡逻了，别蹭我。')
    end
  elseif (self.think == 'patrol') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我在巡逻，别站在我前面。')
    else
      self.action:speak(playerid, nickname, '，我在巡逻，不要影响我。')
    end
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，累死了，别挡着我回家的路。')
    else
      self.action:speak(playerid, nickname, '，累死了，不要降低我回家的速度。')
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，让开哟。')
  end
end
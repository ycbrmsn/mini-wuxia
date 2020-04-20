-- 江渔
Jiangyu = MyActor:new(MyConstant.JIANGYU_ACTOR_ID)

function Jiangyu:new ()
  local o = {
    objid = 4313483879,
    initPosition = MyPosition:new(10.5, 8.5, -13.5),
    bedData = {
      MyPosition:new(12.5, 9.5, -12.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(8.5, 12.5, 13.5), -- 最东边蜡烛台
      MyPosition:new(0.5, 12.5, 13.5), -- 中央蜡烛台
      MyPosition:new(-7.5, 12.5, 13.5) -- 最西边蜡烛台
    },
    patrolPositions = jiangfeng.patrolPositions,
    doorPositions = jiangfeng.doorPositions,
    homeAreaPositions = jiangfeng.homeAreaPositions
  }
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
  if (hour == 6) then
    self:putOutCandle('patrol', true, { self.candlePositions[3], self.candlePositions[2], self.candlePositions[1] })
    self:nextWantPatrol('patrol', self.patrolPositions)
  elseif (hour == 7) then
    self:goHome()
  elseif (hour == 9) then
    self:putOutCandleAndGoToBed(jiangfeng.candlePositions)
  elseif (hour == 18) then
    self:defaultWant()
  elseif (hour == 19) then
    self:toPatrol()
  end
end

function Jiangyu:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 7) then
    self:wantAtHour(6)
  elseif (hour >= 7 and hour < 9) then
    self:wantAtHour(7)
  elseif (hour >= 9 and hour < 18) then
    self:wantAtHour(9)
  elseif (hour >= 18 and hour < 19) then
    self:wantAtHour(18)
  else
    self:wantAtHour(19)
  end
end

-- 初始化
function Jiangyu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 去巡逻
function Jiangyu:toPatrol ()
  if (self.think == 'patrol') then
    self:patrol(true)
  else
    self:wantMove('toPatrol', { self.patrolPositions[1] })
    self:patrol()
  end
end

function Jiangyu:patrol (isNow)
  self:lightCandle('patrol', isNow)
  self:nextWantPatrol('patrol', self.patrolPositions)
end

-- 回家
function Jiangyu:goHome ()
  local index = self:putOutCandle(nil, true, { self.candlePositions[3], self.candlePositions[2], self.candlePositions[1] })
  if (index == 1) then
    self:wantMove('goHome', self.doorPositions)
  else
    self:nextWantMove('goHome', self.doorPositions)
  end
  self:nextWantFreeInArea({ self.homeAreaPositions })
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

function Jiangyu:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'patrol' and not(candle.isLit)) then
    self.action:stopRun()
    self.action:speak(myPlayer.objid, nickname, '，离蜡烛远点，影响到我巡逻要你好看。')
    self:wantLookAt('patrol', myPlayer.objid, 4)
    self.action:playAngry(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
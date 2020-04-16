-- 千兵卫
Qianbingwei = MyActor:new(MyConstant.QIANBINGWEI_ACTOR_ID)

function Qianbingwei:new ()
  local o = {
    objid = 4334903620,
    initPosition = { x = -20, y = 7, z = 527 },
    bedData = {
      { x = 6, y = 9, z = -13 }, -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(9, 9, -11) -- 蜡烛台
    },
    patrolPositions = {
      { x = 10, y = 11, z = 12 }, -- 落叶松旁的城上
      { x = -10, y = 11, z = 12 } -- 庄稼地旁的城上
    },
    doorPositions = {
      { x = 9, y = 8, z = -22 } -- 门外
    },
    homeAreaPositions = {
      { x = 7, y = 8, z = -19 }, -- 屋门口边上
      { x = 11, y = 8, z = -12 } -- 屋内小柜子旁，避开桌椅
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Qianbingwei:defaultWant ()
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 在几点想做什么
function Qianbingwei:wantAtHour (hour)
  if (hour == 6) then
    self:defaultWant()
  elseif (hour == 7) then
    self:toPatrol()
  elseif (hour == 19) then
    self:goHome()
  elseif (hour == 21) then
    self:putOutCandleAndGoToBed()
  end
end

function Qianbingwei:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 7) then
    self:wantAtHour(6)
  elseif (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 21) then
    self:wantAtHour(19)
  else
    self:wantAtHour(21)
  end
end

-- 初始化
function Qianbingwei:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 去巡逻
function Qianbingwei:toPatrol ()
  self:wantMove('toPatrol', { self.patrolPositions[1] })
  self:nextWantPatrol('patrol', self.patrolPositions)
end

-- 回家
function Qianbingwei:goHome ()
  self:wantMove('goHome', self.doorPositions)
  self:lightCandle()
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Qianbingwei:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，撞人是不对的哦。')
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，找我有事吗？')
  elseif (self.think == 'toPatrol') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要去巡逻了，不要挡住路。')
    else
      self.action:speak(playerid, nickname, '，我要去巡逻了，不要干扰我。')
    end
  elseif (self.think == 'patrol') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我在巡逻呢，不要挡路。')
    else
      self.action:speak(playerid, nickname, '，我在巡逻呢，不要闹。')
    end
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我刚巡逻完，累死了，正要回家呢。不要挡路。')
    else
      self.action:speak(playerid, nickname, '，我刚巡逻完，累死了，正要回家呢。不要闹。')
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，不要闹。')
  end
end

function Qianbingwei:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self.action:speak(myPlayer.objid, nickname, '，我在睡觉呢，不要点蜡烛。')
    else
      self.action:speak(myPlayer.objid, nickname, '，我要睡觉了，不要点蜡烛了。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playDown(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
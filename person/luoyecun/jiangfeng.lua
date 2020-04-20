-- 江枫
Jiangfeng = MyActor:new(MyConstant.JIANGFENG_ACTOR_ID)

function Jiangfeng:new ()
  local o = {
    objid = 4313483881,
    initPosition = MyPosition:new(8.5, 8.5, -17.5),
    bedData = {
      MyPosition:new(6.5, 9.5, -12.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(9.5, 9.5, -10.5) -- 蜡烛台
    },
    patrolPositions = {
      MyPosition:new(10.5, 11.5, 12.5), -- 落叶松旁的城上
      MyPosition:new(-9.5, 11.5, 12.5) -- 庄稼地旁的城上
    },
    doorPositions = {
      MyPosition:new(9.5, 8.5, -21.5) -- 门外
    },
    homeAreaPositions = {
      MyPosition:new(7.5, 8.5, -18.5), -- 屋门口边上
      MyPosition:new(11.5, 8.5, -11.5) -- 屋内小柜子旁，避开桌椅
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Jiangfeng:defaultWant ()
  self:wantFreeInArea({ self.homeAreaPositions })
end

-- 在几点想做什么
function Jiangfeng:wantAtHour (hour)
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

function Jiangfeng:doItNow ()
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
function Jiangfeng:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 去巡逻
function Jiangfeng:toPatrol ()
  self:wantMove('toPatrol', { self.patrolPositions[1] })
  self:nextWantPatrol('patrol', self.patrolPositions)
end

-- 回家
function Jiangfeng:goHome ()
  self:wantMove('goHome', self.doorPositions)
  self:lightCandle()
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Jiangfeng:collidePlayer (playerid, isPlayerInFront)
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

function Jiangfeng:candleEvent (myPlayer, candle)
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
  elseif (jiangyu.think == 'sleep' and candle.isLit) then
    jiangyu.action:stopRun()
    if (jiangyu.wants[1].style == 'sleeping') then
      jiangyu.action:speak(myPlayer.objid, nickname, '，我在睡觉，离蜡烛远点。')
    else
      jiangyu.action:speak(myPlayer.objid, nickname, '，我要睡觉了，不要碰我家的蜡烛。')
    end
    jiangyu:wantLookAt('sleep', myPlayer.objid, 4)
    jiangyu.action:playAngry(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      jiangyu:doItNow()
    end, 3)
  end
end
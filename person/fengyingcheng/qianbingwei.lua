-- 千兵卫
Qianbingwei = BaseActor:new(MyMap.ACTOR.QIANBINGWEI_ACTOR_ID)

function Qianbingwei:new ()
  local o = {
    objid = 4334903620,
    initPosition = { x = -19.5, y = 7.5, z = 527.5 },
    bedData = {
      { x = -55.5, y = 7.5, z = 529.5 }, -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-54.5, 8.5, 531.5) -- 蜡烛台
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Qianbingwei:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Qianbingwei:wantAtHour (hour)
  if (hour == 6) then
    self:defaultWant()
  elseif (hour == 21) then
    self:putOutCandleAndGoToBed()
  end
end

function Qianbingwei:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 21) then
    self:wantAtHour(6)
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

function Qianbingwei:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, '请注意不要随便撞人。')
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, '你是想被抓起来吗？')
  else
    self:speakTo(playerid, 0, '请不要影响我。')
  end
end

function Qianbingwei:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, '我……')
    else
      self:speakTo(myPlayer.objid, 0, '我……')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    TimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
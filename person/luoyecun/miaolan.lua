-- 苗兰
Miaolan = MyActor:new(MyConstant.MIAOLAN_ACTOR_ID)

function Miaolan:new ()
  local o = {
    objid = 4314184974,
    initPosition = { x = -34, y = 8, z = -13 }, -- 药店柜台后
    bedData = {
      { x = -30, y = 14, z = -15 }, -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(-32, 9, -15), -- 楼下蜡烛台
      MyPosition:new(-28, 14, -14) -- 楼上蜡烛台
    },
    secondFloorPosition = { x = -29, y = 13, z = -14 }, -- 二楼床旁边
    secondFloorPositions1 = {
      { x = -26, y = 14, z = -15 }, -- 楼梯口
      { x = -29, y = 14, z = -14 } -- 床旁边
    },
    secondFloorPositions2 = {
      { x = -29, y = 13, z = -16 }, -- 靠近床旁边
      { x = -30, y = 13, z = -19 } -- 门口
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Miaolan:defaultWant ()
  self:wantFreeTime()
end

function Miaolan:wantAtHour (hour)
  if (hour == 7) then
    self:goToSell()
  elseif (hour == 19) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Miaolan:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Miaolan:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 卖东西
function Miaolan:goToSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Miaolan:goSecondFloor ()
  self:lightCandle('free', true, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.secondFloorPositions1, self.secondFloorPositions2 })
end

function Miaolan:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，要爱护身体，不要撞来撞去。')
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，这么晚过来，你受伤了吗？')
  elseif (self.think == 'toSell') then
    self.action:speak('我要去卖药了。')
  elseif (self.think == 'sell') then
    self.action:speak(playerid, nickname, '，要抓点药吗？')
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，不要闹。')
  end
end

function Miaolan:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.pos:equals(self.candlePositions[2]) and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self.action:speak(myPlayer.objid, nickname, '，睡眠是很重要的，知道吗？不要点蜡烛了。')
    else
      self.action:speak(myPlayer.objid, nickname, '，你也该去睡觉了，不要点蜡烛了。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playFree2(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  elseif ((self.think == 'toSell' or self.think == 'sell') and candle.pos:equals(self.candlePositions[1]) and not(candle.isLit)) then
    self.action:stopRun()
    self.action:speak(myPlayer.objid, nickname, '，熄了蜡烛光线不好呢。')
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playFree2(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
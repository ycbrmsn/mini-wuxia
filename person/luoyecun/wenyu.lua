-- 文羽
Wenyu = MyActor:new(MyConstant.WENYU_ACTOR_ID)

function Wenyu:new ()
  local o = {
    objid = 4315385572,
    initPosition = { x = 24, y = 8, z = -10 }, -- 屋内
    bedData1 = {
      { x = 20, y = 9, z = -9 }, -- 床尾位置1
      ActorHelper.FACE_YAW.EAST -- 床尾朝向东
    },
    bedData2 = {
      { x = 20, y = 9, z = -12 }, -- 床尾位置2
      ActorHelper.FACE_YAW.EAST -- 床尾朝向东
    },
    candlePositions = {
      MyPosition:new(25, 9, -22), -- 门口蜡烛台
      MyPosition:new(23, 9, -12) -- 里屋蜡烛台
    },
    lastBedData = nil, -- 上一次睡的床尾位置
    currentBedData = nil, -- 当前睡的床尾位置
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
    self:exchangeBed()
    self:wantFreeTime()
  elseif (hour == 19) then
    self:goHome()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Wenyu:doItNow ()
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
function Wenyu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 回家
function Wenyu:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门口
  self:lightCandle()
  self:nextWantFreeInArea({ self.homeAreaPositions1, self.homeAreaPositions2 })
end

function Wenyu:exchangeBed ()
  self.lastBedData = self.currentBedData
end

function MyActor:putOutCandleAndGoToBed ()
  local index = 1
  for i, v in ipairs(self.candlePositions) do
    local candle = MyBlockHelper:getCandle(v)
    if (not(candle) or candle.isLit) then
      if (index == 1) then
        self:toggleCandle('sleep', v, false, true)
      else
        self:toggleCandle('sleep', v, false)
      end
      index = index + 1
    end
  end
  self:goToBed(index == 1)
end

-- 睡觉
function Wenyu:goToBed (isNow)
  if (self.lastBedData and self.lastBedData == self.bedData1) then
    -- 睡二号床
    if (isNow) then
      self:wantGoToSleep(self.bedData2)
    else
      self:nextWantGoToSleep(self.bedData2)
    end
    self.currentBedData = self.bedData2
  else
    -- 睡一号床
    if (isNow) then
      self:wantGoToSleep(self.bedData1)
    else
      self:nextWantGoToSleep(self.bedData1)
    end
    self.currentBedData = self.bedData1
  end
end

function Wenyu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，不要撞我嘛。')
    self.action:playFree(2)
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，要不要来玩丫？')
    self.action:playFree2(2)
  elseif (self.think == 'notice') then
    self.action:speak(playerid, nickname, '，有好消息告诉你哦。')
    self.action:playHi(2)
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要回家了。不要站在路前面，好嘛。')
      self.action:playFree2(2)
    else
      self.action:speak(playerid, nickname, '，我要回家了。明天再玩吧。')
      self.action:playFree2(2)
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，明天再玩吧。')
    self.action:playFree2(2)
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我看不清路了，要去点蜡烛。')
      self.action:playFree2(2)
    else
      self.action:speak(playerid, nickname, '，你要帮我点蜡烛吗？')
      self.action:playFree2(2)
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，让一让嘛，我要熄蜡烛去了。')
      self.action:playFree2(2)
    else
      self.action:speak(playerid, nickname, '，你要帮我熄蜡烛吗？')
      self.action:playFree2(2)
    end
  end
end

function Wenyu:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.pos:equals(self.candlePositions[2]) and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self.action:speak(myPlayer.objid, nickname, '，我在睡觉呢，不要点蜡烛啦。')
    else
      self.action:speak(myPlayer.objid, nickname, '，我要睡觉了，不要点蜡烛啦。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playFree2(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
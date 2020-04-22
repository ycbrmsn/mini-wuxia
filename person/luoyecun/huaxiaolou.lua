-- 花小楼
Huaxiaolou = MyActor:new(MyConstant.HUAXIAOLOU_ACTOR_ID)

function Huaxiaolou:new ()
  local o = {
    objid = 4301071935,
    initPosition = MyPosition:new(10.5, 9.5, -42.5),
    bedData = {
      MyPosition:new(9.5, 10.5, -41.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(11.5, 10.5, -40.5), -- 柜台上的蜡烛台
      MyPosition:new(18.5, 10.5, -42.5), -- 大厅中的蜡烛台
      MyPosition:new(28.5, 10.5, -39.5) -- 走廊上的蜡烛台
    },
    doorPosition = MyPosition:new(16.5, 9.5, -38.5)
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Huaxiaolou:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Huaxiaolou:wantAtHour (hour)
  if (hour == 6) then
    self:goToSell(not(self:lightAndPutOutCandles(self.candlePositions)))
  elseif (hour == 7) then
    self:goToSell(not(self:lightAndPutOutCandles({ self.candlePositions[1], self.candlePositions[2] }, { self.candlePositions[3] })))
  elseif (hour == 19) then
    self:goToSell(not(self:lightAndPutOutCandles(self.candlePositions)))
  elseif (hour == 22) then
    self:goToBed(not(self:lightAndPutOutCandles({ self.candlePositions[1], self.candlePositions[2] }, { self.candlePositions[3] })))
  end
end

function Huaxiaolou:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 7) then
    self:wantAtHour(6)
  elseif (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Huaxiaolou:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 卖东西
function Huaxiaolou:goToSell (isNow)
  if (isNow) then
    self:wantMove('toSell', { self.initPosition })
  else
    self:nextWantMove('toSell', { self.initPosition })
  end
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

function Huaxiaolou:lightAndPutOutCandles (lightCandles, putOutCandles)
  local index = 1
  local lcs = {}
  if (lightCandles and #lightCandles > 0) then
    for i, v in ipairs(lightCandles) do
      local candle = MyBlockHelper:getCandle(v)
      if (not(candle.isLit)) then
        table.insert(lcs, v)
      end
    end
  end
  if (#lcs > 0) then
    self:lightCandle(nil, true, lcs)
    index = index + 1
  end
  local pocs = {}
  if (putOutCandles and #putOutCandles > 0) then
    for i, v in ipairs(putOutCandles) do
      local candle = MyBlockHelper:getCandle(v)
      if (candle.isLit) then
        table.insert(pocs, v)
      end
    end
  end
  if (#pocs > 0) then
    if (index == 1) then
      self:putOutCandle(nil, true, pocs)
    else
      self:putOutCandle(nil, false, pocs)
    end
    index = index + 1
  end
  return index ~= 1
end

function Huaxiaolou:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你撞我我也不给你好吃的。')
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，让一让，我点灯去了。')
    else
      self:speakTo(playerid, 0, nickname, '，不要推丫，万一房子点燃了怎么办。')
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，让一让，我熄灯去了。')
    else
      self:speakTo(playerid, 0, nickname, '，你再打扰我，浪费的灯油你来出哟。')
    end
  elseif (self.think == 'goToSell') then
    if (isPlayerInFront) then
      self:speakTo(playerid, 0, nickname, '，你要买食物吗？')
    else
      self:speakTo(playerid, 0, nickname, '，我背后没有食物啦。')
    end
  end
end

function Huaxiaolou:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  self.action:stopRun()
  self:speakTo(myPlayer.objid, 0, nickname, '，不要来捣乱哦。')
  self:wantLookAt('sleep', myPlayer.objid, 4)
  self.action:playFree2(1)
  MyTimeHelper:callFnAfterSecond (function (p)
    self:doItNow()
  end, 3)
end
-- 花小楼
Huaxiaolou = MyActor:new(MyConstant.HUAXIAOLOU_ACTOR_ID)

function Huaxiaolou:new ()
  local o = {
    objid = 4301071935,
    initPosition = { x = 10, y = 9, z = -43 },
    candles = {
      MyBlockHelper:addCandle(11, 10, -41), -- 柜台上的蜡烛台
      MyBlockHelper:addCandle(18, 10, -43), -- 大厅中的蜡烛台
      MyBlockHelper:addCandle(28, 10, -40) -- 走廊上的蜡烛台
    }
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
    self:lightCandle(true)
    self:goToSell()
  elseif (hour == 7) then
    self:putOutCandle(true)
    self:goToSell()
  elseif (hour == 19) then
    self:lightCandle(true)
    self:goToSell()
  elseif (hour == 22) then
    self:putOutCandle(true, { self.candles[3] })
    self:goToSell()
  end
end

-- 初始化
function Huaxiaolou:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    local hour = MyTimeHelper:getHour()
    if (hour >= 6 and hour < 7) then
      self:lightCandle(true)
      self:goToSell()
    elseif (hour >= 7 and hour < 19) then
      self:putOutCandle(true)
      self:goToSell()
    elseif (hour >= 19 and hour < 22) then
      self:lightCandle(true)
      self:goToSell()
    else
      self:putOutCandle(true, { self.candles[3] })
      self:goToSell()
    end
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
  self:nextWantDoNothing('sell')
end

function Huaxiaolou:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你撞我我也不给你好吃的。')
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，让一让，我点灯去了。')
    else
      self.action:speak(playerid, nickname, '，不要推丫，万一房子点燃了怎么办。')
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，让一让，我熄灯去了。')
    else
      self.action:speak(playerid, nickname, '，你再打扰我，浪费的灯油你来出哟。')
    end
  elseif (self.think == 'goToSell') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，你要买食物吗？')
    else
      self.action:speak(playerid, nickname, '，我背后没有食物啦。')
    end
  end
end
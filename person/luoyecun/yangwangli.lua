-- 杨万里
Yangwanli = MyActor:new(MyConstant.YANGWANLI_ACTOR_ID)

function Yangwanli:new ()
  local o = {
    objid = 4315385574,
    initPosition = { x = -12, y = 8, z = -11 }, -- 屋内
    bedData = {
      { x = -7, y = 9, z = -11 }, -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-18, 9, -10), -- 屋角落蜡烛台
      MyPosition:new(-11, 9, -14) -- 屋中央蜡烛台
    },
    homeAreaPositions = {
      { x = -18, y = 9, z = -19 }, -- 屋门口边上
      { x = -7, y = 9, z = -11 } -- 床
    },
    doorPosition = { x = -12, y = 8, z = -22 } -- 门外位置
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Yangwanli:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Yangwanli:wantAtHour (hour)
  if (hour == 7) then
    self:wantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 19) then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Yangwanli:doItNow ()
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
function Yangwanli:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 回家
function Yangwanli:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门外
end
-- free提一提背上酒壶 free2扔酒壶喝酒 poss喝酒
function Yangwanli:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你怎么能撞老人家呢？')
    self.action:playFree(2)
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，找我有事吗？')
    self.action:playFree2(2) -- 扔酒壶
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要回家。不要挡住老人家的路啊。')
      self.action:playFree(2)
    else
      self.action:speak(playerid, nickname, '，有事去我屋里说。不要随便撞人啊')
      self.action:playFree(2)
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，不要打搅我。要尊老知不知道。')
    self.action:playAngry(2)
  elseif (self.think == 'lightCandle') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，不要挡着老人家点蜡烛。')
      self.action:playFree2(2)
    else
      self.action:speak(playerid, nickname, '，不要影响我去点蜡烛，多危险知道不？')
      self.action:playFree2(2)
    end
  elseif (self.think == 'putOutCandle') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，让一让，老人家要熄蜡烛去了。')
      self.action:playFree2(2)
    else
      self.action:speak(playerid, nickname, '，我去熄蜡烛了，有事等下再说。')
      self.action:playFree2(2)
    end
  end
end

function Yangwanli:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self.action:speak(myPlayer.objid, nickname, '，老人家在睡觉，你点蜡烛做什么!')
    else
      self.action:speak(myPlayer.objid, nickname, '，老人家要睡觉了，你还点蜡烛做什么!')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playAngry(1)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
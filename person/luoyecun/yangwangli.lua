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
    candles = {
      MyBlockHelper:addCandle(-18, 9, -10), -- 屋角落蜡烛台
      MyBlockHelper:addCandle(-11, 9, -14) -- 屋中央蜡烛台
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
    self:lightCandle(true)
    self:nextWantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

-- 初始化
function Yangwanli:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    local hour = MyTimeHelper:getHour()
    if (hour >= 7 and hour < 19) then
      self:wantFreeInArea({ self.homeAreaPositions })
    elseif (hour >= 19 and hour < 22) then
      self:lightCandle(true)
      self:nextWantFreeInArea({ self.homeAreaPositions })
    else
      self:putOutCandleAndGoToBed()
    end
  end
  return initSuc
end

-- 回家
function Yangwanli:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门外
end

function Yangwanli:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你怎么能撞老人家呢？')
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，找我有事吗？')
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要回家。不要挡住老人家的路啊。')
    else
      self.action:speak(playerid, nickname, '，有事去我屋里说。不要随便撞人啊')
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，不要打搅我。要尊老知不知道。')
  end
end
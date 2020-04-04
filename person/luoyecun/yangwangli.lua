-- 杨万里
Yangwanli = MyActor:new(MyConstant.YANGWANLI_ACTOR_ID)

function Yangwanli:new ()
  local o = {
    objid = 4315385574,
    initPosition = { x = -12, y = 8, z = -11 }, -- 屋内
    bedTailPosition = { x = -7, y = 9, z = -11 }, -- 床尾位置
    bedTailPointPosition = { x = -10, y = 9, z = -11 }, -- 床尾指向位置
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
  elseif (hour == 22) then
    self:goToBed()
  end
end

-- 初始化
function Yangwanli:init ()
  self:initActor(self.initPosition)
  local hour = MyTimeHelper:getHour()
  if (hour >= 7 and hour < 22) then
    self:wantFreeInArea({ self.homeAreaPositions })
  else
    self:goToBed()
  end
end

-- 回家
function Yangwanli:goHome ()
  self:wantMove('goHome', { self.doorPosition }) -- 门外
end

-- 睡觉
function Yangwanli:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
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
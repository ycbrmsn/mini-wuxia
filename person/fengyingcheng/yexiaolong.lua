-- 叶小龙
Yexiaolong = BaseActor:new(MyMap.ACTOR.YEXIAOLONG_ACTOR_ID)

function Yexiaolong:new ()
  local o = {
    objid = 4315385631,
    initPosition = MyPosition:new(27.5, 9.5, -34.5), -- 客栈客房内
    bedData = {
      MyPosition:new(28.5, 10.5, -34.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(25.5, 10.5, -37.5) -- 客栈中蜡烛台
    },
    homeAreaPositions = {
      MyPosition:new(27.5, 10.5, -37.5), -- 衣柜旁
      MyPosition:new(25.5, 10.5, -33.5) -- 柜子上
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Yexiaolong:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Yexiaolong:wantAtHour (hour)
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex == 1) then
    if (hour == 7) then
      self:wantFreeInArea({ self.homeAreaPositions })
    elseif (hour == 19) then
      self:lightCandle(nil, true)
      self:nextWantFreeInArea({ self.homeAreaPositions })
    elseif (hour == 22) then
      self:putOutCandleAndGoToBed()
    end
  end
end

function Yexiaolong:doItNow ()
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex == 1) then
    local hour = TimeHelper:getHour()
    if (hour >= 7 and hour < 19) then
      self:wantAtHour(7)
    elseif (hour >= 19 and hour < 22) then
      self:wantAtHour(19)
    else
      self:wantAtHour(22)
    end
  end
end

-- 初始化
function Yexiaolong:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Yexiaolong:collidePlayer (playerid, isPlayerInFront)
  local nickname
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1 and mainProgress < 5) then
    nickname = '年轻人'
  else
    nickname = PlayerHelper:getNickname(playerid)
  end
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self:speakTo(playerid, 0, nickname, '，你撞我是想试试你的实力吗？')
  elseif (self.think == 'sleep') then
    self:speakTo(playerid, 0, nickname, '，我要睡觉了，不要惹我哟。')
  else
    self:speakTo(playerid, 0, nickname, '，找我有事吗？')
  end
end

function Yexiaolong:defaultCollidePlayerEvent (playerid, isPlayerInFront)
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex ~= 2) then
    self.action:stopRun()
    self:collidePlayer(playerid, isPlayerInFront)
    self:wantLookAt(nil, playerid)
  end
end

function Yexiaolong:candleEvent (myPlayer, candle)
  local nickname
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1 and mainProgress < 5) then
    nickname = '年轻人'
  else
    nickname = myPlayer:getName()
  end
  if (self.think == 'sleep' and candle.isLit) then
    self.action:stopRun()
    if (self.wants[1].style == 'sleeping') then
      self:speakTo(myPlayer.objid, 0, nickname, '，你想吃棍子吗？不要碰蜡烛。')
    else
      self:speakTo(myPlayer.objid, 0, nickname, '，我要睡觉了，离蜡烛远点。')
    end
    self:wantLookAt('sleep', myPlayer.objid, 4)
    self.action:playAngry(1)
    TimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
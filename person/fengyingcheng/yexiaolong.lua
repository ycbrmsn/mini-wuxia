-- 叶小龙
Yexiaolong = MyActor:new(MyConstant.YEXIAOLONG_ACTOR_ID)

function Yexiaolong:new ()
  local o = {
    objid = 4315385631,
    initPosition = { x = 27, y = 9, z = -35 }, -- 客栈客房内
    bedData = {
      { x = 28, y = 10, z = -35 }, -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(25, 10, -38) -- 客栈中蜡烛台
    },
    homeAreaPositions = {
      { x = 27, y = 10, z = -38 }, -- 衣柜旁
      { x = 25, y = 10, z = -34 } -- 柜子上
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
  local mainIndex = MyStoryHelper:getMainStoryIndex()
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

-- 初始化
function Yexiaolong:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    local mainIndex = MyStoryHelper:getMainStoryIndex()
    if (mainIndex == 1) then
      local hour = MyTimeHelper:getHour()
      if (hour >= 7 and hour < 19) then
        self:wantAtHour(7)
      elseif (hour >= 19 and hour < 22) then
        self:wantAtHour(19)
      else
        self:wantAtHour(22)
      end
    end
  end
  return initSuc
end

function Yexiaolong:collidePlayer (playerid, isPlayerInFront)
  local nickname
  local mainIndex = MyStoryHelper:getMainStoryIndex()
  local mainProgress = MyStoryHelper:getMainStoryProgress()
  if (mainIndex == 1 and mainProgress < 5) then
    nickname = '年轻人'
  else
    nickname = PlayerHelper:getNickname(playerid)
  end
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你撞我是想试试你的实力吗？')
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，不要惹我哟。')
  else
    self.action:speak(playerid, nickname, '，找我有事吗？')
  end
end
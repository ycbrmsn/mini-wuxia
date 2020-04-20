-- 王大力
Wangdali = MyActor:new(MyConstant.WANGDALI_ACTOR_ID)

function Wangdali:new ()
  local o = {
    objid = 4315385568,
    initPosition = MyPosition:new(-29.5, 9.5, -44.5), -- 屋内
    bedData = {
      MyPosition:new(-25.5, 10.5, -46.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向北
    },
    candlePositions = {
      MyPosition:new(-31.5, 10.5, -41.5) -- 蜡烛台
    },
    bedTailPointPosition = MyPosition:new(-25.5, 10.5, -43.5), -- 床尾指向位置
    movePositions = {
      MyPosition:new(-29.5, 9.5, -44.5), -- 屋内
      MyPosition:new(-29.5, 9.5, -33.5), -- 门外
      MyPosition:new(-21.5, 9.5, -34.5), -- 屋外楼梯上
      MyPosition:new(-20.5, 9.5, -43.5) -- 铁匠炉旁边
    },
    outDoorPositions = {
      MyPosition:new(-16.5, 9.5, -48.5), -- 亭口角
      MyPosition:new(-22.5, 9.5, -36.5) -- 亭口对角
    },
    homePositions = {
      MyPosition:new(-32.5, 9.5, -38.5), -- 进门口右角落
      MyPosition:new(-26.5, 9.5, -46.5) -- 对角床上
    },
    doorPosition = MyPosition:new(-29.5, 9.5, -35.5) -- 门外位置
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Wangdali:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Wangdali:wantAtHour (hour)
  -- 发现王大力好像出不了一格的门，方法就暂时不用
  if (hour == 7) then
    self:goOutDoor()
  elseif (hour == 19) then
    self:goHome()
  end
end

function Wangdali:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 7 and hour < 19) then
    self:wantAtHour(7)
  else
    self:wantAtHour(19)
  end
end

-- 初始化
function Wangdali:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

-- 外出
function Wangdali:goOutDoor ()
  self:putOutCandle(nil, true)
  self:nextWantMove('goOut', self.movePositions)
  self:nextWantFreeInArea({ self.outDoorPositions })
end

-- 回家
function Wangdali:goHome ()
  if (self.think == 'atHome') then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea('atHome', { self.homePositions })
  else
    self:wantMove('goHome', { self.doorPosition })
    self:lightCandle()
    self:nextWantFreeInArea('atHome', { self.homePositions })
  end
end

-- 铁匠这个模型没有此动作
function Wangdali:goToBed ()
  
end

function Wangdali:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，你撞我做什么?')
  elseif (self.think == 'free' or self.think == 'atHome') then
    self.action:speak(playerid, nickname, '，你想买点装备吗？')
  elseif (self.think == 'goHome') then
    if (isPlayerInFront) then
      self.action:speak(playerid, nickname, '，我要回家了，不要挡路。有事进屋里再说。')
    else
      self.action:speak(playerid, nickname, '，你怎么能撞人呢。算了，天色不早了，我先回家了。')
    end
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，有事明天再说。')
  end
end

function Wangdali:candleEvent (myPlayer, candle)
  local nickname = myPlayer:getName()
  if (self.think == 'atHome') then
    self.action:stopRun()
    self.action:speak(myPlayer.objid, nickname, '，别关灯。')
    self:wantLookAt(nil, myPlayer.objid, 4)
    MyTimeHelper:callFnAfterSecond (function (p)
      self:doItNow()
    end, 3)
  end
end
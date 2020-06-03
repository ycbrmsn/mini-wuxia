-- 陆道风
Ludaofeng = MyActor:new(MyConstant.LUDAOFENG_ACTOR_ID)

function Ludaofeng:new ()
  local o = {
    objid = 4334703245,
    initPosition = { x = -36, y = 8, z = 557 }, -- 议事厅
    bedData = {
      { x = -29, y = 17, z = 546 }, -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(-33, 17, 543), -- 大桌
      MyPosition:new(-28, 17, 544) -- 床旁边
    },
    bedroomAreaPositions = {
      { x = 27, y = 10, z = -38 }, -- 衣柜旁
      { x = 25, y = 10, z = -34 } -- 柜子上
    },
    studyAreaPositions = {
      { x = 27, y = 10, z = -38 }, -- 衣柜旁
      { x = 25, y = 10, z = -34 } -- 柜子上
    },
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Ludaofeng:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Ludaofeng:wantAtHour (hour)
  if (hour == 6) then
    self:wantFreeInArea({ self.studyAreaPositions })
  elseif (hour == 8) then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea({ self.homeAreaPositions })
  elseif (hour == 19) then
    self:lightCandle(nil, true)
    self:nextWantFreeInArea({ self.studyAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Ludaofeng:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 8) then
    self:wantAtHour(6)
  elseif (hour >= 8 and hour < 19) then
    self:wantAtHour(8)
  elseif (hour >= 19 and hour < 22) then
    self:wantAtHour(19)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Ludaofeng:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Ludaofeng:collidePlayer (playerid, isPlayerInFront)
  
end

function Ludaofeng:candleEvent (myPlayer, candle)
  
end
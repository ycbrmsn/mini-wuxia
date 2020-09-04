-- 陆道风
Ludaofeng = BaseActor:new(MyMap.ACTOR.LUDAOFENG_ACTOR_ID)

function Ludaofeng:new ()
  local o = {
    objid = 4334703245,
    initPosition = MyPosition:new(-36, 8, 557), -- 议事厅
    movePositions = {
      MyPosition:new(-46.5, 16.5, 545.5), -- 楼梯口
      MyPosition:new(-36.5, 8.5, 545.5) -- 议事厅门口
    }, 
    bedData = {
      MyPosition:new(-28.5, 17.5, 546.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-32.5, 17.5, 543.5), -- 大桌
      MyPosition:new(-27.5, 17.5, 544.5), -- 床旁边
      MyPosition:new(-41.5, 17.5, 546.5) -- 书房
    },
    hallAreaPositions = {
      MyPosition:new(-38.5, 8.5, 549.5), -- 进门左边茶几旁
      MyPosition:new(-33.5, 8.5, 558.5) -- 尽头椅子旁
    },
    bedroomAreaPositions = {
      MyPosition:new(-34.5, 16.5, 546.5), -- 门旁
      MyPosition:new(-29.5, 16.5, 540.5) -- 柜子旁
    },
    studyAreaPositions = {
      MyPosition:new(-38.5, 16.5, 546.5), -- 门旁
      MyPosition:new(-43.5, 16.5, 540.5) -- 茶几旁
    }
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
    self:lightCandle('free', true, { self.candlePositions[3] })
    self:nextWantFreeInArea({ self.studyAreaPositions })
  elseif (hour == 8) then
    self:putOutCandle('free', true, { self.candlePositions[3] })
    self:nextWantMove('free', self.movePositions)
    self:nextWantFreeInArea({ self.hallAreaPositions })
  elseif (hour == 19) then
    self:lightCandle('free', true, { self.candlePositions[1], self.candlePositions[2] })
    self:nextWantFreeInArea({ self.bedroomAreaPositions })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed({ self.candlePositions[1], self.candlePositions[2] })
  end
end

function Ludaofeng:doItNow ()
  local hour = TimeHelper:getHour()
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
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '你找我可有要事？')
end

function Ludaofeng:candleEvent (myPlayer, candle)
  
end
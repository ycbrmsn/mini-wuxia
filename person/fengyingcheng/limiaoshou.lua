-- 李妙手
Limiaoshou = BaseActor:new(MyMap.ACTOR.LIMIAOSHOU_ACTOR_ID)

function Limiaoshou:new ()
  local o = {
    objid = 4369329639,
    initPosition = MyPosition:new(17.5, 9.5, 566.5), -- 售货处
    doorPosition = MyPosition:new(18.5, 8.5, 560.5), -- 门口位置
    bedData = {
      MyPosition:new(16.5, 13.5, 562.5), -- 床尾位置
      ActorHelper.FACE_YAW.EAST -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(16.5, 9.5, 565.5), -- 楼下烛台
      MyPosition:new(15.5, 13.5, 565.5) -- 楼上烛台
    },
    secondFloorPositions = {
      MyPosition:new(19.5, 12.5, 566.5), -- 楼梯口
      MyPosition:new(17.5, 12.5, 562.5) -- 门旁边
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Limiaoshou:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Limiaoshou:wantAtHour (hour)
  if (hour == 6) then
    self:toSell()
  elseif (hour == 20) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Limiaoshou:doItNow ()
  local hour = TimeHelper:getHour()
  if (hour >= 6 and hour < 20) then
    self:wantAtHour(6)
  elseif (hour >= 20 and hour < 22) then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Limiaoshou:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Limiaoshou:toSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Limiaoshou:goSecondFloor ()
  self:lightCandle('free', true, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.secondFloorPositions })
end

function Limiaoshou:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想买点什么？')
end

function Limiaoshou:candleEvent (myPlayer, candle)
  
end

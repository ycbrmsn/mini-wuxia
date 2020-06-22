-- 孙孔武
Sunkongwu = MyActor:new(MyConstant.SUNKONGWU_ACTOR_ID)

function Sunkongwu:new ()
  local o = {
    objid = 4368929599,
    initPosition = MyPosition:new(8.5, 9.5, 566.5), -- 售货处
    doorPosition = MyPosition:new(7.5, 8.5, 559.5), -- 门口位置
    movePositions = {
      MyPosition:new(6.5, 8.5, 566.5), -- 门口
      MyPosition:new(5.5, 8.5, 566.5), -- 门后
      MyPosition:new(3.5, 12.5, 562.5), -- 楼梯上
      MyPosition:new(7.5, 12.5, 563.5) -- 蜡烛台旁
    },
    bedData = {
      MyPosition:new(8.5, 13.5, 561.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(9.5, 9.5, 565.5), -- 楼下烛台
      MyPosition:new(7.5, 13.5, 564.5) -- 楼上烛台
    },
    secondFloorPositions = {
      MyPosition:new(6.5, 12.5, 565.5), -- 楼梯口
      MyPosition:new(10.5, 12.5, 562.5) -- 门旁边
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Sunkongwu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Sunkongwu:wantAtHour (hour)
  if (hour == 6) then
    self:toSell()
  elseif (hour == 20) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Sunkongwu:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 20) then
    self:wantAtHour(6)
  elseif (hour >= 20 and hour < 22) then
    self:wantAtHour(20)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Sunkongwu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Sunkongwu:toSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Sunkongwu:goSecondFloor ()
  self:wantMove('free', self.movePositions)
  self:lightCandle('free', false, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.secondFloorPositions })
end

function Sunkongwu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想买点什么？')
end

function Sunkongwu:candleEvent (myPlayer, candle)
  
end

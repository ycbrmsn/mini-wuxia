-- 大牛
Daniu = MyActor:new(MyConstant.DANIU_ACTOR_ID)

function Daniu:new ()
  local o = {
    objid = 4367229311,
    initPosition = MyPosition:new(-48.5, 9.5, 504.5), -- 马厩招待处
    doorPosition = MyPosition:new(-46.5, 8.5, 501.5), -- 门口位置
    bedData = {
      MyPosition:new(-47.5, 8.5, 507.5), -- 床尾位置
      ActorHelper.FACE_YAW.WEST -- 床尾朝向西
    },
    candlePositions = {
      MyPosition:new(-48.5, 9.5, 503.5)
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Daniu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Daniu:wantAtHour (hour)
  if (hour == 6) then
    self:lightCandle('toSell', true)
    self:nextWantMove('toSell', { self.initPosition })
    self:nextWantLookAt(nil, self.doorPosition, 1)
    self:nextWantDoNothing('sell')
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Daniu:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 22) then
    self:wantAtHour(6)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Daniu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Daniu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想去哪里？')
end

function Daniu:candleEvent (myPlayer, candle)
  
end

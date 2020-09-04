-- 钱多
Qianduo = BaseActor:new(MyMap.ACTOR.QIANDUO_ACTOR_ID)

function Qianduo:new ()
  local o = {
    objid = 4369930009,
    initPosition = MyPosition:new(5.5, 9.5, 574.5), -- 售货处
    doorPosition = MyPosition:new(6.5, 8.5, 579.5), -- 门口位置
    bedData = {
      MyPosition:new(16.5, 9.5, 575.5), -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向
    },
    candlePositions = {
      MyPosition:new(4.5, 9.5, 575.5), -- 大厅烛台
      MyPosition:new(14.5, 9.5, 575.5) -- 屋内烛台
    },
    homeAreaPositions = {
      MyPosition:new(12.5, 8.5, 572.5), -- 门口
      MyPosition:new(15.5, 8.5, 576.5) -- 床旁边
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Qianduo:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Qianduo:wantAtHour (hour)
  if (hour == 6) then
    self:toSell()
  elseif (hour == 20) then
    self:freeInHome()
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Qianduo:doItNow ()
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
function Qianduo:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Qianduo:toSell ()
  self:lightCandle('toSell', true, { self.candlePositions[1] })
  self:nextWantMove('toSell', { self.initPosition })
  self:nextWantLookAt(nil, self.doorPosition, 1)
  self:nextWantDoNothing('sell')
end

-- 屋内自由活动
function Qianduo:freeInHome ()
  self:lightCandle('free', true, { self.candlePositions[2] })
  self:nextWantFreeInArea({ self.homeAreaPositions })
end

function Qianduo:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '客人想买点什么？')
end

function Qianduo:candleEvent (myPlayer, candle)
  
end

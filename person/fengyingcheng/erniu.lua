-- 二牛
Erniu = MyActor:new(MyConstant.ERNIU_ACTOR_ID)

function Erniu:new ()
  local o = {
    objid = 4372230256,
    initPosition = MyPosition:new(-53.5, 9.5, 494.5), -- 马厩小房间
    bedData = {
      MyPosition:new(-51.5, 8.5, 494.5), -- 床尾位置
      ActorHelper.FACE_YAW.NORTH -- 床尾朝向南
    },
    candlePositions = {
      MyPosition:new(-53.5, 9.5, 497.5)
    },
    bedroomAreaPositions = {
      MyPosition:new(-51.5, 8.5, 496.5), -- 衣柜旁
      MyPosition:new(-54.5, 8.5, 493.5) -- 柜子上
    },
    roomAreaPositions1 = {
      MyPosition:new(-59.5, 8.5, 495.5), -- 门旁
      MyPosition:new(-59.5, 8.5, 507.5) -- 转弯处
    },
    roomAreaPositions2 = {
      MyPosition:new(-59.5, 8.5, 507.5), -- 转弯处
      MyPosition:new(-53.5, 8.5, 507.5) -- 尽头
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Erniu:defaultWant ()
  self:wantDoNothing()
end

-- 在几点想做什么
function Erniu:wantAtHour (hour)
  if (hour == 6) then
    self:lightCandle('free', true)
    self:nextWantFreeInArea({ self.bedroomAreaPositions })
  elseif (hour == 8) then
    self:putOutCandle('free', true)
    self:nextWantFreeInArea({ self.roomAreaPositions1, self.roomAreaPositions2 })
  elseif (hour == 22) then
    self:putOutCandleAndGoToBed()
  end
end

function Erniu:doItNow ()
  local hour = MyTimeHelper:getHour()
  if (hour >= 6 and hour < 8) then
    self:wantAtHour(6)
  elseif (hour >= 8 and hour < 22) then
    self:wantAtHour(8)
  else
    self:wantAtHour(22)
  end
end

-- 初始化
function Erniu:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    self:doItNow()
  end
  return initSuc
end

function Erniu:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  self:speakTo(playerid, 0, '买好票之后拿着它给我就好了。')
end

function Erniu:candleEvent (myPlayer, candle)
  
end

function Erniu:playerClickEvent (objid)
  local itemid = PlayerHelper:getCurToolID(objid)
  if (itemid == MyConstant.ITEM.CARRIAGE_LUOYECUN_ID) then -- 落叶村车票
    MyItemHelper:removeCurTool(objid)
    self:speak(0, '这是去往落叶村的车票。我这就送你过去。')
    MyTimeHelper:callFnFastRuns(function ()
      local player = MyPlayerHelper:getPlayer(objid)
      player:setMyPosition(PositionHelper.luoyecunPos)
    end, 2)
  elseif (itemid == MyConstant.ITEM.CARRIAGE_PINGFENGZHAI_ID) then -- 平风寨车票
    MyItemHelper:removeCurTool(objid)
    self:speak(0, '这是去往平风寨的车票。我这就送你过去。')
    MyTimeHelper:callFnFastRuns(function ()
      local player = MyPlayerHelper:getPlayer(objid)
      player:setMyPosition(PositionHelper.pingfengzhaiPos)
    end, 2)
  end
end
-- 苗兰
Miaolan = MyActor:new(MyConstant.MIAOLAN_ACTOR_ID)

function Miaolan:new ()
  local o = {
    objid = 4314184974,
    initPosition = { x = -34, y = 8, z = -13 }, -- 药店柜台后
    bedData = {
      { x = -30, y = 14, z = -15 }, -- 床尾位置
      ActorHelper.FACE_YAW.SOUTH -- 床尾朝向南
    },
    secondFloorPosition = { x = -29, y = 13, z = -14 }, -- 二楼床旁边
    secondFloorPositions1 = {
      { x = -26, y = 14, z = -15 }, -- 楼梯口
      { x = -29, y = 14, z = -14 } -- 床旁边
    },
    secondFloorPositions2 = {
      { x = -29, y = 13, z = -16 }, -- 靠近床旁边
      { x = -30, y = 13, z = -19 } -- 门口
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Miaolan:defaultWant ()
  self:wantFreeTime()
end

function Miaolan:wantAtHour (hour)
  if (hour == 7) then
    self:goToSell()
  elseif (hour == 19) then
    self:goSecondFloor()
  elseif (hour == 22) then
    self:goToBed()
  end
end

-- 初始化
function Miaolan:init ()
  local initSuc = self:initActor(self.initPosition)
  if (initSuc) then
    local hour = MyTimeHelper:getHour()
    if (hour >= 7 and hour < 19) then
      self:goToSell()
    elseif (hour >= 19 and hour < 22) then
      self:goSecondFloor()
    else
      self:goToBed()
    end
  end
  return initSuc
end

-- 卖东西
function Miaolan:goToSell ()
  self:wantMove('toSell', { self.initPosition })
  self:nextWantDoNothing('sell')
end

-- 上二楼
function Miaolan:goSecondFloor ()
  self:wantFreeInArea({ self.secondFloorPositions1, self.secondFloorPositions2 })
end

function Miaolan:collidePlayer (playerid, isPlayerInFront)
  local nickname = PlayerHelper:getNickname(playerid)
  if (self.wants and self.wants[1].currentRestTime > 0) then
    self.action:speak(playerid, nickname, '，要爱护身体，不要撞来撞去。')
  elseif (self.think == 'free') then
    self.action:speak(playerid, nickname, '，这么晚过来，你受伤了吗？')
  elseif (self.think == 'toSell') then
    self.action:speak('我要去卖药了。')
  elseif (self.think == 'sell') then
    self.action:speak(playerid, nickname, '，要抓点药吗？')
  elseif (self.think == 'sleep') then
    self.action:speak(playerid, nickname, '，我要睡觉了，不要闹。')
  end
end
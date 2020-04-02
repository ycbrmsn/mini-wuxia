-- 苗兰
Miaolan = MyActor:new(miaolanActorId)

function Miaolan:new ()
  local o = {
    objid = 4314184974,
    initPosition = { x = -34, y = 8, z = -13 }, -- 药店柜台后
    bedTailPosition = { x = -30, y = 14, z = -15 }, -- 床尾位置
    bedTailPointPosition = { x = -30, y = 14, z = -20 }, -- 床尾指向位置
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
function Miaolan:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 19) then
    self:goToSell()
  elseif (hour >= 19 and hour < 22) then
    self:goSecondFloor()
  else
    self:goToBed()
  end
end

-- 卖东西
function Miaolan:goToSell ()
  self:wantMove({ self.initPosition })
  self:nextWantDoNothing()
end

-- 上二楼
function Miaolan:goSecondFloor ()
  self:wantFreeInArea({ self.secondFloorPositions1, self.secondFloorPositions2 })
end

function Miaolan:goToBed ()
  self:wantGoToSleep(self.bedTailPosition, self.bedTailPointPosition)
end
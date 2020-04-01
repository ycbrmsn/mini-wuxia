-- 苗兰
Miaolan = MyActor:new(miaolanActorId, '苗兰')

function Miaolan:new ()
  local o = {
    objid = 4314184974,
    initPosition = { x = -34, y = 8, z = -13 }, -- 药店柜台后
    bedHeadPosition = { x = -30, y = 14, z = -14 }, -- 床头位置
    bedTailPointPosition = { x = -30, y = 14, z = -20 }, -- 床尾指向位置
    secondFloorPosition = { x = -29, y = 13, z = -14 }, -- 二楼床旁边
    secondFloorPositions1 = {
      { x = -26, y = 13, z = -15 }, -- 楼梯口
      { x = -28, y = 13, z = -14 } -- 床旁边
    },
    secondFloorPositions2 = {
      { x = -29, y = 13, z = -14 }, -- 床旁边
      { x = -30, y = 13, z = -19 } -- 门口
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Miaolan:defaultWant ()
  MyActorHelper:closeAI(self.objid)
  self:wantFreeTime()
end

function Miaolan:wantAtHour (hour)
  if (hour == 7) then
    self:goToSell()
  elseif (hour == 19) then
    self:goSecondFloor()
  end
end

-- 初始化
function Miaolan:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 19) then
    self:goToSell()
  else
    self:goSecondFloor()
  end
end

-- 卖东西
function Miaolan:goToSell ()
  self:wantMove({ self.initPosition })
  self:nextWantDoNothing()
end

-- 上二楼
function Miaolan:goSecondFloor ()
  self:wantMove({ self.secondFloorPosition })
  self:nextWantFreeInArea({ self.secondFloorPositions1, self.secondFloorPositions2 })
end

function Miaolan:goToBed ()
  self:wantMove({ self.bedHeadPosition })
  self:nextWantSleep(self.bedTailPointPosition)
end
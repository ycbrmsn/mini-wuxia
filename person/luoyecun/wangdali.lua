-- 王大力
Wangdali = MyActor:new(wangdaliActorId, '王大力')

function Wangdali:new ()
  local o = {
    objid = 4315385568,
    initPosition = { x = -30, y = 9, z = -45 }, -- 屋内
    movePositions = {
      { x = -30, y = 9, z = -45 }, -- 屋内
      { x = -30, y = 9, z = -34 }, -- 门外
      { x = -22, y = 9, z = -35 }, -- 屋外楼梯上
      { x = -21, y = 9, z = -44 } -- 铁匠炉旁边
    },
    outDoorPositions = {
      { x = -17, y = 9, z = -49 }, -- 亭口角
      { x = -24, y = 9, z = -38 } -- 亭口对角
    },
    homePositions = {
      { x = -34, y = 9, z = -38 }, -- 进门口右角落
      { x = -26, y = 9, z = -48 } -- 对角床上
    }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 默认想法
function Wangdali:defaultWant ()
  self:wantFreeTime()
end

-- 在几点想做什么
function Wangdali:wantAtHour (hour)
  -- 发现王大力好像出不了一格的门，方法就暂时不用
  if (hour == 7) then
    self:goOutDoor()
  elseif (hour == 19) then
    self:goHome()
  end
end

-- 初始化
function Wangdali:init (hour)
  self:initActor(self.initPosition)
  if (hour >= 7 and hour < 19) then
    self:goOutDoor()
  else
    self:goHome()
  end
end

-- 外出
function Wangdali:goOutDoor ()
  self:wantMove(self.movePositions)
  self:nextWantFreeInArea({ self.outDoorPositions })
end

-- 回家
function Wangdali:goHome ()
  self:wantMove(self.movePositions, true)
  self:nextWantFreeInArea({ self.homePositions })
end
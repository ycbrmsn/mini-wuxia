-- 恶狼
Wolf = MyActor:new(MyConstant.WOLF_ACTOR_ID)

function Wolf:new ()
  local o = {
    initPosition1 = { x = 160, y = 8, z = 16 }, -- 恶狼区域1位置
    initPosition2 = { x = 192, y = 7, z = -18 }, -- 恶狼区域2位置
    ravinePosition = { x = 122, y = 7, z = 1} -- 恶狼谷口位置
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Wolf:createInPosition1 (num)
  self:newMonster(self.initPosition1.x, self.initPosition1.y, self.initPosition1.z, num)
end

function Wolf:createInPosition2 (num)
  self:newMonster(self.initPosition2.x, self.initPosition2.y, self.initPosition2.z, num)
end

-- 跑到出生位置
function Wolf:runToInit (objid)
  MyActorHelper:openAI(objid)
  self.action:runTo(self.initPosition, objid)
end
-- 恶狼
Wolf = MyActor:new(MyConstant.WOLF_ACTOR_ID)

function Wolf:new ()
  local o = {
    objid = MyConstant.WOLF_ACTOR_ID,
    expData = {
      level = 3,
      exp = 20
    },
    fallOff = {
      { 12518, 1, 20 }, -- 生鸡腿
      { MyConstant.COIN_ID, 1, 20 } -- 铜板
    },
    monsterPositions = {
      { x = 160, y = 8, z = 16 }, -- 恶狼区域1位置
      { x = 192, y = 7, z = -18 } -- 恶狼区域2位置
    },
    monsterAreas = {},
    ravinePositions = {
      MyPosition:new(122.5, 7.5, 3.5), -- 恶狼谷口位置
      MyPosition:new(123.5, 7.5, 3.5) -- 恶狼谷口后位置
    },
    areaids = {},
    areaName = '恶狼谷'
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Wolf:init ()
  for i, v in ipairs(self.ravinePositions) do
    table.insert(self.areaids, AreaHelper:getAreaByPos(v))
  end
  return true
end

function Wolf:getName ()
  if (not(self.actorname)) then
    self.actorname = '恶狼'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function Wolf:generateMonsters (num)
  num = num or 10
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper:getAreaByPos(v))
  end
  MyTimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    for i, v in ipairs(self.monsterAreas) do
      local objids = AreaHelper:getAllCreaturesInAreaId(v)
      if (not(objids) or #objids < num) then
        for i = 1, num - #objids do
          local pos = MyAreaHelper:getRandomAirPositionInArea(v)
          self:newMonster(pos.x, pos.y, pos.z, 1)
        end
      end
    end
    return false
  end, 60)
end
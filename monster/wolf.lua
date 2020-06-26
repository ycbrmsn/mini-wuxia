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
      { MyConstant.ITEM.APPLE_ID, 1, 20 }, -- 苹果
      { MyConstant.ITEM.COIN_ID, 1, 50 } -- 铜板
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
  -- 怪物定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper:getAreaByPos(v))
  end
  -- 恶狼谷提示区域
  for i, v in ipairs(self.ravinePositions) do
    table.insert(self.areaids, AreaHelper:getAreaByPos(v))
  end
  self.generate = function ()
    self:generateMonsters()
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
  for i, v in ipairs(self.monsterAreas) do
    local objids = AreaHelper:getAllCreaturesInAreaId(v)
    if (not(objids) or #objids < num) then
      for i = 1, num - #objids do
        local pos = MyAreaHelper:getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function Wolf:timerGenerate (num)
  num = num or 10
  MyTimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    self:generateMonsters(num)
    return false
  end, 60)
end
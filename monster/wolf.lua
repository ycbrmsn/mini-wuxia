-- 恶狼
Wolf = BaseActor:new(MyMap.ACTOR.WOLF_ACTOR_ID)

function Wolf:new ()
  local o = {
    objid = MyMap.ACTOR.WOLF_ACTOR_ID,
    expData = {
      level = 3,
      exp = 20
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 20 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 1, 30 } -- 铜板
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
    local curNum = MonsterHelper:getMonsterNum(v, self.actorid)
    if (curNum < num) then
      for i = 1, num - curNum do
        local pos = AreaHelper:getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function Wolf:timerGenerate (num)
  num = num or 10
  TimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    self:generateMonsters(num)
    return false
  end, 60)
end

-- 狂牛
Ox = BaseActor:new(MyMap.ACTOR.OX_ACTOR_ID)

function Ox:new ()
  local o = {
    objid = MyMap.ACTOR.OX_ACTOR_ID,
    expData = {
      level = 7,
      exp = 25
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 20 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 1, 30 } -- 铜板
    },
    monsterPositions = {
      { x = -174, y = 7, z = -16 }, -- 狂牛区域
    },
    monsterAreas = {},
    areaids = {},
    areaName = '狂牛草原'
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Ox:init ()
  -- 怪物定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper:getAreaByPos(v))
  end
  -- 狂牛草原提示区域
  table.insert(self.areaids, -1)
  table.insert(self.areaids, AreaHelper:getAreaByPos(self.monsterPositions[1]))
  self.generate = function ()
    self:generateMonsters()
  end
  return true
end

function Ox:getName ()
  if (not(self.actorname)) then
    self.actorname = '狂牛'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function Ox:generateMonsters (num)
  num = num or 10
  for i, v in ipairs(self.monsterAreas) do
    local curNum = MonsterHelper:getMonsterNum(v, self.actorid)
    if (curNum < num) then
      for i = 1, num - curNum do
        local pos = AreaHelper:getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function Ox:timerGenerate (num)
  num = num or 10
  TimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    self:generateMonsters(num)
    return false
  end, 60)
end
-- 怪物

-- 野狗
Dog = BaseActor:new(MyMap.ACTOR.DOG_ACTOR_ID)

function Dog:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 3,
      exp = 10
    },
    fallOff = {
      { MyMap.ITEM.ANIMAL_BONE_ID, 1, 1, 20 }, -- 兽骨
      { MyMap.ITEM.COIN_ID, 1, 1, 30 } -- 铜板
    },
    monsterPositions = {
      MyPosition:new(-75, 7, -75), -- 生成区域内位置
    },
    monsterAreas = {},
    tipPositions = {
      MyPosition:new(-75, 8, -75) -- 村外山泉
    },
    areaids = {}, -- 提示区域
    areaName = '村外山泉'
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Dog:init ()
  -- 怪物定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper.getAreaByPos(v))
  end
  -- 提示区域
  table.insert(self.areaids, -1)
  table.insert(self.areaids, AreaHelper.getAreaByPos(self.tipPositions[1]))
  self.generate = function () -- 进入附近区域需要生成怪物
    self:generateMonsters()
  end
  return true
end

function Dog:getName ()
  if (not(self.actorname)) then
    self.actorname = '野狗'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function Dog:generateMonsters (num)
  num = num or 10
  for i, v in ipairs(self.monsterAreas) do
    local curNum = MonsterHelper.getMonsterNum(v, self.actorid)
    if (curNum < num) then
      for i = 1, num - curNum do
        local pos = AreaHelper.getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function Dog:timerGenerate (num)
  num = num or 10
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters(num)
    return false
  end, 60, self.actorid .. 'generate')
end

function Dog:attackSpeak (objid)
  -- ChatHelper.speak(self:getName(), toobjid, '汪汪。')
  -- self:toastSpeak('汪汪。')
  GraphicsHelper.speak(objid, self.offset, '汪汪。')
end

-- 恶狼
Wolf = BaseActor:new(MyMap.ACTOR.WOLF_ACTOR_ID)

function Wolf:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 5,
      exp = 18
    },
    fallOff = {
      { MyMap.ITEM.ANIMAL_BONE_ID, 1, 2, 20 }, -- 兽骨
      { MyMap.ITEM.COIN_ID, 1, 1, 30 } -- 铜板
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
    areaids = {}, -- 提示区域
    areaName = '恶狼谷'
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Wolf:init ()
  -- 怪物定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper.getAreaByPos(v))
  end
  -- 恶狼谷提示区域
  for i, v in ipairs(self.ravinePositions) do
    table.insert(self.areaids, AreaHelper.getAreaByPos(v))
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
    local curNum = MonsterHelper.getMonsterNum(v, self.actorid)
    if (curNum < num) then
      for i = 1, num - curNum do
        local pos = AreaHelper.getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function Wolf:timerGenerate (num)
  num = num or 10
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters(num)
    return false
  end, 60, self.actorid .. 'generate')
end

function Wolf:attackSpeak (objid)
  -- ChatHelper.speak(self:getName(), toobjid, '嗷呜……')
  -- self:toastSpeak('嗷呜……')
  GraphicsHelper.speak(objid, self.offset, '嗷呜……')
end

-- 狂牛
Ox = BaseActor:new(MyMap.ACTOR.OX_ACTOR_ID)

function Ox:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 7,
      exp = 23
    },
    fallOff = {
      { MyMap.ITEM.ANIMAL_BONE_ID, 2, 3, 20 }, -- 兽骨
      { MyMap.ITEM.COIN_ID, 1, 3, 30 } -- 铜板
    },
    monsterPositions = {
      { x = -174, y = 7, z = -16 }, -- 狂牛区域
    },
    monsterAreas = {},
    tipPositions = {
      { x = -175, y = 8, z = 5 }
    },
    areaids = {},
    areaName = '狂牛草原'
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Ox:init ()
  -- 怪物定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper.getAreaByPos(v))
  end
  -- 狂牛草原提示区域
  table.insert(self.areaids, -1)
  table.insert(self.areaids, AreaHelper.getAreaByPos(self.tipPositions[1]))
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
    local curNum = MonsterHelper.getMonsterNum(v, self.actorid)
    if (curNum < num) then
      for i = 1, num - curNum do
        local pos = AreaHelper.getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function Ox:timerGenerate (num)
  num = num or 10
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters(num)
    return false
  end, 60, self.actorid .. 'generate')
end

function Ox:attackSpeak (objid)
  -- ChatHelper.speak(self:getName(), toobjid, '哞……')
  -- self:toastSpeak('哞……')
  GraphicsHelper.speak(objid, self.offset, '哞……')
end

-- 强盗喽罗
QiangdaoLouluo = BaseActor:new(MyMap.ACTOR.QIANGDAO_LOULUO_ACTOR_ID)

function QiangdaoLouluo:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 8,
      exp = 25
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 1, 30 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 2, 4, 50 } -- 铜板
    },
    initPosition = { x = 34, y = 7, z = 327 }, -- 剧情二初始化位置
    -- toPosition = { x = -363, y = 7, z = 556 },
    monsters = {},
    monsterPositions = {
      { x = 229, y = 8, z = 49 },
      { x = 255, y = 8, z = 45 },
      { x = 243, y = 15, z = -4 },
      { x = 277, y = 14, z = 34 }
    },
    monsterAreas = {},
    encampmentPositions = {
      MyPosition:new(224.5, 8.5, 69.5),
      MyPosition:new(224.5, 8.5, 68.5)
    },
    areaids = {},
    areaName = '强盗营地'
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function QiangdaoLouluo:init ()
  -- 强盗定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper.getAreaByPos(v))
  end
  -- 强盗营地提示区域
  for i, v in ipairs(self.encampmentPositions) do
    table.insert(self.areaids, AreaHelper.getAreaByPos(v))
  end
  self.action = BaseActorAction:new(self)
  self.generate = function ()
    self:generateMonsters()
    qiangdaoXiaotoumu:generateMonsters()
    qiangdaoDatoumu:generateMonsters()
  end
  return true
end

function QiangdaoLouluo:initStoryMonsters ()
  local areaid = AreaHelper.getAreaByPos(self.initPosition)
  local objids = AreaHelper.getAllCreaturesInAreaId(areaid)
  if (objids and #objids > 0) then
    for i, v in ipairs(objids) do
      table.insert(self.monsters, v)
    end
    -- self:setPositions({self.toPosition})
    -- 清除木围栏
    -- AreaHelper.clearAllWoodenFence(areaid)
  end
end

function QiangdaoLouluo:setPositions (positions)
  if (positions and #positions > 0) then
    if (#positions == 1) then
      local pos = positions[1]
      for i, v in ipairs(self.monsters) do
        ActorHelper.setPosition(v, pos.x, pos.y, pos.z)
      end
    else
      for i, v in ipairs(self.monsters) do
        local pos = positions[i]
        if (pos) then
          ActorHelper.setPosition(v, pos.x, pos.y, pos.z)
        else
          break
        end
      end
    end
  end
end

function QiangdaoLouluo:enableMove (enable)
  local speed
  if (enable) then
    speed = -1
  else
    speed = 0
  end
  for i, v in ipairs(self.monsters) do
    -- ActorHelper.setEnableMoveState(v, enable)
    CreatureHelper.setWalkSpeed(v, speed)
  end
end

function QiangdaoLouluo:setAIActive (isActive, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    CreatureHelper.setAIActive(v, isActive)
  end
end

function QiangdaoLouluo:lookAt (objid, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    ActorHelper.lookAt(v, objid)
  end
end

function QiangdaoLouluo:getName ()
  if (not(self.actorname)) then
    self.actorname = '强盗喽罗'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function QiangdaoLouluo:generateMonsters ()
  num = num or 5
  for i, v in ipairs(self.monsterAreas) do
    local curNum = MonsterHelper.getMonsterNum(v, self.actorid)
    if (curNum < num) then
      for i = 1, num - curNum do
        local pos = AreaHelper.getRandomAirPositionInArea(v)
        self:newMonster(pos.x, pos.y, pos.z, 1)
      end
    end
  end
end

-- 定时生成怪物
function QiangdaoLouluo:timerGenerate (num)
  num = num or 5
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters(num)
    return false
  end, 60, self.actorid .. 'generate')
end

function QiangdaoLouluo:attackSpeak (objid)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if (mainIndex == 2 and mainProgress < #story2.tips) then
    -- ChatHelper.speak(self:getName(), toobjid, '小子，把令牌交出来！')
    -- self:toastSpeak('小子，把令牌交出来！')
    GraphicsHelper.speak(objid, self.offset, '小子，把令牌交出来！')
  else
    -- ChatHelper.speak(self:getName(), toobjid, '小子，把财物都交出来！')
    -- self:toastSpeak('小子，把财物都交出来！')
    GraphicsHelper.speak(objid, self.offset, '小子，把财物都交出来！')
  end
end

-- 强盗小头目
QiangdaoXiaotoumu = BaseActor:new(MyMap.ACTOR.QIANGDAO_XIAOTOUMU_ACTOR_ID)

function QiangdaoXiaotoumu:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 12,
      exp = 35
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 2, 30 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 4, 8, 50 } -- 铜板
    },
    initPosition = { x = 33, y = 7, z = 334 },
    -- toPosition = { x = -363, y = 7, z = 556 },
    monsters = {},
    monsterPositions = {
      { x = 229, y = 8, z = 49 },
      { x = 255, y = 8, z = 45 },
      { x = 243, y = 15, z = -4 },
      { x = 277, y = 14, z = 34 }
    },
    monsterAreas = {}
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function QiangdaoXiaotoumu:init ()
  -- 强盗小头目定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper.getAreaByPos(v))
  end
  self.action = BaseActorAction:new(self)
  self.generate = function ()
    self:generateMonsters()
  end
  return true
end

function QiangdaoXiaotoumu:initStoryMonsters ()
  local areaid = AreaHelper.getAreaByPos(self.initPosition)
  local objids = AreaHelper.getAllCreaturesInAreaId(areaid)
  if (objids and #objids > 0) then
    for i, v in ipairs(objids) do
      table.insert(self.monsters, v)
    end
    -- self:setPositions({self.toPosition})
    -- 清除木围栏
    -- AreaHelper.clearAllWoodenFence(areaid)
  end
end

function QiangdaoXiaotoumu:setPositions (positions)
  if (positions and #positions > 0) then
    if (#positions == 1) then
      local pos = positions[1]
      for i, v in ipairs(self.monsters) do
        ActorHelper.setPosition(v, pos.x, pos.y, pos.z)
      end
    else
      for i, v in ipairs(self.monsters) do
        local pos = positions[i]
        if (pos) then
          ActorHelper.setPosition(v, pos.x, pos.y, pos.z)
        else
          break
        end
      end
    end
  end
end

function QiangdaoXiaotoumu:enableMove (enable)
  local speed
  if (enable) then
    speed = -1
  else
    speed = 0
  end
  for i, v in ipairs(self.monsters) do
    -- ActorHelper.setEnableMoveState(v, enable)
    CreatureHelper.setWalkSpeed(v, speed)
  end
end

function QiangdaoXiaotoumu:setAIActive (isActive, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    CreatureHelper.setAIActive(v, isActive)
  end
end

function QiangdaoXiaotoumu:lookAt (objid, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    ActorHelper.lookAt(v, objid)
  end
end

function QiangdaoXiaotoumu:getName ()
  if (not(self.actorname)) then
    self.actorname = '强盗小头目'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function QiangdaoXiaotoumu:generateMonsters (num)
  num = num or 1
  for i, v in ipairs(self.monsterAreas) do
    local curNum = MonsterHelper.getMonsterNum(v, self.actorid)
    if (curNum < num) then
      self:newMonster(self.monsterPositions[i].x, self.monsterPositions[i].y, self.monsterPositions[i].z, num - curNum)
    end
  end
end

-- 定时生成怪物
function QiangdaoXiaotoumu:timerGenerate (num)
  num = num or 1
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters(num)
    return false
  end, 60, self.actorid .. 'generate')
end

function QiangdaoXiaotoumu:attackSpeak (objid)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if (mainIndex == 2 and mainProgress < #story2.tips) then
    -- ChatHelper.speak(self:getName(), toobjid, '小子，交出令牌给你个痛快！')
    -- self:toastSpeak('小子，交出令牌给你个痛快！')
    GraphicsHelper.speak(objid, self.offset, '小子，交出令牌给你个痛快！')
  else
    -- ChatHelper.speak(self:getName(), toobjid, '小子，纳命来！')
    -- self:toastSpeak('小子，纳命来！')
    GraphicsHelper.speak(objid, self.offset, '小子，纳命来！')
  end
end

-- 强盗大头目
QiangdaoDatoumu = BaseActor:new(MyMap.ACTOR.QIANGDAO_DATOUMU_ACTOR_ID)

function QiangdaoDatoumu:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 15,
      exp = 45
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 2, 30 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 5, 15, 100 } -- 铜板
    },
    begPos = MyPosition:new(282, 19, -12), -- 起点位置
    endPos = MyPosition:new(224, 8, 63), -- 终点位置
    monsterPositions = {
      MyPosition:new(271, 18, 12)
    }
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function QiangdaoDatoumu:init ()
  self.generate = function ()
    self:generateMonsters()
  end
  return true
end

function QiangdaoDatoumu:getName ()
  if (not(self.actorname)) then
    self.actorname = '强盗大头目'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function QiangdaoDatoumu:generateMonsters (num)
  num = num or 1
  local curNum = MonsterHelper.getMonsterNumByPos(self.begPos, self.endPos, self.actorid)
  for i, v in ipairs(self.monsterPositions) do
    if (curNum < num) then
      self:newMonster(v.x, v.y, v.z, num - curNum)
    end
  end
end

-- 定时生成怪物
function QiangdaoDatoumu:timerGenerate (num)
  num = num or 1
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters(num)
    return false
  end, 120, self.actorid .. 'generate')
end

function QiangdaoDatoumu:attackSpeak (objid)
  -- ChatHelper.speak(self:getName(), toobjid, '小子，我看你是活腻了！')
    -- self:toastSpeak('小子，我看你是活腻了！')
    GraphicsHelper.speak(objid, self.offset, '小子，我看你是活腻了！')
end

-- 卫兵（剑）
Guard = BaseActor:new(MyMap.ACTOR.GUARD_ACTOR_ID)

function Guard:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 10,
      exp = 60
    },
    fallOff = {
      { MyWeaponAttr.bronzeSword.levelIds[1], 1, 1, 5 }, -- 青铜剑
      { MyMap.ITEM.COIN_ID, 5, 8, 20 } -- 铜板
    },
    initPositions = {
      MyPosition:new(-39.5, 7, 478.5), -- 南城门卫兵位置
      MyPosition:new(-32.5, 7, 478.5), -- 南城门卫兵位置
      MyPosition:new(37.5, 7, 548.5), -- 东城门卫兵位置
      MyPosition:new(37.5, 7, 555.5), -- 东城门卫兵位置
      MyPosition:new(-32.5, 7, 625.5), -- 北城门卫兵位置
      MyPosition:new(-39.5, 7, 625.5), -- 北城门卫兵位置
      MyPosition:new(-109.5, 7, 555.5), -- 西城门卫兵位置
      MyPosition:new(-109.5, 7, 548.5), -- 西城门卫兵位置
      MyPosition:new(-50.5, 7, 529.5) -- 城主府卫兵位置
    },
    initPositions2 = {
      MyPosition:new(-32.5, 7, 479.5), -- 南门
      MyPosition:new(36.5, 7, 555.5), -- 东门
      MyPosition:new(-39.5, 7, 624.5), -- 北门
      MyPosition:new(-108.5, 7, 548.5) -- 西门
    },
    initAreas = {},  -- 进城区域，对象数组长度5
    initAreas2 = {}, -- 进城后区域，数值数组长度4
    safePositions = {
      MyPosition:new(-35.5, 8.5, 464.5), -- 南
      MyPosition:new(52.5, 8.5, 552.5), -- 东
      MyPosition:new(-36.5, 8.5, 640.5), -- 北
      MyPosition:new(-122.5, 8.5, 551.5) -- 西
    }, -- 安全地点，未持有令牌前往地点
    lordHousePositions = {
      MyPosition:new(-42.5, 7, 528.5), -- 城主府门口卫兵位置
      MyPosition:new(-29.5, 7, 528.5) -- 城主府门口卫兵位置
    },
    lordHousePatrolPositions = {
      MyPosition:new(-21, 7, 531), -- 城主府卫兵巡逻位置
      MyPosition:new(-51, 7, 531), -- 城主府卫兵巡逻位置
      MyPosition:new(-51, 7, 572), -- 城主府卫兵巡逻位置
      MyPosition:new(-21, 7, 572) -- 城主府卫兵巡逻位置
    },
    patrolGuards = {}
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Guard:init ()
  for i, v in ipairs(self.initPositions) do
    if (i % 2 == 1) then
      table.insert(self.initAreas, { areaid = AreaHelper.getAreaByPos(v), isOk = false })
    end
  end
  for i, v in ipairs(self.initPositions2) do
    table.insert(self.initAreas2, AreaHelper.getAreaByPos(v))
  end
  self.action = BaseActorAction:new(self)
  TimeHelper.repeatUtilSuccess(function ()
    local isAllOk = true
    for i, v in ipairs(self.initAreas) do
      if (not(v.isOk)) then
        local objids = AreaHelper.getAllCreaturesInAreaId(v.areaid)
        if (objids and #objids > 0) then
          self:initCityGuard(i, v, objids)
        else
          isAllOk = false
        end
      end
    end
    return isAllOk
  end, 1, self.actorid .. 'initGuard')
end

function Guard:initCityGuard (index, o, objids)
  o.objids = objids
  local dir
  if (index == 1) then -- 南
    dir = 'S'
  elseif (index == 2) then -- 东
    dir = 'E'
  elseif (index == 3) then -- 北
    dir = 'N'
  elseif (index == 4) then -- 西
    dir = 'W'
  else
    for i, v in ipairs(objids) do
      CreatureHelper.closeAI(v)
      if (i == 1) then
        ActorHelper.setMyPosition(v, self.lordHousePositions[i])
        ActorHelper.lookToward(v, 'E')
      elseif (i == 2) then
        ActorHelper.setMyPosition(v, self.lordHousePositions[i])
        ActorHelper.lookToward(v, 'W')
      else
        ActorHelper.setMyPosition(v, self.lordHousePatrolPositions[i - 2])
        local g = BaseActor:new(MyMap.ACTOR.GUARD_ACTOR_ID, v)
        g:wantPatrol('patrol', self.lordHousePatrolPositions, false, i - 2)
        table.insert(self.patrolGuards, g)
      end
    end
  end
  if (index < 5) then
    for i, v in ipairs(objids) do
      CreatureHelper.closeAI(v)
      ActorHelper.setMyPosition(v, self.initPositions[(index - 1) * 2 + i])
      ActorHelper.lookToward(v, dir)
    end
  end
  AreaHelper.clearAllWoodenFence(o.areaid)
  o.isOk = true
end

function Guard:getName ()
  if (not(self.actorname)) then
    self.actorname = '卫兵'
  end
  return self.actorname
end

function Guard:toPatrol ()
  -- body
end

function Guard:checkTokenArea (objid, areaid)
  for i, v in ipairs(self.initAreas) do
    if (i < 5 and v.areaid == areaid) then
      local playerids = AreaHelper.getAllPlayersInAreaId(areaid)
      local players = {}
      local hasToken = false
      for ii, vv in ipairs(playerids) do
        local player = PlayerHelper.getPlayer(vv)
        table.insert(players, player)
        if (player:takeOutItem(MyMap.ITEM.TOKEN_ID)) then
          hasToken = true
        end
      end
      if (not(hasToken)) then
        for ii, vv in ipairs(players) do
          -- self:speakTo(vv.objid, 0, '出示令牌。强闯者，捕。')
          self:toastSpeak('出示令牌。强闯者，捕。')
          TimeHelper.callFnCanRun(function ()
            MonsterHelper.wantLookAt(v.objids, vv.objid, 5)
          end, 5, vv.objid .. 'checkToken')
          vv.action:runTo({ self.safePositions[i] }, function ()
            vv:thinkTo(vv.objid, 0, '还是不要乱跑比较好。')
          end)
        end
      end
      return true
    end
  end
  return false
end

-- 叛逃士兵（剑）
Pantaojianshibing = BaseActor:new(MyMap.ACTOR.PANTAOJIANSHIBING_ACTOR_ID)

function Pantaojianshibing:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 15,
      exp = 32
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 2, 30 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 10, 20, 30 } -- 铜板
    },
    monsterPosCouples = {
      -- 岗哨一楼
      { MyPosition:new(297, 7, 521), MyPosition:new(303, 7, 528), 2 },
      { MyPosition:new(297, 7, 563), MyPosition:new(303, 7, 556), 2 },
      { MyPosition:new(261, 7, 563), MyPosition:new(255, 7, 556), 2 },
      { MyPosition:new(261, 7, 521), MyPosition:new(255, 7, 528), 2 },
      -- 仓库
      { MyPosition:new(286, 7, 563), MyPosition:new(272, 7, 557), 2 },
      -- 宿舍
      { MyPosition:new(281, 7, 550), MyPosition:new(265, 7, 534), 4 },
      -- 主营
      { MyPosition:new(302, 8, 537), MyPosition:new(292, 8, 547), 3 },
    },
    monsterAreaInfos = {},
    tipPosCouples = {
      { MyPosition:new(247, 7, 546), MyPosition:new(247, 10, 538) },
      { MyPosition:new(248, 7, 545), MyPosition:new(248, 10, 539) },
    },
    areaids = {},
    areaName = '叛军营地'
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Pantaojianshibing:init ()
  -- 定时生成区域
  for i, v in ipairs(self.monsterPosCouples) do
    local areaid = AreaHelper.createAreaRectByRange(v[1], v[2])
    table.insert(self.monsterAreaInfos, { areaid = areaid, num = v[3] })
  end
  -- 提示区域
  for i, v in ipairs(self.tipPosCouples) do
    table.insert(self.areaids, AreaHelper.createAreaRectByRange(v[1], v[2]))
  end
  self.generate = function ()
    self:generateMonsters()
    gongshibing:generateMonsters()
  end
  return true
end

function Pantaojianshibing:getName ()
  if (not(self.actorname)) then
    self.actorname = '叛逃士兵'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function Pantaojianshibing:generateMonsters ()
  for i, v in ipairs(self.monsterAreaInfos) do
    local curNum = MonsterHelper.getMonsterNum(v.areaid, self.actorid)
    for i = 1, v.num - curNum do
      local pos = AreaHelper.getRandomAirPositionInArea(v.areaid)
      self:newMonster(pos.x, pos.y, pos.z, 1)
    end
  end
end

-- 定时生成怪物
function Pantaojianshibing:timerGenerate ()
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters()
    return false
  end, 60, self.actorid .. 'generate')
end

function Pantaojianshibing:attackSpeak (objid)
  -- ChatHelper.speak(self:getName(), toobjid, '小子，你来错地方了！')
  -- self:toastSpeak('小子，你来错地方了！')
    GraphicsHelper.speak(objid, self.offset, '小子，你来错地方了！')
end


-- 叛逃士兵（弓）
Pantaogongshibing = BaseActor:new(MyMap.ACTOR.PANTAOGONGSHIBING_ACTOR_ID)

function Pantaogongshibing:new ()
  local o = {
    objid = self.actorid,
    expData = {
      level = 18,
      exp = 35
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 2, 30 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 10, 20, 30 } -- 铜板
    },
    monsterPosCouples = {
      -- 岗哨二楼
      { MyPosition:new(257, 16, 527), MyPosition:new(256, 16, 525), 1 },
      { MyPosition:new(257, 16, 559), MyPosition:new(256, 16, 557), 1 },
      { MyPosition:new(302, 16, 559), MyPosition:new(301, 16, 557), 1 },
      { MyPosition:new(301, 16, 527), MyPosition:new(302, 16, 525), 1 },
    },
    monsterAreaInfos = {},
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Pantaogongshibing:init ()
  -- 定时生成区域
  for i, v in ipairs(self.monsterPosCouples) do
    local areaid = AreaHelper.createAreaRectByRange(v[1], v[2])
    table.insert(self.monsterAreaInfos, { areaid = areaid, num = v[3] })
  end
  return true
end

function Pantaogongshibing:getName ()
  if (not(self.actorname)) then
    self.actorname = '叛逃士兵'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function Pantaogongshibing:generateMonsters ()
  for i, v in ipairs(self.monsterAreaInfos) do
    local curNum = MonsterHelper.getMonsterNum(v.areaid, self.actorid)
    for i = 1, v.num - curNum do
      local pos = AreaHelper.getRandomAirPositionInArea(v.areaid)
      self:newMonster(pos.x, pos.y, pos.z, 1)
    end
  end
end

-- 定时生成怪物
function Pantaogongshibing:timerGenerate ()
  TimeHelper.repeatUtilSuccess(function ()
    self:generateMonsters()
    return false
  end, 60, self.actorid .. 'generate')
end

function Pantaogongshibing:attackSpeak (objid)
  -- ChatHelper.speak(self:getName(), toobjid, '小子看箭！')
  -- self:toastSpeak('小子看箭！')
  GraphicsHelper.speak(objid, self.offset, '小子看箭！')
end

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
  setmetatable(o, self)
  self.__index = self
  return o
end

function Dog:init ()
  -- 怪物定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper:getAreaByPos(v))
  end
  -- 提示区域
  table.insert(self.areaids, -1)
  table.insert(self.areaids, AreaHelper:getAreaByPos(self.tipPositions[1]))
  self.generate = function ()
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
function Dog:timerGenerate (num)
  num = num or 10
  TimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    self:generateMonsters(num)
    return false
  end, 60)
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
  table.insert(self.areaids, AreaHelper:getAreaByPos(self.tipPositions[1]))
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
      { MyMap.ITEM.COIN_ID, 2, 4, 30 } -- 铜板
    },
    initPosition = { x = 34, y = 7, z = 327 },
    toPosition = { x = -363, y = 7, z = 556 },
    monsters = {},
    monsterPositions = {
      { x = 229, y = 8, z = 49 },
      { x = 255, y = 8, z = 45 },
      { x = 243, y = 14, z = -4 }
    },
    monsterAreas = {},
    encampmentPositions = {
      MyPosition:new(224.5, 8.5, 69.5),
      MyPosition:new(224.5, 8.5, 68.5)
    },
    areaids = {},
    areaName = '强盗营地'
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function QiangdaoLouluo:init ()
  -- 强盗定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper:getAreaByPos(v))
  end
  -- 强盗营地提示区域
  for i, v in ipairs(self.encampmentPositions) do
    table.insert(self.areaids, AreaHelper:getAreaByPos(v))
  end
  self.generate = function ()
    self:generateMonsters()
    qiangdaoXiaotoumu:generateMonsters()
  end
  return true
end

function QiangdaoLouluo:initStoryMonsters ()
  local areaid = AreaHelper:getAreaByPos(self.initPosition)
  local objids = AreaHelper:getAllCreaturesInAreaId(areaid)
  if (objids and #objids > 0) then
    self.action = BaseActorAction:new(self)
    for i, v in ipairs(objids) do
      table.insert(self.monsters, v)
    end
    self:setPositions({self.toPosition})
    -- 清除木围栏
    AreaHelper:clearAllWoodenFence(areaid)
  end
end

function QiangdaoLouluo:setPositions (positions)
  if (positions and #positions > 0) then
    if (#positions == 1) then
      local pos = positions[1]
      for i, v in ipairs(self.monsters) do
        ActorHelper:setPosition(v, pos.x, pos.y, pos.z)
      end
    else
      for i, v in ipairs(self.monsters) do
        local pos = positions[i]
        if (pos) then
          ActorHelper:setPosition(v, pos.x, pos.y, pos.z)
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
    -- ActorHelper:setEnableMoveState(v, enable)
    CreatureHelper:setWalkSpeed(v, speed)
  end
end

function QiangdaoLouluo:setAIActive (isActive, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    CreatureHelper:setAIActive(v, isActive)
  end
end

function QiangdaoLouluo:lookAt (objid, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    ActorHelper:lookAt(v, objid)
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
function QiangdaoLouluo:timerGenerate (num)
  num = num or 5
  TimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    self:generateMonsters(num)
    return false
  end, 60)
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
      { MyMap.ITEM.COIN_ID, 4, 8, 30 } -- 铜板
    },
    initPosition = { x = 33, y = 7, z = 334 },
    toPosition = { x = -363, y = 7, z = 556 },
    monsters = {},
    monsterPositions = {
      { x = 229, y = 8, z = 49 },
      { x = 255, y = 8, z = 45 },
      { x = 243, y = 14, z = -4 }
    },
    monsterAreas = {}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function QiangdaoXiaotoumu:init ()
  -- 强盗小头目定时生成区域
  for i, v in ipairs(self.monsterPositions) do
    table.insert(self.monsterAreas, AreaHelper:getAreaByPos(v))
  end
  self.generate = function ()
    self:generateMonsters()
  end
  return true
end

function QiangdaoXiaotoumu:initStoryMonsters ()
  local areaid = AreaHelper:getAreaByPos(self.initPosition)
  local objids = AreaHelper:getAllCreaturesInAreaId(areaid)
  if (objids and #objids > 0) then
    self.action = BaseActorAction:new(self)
    for i, v in ipairs(objids) do
      table.insert(self.monsters, v)
    end
    self:setPositions({self.toPosition})
    -- 清除木围栏
    AreaHelper:clearAllWoodenFence(areaid)
  end
end

function QiangdaoXiaotoumu:setPositions (positions)
  if (positions and #positions > 0) then
    if (#positions == 1) then
      local pos = positions[1]
      for i, v in ipairs(self.monsters) do
        ActorHelper:setPosition(v, pos.x, pos.y, pos.z)
      end
    else
      for i, v in ipairs(self.monsters) do
        local pos = positions[i]
        if (pos) then
          ActorHelper:setPosition(v, pos.x, pos.y, pos.z)
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
    -- ActorHelper:setEnableMoveState(v, enable)
    CreatureHelper:setWalkSpeed(v, speed)
  end
end

function QiangdaoXiaotoumu:setAIActive (isActive, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    CreatureHelper:setAIActive(v, isActive)
  end
end

function QiangdaoXiaotoumu:lookAt (objid, monsters)
  monsters = monsters or self.monsters
  for i, v in ipairs(monsters) do
    ActorHelper:lookAt(v, objid)
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
    local curNum = MonsterHelper:getMonsterNum(v, self.actorid)
    if (curNum < num) then
      self:newMonster(self.monsterPositions[i].x, self.monsterPositions[i].y, self.monsterPositions[i].z, num - curNum)
    end
  end
end

-- 定时生成怪物
function QiangdaoXiaotoumu:timerGenerate (num)
  num = num or 5
  TimeHelper:repeatUtilSuccess(self.actorid, 'generate', function ()
    self:generateMonsters(num)
    return false
  end, 60)
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
  setmetatable(o, self)
  self.__index = self
  return o
end

function Guard:init ()
  for i, v in ipairs(self.initPositions) do
    if (i % 2 == 1) then
      table.insert(self.initAreas, { areaid = AreaHelper:getAreaByPos(v), isOk = false })
    end
  end
  for i, v in ipairs(self.initPositions2) do
    table.insert(self.initAreas2, AreaHelper:getAreaByPos(v))
  end
  self.action = BaseActorAction:new(self)
  TimeHelper:repeatUtilSuccess(self.actorid, 'initGuard', function ()
    local isAllOk = true
    for i, v in ipairs(self.initAreas) do
      if (not(v.isOk)) then
        local objids = AreaHelper:getAllCreaturesInAreaId(v.areaid)
        if (objids and #objids > 0) then
          self:initCityGuard(i, v, objids)
        else
          isAllOk = false
        end
      end
    end
    return isAllOk
  end, 1)
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
      CreatureHelper:closeAI(v)
      if (i == 1) then
        ActorHelper:setMyPosition(v, self.lordHousePositions[i])
        ActorHelper:lookToward(v, 'E')
      elseif (i == 2) then
        ActorHelper:setMyPosition(v, self.lordHousePositions[i])
        ActorHelper:lookToward(v, 'W')
      else
        ActorHelper:setMyPosition(v, self.lordHousePatrolPositions[i - 2])
        local g = BaseActor:new(MyMap.ACTOR.GUARD_ACTOR_ID, v)
        g:wantPatrol('patrol', self.lordHousePatrolPositions, false, i - 2)
        table.insert(self.patrolGuards, g)
      end
    end
  end
  if (index < 5) then
    for i, v in ipairs(objids) do
      CreatureHelper:closeAI(v)
      ActorHelper:setMyPosition(v, self.initPositions[(index - 1) * 2 + i])
      ActorHelper:lookToward(v, dir)
    end
  end
  AreaHelper:clearAllWoodenFence(o.areaid)
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
      local playerids = AreaHelper:getAllPlayersInAreaId(areaid)
      local players = {}
      local hasToken = false
      for ii, vv in ipairs(playerids) do
        local player = PlayerHelper:getPlayer(vv)
        table.insert(players, player)
        if (player:takeOutItem(MyMap.ITEM.TOKEN_ID)) then
          hasToken = true
        end
      end
      if (not(hasToken)) then
        for ii, vv in ipairs(players) do
          self:speakTo(vv.objid, 0, '出示令牌。强闯者，捕。')
          TimeHelper:callFnCanRun(vv.objid, 'checkToken', function ()
            MonsterHelper:wantLookAt(v.objids, vv.objid, 5)
          end, 5)
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
-- 强盗小头目
QiangdaoXiaotoumu = BaseActor:new(MyMap.ACTOR.QIANGDAO_XIAOTOUMU_ACTOR_ID)

function QiangdaoXiaotoumu:new ()
  local o = {
    objid = MyMap.ACTOR.QIANGDAO_XIAOTOUMU_ACTOR_ID,
    expData = {
      level = 7,
      exp = 40
    },
    fallOff = {
      { MyMap.ITEM.APPLE_ID, 1, 30 }, -- 苹果
      { MyMap.ITEM.COIN_ID, 10, 30 } -- 铜板
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
    self.action = MyActorAction:new(self)
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
    MonsterHelper:lookAt(v, objid)
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
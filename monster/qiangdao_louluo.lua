-- 强盗喽罗
QiangdaoLouluo = MyActor:new(MyConstant.QIANGDAO_LOULUO_ACTOR_ID)

function QiangdaoLouluo:new ()
  local o = {
    objid = MyConstant.QIANGDAO_LOULUO_ACTOR_ID,
    expData = {
      level = 5,
      exp = 25
    },
    fallOff = {
      { MyConstant.ITEM.APPLE_ID, 1, 30 }, -- 苹果
      { MyConstant.ITEM.COIN_ID, 5, 70 } -- 铜板
    },
    initPosition = { x = 22, y = 7, z = 37 },
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
  for i, v in ipairs(self.encampmentPositions) do
    table.insert(self.areaids, AreaHelper:getAreaByPos(v))
  end
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
    return true
  else
    return false
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
    MonsterHelper:lookAt(v, objid)
  end
end

function QiangdaoLouluo:getName ()
  if (not(self.actorname)) then
    self.actorname = '强盗喽罗'
  end
  return self.actorname
end

-- 检查各个区域内的怪物数量，少于num只则补充到num只
function QiangdaoLouluo:generateMonsters (num)
  num = num or 5
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
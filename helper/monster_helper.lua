-- 怪物工具类
MonsterHelper = {
  monsters = {}, -- objid -> actor
  forceDoNothingMonsters = {}, -- objid -> times 禁锢次数
  sealedMonsters = {} -- objid -> times
}

function MonsterHelper:addMonster (objid, o)
  self.monsters[objid] = o
end

function MonsterHelper:delMonsterByObjid (objid)
  self.monsters[objid] = nil
end

function MonsterHelper:delMonstersByActorid (actorid)
  for k, v in pairs(self.monsters) do
    if (v.actorid == actorid) then
      self.monsters[k] = nil
    end
  end
end

function MonsterHelper:getMonsterByObjid (objid)
  return self.monsters[objid]
end

function MonsterHelper:init ()
  qiangdaoXiaotoumu = QiangdaoXiaotoumu:new()
  qiangdaoLouluo = QiangdaoLouluo:new()
  wolf = Wolf:new()
  qiangdaoXiaotoumu:generateMonsters()
  qiangdaoLouluo:generateMonsters()
  wolf:generateMonsters()
  self:initMonsters()
end

function MonsterHelper:initMonsters ()
  -- LogHelper:debug('初始化怪物开始')
  local monsters = { qiangdaoXiaotoumu, qiangdaoLouluo, wolf }
  for i, v in ipairs(monsters) do
    MyTimeHelper:initActor(v)
    -- LogHelper:debug('初始化', v:getName(), '完成')
  end
  LogHelper:debug('初始化怪物结束')
end

function MonsterHelper:getExp (playerid, objid)
  local actorid = CreatureHelper:getActorID(objid)
  if (not(actorid)) then
    return 0
  end
  local monsterModels = { wolf, qiangdaoLouluo, qiangdaoXiaotoumu }
  for i, v in ipairs(monsterModels) do
    if (v.actorid == actorid) then
      return self:calExp(playerid, v.expData)
    end
  end
  return 0
end

function MonsterHelper:calExp (playerid, expData)
  local player = MyPlayerHelper:getPlayer(playerid)
  local levelDiffer = player.totalLevel - expData.level
  if (levelDiffer <= 0) then
    return expData.exp
  else
    return math.ceil(expData.exp / math.pow(2, levelDiffer))
  end
end

function MonsterHelper:lookAt (objid, toobjid)
  if (type(objid) == 'table') then
    for i, v in ipairs(objid) do
      self:lookAt(v, toobjid)
    end
  else
    local x, y, z
    if (type(toobjid) == 'table') then
      x, y, z = toobjid.x, toobjid.y, toobjid.z
    else
      x, y, z = ActorHelper:getPosition(toobjid)
      y = y + ActorHelper:getEyeHeight(toobjid) - 1
    end
    local x0, y0, z0 = ActorHelper:getPosition(objid)
    y0 = y0 + ActorHelper:getEyeHeight(objid) - 1 -- 生物位置y是地面上一格，所以要减1
    local myVector3 = MyVector3:new(x0, y0, z0, x, y, z)
    local faceYaw = MathHelper:getActorFaceYaw(myVector3)
    local facePitch = MathHelper:getActorFacePitch(myVector3)
    ActorHelper:setFaceYaw(objid, faceYaw)
    ActorHelper:setFacePitch(objid, facePitch)
  end
end

function MonsterHelper:wantLookAt (objid, toobjid, seconds)
  MyTimeHelper:callFnContinueRuns(function ()
    self:lookAt(objid, toobjid)
  end, seconds, objid .. 'lookat')
end

function MonsterHelper:playAct (objid, act, afterSeconds)
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function (p)
      ActorHelper:playAct(objid, act)
    end, afterSeconds)
  else
    ActorHelper:playAct(objid, act)
  end
end

function MonsterHelper:actorDie (objid, toobjid)
  local actorid = CreatureHelper:getActorID(objid)
  local pos = MyPosition:new(ActorHelper:getPosition(objid))
  local monsterModels = { wolf, qiangdaoXiaotoumu, qiangdaoLouluo }
  for i, v in ipairs(monsterModels) do
    if (v.actorid == actorid) then
      self:createFallOff(v, pos)
      break
    end
  end
end

function MonsterHelper:createFallOff (monster, pos)
  if (monster.fallOff and #monster.fallOff > 0) then
    for i, v in ipairs(monster.fallOff) do
      local r = math.random(1, 100)
      if (v[3] > r) then
        local num = math.random(1, v[2])
        WorldHelper:spawnItem(pos.x, pos.y, pos.z, v[1], num)
      end
    end
  end
end

-- 禁锢怪物
function MonsterHelper:imprisonMonster (objid)
  local times = self.forceDoNothingMonsters[objid]
  if (times) then
    self.forceDoNothingMonsters[objid] = times + 1
  else
    self.forceDoNothingMonsters[objid] = 1
  end
  MyActorHelper:stopRun(objid)
end

-- 取消禁锢怪物，返回true表示已不是囚禁状态
function MonsterHelper:cancelImprisonMonster (objid)
  local times = self.forceDoNothingMonsters[objid]
  if (times) then
    if (times > 1) then
      self.forceDoNothingMonsters[objid] = times - 1
      return false
    else
      self.forceDoNothingMonsters[objid] = nil
      MyActorHelper:openAI(objid)
    end
  end
  return true
end

-- 封魔怪物
function MonsterHelper:sealMonster (objid)
  local times = self.sealedMonsters[objid]
  if (times) then
    self.sealedMonsters[objid] = times + 1
  else
    self.sealedMonsters[objid] = 1
  end
end

-- 取消封魔怪物
function MonsterHelper:cancelSealMonster (objid)
  local times = self.sealedMonsters[objid]
  if (times) then
    if (times > 1) then
      self.sealedMonsters[objid] = times - 1
      return false
    else
      self.sealedMonsters[objid] = nil
    end
  end
  return true
end
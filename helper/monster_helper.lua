-- 怪物工具类
MonsterHelper = {
  monsters = {}, -- 可击杀的怪物数组
  forceDoNothingMonsters = {}, -- objid -> times 禁锢次数
  sealedMonsters = {} -- objid -> times
}

function MonsterHelper:init ()
  qiangdaoXiaotoumu = QiangdaoXiaotoumu:new()
  qiangdaoLouluo = QiangdaoLouluo:new()
  wolf = Wolf:new()
  ox = Ox:new()
  self.monsters = { qiangdaoXiaotoumu, qiangdaoLouluo, wolf, ox }
  for i, v in ipairs(self.monsters) do
    MyTimeHelper:initActor(v)
    v:timerGenerate()
    -- LogHelper:debug('初始化', v:getName(), '完成')
  end
end

-- 玩家获得杀怪经验
function MonsterHelper:getExp (playerid, objid)
  local actorid = CreatureHelper:getActorID(objid)
  if (not(actorid)) then
    return 0
  end
  for i, v in ipairs(self.monsters) do
    if (v.actorid == actorid) then
      return self:calExp(playerid, v.expData)
    end
  end
  return 0
end

-- 计算玩家杀怪获得的经验
function MonsterHelper:calExp (playerid, expData)
  local player = MyPlayerHelper:getPlayer(playerid)
  local levelDiffer = player:getLevel() - expData.level
  if (levelDiffer <= -6) then -- 相差6级双倍经验
    return expData.exp * 2
  elseif (levelDiffer <= -3) then -- 相差3级1.5倍经验
    return math.floor(expData.exp * 1.5)
  elseif (levelDiffer <= 0) then
    return expData.exp
  else
    return math.ceil(expData.exp / math.pow(2, levelDiffer))
  end
end

-- 怪物看向
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
  local t = nil
  if (type(objid) == 'number') then
    t = objid .. 'lookat'
  end
  MyTimeHelper:callFnContinueRuns(function ()
    self:lookAt(objid, toobjid)
  end, seconds, t)
end

-- 怪物做表情
function MonsterHelper:playAct (objid, act, afterSeconds)
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function (p)
      ActorHelper:playAct(objid, act)
    end, afterSeconds)
  else
    ActorHelper:playAct(objid, act)
  end
end

-- 怪物死亡
function MonsterHelper:actorDie (objid, toobjid)
  local actorid = CreatureHelper:getActorID(objid)
  local pos = MyPosition:new(ActorHelper:getPosition(objid))
  for i, v in ipairs(self.monsters) do
    if (v.actorid == actorid) then
      self:createFallOff(v, pos)
      break
    end
  end
end

-- 创建怪物掉落
function MonsterHelper:createFallOff (monster, pos)
  if (monster.fallOff and #monster.fallOff > 0) then
    for i, v in ipairs(monster.fallOff) do
      local r = math.random(1, 100)
      if (v[3] > r) then
        local num = math.ceil(v[2] / 2)
        num = math.random(num, v[2])
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

-- 获取区域内actorid类型的生物数量
function MonsterHelper:getMonsterNum (areaid, actorid)
  local objids = AreaHelper:getAllCreaturesInAreaId(areaid)
  if (not(objids)) then
    return 0
  end
  if (not(actorid)) then
    return #objids
  end
  local curNum = 0
  for i, v in ipairs(objids) do
    local actid = CreatureHelper:getActorID(v)
    if (actid and actid == actorid) then
      curNum = curNum + 1
    end
  end
  return curNum
end
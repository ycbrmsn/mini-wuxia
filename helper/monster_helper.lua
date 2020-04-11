-- 怪物工具类
MonsterHelper = {
  monsters = {} -- objid -> actor
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
  self:initMonsters()
end

function MonsterHelper:initMonsters ()
  local monsters = { qiangdaoXiaotoumu, qiangdaoLouluo }
  for i, v in ipairs(monsters) do
    MyTimeHelper:initActor(v)
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

function MonsterHelper:playAct (objid, act, afterSeconds)
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function (p)
      ActorHelper:playAct(objid, act)
    end, afterSeconds)
  else
    ActorHelper:playAct(objid, act)
  end
end
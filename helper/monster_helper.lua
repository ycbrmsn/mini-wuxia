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
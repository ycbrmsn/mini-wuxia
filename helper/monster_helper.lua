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
  LogHelper:info('初始化怪物结束')
end
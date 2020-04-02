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

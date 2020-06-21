-- 刀
-- 木刀
WoodKnife = MyWeapon:new(MyWeaponAttr.woodKnife)

-- 青铜刀
BronzeKnife = MyWeapon:new(MyWeaponAttr.bronzeKnife)

-- 割鹿刀
CutDeerKnife = MyWeapon:new(MyWeaponAttr.cutDeerKnife)

-- 凝霜刀
CongealFrostKnife = MyWeapon:new(MyWeaponAttr.congealFrostKnife)

-- 攻击命中冰冻
function CongealFrostKnife:attackHit (objid, toobjid)
  local bufflv = self.level + 1
  local customticks = 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(toobjid, 45, bufflv, customticks)
end

-- 回春刀
RejuvenationKnife = MyWeapon:new(MyWeaponAttr.rejuvenationKnife)

function RejuvenationKnife:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('回春'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '回春技能冷却中')
    return
  end
  MyItemHelper:recordUseSkill(objid, self.id, self.cd)
  local bufflv = self.level + 1
  local customticks = (self.skillTime + self.level * self.addSkillTimePerLevel) * 20 -- 每秒20帧
  ActorHelper:addBuff(objid, 50, bufflv, customticks) -- 快速生命恢复
end

-- 封魔刀
SealDemonKnife = MyWeapon:new(MyWeaponAttr.sealDemonKnife)

function SealDemonKnife:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('封魔'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '封魔技能冷却中')
    return
  end
  local playerPos = player:getMyPosition()
  local skillRange = self.skillRange + self.level * self.addSkillRangePerLevel
  local areaid = AreaHelper:createAreaRect(playerPos, { x = skillRange, y = skillRange, z = skillRange })
  local objids = MyActorHelper:getAllOtherTeamActorsInAreaId(objid, areaid)
  AreaHelper:destroyArea(areaid)
  if (#objids > 0) then
    MyItemHelper:recordUseSkill(objid, self.id, self.cd)
    for i, v in ipairs(objids) do
      MyActorHelper:sealActor(v)
    end
    MyTimeHelper:callFnFastRuns (function ()
      for i, v in ipairs(objids) do
        MyActorHelper:cancelSealActor(v)
      end
    end, self.skillTime + self.level * self.addSkillTimePerLevel)
  else
    ChatHelper:sendSystemMsg('封魔技能有效范围内未发现目标', objid)
  end
end
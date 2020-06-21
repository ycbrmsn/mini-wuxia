-- 枪
-- 木枪
WoodSpear = MyWeapon:new(MyWeaponAttr.woodSpear)

-- 攻击命中
function WoodSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

-- 青铜枪
BronzeSpear = MyWeapon:new(MyWeaponAttr.bronzeSpear)

-- 攻击命中
function BronzeSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

-- 御龙枪
ControlDragonSpear = MyWeapon:new(MyWeaponAttr.controlDragonSpear)

-- 攻击命中
function ControlDragonSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

-- 火尖枪
FireTipSpear = MyWeapon:new(MyWeaponAttr.fireTipSpear)

-- 攻击命中着火
function FireTipSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
  local bufflv = self.level + 1
  local customticks = 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(toobjid, 33, bufflv, customticks)
end

-- 霸王枪
OverlordSpear = MyWeapon:new(MyWeaponAttr.overlordSpear)

-- 攻击命中
function OverlordSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

function OverlordSpear:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('霸王'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '霸王技能冷却中')
    return
  end
  MyItemHelper:recordUseSkill(objid, self.id, self.cd)
  ActorHelper:clearAllBadBuff(objid) -- 清除全部减益buff
  local curHp = PlayerHelper:getHp(objid)
  local maxHp = PlayerHelper:getMaxHp(objid)
  if (curHp < maxHp) then -- 恢复损失生命的20%
    local coverHp = self.coverHp + self.level * addCoverHpPerLevel
    local hp = curHp + math.floor((maxHp - curHp) * coverHp)
    PlayerHelper:setHp(objid, hp)
  end
  -- 击退周围3格内的敌对生物
  local playerPos = player:getMyPosition()
  local skillRange = self.skillRange + self.level * self.addSkillRangePerLevel
  local areaid = AreaHelper:createAreaRect(playerPos, { x = skillRange, y = skillRange, z = skillRange })
  local objids = MyActorHelper:getAllOtherTeamActorsInAreaId(objid, areaid)
  AreaHelper:destroyArea(areaid)
  for i, v in ipairs(objids) do
    MyActorHelper:appendSpeed(v, 4, playerPos)
  end
  MyActorHelper:playAndStopBodyEffectById(objid, MyConstant.BODY_EFFECT.BOOM1)
end

-- 慑魂枪
ShockSoulSpear = MyWeapon:new(MyWeaponAttr.shockSoulSpear)

-- 攻击命中
function ShockSoulSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

function ShockSoulSpear:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('慑魂'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '慑魂技能冷却中')
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
      MyActorHelper:imprisonActor(v)
    end
    MyTimeHelper:callFnFastRuns (function ()
      for i, v in ipairs(objids) do
        MyActorHelper:cancelImprisonActor(v)
      end
    end, self.skillTime + self.level * self.addSkillTimePerLevel)
  else
    ChatHelper:sendSystemMsg('慑魂技能有效范围内未发现目标', objid)
  end
end
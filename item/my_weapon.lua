-- 武器

-- 剑

-- 木剑
WoodSword = MyWeapon:new(MyWeaponAttr.woodSword)

-- 青铜剑
BronzeSword = MyWeapon:new(MyWeaponAttr.bronzeSword)

-- 刺虎剑
StabTigerSword = MyWeapon:new(MyWeaponAttr.stabTigerSword)

-- 饮血剑
DrinkBloodSword = MyWeapon:new(MyWeaponAttr.drinkBloodSword)

-- 攻击命中恢复血量
function DrinkBloodSword:attackHit (objid, toobjid)
  local hp = self.hp + math.floor(self.addHpPerLevel * self.level)
  local toHp
  if (ActorHelper:isPlayer(toobjid)) then -- 命中玩家
    toHp = PlayerHelper:getHp(toobjid)
  else -- 命中生物
    toHp = CreatureHelper:getHp(toobjid)
  end
  if (toHp < hp) then
    hp = toHp
  end
  local player = MyPlayerHelper:getPlayer(objid)
  player:recoverHp(hp)
  ActorHelper:playBodyEffectById(objid, ActorHelper.BODY_EFFECT.LITTLE_TREAT, 1)
end

-- 闪袭剑
StrongAttackSword = MyWeapon:new(MyWeaponAttr.strongAttackSword)

function StrongAttackSword:useItem (objid)
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '闪袭技能冷却中')
    return
  end
  local player = MyPlayerHelper:getPlayer(objid)
  local playerPos = player:getMyPosition()
  -- 循环以距离玩家正面1米递增的间隔点开始，作为中心点，扩大1格，查找生物
  for i = 1, self.level + 1 do
    local pos = MathHelper:getDistancePosition(player:getMyPosition(), player:getFaceYaw(), i)
    local areaid = AreaHelper:createNineCubicArea(pos)
    local objids = MyActorHelper:getAllOtherTeamActorsInAreaId(objid, areaid)
    AreaHelper:destroyArea(areaid)
    if (#objids > 0) then
      MyItemHelper:recordUseSkill(objid, self.id, self.cd)
      local tempDistance, targetObjid
      for ii, vv in ipairs(objids) do
        local distance = WorldHelper:calcDistance(playerPos, MyActorHelper:getMyPosition(vv))
        if (not(tempDistance) or distance < tempDistance) then
          tempDistance = distance
          targetObjid = vv
        end
      end
      if (targetObjid) then -- 发现目标
        player:setDistancePosition(targetObjid, -1)
        player:lookAt(targetObjid)
        player:damageActor(targetObjid, self.attack * 2)
        break
      end
    else
      ChatHelper:sendSystemMsg('闪袭技能有效范围内未发现目标', objid)
    end
  end
end

-- 追风剑
ChaseWindSword = MyWeapon:new(MyWeaponAttr.chaseWindSword)

function ChaseWindSword:useItem (objid)
  -- body
end

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
  local bufflv = math.floor(self.level / 3 + 1)
  local customticks = math.floor(self.level / 3 + 1) * 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(toobjid, 45, bufflv, customticks)
end

-- 回春刀
RejuvenationKnife = MyWeapon:new(MyWeaponAttr.rejuvenationKnife)

function RejuvenationKnife:useItem (objid)
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '回春技能冷却中')
    return
  end
  MyItemHelper:recordUseSkill(objid, self.id, self.cd)
  local bufflv = math.floor(self.level / 3 + 1)
  local customticks = math.floor(self.level / 3 + 2) * 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(objid, 50, bufflv, customticks) -- 快速生命恢复
end

-- 封魔刀
SealDemonKnife = MyWeapon:new(MyWeaponAttr.sealDemonKnife)

function SealDemonKnife:useItem (objid)
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '封魔技能冷却中')
    return
  end
end

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
  local bufflv = math.floor(self.level / 3 + 1)
  local customticks = math.floor(self.level / 3 + 1) * 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(toobjid, 33, bufflv, customticks)
end

-- 霸王枪
OverlordSpear = MyWeapon:new(MyWeaponAttr.overlordSpear)

-- 攻击命中
function OverlordSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

function OverlordSpear:useItem (objid)
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
    local hp = curHp + math.floor((maxHp - curHp) * 0.2)
    PlayerHelper:setHp(objid, hp)
  end
  -- 击退周围3格内的敌对生物
  local player = MyPlayerHelper:getPlayer(objid)
  local playerPos = player:getMyPosition()
  local areaid = AreaHelper:createAreaRect(playerPos, { x = 3, y = 2, z = 3 })
  local objids = MyActorHelper:getAllOtherTeamActorsInAreaId(objid, areaid)
  AreaHelper:destroyArea(areaid)
  for i, v in ipairs(objids) do
    local dstPos = MyActorHelper:getMyPosition(v)
    local speed = MathHelper:getSpeedVector3(playerPos, dstPos, 2)
    ActorHelper:appendSpeed(v, speed.x, speed.y, speed.z)
  end
  WorldHelper:playAttackEffect(playerPos)
end

-- 慑魂枪
ShockSoulSpear = MyWeapon:new(MyWeaponAttr.shockSoulSpear)

-- 攻击命中
function ShockSoulSpear:attackHit (objid, toobjid)
  self:reduceStrength(objid)
end

function ShockSoulSpear:useItem (objid)
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '慑魂技能冷却中')
    return
  end
end

-- 弓

-- 木弓
WoodBow = MyWeapon:new(MyWeaponAttr.woodBow)

-- 青铜弓
BronzeBow = MyWeapon:new(MyWeaponAttr.bronzeBow)

-- 射雕弓
ShootEagleBow = MyWeapon:new(MyWeaponAttr.shootEagleBow)

-- 噬魂弓
SwallowSoulBow = MyWeapon:new(MyWeaponAttr.swallowSoulBow)

-- 攻击命中中毒
function SwallowSoulBow:attackHit (objid, toobjid)
  local bufflv = math.floor(self.level / 3 + 1)
  local customticks = math.floor(self.level / 3 + 1) * 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(toobjid, 34, bufflv, customticks)
end

-- 坠星弓
FallStarBow = MyWeapon:new(MyWeaponAttr.fallStarBow)

function FallStarBow:useItem2 (objid)
  local ableUseSkill, remainingTime = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '坠星技能冷却中')
    ChatHelper:sendSystemMsg('坠星技能冷却时间剩余' .. remainingTime .. '秒', objid)
    return
  end
  if (self:getObjids(objid, 1)) then
    MyItemHelper:cancelDelaySkill(objid) -- 取消之前的技能
    MyItemHelper:recordUseSkill(objid, self.id, self.cd, true) -- 记录新的技能
    self:useSkill(objid, 1)
  end
end

function FallStarBow:getObjids (objid, index)
  -- 8格内的敌对生物
  local player = MyPlayerHelper:getPlayer(objid)
  local playerPos = player:getMyPosition()
  local areaid = AreaHelper:createAreaRect(playerPos, { x = 8, y = 4, z = 8 })
  local objids = MyActorHelper:getAllOtherTeamActorsInAreaId(objid, areaid)
  AreaHelper:destroyArea(areaid)
  local msg
  if (#objids == 0) then
    if (index == 1) then
      msg = '坠星技能有效范围内未发现目标'
    else
      msg = '坠星技能有效范围内已无目标'
    end
    ChatHelper:sendSystemMsg(msg, objid)
    return false
  end
  -- 查询背包内箭矢数量
  local num = BackpackHelper:getItemNumAndGrid(objid, MyConstant.WEAPON.ARROW_ID)
  if (num < #objids) then -- 箭矢数量不足
    if (index == 1) then
      msg = '箭矢数量不足'
    else
      msg = '箭矢数量不足，技能终止'
    end
    ChatHelper:sendSystemMsg(msg, objid)
    return false
  end
  return objids
end

function FallStarBow:useSkill (objid, index)
  -- 蓄力3秒
  ChatHelper:sendSystemMsg('蓄力3秒', objid)
  local time, idx = MyTimeHelper:callFnAfterSecond (function ()
    local objids = self:getObjids(objid, index + 1)
    if (not(objids)) then -- 没有目标
      MyItemHelper:cancelDelaySkill(objid)
      return
    end
    local itemid = MyConstant.WEAPON.COMMON_PROJECTILE_ID -- 通用投掷物id
    BackpackHelper:removeGridItemByItemID(objid, MyConstant.WEAPON.ARROW_ID, #objids) -- 扣除箭矢
    for i, v in ipairs(objids) do
      local targetPos = MyActorHelper:getMyPosition(v)
      local initPos = MyPosition:new(targetPos.x, targetPos.y + 0.2, targetPos.z)
      local dirVector3 = MyVector3:new(0, -1, 0)
      local projectileid = WorldHelper:spawnProjectileByDirPos(objid, itemid, initPos, dirVector3) -- 创建投掷物
      MyItemHelper:recordProjectile(projectileid, objid, self, self.attack) -- 记录伤害
    end
    self:useSkill(objid, index + 1)
  end, 3)
  MyItemHelper:recordDelaySkill(objid, time, idx, '坠星')
end

-- 投掷物命中
function FallStarBow:projectileHit (projectileInfo, toobjid, blockid, x, y, z)
  if (toobjid > 0) then
    local objid = projectileInfo.objid
    local player = MyPlayerHelper:getPlayer(objid)
    player:damageActor(toobjid, projectileInfo.hurt)
  end
end

-- 连珠弓
OneByOneBow = MyWeapon:new(MyWeaponAttr.oneByOneBow)

function OneByOneBow:useItem2 (objid)
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '连珠技能冷却中')
    return
  end
end
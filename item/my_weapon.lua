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
  local hp = self.hp + self.addHpPerLevel * self.level
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
  MyActorHelper:playAndStopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT3)
end

-- 闪袭剑
StrongAttackSword = MyWeapon:new(MyWeaponAttr.strongAttackSword)

function StrongAttackSword:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('闪袭'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '闪袭技能冷却中')
    return
  end
  local playerPos = player:getMyPosition()
  -- 循环以距离玩家正面1米递增的间隔点开始，作为中心点，扩大1格，查找生物
  local distanceTimes = self.distance + self.level * self.addDistancePerLevel
  for i = 1, distanceTimes do
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
        WorldHelper:playAndStopBodyEffectById(playerPos, MyConstant.BODY_EFFECT.SMOG1)
        player:setDistancePosition(targetObjid, -1)
        player:lookAt(targetObjid)
        -- 击退效果
        MyActorHelper:appendSpeed(targetObjid, 2, player:getMyPosition())
        -- 伤害
        player:damageActor(targetObjid, self.attack * (self.multiple + self.level * self.addMultiplePerLevel))
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
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('追风'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '追风技能冷却中')
    return
  end
  MyItemHelper:recordUseSkill(objid, self.id, self.cd)
  local gridid = BackpackHelper:getCurShotcutGrid(objid)
  local curDur = BackpackHelper:getGridDurability(objid, gridid) -- 耐久度
  local playerPos = player:getMyPosition()
  -- local srcPos = MyPosition:new(playerPos.x, playerPos.y + 1, playerPos.z)
  local srcPos = MyPosition:new(ActorHelper:getEyePosition(objid))
  local aimPos = player:getAimPos() -- 准星位置
  -- 移除手持的追风剑
  BackpackHelper:removeGridItem(objid, gridid)
  -- 生成飞行的追风剑（投掷物）
  local projectileid = WorldHelper:spawnProjectileByPos(objid, self.projectileid, srcPos, aimPos)
  local weaponType = objid .. '-' .. self.id
  MyTimeHelper:callFnFastRuns (function ()
    local pos = MyActorHelper:getMyPosition(projectileid)
    if (pos.x) then
      WorldHelper:despawnActor(projectileid) -- 移除投掷物
      self:moveAndRecoverWeapon(player, objid, playerPos, pos, self, curDur)
    else
      self:recoverWeapon(objid, self, curDur)
    end
  end, self.flyTime + self.level * self.addFlyTimePerLevel, weaponType)
  MyItemHelper:recordProjectile(projectileid, objid, self, { pos = playerPos, curDur = curDur, weaponType = weaponType })
end

-- 投掷物命中
function ChaseWindSword:projectileHit (projectileInfo, toobjid, blockid, pos)
  MyTimeHelper:delFnFastRuns(projectileInfo.weaponType)
  local objid = projectileInfo.objid
  local item = projectileInfo.item
  local player = MyPlayerHelper:getPlayer(objid)
  local playerPos = projectileInfo.pos
  local curDur = projectileInfo.curDur -- 耐久度
  if (toobjid > 0) then -- 命中生物（似乎命中同队生物不会进入这里）
    self:moveAndRecoverWeapon(player, objid, playerPos, pos, item, curDur)
    MyActorHelper:appendSpeed(toobjid, 2, player:getMyPosition()) -- 冲击
    -- 判断是否是敌对生物
    if (not(MyActorHelper:isTheSameTeamActor(objid, toobjid))) then -- 敌对生物，则造成伤害
      local toPos = MyActorHelper:getMyPosition(toobjid)
      local distance = WorldHelper:calcDistance(playerPos, toPos)
      local dam = item.damage + item.level * item.addDamagePerLevel
      player:damageActor(toobjid, math.floor(item.attack + distance * dam))
    end
  elseif (blockid > 0) then -- 命中方块
    self:moveAndRecoverWeapon(player, objid, playerPos, pos, item, curDur)
  end
end

-- 移动并收回武器
function ChaseWindSword:moveAndRecoverWeapon (player, playerid, playerPos, pos, item, curDur)
  WorldHelper:playAndStopBodyEffectById(playerPos, MyConstant.BODY_EFFECT.SMOG1)
  local dstPos = MathHelper:getPos2PosInLineDistancePosition(playerPos, pos, 1)
  player:setMyPosition(dstPos)
  self:recoverWeapon(playerid, item, curDur)
end

-- 收回追风剑
function ChaseWindSword:recoverWeapon (playerid, item, curDur)
  local itemid = PlayerHelper:getCurToolID(playerid)
  if (itemid) then -- 手上拿了别的东西
    item:newItem(playerid, 1)
    local num, backpacks = BackpackHelper:getItemNum(playerid, item.id)
    BackpackHelper:setGridItem(playerid, backpacks[1], item.id, 1, curDur)
  else -- 空手
    local gridid = BackpackHelper:getCurShotcutGrid(objid)
    BackpackHelper:setGridItem(playerid, gridid, item.id, 1, curDur)
  end
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
  local bufflv = self.level + 1
  local customticks = 5 * 20 -- 每秒20帧
  ActorHelper:addBuff(toobjid, 34, bufflv, customticks)
end

-- 坠星弓
FallStarBow = MyWeapon:new(MyWeaponAttr.fallStarBow)

function FallStarBow:useItem2 (objid)
  -- 检测技能是否正在释放
  if (MyItemHelper:isDelaySkillUsing(objid, '坠星')) then -- 技能释放中
    self:cancelSkill(objid)
    return
  end
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('坠星'))) then
    return false
  end
  -- 检测技能cd是否完成
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '坠星技能冷却中')
    return
  end
  -- 检测技能释放条件
  if (self:getObjids(objid, 1)) then
    MyItemHelper:recordUseSkill(objid, self.id, self.cd) -- 记录新的技能
    player:enableMove(false)
    ChatHelper:sendSystemMsg('释放技能中无法移动', objid)
    ActorHelper:playBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT10, 1)
    self:useSkill(objid, 1)
  end
end

function FallStarBow:getObjids (objid, index)
  -- 8格内的敌对生物
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('坠星'))) then
    return false
  end
  local playerPos = player:getMyPosition()
  local skillRange = self.skillRange + self.level * self.addSkillRangePerLevel
  local areaid = AreaHelper:createAreaRect(playerPos, { x = skillRange, y = 4, z = skillRange })
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
  -- 蓄力2秒
  -- ChatHelper:sendSystemMsg('蓄力2秒', objid)
  MyActorHelper:playSoundEffectById(objid, MyConstant.SOUND_EFFECT.SKILL9)
  local player = MyPlayerHelper:getPlayer(objid)
  player.action:playAttack()
  local time, idx = MyTimeHelper:callFnAfterSecond (function ()
    local objids = self:getObjids(objid, index + 1)
    if (not(objids)) then -- 没有目标
      self:cancelSkill(objid)
      return
    end
    local itemid = MyConstant.WEAPON.COMMON_PROJECTILE_ID -- 通用投掷物id
    BackpackHelper:removeGridItemByItemID(objid, MyConstant.WEAPON.ARROW_ID, #objids) -- 扣除箭矢
    for i, v in ipairs(objids) do
      local targetPos = MyActorHelper:getMyPosition(v)
      local initPos = MyPosition:new(targetPos.x, targetPos.y + 0.2, targetPos.z)
      local dirVector3 = MyVector3:new(0, -1, 0)
      local projectileid = WorldHelper:spawnProjectileByDirPos(objid, itemid, initPos, dirVector3) -- 创建投掷物
      MyItemHelper:recordProjectile(projectileid, objid, self, { hurt = self.attack }) -- 记录伤害
    end
    self:useSkill(objid, index + 1)
  end, 2)
  MyItemHelper:recordDelaySkill(objid, time, idx, '坠星')
end

-- 取消技能
function FallStarBow:cancelSkill (objid)
  MyItemHelper:cancelDelaySkill(objid)
  ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT10)
  local player = MyPlayerHelper:getPlayer(objid)
  player:enableMove(true)
end

-- 投掷物命中
function FallStarBow:projectileHit (projectileInfo, toobjid, blockid, pos)
  if (toobjid > 0) then
    local objid = projectileInfo.objid
    local player = MyPlayerHelper:getPlayer(objid)
    MyActorHelper:appendSpeed(toobjid, 2, player:getMyPosition()) -- 箭矢冲击
    player:damageActor(toobjid, projectileInfo.hurt)
  end
end

-- 连珠弓
OneByOneBow = MyWeapon:new(MyWeaponAttr.oneByOneBow)

function OneByOneBow:useItem2 (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('连珠'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '连珠技能冷却中')
    return
  end
  -- 查询背包内箭矢数量
  local num = BackpackHelper:getItemNumAndGrid(objid, MyConstant.WEAPON.ARROW_ID)
  local times = self.arrowNum + self.level * self.addArrowNumPerLevel
  if (num < times) then
    ChatHelper:sendSystemMsg('箭矢数量不足', objid)
    return false
  end
  MyItemHelper:recordUseSkill(objid, self.id, self.cd) -- 记录新的技能
  ActorHelper:playBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT4, 1)
  self:resetHitTimes(objid)
  player.action:playAttack()
  -- 半秒后发射
  MyTimeHelper:callFnFastRuns(function ()
    local weaponType = objid .. '-' .. self.id
    for i = 1, times do
      MyTimeHelper:callFnFastRuns(function ()
        local num = BackpackHelper:getItemNumAndGrid(objid, MyConstant.WEAPON.ARROW_ID)
        if (num > 0 and player:ableUseSkill('连珠')) then -- 有箭矢并且能释放技能
          BackpackHelper:removeGridItemByItemID(objid, MyConstant.WEAPON.ARROW_ID, 1) -- 扣除箭矢
          local playerPos = player:getMyPosition()
          -- local srcPos = MyPosition:new(playerPos.x, playerPos.y + 1, playerPos.z)
          local srcPos = MyPosition:new(ActorHelper:getEyePosition(objid))
          local aimPos = player:getAimPos() -- 准星位置
          local projectileid = WorldHelper:spawnProjectileByPos(objid, MyConstant.WEAPON.ARROW_ID, srcPos, aimPos)
          MyItemHelper:recordProjectile(projectileid, objid, self)
          if (i == times) then -- 最后一箭关闭特效
            ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT4)
          end
        else -- 无法释放技能则终止其他箭的发射并关闭特效
          MyTimeHelper:delFnFastRuns(weaponType)
          ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT4)
        end
      end, 0.2 * i, weaponType)
    end
  end, 0.5)
end

-- 投掷物命中
function OneByOneBow:projectileHit (projectileInfo, toobjid, blockid, pos)
  local objid = projectileInfo.objid
  local item = projectileInfo.item
  local player = MyPlayerHelper:getPlayer(objid)
  if (toobjid > 0) then -- 命中生物（似乎命中同队生物不会进入这里）
    MyActorHelper:appendSpeed(toobjid, 1, player:getMyPosition()) -- 冲击
    -- 判断是否是敌对生物
    if (not(MyActorHelper:isTheSameTeamActor(objid, toobjid))) then -- 敌对生物，则造成伤害
      local hurt = item.attack - self:addHitTimes(objid) * 10 -- 命中伤害10点递减
      if (hurt < 10) then -- 最低伤害10点
        hurt = 10
      end
      player:damageActor(toobjid, hurt)
    end
  end
end

-- 重置命中次数
function OneByOneBow:resetHitTimes (objid)
  if (not(self.hitTimes)) then
    self.hitTimes = {}
  end
  self.hitTimes[objid] = 0
end

-- 获得命中次数
function OneByOneBow:getHitTimes (objid)
  return self.hitTimes[objid]
end

-- 增加命中次数
function OneByOneBow:addHitTimes (objid)
  local times = self:getHitTimes(objid)
  self.hitTimes[objid] = self.hitTimes[objid] + 1
  return times
end
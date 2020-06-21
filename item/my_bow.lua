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
      MyItemHelper:recordProjectile(projectileid, objid, self, { hurt = self.attack - MyConstant.PROJECTILE_HURT }) -- 记录伤害
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
      local key = MyPlayerHelper:generateDamageKey(objid, toobjid)
      local isHurt = MyTimeHelper:getFrameInfo(key)
      local superfluousHurt = 0 -- 多余的伤害
      if (isHurt) then -- 造成伤害事件发生了
        superfluousHurt = MyConstant.PROJECTILE_HURT
      end
      local hurt = item.attack - superfluousHurt - self:addHitTimes(objid) * 10 -- 命中伤害10点递减
      local minHurt = 10 - superfluousHurt
      if (hurt < minHurt) then -- 最低伤害10点
        hurt = minHurt
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
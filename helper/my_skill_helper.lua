-- 我的技能工具类
MySkillHelper = {
  huitianData = {}, -- { objid -> {} }
  airArmourData = {
    bodyEffect = BaseConstant.BODY_EFFECT.LIGHT64
  },
  shunData = {}, -- { objid -> {} }
  qiuData = {}, -- { objid -> pos }
}

-- 囚禁actor，用于慑魂枪效果
function MySkillHelper.imprisonActor (objid)
  ActorHelper.playBodyEffect(objid, BaseConstant.BODY_EFFECT.LIGHT22)
  if (ActorHelper.isPlayer(objid)) then -- 玩家
    local player = PlayerHelper.getPlayer(objid)
    player:setImprisoned(true)
  else
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      actor:setImprisoned(true)
    else
      MonsterHelper.imprisonMonster(objid)
    end
  end
end

-- 取消囚禁actor
function MySkillHelper.cancelImprisonActor (objid)
  local canCancel
  if (ActorHelper.isPlayer(objid)) then -- 玩家
    local player = PlayerHelper.getPlayer(objid)
    canCancel = player:setImprisoned(false)
  else
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      canCancel = actor:setImprisoned(false)
    else
      canCancel = MonsterHelper.cancelImprisonMonster(objid)
    end
  end
  if (canCancel) then
    ActorHelper.stopBodyEffectById(objid, BaseConstant.BODY_EFFECT.LIGHT22)
  end
end

-- 封魔actor
function MySkillHelper.sealActor (objid)
  ActorHelper.playBodyEffect(objid, BaseConstant.BODY_EFFECT.LIGHT47)
  if (ActorHelper.isPlayer(objid)) then -- 玩家
    local player = PlayerHelper.getPlayer(objid)
    player:setSeal(true)
  else
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      actor:setSealed(true)
    else
      MonsterHelper.sealMonster(objid)
    end
  end
end

-- 取消封魔actor
function MySkillHelper.cancelSealActor (objid)
  local canCancel
  if (ActorHelper.isPlayer(objid)) then -- 玩家
    local player = PlayerHelper.getPlayer(objid)
    canCancel = player:setSeal(false)
  else
    local actor = ActorHelper.getActor(objid)
    if (actor) then
      canCancel = actor:setSealed(false)
    else
      canCancel = MonsterHelper.cancelSealMonster(objid)
    end
  end
  if (canCancel) then
    ActorHelper.stopBodyEffectById(objid, BaseConstant.BODY_EFFECT.LIGHT47)
  end
end

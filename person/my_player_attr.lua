-- 我的玩家属性类
MyPlayerAttr = {
  level = 1, -- 当前等级，已废弃
  totalLevel = 1, -- 总等级
  exp = 0,  -- 当前经验
  levelExp = 100, -- 每升一级需要的经验
  positions = nil, -- 最近几秒的位置
  hurtReason = nil, -- 受伤原因，目前没用
  attack = 0, -- 手持武器攻击
  defense = 0, -- 手持武器防御
  strength = 100 -- 体力，用于使枪消耗
}

function MyPlayerAttr:new (player)
  local o = {
    myActor = player,
    cantUseSkillReasons = {
      seal = 0, -- 封魔叠加数
      imprisoned = 0 -- 慑魂叠加数
    } -- 无法使用技能原因, { string -> times }
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyPlayerAttr:enableMove (enable, showMsg)
  local objid = self.myActor.objid
  if (enable) then
    if (showMsg) then
      PlayerHelper:notifyGameInfo2Self(objid, '恢复移动')
    end
    PlayerHelper:setAttr(objid, PLAYERATTR.WALK_SPEED, -1)
    PlayerHelper:setAttr(objid, PLAYERATTR.RUN_SPEED, -1)
    PlayerHelper:setAttr(objid, PLAYERATTR.SNEAK_SPEED, -1)
    PlayerHelper:setAttr(objid, PLAYERATTR.SWIN_SPEED, -1)
    PlayerHelper:setAttr(objid, PLAYERATTR.JUMP_POWER, -1)
  else
    if (showMsg) then
      PlayerHelper:notifyGameInfo2Self(objid, '当前不可移动')
    end
    PlayerHelper:setAttr(objid, PLAYERATTR.WALK_SPEED, 0)
    PlayerHelper:setAttr(objid, PLAYERATTR.RUN_SPEED, 0)
    PlayerHelper:setAttr(objid, PLAYERATTR.SNEAK_SPEED, 0)
    PlayerHelper:setAttr(objid, PLAYERATTR.SWIN_SPEED, 0)
    PlayerHelper:setAttr(objid, PLAYERATTR.JUMP_POWER, 0)
  end
end

function MyPlayerAttr:updatePositions ()
  if (not(self.positions)) then
    self.positions = {}
  end
  local myPosition = self.myActor:getMyPosition()
  if (myPosition) then
    table.insert(self.positions, 1, myPosition)
    if (#self.positions > 3) then
      table.remove(self.positions)
    end
  end
end

function MyPlayerAttr:gainExp (exp)
  self.exp = self.exp + exp
  local msg = '获得'.. exp .. '点经验。'
  ChatHelper:sendSystemMsg(msg, self.myActor.objid)
  local needExp = self.totalLevel * self.levelExp - self.exp
  if (needExp <= 0) then
    repeat
      msg = self:upgrade(1)
      ChatHelper:sendSystemMsg(msg, self.myActor.objid)
      needExp = needExp + self.levelExp
    until (needExp > 0)
  else
    msg = '当前等级为：' .. self.totalLevel .. '。还差' .. needExp .. '点经验升级。'
    ChatHelper:sendSystemMsg(msg, self.myActor.objid)
  end
  GameDataHelper:updateGameData(self.myActor)
end

function MyPlayerAttr:upgrade (addLevel)
  if (addLevel > 0) then
    self.totalLevel = self.totalLevel + addLevel
    self:changeAttr(2 * addLevel, 2 * addLevel)
    -- local attrtype1 = { PLAYERATTR.ATK_MELEE, PLAYERATTR.ATK_REMOTE, PLAYERATTR.DEF_MELEE, PLAYERATTR.DEF_REMOTE }
    -- for i, v in ipairs(attrtype1) do
    --   PlayerHelper:addAttr(self.objid, v, 2 * addLevel)
    -- end
    local objid = self.myActor.objid
    local maxHp = PlayerHelper:getMaxHp(objid) + 10 * addLevel
    PlayerHelper:setMaxHp(objid, maxHp)
    PlayerHelper:setHp(objid, maxHp)
    PlayerHelper:setFoodLevel(objid, 100)
    return StringHelper:concat('你升级了。当前等级为：', self.totalLevel)
  end
  return ''
end

function MyPlayerAttr:changeAttr (attack, defense, dodge)
  local attrMap = {}
  if (attack and attack ~= 0) then
    attrMap[PLAYERATTR.ATK_MELEE] = attack
    attrMap[PLAYERATTR.ATK_REMOTE] = attack
  end
  if (defense and defense ~= 0) then
    attrMap[PLAYERATTR.DEF_MELEE] = defense
    attrMap[PLAYERATTR.DEF_REMOTE] = defense
  end
  if (dodge and dodge ~= 0) then
    attrMap[PLAYERATTR.DODGE] = dodge
  end
  for k, v in pairs(attrMap) do
    PlayerHelper:addAttr(self.myActor.objid, k, v)
  end
end

function MyPlayerAttr:showAttr (isMelee)
  local objid, attack = self.myActor.objid
  if (isMelee) then
    attack = PlayerHelper:getAttr(objid, PLAYERATTR.ATK_MELEE)
  else
    attack = PlayerHelper:getAttr(objid, PLAYERATTR.ATK_REMOTE)
  end
  local defense = PlayerHelper:getAttr(objid, PLAYERATTR.DEF_MELEE)
  local att, def = attack - self.attack, defense - self.defense
  if (att >= 0) then
    att = '+' .. att
  end
  if (def >= 0) then
    def = '+' .. def
  end
  local content = StringHelper:concat('攻击', att, '，防御', def)
  ChatHelper:sendSystemMsg(content, objid)
  self.attack = attack
  self.defense = defense
end

function MyPlayerAttr:recoverHp (hp)
  if (hp == 0) then
    return
  end
  local objid = self.myActor.objid
  local curHp = PlayerHelper:getHp(objid)
  if (hp > 0) then -- 加血
    local maxHp = PlayerHelper:getMaxHp(objid)
    if (curHp == maxHp) then -- 满血量不处理
      return
    end
    curHp = curHp + hp
    if (curHp > maxHp) then
      curHp = maxHp
    end
  else -- 减血
    local minHp = 1
    if (curHp == minHp) then -- 重伤不处理
      return
    end
    curHp = curHp + hp
    if (curHp < minHp) then
      curHp = minHp
    end
  end
  PlayerHelper:setHp(objid, curHp)
end

function MyPlayerAttr:recoverFoodLevel(foodLevel)
  if (foodLevel == 0) then
    return
  end
  local curFoodLevel = PlayerHelper:getFoodLevel(self.myActor.objid)
  if (foodLevel > 0) then -- 增加饱食度
    local maxFoodLevel = 100
    if (curFoodLevel == maxFoodLevel) then -- 满饱食度不处理
      return
    end
    curFoodLevel = curFoodLevel + foodLevel
    if (curFoodLevel > maxFoodLevel) then
      curFoodLevel = maxFoodLevel
    end
  else -- 减血
    local minFoodLevel = 0
    if (curFoodLevel == minFoodLevel) then -- 饥饿不处理
      return
    end
    curFoodLevel = curFoodLevel + foodLevel
    if (curFoodLevel < minFoodLevel) then
      curFoodLevel = minFoodLevel
    end
  end
  PlayerHelper:setFoodLevel(self.myActor.objid, curFoodLevel)
end

function MyPlayerAttr:reduceStrength (strength)
  self.strength = self.strength - strength
  if (self.strength <= 0) then
    self.strength = 100
    self:recoverFoodLevel(-1)
  end
end

function MyPlayerAttr:damageActor (toobjid, val)
  if (val <= 0) then -- 伤害值无效
    return
  end
  if (ActorHelper:isPlayer(toobjid)) then -- 伤害玩家
    local hp = PlayerHelper:getHp(toobjid)
    if (hp <= 0) then -- 生物已经死亡
      return
    end
    if (hp > val) then -- 玩家不会死亡
      hp = hp - val
      PlayerHelper:setHp(toobjid, hp)
    else -- 玩家可能会死亡，则检测玩家是否可被杀死
      local ableBeKilled = PlayerHelper:getPlayerEnableBeKilled(toobjid)
      if (ableBeKilled) then -- 能被杀死
        ActorHelper:killSelf(toobjid)
        MyPlayerHelper:playerDefeatActor(self.myActor.objid, toobjid)
      else -- 不能被杀死
        hp = 1
        PlayerHelper:setHp(toobjid, hp)
      end
    end
  else -- 伤害了生物
    local hp = CreatureHelper:getHp(toobjid)
    if (not(hp) or hp <= 0) then -- 未找到生物或生物已经死亡
      return
    end
    if (hp > val) then -- 生物不会死亡
      hp = hp - val
      CreatureHelper:setHp(toobjid, hp)
    else -- 生物可能会死亡，则检测生物是否可被杀死
      local ableBeKilled = ActorHelper:getEnableBeKilledState(toobjid)
      if (ableBeKilled) then -- 能被杀死
        ActorHelper:killSelf(toobjid)
        MyPlayerHelper:playerDefeatActor(self.myActor.objid, toobjid)
      else -- 不能被杀死
        hp = 1
        CreatureHelper:setHp(toobjid, hp)
      end
    end
  end
  MyPlayerHelper:playerDamageActor(self.myActor.objid, toobjid)
end

function MyPlayerAttr:setImprisoned (active)
  self:enableMove(not(active)) -- 可移动设置
  PlayerHelper:setActionAttrState(self.myActor.objid, PLAYERATTR.ENABLE_ATTACK, not(active)) -- 可攻击设置
  if (active) then
    -- 设置囚禁标志用于不能使用主动技能
    self.cantUseSkillReasons.imprisoned = self.cantUseSkillReasons.imprisoned + 1
    ChatHelper:sendSystemMsg('你被慑魂枪震慑了灵魂，无法做出有效行为', self.myActor.objid)
  else 
    -- 返回true表示已不是囚禁状态
    self.cantUseSkillReasons.imprisoned = self.cantUseSkillReasons.imprisoned - 1
    return self.cantUseSkillReasons.imprisoned <= 0
  end
end

function MyPlayerAttr:setSeal (active)
  if (active) then
    self.cantUseSkillReasons.seal = self.cantUseSkillReasons.seal + 1
    ChatHelper:sendSystemMsg('你被封魔了，当前无法使用技能', self.myActor.objid)
  else
    -- 返回true表示已不是封魔状态
    self.cantUseSkillReasons.seal = self.cantUseSkillReasons.seal - 1
    return self.cantUseSkillReasons.seal <= 0
  end
end

function MyPlayerAttr:ableUseSkill (skillname)
  skillname = skillname or ''
  if (self.cantUseSkillReasons.seal > 0) then
    ChatHelper:sendSystemMsg('你处于封魔状态，当前无法使用' .. skillname .. '技能', self.myActor.objid)
    return false
  end
  if (self.cantUseSkillReasons.imprisoned > 0) then
    ChatHelper:sendSystemMsg('你处于慑魂状态，当前无法使用' .. skillname .. '技能', self.myActor.objid)
    return false
  end
  return true
end
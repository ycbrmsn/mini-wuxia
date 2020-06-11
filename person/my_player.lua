-- 我的玩家类
MyPlayer = {
  objid = nil,
  nickname = nil,
  action = nil,
  wants = nil,  -- 想做什么
  moveMotion = nil,
  level = 1, -- 当前等级，已废弃
  totalLevel = 1, -- 总等级
  exp = 0,  -- 当前经验
  levelExp = 100, -- 每升一级需要的经验
  positions = nil, -- 最近几秒的位置
  prevAreaId = nil, -- 上一进入区域id
  hurtReason = nil, -- 受伤原因，目前没用
  hold = nil, -- 手持物品
  attack = 0, -- 手持武器攻击
  defense = 0, -- 手持武器防御
  strength = 100, -- 体力，用于使枪消耗
  cantUseSkillReasons = {
    seal = 0, -- 封魔叠加数
    imprisoned = 0 -- 慑魂叠加数
  } -- 无法使用技能原因, { string -> times }
}

function MyPlayer:new (objid)
  local o = { 
    objid = objid,
  }
  o.action = MyPlayerAction:new(o)
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyPlayer:speak (afterSeconds, ...)
  if (afterSeconds > 0) then
    self.action:speakToAllAfterSecond(afterSeconds, ...)
  else
    self.action:speakToAll(...)
  end
end

function MyPlayer:speakTo (playerids, afterSeconds, ...)
  if (type(playerids) == 'number') then
    if (afterSeconds > 0) then
      self.action:speakAfterSecond(playerids, afterSeconds, ...)
    else
      self.action:speak(playerids, ...)
    end
  elseif (type(playerids) == 'table') then
    for i, v in ipairs(playerids) do
      self:speakTo(v)
    end
  end
end

function MyPlayer:thinks (afterSeconds, ...)
  if (afterSeconds > 0) then
    self.action:speakInHeartToAllAfterSecond(afterSeconds, ...)
  else
    self.action:speakInHeartToAll(...)
  end
end

function MyPlayer:thinkTo (playerids, afterSeconds, ...)
  if (type(playerids) == 'number') then
    if (afterSeconds > 0) then
      self.action:speakInHeartAfterSecond(playerids, afterSeconds, ...)
    else
      self.action:speakInHeart(playerids, ...)
    end
  elseif (type(playerids) == 'table') then
    for i, v in ipairs(playerids) do
      self:thinkTo(v)
    end
  end
end

function MyPlayer:updatePositions ()
  if (not(self.positions)) then
    self.positions = {}
  end
  local myPosition = self:getMyPosition()
  table.insert(self.positions, 1, myPosition)
  if (#self.positions > 3) then
    table.remove(self.positions)
  end
end

function MyPlayer:getName ()
  if (not(self.nickname)) then
    self.nickname = PlayerHelper:getNickname(self.objid)
  end
  return self.nickname
end

function MyPlayer:enableMove (enable, showMsg)
  if (enable) then
    if (showMsg) then
      PlayerHelper:notifyGameInfo2Self(self.objid, '恢复移动')
    end
    PlayerHelper:setAttr(self.objid, PLAYERATTR.WALK_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.RUN_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.SNEAK_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.SWIN_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.JUMP_POWER, -1)
  else
    if (showMsg) then
      PlayerHelper:notifyGameInfo2Self(self.objid, '当前不可移动')
    end
    PlayerHelper:setAttr(self.objid, PLAYERATTR.WALK_SPEED, 0)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.RUN_SPEED, 0)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.SNEAK_SPEED, 0)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.SWIN_SPEED, 0)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.JUMP_POWER, 0)
  end
end

function MyPlayer:enableBeAttacked (enable)
  return PlayerHelper:setPlayerEnableBeAttacked(self.objid, enable)
end

function MyPlayer:getPosition ()
  return ActorHelper:getPosition(self.objid)
end

function MyPlayer:getMyPosition ()
  return MyPosition:new(self:getPosition())
end

function MyPlayer:setPosition (x, y, z)
  return MyActorHelper:setPosition(self.objid, x, y, z)
end

function MyPlayer:setMyPosition (pos)
  return MyActorHelper:setPosition(self.objid, pos.x, pos.y, pos.z)
end

function MyPlayer:getDistancePosition (distance)
  return MyActorHelper:getDistancePosition(self.objid, distance)
end

function MyPlayer:setDistancePosition (objid, distance)
  self:setPosition(MyActorHelper:getDistancePosition(objid, distance))
end

function MyPlayer:getFaceYaw ()
  return ActorHelper:getFaceYaw(self.objid)
end

function MyPlayer:getFacePitch ()
  return ActorHelper:getFacePitch(self.objid)
end

-- 获取准星位置
function MyPlayer:getAimPos ()
  return MyPosition:new(PlayerHelper:getAimPos(self.objid))
end

function MyPlayer:gainExp (exp)
  self.exp = self.exp + exp
  local msg = '获得'.. exp .. '点经验。'
  ChatHelper:sendSystemMsg(msg, self.objid)
  local needExp = self.totalLevel * self.levelExp - self.exp
  if (needExp <= 0) then
    repeat
      msg = self:upgrade(1)
      ChatHelper:sendSystemMsg(msg, self.objid)
      needExp = needExp + self.levelExp
    until (needExp > 0)
  else
    msg = '当前等级为：' .. self.totalLevel .. '。还差' .. needExp .. '点经验升级。'
    ChatHelper:sendSystemMsg(msg, self.objid)
  end
end

function MyPlayer:upgrade (addLevel)
  if (addLevel > 0) then
    self.totalLevel = self.totalLevel + addLevel
    self:changeAttr(2 * addLevel, 2 * addLevel)
    -- local attrtype1 = { PLAYERATTR.ATK_MELEE, PLAYERATTR.ATK_REMOTE, PLAYERATTR.DEF_MELEE, PLAYERATTR.DEF_REMOTE }
    -- for i, v in ipairs(attrtype1) do
    --   PlayerHelper:addAttr(self.objid, v, 2 * addLevel)
    -- end
    local maxHp = PlayerHelper:getMaxHp(self.objid) + 10 * addLevel
    PlayerHelper:setMaxHp(self.objid, maxHp)
    PlayerHelper:setHp(self.objid, maxHp)
    PlayerHelper:setFoodLevel(self.objid, 100)
    return StringHelper:concat('你升级了。当前等级为：', self.totalLevel)
  end
  return ''
end

function MyPlayer:lookAt (objid)
  local x, y, z
  if (type(objid) == 'table') then
    x, y, z = objid.x, objid.y, objid.z
  else
    x, y, z = ActorHelper:getPosition(objid)
    y = y + ActorHelper:getEyeHeight(objid) - 1
  end
  local x0, y0, z0 = ActorHelper:getPosition(self.objid)
  y0 = y0 + ActorHelper:getEyeHeight(self.objid) - 1 -- 生物位置y是地面上一格，所以要减1
  local myVector3 = MyVector3:new(x0, y0, z0, x, y, z)
  local faceYaw = MathHelper:getPlayerFaceYaw(myVector3)
  local facePitch = MathHelper:getActorFacePitch(myVector3)
  PlayerHelper:rotateCamera(self.objid, faceYaw, facePitch)
end

function MyPlayer:wantLookAt (objid, seconds)
  MyTimeHelper:callFnContinueRuns(function ()
    self:lookAt(objid)
  end, seconds)
end

-- 背包数量及背包格数组
function MyPlayer:getItemNum (itemid, containEquip)
  return BackpackHelper:getItemNum(self.objid, itemid, containEquip)
end

-- 拿出道具
function MyPlayer:takeOutItem (itemid, containEquip)
  local num, arr = self:getItemNum(itemid, containEquip)
  if (num == 0) then
    return false
  else
    local grid = BackpackHelper:getCurShotcutGrid(self.objid)
    return BackpackHelper:swapGridItem(self.objid, arr[1], grid)
  end
end

function MyPlayer:holdItem ()
  local itemid = PlayerHelper:getCurToolID(self.objid)
  if (not(self.hold) and not(itemid)) then  -- 变化前后都没有拿东西
    -- do nothing
  elseif (not(self.hold)) then -- 之前没有拿东西
    self:changeHold(itemid)
  elseif (not(itemid)) then -- 之后没有拿东西
    self:changeHold(itemid)
  elseif (self.hold ~= itemid) then -- 换了一件东西拿
    self:changeHold(itemid)
  end -- else是没有换东西，略去
end

function MyPlayer:changeHold (itemid)
  local foundItem = MyItemHelper:changeHold(self.objid, self.hold, itemid)
  self.hold = itemid
  if (foundItem) then
    self:showAttr(true) -- 目前默认显示近程攻击
  end
end

function MyPlayer:changeAttr (attack, defense, dodge)
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
    PlayerHelper:addAttr(self.objid, k, v)
  end
end

function MyPlayer:showAttr (isMelee)
  local attack
  if (isMelee) then
    attack = PlayerHelper:getAttr(self.objid, PLAYERATTR.ATK_MELEE)
  else
    attack = PlayerHelper:getAttr(self.objid, PLAYERATTR.ATK_REMOTE)
  end
  local defense = PlayerHelper:getAttr(self.objid, PLAYERATTR.DEF_MELEE)
  local att, def = attack - self.attack, defense - self.defense
  if (att >= 0) then
    att = '+' .. att
  end
  if (def >= 0) then
    def = '+' .. def
  end
  local content = StringHelper:concat('攻击', att, '，防御', def)
  ChatHelper:sendSystemMsg(content, self.objid)
  self.attack = attack
  self.defense = defense
end

-- 恢复血量（加/减血）
function MyPlayer:recoverHp (hp)
  if (hp == 0) then
    return
  end
  local curHp = PlayerHelper:getHp(self.objid)
  if (hp > 0) then -- 加血
    local maxHp = PlayerHelper:getMaxHp(self.objid)
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
  PlayerHelper:setHp(self.objid, curHp)
end

-- 恢复饱食度（加/减饱食度）
function MyPlayer:recoverFoodLevel(foodLevel)
  if (foodLevel == 0) then
    return
  end
  local curFoodLevel = PlayerHelper:getFoodLevel(self.objid)
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
  PlayerHelper:setFoodLevel(self.objid, curFoodLevel)
end

-- 减体力
function MyPlayer:reduceStrength (strength)
  self.strength = self.strength - strength
  if (self.strength <= 0) then
    self.strength = 100
    self:recoverFoodLevel(-1)
  end
end

-- 伤害生物
function MyPlayer:damageActor (toobjid, val)
  if (val <= 0) then -- 伤害值无效
    return
  end
  if (ActorHelper:isPlayer(toobjid)) then -- 伤害玩家
    local hp = PlayerHelper:getHp(toobjid)
    if (hp > val) then -- 玩家不会死亡
      hp = hp - val
      PlayerHelper:setHp(toobjid, hp)
    else -- 玩家可能会死亡，则检测玩家是否可被杀死
      local ableBeKilled = PlayerHelper:getPlayerEnableBeKilled(toobjid)
      if (ableBeKilled) then -- 能被杀死
        ActorHelper:killSelf(toobjid)
        MyPlayerHelper:playerDefeatActor(self.objid, toobjid)
      else -- 不能被杀死
        hp = 1
        PlayerHelper:setHp(toobjid, hp)
      end
    end
  else -- 伤害了生物
    local hp = CreatureHelper:getHp(toobjid)
    if (not(hp)) then -- 未找到生物
      return
    end
    if (hp > val) then -- 生物不会死亡
      hp = hp - val
      CreatureHelper:setHp(toobjid, hp)
    else -- 生物可能会死亡，则检测生物是否可被杀死
      local ableBeKilled = ActorHelper:getEnableBeKilledState(toobjid)
      if (ableBeKilled) then -- 能被杀死
        ActorHelper:killSelf(toobjid)
        MyPlayerHelper:playerDefeatActor(self.objid, toobjid)
      else -- 不能被杀死
        hp = 1
        CreatureHelper:setHp(toobjid, hp)
      end
    end
  end
  MyPlayerHelper:playerDamageActor(self.objid, toobjid)
end

-- 设置囚禁状态
function MyPlayer:setImprisoned (active)
  self:enableMove(not(active)) -- 可移动设置
  PlayerHelper:setActionAttrState(self.objid, PLAYERATTR.ENABLE_ATTACK, not(active)) -- 可攻击设置
  if (active) then
    -- 设置囚禁标志用于不能使用主动技能
    self.cantUseSkillReasons.imprisoned = self.cantUseSkillReasons.imprisoned + 1
    ChatHelper:sendSystemMsg('你被慑魂枪震慑了灵魂，无法做出有效行为', self.objid)
  else 
    -- 返回true表示已不是囚禁状态
    self.cantUseSkillReasons.imprisoned = self.cantUseSkillReasons.imprisoned - 1
    return self.cantUseSkillReasons.imprisoned <= 0
  end
end

-- 设置封魔状态
function MyPlayer:setSeal (active)
  if (active) then
    self.cantUseSkillReasons.seal = self.cantUseSkillReasons.seal + 1
    ChatHelper:sendSystemMsg('你被封魔了，当前无法使用技能', self.objid)
  else
    -- 返回true表示已不是封魔状态
    self.cantUseSkillReasons.seal = self.cantUseSkillReasons.seal - 1
    return self.cantUseSkillReasons.seal <= 0
  end
end

-- 是否能够使用技能
function MyPlayer:ableUseSkill (skillname)
  skillname = skillname or ''
  if (self.cantUseSkillReasons.seal > 0) then
    ChatHelper:sendSystemMsg('你处于封魔状态，当前无法使用' .. skillname .. '技能', self.objid)
    return false
  end
  if (self.cantUseSkillReasons.imprisoned > 0) then
    ChatHelper:sendSystemMsg('你处于慑魂状态，当前无法使用' .. skillname .. '技能', self.objid)
    return false
  end
  return true
end
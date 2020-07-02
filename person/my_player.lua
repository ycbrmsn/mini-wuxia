-- 我的玩家类
MyPlayer = {
  objid = nil,
  nickname = nil,
  action = nil,
  wants = nil,  -- 想做什么
  moveMotion = nil,
  prevAreaId = nil, -- 上一进入区域id
  hold = nil -- 手持物品
}

function MyPlayer:new (objid)
  local o = { 
    objid = objid
  }
  o.action = MyPlayerAction:new(o)
  o.attr = MyPlayerAttr:new(o)
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
  self.attr:updatePositions()
end

function MyPlayer:getName ()
  if (not(self.nickname)) then
    self.nickname = PlayerHelper:getNickname(self.objid)
  end
  return self.nickname
end

function MyPlayer:getLevel ()
  return self.attr.totalLevel
end

function MyPlayer:setLevel (level)
  self.attr.totalLevel = level
end

function MyPlayer:getExp ()
  return self.attr.exp
end

function MyPlayer:setExp (exp)
  self.attr.exp = exp
end

function MyPlayer:enableMove (enable, showMsg)
  self.attr:enableMove(enable, showMsg)
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

function MyPlayer:getDistancePosition (distance, angle)
  return MyActorHelper:getDistancePosition(self.objid, distance, angle)
end

function MyPlayer:setDistancePosition (objid, distance, angle)
  self:setPosition(MyActorHelper:getDistancePosition(objid, distance, angle))
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
  self.attr:gainExp(exp)
end

function MyPlayer:upgrade (addLevel)
  return self.attr:upgrade(addLevel)
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
    -- self:showAttr(true) -- 目前默认显示近程攻击
    -- 检测技能是否正在释放
    if (MyItemHelper:isDelaySkillUsing(self.objid, '坠星')) then -- 技能释放中
      FallStarBow:cancelSkill(self.objid)
      return
    end
  end
end

function MyPlayer:changeAttr (attack, defense, dodge)
  self.attr:changeAttr(attack, defense, dodge)
end

function MyPlayer:showAttr (isMelee)
  self.attr:showAttr(isMelee)
end

-- 恢复血量（加/减血）
function MyPlayer:recoverHp (hp)
  self.attr:recoverHp(hp)
end

-- 恢复饱食度（加/减饱食度）
function MyPlayer:recoverFoodLevel(foodLevel)
  self.attr:recoverFoodLevel(foodLevel)
end

-- 减体力
function MyPlayer:reduceStrength (strength)
  self.attr:reduceStrength(strength)
end

-- 伤害生物
function MyPlayer:damageActor (toobjid, val)
  self.attr:damageActor(toobjid, val)
end

-- 设置囚禁状态
function MyPlayer:setImprisoned (active)
  return self.attr:setImprisoned(active)
end

-- 设置封魔状态
function MyPlayer:setSeal (active)
  return self.attr:setSeal(active)
end

-- 是否能够使用技能
function MyPlayer:ableUseSkill (skillname)
  return self.attr:ableUseSkill(skillname)
end
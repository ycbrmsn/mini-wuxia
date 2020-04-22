-- 我的玩家类
MyPlayer = {
  objid = nil,
  nickname = nil,
  action = nil,
  wants = nil,
  moveMotion = nil,
  level = 1,
  totalLevel = 1,
  exp = 0,
  levelExp = 100,
  positions = nil,
  prevAreaId = nil,
  hurtReason = nil
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

function MyPlayer:enableMove (enable)
  if (enable) then
    PlayerHelper:notifyGameInfo2Self(self.objid, '恢复移动')
    PlayerHelper:setAttr(self.objid, PLAYERATTR.WALK_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.RUN_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.SNEAK_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.SWIN_SPEED, -1)
    PlayerHelper:setAttr(self.objid, PLAYERATTR.JUMP_POWER, -1)
  else
    PlayerHelper:notifyGameInfo2Self(self.objid, '当前不可移动')
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

function MyPlayer:gainExp (exp)
  self.exp = self.exp + exp
  local msg = '获得'.. exp .. '点经验。'
  local needExp = self.totalLevel * self.levelExp - self.exp
  if (needExp <= 0) then
    repeat
      msg = msg .. '\n' .. self:upgrade(1)
      needExp = needExp + self.levelExp
    until (needExp > 0)
  else
    msg = msg .. '当前等级为：' .. self.totalLevel .. '。还差' .. needExp .. '点经验升级。'
  end
  ChatHelper:sendSystemMsg(msg, self.objid)
end

function MyPlayer:upgrade (addLevel)
  if (addLevel > 0) then
    self.totalLevel = self.totalLevel + addLevel
    local attrtype1 = { PLAYERATTR.ATK_MELEE, PLAYERATTR.ATK_REMOTE, PLAYERATTR.DEF_MELEE, PLAYERATTR.DEF_REMOTE }
    for i, v in ipairs(attrtype1) do
      PlayerHelper:addAttr(self.objid, v, 2 * addLevel)
    end
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
    local idx = PlayerHelper:getCurShotcut(self.objid) + 1000
    return BackpackHelper:swapGridItem(self.objid, arr[1], idx)
  end
end
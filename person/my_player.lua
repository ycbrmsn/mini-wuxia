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
  positions = nil
}

function MyPlayer:new (objid)
  local o = { 
    objid = objid,
    action = MyPlayerAction:new(self)
  }
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
  local myPosition = MyPosition:new(self:getPosition())
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
  return PlayerHelper:setPlayerEnableMove(self.objid, enable)
end

function MyPlayer:getPosition ()
  return ActorHelper:getPosition(self.objid)
end

function MyPlayer:setPosition (x, y, z)
  if (type(x) == 'table') then
    return ActorHelper:setPosition(self.objid, x.x, x.y, x.z)
  else
    return ActorHelper:setPosition(self.objid, x, y, z)
  end
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
  self.wants = { { style = 'lookAt', dst = objid } }
  MyTimeHelper:callFnAfterSecond(function (p)
    self.wants = nil
  end, seconds)
end
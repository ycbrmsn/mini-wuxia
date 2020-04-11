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
  levelExp = 100
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
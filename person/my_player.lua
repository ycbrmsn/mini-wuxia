-- 我的玩家类
MyPlayer = {
  objid = nil,
  nickname = nil,
  action = nil,
  wants = nil,
  moveMotion = nil
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
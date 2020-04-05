-- 我的玩家类
MyPlayer = {
  objid = nil,
  nickname = nil,
  action = nil,
  wants = nil
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
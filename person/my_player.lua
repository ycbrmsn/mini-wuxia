-- 我的玩家类
MyPlayer = BasePlayer:new()

function MyPlayer:new (objid)
  local o = {
    objid = objid,
    beatBy = nil, -- 被什么生物击败
    finalBeatBy = nil, -- 最终被什么生物击败
    isWinGame = false, -- 是否获得游戏胜利
    initHp = 50, -- 初始生命
  }
  o.action = BasePlayerAction:new(o)
  o.attr = BasePlayerAttr:new(o)
  -- o.attr.expData = { exp = 50 }
  o.attr.defeatedExp = 0
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 自定义初始化
function MyPlayer:initMyPlayer ()
  -- 检测玩家是否有江湖日志，如果没有则放进背包
  if (not(LogPaper:hasItem(self.objid))) then
    LogPaper:newItem(self.objid, 1, true)
  end
  local level = self:getLevel()
  if (level) then
    local hp = self.initHp + level * self.attr.addMaxHp
    PlayerHelper:setMaxHp(self.objid, hp)
    PlayerHelper:setHp(self.objid, hp)
  else
    LogHelper:error('重置玩家生命值失败，建议重新进入游戏')
  end
end
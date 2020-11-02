-- 我的玩家类
MyPlayer = BasePlayer:new()

function MyPlayer:new (objid)
  local o = {
    objid = objid,
    beatBy = nil, -- 被什么生物击败
    finalBeatBy = nil, -- 最终被什么生物击败
    isWinGame = false, -- 是否获得游戏胜利
    initHp = 50, -- 初始生命
    destroyBlock = {}, -- 破坏的方块（这里仅保存城墙）
  }
  o.action = BasePlayerAction:new(o)
  o.attr = BasePlayerAttr:new(o)
  -- o.attr.expData = { exp = 50 }
  o.attr.addMeleeAttack = 1 -- 近战攻击
  o.attr.addRemoteAttack = 1 -- 远程攻击
  o.attr.addMeleeDefense = 1 -- 近战防御
  o.attr.addRemoteDefense = 1 -- 远程防御
  o.attr.addMaxHp = 5 -- 最大生命值
  o.attr.defeatedExp = 0
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 自定义初始化
function MyPlayer:initMyPlayer ()
  local curMaxHp = PlayerHelper:getMaxHp(self.objid)
  local curHp = PlayerHelper:getHp(self.objid)
  local level = self:getLevel()
  if (curMaxHp and curHp and level) then
    local hp = self.initHp + level * self.attr.addMaxHp
    if (curMaxHp ~= hp) then -- 当前最大值与实际最大值不等
      PlayerHelper:setMaxHp(self.objid, hp)
    end
    if (curMaxHp == curHp) then -- 满血
      PlayerHelper:setHp(self.objid, hp)
    end
  else
    LogHelper:error('重置玩家生命值失败，建议重新进入游戏')
  end
end
-- 玩家工具类
PlayerHelper = {
  PLAYERATTR = {
    MAX_HP = 1,
    CUR_HP = 2,
    MAX_HUNGER = 5,
    CUR_HUNGER = 6
  }
}

-- 设置道具不可丢弃
function PlayerHelper:setItemDisableThrow (objid, itemid)
  return self:setItemAttAction(objid, itemid, PLAYERATTR.ITEM_DISABLE_THROW, true)
end

-- 设置玩家是否可以移动
function PlayerHelper:setPlayerEnableMove (objid, enable)
  return self:setActionAttrState(objid, PLAYERATTR.ENABLE_MOVE, enable)
end

-- 查询玩家是否可被杀死
function PlayerHelper:getPlayerEnableBeKilled (objid)
  return PlayerHelper:checkActionAttrState(objid, PLAYERATTR.ENABLE_BEKILLED)
end

-- 设置玩家是否可被杀死
function PlayerHelper:setPlayerEnableBeKilled (objid, enable)
  return self:setActionAttrState(objid, PLAYERATTR.ENABLE_BEKILLED, enable)
end

-- 设置玩家是否可被攻击
function PlayerHelper:setPlayerEnableBeAttacked (objid, enable)
  return self:setActionAttrState(objid, PLAYERATTR.ENABLE_BEATTACKED, enable)
end

function PlayerHelper:getHp (objid)
  return self:getAttr(objid, PLAYERATTR.CUR_HP)
end

function PlayerHelper:getMaxHp (objid)
  return self:getAttr(objid, PLAYERATTR.MAX_HP)
end

function PlayerHelper:getLevel (objid)
  return self:getAttr(objid, PLAYERATTR.LEVEL)
end

function PlayerHelper:setHp (objid, hp)
  return self:setAttr(objid, PLAYERATTR.CUR_HP, hp)
end

function PlayerHelper:setMaxHp (objid, hp)
  return self:setAttr(objid, PLAYERATTR.MAX_HP, hp)
end

function PlayerHelper:addAttr (objid, attrtype, addVal)
  local curVal = self:getAttr(objid, attrtype)
  self:setAttr(objid, attrtype, curVal + addVal)
end

function PlayerHelper:recoverAttr (objid, attrtype)
  return self:setAttr(objid, attrtype + 1, self:getAttr(objid, attrtype))
end

-- 封装原始接口

-- 获取玩家昵称
function PlayerHelper:getNickname (objid)
  local onceFailMessage = '获取玩家昵称失败一次'
  local finillyFailMessage = StringHelper:concat('获取玩家昵称失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getNickname(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 对玩家显示飘窗文字
function PlayerHelper:notifyGameInfo2Self (objid, info)
  local onceFailMessage = '对玩家显示飘窗文字失败一次'
  local finillyFailMessage = StringHelper:concat('对玩家显示飘窗文字失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:notifyGameInfo2Self(objid, info)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置玩家道具设置属性
function PlayerHelper:setItemAttAction (objid, itemid, attrtype, switch)
  local onceFailMessage = '设置玩家道具设置属性失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家道具设置属性失败，参数：objid=', objid, ', itemid=', itemid, ', attrtype=', attrtype, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setItemAttAction(objid, itemid, attrtype, switch)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置玩家位置
function PlayerHelper:setPosition (objid, x, y, z)
  local onceFailMessage = '设置玩家位置失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家位置失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setPosition(objid, x, y, z)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取玩家特殊属性的状态
function PlayerHelper:checkActionAttrState (objid, actionattr)
  local onceFailMessage = '获取玩家特殊属性的状态失败一次'
  local finillyFailMessage = StringHelper:concat('获取玩家特殊属性的状态失败，参数：objid=', objid, ',actionattr=', actionattr)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:checkActionAttrState(objid, actionattr)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置玩家行为属性状态
function PlayerHelper:setActionAttrState (objid, actionattr, switch)
  local onceFailMessage = '设置玩家行为属性状态失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家行为属性状态失败，参数：objid=', objid, ', actionattr=', actionattr, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setActionAttrState(objid, actionattr, switch)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 旋转玩家镜头
function PlayerHelper:rotateCamera (objid, yaw, pitch)
  local onceFailMessage = '旋转玩家镜头失败一次'
  local finillyFailMessage = StringHelper:concat('旋转玩家镜头失败，参数：objid=', objid, ', yaw=', yaw, ', pitch=', pitch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:rotateCamera(objid, yaw, pitch)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 玩家属性获取
function PlayerHelper:getAttr (objid, attrtype)
  local onceFailMessage = '玩家属性获取失败一次'
  local finillyFailMessage = StringHelper:concat('玩家属性获取失败，参数：objid=', objid, ', attrtype=', attrtype)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getAttr(objid, attrtype)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 玩家属性设置
function PlayerHelper:setAttr (objid, attrtype, val)
  local onceFailMessage = '玩家属性设置失败一次'
  local finillyFailMessage = StringHelper:concat('玩家属性设置失败，参数：objid=', objid, ', attrtype=', attrtype, ', val=', val)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setAttr(objid, attrtype, val)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取玩家队伍
function PlayerHelper:getTeam (objid)
  local onceFailMessage = '获取玩家队伍失败一次'
  local finillyFailMessage = StringHelper:concat('获取玩家队伍失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getTeam(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置玩家队伍（数据变了，但是好像没起作用）
function PlayerHelper:setTeam (objid, teamid)
  local onceFailMessage = '设置玩家队伍失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家队伍失败，参数：objid=', objid, ', teamid=', teamid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setTeam(objid, teamid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 玩家播放动画
function PlayerHelper:playAct (objid, actid)
  local onceFailMessage = '玩家播放动画失败一次'
  local finillyFailMessage = StringHelper:concat('玩家播放动画失败，参数：objid=', objid, ', actid=', actid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:playAct(objid, actid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 改变玩家视角模式
function PlayerHelper:changeViewMode (objid, viewmode, islock)
  local onceFailMessage = '改变玩家视角模式失败一次'
  local finillyFailMessage = StringHelper:concat('改变玩家视角模式失败，参数：objid=', objid, ',viewmode=', viewmode, ',islock=', islock)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:changeViewMode(objid, viewmode, islock)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取当前所用快捷栏键
function PlayerHelper:getCurShotcut (objid)
  local onceFailMessage = '获取当前所用快捷栏键失败一次'
  local finillyFailMessage = StringHelper:concat('获取当前所用快捷栏键失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getCurShotcut(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取当前饱食度
function PlayerHelper:getFoodLevel (objid)
  local onceFailMessage = '获取当前饱食度失败一次'
  local finillyFailMessage = StringHelper:concat('获取当前饱食度失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getFoodLevel(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置玩家饱食度
function PlayerHelper:setFoodLevel (objid, foodLevel)
  local onceFailMessage = '设置玩家饱食度失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家饱食度失败，参数：objid=', objid, ',foodLevel=', foodLevel)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setFoodLevel(objid, foodLevel)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取玩家当前手持的物品id
function PlayerHelper:getCurToolID (objid)
  local onceFailMessage = '获取玩家当前手持的物品id失败一次'
  local finillyFailMessage = StringHelper:concat('获取玩家当前手持的物品id失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getCurToolID(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置技能CD，该技能CD为工具原生技能的CD，添加的技能CD与此无关，因此，此方法没什么用
function PlayerHelper:setSkillCD (objid, itemid, cd)
  local onceFailMessage = '设置技能CD失败一次'
  local finillyFailMessage = StringHelper:concat('设置技能CD失败，参数：objid=', objid, ',itemid=', itemid, ',cd=', cd)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setSkillCD(objid, itemid, cd)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取player准星位置
function PlayerHelper:getAimPos (objid)
  local onceFailMessage = '获取player准星位置失败一次'
  local finillyFailMessage = StringHelper:concat('获取player准星位置失败，参数：objid=', objid)
  return CommonHelper:callThreeResultMethod(function (p)
    return Player:getAimPos(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 传送玩家到出生点
function PlayerHelper:teleportHome (objid)
  local onceFailMessage = '传送玩家到出生点失败一次'
  local finillyFailMessage = StringHelper:concat('传送玩家到出生点失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:teleportHome(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end
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

-- 设置玩家是否可被杀死
function PlayerHelper:setPlayerEnableBeKilled (objid, enable)
  return self:setActionAttrState(objid, PLAYERATTR.ENABLE_BEKILLED, enable)
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
    return Player:getNickname(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end

-- 对玩家显示飘窗文字
function PlayerHelper:notifyGameInfo2Self (objid, info)
  local onceFailMessage = '对玩家显示飘窗文字失败一次'
  local finillyFailMessage = StringHelper:concat('对玩家显示飘窗文字失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:notifyGameInfo2Self(p.objid, p.info)
  end, { objid = objid, info = info }, onceFailMessage, finillyFailMessage)
end

-- 设置玩家道具设置属性
function PlayerHelper:setItemAttAction (objid, itemid, attrtype, switch)
  local onceFailMessage = '设置玩家道具设置属性失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家道具设置属性失败，参数：objid=', objid, ', itemid=', itemid, ', attrtype=', attrtype, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setItemAttAction(p.objid, p.itemid, p.attrtype, p.switch)
  end, { objid = objid, itemid = itemid, attrtype = attrtype, switch = switch }, onceFailMessage, finillyFailMessage)
end

-- 设置玩家位置
function PlayerHelper:setPosition (objid, x, y, z)
  local onceFailMessage = '设置玩家位置失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家位置失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setPosition(p.objid, p.x, p.y, p.z)
  end, { objid = objid, x = x, y = y, z = z }, onceFailMessage, finillyFailMessage)
end

-- 设置玩家行为属性状态
function PlayerHelper:setActionAttrState (objid, actionattr, switch)
  local onceFailMessage = '设置玩家行为属性状态失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家行为属性状态失败，参数：objid=', objid, ', actionattr=', actionattr, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setActionAttrState(p.objid, p.actionattr, p.switch)
  end, { objid = objid, actionattr = actionattr, switch = switch }, onceFailMessage, finillyFailMessage)
end

-- 旋转玩家镜头
function PlayerHelper:rotateCamera (objid, yaw, pitch)
  local onceFailMessage = '旋转玩家镜头失败一次'
  local finillyFailMessage = StringHelper:concat('旋转玩家镜头失败，参数：objid=', objid, ', yaw=', yaw, ', pitch=', pitch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:rotateCamera(p.objid, p.yaw, p.pitch)
  end, { objid = objid, yaw = yaw, pitch = pitch }, onceFailMessage, finillyFailMessage)
end

-- 玩家属性获取
function PlayerHelper:getAttr (objid, attrtype)
  local onceFailMessage = '玩家属性获取失败一次'
  local finillyFailMessage = StringHelper:concat('玩家属性获取失败，参数：objid=', objid, ', attrtype=', attrtype)
  return CommonHelper:callOneResultMethod(function (p)
    return Player:getAttr(p.objid, p.attrtype)
  end, { objid = objid, attrtype = attrtype }, onceFailMessage, finillyFailMessage)
end

-- 玩家属性设置
function PlayerHelper:setAttr (objid, attrtype, val)
  local onceFailMessage = '玩家属性设置失败一次'
  local finillyFailMessage = StringHelper:concat('玩家属性设置失败，参数：objid=', objid, ', attrtype=', attrtype, ', val=', val)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setAttr(p.objid, p.attrtype, p.val)
  end, { objid = objid, attrtype = attrtype, val = val }, onceFailMessage, finillyFailMessage)
end

-- 设置玩家队伍（数据变了，但是好像没起作用）
function PlayerHelper:setTeam (objid, teamid)
  local onceFailMessage = '设置玩家队伍失败一次'
  local finillyFailMessage = StringHelper:concat('设置玩家队伍失败，参数：objid=', objid, ', teamid=', teamid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Player:setTeam(p.objid, p.teamid)
  end, { objid = objid, teamid = teamid }, onceFailMessage, finillyFailMessage)
end
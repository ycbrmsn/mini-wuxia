-- 玩家工具类
PlayerHelper = {}

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


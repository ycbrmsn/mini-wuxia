-- 角色工具类
ActorHelper = {}

-- 设置生物可移动状态
function ActorHelper:setEnableMoveState (objid, switch)
  return self:setActionAttrState(objid, CREATUREATTR.ENABLE_MOVE, switch)
end

-- 获取生物可移动状态
function ActorHelper:getEnableMoveState (objid)
  return self:getActionAttrState(objid, CREATUREATTR.ENABLE_MOVE)
end

-- 封装原始接口

-- 向目标位置移动
function ActorHelper:tryMoveToPos (objid, x, y, z, speed)
  local onceFailMessage = '向目标移动失败一次'
  local finillyFailMessage = StringHelper:concat('向目标移动失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z, ', speed=', speed)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:tryMoveToPos(p.objid, p.x, p.y, p.z, p.speed)
  end, { objid = objid, x = x, y = y, z = z, speed = speed }, onceFailMessage, finillyFailMessage)
end

-- 寻路到目标位置
function ActorHelper:tryNavigationToPos (objid, x, y, z, cancontrol)
  local onceFailMessage = '寻路到目标位置失败一次'
  local finillyFailMessage = StringHelper:concat('寻路到目标位置失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z, ', cancontrol=', cancontrol)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:tryNavigationToPos(p.objid, p.x, p.y, p.z, p.cancontrol)
  end, { objid = objid, x = x, y = y, z = z, cancontrol = cancontrol }, onceFailMessage, finillyFailMessage)
end

-- 设置生物行为状态
function ActorHelper:setActionAttrState (objid, actionattr, switch)
  local onceFailMessage = '设置生物行为状态失败一次'
  local finillyFailMessage = StringHelper:concat('设置生物行为状态失败，参数：objid=', objid, ', actionattr=', actionattr, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:setActionAttrState(p.objid, p.actionattr, p.switch)
  end, { objid = objid, actionattr = actionattr, switch = switch }, onceFailMessage, finillyFailMessage)
end

-- 获取生物行为状态
function ActorHelper:getActionAttrState (objid, actionattr)
  local onceFailMessage = '获取生物行为状态失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物行为状态失败，参数：objid=', objid, ', actionattr=', actionattr)
  return CommonHelper:callOneResultMethod(function (p)
    return Actor:getActionAttrState(p.objid, p.actionattr)
  end, { objid = objid, actionattr = actionattr }, onceFailMessage, finillyFailMessage)
end

-- 获取生物位置
function ActorHelper:getPosition (objid)
  local onceFailMessage = '获取生物位置失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物位置失败，参数：objid=', objid)
  return CommonHelper:callThreeResultMethod(function (p)
    return Actor:getPosition(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end

-- 设置生物位置
function ActorHelper:setPosition (objid, x, y, z)
  local onceFailMessage = '设置生物位置失败一次'
  local finillyFailMessage = StringHelper:concat('设置生物位置失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:setPosition(p.objid, p.x, p.y, p.z)
  end, { objid = objid, x = x, y = y, z = z }, onceFailMessage, finillyFailMessage)
end

-- 清除生物ID为actorid的生物
function ActorHelper:clearActorWithId (actorid, bkill)
  local onceFailMessage = '清除生物失败一次'
  local finillyFailMessage = StringHelper:concat('清除生物失败，参数：actorid=', actorid, ', bkill=', bkill)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:clearActorWithId(p.actorid, p.bkill)
  end, { actorid = actorid, bkill = bkill }, onceFailMessage, finillyFailMessage)
end

-- 是否是玩家
function ActorHelper:isPlayer (objid)
  return Actor:isPlayer(objid) == ErrorCode.OK
end
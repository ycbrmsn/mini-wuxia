-- 生物工具类
CreatureHelper = {}

-- 封装原始接口

-- 设置生物AI是否生效
function CreatureHelper:setAIActive(objid, isActive)
  local onceFailMessage = '设置生物AI失败一次'
  local finillyFailMessage = StringHelper:concat('设置生物AI失败，参数：objid=', objid, ', isActive=', isActive)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Creature:setAIActive(objid, isActive)
  end, { objid = objid, isActive = isActive }, onceFailMessage, finillyFailMessage)
end

-- 获取生物行走速度，原始速度是-1
function CreatureHelper:getWalkSpeed (objid)
  local onceFailMessage = '获取生物行走速度失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物行走速度失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Creature:getWalkSpeed(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end

-- 设置生物行走速度
function CreatureHelper:setWalkSpeed (objid, speed)
  local onceFailMessage = '设置生物行走速度失败一次'
  local finillyFailMessage = StringHelper:concat('设置生物行走速度失败，参数：objid=', objid, ', speed=', speed)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Creature:setWalkSpeed(p.objid, p.speed)
  end, { objid = objid, speed = speed }, onceFailMessage, finillyFailMessage)
end

-- 获取生物的actorid
function CreatureHelper:getActorID (objid)
  local onceFailMessage = '获取生物的actorid失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物的actorid失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Creature:getActorID(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end

-- 获取生物名称
function CreatureHelper:getActorName (objid)
  local onceFailMessage = '获取生物名称失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物名称失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Creature:getActorName(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end
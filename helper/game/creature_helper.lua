-- 生物工具类
CreatureHelper = {}

-- 封装原始接口

-- 设置生物AI是否生效
function CreatureHelper:setAIActive(objid, isActive)
  local onceFailMessage = '设置生物AI失败一次'
  local finillyFailMessage = '设置生物AI失败'
  return CommonHelper:callIsSuccessMethod(function (p)
    return Creature:setAIActive(objid, isActive)
  end, { objid = objid, isActive = isActive }, onceFailMessage, finillyFailMessage)
end

-- 获取生物行走速度，原始速度是-1
function CreatureHelper:getWalkSpeed (objid)
  local onceFailMessage = '获取生物行走速度失败一次'
  local finillyFailMessage = '获取生物行走速度失败'
  return CommonHelper:callOneResultMethod(function (p)
    return Creature:getWalkSpeed(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end

-- 设置生物行走速度
function CreatureHelper:setWalkSpeed (objid, speed)
  local onceFailMessage = '设置生物行走速度失败一次'
  local finillyFailMessage = '设置生物行走速度失败'
  return CommonHelper:callIsSuccessMethod(function (p)
    return Creature:setWalkSpeed(p.objid, p.speed)
  end, { objid = objid, speed = speed }, onceFailMessage, finillyFailMessage)
end
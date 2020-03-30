-- 区域工具类
AreaHelper = {
  movePosDim = { x = 1, y = 0, z = 1 }
}

-- 创建移动点区域
function AreaHelper:createMovePosArea (pos)
  return self:createAreaRect(pos, self.movePosDim)
end

-- 创建门区域
function AreaHelper:createDoorPosArea (pos)
  return self:createMovePosArea(pos)
end

-- 封装原始接口

-- 根据中心位置创建矩形区域
function AreaHelper:createAreaRect (pos, dim)
  local onceFailMessage = '创建区域失败一次，中心点：' .. pos.x .. ', ' .. pos.y .. ', ' .. pos.z
  local finillyFailMessage = '创建矩形区域失败，中心点：' .. pos.x .. ', ' .. pos.y .. ', ' .. pos.z
  return CommonHelper:callOneResultMethod(function (p)
    return Area:createAreaRect(p.pos, p.dim)
  end, { pos = pos, dim = dim }, onceFailMessage, finillyFailMessage)
end

-- 根据起始点创建矩形区域
function AreaHelper:createAreaRectByRange (posBeg, posEnd)
  local onceFailMessage = '创建矩形区域失败一次，起点：' .. posBeg.x .. ', ' .. posBeg.y .. ', ' .. posBeg.z
  local finillyFailMessage = '创建矩形区域失败，起点：' .. posBeg.x .. ', ' .. posBeg.y .. ', ' .. posBeg.z
  return CommonHelper:callOneResultMethod(function (p)
    return Area:createAreaRectByRange(p.posBeg, p.posEnd)
  end, { posBeg = posBeg, posEnd = posEnd }, onceFailMessage, finillyFailMessage)
end

-- 销毁区域
function AreaHelper:destroyArea (areaid)
  local onceFailMessage = '销毁区域失败一次，区域：' .. areaid
  local finillyFailMessage = '销毁区域失败，区域：' .. areaid
  return CommonHelper:callIsSuccessMethod(function (p)
    return Area:destroyArea(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end

-- 获取区域中的生物
function AreaHelper:getAreaCreatures (areaid)
  local onceFailMessage = '获取区域中的生物失败一次'
  local finillyFailMessage = '获取区域中的生物失败'
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getAreaCreatures(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end

-- 获取随机区域内的位置
function AreaHelper:getRandomPos (areaid)
  local onceFailMessage = '获取随机区域内的位置失败一次'
  local finillyFailMessage = '获取随机区域内的位置失败，参数为'
  if (type(areaid) == 'nil') then
    finillyFailMessage = finillyFailMessage .. 'nil'
  else
    finillyFailMessage = finillyFailMessage .. areaid
  end
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getRandomPos(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end
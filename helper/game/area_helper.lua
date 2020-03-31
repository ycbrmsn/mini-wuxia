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

-- 创建初始化生物区域
function AreaHelper:createInitActorArea (pos)
  return self:createMovePosArea(pos)
end

-- 清空所有木围栏
function AreaHelper:clearAllWoodenFence (areaid)
  return self:clearAllBlock(areaid, BlockHelper.woodenFenceid)
end

-- 封装原始接口

-- 根据中心位置创建矩形区域
function AreaHelper:createAreaRect (pos, dim)
  local onceFailMessage = '创建区域失败一次'
  local finillyFailMessage = StringHelper:concat('创建矩形区域失败，参数：pos=', pos, ', dim=', dim)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:createAreaRect(p.pos, p.dim)
  end, { pos = pos, dim = dim }, onceFailMessage, finillyFailMessage)
end

-- 根据起始点创建矩形区域
function AreaHelper:createAreaRectByRange (posBeg, posEnd)
  local onceFailMessage = '创建矩形区域失败一次'
  local finillyFailMessage = StringHelper:concat('创建矩形区域失败，参数：posBeg=', posBeg, ', posEnd=', posEnd)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:createAreaRectByRange(p.posBeg, p.posEnd)
  end, { posBeg = posBeg, posEnd = posEnd }, onceFailMessage, finillyFailMessage)
end

-- 销毁区域
function AreaHelper:destroyArea (areaid)
  local onceFailMessage = '销毁区域失败一次'
  local finillyFailMessage = StringHelper:concat('销毁区域失败，参数：areaid=', areaid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Area:destroyArea(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end

-- 获取区域中的生物
function AreaHelper:getAreaCreatures (areaid)
  local onceFailMessage = '获取区域中的生物失败一次'
  local finillyFailMessage = StringHelper:concat('获取区域中的生物失败，参数：areaid=', areaid)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getAreaCreatures(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end

-- 获取随机区域内的位置
function AreaHelper:getRandomPos (areaid)
  local onceFailMessage = '获取随机区域内的位置失败一次'
  local finillyFailMessage = StringHelper:concat('获取随机区域内的位置失败，参数：areaid=', areaid)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getRandomPos(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end

-- 清空区域内的全部方块
function AreaHelper:clearAllBlock (areaid, blockid)
  local onceFailMessage = '清空区域内的全部方块失败一次'
  local finillyFailMessage = StringHelper:concat('清空区域内的全部方块失败，参数：areaid=', areaid, '，blockid=', blockid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Area:clearAllBlock(p.areaid, p.blockid)
  end, { areaid = areaid, blockid = blockid }, onceFailMessage, finillyFailMessage)
end

-- 通过位置查找区域
function AreaHelper:getAreaByPos (pos)
  local onceFailMessage = '通过位置查找区域失败一次'
  local finillyFailMessage = StringHelper:concat('通过位置查找区域失败，参数：pos=', pos)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getAreaByPos(p.pos)
  end, { pos = pos }, onceFailMessage, finillyFailMessage)
end
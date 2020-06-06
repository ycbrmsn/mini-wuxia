-- 区域工具类
AreaHelper = {
  movePosDim = { x = 0, y = 0, z = 0 }, -- 移动地点尺寸
  approachPosDim = { x = 1, y = 0, z = 1 }, -- 靠近地点尺寸
  nineCubicDim = { x = 1, y = 1, z = 1 }, -- 扩大1格
  allDoorAreas = {}
}

-- 创建移动点区域
function AreaHelper:createMovePosArea (pos)
  return self:createAreaRect(pos, self.movePosDim)
end

-- 创建靠近区域
function AreaHelper:createApproachPosArea (pos)
  return self:createAreaRect(pos, self.approachPosDim)
end

-- 创建扩大1格区域
function AreaHelper:createNineCubicArea (pos)
  return self:createAreaRect(pos, self.nineCubicDim)
end

-- 创建初始化生物区域
function AreaHelper:createInitActorArea (pos)
  return self:createMovePosArea(pos)
end

-- 清空所有木围栏
function AreaHelper:clearAllWoodenFence (areaid)
  return self:clearAllBlock(areaid, BlockHelper.woodenFenceid)
end

-- 查询areaid内的所有生物
function AreaHelper:getAllCreaturesInAreaId (areaid)
  local posBeg, posEnd = self:getAreaRectRange(areaid)
  return self:getAllCreaturesInAreaRange(posBeg, posEnd)
end

-- 查询areaid内的所有玩家
function AreaHelper:getAllPlayersInAreaId (areaid)
  local posBeg, posEnd = self:getAreaRectRange(areaid)
  return self:getAllPlayersInAreaRange(posBeg, posEnd)
end

-- 查询areaid内的所有生物与玩家，返回生物id数组与玩家id数组
function AreaHelper:getAllCreaturesAndPlayersInAreaId (areaid)
  local posBeg, posEnd = self:getAreaRectRange(areaid)
  local objids1 = self:getAllCreaturesInAreaRange(posBeg, posEnd)
  local objids2 = self:getAllPlayersInAreaRange(posBeg, posEnd)
  return objids1, objids2
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

-- 获取区域中的生物 该接口第二次调用会报错，不使用
-- function AreaHelper:getAreaCreatures (areaid)
--   local onceFailMessage = '获取区域中的生物失败一次'
--   local finillyFailMessage = StringHelper:concat('获取区域中的生物失败，参数：areaid=', areaid)
--   return CommonHelper:callOneResultMethod(function (p)
--     return Area:getAreaCreatures(p.areaid)
--   end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
-- end

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

-- 获取区域范围内全部生物
function AreaHelper:getAllCreaturesInAreaRange (posBeg, posEnd)
  local onceFailMessage = '获取区域范围内全部生物失败一次'
  local finillyFailMessage = StringHelper:concat('获取区域范围内全部生物失败，参数：posBeg=', posBeg, ', posEnd=', posEnd)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getAllCreaturesInAreaRange(posBeg, posEnd)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取区域范围内全部玩家
function AreaHelper:getAllPlayersInAreaRange (posBeg, posEnd)
  local onceFailMessage = '获取区域范围内全部玩家失败一次'
  local finillyFailMessage = StringHelper:concat('获取区域范围内全部玩家失败，参数：posBeg=', posBeg, ', posEnd=', posEnd)
  return CommonHelper:callOneResultMethod(function (p)
    return Area:getAllPlayersInAreaRange(posBeg, posEnd)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取区域范围
function AreaHelper:getAreaRectRange (areaid)
  local onceFailMessage = '获取区域范围失败一次'
  local finillyFailMessage = StringHelper:concat('获取区域范围失败，参数：areaid=', areaid)
  return CommonHelper:callTwoResultMethod(function (p)
    return Area:getAreaRectRange(p.areaid)
  end, { areaid = areaid }, onceFailMessage, finillyFailMessage)
end

-- 位置是否在区域内
function AreaHelper:posInArea (pos, areaid)
  return Area:posInArea(pos, areaid) == ErrorCode.OK
end

-- 替换方块类型为新的方块类型
function AreaHelper:replaceAreaBlock (areaid, srcblockid, destblockid, face)
  local onceFailMessage = '替换方块类型为新的方块类型失败一次'
  local finillyFailMessage = StringHelper:concat('替换方块类型为新的方块类型失败，参数：areaid=', areaid, ',srcblockid=', srcblockid, ',destblockid=', destblockid, ',face=', face)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Area:replaceAreaBlock(p.areaid, p.srcblockid, p.destblockid, p.face)
  end, { areaid = areaid, srcblockid = srcblockid, destblockid = destblockid, face = face }, onceFailMessage, finillyFailMessage)
end
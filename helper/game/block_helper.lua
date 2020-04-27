-- 方块工具类
BlockHelper = {
  repeatTime = 3, -- 失败重复调用次数
  woodenFenceid = 534, -- 木围栏id
  switchid = 724, -- 开关id
  doorid = 812, -- 果木门id
  bedid = 828 -- 舒适的床
}

-- 门是否开着，参数为x, y, z或者table，最后一个doorid，默认是果木门
function BlockHelper:isDoorOpen (x, y, z, doorid)
  local doorPos, doorid = self:getDoorData(x, y, z, doorid)
  local data = self:getBlockData(doorPos.x, doorPos.y, doorPos.z)
  return data > 4 -- 观察数据发现关上的门的数据为0, 1, 2, 3
end

-- 开门，参数为x, y, z或者table，最后一个doorid，默认是果木门
function BlockHelper:openDoor (x, y, z, doorid)
  if (self:isDoorOpen(x, y, z, doorid)) then -- 门开着
    -- do nothing
  else -- 门没有打开
    local doorPos, doorid = self:getDoorData(x, y, z, doorid)
    local data1 = self:getBlockData(doorPos.x, doorPos.y, doorPos.z)
    local data2 = self:getBlockData(doorPos.x, doorPos.y + 1, doorPos.z)
    self:setBlockAll(doorPos.x, doorPos.y, doorPos.z, doorid, data1 + 8)
    self:setBlockAll(doorPos.x, doorPos.y + 1, doorPos.z, doorid, data2 + 8)
    WorldHelper:playOpenDoorSoundOnPos(doorPos)
  end
  return true
end

-- 关门，参数为x, y, z或者table，最后一个doorid，默认是果木门
function BlockHelper:closeDoor (x, y, z, doorid)
  if (self:isDoorOpen(x, y, z, doorid)) then -- 门开着
    local doorPos, doorid = self:getDoorData(x, y, z, doorid)
    local data1 = self:getBlockData(doorPos.x, doorPos.y, doorPos.z)
    local data2 = self:getBlockData(doorPos.x, doorPos.y + 1, doorPos.z)
    self:setBlockAll(doorPos.x, doorPos.y, doorPos.z, doorid, data1 - 8)
    self:setBlockAll(doorPos.x, doorPos.y + 1, doorPos.z, doorid, data2 - 8)
    WorldHelper:playCloseDoorSoundOnPos(doorPos)
  else -- 门没有打开
    -- do nothing
  end
  return true
end

-- 开关门，参数为x, y, z或者table，最后一个doorid，默认是果木门
function BlockHelper:toggleDoor (x, y, z, doorid)
  if (self:isDoorOpen(x, y, z, doorid)) then
    self:closeDoor(x, y, z, doorid)
  else
    self:openDoor(x, y, z, doorid)
  end
end

-- 封装处理数据函数
function BlockHelper:getDoorData (x, y, z, doorid)
  local doorPos
  if (type(x) == 'number') then
    doorPos = { x = x, y = y, z = z }
    doorid = doorid or self.doorid
  elseif (type(x) == 'table') then
    doorPos = x
    doorid = y or self.doorid
  else -- 其他数据类型
    LogHelper:debug('openDoor数据类型错误')
    return false
  end
  return doorPos, doorid
end

-- 封装原始接口

-- 获取方块数据
function BlockHelper:getBlockData (x, y, z)
  local onceFailMessage = '获取方块数据失败一次'
  local finillyFailMessage = StringHelper:concat('获取方块数据失败，参数：x=', x, ', y=', y, ', z=', z)
  return CommonHelper:callOneResultMethod(function (p)
    return Block:getBlockData(p.x, p.y, p.z)
  end, { x = x, y = y, z = z }, onceFailMessage, finillyFailMessage)
end

-- 设置方块数据
function BlockHelper:setBlockAll (x, y, z, blockid, data)
  local onceFailMessage = '设置方块数据失败一次'
  local finillyFailMessage = StringHelper:concat('设置方块数据失败，参数：x=', x, ', y=', y, ', z=', z, ', blockid=', blockid, ', data=', data)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Block:setBlockAll(p.x, p.y, p.z, p.blockid, p.data)
  end, { x = x, y = y, z = z, blockid = blockid, data = data }, onceFailMessage, finillyFailMessage)
end

-- 设置blockalldata更新当前位置方块
function BlockHelper:setBlockAllForNotify (x, y, z, blockid)
  local onceFailMessage = '设置blockalldata更新当前位置方块失败一次'
  local finillyFailMessage = StringHelper:concat('设置blockalldata更新当前位置方块失败，参数：x=', x, ', y=', y, ', z=', z, ', blockid=', blockid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Block:setBlockAllForNotify(p.x, p.y, p.z, p.blockid)
  end, { x = x, y = y, z = z, blockid = blockid}, onceFailMessage, finillyFailMessage)
end

-- 获取block对应id
function BlockHelper:getBlockID (x, y, z)
  local onceFailMessage = '获取block对应id失败一次'
  local finillyFailMessage = StringHelper:concat('获取block对应id失败，参数：x=', x, ', y=', y, ', z=', z)
  return CommonHelper:callOneResultMethod(function (p)
    return Block:getBlockID(p.x, p.y, p.z)
  end, { x = x, y = y, z = z }, onceFailMessage, finillyFailMessage)
end

-- 替换方块
function BlockHelper:replaceBlock (blockid, x, y, z, face)
  local onceFailMessage = '替换方块失败一次'
  local finillyFailMessage = StringHelper:concat('替换方块失败，参数：blockid=', blockid, ', x=', x, ', y=', y, ', z=', z, ', face=', face)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Block:replaceBlock(p.blockid, p.x, p.y, p.z, p.face)
  end, { blockid = blockid, x = x, y = y, z = z, face = face }, onceFailMessage, finillyFailMessage)
end

-- 是否是气体方块
function BlockHelper:isAirBlock (x, y, z)
  return Block:isAirBlock(x, y, z) == ErrorCode.OK
end

-- 获取功能方块的开关状态
function BlockHelper:getBlockSwitchStatus (pos)
  local onceFailMessage = '获取功能方块的开关状态失败一次'
  local finillyFailMessage = StringHelper:concat('获取功能方块的开关状态失败，参数：pos=', pos)
  return CommonHelper:callOneResultMethod(function (p)
    return Block:getBlockSwitchStatus(p.pos)
  end, { pos = pos }, onceFailMessage, finillyFailMessage)
end

-- 设置方块设置属性状态
function BlockHelper:setBlockSettingAttState (blockid, attrtype, switch)
  local onceFailMessage = '设置方块设置属性状态一次'
  local finillyFailMessage = StringHelper:concat('设置方块设置属性状态失败，参数：blockid=', blockid, ', attrtype=', attrtype, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Block:setBlockSettingAttState(blockid, attrtype, switch)
  end, {}, onceFailMessage, finillyFailMessage)
end
-- 方块工具类
BlockHelper = {
  repeatTime = 3, -- 失败重复调用次数
  doorid = 812 -- 果木门id
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
  local finillyFailMessage = '获取方块数据失败'
  return CommonHelper:callOneResultMethod(function (p)
    return Block:getBlockData(p.x, p.y, p.z)
  end, { x = x, y = y, z = z }, onceFailMessage, finillyFailMessage)
end

-- 设置方块数据
function BlockHelper:setBlockAll (x, y, z, blockid, data)
  local onceFailMessage = '设置方块数据失败一次'
  local finillyFailMessage = '设置方块数据失败'
  return CommonHelper:callIsSuccessMethod(function (p)
    return Block:setBlockAll(p.x, p.y, p.z, p.blockid, p.data)
  end, { x = x, y = y, z = z, blockid = blockid, data = data }, onceFailMessage, finillyFailMessage)
end
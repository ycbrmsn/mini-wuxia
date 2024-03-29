-- 方块工具类
BlockHelper = {
  candles = {}, -- 保存所有蜡烛台
  repeatTime = 3, -- 失败重复调用次数
  woodenFenceid = 534, -- 木围栏id
  switchid = 724, -- 开关id
  doorid = 812, -- 果木门id 白杨木门856
  bedid = 828, -- 舒适的床
  bedid2 = 883, -- 精致木床
  airBlockid = 1081, -- 空气墙-不挡物理
  doorStateData = {
    { { 2, 5 }, { 8, 12 } }, -- 1 南 -> 北
    { { 2, 4 }, { 9, 13 } }, -- 2 南 -> 北
    { { 3, 5 }, { 9, 12 } }, -- 3 北 -> 南
    { { 3, 4 }, { 8, 13 } }, -- 4 北 -> 南
    { { 0, 4 }, { 10, 13 } }, -- 8 西 -> 东
    { { 1, 5 }, { 10, 12 } }, -- 5 东 -> 西
    { { 1, 4 }, { 11, 13 } }, -- 6 东 -> 西
    { { 0, 5 }, { 11, 12 } } -- 7 西 -> 东
  }
}

function BlockHelper.getDoorState (x, y, z)
  local data1 = BlockHelper.getBlockData(x, y, z)
  local data2 = BlockHelper.getBlockData(x, y + 1, z)
  for i, v in ipairs(BlockHelper.doorStateData) do
    for ii, vv in ipairs(v) do
      if data1 == vv[1] and data2 == vv[2] then
        return i
      end
    end
  end
end

function BlockHelper.getCloseDoorState (x, y, z)
  local pos = MyPosition:new(x, y, z)
  for k, doorInfo in pairs(AreaHelper.allDoorAreas) do
    if pos:equals(doorInfo.pos) then
      return doorInfo.state
    end
  end
end

-- 门是否开着，参数为x, y, z或者table
-- function BlockHelper.isDoorOpen (x, y, z)
--   local data = BlockHelper.getBlockData(x, y, z)
--   return data > 4 -- 观察数据发现关上的门的数据为0, 1, 2, 3
-- end
function BlockHelper.isDoorOpen (x, y, z)
  local closeDoorState = BlockHelper.getCloseDoorState(x, y, z) -- 设置关闭的门的状态
  if closeDoorState then
    local state = BlockHelper.getDoorState(x, y, z) -- 当前门的状态
    return closeDoorState ~= state, closeDoorState -- 不相同表示门是开着的
  else -- 没找到状态，表示门没有设置
    LogHelper.debug('没有找到门的关闭数据')
    return nil
  end
end

-- 开门，参数为x, y, z或者table
-- function BlockHelper.openDoor (x, y, z)
--   if BlockHelper.isDoorOpen(x, y, z) then -- 门开着
--     -- do nothing
--   else -- 门没有打开
--     local blockid = BlockHelper.getBlockID(x, y, z)
--     local data1 = BlockHelper.getBlockData(x, y, z)
--     local data2 = BlockHelper.getBlockData(x, y + 1, z)
--     BlockHelper.setBlockAll(x, y, z, blockid, data1 + 8)
--     BlockHelper.setBlockAll(x, y + 1, z, blockid, data2 + 8)
--     WorldHelper.playOpenDoorSoundOnPos(MyPosition:new(x, y, z))
--   end
--   return true
-- end
function BlockHelper.openDoor (x, y, z)
  local isOpen, closeDoorState = BlockHelper.isDoorOpen(x, y, z)
  if isOpen == nil or isOpen then -- 门数据没设置 或者 门开着
    -- do nothing
  else -- 门没有打开
    local blockid = BlockHelper.getBlockID(x, y, z)
    local index = (closeDoorState + 4 - 1) % 8 + 1
    local doorData = BlockHelper.doorStateData[index][1]
    BlockHelper.setBlockAll(x, y, z, blockid, doorData[1])
    -- BlockHelper.setBlockAll(x, y + 1, z, blockid, doorData[2])
    WorldHelper.playOpenDoorSoundOnPos(MyPosition:new(x, y, z))
  end
end

-- 关门，参数为x, y, z或者table
-- function BlockHelper.closeDoor (x, y, z)
--   if BlockHelper.isDoorOpen(x, y, z) then -- 门开着
--     local blockid = BlockHelper.getBlockID(x, y, z)
--     local data1 = BlockHelper.getBlockData(x, y, z)
--     local data2 = BlockHelper.getBlockData(x, y + 1, z)
--     BlockHelper.setBlockAll(x, y, z, blockid, data1 - 8)
--     BlockHelper.setBlockAll(x, y + 1, z, blockid, data2 - 8)
--     WorldHelper.playCloseDoorSoundOnPos(MyPosition:new(x, y, z))
--   else -- 门没有打开
--     -- do nothing
--   end
--   return true
-- end
function BlockHelper.closeDoor (x, y, z)
  local isOpen, closeDoorState = BlockHelper.isDoorOpen(x, y, z)
  if isOpen then -- 门开着
    local blockid = BlockHelper.getBlockID(x, y, z)
    local doorData = BlockHelper.doorStateData[closeDoorState][1]
    BlockHelper.setBlockAll(x, y, z, blockid, doorData[1])
    -- BlockHelper.setBlockAll(x, y + 1, z, blockid, doorData[2])
    WorldHelper.playCloseDoorSoundOnPos(MyPosition:new(x, y, z))
  else -- 门没有打开 或者门的数据没有设置
    -- do nothing
  end
end

-- 开关门，参数为x, y, z或者table
function BlockHelper.toggleDoor (x, y, z)
  if BlockHelper.isDoorOpen(x, y, z) then
    BlockHelper.closeDoor(x, y, z)
  else
    BlockHelper.openDoor(x, y, z)
  end
end

-- 指定位置处的蜡烛台加入集合，参数为（myPosition, blockid）或者 如下
function BlockHelper.addCandle (x, y, z, blockid)
  local myPosition
  if type(x) == 'number' then
    myPosition = MyPosition:new(x, y, z)
  else
    myPosition = x
    blockid = y
  end
  -- local myPos = myPosition:floor()
  local candle = MyCandle:new(myPosition, blockid)
  BlockHelper.candles[myPosition:toString()] = candle
  return candle
end

-- 查询指定位置处的蜡烛台
function BlockHelper.getCandle (myPosition)
  -- local myPos = myPosition:floor()
  return BlockHelper.candles[myPosition:toString()]
end

-- 从集合中删除指定位置的蜡烛台
function BlockHelper.removeCandle (myPosition)
  -- local myPos = myPosition:floor()
  BlockHelper.candles[myPosition:toString()] = nil
end

-- 检查指定位置处是否是蜡烛台
function BlockHelper.checkIsCandle (myPosition)
  local isCandle, blockid = MyCandle:isCandle(myPosition)
  if isCandle then
    local candle = BlockHelper.getCandle(myPosition)
    if not candle then
      candle = BlockHelper.addCandle(myPosition, blockid)
    end
    return true, candle
  else
    return false
  end
end

-- 检查被破坏/移除的方块是否是蜡烛台
function BlockHelper.checkIfRemoveCandle (myPosition, blockid)
  if MyCandle:isBlockCandle(blockid) then
    BlockHelper.removeCandle(myPosition)
  end
end

function BlockHelper.getWhoseCandle (myPosition)
  local index = 1
  -- myPosition = myPosition:floor()
  for k, v in pairs(ActorHelper.getAllActors()) do
    if v.candlePositions and #v.candlePositions > 0 then
      for kk, vv in pairs(v.candlePositions) do
        index = index + 1
        if vv:equals(myPosition) then
          return v
        end
      end
    end
  end
  return nil
end

function BlockHelper.handleCandle (myPosition, isLit)
  if not MyPosition:isPosition(myPosition) then -- 如果不是位置对象，则构造一个位置对象
    myPosition = MyPosition:new(myPosition)
  end
  local isCandle, candle = BlockHelper.checkIsCandle(myPosition)
  if isCandle then
    if type(isLit) == 'nil' then
      candle:toggle()
    elseif isLit then
      candle:light()
    else
      candle:putOut()
    end
  end
  return candle
end

function BlockHelper.checkCandle (objid, blockid, pos)
  if MyCandle:isCandle(blockid) then
    -- 处理蜡烛台
    local candle = BlockHelper.handleCandle(pos)
    if candle then
      local myActor = BlockHelper.getWhoseCandle(pos)
      if myActor then
        local player = PlayerHelper.getPlayer(objid)
        myActor:candleEvent(player, candle)
      end
    end
    return true
  else
    return false
  end
end

-- 是否是固体方块
function BlockHelper.isSolidBlockOffset (pos, dx, dy, dz)
  dx, dy, dz = dx or 0, dy or 0, dz or 0
  return BlockHelper.isSolidBlock(pos.x + dx, pos.y + dy, pos.z + dz)
end

-- 是否是空气方块
function BlockHelper.isAirBlockOffset (pos, dx, dy, dz)
  dx, dy, dz = dx or 0, dy or 0, dz or 0
  return BlockHelper.isAirBlock(pos.x + dx, pos.y + dy, pos.z + dz)
end

-- 是否是不可见方块
function BlockHelper.isInvisibleBlockOffset (pos, dx, dy, dz)
  dx, dy, dz = dx or 0, dy or 0, dz or 0
  local blockid = BlockHelper.getBlockID(pos.x + dx, pos.y + dy, pos.z + dz)
  return (blockid == BLOCKID.AIR) or (blockid == BlockHelper.airBlockid)
end

-- 切换开关状态
function BlockHelper.toggleSwitch (pos)
  local isActive = BlockHelper.getBlockSwitchStatus(pos)
  BlockHelper.setBlockSwitchStatus(pos, not isActive)
end

-- 是否是水（3静态水4水）
function BlockHelper.isWater (x, y, z)
  local blockid = BlockHelper.getBlockID(x, y, z)
  return blockid and (blockid == 3 or blockid == 4)
end

-- 放置方块与空位置
function BlockHelper.placeBlockWhenEmpty (blockid, x, y, z, face)
  local bid = BlockHelper.getBlockID(x, y, z)
  if bid and bid == BLOCKID.AIR then
    -- BlockHelper.placeBlock(blockid, x, y, z, face)
    return BlockHelper.setBlockAll(x, y, z, blockid, face)
  end
end

-- 位置是否是在地上
function BlockHelper.isArroundFloor (pos)
  return BlockHelper.isSolidBlockOffset(pos, 0, -1, 0) and BlockHelper.isSolidBlockOffset(pos, -1, -1, -1)
    and BlockHelper.isSolidBlockOffset(pos, -1, -1, 0) and BlockHelper.isSolidBlockOffset(pos, -1, -1, 1)
    and BlockHelper.isSolidBlockOffset(pos, 0, -1, -1) and BlockHelper.isSolidBlockOffset(pos, 0, -1, 1)
    and BlockHelper.isSolidBlockOffset(pos, 1, -1, -1) and BlockHelper.isSolidBlockOffset(pos, 1, -1, 0)
    and BlockHelper.isSolidBlockOffset(pos, 1, -1, 1)
end

-- 事件

-- 方块被破坏
function BlockHelper.blockDestroyBy (objid, blockid, x, y, z)
  -- body
end

-- 完成方块挖掘
function BlockHelper.blockDigEnd (objid, blockid, x, y, z)
  -- body
end

-- 方块被放置
function BlockHelper.blockPlaceBy (objid, blockid, x, y, z)
  -- body
end

-- 方块被移除
function BlockHelper.blockRemove (blockid, x, y, z)
  -- body
end

-- 方块被触发
function BlockHelper.blockTrigger (objid, blockid, x, y, z)
  -- body
end

-- 封装原始接口

-- 获取方块数据
function BlockHelper.getBlockData (x, y, z)
  return CommonHelper.callOneResultMethod(function (p)
    return Block:getBlockData(x, y, z)
  end, '获取方块数据', 'x=', x, ',y=', y, ',z=', z)
end

-- 设置方块数据
function BlockHelper.setBlockAll (x, y, z, blockid, data)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:setBlockAll(x, y, z, blockid, data)
  end, '设置方块数据', 'x=', x, ',y=', y, ',z=', z, ',blockid=', blockid, ',data=', data)
end

-- 设置blockalldata更新当前位置方块
function BlockHelper.setBlockAllForNotify (x, y, z, blockid)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:setBlockAllForNotify(x, y, z, blockid)
  end, '设置blockalldata更新当前位置方块', 'x=', x, ',y=', y, ',z=', z, ',blockid=', blockid)
end

-- 获取block对应id
function BlockHelper.getBlockID (x, y, z)
  return CommonHelper.callOneResultMethod(function (p)
    return Block:getBlockID(x, y, z)
  end, '获取block对应id', 'x=', x, ',y=', y, ',z=', z)
end

-- 放置方块
function BlockHelper.placeBlock (blockid, x, y, z, face)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:placeBlock(blockid, x, y, z, face)
  end, '放置方块', 'blockid=', blockid, ',x=', x, ',y=', y, ',z=', z, ',face=', face)
end

-- 替换方块
function BlockHelper.replaceBlock (blockid, x, y, z, face)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:replaceBlock(blockid, x, y, z, face)
  end, '替换方块', 'blockid=', blockid, ',x=', x, ',y=', y, ',z=', z,
    ',face=', face)
end

-- 是否是固体方块
function BlockHelper.isSolidBlock (x, y, z)
  return Block:isSolidBlock(x, y, z) == ErrorCode.OK
end

-- 是否是气体方块
function BlockHelper.isAirBlock (x, y, z)
  return Block:isAirBlock(x, y, z) == ErrorCode.OK
end

-- 获取功能方块的开关状态
function BlockHelper.getBlockSwitchStatus (pos)
  return CommonHelper.callOneResultMethod(function (p)
    return Block:getBlockSwitchStatus(pos)
  end, '获取功能方块的开关状态', 'pos=', pos)
end

function BlockHelper.setBlockSwitchStatus (pos, isActive)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:setBlockSwitchStatus(pos, isActive)
  end, '设置功能方块的开关状态', 'pos=', pos, ',isActive=', isActive)
end

-- 设置方块设置属性状态
function BlockHelper.setBlockSettingAttState (blockid, attrtype, switch)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:setBlockSettingAttState(blockid, attrtype, switch)
  end, '设置方块设置属性状态', 'blockid=', blockid, ',attrtype=', attrtype,
    ',switch=', switch)
end

-- 摧毁方块 dropitem:掉落道具(默认false,不掉落)
function BlockHelper.destroyBlock (x, y, z, dropitem)
  return CommonHelper.callIsSuccessMethod(function (p)
    return Block:destroyBlock(x, y, z, dropitem)
  end, '摧毁方块', 'x=', x, ',y=', y, ',z=', z, ',dropitem=', dropitem)
end
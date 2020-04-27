-- 我的方块工具类
MyBlockHelper = {
  candles = {}, -- 保存所有蜡烛台
  cityGateBlockIds = { 414, 122, 415 }, -- 竖纹、雪堆、电石块
  cityGates = { -- 开关、左电石、右电石、右区域
    { MyPosition:new(-41.5, 8.5, 484.5), MyPosition:new(-39.5, 5.5, 480.5), MyPosition:new(-32.5, 5.5, 480.5), MyPosition:new(-35.5, 12.5, 480.5) }, -- 南
    { MyPosition:new(-30.5, 8.5, 619.5), MyPosition:new(-32.5, 5.5, 623.5), MyPosition:new(-39.5, 5.5, 623.5), MyPosition:new(-36.5, 12.5, 623.5) }, -- 北
    { MyPosition:new(31.5, 8.5, 546.5), MyPosition:new(35.5, 5.5, 548.5), MyPosition:new(35.5, 5.5, 555.5), MyPosition:new(35.5, 12.5, 552.5) }, -- 东
    { MyPosition:new(-103.5, 8.5, 557.5), MyPosition:new(-107.5, 5.5, 555.5), MyPosition:new(-107.5, 5.5, 548.5), MyPosition:new(-107.5, 12.5, 551.5) } -- 西
  }
}

function MyBlockHelper:init ()
  for i, v in ipairs(self.cityGates) do
    table.insert(v, AreaHelper:getAreaByPos(v[4]))
  end
end

-- 指定位置处的蜡烛台加入集合，参数为（myPosition, blockid）或者 如下
function MyBlockHelper:addCandle (x, y, z, blockid)
  local myPosition
  if (type(x) == 'number') then
    myPosition = MyPosition:new(x, y, z)
  else
    myPosition = x
    blockid = y
  end
  -- local myPos = myPosition:floor()
  local candle = MyCandle:new(myPosition, blockid)
  self.candles[myPosition:toString()] = candle
  return candle
end

-- 查询指定位置处的蜡烛台
function MyBlockHelper:getCandle (myPosition)
  -- local myPos = myPosition:floor()
  return self.candles[myPosition:toString()]
end

-- 从集合中删除指定位置的蜡烛台
function MyBlockHelper:removeCandle (myPosition)
  -- local myPos = myPosition:floor()
  self.candles[myPosition:toString()] = nil
end

-- 检查指定位置处是否是蜡烛台
function MyBlockHelper:checkIsCandle (myPosition)
  local isCandle, blockid = MyCandle:isCandle(myPosition)
  if (isCandle) then
    local candle = self:getCandle(myPosition)
    if (not(candle)) then
      candle = self:addCandle(myPosition, blockid)
    end
    return true, candle
  else
    return false
  end
end

-- 检查被破坏/移除的方块是否是蜡烛台
function MyBlockHelper:checkIfRemoveCandle (myPosition, blockid)
  if (MyCandle:isBlockCandle(blockid)) then
    self:removeCandle(myPosition)
  end
end

function MyBlockHelper:check (pos, objid)
  local blockid = BlockHelper:getBlockID(pos.x, pos.y, pos.z)
  if (MyCandle:isCandle(blockid)) then
    -- 处理蜡烛台
    local candle = self:handleCandle(pos)
    if (candle) then
      local myActor = self:getWhoseCandle(pos)
      if (myActor) then
        local player = MyPlayerHelper:getPlayer(objid)
        myActor:candleEvent(player, candle)
      end
    end
  elseif (MyBed:isBed(blockid)) then
    -- 处理床
    MyPlayerHelper:showToast(objid, '你无法在别人的床上睡觉')
  end
end

function MyBlockHelper:getWhoseCandle (myPosition)
  local index = 1
  -- myPosition = myPosition:floor()
  for k, v in pairs(MyActorHelper:getAllActors()) do
    if (v.candlePositions and #v.candlePositions > 0) then
      for kk, vv in pairs(v.candlePositions) do
        index = index + 1
        if (vv:equals(myPosition)) then
          return v
        end
      end
    end
  end
  return nil
end

function MyBlockHelper:handleCandle (myPosition, isLit)
  if (not(MyPosition:isPosition(myPosition))) then
    myPosition = MyPosition:new(myPosition)
  end
  local isCandle, candle = self:checkIsCandle(myPosition)
  if (isCandle) then
    if (type(isLit) == 'nil') then
      candle:toggle()
    elseif (isLit) then
      candle:light()
    else
      candle:putOut()
    end
  end
  return candle
end

function MyBlockHelper:checkCityGates (args)
  if (args.blockid == 724) then -- 开关
    for i, v in ipairs(self.cityGates) do
      if (v[1]:equals(args)) then -- 找到开关
        if (BlockHelper:getBlockSwitchStatus(v[1])) then -- 打开
          if (BlockHelper:getBlockID(v[4].x, v[4].y, v[4].z) == self.cityGateBlockIds[1]) then
            AreaHelper:replaceAreaBlock(v[5], self.cityGateBlockIds[1], self.cityGateBlockIds[2], 5)
            BlockHelper:replaceBlock(self.cityGateBlockIds[3], v[2].x, v[2].y, v[2].z)
            MyTimeHelper:callFnFastRuns(function ()
              AreaHelper:replaceAreaBlock(v[5], self.cityGateBlockIds[2], self.cityGateBlockIds[1], 5)
              BlockHelper:replaceBlock(self.cityGateBlockIds[3], v[3].x, v[3].y, v[3].z)
            end, 0.005)
          end
        else
          BlockHelper:replaceBlock(self.cityGateBlockIds[2], v[2].x, v[2].y, v[2].z)
          BlockHelper:replaceBlock(self.cityGateBlockIds[2], v[3].x, v[3].y, v[3].z)
        end
        break
      end
    end
  end
end

function MyBlockHelper:initBlocks ()
  BlockHelper:setBlockSettingAttState(BlockHelper.bedid, BLOCKATTR.ENABLE_BEOPERATED, false) -- 舒适的床不可操作
  BlockHelper:setBlockSettingAttState(BlockHelper.switchid, BLOCKATTR.ENABLE_DESTROYED, false) -- 开关不可被破坏
  BlockHelper:setBlockSettingAttState(BlockHelper.doorid, BLOCKATTR.ENABLE_DESTROYED, false) -- 门不可被破坏
end

function MyBlockHelper:blockDigEnd (objid, blockid, x, y, z)
  local disableMsg = '不可被破坏'
  if (blockid == BlockHelper.switchid) then
    MyPlayerHelper:showToast(objid, '开关', disableMsg)
  elseif (blockid == BlockHelper.doorid) then
    MyPlayerHelper:showToast(objid, '门', disableMsg)
  end
end
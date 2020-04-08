-- 我的方块工具类
MyBlockHelper = {
  candles = {} -- 保存所有蜡烛台
}

-- 指定位置处的蜡烛台加入集合
function MyBlockHelper:addCandle (myPosition, blockid)
  local candle = MyCandle:new(myPosition, blockid)
  self.candles[myPosition:toNumber()] = candle
  return candle
end

-- 查询指定位置处的蜡烛台
function MyBlockHelper:getCandle (myPosition)
  return self.candles[myPosition:toNumber()]
end

-- 从集合中删除指定位置的蜡烛台
function MyBlockHelper:removeCandle (myPosition)
  self.candles[myPosition:toNumber()] = nil
end

-- 检查指定位置处是否是蜡烛台
function MyBlockHelper:checkIsCandle (myPosition)
  local isCandle, blockid = MyCandle:isCandle(myPosition)
  if (isCandle) then
    local candle = self:getCandle(myPosition)
    if (not(candle)) then
      candle = self:addCandle(myPosition, blockid)
    end
    candle:toggle()
  end
end

-- 检查被破坏/移除的方块是否是蜡烛台
function MyBlockHelper:checkIfRemoveCandle (myPosition, blockid)
  if (MyCandle:isBlockCandle(blockid)) then
    self:removeCandle(myPosition)
  end
end

function MyBlockHelper:check (myPosition)
  if (not(MyPosition:isPosition(myPosition))) then
    myPosition = MyPosition:new(myPosition)
  end
  MyBlockHelper:checkIsCandle(myPosition)
end
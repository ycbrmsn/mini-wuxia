-- 我的方块工具类
MyBlockHelper = {
  candles = {} -- 保存所有蜡烛台
}

-- 指定位置处的蜡烛台加入集合，参数为（myPosition, blockid）或者 如下
function MyBlockHelper:addCandle (x, y, z, blockid)
  local myPosition
  if (type(x) == 'number') then
    myPosition = MyPosition:new(x, y, z)
  else
    myPosition = x
    blockid = y
  end
  local myPos = myPosition:floor()
  local candle = MyCandle:new(myPos, blockid)
  self.candles[myPos:toString()] = candle
  return candle
end

-- 查询指定位置处的蜡烛台
function MyBlockHelper:getCandle (myPosition)
  local myPos = myPosition:floor()
  return self.candles[myPos:toString()]
end

-- 从集合中删除指定位置的蜡烛台
function MyBlockHelper:removeCandle (myPosition)
  local myPos = myPosition:floor()
  self.candles[myPos:toString()] = nil
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

function MyBlockHelper:check (myPosition, objid)
  local candle = self:handleCandle(myPosition)
  if (candle) then
    local myActor = self:getWhoseCandle(myPosition)
    if (myActor) then
      local myPlayer = MyPlayerHelper:getPlayer(objid)
      myActor:candleEvent(myPlayer, candle)
    end
  end
end

function MyBlockHelper:getWhoseCandle (myPosition)
  local index = 1
  myPosition = myPosition:floor()
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

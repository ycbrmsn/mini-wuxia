-- 蜡烛台
MyCandle = {
  BLOCK_ID = {
    CANDLE = 931, -- 熄灭的蜡烛台
    LIT_CANDLE = 932 -- 点燃的蜡烛台
  },
  pos = nil,
  isLit = false
}

function MyCandle:new (myPosition, blockid)
  blockid = blockid or self.BLOCK_ID.CANDLE
  local o = {
    pos = myPosition,
    isLit = blockid == self.BLOCK_ID.LIT_CANDLE
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 位置上是否是蜡烛台
function MyCandle:isCandle (myPosition)
  local blockid = BlockHelper:getBlockID(myPosition.x, myPosition.y, myPosition.z)
  return self:isBlockCandle(blockid)
end

-- 方块是否是蜡烛台
function MyCandle:isBlockCandle (blockid)
  return blockid == self.BLOCK_ID.CANDLE or blockid == self.BLOCK_ID.LIT_CANDLE, blockid
end

-- 点燃
function MyCandle:light ()
  self.isLit = true
  return BlockHelper:setBlockAllForNotify(self.pos.x, self.pos.y, self.pos.z, self.BLOCK_ID.LIT_CANDLE)
end

-- 熄灭
function MyCandle:putOut ()
  self.isLit = false
  return BlockHelper:setBlockAllForNotify(self.pos.x, self.pos.y, self.pos.z, self.BLOCK_ID.CANDLE)
end

-- 切换
function MyCandle:toggle ()
  if (self.isLit) then
    self:putOut()
  else
    self:light()
  end
end

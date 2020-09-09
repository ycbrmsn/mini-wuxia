-- 我的方块工具类
MyBlockHelper = {
  unableBeoperated = {
    BlockHelper.bedid
  },
  unableDestroyed = {
    BlockHelper.switchid,
    BlockHelper.doorid,
    860, -- 落叶松木门
    MyMap.BLOCK.COPPER_ORE_ID
  },
  cityGateBlockIds = { 414, 122, 415 }, -- 竖纹、雪堆、电石块
  cityGatesData = { -- 开关、左电石、右电石、右区域
    { { -42, 8, 484 }, { -40, 5, 480 }, { -33, 5, 480 }, { -36, 12, 480 } }, -- 南
    { { -31, 8, 619 }, { -33, 5, 623 }, { -40, 5, 623 }, { -37, 12, 623 } }, -- 北
    { { 31, 8, 546 }, { 35, 5, 548 }, { 35, 5, 555 }, { 35, 12, 552 } }, -- 东
    { { -104, 8, 557 }, { -108, 5, 555 }, { -108, 5, 548 }, { -108, 12, 551 } } -- 西
  },  
  cityGates = {}
}

-- 初始化
function MyBlockHelper:init ()
  -- body
  -- 前四个位置，第五个区域
  for i, v in ipairs(self.cityGatesData) do
    local cityGate = {}
    AreaHelper:initPosByPosData(v, cityGate)
    table.insert(cityGate, AreaHelper:getAreaByPos(cityGate[4]))
    table.insert(self.cityGates, cityGate)
  end
end

function MyBlockHelper:initBlocks ()
  for i,v in ipairs(self.unableBeoperated) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_BEOPERATED, false) -- 不可操作  
  end
  for i, v in ipairs(self.unableDestroyed) do
    BlockHelper:setBlockSettingAttState(v, BLOCKATTR.ENABLE_DESTROYED, false) -- 不可被破坏
  end
end

-- 检查城门开关
function MyBlockHelper:checkCityGateSwitch (blockid, pos)
  if (blockid == 724) then -- 开关
    for i, v in ipairs(self.cityGates) do
      if (v[1]:equalBlockPos(pos)) then -- 找到开关
        if (BlockHelper:getBlockSwitchStatus(v[1])) then -- 打开
          if (BlockHelper:getBlockID(v[4].x, v[4].y, v[4].z) == self.cityGateBlockIds[1]) then
            AreaHelper:replaceAreaBlock(v[5], self.cityGateBlockIds[1], self.cityGateBlockIds[2], 5)
            BlockHelper:replaceBlock(self.cityGateBlockIds[3], v[2].x, v[2].y, v[2].z)
            TimeHelper:callFnFastRuns(function ()
              AreaHelper:replaceAreaBlock(v[5], self.cityGateBlockIds[2], self.cityGateBlockIds[1], 5)
              BlockHelper:replaceBlock(self.cityGateBlockIds[3], v[3].x, v[3].y, v[3].z)
            end, 0.005)
          end
        else
          BlockHelper:replaceBlock(self.cityGateBlockIds[2], v[2].x, v[2].y, v[2].z)
          BlockHelper:replaceBlock(self.cityGateBlockIds[2], v[3].x, v[3].y, v[3].z)
        end
        return true
      end
    end
  end
  return false
end


-- 事件

-- 方块被破坏
function MyBlockHelper:blockDestroyBy (objid, blockid, x, y, z)
  BlockHelper:blockDestroyBy(objid, blockid, x, y, z)
  -- body
end

-- 完成方块挖掘
function MyBlockHelper:blockDigEnd (objid, blockid, x, y, z)
  BlockHelper:blockDigEnd(objid, blockid, x, y, z)
  -- body
  local disableMsg = '不可被破坏'
  if (blockid == BlockHelper.switchid) then
    PlayerHelper:showToast(objid, '开关', disableMsg)
  elseif (blockid == BlockHelper.doorid or blockid == 860) then
    PlayerHelper:showToast(objid, '门', disableMsg)
  elseif (blockid == MyMap.BLOCK.COPPER_ORE_ID) then -- 铜矿石
    BackpackHelper:addItem(objid, blockid, 1)
  end
end

-- 方块被放置
function MyBlockHelper:blockPlaceBy (objid, blockid, x, y, z)
  BlockHelper:blockPlaceBy(objid, blockid, x, y, z)
  -- body
  if (blockid == MyMap.BLOCK.COPPER_ORE_ID) then -- 铜矿石
    -- 一秒后破坏
    TimeHelper:callFnFastRuns(function ()
      BlockHelper:destroyBlock(x, y, z)
      WorldHelper:playPlaceBlockSoundOnPos(MyPosition:new(x, y, z))
      WorldHelper:spawnItem(x, y, z, blockid, 1)
    end, 1)
  end
end

-- 方块被移除
function MyBlockHelper:blockRemove (blockid, x, y, z)
  BlockHelper:blockRemove(blockid, x, y, z)
  -- body
end

-- 方块被触发
function MyBlockHelper:blockTrigger (objid, blockid, x, y, z)
  BlockHelper:blockTrigger(objid, blockid, x, y, z)
  -- body
end
-- 我的方块工具类
MyBlockHelper = {
  unableBeoperated = {
    BlockHelper.bedid,
    BlockHelper.bedid2,
  },
  unableDestroyed = {
    BlockHelper.switchid,
    BlockHelper.doorid,
    BlockHelper.bedid,
    BlockHelper.bedid2,
    428, -- 四格釉面砖
    667, -- 白色硬砂块
    820, -- 书柜
    860, -- 落叶松木门
    MyMap.BLOCK.COPPER_ORE_ID, -- 铜矿石
    2004, -- 监狱围栏
    2005, -- 监狱围栏
    2006, -- 监狱围栏
    2007, -- 监狱围栏
    2008, -- 监狱围栏
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
function MyBlockHelper.init ()
  MyBlockHelper.initBlocks()
  -- body
  -- 前四个位置，第五个区域
  for i, v in ipairs(MyBlockHelper.cityGatesData) do
    local cityGate = {}
    AreaHelper.initPosByPosData(v, cityGate)
    table.insert(cityGate, AreaHelper.getAreaByPos(cityGate[4]))
    table.insert(MyBlockHelper.cityGates, cityGate)
  end
end

function MyBlockHelper.initBlocks ()
  for i,v in ipairs(MyBlockHelper.unableBeoperated) do
    BlockHelper.setBlockSettingAttState(v, BLOCKATTR.ENABLE_BEOPERATED, false) -- 不可操作  
  end
  for i, v in ipairs(MyBlockHelper.unableDestroyed) do
    BlockHelper.setBlockSettingAttState(v, BLOCKATTR.ENABLE_DESTROYED, false) -- 不可被破坏
  end
end

-- 检查城门开关
function MyBlockHelper.checkCityGateSwitch (blockid, pos)
  if blockid == 724 then -- 开关
    for i, v in ipairs(MyBlockHelper.cityGates) do
      if v[1]:equalBlockPos(pos) then -- 找到开关
        if BlockHelper.getBlockSwitchStatus(v[1]) then -- 打开
          if BlockHelper.getBlockID(v[4].x, v[4].y, v[4].z) == MyBlockHelper.cityGateBlockIds[1] then
            AreaHelper.replaceAreaBlock(v[5], MyBlockHelper.cityGateBlockIds[1], MyBlockHelper.cityGateBlockIds[2], 5)
            BlockHelper.replaceBlock(MyBlockHelper.cityGateBlockIds[3], v[2].x, v[2].y, v[2].z)
            TimeHelper.callFnFastRuns(function ()
              AreaHelper.replaceAreaBlock(v[5], MyBlockHelper.cityGateBlockIds[2], MyBlockHelper.cityGateBlockIds[1], 5)
              BlockHelper.replaceBlock(MyBlockHelper.cityGateBlockIds[3], v[3].x, v[3].y, v[3].z)
            end, 0.005)
          end
        else
          BlockHelper.replaceBlock(MyBlockHelper.cityGateBlockIds[2], v[2].x, v[2].y, v[2].z)
          BlockHelper.replaceBlock(MyBlockHelper.cityGateBlockIds[2], v[3].x, v[3].y, v[3].z)
        end
        return true
      end
    end
  end
  return false
end

-- 点击书柜
function MyBlockHelper.clickBookcase (objid, blockid, x, y, z)
  if blockid == 820 and x == 33 and y == 8 and z == 7 then -- 家里的书柜
    TimeHelper.callFnCanRun(function ()
      local player = PlayerHelper.getPlayer(objid)
      player:enableMove(false, '选择中')
      player:thinkSelf(0, '这里有一些游戏说明，我要看看吗？')
      ChatHelper.sendMsg(objid, '选择对应序号的快捷栏进行选择')
      MyOptionHelper.showOptions(player, 'look')
      -- ChatHelper.showChooseItems(playerid, { '看看', '不看' })
      -- player.whichChoose = 'readme'
    end, 10, objid .. 'clickBookcase')
    return true
  end
  return false
end

-- 点击床睡觉
function MyBlockHelper.clickBed (objid, blockid, x, y, z)
  if MyBed:isBed(blockid) then
    PlayerHelper.showToast(objid, '你无法在别人的床上睡觉')
    return true
  elseif blockid == BlockHelper.bedid2 then
    local player = PlayerHelper.getPlayer(objid)
    if player:isHostPlayer() then
      TimeHelper.callFnCanRun(function ()
        player:enableMove(false, '选择中')
        player:thinkSelf(0, '我要睡多长时间呢？')
        MyOptionHelper.showOptions(player, 'sleep')
      end, 10, objid .. 'clickBed')
    else
      ChatHelper.sendMsg(objid, '仅房主能够使用床睡觉')
    end
    return true
  end
  return false
end

-- 事件

-- 完成方块挖掘
EventHelper.addEvent('blockDigEnd', function (objid, blockid, x, y, z)
  local disableMsg = '不可被破坏'
  if blockid == BlockHelper.switchid then
    PlayerHelper.showToast(objid, '开关', disableMsg)
  elseif blockid == BlockHelper.doorid or blockid == 860 then
    PlayerHelper.showToast(objid, '门', disableMsg)
  elseif blockid == BlockHelper.bedid then -- 木床
    PlayerHelper.showToast(objid, '床', disableMsg)
  elseif blockid == MyMap.BLOCK.COPPER_ORE_ID then -- 铜矿石
    BackpackHelper.addItem(objid, blockid, 1)
    PlayerHelper.showToast(objid, '获得一个铜矿石')
  elseif blockid == 428 then -- 四格釉面砖
    PlayerHelper.showToast(objid, '此地面', disableMsg)
  elseif blockid == 667 then -- 白色硬砂块
    PlayerHelper.showToast(objid, '围墙', disableMsg)
  elseif blockid == 820 then -- 书柜
    PlayerHelper.showToast(objid, '书柜', disableMsg)
  elseif blockid >= 2004 and blockid <= 2008 then
    PlayerHelper.showToast(objid, '围栏', disableMsg)
  end
  MyStoryHelper.blockDigEnd(objid, blockid, x, y, z)
end)

-- 方块被放置
EventHelper.addEvent('blockPlaceBy', function (objid, blockid, x, y, z)
  if blockid == MyMap.BLOCK.COPPER_ORE_ID then -- 铜矿石
    -- 一秒后破坏
    TimeHelper.callFnFastRuns(function ()
      BlockHelper.replaceBlock(BLOCKID.AIR, x, y, z)
      WorldHelper.playPlaceBlockSoundOnPos(MyPosition:new(x, y, z))
      WorldHelper.spawnItem(x, y, z, blockid, 1)
    end, 1)
  end
end)

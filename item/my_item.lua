-- 我的道具类

-- 江湖日志类
LogPaper = BaseItem:new({ id = MyMap.ITEM.LOG_PAPER_ID })

-- 获取日志
function LogPaper:getContent ()
  local title, content = StoryHelper:getMainStoryTitleAndTip()
  return title .. '\n\t\t' .. content
end

-- 显示日志
function LogPaper:showContent (objid)
  ChatHelper:sendSystemMsg(self:getContent(), objid)
end

function LogPaper:useItem (objid)
  self:showContent(objid)
end

-- 保存游戏
SaveGame = BaseItem:new({
  id = MyMap.ITEM.SAVE_GAME_ID,
  blockid = 801, -- 储物箱id
})

function SaveGame:numError (objid)
  ChatHelper:sendMsg(objid, '附近储物箱数目异常，请挖掘掉多余的储物箱')
end

function SaveGame:existError (objid)
  ChatHelper:sendMsg(objid, '附近已存在储物箱，无法创建')
end

function SaveGame:createError (objid)
  ChatHelper:sendMsg(objid, '创建储物箱失败。请找一个空旷的位置进行保存')
end

-- 储物箱查询道具方法会导致退出游戏
function SaveGame:takeOutItem (objid, pos)
  local isEmpty = true
  local x, y, z = math.floor(pos.x), math.floor(pos.y), math.floor(pos.z)
  for i = 0, 29 do
    local itemid, num = WorldContainerHelper:getStorageItem(x, y, z, i)
    if (itemid and itemid ~= 0) then
      if (itemid >= 4129 and itemid <= 4245 and itemid ~= 4130 and itemid ~= 4133 and itemid ~= 4142) then -- 自定义武器
        isEmpty = false
      elseif (itemid > 11000 and itemid < 11100) then -- 常规武器
        isEmpty = false
      elseif (itemid > 12000 and itemid < 12900) then -- 武器+装备
        isEmpty = false
      elseif (itemid >= 15000 and itemid < 15500) then -- 热武器
        isEmpty = false
      else -- 无耐久度的物品
        BackpackHelper:addItem(objid, itemid, num)
        WorldContainerHelper:removeStorageItemByIndex(x, y, z, i, num)
      end
    end
  end
  return isEmpty
end

-- BACKPACK_TYPE.SHORTCUT、BACKPACK_TYPE.INVENTORY
function SaveGame:putInItem (objid, pos, category)
  category = category or BACKPACK_TYPE.SHORTCUT
  local min, max, gap
  if (category == BACKPACK_TYPE.SHORTCUT) then
    min, max, gap = 0, 7, 1000
  elseif (category == BACKPACK_TYPE.INVENTORY) then
    min, max, gap = 0, 39, 0
  else
    min, max, gap = 0, 0, 0
  end
  for i = min, max do
    local gridid = i + gap
    local durcur, durmax = BackpackHelper:getGridDurability(objid, gridid)
    if (durcur == -1 or durcur == durmax) then -- 无耐久或满耐久
      local itemid, num = BackpackHelper:getGridItemID(objid, gridid)
      local realNum = WorldContainerHelper:addStorageItem(pos.x, pos.y, pos.z, itemid, num)
      if (realNum) then
        BackpackHelper:removeGridItem(objid, gridid, realNum)
      end
    end
  end
end

function SaveGame:useItem (objid)
  -- 检测附件是否有储物箱
  local pos = ActorHelper:getMyPosition(objid)
  pos.x, pos.y, pos.z = math.floor(pos.x), math.floor(pos.y), math.floor(pos.z)
  local positions = AreaHelper:getBlockPositionsAround(pos, { x = 5, y = 5, z = 5 }, self.blockid)
  if (#positions > 0) then
    PlayerHelper:openBoxByPos(objid, positions[1].x, positions[1].y, positions[1].z)
    return
  end

  -- 创建储物箱
  local offsets = {}
  local x, y, z = ActorHelper:getFaceDirection(objid)
  if (math.abs(x) > math.abs(z)) then -- 东西走向
    if (x > 0) then -- 朝东
      table.insert(offsets, { 2, 0 })
    else -- 朝西
      table.insert(offsets, { -2, 0 })
    end
    if (z > 0) then -- 朝北
      table.insert(offsets, { 0, 2 })
    else -- 朝南
      table.insert(offsets, { 0, -2 })
    end
  else -- 南北走向
    if (z > 0) then -- 朝北
      table.insert(offsets, { 0, 2 })
    else -- 朝南
      table.insert(offsets, { 0, -2 })
    end
    if (x > 0) then -- 朝东
      table.insert(offsets, { 2, 0 })
    else -- 朝西
      table.insert(offsets, { -2, 0 })
    end
  end
  local dstPos = MyPosition:new(pos.x + offsets[1][1], pos.y, pos.z + offsets[1][2])
  if (not(AreaHelper:isAirArea(dstPos))) then
    dstPos = MyPosition:new(pos.x + offsets[2][1], pos.y, pos.z + offsets[2][2])
    if (not(AreaHelper:isAirArea(dstPos))) then
      self:createError()
      return
    end
  end
  local result1 = WorldContainerHelper:addStorageBox(dstPos.x, dstPos.y, dstPos.z)
  if (not(result1)) then
    self:createError()
    return
  end
  local result2 = WorldContainerHelper:addStorageBox(dstPos.x, dstPos.y + 1, dstPos.z)
  if (not(result2)) then
    self:createError()
    return
  end
  -- 创建成功
  PlayerHelper:openBoxByPos(objid, math.floor(dstPos.x), math.floor(dstPos.y), math.floor(dstPos.z))
  self:putInItem(objid, dstPos)
  self:putInItem(objid, MyPosition:new(dstPos.x, dstPos.y + 1, dstPos.z), BACKPACK_TYPE.INVENTORY)
end

-- 加载进度
LoadGame = BaseItem:new({
  id = MyMap.ITEM.LOAD_GAME_ID,
})

function LoadGame:useError (objid)
  ChatHelper:sendMsg(objid, '加载进度道具仅房主使用有效')
end

function LoadGame:itemLostError (objid, name)
  ChatHelper:sendMsg(objid, '加载错误：#G游戏数据', name, '#n遗失，请找到后重新加载')
end

function LoadGame:loadOver (objid)
  ChatHelper:sendMsg(objid, '游戏加载完成')
end

function LoadGame:useItem (objid)
  if (PlayerHelper:isMainPlayer(objid)) then -- 房主
    local numA = BackpackHelper:getItemNumAndGrid(objid, MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID)
    local numB = BackpackHelper:getItemNumAndGrid(objid, MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID)
    if (not(numA) or numA == 0) then
      self:itemLostError(objid, 'A')
      return
    end
    if (not(numB) or numB == 0) then
      self:itemLostError(objid, 'B')
      return
    end
    -- 数据存在，则开始加载
    local player = PlayerHelper:getPlayer(objid)
    GameDataHelper:updateStoryData()
    if (StoryHelper:recover(player)) then -- 恢复剧情
      self:loadOver(objid)
    end
  else -- 其他玩家
    self:useError(objid)
  end
end
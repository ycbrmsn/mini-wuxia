-- 我的道具类

-- 江湖日志类
LogPaper = BaseItem:new({ id = MyMap.ITEM.LOG_PAPER_ID })

-- 获取日志
function LogPaper:getContent ()
  local title, content = StoryHelper.getMainStoryTitleAndTip()
  return title .. '\n\t\t' .. content
end

-- 显示日志
function LogPaper:showContent (objid)
  ChatHelper.sendSystemMsg(self:getContent(), objid)
end

function LogPaper:useItem (objid)
  self:showContent(objid)
end

-- 保存游戏
SaveGame = BaseItem:new({
  id = MyMap.ITEM.SAVE_GAME_ID,
  blockid = 801, -- 储物箱id
})

function SaveGame:createError (objid)
  ChatHelper.sendMsg(objid, '创建储物箱失败。请找一个空旷的位置进行保存')
end

-- 储物箱查询道具方法会导致退出游戏
function SaveGame:takeOutItem (objid, pos)
  local isEmpty = true
  local x, y, z = math.floor(pos.x), math.floor(pos.y), math.floor(pos.z)
  for i = 0, 29 do
    local itemid, num = WorldContainerHelper.getStorageItem(x, y, z, i)
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
        BackpackHelper.addItem(objid, itemid, num)
        WorldContainerHelper.removeStorageItemByIndex(x, y, z, i, num)
      end
    end
  end
  return isEmpty
end

-- BACKPACK_TYPE.SHORTCUT、BACKPACK_TYPE.INVENTORY
function SaveGame:putInItem (objid, pos, bartype)
  bartype = bartype or BACKPACK_TYPE.SHORTCUT
  local min, max = BackpackHelper.getBackpackBarIDRange(bartype)
  for i = min, max do
    local durcur, durmax = BackpackHelper.getGridDurability(objid, i)
    if (durcur == -1 or durcur == durmax) then -- 无耐久或满耐久
      local itemid, num = BackpackHelper.getGridItemID(objid, i)
      local realNum = WorldContainerHelper.addStorageItem(pos.x, pos.y, pos.z, itemid, num)
      if (realNum) then
        BackpackHelper.removeGridItem(objid, i, realNum)
      end
    end
  end
end

-- 脱下所有装备
function SaveGame:takeOffEquip (objid)
  local min, max = BackpackHelper.getBackpackBarIDRange(BACKPACK_TYPE.EQUIP)
  for i = min, max do
    local itemid, num = BackpackHelper.getGridItemID(objid, i)
    if (itemid and itemid ~= 0) then
      local gridid = BackpackHelper.getFirstEmptyGridByBartype(objid, BACKPACK_TYPE.INVENTORY)
      if (gridid) then
        BackpackHelper.moveGridItem(objid, i, gridid)
      end
    end
  end
end

function SaveGame:showDataNum (objid)
  if (PlayerHelper.isMainPlayer(objid)) then
    local mainIndex = StoryHelper.getMainStoryIndex()
    local mainProgress = StoryHelper.getMainStoryProgress()
    ChatHelper.sendMsg(objid, '#G游戏数据A#n与#G游戏数据B#n的数量应分别是#G',
      StringHelper.int2Chinese(mainIndex), '#n、#G', StringHelper.int2Chinese(mainProgress),
      '#n，请确保数量正确')
  end
end

function SaveGame:useItem (objid)
  -- if (not(PlayerHelper.isMainPlayer(objid))) then -- 不是房主
  --   ChatHelper.sendMsg(objid, '该道具仅房主使用有效')
  --   return
  -- end

  -- 判断剧情是否加载
  if (not(StoryHelper.isLoad())) then
    ChatHelper.sendMsg(objid, '当前剧情未加载，无法保存')
    return
  end

  -- 检测附近是否有储物箱
  local pos = ActorHelper.getMyPosition(objid)
  pos.x, pos.y, pos.z = math.floor(pos.x), math.floor(pos.y), math.floor(pos.z)
  local positions = AreaHelper.getBlockPositionsAround(pos, { x = 5, y = 5, z = 5 }, self.blockid)
  if (#positions > 0) then
    PlayerHelper.openBoxByPos(objid, positions[1].x, positions[1].y, positions[1].z)
    ChatHelper.sendMsg(objid, '附近发现储物箱')
    SaveGame:showDataNum(objid)
    return
  end

  -- 创建储物箱
  local offsets = {}
  local x, y, z = ActorHelper.getFaceDirection(objid)
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
  if (not(AreaHelper.isAirArea(dstPos))) then
    dstPos = MyPosition:new(pos.x + offsets[2][1], pos.y, pos.z + offsets[2][2])
    if (not(AreaHelper.isAirArea(dstPos))) then
      self:createError()
      return
    end
  end
  local result1 = WorldContainerHelper.addStorageBox(dstPos.x, dstPos.y, dstPos.z)
  if (not(result1)) then
    self:createError()
    return
  end
  local result2 = WorldContainerHelper.addStorageBox(dstPos.x, dstPos.y + 1, dstPos.z)
  if (not(result2)) then
    self:createError()
    return
  end
  -- 创建成功
  PlayerHelper.openBoxByPos(objid, math.floor(dstPos.x), math.floor(dstPos.y), math.floor(dstPos.z))
  SaveGame:putInItem(objid, dstPos)
  SaveGame:putInItem(objid, dstPos, BACKPACK_TYPE.EQUIP)
  SaveGame:putInItem(objid, MyPosition:new(dstPos.x, dstPos.y + 1, dstPos.z), BACKPACK_TYPE.INVENTORY)
  SaveGame:takeOffEquip(objid)
  SaveGame:showDataNum(objid)
end

-- 加载进度
LoadGame = BaseItem:new({
  id = MyMap.ITEM.LOAD_GAME_ID,
})

function LoadGame:useError (objid)
  ChatHelper.sendMsg(objid, '该道具仅房主使用有效')
end

function LoadGame:itemLostError (objid, name)
  ChatHelper.sendMsg(objid, '加载错误：#G游戏数据', name, '#n遗失，请找到后重新加载')
end

function LoadGame:loadOver (objid)
  ChatHelper.sendMsg(objid, '游戏加载完成')
end

-- 检测游戏数据
function LoadGame:checkData (objid, numA, numB)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if (mainIndex == numA and mainProgress == numB) then
    if (GameDataHelper.updateMainIndex() and GameDataHelper.updateMainProgress()) then
      ChatHelper.sendMsg(objid, '剧情已加载过，游戏数据正常')
    else
      ChatHelper.sendMsg(objid, '剧情已加载过，游戏数据调整失败')
    end
  else
    if (GameDataHelper.updateMainIndex() and GameDataHelper.updateMainProgress()) then
      ChatHelper.sendMsg(objid, '剧情已加载过，游戏数据调整正常')
    else
      ChatHelper.sendMsg(objid, '剧情已加载过，游戏数据调整失败')
    end
  end
end

function LoadGame:useItem (objid)
  if (PlayerHelper.isMainPlayer(objid)) then -- 房主
    local numA = BackpackHelper.getItemNumAndGrid(objid, MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID)
    local numB = BackpackHelper.getItemNumAndGrid(objid, MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID)
    if (StoryHelper.isLoad()) then
      self:checkData(objid, numA, numB)
    else
      if (not(numA) or numA == 0) then
        self:itemLostError(objid, 'A')
        return
      end
      if (not(numB) or numB == 0) then
        self:itemLostError(objid, 'B')
        return
      end
      -- 数据存在，则开始加载
      local player = PlayerHelper.getPlayer(objid)
      GameDataHelper.updateStoryData()
      if (StoryHelper.recover(player)) then -- 恢复剧情
        -- self:loadOver(objid)
      end
    end
  else -- 其他玩家
    self:useError(objid)
  end
end

-- 守护宝石
ProtectGem = BaseItem:new({ id = MyMap.ITEM.PROTECT_GEM_ID })

function ProtectGem:useItem (objid)
  if (ActorHelper.hasBuff(objid, MyMap.BUFF.PROTECT_ID)) then -- 有守护状态
    ActorHelper.removeBuff(objid, MyMap.BUFF.PROTECT_ID)
  else -- 没有
    ActorHelper.addBuff(objid, MyMap.BUFF.PROTECT_ID, 1)
  end
end

-- 生物蛋
Egg = BaseItem:new()

-- function Egg:new (o)
--   o = o or {}
--   if (o.id) then
--     ItemHelper.register(o)
--   end
--   self.__index = self
--   setmetatable(o, self)
--   return o
-- end

function Egg:selectItem (objid, index)
  local itemid = self:getItemid(index)
  if (itemid) then
    ChatHelper.sendMsg(objid, '使用将获得', ItemHelper.getItemName(itemid))
  else
    ChatHelper.sendMsg(objid, '无对应生物')
  end
end

function Egg:useItem (objid)
  local index = PlayerHelper.getCurShotcut(objid)
  local itemid = self:getItemid(index)
  if (itemid) then
    if (BackpackHelper.addItem(objid, itemid, 1)) then
      BackpackHelper.removeGridItemByItemID(objid, self.id, 1)
    end
  else
    ChatHelper.sendMsg(objid, '无对应生物')
  end
end

-- 落叶村生物蛋
Egg1 = Egg:new({ id = MyMap.ITEM.EGG1_ID })

function Egg1:getItemid (index)
  if (index == 0) then
    return MyMap.ITEM.YANGWANLI_EGG_ID
  elseif (index == 1) then
    return MyMap.ITEM.WANGDALI_EGG_ID
  elseif (index == 2) then
    return MyMap.ITEM.MIAOLAN_EGG_ID
  elseif (index == 3) then
    return MyMap.ITEM.HUAXIAOLOU_EGG_ID
  elseif (index == 4) then
    return MyMap.ITEM.JIANGFENG_EGG_ID
  elseif (index == 5) then
    return MyMap.ITEM.JIANGYU_EGG_ID
  elseif (index == 6) then
    return MyMap.ITEM.WENYU_EGG_ID
  else
    return nil
  end
end

-- 风颖城生物蛋甲
Egg2 = Egg:new({ id = MyMap.ITEM.EGG2_ID })

function Egg2:getItemid (index)
  if (index == 0) then
    return MyMap.ITEM.LUDAOFENG_EGG_ID
  elseif (index == 1) then
    return MyMap.ITEM.QIANBINGWEI_EGG_ID
  elseif (index == 2) then
    return MyMap.ITEM.YEXIAOLONG_EGG_ID
  elseif (index == 3) then
    return MyMap.ITEM.GAOXIAOHU_EGG_ID
  elseif (index == 4) then
    return MyMap.ITEM.JIANGHUO_EGG_ID
  elseif (index == 5) then
    return MyMap.ITEM.YUEWUSHUANG_EGG_ID
  elseif (index == 6) then
    return MyMap.ITEM.SUNKONGWU_EGG_ID
  else
    return MyMap.ITEM.LIMIAOSHOU_EGG_ID
  end
end

-- 风颖城生物蛋乙
Egg3 = Egg:new({ id = MyMap.ITEM.EGG3_ID })

function Egg3:getItemid (index)
  if (index == 0) then
    return MyMap.ITEM.MURONGXIAOTIAN_EGG_ID
  elseif (index == 1) then
    return MyMap.ITEM.QIANDUO_EGG_ID
  elseif (index == 2) then
    return MyMap.ITEM.DANIU_EGG_ID
  elseif (index == 3) then
    return MyMap.ITEM.ERNIU_EGG_ID
  else
    return nil
  end
end

-- 任务道具

-- 任务书
MissionBook = BaseItem:new()

function MissionBook:useItem (objid)
  local player = PlayerHelper.getPlayer(objid)
  local task = TaskHelper.getTask(objid, self.cTask:getRealid())
  if (not(task)) then -- 如果任务不存在
    task = TaskHelper.addTask(objid, self.cTask:realTask())
  end
  if (player.showTaskPos) then
    task:close(objid)
  else
    task:show(objid, true)
  end
end

-- 砍树（采集落叶松木）任务书
MissionKanshu = MissionBook:new({
  id = MyMap.ITEM.MISSION_KANSHU,
  cTask = KanshuTask,
})

-- 杀狗（消灭野狗）任务书
MissionXiaomieyegou = MissionBook:new({
  id = MyMap.ITEM.MISSION_XIAOMIEYEGOU,
  cTask = XiaomieyegouTask,
})

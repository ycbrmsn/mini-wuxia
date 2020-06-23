-- 游戏数据工具类
GameDataHelper = {}

-- 更新剧情数据
function GameDataHelper:updateStoryData ()
  local player = MyPlayerHelper:getHostPlayer()
  local mainIndex = BackpackHelper:getItemNumAndGrid(player.objid, MyConstant.ITEM.GAME_DATA_MAIN_INDEX_ID)
  local mainProgress = BackpackHelper:getItemNumAndGrid(player.objid, MyConstant.ITEM.GAME_DATA_MAIN_PROGRESS_ID)
  if (mainIndex == 0) then -- 游戏刚开始
    self:updateMainIndex()
    self:updateMainProgress()
    return false
  else -- 再次回到游戏
    MyStoryHelper.mainIndex = mainIndex
    MyStoryHelper.mainProgress = mainProgress
    return true
  end
end

-- 更新玩家数据
function GameDataHelper:updatePlayerData (player)
  local totalLevel = BackpackHelper:getItemNumAndGrid(player.objid, MyConstant.ITEM.GAME_DATA_LEVEL_ID)
  local exp = (totalLevel - 1) * 100 + 
      BackpackHelper:getItemNumAndGrid(player.objid, MyConstant.ITEM.GAME_DATA_EXP_ID)
  if (totalLevel == 0) then -- 刚进入游戏
    self:updateLevel(player)
    self:updateExp(player)
    return false
  else -- 再次回到游戏
    player.totalLevel = totalLevel
    player.exp = exp
    return true
  end
end

-- 更新主线剧情序号道具
function GameDataHelper:updateMainIndex ()
  local player = MyPlayerHelper:getHostPlayer()
  local itemid = MyConstant.ITEM.GAME_DATA_MAIN_INDEX_ID
  local gridid = 26
  self:discardOtherItem(player.objid, gridid)
  BackpackHelper:removeGridItemByItemID(player.objid, itemid)
  BackpackHelper:setGridItem(player.objid, gridid, itemid, MyStoryHelper.mainIndex)
  PlayerHelper:setItemDisableThrow(player.objid, itemid)
end

-- 更新主线剧情进度道具
function GameDataHelper:updateMainProgress ()
  local player = MyPlayerHelper:getHostPlayer()
  local itemid = MyConstant.ITEM.GAME_DATA_MAIN_PROGRESS_ID
  local gridid = 27
  self:discardOtherItem(player.objid, gridid)
  BackpackHelper:removeGridItemByItemID(player.objid, itemid)
  BackpackHelper:setGridItem(player.objid, gridid, itemid, MyStoryHelper.mainProgress)
  PlayerHelper:setItemDisableThrow(player.objid, itemid)
end

-- 更新玩家等级道具
function GameDataHelper:updateLevel (player)
  local itemid = MyConstant.ITEM.GAME_DATA_LEVEL_ID
  local gridid = 28
  self:discardOtherItem(player.objid, gridid)
  BackpackHelper:removeGridItemByItemID(player.objid, itemid)
  BackpackHelper:setGridItem(player.objid, gridid, itemid, player.totalLevel)
  PlayerHelper:setItemDisableThrow(player.objid, itemid)
end

-- 更新玩家经验道具
function GameDataHelper:updateExp (player)
  local itemid = MyConstant.ITEM.GAME_DATA_EXP_ID
  local gridid = 29
  self:discardOtherItem(player.objid, gridid)
  BackpackHelper:removeGridItemByItemID(player.objid, itemid)
  local num = player.exp % 100
  if (num ~= 0) then -- 不为0时添加道具
    BackpackHelper:setGridItem(player.objid, gridid, itemid, num)
    PlayerHelper:setItemDisableThrow(player.objid, itemid)
  end
end

-- 丢弃非游戏数据道具
function GameDataHelper:discardOtherItem (playerid, gridid)
  local itemid = BackpackHelper:getGridItemID(playerid, gridid)
  if (itemid ~= MyConstant.ITEM.GAME_DATA_MAIN_INDEX_ID and 
    itemid ~= MyConstant.ITEM.GAME_DATA_MAIN_PROGRESS_ID and 
    itemid ~= MyConstant.ITEM.GAME_DATA_LEVEL_ID and 
    itemid ~= MyConstant.ITEM.GAME_DATA_EXP_ID) then
    BackpackHelper:discardItem(playerid, gridid, 99)
  end
end

-- 更新游戏数据道具
function GameDataHelper:updateGameData (player)
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  if (player == hostPlayer) then
    self:updateMainIndex()
    self:updateMainProgress()
  end
  self:updateLevel(player)
  self:updateExp(player)
end
-- 我的玩家工具类
MyPlayerHelper = {}

-- 事件

-- 玩家进入游戏
EventHelper.addEvent('playerEnterGame', function (objid)
  MusicHelper.startBGM(objid, 1, true)
  -- 如果有任务书，则自动接受任务
  for i, task in pairs(TaskHelper.needBookTasks) do
    if (BackpackHelper.hasItem(objid, task.itemid, true)) then -- 有任务书
      if (not(TaskHelper.hasTask (objid, task.id))) then -- 没有任务
        TaskHelper.addTask(objid, task) -- 接受任务
      end
    end
  end
  MyCustomUIHelper.init(objid) -- 初始化UI界面
end)

-- 玩家离开游戏
EventHelper.addEvent('playerLeaveGame', function (objid)
  MusicHelper.stopBGM(objid)
end)

-- 玩家进入区域
EventHelper.addEvent('playerEnterArea', function (objid, areaid)
  if (guard and guard:checkTokenArea(objid, areaid)) then -- 检查通行令牌
  end
end)

-- 玩家点击方块
EventHelper.addEvent('playerClickBlock', function (objid, blockid, x, y, z)
  if (MyBlockHelper.clickBed(objid, blockid, x, y, z)) then
  elseif (MyBlockHelper.checkCityGateSwitch(blockid, MyPosition:new(x, y, z))) then
  elseif (blockid == SaveGame.blockid) then -- 储物箱
    local itemid = PlayerHelper.getCurToolID(objid)
    if (itemid and itemid == MyMap.ITEM.SAVE_GAME_ID) then -- 手持保存游戏道具将删除储物箱
      WorldContainerHelper.removeStorageBox(math.floor(x), math.floor(y), math.floor(z))
    end
  elseif (MyBlockHelper.clickBookcase(objid, blockid, x, y, z)) then -- 书柜说明
  end
end)

-- 玩家点击生物
EventHelper.addEvent('playerClickActor', function (objid, toobjid)
  -- if (SkillHelper.isFlying(toobjid)) then
  --   SkillHelper.stopFly(toobjid)
  -- else
  --   SkillHelper.flyStatic(toobjid)
  -- end
  -- if (ActorHelper.hasBuff(objid, MyMap.BUFF.SEAL_ID)) then
  --   ActorHelper.removeBuff(objid, MyMap.BUFF.SEAL_ID)
  -- else
  --   ActorHelper.addBuff(objid, MyMap.BUFF.SEAL_ID, 1)
  -- end
  -- if (ActorHelper.hasBuff(objid, MyMap.BUFF.IMPRISON_ID)) then
  --   ActorHelper.removeBuff(objid, MyMap.BUFF.IMPRISON_ID)
  -- else
  --   ActorHelper.addBuff(objid, MyMap.BUFF.IMPRISON_ID, 1)
  -- end
end)

-- 玩家获得道具
EventHelper.addEvent('playerAddItem', function (objid, itemid, itemnum)
  local player = PlayerHelper.getPlayer(objid)
  if (itemid == MyMap.ITEM.GAME_DATA_JIANGHUO_EXP_ID) then -- 江火的经验
    player:gainExp(500)
    BackpackHelper.removeGridItemByItemID(objid, itemid, itemnum) -- 销毁
  end
end)

-- 玩家使用道具
EventHelper.addEvent('playerUseItem', function (objid, toobjid, itemid, itemnum)
  if (itemid == MyMap.ITEM.MUSIC_PLAYER_ID) then -- 音乐播放器
    local index = PlayerHelper.getCurShotcut(objid)
    if (index == 3) then -- 加速
      MusicHelper.changeSpeed (objid, 1)
    elseif (index == 4) then -- 减速
      MusicHelper.changeSpeed (objid, -1)
    elseif (index == 5) then -- 调大声音
      MusicHelper.modulateVolume(objid, 1)
    elseif (index == 6) then -- 调小声音
      MusicHelper.modulateVolume(objid, -1)
    elseif (index == 7) then -- 重置音乐选项
      MusicHelper.changeBGM(objid, 1, true, true)
      ChatHelper.sendMsg(objid, '音乐、音量及播放速度重置完成')
    else
      ChatHelper.sendMsg(objid, '当前处于快捷栏第', index + 1, '格，暂无对应功能')
    end
  end
end)

-- 玩家消耗道具
EventHelper.addEvent('playerConsumeItem', function (objid, toobjid, itemid, itemnum)
  if (itemid == MyMap.ITEM.WINE_ID) then -- 最香酒
    ActorHelper.addBuff(objid, 17, 2, 3600)
    ActorHelper.addBuff(objid, 18, 2, 3600)
  elseif (itemid == MyMap.ITEM.FASTER_RUN_PILL1_ID) then -- 速行丸
    ActorHelper.addBuff(objid, ActorHelper.BUFF.FASTER_RUN, 1, 3600)
  elseif (itemid == MyMap.ITEM.FASTER_RUN_PILL2_ID) then -- 疾行丸
    ActorHelper.addBuff(objid, ActorHelper.BUFF.FASTER_RUN, 2, 3600)
  elseif (itemid == MyMap.ITEM.FASTER_RUN_PILL3_ID) then -- 神行丸
    ActorHelper.addBuff(objid, ActorHelper.BUFF.FASTER_RUN, 3, 3600)
  end
end)

-- 玩家死亡
EventHelper.addEvent('playerDie', function (objid, toobjid)
  local num = BackpackHelper.getItemNumAndGrid(objid, MyMap.ITEM.PROTECT_GEM_ID) -- 守护宝石数量
  if (num > 0) then
    if (ActorHelper.hasBuff(objid, MyMap.BUFF.PROTECT_ID)) then -- 有守护状态
      if (BackpackHelper.removeGridItemByItemID(objid, MyMap.ITEM.PROTECT_GEM_ID, 1)) then -- 移除一颗宝石
        local pos = ActorHelper.getMyPosition(objid)
        PlayerHelper.reviveToPos(objid, pos.x, pos.y, pos.z)
        return
      end
    end
  end
  -- 不满足条件则根据剧情移动到对应位置
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if (mainIndex == 1 or mainIndex == 2) then
    local pos = MyStoryHelper.initPosition
    PlayerHelper.reviveToPos(objid, pos.x, pos.y, pos.z)
    ActorHelper.setMyPosition(objid, pos)
  elseif (mainIndex == 3) then
    local pos = MyStoryHelper.initPosition3
    PlayerHelper.reviveToPos(objid, pos.x, pos.y, pos.z)
  end
  -- if (num == 0) then -- 玩家没有守护宝石
    -- if (PlayerHelper.isMainPlayer(objid)) then -- 房主
    --   -- 等待其他事件的一些取值得到后结束游戏
    --   TimeHelper.callFnFastRuns(function ()
    --     local player = PlayerHelper.getPlayer(objid)
    --     if (player.beatBy) then
    --       player.finalBeatBy = player.beatBy
    --     end
    --     GameHelper.doGameEnd()
    --     -- PlayerHelper.setGameWin(objid)
    --   end, 0.1)
    -- else -- 其他玩家
    --   BackpackHelper.clearAllPack(objid)
    -- end
  -- end
end)

-- 玩家复活
EventHelper.addEvent('playerRevive', function (objid, toobjid)
  local player = PlayerHelper.getPlayer(objid)
  player:init()
  local num = BackpackHelper.getItemNumAndGrid(objid, MyMap.ITEM.PROTECT_GEM_ID) -- 守护宝石数量
  if (not(num) or num == 0) then
    if (ActorHelper.hasBuff(objid, MyMap.BUFF.PROTECT_ID)) then -- 有守护状态
      ActorHelper.removeBuff(objid, MyMap.BUFF.PROTECT_ID) -- 移除
    end
  end
end)

-- 属性变化
-- EventHelper.addEvent('playerChangeAttr', function (objid, playerattr)
--   if (playerattr == PLAYERATTR.CUR_HP) then
--     ActorHelper.updateHp(objid, 130) -- 显示生命
--   end
-- end)

-- 玩家获得状态效果
EventHelper.addEvent('playerAddBuff', function (objid, buffid, bufflvl)
  local player = PlayerHelper.getPlayer(objid)
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    player:setSeal(true)
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    player:setImprisoned(true)
  end
end)

-- 玩家失去状态效果
EventHelper.addEvent('playerRemoveBuff', function (objid, buffid, bufflvl)
  local player = PlayerHelper.getPlayer(objid)
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    player:setSeal(false)
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    player:setImprisoned(false)
  end
end)

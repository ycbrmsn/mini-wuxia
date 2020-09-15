-- 我的玩家工具类
MyPlayerHelper = {}

-- 事件

-- 玩家进入游戏
function MyPlayerHelper:playerEnterGame (objid)
  local isEntered = PlayerHelper:playerEnterGame(objid)
  MyStoryHelper:playerEnterGame(objid)
  -- body
  if (not(logPaper)) then
    logPaper = LogPaper:new()
  end
  -- 检测玩家是否有江湖日志，如果没有则放进背包
  if (not(logPaper:hasItem(objid))) then
    logPaper:newItem(objid, 1, true)
  end
  if (not(isEntered)) then -- 没有进入过游戏，则给一颗守护宝石
    BackpackHelper:addItem(objid, MyMap.ITEM.PROTECT_GEM_ID, 1)
  end
end

-- 玩家离开游戏
function MyPlayerHelper:playerLeaveGame (objid)
  PlayerHelper:playerLeaveGame(objid)
  MyStoryHelper:playerLeaveGame(objid)
  MusicHelper:stopBGM(objid)
end

-- 玩家进入区域
function MyPlayerHelper:playerEnterArea (objid, areaid)
  PlayerHelper:playerEnterArea(objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  -- body
  if (guard and guard:checkTokenArea(objid, areaid)) then -- 检查通行令牌
  end
end

-- 玩家离开区域
function MyPlayerHelper:playerLeaveArea (objid, areaid)
  PlayerHelper:playerLeaveArea(objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

-- 玩家点击方块
function MyPlayerHelper:playerClickBlock (objid, blockid, x, y, z)
  PlayerHelper:playerClickBlock(objid, blockid, x, y, z)
  MyStoryHelper:playerClickBlock(objid, blockid, x, y, z)
  -- body
  if (MyBed:isBed(blockid)) then
    -- 处理床
    PlayerHelper:showToast(objid, '你无法在别人的床上睡觉')
  elseif (MyBlockHelper:checkCityGateSwitch(blockid, MyPosition:new(x, y, z))) then
  end
end

-- 玩家点击生物
function MyPlayerHelper:playerClickActor (objid, toobjid)
  PlayerHelper:playerClickActor(objid, toobjid)
  MyStoryHelper:playerClickActor(objid, toobjid)
end

-- 玩家获得道具
function MyPlayerHelper:playerAddItem (objid, itemid, itemnum)
  PlayerHelper:playerAddItem(objid, itemid, itemnum)
  MyStoryHelper:playerAddItem(objid, itemid, itemnum)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  if (itemid == MyMap.ITEM.GAME_DATA_JIANGHUO_EXP_ID) then -- 江火的经验
    player:gainExp(500)
    BackpackHelper:removeGridItemByItemID(objid, itemid, itemnum) -- 销毁
  end
end

-- 玩家使用道具
function MyPlayerHelper:playerUseItem (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerUseItem(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerUseItem(objid, toobjid, itemid, itemnum)
end

-- 玩家攻击命中
function MyPlayerHelper:playerAttackHit (objid, toobjid)
  PlayerHelper:playerAttackHit(objid, toobjid)
  MyStoryHelper:playerAttackHit(objid, toobjid)
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid, hurtlv)
  PlayerHelper:playerDamageActor(objid, toobjid, hurtlv)
  MyStoryHelper:playerDamageActor(objid, toobjid, hurtlv)
end

-- 玩家击败目标
function MyPlayerHelper:playerDefeatActor (objid, toobjid)
  local realDefeat = PlayerHelper:playerDefeatActor(objid, toobjid)
  MyStoryHelper:playerDefeatActor(objid, toobjid)
  -- body
end

-- 玩家受到伤害
function MyPlayerHelper:playerBeHurt (objid, toobjid, hurtlv)
  PlayerHelper:playerBeHurt(objid, toobjid, hurtlv)
  MyStoryHelper:playerBeHurt(objid, toobjid, hurtlv)
  -- body
end

-- 玩家死亡
function MyPlayerHelper:playerDie (objid, toobjid)
  PlayerHelper:playerDie(objid, toobjid)
  MyStoryHelper:playerDie(objid, toobjid)
  -- body
  local num = BackpackHelper:getItemNumAndGrid(objid, MyMap.ITEM.PROTECT_GEM_ID) -- 守护宝石数量
  if (num == 0) then -- 玩家没有守护宝石
    if (PlayerHelper:isMainPlayer(objid)) then -- 房主
      -- 等待其他事件的一些取值得到后结束游戏
      TimeHelper:callFnFastRuns(function ()
        local player = PlayerHelper:getPlayer(objid)
        if (player.beatBy) then
          player.finalBeatBy = player.beatBy
        end
        -- PlayerHelper:setGameResults(objid, 2) -- 游戏结束
        PlayerHelper:setGameWin(objid)
      end, 1)
    else -- 其他玩家
      BackpackHelper:clearAllPack(objid)
      logPaper:newItem(objid, 1, true)
    end
  else
    BackpackHelper:removeGridItemByItemID(objid, MyMap.ITEM.PROTECT_GEM_ID, 1) -- 移除一颗宝石
  end
end

-- 玩家复活
function MyPlayerHelper:playerRevive (objid, toobjid)
  PlayerHelper:playerRevive(objid, toobjid)
  MyStoryHelper:playerRevive(objid, toobjid)
  -- body
end

-- 玩家选择快捷栏
function MyPlayerHelper:playerSelectShortcut (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerSelectShortcut(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerSelectShortcut(objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家快捷栏变化
function MyPlayerHelper:playerShortcutChange (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerShortcutChange(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerShortcutChange(objid, toobjid, itemid, itemnum)
end

-- 玩家运动状态改变
function MyPlayerHelper:playerMotionStateChange (objid, playermotion)
  PlayerHelper:playerMotionStateChange(objid, playermotion)
  MyStoryHelper:playerMotionStateChange(objid, playermotion)
  -- body
end

-- 玩家移动一格
function MyPlayerHelper:playerMoveOneBlockSize (objid)
  PlayerHelper:playerMoveOneBlockSize(objid)
  MyStoryHelper:playerMoveOneBlockSize(objid)
  -- body
end

-- 玩家骑乘
function MyPlayerHelper:playerMountActor (objid, toobjid)
  PlayerHelper:playerMountActor(objid, toobjid)
  MyStoryHelper:playerMountActor(objid, toobjid)
end

-- 玩家取消骑乘
function MyPlayerHelper:playerDismountActor (objid, toobjid)
  PlayerHelper:playerDismountActor(objid, toobjid)
  MyStoryHelper:playerDismountActor(objid, toobjid)
end

-- 聊天输出界面变化
function MyPlayerHelper:playerInputContent (objid, content)
  PlayerHelper:playerInputContent(objid, content)
  MyStoryHelper:playerInputContent(objid, content)
end

-- 输入字符串
function MyPlayerHelper:playerNewInputContent (objid, content)
  PlayerHelper:playerNewInputContent(objid, content)
  MyStoryHelper:playerNewInputContent(objid, content)
end

-- 按键被按下
function MyPlayerHelper:playerInputKeyDown (objid, vkey)
  PlayerHelper:playerInputKeyDown(objid, vkey)
  MyStoryHelper:playerInputKeyDown(objid, vkey)
  -- body
end

-- 按键处于按下状态
function MyPlayerHelper:playerInputKeyOnPress (objid, vkey)
  PlayerHelper:playerInputKeyOnPress(objid, vkey)
  MyStoryHelper:playerInputKeyOnPress(objid, vkey)
  -- body
end

-- 按键松开
function MyPlayerHelper:playerInputKeyUp (objid, vkey)
  PlayerHelper:playerInputKeyUp(objid, vkey)
  MyStoryHelper:playerInputKeyUp(objid, vkey)
  -- body
end

-- 我的玩家工具类
MyPlayerHelper = {
  chooseMap = {
    readme = {
      [1] = function (player)
        ChatHelper:showChooseItems(playerid, { '游戏简介', '更新内容', '退出' })
        player.whichChoose = 'readme1'
      end,
      [2] = function (player)
        MyPlayerHelper:exitChoose(player)
      end, -- 退出
    },
    readme1 = {
      [1] = function (player)
        ChatHelper:sendMsg(player.objid, '\t\t这是一个简单的角色扮演类游戏，有')
        ChatHelper:sendMsg(player.objid, '几个简单的剧情。目前剧情还未做完，正')
        ChatHelper:sendMsg(player.objid, '常情况下月更。', StringHelper:repeatStrs('\t', 10))
        MyPlayerHelper.chooseMap.readme[1](player)
      end, -- 游戏简介
      [2] = function (player)
        ChatHelper:showChooseItems(playerid, { 'v0.3.4', '返回' })
        player.whichChoose = 'readmeUpdate'
      end, -- 更新内容
      [3] = function (player)
        MyPlayerHelper:exitChoose(player)
      end, -- 退出
    },
    readmeUpdate = {
      [1] = function (player)
        ChatHelper:sendMsg(player.objid, '1.新增叛军营地、橘山。', StringHelper:repeatStrs('\t', 7))
        ChatHelper:sendMsg(player.objid, '2.新增挖城墙事件。', StringHelper:repeatStrs('\t', 9))
        ChatHelper:sendMsg(player.objid, '3.调低了升级后玩家增长的属性。', StringHelper:repeatStrs('\t', 3))
        ChatHelper:sendMsg(player.objid, '4.调高了部分怪物的伤害。', StringHelper:repeatStrs('\t', 6))
        ChatHelper:sendMsg(player.objid, '5.修复车票无法送达的问题。', StringHelper:repeatStrs('\t', 5))
        ChatHelper:sendMsg(player.objid, '6.微调了一些其他东西。', StringHelper:repeatStrs('\t', 7))
        MyPlayerHelper.chooseMap.readme1[2](player)
      end, -- v0.3.4
      [2] = function (player)
        MyPlayerHelper.chooseMap.readme[1](player)
      end, -- 返回
    },
    breakCity = {
      [1] = function (player)
        player.whichChoose = nil
        local ws = WaitSeconds:new(2)
        player:speakSelf(0, '我愿意跟你走。')
        guard:speakTo(player.objid, ws:use(), '这样最好了。')
        TimeHelper:callFnAfterSecond(function ()
          local pos = MyAreaHelper:getEmptyPrisonPos()
          player:setMyPosition(pos)
          player:enableMove(true)
          WorldHelper:despawnActor(player.chooseMap.objid)
          for i, v in ipairs(player.destroyBlock) do
            BlockHelper:placeBlock(v.blockid, v.x, v.y, v.z)
          end
          player.destroyBlock = {}
        end, ws:get())
      end,
      [2] = function (player)
        player.whichChoose = nil
        local ws = WaitSeconds:new(2)
        player:speakSelf(0, '想让我跟你走，想都别想！')
        guard:speakTo(player.objid, ws:use(1), '那么抱歉了……')
        TimeHelper:callFnAfterSecond(function ()
          MyStoryHelper:beatBreakCityPlayer(player)
        end, ws:get())
      end,
    },
  },
}

-- 退出选择
function MyPlayerHelper:exitChoose (player)
  player.whichChoose = nil
  player:enableMove(true, true)
  player:thinkSelf(0, '算了，我都知道了。')
end

-- 事件

-- 玩家进入游戏
function MyPlayerHelper:playerEnterGame (objid)
  local isEntered = PlayerHelper:playerEnterGame(objid)
  MyStoryHelper:playerEnterGame(objid)
  -- body
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
  elseif (blockid == SaveGame.blockid) then -- 储物箱
    local itemid = PlayerHelper:getCurToolID(objid)
    if (itemid and itemid == MyMap.ITEM.SAVE_GAME_ID) then -- 手持保存游戏道具将删除储物箱
      WorldContainerHelper:removeStorageBox(math.floor(x), math.floor(y), math.floor(z))
    end
  elseif (MyBlockHelper:clickBookcase(objid, blockid, x, y, z)) then -- 书柜说明
  end
end

-- 玩家点击生物
function MyPlayerHelper:playerClickActor (objid, toobjid)
  PlayerHelper:playerClickActor(objid, toobjid)
  MyStoryHelper:playerClickActor(objid, toobjid)
  -- body
  -- if (SkillHelper:isFlying(toobjid)) then
  --   SkillHelper:stopFly(toobjid)
  -- else
  --   SkillHelper:flyStatic(toobjid)
  -- end
  -- if (ActorHelper:hasBuff(objid, MyMap.BUFF.SEAL_ID)) then
  --   ActorHelper:removeBuff(objid, MyMap.BUFF.SEAL_ID)
  -- else
  --   ActorHelper:addBuff(objid, MyMap.BUFF.SEAL_ID, 1)
  -- end
  -- if (ActorHelper:hasBuff(objid, MyMap.BUFF.IMPRISON_ID)) then
  --   ActorHelper:removeBuff(objid, MyMap.BUFF.IMPRISON_ID)
  -- else
  --   ActorHelper:addBuff(objid, MyMap.BUFF.IMPRISON_ID, 1)
  -- end
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
  -- body
  if (itemid == MyMap.ITEM.MUSIC_PLAYER_ID) then -- 音乐播放器
    local index = PlayerHelper:getCurShotcut(objid)
    if (index == 3) then -- 加速
      MusicHelper:changeSpeed (objid, 1)
    elseif (index == 4) then -- 减速
      MusicHelper:changeSpeed (objid, -1)
    elseif (index == 5) then -- 调大声音
      MusicHelper:modulateVolume(objid, 1)
    elseif (index == 6) then -- 调小声音
      MusicHelper:modulateVolume(objid, -1)
    elseif (index == 7) then -- 重置音乐选项
      MusicHelper:changeBGM(objid, 1, true, true)
      ChatHelper:sendMsg(objid, '音乐、音量及播放速度重置完成')
    else
      ChatHelper:sendMsg(objid, '当前处于快捷栏第', index + 1, '格，暂无对应功能')
    end
  end
end

-- 玩家消耗道具
function MyPlayerHelper:playerConsumeItem (objid, toobjid, itemid, itemnum)
  PlayerHelper:playerConsumeItem(objid, toobjid, itemid, itemnum)
  MyStoryHelper:playerConsumeItem(objid, toobjid, itemid, itemnum)
  -- body
  if (itemid == MyMap.ITEM.WINE_ID) then -- 最香酒
    ActorHelper:addBuff(objid, 17, 2, 3600)
    ActorHelper:addBuff(objid, 18, 2, 3600)
  elseif (itemid == MyMap.ITEM.FASTER_RUN_PILL1_ID) then -- 速行丸
    ActorHelper:addBuff(objid, ActorHelper.BUFF.FASTER_RUN, 1, 3600)
  elseif (itemid == MyMap.ITEM.FASTER_RUN_PILL2_ID) then -- 疾行丸
    ActorHelper:addBuff(objid, ActorHelper.BUFF.FASTER_RUN, 2, 3600)
  elseif (itemid == MyMap.ITEM.FASTER_RUN_PILL3_ID) then -- 神行丸
    ActorHelper:addBuff(objid, ActorHelper.BUFF.FASTER_RUN, 3, 3600)
  end
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
  if (num > 0) then
    if (ActorHelper:hasBuff(objid, MyMap.BUFF.PROTECT_ID)) then -- 有守护状态
      if (BackpackHelper:removeGridItemByItemID(objid, MyMap.ITEM.PROTECT_GEM_ID, 1)) then -- 移除一颗宝石
        local pos = ActorHelper:getMyPosition(objid)
        PlayerHelper:reviveToPos(objid, pos.x, pos.y, pos.z)
        return
      end
    end
  end
  -- 不满足条件则根据剧情移动到对应位置
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 1 or mainIndex == 2) then
    local pos = MyStoryHelper.initPosition
    PlayerHelper:reviveToPos(objid, pos.x, pos.y, pos.z)
    ActorHelper:setMyPosition(objid, pos)
  elseif (mainIndex == 3) then
    local pos = MyStoryHelper.initPosition3
    PlayerHelper:reviveToPos(objid, pos.x, pos.y, pos.z)
  end
  -- if (num == 0) then -- 玩家没有守护宝石
    -- if (PlayerHelper:isMainPlayer(objid)) then -- 房主
    --   -- 等待其他事件的一些取值得到后结束游戏
    --   TimeHelper:callFnFastRuns(function ()
    --     local player = PlayerHelper:getPlayer(objid)
    --     if (player.beatBy) then
    --       player.finalBeatBy = player.beatBy
    --     end
    --     GameHelper:doGameEnd()
    --     -- PlayerHelper:setGameWin(objid)
    --   end, 0.1)
    -- else -- 其他玩家
    --   BackpackHelper:clearAllPack(objid)
    -- end
  -- end
end

-- 玩家复活
function MyPlayerHelper:playerRevive (objid, toobjid)
  PlayerHelper:playerRevive(objid, toobjid)
  MyStoryHelper:playerRevive(objid, toobjid)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  player:init()
  local num = BackpackHelper:getItemNumAndGrid(objid, MyMap.ITEM.PROTECT_GEM_ID) -- 守护宝石数量
  if (not(num) or num == 0) then
    if (ActorHelper:hasBuff(objid, MyMap.BUFF.PROTECT_ID)) then -- 有守护状态
      ActorHelper:removeBuff(objid, MyMap.BUFF.PROTECT_ID) -- 移除
    end
  end
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

-- 等级发生改变
function MyPlayerHelper:playerLevelModelUpgrade (objid, toobjid)
  PlayerHelper:playerLevelModelUpgrade(objid, toobjid)
  MyStoryHelper:playerLevelModelUpgrade(objid, toobjid)
  -- body
end

-- 属性变化
function MyPlayerHelper:playerChangeAttr (objid, playerattr)
  PlayerHelper:playerChangeAttr(objid, playerattr)
  MyStoryHelper:playerChangeAttr(objid, playerattr)
  -- body
end

-- 玩家获得状态效果
function MyPlayerHelper:playerAddBuff (objid, buffid, bufflvl)
  PlayerHelper:playerAddBuff(objid, buffid, bufflvl)
  MyStoryHelper:playerAddBuff(objid, buffid, bufflvl)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    player:setSeal(true)
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    player:setImprisoned(true)
  end
end

-- 玩家失去状态效果
function MyPlayerHelper:playerRemoveBuff (objid, buffid, bufflvl)
  PlayerHelper:playerRemoveBuff(objid, buffid, bufflvl)
  MyStoryHelper:playerRemoveBuff(objid, buffid, bufflvl)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  if (buffid == MyMap.BUFF.SEAL_ID) then -- 封魔
    player:setSeal(false)
  elseif (buffid == MyMap.BUFF.IMPRISON_ID) then -- 慑魂
    player:setImprisoned(false)
  end
end
-- 我的剧情工具类
MyStoryHelper = {
  initWoodPos = MyPosition:new(31, 5, 10), -- 游戏开始时的一个标志木头位置
  woodid = 201,
  initPosition = MyPosition:new(29.5, 9.5, 7.5),
  initPosition3 = MyPosition:new(19.5, 8.5, 605.5),
}

function MyStoryHelper:init ()
  story1 = Story1:new()
  story2 = Story2:new()
  story3 = Story3:new()
  StoryHelper:setStorys({ story1, story2, story3 })
end

function MyStoryHelper:replaceInitBlock (pos)
  if (not(BlockHelper:replaceBlock(200, pos.x, pos.y, pos.z))) then
    TimeHelper:callFnAfterSecond(function ()
      MyStoryHelper:replaceInitBlock(pos)
    end, 1)
  end
end

-- 事件

-- 世界时间到[n]点
function MyStoryHelper:atHour (hour)
  StoryHelper:atHour(hour)
  -- body
  if (hour == 0) then
    StoryHelper:forward(1, '明日出发')
  elseif (hour == 9) then
    -- LogHelper:debug(StoryHelper:getMainStoryIndex(), '-', StoryHelper:getMainStoryProgress(), '-', #story1.tips)
    -- if (StoryHelper:getMainStoryIndex() == 1 and StoryHelper:getMainStoryProgress() == #story1.tips) then
    if (StoryHelper:forward(1, '今日出发')) then
      story2:goToCollege()
    end
  end
end

-- 玩家进入游戏
function MyStoryHelper:playerEnterGame (objid)
  -- body
  local player = PlayerHelper:getPlayer(objid)
  if (PlayerHelper:isMainPlayer(objid)) then -- 本地玩家
    if (not(GameDataHelper:updateStoryData())) then -- 未找到游戏数据文件
      -- 判断是否刚进入游戏，等待1s后检测
      TimeHelper:callFnAfterSecond(function ()
        local blockid = BlockHelper:getBlockID(self.initWoodPos.x, self.initWoodPos.y, self.initWoodPos.z)
        if (blockid and blockid == self.woodid) then -- 刚进入游戏
          GameDataHelper:updateMainIndex()
          GameDataHelper:updateMainProgress()
          StoryHelper:setLoad(true)
          TimeHelper:setHour(MyMap.CUSTOM.INIT_HOUR)
          player:setPosition(self.initPosition) -- 初始位置
          PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.NORTH, 0)
          if (not(LogPaper:hasItem(objid))) then -- 没有江湖日志
            LogPaper:newItem(objid, 1, true) -- 江湖日志
            BackpackHelper:addItem(objid, MyMap.ITEM.PROTECT_GEM_ID, 1) -- 给房主一颗守护宝石
            SaveGame:newItem(objid, 1, true) -- 保存游戏
            LoadGame:newItem(objid, 1, true) -- 加载进度
          end
          -- 3秒后替换掉初始方块
          TimeHelper:callFnAfterSecond(function ()
            MyStoryHelper:replaceInitBlock(self.initWoodPos)
          end, 3)
        else -- 再次进入游戏
          TimeHelper:callFnAfterSecond(function ()
            StoryHelper:loadTip(objid)
          end, 2)
        end
        StoryHelper:recover() -- 初始化剧情
      end, 1)
    else -- 找到数据文件
      StoryHelper:recover(player) -- 恢复剧情
    end
  else -- 其他玩家
    local hostPlayer = PlayerHelper:getHostPlayer()
    if (hostPlayer) then
      player:setPosition(hostPlayer:getPosition())
    else -- 没有房主
      player:setPosition(self.initPosition) -- 初始位置
      PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.NORTH, 0)
    end
  end

  -- 播放背景音乐
  MusicHelper:startBGM(objid, 1, true)
end

-- 玩家离开游戏
function MyStoryHelper:playerLeaveGame (objid)
  -- body
end

-- 玩家进入区域
function MyStoryHelper:playerEnterArea (objid, areaid)
  -- body
  if (areaid == story1.areaid) then -- 文羽通知事件
    if (StoryHelper:check(1, '闲来无事')) then
      story1:noticeEvent(areaid)
      -- 玩家看文羽两秒
      local player = PlayerHelper:getPlayer(objid)
      TimeHelper:callFnContinueRuns(function ()
        if (player:isActive()) then
          player:lookAt(wenyu.objid)
        end
      end, 2)
    end
  elseif (areaid == MyAreaHelper.playerInHomeAreaId) then -- 主角进入家中
    story1:fasterTime()
  elseif (story3 and areaid == story3.startArea) then -- 剧情三开启区域
    if (StoryHelper:forward(2, '临近风颖城')) then
      AreaHelper:destroyArea(areaid)
      story3:comeToCollege()
    end
  end
end

-- 玩家离开区域
function MyStoryHelper:playerLeaveArea (objid, areaid)
  -- body
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 2 and mainProgress == 4 and areaid == story2.areaid) then -- 跑出强盗区域
    story2:comeBack(objid, areaid)
  end
end

-- 玩家点击方块
function MyStoryHelper:playerClickBlock (objid, blockid, x, y, z)
  -- body
end

-- 玩家点击生物
function MyStoryHelper:playerClickActor (objid, toobjid)
  -- body
end

-- 玩家获得道具
function MyStoryHelper:playerAddItem (objid, itemid, itemnum)
  -- body
  local mainIndex = StoryHelper:getMainStoryIndex()
  if (mainIndex == 1) then -- 剧情一
    if (itemid == MyMap.ITEM.WENYU_PACKAGE_ID) then -- 文羽包裹
      StoryHelper:forward(1, '文羽通知')
    elseif (itemid == MyMap.ITEM.YANGWANLI_PACKAGE_ID) then -- 村长包裹
      StoryHelper:forward(1, '文羽的礼物')
    elseif (itemid == MyMap.ITEM.TOKEN_ID) then -- 风颖城通行令牌
      PlayerHelper:setItemDisableThrow(objid, itemid)
      StoryHelper:forward(1, '村长的礼物')
      story1:finishNoticeEvent(objid)
    end
  elseif (mainIndex == 3) then -- 剧情三
    if (itemid == MyMap.ITEM.GAME_DATA_TALK_WITH_GAO_ID) then
      if (StoryHelper:forward(3, '对话高先生')) then
        BackpackHelper:removeGridItemByItemID(objid, itemid, itemnum) -- 销毁
      end
    elseif (itemid == MyMap.ITEM.GAME_DATA_GET_WEAPON_ID) then
      if (StoryHelper:forward(3, '新生武器')) then
        BackpackHelper:removeGridItemByItemID(objid, itemid, itemnum) -- 销毁
      end
    end
  end
end

-- 玩家使用道具
function MyStoryHelper:playerUseItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家消耗道具
function MyStoryHelper:playerConsumeItem (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家攻击命中
function MyStoryHelper:playerAttackHit (objid, toobjid)
  -- body
end

-- 玩家造成伤害
function MyStoryHelper:playerDamageActor (objid, toobjid, hurtlv)
  -- body
end

-- 玩家击败生物
function MyStoryHelper:playerDefeatActor (playerid, objid)
  -- body
end

-- 玩家受到伤害
function MyStoryHelper:playerBeHurt (objid, toobjid, hurtlv)
  -- body
  local hp = PlayerHelper:getHp(objid)
  if (hp and hp == 1) then -- 重伤
    -- 检测技能是否正在释放
    if (ItemHelper:isDelaySkillUsing(objid, '坠星')) then -- 技能释放中
      FallStarBow:cancelSkill(objid)
      return
    end
    local mainIndex = StoryHelper:getMainStoryIndex()
    local mainProgress = StoryHelper:getMainStoryProgress()
    -- if (mainIndex == 1) then -- 在落叶村受重伤
    --   story1:playerBadHurt(objid)
    if (mainIndex == 2 and mainProgress == 4) then -- 杀强盗受重伤
      story2:playerBadHurt(objid)
    end
  end
end

-- 玩家死亡
function MyStoryHelper:playerDie (objid, toobjid)
  -- body
end

-- 玩家复活
function MyStoryHelper:playerRevive (objid, toobjid)
  -- body
end

-- 玩家选择快捷栏
function MyStoryHelper:playerSelectShortcut (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家快捷栏变化
function MyStoryHelper:playerShortcutChange (objid, toobjid, itemid, itemnum)
  -- body
end

-- 玩家运动状态改变
function MyStoryHelper:playerMotionStateChange (objid, playermotion)
  -- body
end

-- 玩家移动一格
function MyStoryHelper:playerMoveOneBlockSize (objid)
  -- body
end

-- 玩家骑乘
function MyStoryHelper:playerMountActor (objid, toobjid)
  -- body
end

-- 玩家取消骑乘
function MyStoryHelper:playerDismountActor (objid, toobjid)
  -- body
end

-- 聊天输出界面变化
function MyStoryHelper:playerInputContent (objid, content)
  -- body
end

-- 输入字符串
function MyStoryHelper:playerNewInputContent (objid, content)
  -- body
end

-- 按键被按下
function MyStoryHelper:playerInputKeyDown (objid, vkey)
  -- body
end

-- 按键处于按下状态
function MyStoryHelper:playerInputKeyOnPress (objid, vkey)
  -- body
end

-- 按键松开
function MyStoryHelper:playerInputKeyUp (objid, vkey)
  -- body
end

-- 等级发生变化
function MyStoryHelper:playerLevelModelUpgrade (objid, toobjid)
  -- body
end

-- 生物进入区域
function MyStoryHelper:actorEnterArea (objid, areaid)
  -- body
end

-- 生物离开区域
function MyStoryHelper:actorLeaveArea (objid, areaid)
  -- body
  local mainIndex = StoryHelper:getMainStoryIndex()
  local mainProgress = StoryHelper:getMainStoryProgress()
  if (mainIndex == 2 and mainProgress == 4 and areaid == story2.areaid) then
    local actorid = CreatureHelper:getActorID(objid)
    if (actorid == QiangdaoLouluo.actorid or actorid == QiangdaoXiaotoumu.actorid) then
      story2:comeBack(objid, areaid)
    end
  end
end

-- 生物碰撞
function MyStoryHelper:actorCollide (objid, toobjid)
  -- body
end

-- 生物攻击命中
function MyStoryHelper:actorAttackHit (objid, toobjid)
  -- body
end

-- 生物击败目标
function MyStoryHelper:actorBeat (objid, toobjid)
  -- body
end

-- 生物行为改变
function MyStoryHelper:actorChangeMotion (objid, actormotion)
  -- body
end

-- 生物死亡
function MyStoryHelper:actorDie (objid, toobjid)
  -- body
  if (StoryHelper:getMainStoryIndex() == 2) then
    story2:showMessage(objid)
  end
end

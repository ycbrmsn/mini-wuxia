-- 我的剧情工具类
MyStoryHelper = {
  initWoodPos = MyPosition:new(31, 5, 10), -- 游戏开始时的一个标志木头位置
  woodid = 201,
  initPosition = MyPosition:new(29.5, 9.5, 7.5), -- 玩家进入游戏的初始位置
  initPosition3 = MyPosition:new(19.5, 8.5, 605.5), -- 剧情三的初始位置
  outCityPos = MyPosition:new(-37, 7, 457), -- 南门外
}

function MyStoryHelper.init ()
  story1 = Story1:new()
  story2 = Story2:new()
  story3 = Story3:new()
  StoryHelper.setStorys({ story1, story2, story3 })
end

-- 替换初始方块
function MyStoryHelper.replaceInitBlock (pos)
  if (not(BlockHelper.replaceBlock(200, pos.x, pos.y, pos.z))) then
    TimeHelper.callFnAfterSecond(function ()
      MyStoryHelper.replaceInitBlock(pos)
    end, 1)
  end
end

-- 不同玩家给不同的礼物
function MyStoryHelper.diffPersonDiffPresents (player)
  if (player.objid == 807364131) then -- 作者
    BackpackHelper.addItem(player.objid, MyMap.ITEM.PROTECT_GEM_ID, 5)
    BackpackHelper.addItem(player.objid, 4246, 1) -- 慑魂枪
    ChatHelper.sendMsg(player.objid, '欢迎', player:getName(), '，作者额外送你5个',
      ItemHelper.getItemName(MyMap.ITEM.PROTECT_GEM_ID))
  elseif (player.objid == 865147101) then -- 懒懒小朋友
    BackpackHelper.addItem(player.objid, MyMap.ITEM.PROTECT_GEM_ID, 5)
    ChatHelper.sendMsg(player.objid, '欢迎', player:getName(), '小朋友，作者额外送你5个',
      ItemHelper.getItemName(MyMap.ITEM.PROTECT_GEM_ID))
  end
end

-- 击败挖城墙玩家
function MyStoryHelper.beatBreakCityPlayer (player)
  ActorHelper.playAct(player.chooseMap.objid, ActorHelper.ACT.ATTACK)
  TimeHelper.callFnAfterSecond(function ()
    player:enableMove(true)
    ActorHelper.killSelf(player.objid)
    WorldHelper.despawnActor(player.chooseMap.objid)
    for i, v in ipairs(player.destroyBlock) do
      BlockHelper.placeBlock(v.blockid, v.x, v.y, v.z)
    end
    player.destroyBlock = {}
  end, 1)
end

-- 过去几小时，用于睡觉
function MyStoryHelper.addHour (hours)
  if (StoryHelper.check(1, '明日出发')) then
    local hour = TimeHelper.getHour()
    if (hour + hours > 24) then
      StoryHelper.forward(1, '明日出发')
    end
  elseif (StoryHelper.check(1, '今日出发')) then
    if (hour + hours > 7) then
      return false
    end
  end
  TimeHelper.addHour(hours)
  return true
end

-- 事件

-- 世界时间到[n]点
EventHelper.addEvent('atHour', function (hour)
  if (hour == 0) then
    StoryHelper.forward(1, '明日出发')
  elseif (hour == 7) then
    -- LogHelper.debug(StoryHelper.getMainStoryIndex(), '-', StoryHelper.getMainStoryProgress(), '-', #story1.tips)
    -- if (StoryHelper.getMainStoryIndex() == 1 and StoryHelper.getMainStoryProgress() == #story1.tips) then
    if (StoryHelper.forward(1, '今日出发')) then
      story2:goToCollege()
    end
  end
end)

-- 玩家进入游戏
EventHelper.addEvent('playerEnterGame', function (objid)
  local player = PlayerHelper.getPlayer(objid)
  if (PlayerHelper.isMainPlayer(objid)) then -- 本地玩家
    if (not(GameDataHelper.updateStoryData())) then -- 未找到游戏数据文件
      -- 判断是否刚进入游戏，等待1s后检测
      TimeHelper.callFnAfterSecond(function ()
        local blockid = BlockHelper.getBlockID(MyStoryHelper.initWoodPos.x, MyStoryHelper.initWoodPos.y, MyStoryHelper.initWoodPos.z)
        if (blockid and blockid == MyStoryHelper.woodid) then -- 刚进入游戏
          GameDataHelper.updateMainIndex()
          GameDataHelper.updateMainProgress()
          StoryHelper.setLoad(true)
          TimeHelper.setHour(MyMap.CUSTOM.INIT_HOUR)
          player:setPosition(MyStoryHelper.initPosition) -- 初始位置
          PlayerHelper.rotateCamera(objid, ActorHelper.FACE_YAW.NORTH, 0)
          if (not(LogPaper:hasItem(objid))) then -- 没有江湖日志
            LogPaper:newItem(objid, 1, true) -- 江湖日志
            BackpackHelper.addItem(objid, MyMap.ITEM.PROTECT_GEM_ID, 3) -- 给房主三颗守护宝石
            SaveGame:newItem(objid, 1, true) -- 保存游戏
            LoadGame:newItem(objid, 1, true) -- 加载进度
            MyStoryHelper.diffPersonDiffPresents(player)
          end
          -- 3秒后替换掉初始方块
          TimeHelper.callFnAfterSecond(function ()
            MyStoryHelper.replaceInitBlock(MyStoryHelper.initWoodPos)
          end, 3)
        else -- 再次进入游戏
          TimeHelper.callFnAfterSecond(function ()
            StoryHelper.loadTip(objid)
          end, 2)
        end
        StoryHelper.recover() -- 初始化剧情
      end, 1)
    else -- 找到数据文件
      StoryHelper.recover(player) -- 恢复剧情
    end
  else -- 其他玩家
    local hostPlayer = PlayerHelper.getHostPlayer()
    if (hostPlayer) then
      player:setPosition(hostPlayer:getPosition())
    else -- 没有房主
      player:setPosition(MyStoryHelper.initPosition) -- 初始位置
      PlayerHelper.rotateCamera(objid, ActorHelper.FACE_YAW.NORTH, 0)
    end
  end
end)

-- 玩家进入区域
EventHelper.addEvent('playerEnterArea', function (objid, areaid)
  if (story1 and areaid == story1.areaid) then -- 文羽通知事件
    if (StoryHelper.check(1, '闲来无事')) then
      story1:noticeEvent(areaid)
      -- 玩家看文羽两秒
      local player = PlayerHelper.getPlayer(objid)
      TimeHelper.callFnContinueRuns(function ()
        if (player:isActive()) then
          player:lookAt(wenyu.objid)
        end
      end, 2)
    end
  elseif (areaid == MyAreaHelper.playerInHomeAreaId) then -- 主角进入家中
    -- story1:fasterTime()
  elseif (story3 and areaid == story3.startArea) then -- 剧情三开启区域
    if (StoryHelper.forward(2, '临近风颖城')) then
      AreaHelper.destroyArea(areaid)
      story3:comeToCollege()
    end
  else
    local player = PlayerHelper.getPlayer(objid)
    -- 监狱区域
    for i, v in ipairs(MyAreaHelper.prisonAreas) do
      if (areaid == v) then
        local timerid = TimerHelper.doAfterSeconds(function ()
          local pos = player:getMyPosition()
          if (pos) then
            TimerHelper.hideTips({ objid }, timerid)
            player:setPosition(-14.5, pos.y, pos.z)
            TimeHelper.callFnAfterSecond(function ()
              if (not(BackpackHelper.hasItem(player.objid, MyMap.ITEM.TOKEN_ID))) then -- 没有令牌
                local objids = WorldHelper.spawnCreature(-14.5, pos.y, pos.z - 3, guard.actorid, 1)
                if (objids and #objids > 0) then
                  player:enableMove(false, true)
                  CreatureHelper.closeAI(objids[1])
                  ActorHelper.lookAt(objids[1], objid)
                  player:lookAt(objids[1])
                  guard:speakTo(objid, 0, '由于你没有通行令牌，现在跟我出城。')
                  TimeHelper.callFnAfterSecond(function ()
                    player:setPosition(MyStoryHelper.outCityPos)
                    player:enableMove(true, false)
                    WorldHelper.despawnActor(objids[1])
                  end, 2)
                end
              end
            end, 2)
          end
        end, 60)
        TimerHelper.showTips({ objid }, timerid, '剩余出狱时间：')
        break
      end
    end
  end
end)

-- 玩家离开区域
EventHelper.addEvent('playerLeaveArea', function (objid, areaid)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if (mainIndex == 2 and mainProgress == 4 and areaid == story2.areaid) then -- 跑出强盗区域
    story2:comeBack(objid, areaid)
  end
end)

-- 玩家获得道具
EventHelper.addEvent('playerAddItem', function (objid, itemid, itemnum)
  local mainIndex = StoryHelper.getMainStoryIndex()
  if (mainIndex == 1) then -- 剧情一
    if (itemid == MyMap.ITEM.WENYU_PACKAGE_ID) then -- 文羽包裹
      StoryHelper.forward(1, '文羽通知')
      wenyu:doItNow() -- 不再跟随
    elseif (itemid == MyMap.ITEM.YANGWANLI_PACKAGE_ID) then -- 村长包裹
      StoryHelper.forward(1, '文羽的礼物')
    -- elseif (itemid == MyMap.ITEM.TOKEN_ID) then -- 风颖城通行令牌
    --   PlayerHelper.setItemDisableThrow(objid, itemid)
    --   StoryHelper.forward(1, '村长的礼物')
    --   story1:finishNoticeEvent(objid)
    end
  elseif (mainIndex == 3) then -- 剧情三
    if (itemid == MyMap.ITEM.GAME_DATA_TALK_WITH_GAO_ID) then
      if (StoryHelper.forward(3, '对话高先生')) then
        BackpackHelper.removeGridItemByItemID(objid, itemid, itemnum) -- 销毁
      end
    elseif (itemid == MyMap.ITEM.GAME_DATA_GET_WEAPON_ID) then
      if (StoryHelper.forward(3, '新生武器')) then
        BackpackHelper.removeGridItemByItemID(objid, itemid, itemnum) -- 销毁
      end
    end
  end
end)

-- 玩家受到伤害
EventHelper.addEvent('playerBeHurt', function (objid, toobjid, hurtlv)
  local hp = PlayerHelper.getHp(objid)
  if (hp and hp == 1) then -- 重伤
    -- 检测技能是否正在释放
    if (ItemHelper.isDelaySkillUsing(objid, '坠星')) then -- 技能释放中
      FallStarBow:cancelSkill(objid)
      return
    end
    local mainIndex = StoryHelper.getMainStoryIndex()
    local mainProgress = StoryHelper.getMainStoryProgress()
    -- if (mainIndex == 1) then -- 在落叶村受重伤
    --   story1:playerBadHurt(objid)
    if (mainIndex == 2 and mainProgress == 4) then -- 杀强盗受重伤
      story2:playerBadHurt(objid)
    end
  end
end)

-- 生物离开区域
EventHelper.addEvent('actorLeaveArea', function (objid, areaid)
  local mainIndex = StoryHelper.getMainStoryIndex()
  local mainProgress = StoryHelper.getMainStoryProgress()
  if (mainIndex == 2 and mainProgress == 4 and areaid == story2.areaid) then
    local actorid = CreatureHelper.getActorID(objid)
    if (actorid == QiangdaoLouluo.actorid or actorid == QiangdaoXiaotoumu.actorid) then
      story2:comeBack(objid, areaid)
    end
  end
end)

-- 生物死亡
EventHelper.addEvent('actorDie', function (objid, toobjid)
  if (StoryHelper.getMainStoryIndex() == 2) then
    story2:showMessage(objid)
  end
end)

-- 完成方块挖掘
EventHelper.addEvent('blockDigEnd', function (objid, blockid, x, y, z)
  if (blockid == 422 or blockid == 123) then -- 粗制岩石砖 冰块插件
    local pos = ActorHelper.getMyPosition(objid)
    if (pos.x > -117 and pos.x < 45 and pos.z > 471 and pos.z < 633) then -- 风颖城范围
      local player = PlayerHelper.getPlayer(objid)
      table.insert(player.destroyBlock, { blockid = blockid, x = x, y = y, z = z })
      if (player.whichChoose and player.whichChoose == 'breakCity') then
        player.whichChoose = nil
        guard:speakTo(objid, 0, '你还敢挖！！！')
        TimeHelper.callFnAfterSecond(function ()
          MyStoryHelper.beatBreakCityPlayer(player)
        end, 1)
      else
        local pos = AreaHelper.getEmptyPos(player)
        local objids = WorldHelper.spawnCreature(pos.x, pos.y, pos.z, guard.actorid, 1)
        if (objids and #objids > 0) then
          player:enableMove(false, true)
          CreatureHelper.closeAI(objids[1])
          ActorHelper.lookAt(objids[1], objid)
          player:lookAt(objids[1])
          guard:speakTo(objid, 0, '你破坏了城墙，请跟我走一趟。')
          local ws = WaitSeconds:new(2)
          player:thinkSelf(ws:use(), '我要怎么做呢？')
          TimeHelper.callFnAfterSecond(function ()
            ChatHelper.sendMsg(objid, '请选择对应的快捷栏')
            -- ChatHelper.showChooseItems(playerid, { '跟他走', '不跟他走' })
            -- player.whichChoose = 'breakCity'
            MyOptionHelper.showOptions(player, 'breakCity')
            player.chooseMap = { objid = objids[1] }
          end, ws:get())
        end
      end
    end
  end
end)

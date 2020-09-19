-- 我的游戏工具类
MyGameHelper = {}

function MyGameHelper:setGBattleUI ()
  local player = PlayerHelper:getHostPlayer()
  if (player) then
    MusicHelper:stopBGM(player.objid)
    local title, desc, reason = MyGameHelper:getDesc(player)
    UIHelper:setLeftDesc(desc)
    if (reason) then
      UIHelper:setLeftLittleDesc('死亡原因：')
      UIHelper:setRightLittleDesc(reason)
    else
      UIHelper:setLeftLittleDesc('成功通关')
      UIHelper:setRightLittleDesc('等级：', player:getLevel())
    end
    UIHelper:setLeftTitle('获得称号：')
    UIHelper:setRightTitle(title)
  end
  UIHelper:setGBattleUI('result', true)
end

function MyGameHelper:getDesc (player)
  if (player.isWinGame) then
    return '一代大侠', '闯江湖，走遍天下恶尽除'
  else
    local finalBeatBy = player.finalBeatBy
    if (not(finalBeatBy)) then
      return '冒险家', '孰能料，蹦蹦跳跳会死掉', '意外'
    else -- 被生物击败
      if (finalBeatBy == MyMap.ACTOR.DOG_ACTOR_ID) then
        return '战五渣', '难置信，野狗也能要人命', '野狗'
      elseif (finalBeatBy == MyMap.ACTOR.WOLF_ACTOR_ID) then
        return '喂狼者', '真善良，舍去皮囊喂了狼', '恶狼'
      elseif (finalBeatBy == MyMap.ACTOR.OX_ACTOR_ID) then
        return '斗牛逝', '没轻功，依然能够上天空', '狂牛'
      elseif (finalBeatBy == MyMap.ACTOR.QIANGDAO_LOULUO_ACTOR_ID) then
        return '守财奴', '为守财，美好人间又白来', '强盗小喽罗'
      elseif (finalBeatBy == MyMap.ACTOR.QIANGDAO_XIAOTOUMU_ACTOR_ID) then
        return '锤死者', '功夫差，竟被两拳锤趴下', '强盗小头目'
      elseif (finalBeatBy == MyMap.ACTOR.QIANGDAO_DATOUMU_ACTOR_ID) then
        return '无畏者', '胆子大，独闯大营三秒挂', '强盗大头目'
      end
    end
  end
  return '', '', ''
end

-- 事件

-- 开始游戏
function MyGameHelper:startGame ()
  GameHelper:startGame()
  MyBlockHelper:init()
  MyMonsterHelper:init()
  MyAreaHelper:init()
  MyActorHelper:init()
  -- -- body
end

-- 游戏运行时
function MyGameHelper:runGame ()
  GameHelper:runGame()
  -- body
end

-- 结束游戏
function MyGameHelper:endGame ()
  GameHelper:endGame()
  -- body
  MyGameHelper:setGBattleUI()
end

-- 世界时间到[n]点
function MyGameHelper:atHour (hour)
  GameHelper:atHour(hour)
  MyStoryHelper:atHour(hour)
end

-- 世界时间到[n]秒
function MyGameHelper:atSecond (second)
  GameHelper:atSecond(second)
  -- body
  if (second == 1) then
    -- StoryHelper:setMainStoryIndex(2)
    -- StoryHelper:setMainStoryProgress(#story2.tips)
    -- -- StoryHelper:forward(1, #story1.tips)
    -- -- story2:goToCollege()
    -- PlayerHelper:getHostPlayer():setPosition(-18.5, 7.5, 595.5)
    -- yexiaolong:wantDoNothing()
    -- yexiaolong:setPosition(-18.5, 7.5, 595.5)
  end
end

-- 任意计时器发生变化
function MyGameHelper:minitimerChange (timerid, timername)
  GameHelper:minitimerChange(timerid, timername)
  -- body
end
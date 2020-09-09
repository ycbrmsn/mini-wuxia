-- 我的游戏工具类
MyGameHelper = {}

function MyGameHelper:setGBattleUI ()
  local player = PlayerHelper:getHostPlayer()
  if (player) then
    MusicHelper:stopBGM(player.objid)
    local title, desc1, desc2 = MyGameHelper:getDesc(player)
    UIHelper:setLeftDesc(desc1, '#G', player:getName(), '#n', desc2)
    UIHelper:setLeftLittleDesc('玩家等级：', player:getLevel())
    UIHelper:setRightLittleDesc('当前剧情：', StoryHelper:getStory().title)
    UIHelper:setLeftTitle('获得称号：')
    UIHelper:setRightTitle(title)
  end
  UIHelper:setGBattleUI('result', true)
end

function MyGameHelper:getDesc (player)
  if (player.isWinGame) then
    return '一代大侠', '经过一番努力，', '远近闻名于天下'
  else
    local finalBeatBy = player.finalBeatBy
    if (not(finalBeatBy)) then
      return '冒险家', '天有不测风云，', '意外死掉了'
    else -- 被生物击败
      if (finalBeatBy == MyMap.ACTOR.DOG_ACTOR_ID) then
        return '战五渣', '难以置信，', '竟然被野狗给咬死了'
      elseif (finalBeatBy == MyMap.ACTOR.WOLF_ACTOR_ID) then
        return '喂狼者', '真善良，', '一身皮囊喂了恶狼'
      elseif (finalBeatBy == MyMap.ACTOR.OX_ACTOR_ID) then
        return '斗牛逝', '没轻功，', '终靠狂牛上天空'
      elseif (finalBeatBy == MyMap.ACTOR.QIANGDAO_LOULUO_ACTOR_ID) then
        return '守财奴', '为守住钱财，', '将命交给了强盗喽罗'
      elseif (finalBeatBy == MyMap.ACTOR.QIANGDAO_XIAOTOUMU_ACTOR_ID) then
        return '锤死者', '没想到，', '被强盗小头目两拳锤死了'
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
    -- StoryHelper:setMainStoryIndex(1)
    -- StoryHelper:setMainStoryProgress(#story1.tips)
    -- StoryHelper:forward('出发，前往学院')
    -- story2:goToCollege()
    -- PlayerHelper:getHostPlayer():setPosition(224.5, 8.5, 69.5)
  end
end

-- 任意计时器发生变化
function MyGameHelper:minitimerChange (timerid, timername)
  GameHelper:minitimerChange(timerid, timername)
  -- body
end
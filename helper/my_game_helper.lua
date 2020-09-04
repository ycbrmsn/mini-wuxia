-- 我的游戏工具类
MyGameHelper = {}

function MyGameHelper:setGBattleUI ()
  local player = PlayerHelper:getHostPlayer()
  if (player) then
    UIHelper:setGBattleUI('left_desc', player:getName() .. msg .. score)
    UIHelper:setGBattleUI('left_little_desc', '获得金币数：' .. teamScore / 5)
    UIHelper:setGBattleUI('right_little_desc', '总耗时：' .. time)
  end
  UIHelper:setGBattleUI('result', false)
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
end

-- 任意计时器发生变化
function MyGameHelper:minitimerChange (timerid, timername)
  GameHelper:minitimerChange(timerid, timername)
  -- body
end
-- 游戏事件

-- eventobjid, toobjid
local playerEnterGame = function (event)
  local objid = event['eventobjid']
  LogHelper:call(function ()
    MyPlayerHelper:initPlayer(objid)
    -- MyPlayerHelper:getHostPlayer().action:runTo({ { x = 0, y = 7, z = 70 } })
  end)
end

-- eventobjid, toobjid
local playerLeaveGame = function (event)
  -- 从players中清除数据
  MyPlayerHelper:removePlayer(event.eventobjid)
end

-- 无参数
local startGame = function ()
  LogHelper:debug('开始游戏')
  MyBlockHelper:initBlocks()
  initDoorAreas()
end

-- 无参数
local runGame = function ()
  LogHelper:call(function ()
    MyTimeHelper:addFrame()
    MyTimeHelper:runFnFastRuns()
    MyTimeHelper:runFnContinueRuns()
    MonsterHelper:runBosses()
  end)
end

-- 无参数
local endGame = function ()
  LogHelper:debug('结束游戏')
end

-- 参数 hour
local atHour = function (event)
  local hour = event['hour']
  -- LogHelper:info('atHour: ', hour)
  LogHelper:call(function ()
    MyTimeHelper:updateHour(hour)
    MyStoryHelper:run(hour)
    MyActorHelper:atHour(hour)
  end)
end

function initMyActors ()
  PersonHelper:init()
  MyBlockHelper:init()
end

function initDoorAreas ()
  local doors = PositionHelper:getDoorPositions()
  for i, v in ipairs(doors) do
    local areaid = AreaHelper:getAreaByPos(v)
    -- LogHelper:debug('初始化门区域：', areaid)
    table.insert(AreaHelper.allDoorAreas, areaid, v)
  end
end

local atSecond = function (event)
  local second = event['second']
  LogHelper:call(function ()
    MyTimeHelper:doPerSecond(second)
    MyPlayerHelper:updateEveryPlayerPositions()
    MyActorHelper:runActors()
    MyPlayerHelper:runPlayers()

    if (second == 1) then
      initMyActors()
      MonsterHelper:init()
      MyAreaHelper:initAreas()
    end

    -- if (second == 3) then
    --   MyStoryHelper.mainIndex = 2
    --   MyStoryHelper.mainProgress = 1
    --   story2:goToCollege()
    -- end
  end)
  
end

ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], playerEnterGame) -- 玩家进入游戏
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], playerLeaveGame) -- 玩家离开游戏
ScriptSupportEvent:registerEvent([=[Game.Start]=], startGame) -- 开始游戏
ScriptSupportEvent:registerEvent([=[Game.End]=], endGame) -- 结束游戏
ScriptSupportEvent:registerEvent([=[Game.Hour]=], atHour) -- 世界时间到[n]点
ScriptSupportEvent:registerEvent([=[Game.Run]=], runGame) -- 游戏运行时
ScriptSupportEvent:registerEvent([=[Game.RunTime]=], atSecond) -- 世界时间到[n]秒

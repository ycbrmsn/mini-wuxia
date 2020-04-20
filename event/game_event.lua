-- 游戏事件

-- eventobjid, toobjid
local playerEnterGame = function (eventArgs)
  local objid = eventArgs['eventobjid']
  if (type(logPaper) == 'nil') then -- 说明是第一个进入游戏的玩家，即房主，则初始化一些数据
    LogHelper:call(init)
  end
  -- 检测玩家是否有江湖日志，如果没有则放进背包
  if (not(logPaper:hasItem())) then
    logPaper:newItem(objid, 1, true)
  end
  MyPlayerHelper:initPlayer(objid)
end

-- eventobjid, toobjid
local playerLeaveGame = function (eventArgs)
  -- 从players中清除数据
  MyPlayerHelper:removePlayer(eventArgs.eventobjid)
end

-- 无参数
local startGame = function ()
  LogHelper:debug('开始游戏')
  initHours(7)
end

-- 无参数
local runGame = function ()
  MyTimeHelper:runFnFastRuns()
  MyTimeHelper:runFnContinueRuns()
end

-- 无参数
local endGame = function ()
  LogHelper:debug('结束游戏')
end

-- 参数 hour
local atHour = function (eventArgs)
  local hour = eventArgs['hour']
  -- LogHelper:info('atHour: ', hour)
  LogHelper:call(function (p)
    MyTimeHelper:updateHour(p.hour)
    MyStoryHelper:run(p.hour)
    MyActorHelper:atHour(p.hour)
  end, { hour = hour })
end

function init ()
  logPaper = LogPaper:new()
end

function initHours (hour)
  MyTimeHelper:setHour(hour)
end

function initMyActors ()
  wenyu = Wenyu:new()
  jiangfeng = Jiangfeng:new()
  jiangyu = Jiangyu:new()
  wangdali = Wangdali:new()
  miaolan = Miaolan:new()
  yangwanli = Yangwanli:new()
  huaxiaolou = Huaxiaolou:new()
  yexiaolong = Yexiaolong:new()
  local myActors = { jiangfeng, jiangyu, wangdali, miaolan, wenyu, yangwanli, huaxiaolou, yexiaolong }
  for i, v in ipairs(myActors) do
    MyTimeHelper:initActor(v)
    -- LogHelper:debug('创建', v:getName(), '完成')
  end
  -- MyTimeHelper:initActor(miaolan)
  guard = Guard:new()
  guard:init()
  LogHelper:debug('创建人物完成')
  MyStoryHelper:init()
  MyBlockHelper:init()
end

function initDoorAreas ()
  local doors = PositionHelper:getDoorPositions()
  for i, v in ipairs(doors) do
    local areaid = AreaHelper:getAreaByPos(v)
    -- Area:fillBlock(areaid, 200, 1)
    -- LogHelper:debug('初始化门区域：', areaid)
    table.insert(AreaHelper.allDoorAreas, areaid, v)
  end
end

local atSecond = function (eventArgs)
  local second = eventArgs['second']
  LogHelper:call(function (p)
    MyTimeHelper:updateTime(p.second)
    MyTimeHelper:runFnAfterSecond(p.second)
    MyTimeHelper:runFnInterval(p.second)
    MyTimeHelper:runFnLastRuns(p.second)
    MyPlayerHelper:updateEveryPlayerPositions()

    if (p.second == 1) then
      initDoorAreas()
      MyAreaHelper:initAreas()
      initMyActors()
      MonsterHelper:init()
      MyAreaHelper:initShowToastAreas()
      TimerHelper.timerid = TimerHelper:createTimerIfNotExist(MyActor.timername, TimerHelper.timerid)
      TimerHelper:startForwardTimer(TimerHelper.timerid)
    end

    -- if (p.second == 3) then
    --   MyStoryHelper.mainIndex = 2
    --   MyStoryHelper.mainProgress = 1
    --   Story2:goToCollege()
    -- end
  end, { second = second })
  
end

ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], playerEnterGame) -- 玩家进入游戏
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], playerLeaveGame) -- 玩家离开游戏
ScriptSupportEvent:registerEvent([=[Game.Start]=], startGame) -- 开始游戏
ScriptSupportEvent:registerEvent([=[Game.End]=], endGame) -- 结束游戏
ScriptSupportEvent:registerEvent([=[Game.Hour]=], atHour) -- 世界时间到[n]点
ScriptSupportEvent:registerEvent([=[Game.Run]=], runGame) -- 游戏运行时
ScriptSupportEvent:registerEvent([=[Game.RunTime]=], atSecond) -- 世界时间到[n]秒

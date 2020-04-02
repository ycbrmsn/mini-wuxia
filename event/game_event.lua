-- 游戏事件

allPlayers = {}

-- 参数 eventobjid, toobjid
local playerEnterGame = function (eventArgs)
  local objid = eventArgs['eventobjid']
  if (type(logPaper) == 'nil') then -- 说明是第一个进入游戏的玩家，即房主，则初始化一些数据
    LogHelper:call(init)
  end
  -- 检测玩家是否有江湖日志，如果没有则放进背包
  if (not(logPaper:hasItem())) then
    logPaper:newItem(objid, 1, true)
  end
  local nickname = PlayerHelper:getNickname(objid)
  table.insert(allPlayers, { objid = objid, nickname = nickname })
end

-- 参数 eventobjid, toobjid
local playerLeaveGame = function (eventArgs)
  -- Chat:sendSystemMsg('离开游戏')
  local objid = eventArgs['eventobjid']
  -- 从allPlayers中清除数据
  for i, v in ipairs(allPlayers) do
    if (v.objid == objid) then
      table.remove(allPlayers, i)
      break
    end
  end
end

-- 无参数
local startGame = function ()
  LogHelper:debug('开始游戏')
  initHours(7)
end

-- 无参数
local loadGame = function ()
  LogHelper:debug('启动游戏')
end

-- 无参数
local endGame = function ()
  LogHelper:debug('结束游戏')
end

-- 参数 hour
local atHour = function (eventArgs)
  local hour = eventArgs['hour']
  MyActorHelper:atHour(hour)
end

function init ()
  logPaper = LogPaper:new()
  initStoryAreas(logPaper)
end

function initHours (hour)
  WorldHelper:setHours(hour)
end

function initMyActors (hour)
  wenyu = Wenyu:new()
  jiangfeng = Jiangfeng:new()
  jiangyu = Jiangyu:new()
  wangdali = Wangdali:new()
  miaolan = Miaolan:new()
  yangwanli = Yangwanli:new()
  yexiaolong = Yexiaolong:new()
  wenyu:init(hour)
  jiangfeng:init(hour)
  jiangyu:init(hour)
  wangdali:init(hour)
  miaolan:init(hour)
  yangwanli:init(hour)
  yexiaolong:init(hour)
  LogHelper:info('创建人物完成')
end

function initStoryAreas (logPaper)
  if (logPaper.mainIndex == 1) then -- 剧情1
    local areaid = AreaHelper:createAreaRectByRange(myStories[1].posBeg, myStories[1].posEnd)
    myStories[1].areaid = areaid
    -- Area:fillBlock(myStories[1].areaid, 200, 1)
  end
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
  if (eventArgs.second == 1) then
    LogHelper:call(function ()
      initMyActors(7)
      initDoorAreas()
      MyAreaHelper:initAreas()
      TimerHelper.timerid = TimerHelper:createTimerIfNotExist(MyActor.timername, TimerHelper.timerid)
      TimerHelper:startForwardTimer(TimerHelper.timerid)
    end)
  end
  if (eventArgs.second == 2) then
    LogHelper:call(function ()
      
    end)
  end
end

ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], playerEnterGame) -- 玩家进入游戏
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], playerLeaveGame) -- 玩家离开游戏
ScriptSupportEvent:registerEvent([=[Game.Start]=], startGame) -- 开始游戏
ScriptSupportEvent:registerEvent([=[Game.Load]=], loadGame) -- 启动游戏
ScriptSupportEvent:registerEvent([=[Game.End]=], endGame) -- 结束游戏
ScriptSupportEvent:registerEvent([=[Game.Hour]=], atHour) -- 世界时间到[n]点
ScriptSupportEvent:registerEvent([=[Game.RunTime]=], atSecond) -- 世界时间到[n]秒

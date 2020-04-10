-- 游戏事件

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
  MyPlayerHelper:addPlayer(objid)
end

-- 参数 eventobjid, toobjid
local playerLeaveGame = function (eventArgs)
  -- Chat:sendSystemMsg('离开游戏')
  local objid = eventArgs['eventobjid']
  -- 从players中清除数据
  MyPlayerHelper:removePlayer(objid)
end

-- 无参数
local startGame = function ()
  LogHelper:debug('开始游戏')
  initHours(7)
end

-- 无参数
local runGame = function ()
  for k, v in pairs(MyActorHelper.actors) do
    LogHelper:call(function (myActor)
      if (myActor.wants and myActor.wants[1] and myActor.wants[1].style == 'lookAt') then
        if (myActor.wants[1].pos) then
          myActor:lookAt(myActor.wants[1].pos)
        elseif (myActor.wants[1].objid) then
          myActor:lookAt(myActor.wants[1].objid)
        end
      end
    end, v)
  end
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
  LogHelper:debug('初始化文羽完成')
  jiangfeng = Jiangfeng:new()
  LogHelper:debug('初始化江枫完成')
  jiangyu = Jiangyu:new()
  LogHelper:debug('初始化江渔完成')
  wangdali = Wangdali:new()
  LogHelper:debug('初始化王大力完成')
  miaolan = Miaolan:new()
  LogHelper:debug('初始化苗兰完成')
  yangwanli = Yangwanli:new()
  LogHelper:debug('初始化杨万里完成')
  huaxiaolou = Huaxiaolou:new()
  LogHelper:debug('初始化花小楼完成')
  yexiaolong = Yexiaolong:new()
  LogHelper:debug('初始化叶小龙完成')
  local myActors = { wenyu, jiangfeng, jiangyu, wangdali, miaolan, yangwanli, huaxiaolou, yexiaolong }
  for i, v in ipairs(myActors) do
    MyTimeHelper:initActor(v)
    LogHelper:debug('创建', v:getName(), '完成')
  end
  -- MyTimeHelper:initActor(miaolan)
  LogHelper:debug('创建人物完成')
  MyStoryHelper:init()
  -- for i = 1, 2 do
  --   MyTimeHelper:callFnInterval(wenyu.objid, 'speak', function (p)
  --     -- wenyu.action:speakToAllAfterSecond(i, i)
  --     -- MyPlayerHelper:showToast(807364131, i)
  --     MyTimeHelper:setHour(7 + p.time)
  --   end, 3, { time = i })
  -- end
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

    if (p.second == 1) then
      initDoorAreas()
      MyAreaHelper:initAreas()
      initMyActors()
      MonsterHelper:init()
      TimerHelper.timerid = TimerHelper:createTimerIfNotExist(MyActor.timername, TimerHelper.timerid)
      TimerHelper:startForwardTimer(TimerHelper.timerid)
    end

    -- if (p.second == 5) then
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

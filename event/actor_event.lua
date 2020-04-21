-- 生物事件

-- eventobjid, areaid
local actorEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug(objid .. '进入了区域' .. areaid)
  LogHelper:call(function (p)
    MyActorHelper:enterArea(p.objid, p.areaid)
  end, { objid = objid, areaid = areaid })
end

-- eventobjid, areaid
local actorLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug(objid .. '离开了区域' .. areaid)
  LogHelper:call(function (p)
    MyActorHelper:leaveArea(p.objid, p.areaid)
  end, { objid = objid, areaid = areaid })
end

-- eventobjid, toobjid
local actorCollide = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  LogHelper:call(function (p)
    MyActorHelper:actorCollide(p.objid, p.toobjid)
  end, { objid = objid, toobjid = toobjid })
end

-- eventobjid, toobjid
local actorDie = function (eventArgs)
  LogHelper:call(function (p)
    MonsterHelper:actorDie(p.objid, p.toobjid)
    MyStoryHelper:actorDieEvent(p.objid)
  end, { objid = eventArgs.eventobjid, toobjid = eventArgs.toobjid })
end

-- eventobjid, blockid, x, y, z
local blockTrigger = function (eventArgs)
  MyBlockHelper:checkCityGates(eventArgs)
end

-- timerid, timername
local changeTimer = function (eventArgs)
  local timerid = eventArgs['timerid']
  local timername = eventArgs['timername']
  -- LogHelper:debug('timer run')
  LogHelper:call(function (p)
    MyActorHelper:changeTimer(p.timerid, p.timername)
  end, { timerid = timerid, timername = timername })
end

ScriptSupportEvent:registerEvent([=[Actor.AreaIn]=], actorEnterArea) -- 生物进入区域
ScriptSupportEvent:registerEvent([=[Actor.AreaOut]=], actorLeaveArea) -- 生物离开区域
ScriptSupportEvent:registerEvent([=[Actor.Collide]=], actorCollide) -- 生物发生碰撞
ScriptSupportEvent:registerEvent([=[Actor.Die]=], actorDie) -- 生物死亡
ScriptSupportEvent:registerEvent([=[Block.Trigger]=], blockTrigger) -- 方块被触发
ScriptSupportEvent:registerEvent([=[minitimer.change]=], changeTimer) -- 计时器发生变化
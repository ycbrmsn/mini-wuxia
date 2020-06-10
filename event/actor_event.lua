-- 生物事件

-- eventobjid, areaid
local actorEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug(objid .. '进入了区域' .. areaid)
  LogHelper:call(function ()
    MyActorHelper:enterArea(objid, areaid)
  end)
end

-- eventobjid, areaid
local actorLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug(objid .. '离开了区域' .. areaid)
  LogHelper:call(function ()
    MyActorHelper:leaveArea(objid, areaid)
  end)
end

-- eventobjid, toobjid
local actorCollide = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  LogHelper:call(function ()
    MyActorHelper:actorCollide(objid, toobjid)
  end)
end

-- eventobjid, toobjid
local actorDie = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  LogHelper:call(function ()
    MonsterHelper:actorDie(objid, toobjid)
    MyStoryHelper:actorDieEvent(objid)
  end)
end

-- eventobjid, toobjid(opt), blockid(opt), x, y, z
local actorProjectileHit = function (eventArgs)
  local projectileid, toobjid, blockid = eventArgs.eventobjid, eventArgs.toobjid, eventArgs.blockid
  local x, y, z = eventArgs.x, eventArgs.y, eventArgs.z
  LogHelper:call(function ()
    MyItemHelper:projectileHit(projectileid, toobjid, blockid, MyPosition:new(x, y, z))
  end)
end

-- eventobjid, blockid, x, y, z
local blockDigEnd = function (eventArgs)
  LogHelper:call(function ()
    MyBlockHelper:blockDigEnd(eventArgs.eventobjid, eventArgs.blockid, eventArgs.x, eventArgs.y, eventArgs.z)
  end)
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
  LogHelper:call(function ()
    MyActorHelper:changeTimer(timerid, timername)
  end)
end

ScriptSupportEvent:registerEvent([=[Actor.AreaIn]=], actorEnterArea) -- 生物进入区域
ScriptSupportEvent:registerEvent([=[Actor.AreaOut]=], actorLeaveArea) -- 生物离开区域
ScriptSupportEvent:registerEvent([=[Actor.Collide]=], actorCollide) -- 生物发生碰撞
ScriptSupportEvent:registerEvent([=[Actor.Die]=], actorDie) -- 生物死亡
ScriptSupportEvent:registerEvent([=[Actor.Projectile.Hit]=], actorProjectileHit) -- 投掷物击中
ScriptSupportEvent:registerEvent([=[Block.Dig.End]=], blockDigEnd) -- 完成方块挖掘
ScriptSupportEvent:registerEvent([=[Block.Trigger]=], blockTrigger) -- 方块被触发
ScriptSupportEvent:registerEvent([=[minitimer.change]=], changeTimer) -- 计时器发生变化
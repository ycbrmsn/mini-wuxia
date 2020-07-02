-- 生物事件

-- eventobjid, areaid
local actorEnterArea = function (event)
  local objid = event['eventobjid']
  local areaid = event['areaid']
  -- LogHelper:debug(objid .. '进入了区域' .. areaid)
  LogHelper:call(function ()
    MyActorHelper:enterArea(objid, areaid)
  end)
end

-- eventobjid, areaid
local actorLeaveArea = function (event)
  local objid = event['eventobjid']
  local areaid = event['areaid']
  -- LogHelper:debug(objid .. '离开了区域' .. areaid)
  LogHelper:call(function ()
    MyActorHelper:leaveArea(objid, areaid)
  end)
end

-- eventobjid, toobjid
local actorCollide = function (event)
  local objid = event['eventobjid']
  local toobjid = event['toobjid']
  LogHelper:call(function ()
    MyActorHelper:actorCollide(objid, toobjid)
  end)
end

-- eventobjid, toobjid
local actorAttackHit = function (event)
  LogHelper:call(function ()
    MyActorHelper:actorAttackHit(event.eventobjid, event.toobjid)
  end)
end

-- eventobjid, actormotion
local actorChangeMotion = function (event)
  LogHelper:call(function ()
    MyActorHelper:actorDie(event['eventobjid'], event['actormotion'])
  end)
end

-- eventobjid, toobjid
local actorDie = function (event)
  local objid = event['eventobjid']
  local toobjid = event['toobjid']
  LogHelper:call(function ()
    MonsterHelper:actorDie(objid, toobjid)
    MyStoryHelper:actorDieEvent(objid)
  end)
end

-- eventobjid, toobjid(opt), blockid(opt), x, y, z
local actorProjectileHit = function (event)
  local projectileid, toobjid, blockid = event.eventobjid, event.toobjid, event.blockid
  local x, y, z = event.x, event.y, event.z
  LogHelper:call(function ()
    MyItemHelper:projectileHit(projectileid, toobjid, blockid, MyPosition:new(x, y, z))
  end)
end

-- eventobjid, blockid, x, y, z
local blockDigEnd = function (event)
  LogHelper:call(function ()
    MyBlockHelper:blockDigEnd(event.eventobjid, event.blockid, event.x, event.y, event.z)
  end)
end

-- eventobjid, blockid, x, y, z
local blockTrigger = function (event)
  MyBlockHelper:checkCityGates(event)
end

-- timerid, timername
local changeTimer = function (event)
  local timerid = event['timerid']
  local timername = event['timername']
  -- LogHelper:debug('timer run')
  LogHelper:call(function ()
    MyActorHelper:changeTimer(timerid, timername)
  end)
end

ScriptSupportEvent:registerEvent([=[Actor.AreaIn]=], actorEnterArea) -- 生物进入区域
ScriptSupportEvent:registerEvent([=[Actor.AreaOut]=], actorLeaveArea) -- 生物离开区域
ScriptSupportEvent:registerEvent([=[Actor.Collide]=], actorCollide) -- 生物发生碰撞
ScriptSupportEvent:registerEvent([=[Actor.AttackHit]=], actorAttackHit) -- 生物攻击命中
ScriptSupportEvent:registerEvent([=[Actor.Die]=], actorDie) -- 生物死亡
ScriptSupportEvent:registerEvent([=[Actor.ChangeMotion]=], actorChangeMotion) -- 生物行为状态变更
ScriptSupportEvent:registerEvent([=[Actor.Projectile.Hit]=], actorProjectileHit) -- 投掷物击中
ScriptSupportEvent:registerEvent([=[Block.Dig.End]=], blockDigEnd) -- 完成方块挖掘
ScriptSupportEvent:registerEvent([=[Block.Trigger]=], blockTrigger) -- 方块被触发
-- ScriptSupportEvent:registerEvent([=[minitimer.change]=], changeTimer) -- 计时器发生变化
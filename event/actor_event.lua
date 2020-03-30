-- 生物事件

-- 参数 eventobjid, areaid
local actorEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug(objid .. '进入了区域' .. areaid)
  MyActorHelper:enterArea(objid, areaid)
end

-- 参数 eventobjid, areaid
local actorLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug(objid .. '离开了区域' .. areaid)
  MyActorHelper:leaveArea(objid, areaid)
end

-- 参数 eventobjid, toobjid
local actorCollide = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  local actor1 = MyActorHelper:getActorByObjid(objid)
  if (actor1) then -- 生物是特定生物
    if (ActorHelper:isPlayer(toobjid)) then -- 是玩家
      actor1:wantStayForAWhile()
    else
      local actor2 = MyActorHelper:getActorByObjid(toobjid)
      if (actor2) then
        -- 先简单处理为actorid小的停下来
        if (actor1.actorid < actor2.actorid) then
          actor1:wantStayForAWhile()
        else
          actor2:wantStayForAWhile()
        end
      end
    end
  end
end

-- 参数 timerid, timername
local changeTimer = function (eventArgs)
  local timerid = eventArgs['timerid']
  local timername = eventArgs['timername']
  -- LogHelper:debug('timer run')
  MyActorHelper:changeTimer(timerid, timername)
end

ScriptSupportEvent:registerEvent([=[Actor.AreaIn]=], actorEnterArea) -- 生物进入区域
ScriptSupportEvent:registerEvent([=[Actor.AreaOut]=], actorLeaveArea) -- 生物离开区域
ScriptSupportEvent:registerEvent([=[Actor.Collide]=], actorCollide) -- 生物发生碰撞
ScriptSupportEvent:registerEvent([=[minitimer.change]=], changeTimer) -- 计时器发生变化

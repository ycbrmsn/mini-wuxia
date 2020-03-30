-- 玩家事件

-- 参数 eventobjid, areaid
local playerEnterArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug('玩家进入区域' .. areaid)
  if (areaid == myStories[1].areaid) then -- 文羽通知事件
    AreaHelper:destroyArea(areaid)
    -- LogHelper:debug('玩家进入区域' .. areaid .. ',然后销毁' .. myStories[1].createPos.x)
    wenyu:setPosition(myStories[1].createPos.x, myStories[1].createPos.y, myStories[1].createPos.z)
    -- Chat:sendSystemMsg('生物创建成功')
    wenyu:wantMove({ myStories[1].movePos })
    local content = StringHelper:join(allPlayers, '、', 'nickname')
    local subject = '你'
    if (#allPlayers > 1) then 
      subject = '你们'
    end
    content = content .. '，' .. subject .. '在家吗？我有一个好消息要告诉' .. subject .. '。'
    wenyu.action:speak(content)
  end
end

-- 参数 eventobjid, areaid
local playerLeaveArea = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local areaid = eventArgs['areaid']
  -- LogHelper:debug('玩家离开区域' .. areaid)
end

-- 参数 eventobjid, blockid, x, y, z
local clickBlock = function (eventArgs)
  -- LogHelper:debug('点击方块')
  -- local data = BlockHelper:getBlockData(eventArgs.x, eventArgs.y, eventArgs.z)
  -- LogHelper:debug('men' .. data)

  -- LogHelper:debug('销毁江枫')
  ActorHelper:clearActorWithId(yexiaolong.actorid)

  -- jiangfeng:newActor(eventArgs.x, eventArgs.y, eventArgs.z, true)
  -- jiangfeng:wantMove(PositionHelper:getJiangfengMovetoPatrolPositions())
  -- jiangfeng:wantPatrol(PositionHelper:getJiangfengPatrolPositions())
  

  -- jiangfeng:wantMove(PositionHelper:getJiangfengMovetoPatrolPositions())
  -- jiangfeng:nextWantPatrol(PositionHelper:getJiangfengPatrolPositions())

  -- LogHelper:debug('MyActorActionHelper: ' .. type(MyActorActionHelper))
  -- LogHelper:debug('PositionHelper: ' .. type(PositionHelper))


  -- CreatureHelper:setAIActive(jiangfeng.objid, false)  

  -- ActorHelper:tryNavigationToPos (jiangfeng.objid, eventArgs.x, eventArgs.y, eventArgs.z, true)
  
  -- if (wenyu:playAct(100103)) then
  --   LogHelper:debug('动作成功')
  -- else
  --   LogHelper:debug('动作失败')
  -- end
end

-- 参数 eventobjid toobjid itemid itemnum
local playerUseItem = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local itemid = eventArgs['itemid']
  if(itemid == logPaper.id) then -- 如果使用江湖日志，则显示日志内容
    logPaper:showContent(objid)
  end
end

-- 参数 eventobjid, toobjid
local playerClickActor = function (eventArgs)
  local objid = eventArgs['eventobjid']
  local toobjid = eventArgs['toobjid']
  MyActorHelper:playerClickActor(objid, toobjid)
end

ScriptSupportEvent:registerEvent([=[Player.AreaIn]=], playerEnterArea) -- 玩家进入区域
ScriptSupportEvent:registerEvent([=[Player.AreaOut]=], playerLeaveArea) -- 玩家离开区域
ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=], clickBlock) -- 点击方块
ScriptSupportEvent:registerEvent([=[Player.UseItem]=], playerUseItem) -- 玩家使用物品
ScriptSupportEvent:registerEvent([=[Player.ClickActor]=], playerClickActor) -- 玩家点击生物

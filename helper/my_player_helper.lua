-- 我的玩家工具类
MyPlayerHelper = {
  players = {}
}

function MyPlayerHelper:addPlayer (objid)
  local player = MyPlayer:new(objid)
  table.insert(self:getAllPlayers(), player)
  return player
end

function MyPlayerHelper:removePlayer (objid)
  for i, v in ipairs(self:getAllPlayers()) do
    if (v.objid == objid) then
      table.remove(self:getAllPlayers(), i)
      break
    end
  end
end

function MyPlayerHelper:getPlayer (objid)
  for i, v in ipairs(self:getAllPlayers()) do
    if (v.objid == objid) then
      return v
    end
  end
  return nil
end

function MyPlayerHelper:getHostPlayer ()
  return self:getAllPlayers()[1]
end

function MyPlayerHelper:initPlayer (objid)
  PlayerHelper:setPlayerEnableBeKilled(objid, false)
  local player = self:addPlayer(objid)
  local hostPlayer = self:getHostPlayer()
  if (player == hostPlayer) then
    player:setPosition(29.5, 9.5, 7.5)
    PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.NORTH, 0)
  else
    player:setPosition(hostPlayer:getPosition())
  end
end

-- 显示飘窗信息
function MyPlayerHelper:showToast (objid, ...)
  local info = StringHelper:concat(...)
  MyTimeHelper:callFnInterval(objid, 'toast', function (p)
    PlayerHelper:notifyGameInfo2Self(p.objid, p.info)
  end, 2, { info = info })
end

-- 玩家攻击命中
function MyPlayerHelper:playerAttackHit (objid, toobjid)
  local itemid = PlayerHelper:getCurToolID(objid)
  local item = MyItemHelper:getItem(itemid)
  if (item) then
    item:attackHit(objid, toobjid)
    self:showActorHp(objid, toobjid)
  end
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid)
  local key = self:generateDamageKey(objid, toobjid)
  MyTimeHelper:setFrameInfo(key, true)
  self:showActorHp(objid, toobjid)
end

-- 玩家击败生物
function MyPlayerHelper:playerDefeatActor (playerid, objid)
  local exp = MonsterHelper:getExp(playerid, objid)
  local player = self:getPlayer(playerid)
  player:gainExp(exp)
end

function MyPlayerHelper:generateDamageKey (objid, toobjid)
  return objid .. 'damage' .. toobjid
end

function MyPlayerHelper:showActorHp (objid, toobjid)
  local actorname, hp
  if (ActorHelper:isPlayer(toobjid)) then -- 生物是玩家
    local player = MyPlayerHelper:getPlayer(toobjid)
    actorname = player:getName()
    hp = PlayerHelper:getHp(toobjid)
  else
    actorname = CreatureHelper:getActorName(toobjid)
    hp = CreatureHelper:getHp(toobjid)
  end

  local t = 'showActorHp' .. toobjid
  MyTimeHelper:delFnFastRuns(t)
  MyTimeHelper:callFnFastRuns(function ()
    if (hp and hp <= 0) then
      self:showToast(objid, StringHelper:concat(actorname, '已死亡'))
    else
      hp = math.ceil(hp)
      self:showToast(objid, StringHelper:concat(actorname, '剩余生命：', hp))
    end
  end, 0.1, t)
end

function MyPlayerHelper:getAllPlayers ()
  return self.players
end

function MyPlayerHelper:getAllPlayerNames ()
  local names = {}
  for i, v in ipairs(self:getAllPlayers()) do
    table.insert(names, v:getName())
  end
  return names
end

function MyPlayerHelper:everyPlayerDoSomeThing (f, afterSeconds)
  if (not(f)) then
    return
  end
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function ()
      for i, v in ipairs(self:getAllPlayers()) do
        f(v)
      end
    end, afterSeconds)
  else
    for i, v in ipairs(self:getAllPlayers()) do
      f(v)
    end
  end
end

function MyPlayerHelper:updateEveryPlayerPositions ()
  self:everyPlayerDoSomeThing(function (player)
    player:updatePositions()
  end)
end

function MyPlayerHelper:setEveryPlayerPosition (x, y, z, afterSeconds)
  self:everyPlayerDoSomeThing(function (player)
    player:setPosition(x, y, z)
  end, afterSeconds)
end

function MyPlayerHelper:everyPlayerSpeakAfterSecond (second, ...)
  for i, v in ipairs(self:getAllPlayers()) do
    v.action:speakAfterSecond(v.objid, second, ...)
  end
end

function MyPlayerHelper:everyPlayerSpeakToAllAfterSecond (second, ...)
  for i, v in ipairs(self:getAllPlayers()) do
    v.action:speakToAllAfterSecond(second, ...)
  end
end

function MyPlayerHelper:everyPlayerSpeakInHeartAfterSecond (second, ...)
  for i, v in ipairs(self:getAllPlayers()) do
    v.action:speakInHeartAfterSecond(v.objid, second, ...)
  end
end

function MyPlayerHelper:everyPlayerNotify (info, afterSeconds)
  self:everyPlayerDoSomeThing(function (player)
    PlayerHelper:notifyGameInfo2Self(player.objid, info)
  end, afterSeconds)
end

function MyPlayerHelper:everyPlayerEnableMove (enable, afterSeconds)
  self:everyPlayerDoSomeThing(function (player)
    player:enableMove(enable, true)
  end, afterSeconds)
end

function MyPlayerHelper:everyPlayerRunTo (positions, callback, param, afterSeconds)
  self:everyPlayerDoSomeThing(function (player)
    player.action:runTo(positions, callback, param)
  end, afterSeconds)
end

function MyPlayerHelper:everyPlayerAddBuff(buffid, bufflv, customticks, afterSeconds)
  self:everyPlayerDoSomeThing(function (player)
    ActorHelper:addBuff(player.objid, buffid, bufflv, customticks)
  end, afterSeconds)
end

function MyPlayerHelper:changeViewMode (objid, viewmode, islock)
  viewmode = viewmode or VIEWPORTTYPE.BACKVIEW
  if (not(objid)) then
    self:everyPlayerDoSomeThing(function (p)
      PlayerHelper:changeViewMode(p.objid, viewmode, islock)
    end)
  elseif (type(objid) == 'number') then
    PlayerHelper:changeViewMode(objid, viewmode, islock)
  else
    for i, v in ipairs(objid) do
      PlayerHelper:changeViewMode(v, viewmode, islock)
    end
  end
end
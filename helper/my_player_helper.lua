-- 我的玩家工具类
MyPlayerHelper = {
  players = {}
}

function MyPlayerHelper:addPlayer (objid)
  table.insert(self:getAllPlayers(), MyPlayer:new(objid))
end

function MyPlayerHelper:removePlayer (objid)
  for i, v in ipairs(self:getAllPlayers()) do
    if (v.objid == objid) then
      table.remove(self:getAllPlayers(), i)
      break
    end
  end
end

-- 显示飘窗信息
function MyPlayerHelper:showToast (objid, info)
  MyTimeHelper:runFnInterval(objid, 'toast', function (p)
    PlayerHelper:notifyGameInfo2Self(p.objid, p.info)
  end, 3, { info = info })
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid)
  local actorname = CreatureHelper:getActorName(toobjid)
  local hp = CreatureHelper:getHp(toobjid)
  if (hp and hp <= 0) then
    self:showToast(objid, StringHelper:concat(actorname, '已死亡'))
  else
    self:showToast(objid, StringHelper:concat(actorname, '剩余生命：', hp))
  end
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

function MyPlayerHelper:setEveryPlayerPosition (x, y, z)
  for i, v in ipairs(self:getAllPlayers()) do
    v:setPosition(x, y, z)
  end
end

function MyPlayerHelper:everyPlayerSpeakToAllAfterSecond (second, ...)
  for i, v in ipairs(self:getAllPlayers()) do
    v.action:speakToAllAfterSecond(second, ...)
  end
end
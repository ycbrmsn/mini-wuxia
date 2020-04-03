-- 我的玩家工具类
MyPlayerHelper = {}

function MyPlayerHelper:playerDamageActor (objid, toobjid)
  local actorname = CreatureHelper:getActorName(toobjid)
  local hp = CreatureHelper:getHp(toobjid)
  if (hp and hp <= 0) then
    PlayerHelper:notifyGameInfo2Self(objid, StringHelper:concat(actorname, '已死亡'))
  else
    PlayerHelper:notifyGameInfo2Self(objid, StringHelper:concat(actorname, '剩余生命：', hp))
  end
end
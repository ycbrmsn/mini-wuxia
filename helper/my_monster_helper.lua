-- 我的怪物工具类
MyMonsterHelper = {}

-- 初始化
function MyMonsterHelper:init ()
  qiangdaoDatoumu = QiangdaoDatoumu:new()
  qiangdaoXiaotoumu = QiangdaoXiaotoumu:new()
  qiangdaoLouluo = QiangdaoLouluo:new()
  dog = Dog:new()
  wolf = Wolf:new()
  ox = Ox:new()
  guard = Guard:new()
  guard:init()
  jianshibing = Pantaojianshibing:new()
  gongshibing = Pantaogongshibing:new()
  local monsterModels = { qiangdaoDatoumu, qiangdaoXiaotoumu, qiangdaoLouluo, dog, wolf, ox,
    jianshibing, gongshibing }
  MonsterHelper:init(monsterModels)
end

function MyMonsterHelper:getMonsterModel (objid)
  local actorid = CreatureHelper:getActorID(objid)
  if (actorid) then
    for i, v in ipairs(MonsterHelper:getMonsterModels()) do
      if (v.actorid == actorid) then
        return v
      end
    end
  end
  return nil
end
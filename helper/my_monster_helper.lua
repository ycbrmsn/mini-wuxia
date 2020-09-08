-- 我的怪物工具类
MyMonsterHelper = {}

-- 初始化
function MyMonsterHelper:init ()
  qiangdaoXiaotoumu = QiangdaoXiaotoumu:new()
  qiangdaoLouluo = QiangdaoLouluo:new()
  dog = Dog:new()
  wolf = Wolf:new()
  ox = Ox:new()
  guard = Guard:new()
  guard:init()
  local monsterModels = { qiangdaoXiaotoumu, qiangdaoLouluo, dog, wolf, ox }
  MonsterHelper:init(monsterModels)
end
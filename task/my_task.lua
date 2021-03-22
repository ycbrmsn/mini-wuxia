-- 我的任务类

-- 砍树任务
KanshuTask = BaseTask:new({
  id = 10000,
  name = '采集落叶松木',
  itemid = MyMap.ITEM.MISSION_KANSHU,
  desc = '收集5个落叶松木，交给',
  appendDesc = { 'desc', 'actorname', '。' },
  category = 2, -- 交付道具
  -- actorid = MyMap.ACTOR.YANGWANLI_ACTOR_ID, -- 交付NPC
  itemInfos = {
    { itemid = 201, num = 5 }, -- 落叶松木5个
  },
  rewards = {
    TaskReward:new({
      desc = '获得铜板数枚',
      category = 1,
      itemid = MyMap.ITEM.COIN_ID,
      num = 5,
    }),
  },
})

-- -- 万仙剑任务
-- WanTask = BaseTask:new({
--   name = '万仙剑',
--   desc = '从屋顶上采集一节竹子，交给',
--   category = 2, -- 交付道具
--   -- actorid = MyMap.ACTOR.YEXIAOLONG_ACTOR_ID, -- 交付NPC
--   itemInfos = {
--     { itemid = 251, num = 1 }, -- 竹子一节
--   },
--   rewards = {
--     TaskReward:new({
--       desc = '获得万仙剑一柄',
--       category = 1,
--       itemid = MyWeaponAttr.tenThousandsSword.levelIds[1],
--       num = 1,
--     }),
--   },
-- })

-- function WanTask:new (taskid, actorid, actorname)
--   local desc = self.desc .. actorname .. '。'
--   local o = {
--     id = taskid,
--     actorid = actorid,
--     desc = desc,
--   }
--   self.__index = self
--   setmetatable(o, self)
--   return o
-- end

-- -- 回仙剑任务
-- HuiTask = BaseTask:new({
--   name = '回仙剑',
--   desc = '去虚岩谷击败5只幽风之狼，然后向',
--   category = 1, -- 击败生物
--   -- actorid = MyMap.ACTOR.YEXIAOLONG_ACTOR_ID, -- 交付NPC
--   beatInfos = {
--     { actorid = MyMap.ACTOR.WOLF_ACTOR_ID, actorname = '幽风之狼', num = 5, curnum = 0 }, -- 幽风之狼5只
--   },
--   rewards = {
--     TaskReward:new({
--       desc = '获得回仙剑一柄',
--       category = 1,
--       itemid = MyWeaponAttr.huixianSword.levelIds[1],
--       num = 1,
--     }),
--   },
-- })

-- function HuiTask:new (taskid, actorid, actorname)
--   local desc = self.desc .. actorname .. '交付。'
--   local o = {
--     id = taskid,
--     actorid = actorid,
--     desc = desc,
--   }
--   self.__index = self
--   setmetatable(o, self)
--   return o
-- end

-- -- 气仙剑任务
-- QiTask = BaseTask:new({
--   name = '气仙剑',
--   desc = '击败狂浪之牛收集兽骨，交给',
--   category = 2, -- 交付道具
--   -- actorid = MyMap.ACTOR.YEXIAOLONG_ACTOR_ID, -- 交付NPC
--   itemInfos = {
--     { itemid = MyMap.ITEM.ANIMAL_BONE_ID, num = 5 }, -- 兽骨5根
--   },
--   rewards = {
--     TaskReward:new({
--       desc = '获得气仙剑一柄',
--       category = 1,
--       itemid = MyWeaponAttr.vitalqiSword.levelIds[1],
--       num = 1,
--     }),
--   },
-- })

-- function QiTask:new (taskid, actorid, actorname)
--   local desc = self.desc .. actorname .. '。'
--   local o = {
--     id = taskid,
--     actorid = actorid,
--     desc = desc,
--   }
--   self.__index = self
--   setmetatable(o, self)
--   return o
-- end

-- -- 乱仙剑任务
-- LuanTask = BaseTask:new({
--   name = '乱仙剑',
--   desc = '击败任意生物收集苹果，交给',
--   category = 2, -- 交付道具
--   -- actorid = MyMap.ACTOR.YEXIAOLONG_ACTOR_ID, -- 交付NPC
--   itemInfos = {
--     { itemid = MyMap.ITEM.APPLE_ID, num = 6 }, -- 苹果6个
--   },
--   rewards = {
--     TaskReward:new({
--       desc = '获得乱仙剑一柄',
--       category = 1,
--       itemid = MyWeaponAttr.luanSword.levelIds[1],
--       num = 1,
--     }),
--   },
-- })

-- function LuanTask:new (taskid, actorid, actorname)
--   local desc = self.desc .. actorname .. '。'
--   local o = {
--     id = taskid,
--     actorid = actorid,
--     desc = desc,
--   }
--   self.__index = self
--   setmetatable(o, self)
--   return o
-- end

-- -- 瞬仙剑任务
-- ShunTask = BaseTask:new({
--   name = '瞬仙剑',
--   desc = '击败任意生物收集苹果，交给',
--   category = 2, -- 交付道具
--   -- actorid = MyMap.ACTOR.YEXIAOLONG_ACTOR_ID, -- 交付NPC
--   itemInfos = {
--     { itemid = MyMap.ITEM.APPLE_ID, num = 6 }, -- 苹果6个
--   },
--   rewards = {
--     TaskReward:new({
--       desc = '获得瞬仙剑一柄',
--       category = 1,
--       itemid = MyWeaponAttr.shunSword.levelIds[1],
--       num = 1,
--     }),
--   },
-- })

-- function ShunTask:new (taskid, actorid, actorname)
--   local desc = self.desc .. actorname .. '。'
--   local o = {
--     id = taskid,
--     actorid = actorid,
--     desc = desc,
--   }
--   self.__index = self
--   setmetatable(o, self)
--   return o
-- end